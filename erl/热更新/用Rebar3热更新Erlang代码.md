在本文中我将探讨为了在生产环境里获得高可用性的关键特性：代码热更新。下面是我给不熟悉代码热更新的同学关于这个概念的正式定义：

代码热更新就是一门给正在飞奔的汽车换引擎的艺术。

简而言之，它的目的就是不停止服务的情况下用新的代码替换正在运行的代码。现在我们明白了代码热更新是什么了，那么让我们尝试着看看在Erlang里如何做到代码热更新。

我们将创建一个样例项目，然后学习如何来做代码热更新。这个项目的代码我已经放在这里。让我们用rebar3来创建一个模版项目。

1
$ rebar3 new release nine9s
现在我们在我们的rebar.config文件里增加cowboy和lager为依赖。

1
2
3
4
{deps, [
	{lager, {git, "git://github.com/basho/lager.git", {tag, "2.1.1"}}},
	{cowboy, {git, "https://github.com/ninenines/cowboy.git", {tag, "2.0.0-pre.1"}}}
]}.
为了更加真实的体验，请按如下修改我们的rebar.config。

1
2
3
4
5
6
7
8
9
{relx, [
		{release, {'nine9s', "0.1.0"}, ['nine9s', sasl]},
		{sys_config, "./config/sys.config"},
		{vm_args, "./config/vm.args"},
		{dev_mode, false},
		{include_erts, true},
		{extended_start_script, true}
	]
}.
你可能想知道这个“nine9s”应用将会做些什么？我的想法是先让这个应用做成一个hello world的web服务，然后再热更新它的代码。修改你的nine9s_app.erl文件以便让start/2看起来像下面一样：

1
2
3
4
5
6
7
8
9
start(_StartType, _StartArgs) ->
 Dispatch = cowboy_router:compile(
                                  [{‘_’, [
                                          {“/”, default_handler, []}
                                         ]}
                                  ]),
 {ok, _} = cowboy:start_http(http, 10, [{port, 9090}],
 [{env, [{dispatch, Dispatch}]}]),
 ‘nine9s_sup’:start_link().
现在我们创建一个模块，它叫做default_handler.erl。

1
2
3
4
5
6
7
-module(default_handler).
-export([init/2]).
init(Req, Opts) ->
    Req2 = cowboy_req:reply(200, [ {<<”content-type">>,
                                    <<”text/plain”>>} ],
                            <<”Hello world!”>>, Req),
    {ok, Req2, Opts}.
接下来，我们编译并运行这个应用。

1
2
$ rebar3 compile && rebar3 release
$ _build/default/rel/nine9s/bin/nine9s-0.1.0 console
现在你已经运行了你的应用，你可以浏览http://localhost:9090来验证一下。请保持这个应用一直运行，因为我们将创建这个应用的一个新版本并且尝试在线进行代码热更新。

上述代码在项目的0.1.0分支里。

我们开始添加一些新的特性到我们的项目里，这样将形成我们项目的0.2.0版本，然后我们将尝试在运行着的0.1.0版本上在线进行代码热更新。版本0.2.0的代码在项目的0.2.0分支。

我们想统计我们的default_handler已经响应的请求数。这个很好解决，我们创建一个模块state_handler.erl，它是一个gen_server，它将存储default_handler.erl被调用的次数。

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
-module(state_handler).
-behaviour(gen_server).
%% API functions
-export([hello_world/0,
         get_hello_world_count/0,
         start_link/0]).
%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).
-record(state, {count = 0}).
%%%==========================================================
%%% API functions
%%%==========================================================
hello_world() ->
    gen_server:cast(?MODULE, hello_world).
get_hello_world_count() ->
    gen_server:call(?MODULE, hello_world_count).
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
%%%===========================================================
%%% callback functions
%%%===========================================================
init([]) ->
    {ok, #state{}}.
handle_call(hello_world_count, _From, State) ->
    {reply, State#state.count, State};
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.
handle_cast(hello_world, State) ->
    Count = State#state.count,
    {noreply, State#state{count = Count + 1}};
handle_cast(_Msg, State) ->
    {noreply, State}.
handle_info(_Info, State) ->
    {noreply, State}.
terminate(_Reason, _State) ->
    ok.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
我们修改我们的default_handler.erl，以便每次它接收到请求的时候就通知state_handler。

1
2
3
4
5
6
7
8
-module(default_handler).
-export([init/2]).
init(Req, Opts) ->
    state_handler:hello_world(),
    Req2 = cowboy_req:reply(200, [ {<<”content-type”>>,
                                 <<”text/plain”>>} ],
                         <<”Hello world 2 !”>>, Req),
    {ok, Req2, Opts}.
我们的state_handler将是nine9s_sup监督者下的一个工作进程。

1
2
3
4
5
6
7
8
9
10
11
-module(‘nine9s_sup’).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).
-define(SERVER, ?MODULE).
-define(CHILD(Id, Mod, Args, Restart, Type), {Id, {Mod, start_link, Args}, Restart, 60000, Type, [Mod]}).
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).
init([]) ->
    State_Handler = ?CHILD(state_handler, state_handler, [], transient, worker),
    {ok, { {one_for_all, 0, 1}, [State_Handler]} }.
既然我们已经记录了default_handler的访问次数，我们就想有一个cowboy的路由来给出当前的访问次数，所以我们修改nine9s_sup.erl。

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
-module(‘nine9s_app’).
-behaviour(application).
%% Application callbacks
-export([start/2
         ,stop/1]).
-export([set_routes_new/0
        ,set_routes_old/0 ]).
start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{‘_’, get_new_routes()}]),
    {ok, _} = cowboy:start_http(http, 10, [{port, 9090}],
    [{env, [{dispatch, Dispatch}]}]),
    ‘nine9s_sup’:start_link().
stop(_State) -> ok.
get_new_routes() ->
    [{“/count”, count_handler, []}] ++ get_old_routes().
get_old_routes() ->
    [{“/”, default_handler, []}].
set_routes_new() ->
    CompileRoutes = cowboy_router:compile([{‘_’, get_new_routes() }]),
    cowboy:set_env(http, dispatch, CompileRoutes).
set_routes_old() ->
    CompileRoutes = cowboy_router:compile([{‘_’, get_old_routes() }]),
    cowboy:set_env(http, dispatch, CompileRoutes).
请注意，我们把路由分成两部分，一部分是版本0.1.0里就有的，也就是老路由，还有一部分就是新路由。函数set_routes_new/0和set_routes_old/0我们将在后面解释。

下述代码是count_handler模块，就是处理路由 “/count”的模块。

1
2
3
4
5
6
7
8
9
-module(count_handler).
-export([init/2]).
init(Req, Opts) ->
    Count = state_handler:get_hello_world_count(),
    BCount = integer_to_binary(Count),
    Req2 = cowboy_req:reply(200, [ {<<”content-type”>>,
                                 <<”text/plain”>>} ],
                         BCount, Req),
    {ok, Req2, Opts}.
最后，我们将修改在nine9s.app.src和rebar.config里的版本数字。版本0.2.0的特性就完成了。现在我们将尝试将正在运行的0.1.0版本升级到版本0.2.0。

为了升级到新的版本，我们需要创建一个appup文件，也就是nine9s.app.src文件，它描述了如何从版本0.1.0升级到0.2.0。

1
2
3
4
{"vsn in app.src",
    [ {"upgrade from vsn", Instructions1}],
    [ {"downgrade to vsn", Instructions2}]
}
appup文件是一个三元素组成的元组文件。第一个元素是和.app.src文件里一样的版本号（也就是当前版本）。第二个元素是一个元组列表，它的第一个元素是将要被升级的版本号，它的第二个元素是一些指令组成的列表，这些指令指示该如何从这个版本升级到新的版本。第三个元素也是一个元组列表，它的第一个元素是将要降级到的版本号，它的第二个元素是也是一些指令组成的列表，这些指令指示该如何降级到这个版本。

下面是应用nine9s的appup文件内容：

{“0.2.0”,
  [{“0.1.0”, [
              {add_module, state_handler}
             ,{update, nine9s_sup, supervisor}
             ,{apply, {supervisor, restart_child, [nine9s_sup, state_handler]}}
             ,{load_module, default_handler}
             ,{add_module, count_handler}
             ,{load_module, nine9s_app}
             ,{apply, {nine9s_app, set_routes_new, [] }} ] }],

  [{“0.1.0”, [
              {load_module, default_handler}
             ,{apply, {supervisor, terminate_child, [nine9s_sup, state_handler]}}
             ,{apply, {supervisor, delete_child, [nine9s_sup, state_handler]}}
             ,{update, nine9s_sup, supervisor}
             ,{delete_module, state_handler}
             ,{apply, {nine9s_app, set_routes_old, [] }}
             ,{delete_module, count_handler}
             ,{load_module, nine9s_app}
             ]
}]}.
现在我们先来解释一下升级指令。注意：这些指令是按它们在文件中的先后顺序来执行的。

{add_module, state_handler} : 指示增加state_handler模块到运行环境里。
{update, nine9s, supervisor} : 这条指令将修改监督者的内部状态，也就是改变重启策略和最大重启频率，同时也改变子进程规格说明。最终将增加state_handler这个模块到监督者的子进程规格说明里。
{apply, {supervisor, restart_child, [nine9s, state_handler]}} : “apply”指令接收{M,F,A}做为参数，然后执行 M:F(A1, … An)。所以我们实际上是执行supervisor:restart_child(nine9s, state_handler)，这将在nine9s_sup监督者下启动state_handler做为工作进程。请注意：上述三条指令的顺序。首先我们增加state_handler模块，然后改变监督者的状态，最后创建state_handler进程。
{load_module, default_handler} : 这条指令将重新装载default_handler模块，替换它的老版本代码。
{add_module, count_handler} : 增加count_handler模块。
{load_module, nine9s_app} : 我们重新装载nine9s_app，从而我们新增加的函数被装载进虚拟机。
{apply, {nine9s_app, set_routes_new, [ ] }} ] } ] : 既然我们装载了新的函数，我就执行 nine9s_app:set_routes_new() 增加新的路由到我们的服务器。
接下来的元素是如何降级的指令，它的工作模式和前一个元素相似，但是是用老模块替换新模块。

{load_module, default_handler} : 这个指令将装载老的default_handler模块。
{apply, {supervisor, terminate_child, [nine9s_sup, state_handler]}} : 终止state_handler进程。
{apply, {supervisor, delete_child, [nine9s_sup, state_handler]}} : 从nine9s_sup里删除state_handler这个子进程规格。
{update, nine9s_sup, supervisor} : 修改监督者nine9s_sup的内部状态。
{delete_module, state_handler} : 删除state_handler模块。
{apply, {nine9s_app, set_routes_old, [ ] }} : 设置路由为老版本路由。
{delete_module, count_handler} : 删除count_handler模块。
{load_module, nine9s_app} : 装载老的nine9s_app模块。
既然我们的appup文件准备好了，我们就开始升级到最新的版本。


# 首先我们拷贝appup文件到lib目录下nine9s/ebin下
$ cp apps/nine9s/src/nine9s.appup.src _build/default/lib/nine9s/ebin/nine9s.appup
# 接着我们编译和发布应用
$ rebar3 compile
$ rebar3 release
# 生成relup到前一个版本
$ rebar3 relup -n nine9s -v "0.2.0" -u "0.1.0"
# 生成新版本的tar文件
$ rebar3 tar -n nine9s -v "0.2.0"
$ mv _build/default/rel/nine9s/nine9s-0.2.0.tar.gz _build/default/rel/nine9s/releases/0.2.0/nine9s.tar.gz
# 升级到新的版本
$ _build/default/rel/nine9s/bin/nine9s-0.1.0 upgrade "0.2.0"
搞定！如果所有执行都成功，那么我们就升级到0.2.0版本了。你可以浏览 http://localhost:9090和http://localhost:9090/count来验证一下。

项目有两个分支0.1.0和0.2.0。你可以先编译和运行分支0.1.0，然后切换到0.2.0分支，使用python脚本upgrade.py来升级到0.2.0版本。

原文链接： https://medium.com/@kansi/hot-code-loading-with-erlang-and-rebar3-8252af16605b#.zu5b3bzk4