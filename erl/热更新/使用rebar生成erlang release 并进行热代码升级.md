http://blog.sina.com.cn/s/blog_6530ad590100wmkn.html

一、使用rebar创建一个otp项目
第1步：创建一个项目目录
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test$ mkdir myapp; cd myapp

第2步：将rebar文件复制到这个目录，也可以直接下载
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test$ wget http://cloud.github.com/downloads/basho/rebar/rebar && chmod u+x rebar
--2011-05-13 09:37:13--  http://cloud.github.com/downloads/basho/rebar/rebar
正在解析主机 cloud.github.com... 204.246.165.144, 204.246.165.231, 204.246.165.99, ...
正在连接 cloud.github.com|204.246.165.144|:80... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度： 102570 (100K) [application/octet-stream]
正在保存至: “rebar”

100%[======================================>] 102,570     74.4K/s   in 1.3s    

2011-05-13 09:37:23 (74.4 KB/s) - 已保存 “rebar” [102570/102570])

注：rebar项目地址git地址：https://github.com/basho/rebar.git （$ git clone https://github....），git下载后make生成一个rebar文件也是可以的。

第3步：创建一个OTP项目
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ ./rebar create-app appid=myapp
==> myapp (create-app)
Writing src/myapp.app.src
Writing src/myapp_app.erl
Writing src/myapp_sup.erl

第4步：增加一个gen_server，可以设置状态值和得到状态，具体代码看文件，并修改myapp_sup.erl
init([]) ->
    Server1 = {myapp_server,
             {myapp_server, start_link, []},
             permanent, 5000, worker, [myapp_server]},

    {ok, {{one_for_one, 5, 10}, [Server1]}}.
    
第5步：修改myapp.app.src
增加配置项：
  {modules, [
             myapp_app,
             myapp_sup,
             myapp_server
            ]},

第4步：编译
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ ./rebar compile
==> myapp (compile)
Compiled src/myapp_app.erl
Compiled src/myapp_sup.erl
Compiled src/myapp_server.erl

第5步：测试
rebar同时支持 eunit 和 common_test两种测试框架，下面例子将使用eunit方式进行一个简单测试
1）打开 src/myapp_app.erl文件，在 -export() 后加入如下代码：
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

同时在文件中加入测试函数（注：所有的测试函数都需要被包含在-ifdef(TEST)和-endif中）：
-ifdef(TEST).

%%测试函数
simple_test() ->
    ok = application:start(myapp),
    ?assertNot(undefined == whereis(myapp_sup)).

-endif.
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ cat src/myapp_app.erl
-module(myapp_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    myapp_sup:start_link().

stop(_State) ->
    ok.
    
-ifdef(TEST).
%%测试函数
simple_test() ->
    ok = application:start(myapp),
    ?assertNot(undefined == whereis(myapp_sup)).
-endif.
2）进行单元测试
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ ./rebar compile eunit
==> myapp (compile)
Compiled src/myapp_app.erl
Compiled src/myapp_sup.erl
==> myapp (eunit)
Compiled src/myapp_app.erl
  Test passed.

二、发布版本
第1步：创建apps目录
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ mkdir apps

第2步：在apps目录下创建myapp
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ mkdir apps/myapp

第3步：将src文件移动到apps/myapp目录下
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ mv src apps/myapp/src
      
第4步：创建rel目录
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ mkdir rel
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ cd rel
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel$

第5步：create the node
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel$ ../rebar create-node nodeid=myapp
==> rel (create-node)
Writing reltool.config
Writing files/erl
Writing files/nodetool
Writing files/myapp
Writing files/app.config
Writing files/vm.args

bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel$ ls -lR
.:
总用量 8
drwxr-xr-x 2 bland bland 4096 2011-05-13 09:55 files
-rw-r--r-- 1 bland bland  783 2011-05-13 09:55 reltool.config

./files:
总用量 28
-rw-r--r-- 1 bland bland  334 2011-05-13 09:55 app.config
-rwxr--r-- 1 bland bland 1120 2011-05-13 09:55 erl
-rwxr--r-- 1 bland bland 4370 2011-05-13 09:55 myapp
-rwxr--r-- 1 bland bland 4819 2011-05-13 09:55 nodetool
-rw-r--r-- 1 bland bland  417 2011-05-13 09:55 vm.args

第6步：创建一个rebar.config文件，并增加如下信息:
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel$ cd ..
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ cat << EOF > rebar.config 【回车】
> {sub_dirs, ["apps/myapp","rel"]}. 【回车】
> {cover_enabled, true}. 【回车】
> EOF 【回车】
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ cat rebar.config
{sub_dirs, ["apps/myapp","rel"]}.
{cover_enabled, true}.

第7步：修改rel/reltool.config 文件
找到 {lib_dirs, []},...
      修改为：{lib_dirs, ["../apps"]},
找到 {rel, "myapp", "1",
        [
         kernel,
         stdlib,
         sasl
        ]},...
      修改为：
      {rel, "myapp", "1",
        [
         kernel,
         stdlib,
         sasl,
         myapp
        ]},
        
找到 {excl_sys_filters, ["^bin/.*",
                           "^erts.*/bin/(dialyzer|typer)"]},
      {app, sasl, [{incl_cond, include}]} .....
      修改为：
       {excl_sys_filters, ["^bin/.*",
                           "^erts.*/bin/(dialyzer|typer)"]},
       {excl_archive_filters, [".*"]},
       {app, myapp, [{incl_cond, include}]},
       {app, sasl, [{incl_cond, include}]}......
      
第8步：编译
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$./rebar compile
==> myapp (compile)
==> rel (compile)
==> myapp (compile)
       
第9步：生成release
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$./rebar generate
==> rel (generate)
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ ls rel/myapp/
bin  erts-5.8.1  etc  lib  log  releases

bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ ls rel/myapp/lib/
compiler-4.7.1  hipe-3.7.7        public_key-0.8         tools-2.6.6.1
crypto-2.0.1    inets-5.5         runtime_tools-1.8.4.1  webtool-0.8.7
edoc-0.7.6.7    kernel-2.14.1     sasl-2.1.9.2           wx-0.98.7
erts-5.8.1      mnesia-4.4.15     ssl-4.0.1              xmerl-1.2.6
et-1.4.1        myapp-0.1         stdlib-1.17.1
gs-1.5.13       observer-0.9.8.3  syntax_tools-1.6.6

三、进行热代码替换
第1步：构建0.1版本并启动应用
1）修改目录名称，按照版本号命名
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ mv rel/myapp rel/myapp_0.1
2）进入rel/myapp_0.1
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ cd rel/myapp_0.1/
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel/myapp_0.1$ ls
bin  erts-5.8.1  etc  lib  log  releases

3）启动应用
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel/myapp_0
.1$ ./bin/myapp console
Exec: /home/bland/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel/myapp_0.1/erts-5.8.1/bin/erlexec -boot /home/bland/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel/myapp_0.1/releases/1/myapp -embedded -config /home/bland/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel/myapp_0.1/etc/app.config -args_file /home/bland/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel/myapp_0.1/etc/vm.args -- console
Root: /home/bland/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp/rel/myapp_0.1
Erlang R14B (erts-5.8.1) [source] [smp:2:2] [rq:2] [async-threads:5] [hipe] [kernel-poll:true]

Eshell V5.8.1  (abort with ^G)
(myapp@127.0.0.1)1> application:which_applications().%%浏览当前节点启动的应用
[{sasl,"SASL  CXC 138 11","2.1.9.2"},
 {myapp,"my first app","0.1"},
 {stdlib,"ERTS  CXC 138 10","1.17.1"},
 {kernel,"ERTS  CXC 138 10","2.14.1"}]
(myapp@127.0.0.1)3> myapp_server:get_state().
0
(myapp@127.0.0.1)4> myapp_server:set_state(123).
{ok,123}
(myapp@127.0.0.1)5> myapp_server:get_state().   
123
(myapp@127.0.0.1)5> release_handler:which_releases(). %%查看当前版本
[{"myapp","0.1",[],permanent}]
(myapp@127.0.0.1)6>

第3步：构建0.2版本
1）将release版本号从0.1改为0.2
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ vim apps/myapp/src/myapp.app.src
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ vim rel/reltool.config
2）编译并且打包
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ ./rebar compile
==> myapp (compile)
==> rel (compile)
==> myapp (compile)
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ ./rebar generate
==> rel (generate)
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ ./rebar generate-appups previous_release=myapp_0.1
==> rel (generate-appups)
Generated appup for myapp
Appup generation complete
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ ./rebar generate-upgrade previous_release=myapp_0.1
==> rel (generate-upgrade)
myapp_0.2 upgrade package created
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$

3）检查升级包内容
bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ tar -zvtf rel/myapp_0.2.tar.gz

第4步：使用RELEASE_HANDLER进行部署
1）bland@thinkpad:~/workspace/黑米/研发/项目/SiteLyst3/rebar_test/myapp$ mv rel/myapp_0.2.tar.gz rel/myapp_0.1/releases/
2）使用release_handler在运行应用的erlang shell中进行部署
(myapp@127.0.0.1)> release_handler:unpack_release("myapp_0.2").
{ok,"0.2"}
(myapp@127.0.0.1)> release_handler:install_release("0.2").
{ok,"0.1",[]}
(myapp@127.0.0.1)> release_handler:make_permanent("0.2").
ok
(myapp@127.0.0.1)> release_handler:which_releases().
[{"myapp","0.2",
  ["kernel-2.14.1","stdlib-1.17.1","myapp-0.2","sasl-2.1.9.2",
   "compiler-4.7.1","crypto-2.0.1","syntax_tools-1.6.6",
   "edoc-0.7.6.7","et-1.4.1","gs-1.5.13","hipe-3.7.7",
   "inets-5.5","mnesia-4.4.15","observer-0.9.8.3",
   "public_key-0.8","runtime_tools-1.8.4.1","ssl-4.0.1",
   "tools-2.6.6.1","webtool-0.8.7","wx-0.98.7","xmerl-1.2.6"],
  permanent},
 {"myapp","0.1",[],old}]
(myapp@127.0.0.1)> myapp_server:get_state().
123
Gen Server的状态值仍然为123。

好了，关于rebar就这些了，rebar的细节请查看附件资料。

李存刚（bland.li@heimi360.com & licungang@gmail.com）


注：这是以前和同事分享的一个学习总结，没有进行进一步的整理，以上操作系统都为ubuntu10.04 x86 erlang版本：R14A
