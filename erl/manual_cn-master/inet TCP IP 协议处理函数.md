inet TCP/IP 协议处理函数

----------
inet:peername/1
返回另一端连接的地址和端口

用法：

peername(Socket) ->  {ok, {Address, Port}} | {error, posix()}
内部实现：

-spec peername(Socket) ->  {ok, {Address, Port}} | {error, posix()} when
      Socket :: socket(),
      Address :: ip_address(),
      Port :: non_neg_integer().

peername(Socket) -> 
    prim_inet:peername(Socket).
返回另一端连接的地址和端口。

Socket = util:get_socket(),
case inet:peername(Socket) of
    {ok, {Ip, Port}} ->
        {Ip, Port};
    {error, Reason} ->
        Reason
end.
对于是 SCTP 的套接字连接，这个函数只返回连接端地址中的一个套接字连接，函数 inet:peernames/1 和 inet:peernames/2 会返回所有。

----------
inet:port/1
返回一个套接字的本地端口号

用法：

port(Socket) -> {ok, Port} | {error, any()}
内部实现：

-spec port(Socket) -> {'ok', Port} | {'error', any()} when
      Socket :: socket(),
      Port :: port_number().

port(Socket) ->
    case prim_inet:sockname(Socket) of
	{ok, {_,Port}} -> {ok, Port};
	Error -> Error
    end.
返回一个套接字 Socket 的本地端口号。

获取由函数 gen_tcp:listen/2 建立的套接字所监听的端口：

{Rand, _RandSeed} = ranDOM:uniform_s(9999, erlang:now()),
Port = 40000 + Rand,
case gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]) of
    {ok, Socket} ->
        inet:port(Socket);
    _ ->
        socket_listen_fail
end.
本服务所监听的端口：

Socket = util:get_socket(),
inet:port(Socket).

----------
