rpc:call/4
在一个节点上调用执行一个函数

用法：

call(Node, Module, Function, Args) -> Res | {badrpc, Reason}
在节点 Node 上执行 apply(Module, Function, Args)，并返回响应值 Res。该函数等同于调用 rpc:call/5 的 rpc:call(Node, Module, Function, Args, infinity)。

Pid = self(),
Node = node(Pid),
rpc:call(Node, erlang, is_process_alive, [Pid]).
如果调用失败，则返回 {badrpc, Reason}。

Pid = self(),
Node = node(Pid),
rpc:call(Node, erlang, now, [Pid]).

----------
rpc:call/5
在一个节点上调用执行一个函数

用法：

call(Node, Module, Function, Args, Timeout) -> Res | {badrpc, Reason}
跟 rpc:call/4 一样，都是在节点 Node 上执行 apply(Module, Function, Args)，并返回响应值 Res。如果调用失败，则返回 {badrpc, Reason}。Timeout 是以毫秒为单位的一个超时值。如果调用超时，则返回的调用失败原因 Reason 是 timeout。

Pid = self(),
Node = node(Pid),
rpc:call(Node, erlang, is_process_alive, [Pid], 5000).
如果在调用超时后收到回复信息，那么这条回复信息是不会被方便消息队列里，因为这个函数开启的接收信息的进程来停止接收这条信息。同理，rpc:call/4 也是有这特性。

----------
rpc:cast/4
在一个节点上调用执行一个函数

用法：

cast(Node, Module, Function, Args) -> true
在节点 Node 上执行 apply(Module, Function, Args)。不会有结果信息返回。跟 rpc:call/4、rpc:call/5 一样，调用进程直到函数执行完才终止。

Pid = self(),
Node = node(Pid),
rpc:cast(Node, erlang, is_process_alive, [Pid]).

----------
rpc:eval_everywhere/3
在所有节点上异步调用一个函数

用法：

eval_everywhere(Module, Function, Args) -> abcast
内部实现：

-spec eval_everywhere(Module, Function, Args) -> abcast when
      Module :: module(),
      Function :: atom(),
      Args :: [term()].

eval_everywhere(Mod, Fun, Args) ->
    eval_everywhere([node() | nodes()] , Mod, Fun, Args).

-spec eval_everywhere(Nodes, Module, Function, Args) -> abcast when
      Nodes :: [node()],
      Module :: module(),
      Function :: atom(),
      Args :: [term()].

eval_everywhere(Nodes, Mod, Fun, Args) ->
    gen_server:abcast(Nodes, ?NAME, {cast,Mod,Fun,Args,group_leader()}).
在所有节点上异步调用一个函数，忽略结果。等价于调用 rpc:eval_everywhere/4 的 rpc:eval_everywhere([node()|nodes()], Module, Function, Args)。

rpc:eval_everywhere(erlang, now, []).

----------
rpc:eval_everywhere/4
在指定节点上异步调用一个函数

用法：

eval_everywhere(Nodes, Module, Function, Args) -> abcast
内部实现：

-spec eval_everywhere(Nodes, Module, Function, Args) -> abcast when
      Nodes :: [node()],
      Module :: module(),
      Function :: atom(),
      Args :: [term()].

eval_everywhere(Nodes, Mod, Fun, Args) ->
    gen_server:abcast(Nodes, ?NAME, {cast,Mod,Fun,Args,group_leader()}).
在指定节点上异步调用一个函数，忽略结果。

rpc:eval_everywhere([node()], erlang, now, []).

----------
rpc:multicall/3
在所有节点上调用一个函数

用法：

multicall(Module, Function, Args) -> {ResL, BadNodes}
这个函数会在所有节点上调用模拟执行 apply(Module, Function, Args)，并收集返回结果信息。它会返回 {ResL, BadNodes} 格式的结果，BadNodes 是一个节点崩溃或调用超时的一个节点列表，ResL 是一个返回值的列表。用法跟 rpc:multicall/5 的 rpc:multicall([node()|nodes()], Module, Function, Args, infinity) 一样。

{ok, Mod} = application:get_application(),
case code:get_object_code(Mod) of
    {_Module, Bin, Fname} ->
        rpc:multicall(code, load_binary, [Mod, Fname, Bin]);
    Other ->
	    Other
end.

----------
rpc:multicall/5
在指定节点上调用一个函数

用法：

multicall(Nodes, Module, Function, Args, Timeout) -> {ResL, BadNodes}
内部实现：

multicall(Nodes, M, F, A, infinity)
  when is_list(Nodes), is_atom(M), is_atom(F), is_list(A) ->
    do_multicall(Nodes, M, F, A, infinity);
multicall(Nodes, M, F, A, Timeout) 
  when is_list(Nodes), is_atom(M), is_atom(F), is_list(A), is_integer(Timeout), 
       Timeout >= 0 ->
    do_multicall(Nodes, M, F, A, Timeout).

do_multicall(Nodes, M, F, A, Timeout) ->
    {Rep,Bad} = gen_server:multi_call(Nodes, ?NAME, 
				      {call, M,F,A, group_leader()}, 
				      Timeout),
    {lists:map(fun({_,R}) -> R end, Rep), Bad}.
这个函数会在指定节点上调用模拟执行 apply(Module, Function, Args)，并收集返回结果信息。它会返回 {ResL, BadNodes} 格式的结果，BadNodes 是一个节点崩溃或调用超时的一个节点列表，ResL 是一个返回值的列表。

参数 Timeout 是一个毫秒为单位的整数值，如果改值为 infinity，则表示无限超时时间。

{ok, Mod} = application:get_application(),
case code:get_object_code(Mod) of
    {_Module, Bin, Fname} ->
        rpc:multicall([node()|nodes()], code, load_binary, [Mod, Fname, Bin], infinity);
    Other ->
        Other
end.
在一个 RPC 里，rpc:multicall/5 可以在从一个客户端想多个服务端同时发送信息。这有利于从节点群里收集一些信息，或在节点群里调用一个会引起一些效果作用的函数方法。在语义上，这跟在所有节点上迭代操作一系列 RPC 服务一样效果，但是 rpc:multicall/5 会更快，因为虽然所有请求是同时发送，不过它们的返回是一个一个接收的。

----------
