# [关于Erlang中的behaviour]

唔，听说过这四个牛逼渣渣的behaviour：gen_server,gen_fsm,gen_event,supervisor。所以也就更加好奇behaviour的实现。

在解释它是怎么工作的之前，我们可以先看一个具体的实现。这可能会帮助我们理解。

我们先定义一个behaviour：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
-module(my_behaviour).
-export([behaviour_info/1]).
-export([start/1, stop/0]).

behaviour_info(callbacks) ->
        [ {init, 1},
         {handle, 2}];
behaviour_info(_Other) ->
        undefined.

start(Mod) ->
        State = Mod:init(0),
        {ok, State2} = Mod:handle(add, State),
        io:format("state : ~p~n", [State2]).

stop() ->
        stop.
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

然后，我们给他的callback给出具体的定义：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
-module(use_my_behaviour).
-behaviour(my_behaviour).

-export([init/1, handle/2]).

init(State) ->
        io:format("init ~p~n", [State]),
        State.

handle(Request, State) ->
        io:format("handle request:~p state:~p~n", [Request, State]),
        State2 = State + 1,
        {ok, State2}.
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

ok，然后是具体的执行：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
$ erlc my_behaviour.erl
$ erlc use_my_behaviour.erl 
use_my_behaviour.erl:2: Warning: behaviour my_behaviour undefined
$ erl
1> my_behaviour:start(use_my_behaviour).
init 0
handle request:add state:0
state : 1
ok
2> my_behaviour:module_info().            
[{exports,[{behaviour_info,1},
           {start,1},
           {stop,0},
           {module_info,0},
           {module_info,1}]},
 {imports,[]},
 {attributes,[{vsn,[81274671739413406355698544269213408364]}]},
 {compile,[{options,[{outdir,"/Users/luozhenxing/work/erlang/behaviour"}]},
           {version,"4.9.4"},
           {time,{2014,7,2,14,56,19}},
           {source,"/Users/luozhenxing/work/erlang/behaviour/my_behaviour.erl"}]}]
3> my_behaviour:behaviour_info(callbacks).
[{init,1},{handle,2}]
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

我们来看看我们做了什么，先看behaviour的定义：

\1. 需要一个叫behaviour_info的函数，它的参数只有一个，是一个atom，叫做callbacks。

\2. 然后，它的返回是a list of tuples，这些tuple定义了具体的callback的名字，以及他们的参数个数。

\3. behaviour具体的执行代码，虽然我们已经给出了callback的接口，但是总要做点什么的，要不然就不叫behaviour了。如上面的start(Mod)，我们在这里使用了Mod中具体的init和handle方法。

接着看behaviour使用的时候，事实上，也只是具体定义了behaviour需要的每个callbacks。

所以我们可以得出结论：

\1. hehaviour的定义其实还是使用的module的模板，所以，可以说它是一种特殊的module。

\2. 我们可以在定义一个module的时候，只写一些共性的行为，同时为一些特殊的方法留下callback接口，这一module就是the behaviour module；然后，在具体使用的时候，实现不同的callbacks即可，这一module就是the callback module。这一机制就是behviour机制了。

\3. 显然，一个behaviour module，我们是可以写很多个callback module配套使用的。

 

另外，R15B之后，提供了另外一种新的定义behaviour的方法(看起来是不是和spec很像？)：

```
-module(some_behaviour).
-callback init( number() ) -> number().
-callback handle( Event :: atom(), ARG::number() ) -> number().
```

这样做，和“先定义behaviour_info(callback)，然后再将其export出去”效果是一样的；不同的是，这样定义之后，Dialyzer可以方便的知道是不是出了什么问题。