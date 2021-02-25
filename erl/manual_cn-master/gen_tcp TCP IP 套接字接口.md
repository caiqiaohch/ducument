gen_tcp TCP/IP 套接字接口

gen_tcp:accept/1
接受一个发送到监听套接字 ListenSocket 上的连接请求

用法：

accept(ListenSocket) -> {ok, Socket} | {error, Reason}
接受一个发送到监听套接字 ListenSocket 上的连接请求。ListenSocket 必须是由函数 gen_tcp:listen/2 建立返回。

该函数会引起进程阻塞，直到有一个连接请求发送到监听的套接字。

如果连接已建立，则返回 {ok，Socket}；或如果 ListenSocket 已经关闭，则返回{error，closed}；或如果在指定的时间内连接没有建立，则返回{error，timeout}；或如果 Erlang 虚拟机里可用的端口都被使用了，则返回 {error, system_limit}；如果某些东西出错，也可能返回一个 POSIX 错误。一些有可能的错误请查看 inet 模块的相关说明。

使用 gen_tcp:send/2 向该函数返回的套接字 Socket 发送数据包。往端口发送的数据包会以下面格式的消息发送：

{tcp, Socket, Data}
如果在建立套接字 Socket 的时候选项列表中指定了 {active，false}，这样就只能使用 gen_tcp:recv/2 或 gen_tcp:recv/3 来接收数据包了。

{Rand, _RandSeed} = ranDOM:uniform_s(9999, erlang:now()),
Port = 40000 + Rand,
case gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]) of
    {ok, ListenSocket} ->
        case gen_tcp:accept(ListenSocket) of
            {ok, Socket} ->
                Socket;
            {error, SocketAcceptFail} ->
                SocketAcceptFail
        end;
    _ ->
        socket_listen_fail
end.

----------
gen_tcp:accept/2
接受一个发送到监听套接字 ListenSocket 上的连接请求

用法：

accept(ListenSocket, Timeout) -> {ok, Socket} | {error, Reason}
接受一个发送到监听套接字 ListenSocket 上的连接请求。ListenSocket 必须是由函数 gen_tcp:listen/2 建立返回。Timeout 是一个毫秒级的超时值，默认为infinity。

该函数会引起进程阻塞，直到有一个连接请求发送到监听的套接字，或是超过监听接受时间。

如果连接已建立，则返回 {ok，Socket}；或如果 ListenSocket 已经关闭，则返回{error，closed}；或如果在指定的时间内连接没有建立，则返回{error，timeout}；或如果 Erlang 虚拟机里可用的端口都被使用了，则返回 {error, system_limit}；如果某些东西出错，也可能返回一个 POSIX 错误。一些有可能的错误请查看 inet 模块的相关说明。

使用 gen_tcp:send/2 向该函数返回的套接字 Socket 发送数据包。往端口发送的数据包会以下面格式的消息发送：

{tcp, Socket, Data}
如果在建立套接字 Socket 的时候选项列表中指定了 {active，false}，这样就只能使用 gen_tcp:recv/2 或 gen_tcp:recv/3 来接收数据包了。

{Rand, _RandSeed} = ranDOM:uniform_s(9999, erlang:now()),
Port = 40000 + Rand,
case gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]) of
    {ok, ListenSocket} ->
        case gen_tcp:accept(ListenSocket, 1500) of
            {ok, Socket} ->
                Socket;
            {error, SocketAcceptFail} ->
                SocketAcceptFail
        end;
    _ ->
        socket_listen_fail
end.

----------
gen_tcp:close/1
关闭一个 TCP 套接字

用法：

close(Socket) -> ok
关闭一个 TCP 套接字。

{Rand, _RandSeed} = ranDOM:uniform_s(9999, erlang:now()),
Port = 40000 + Rand,
case gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]) of
    {ok, Socket} ->
        gen_tcp:close(Socket);
    _ ->
        socket_listen_fail
end.

----------
gen_tcp:connect/3
连接一个 TCP 端口

用法：

connect(Address, Port, Options) -> {ok, Socket} | {error, Reason}
用给出的端口 Port 和 IP 地址 Address 连接到一个服务器上的 TCP 端口上。参数 Address 即可以是一个主机名，也可以是一个 IP 地址。

{Rand, _RandSeed} = ranDOM:uniform_s(9999, erlang:now()),
Port = 40000 + Rand,
gen_tcp:connect("localhost", Port, [{active, false}, {packet, 0}]).

----------
gen_tcp:connect/4
连接一个 TCP 端口

用法：

connect(Address, Port, Options, Timeout) -> {ok, Socket} | {error, Reason}
用给出的端口 Port 和 IP 地址 Address 连接到一个服务器上的 TCP 端口上。参数 Address 即可以是一个主机名，也可以是一个 IP 地址。

参数 Timeout 指定一个以毫秒为单位的超时值，默认值是 infinity。

{Rand, _RandSeed} = ranDOM:uniform_s(9999, erlang:now()),
Port = 40000 + Rand,
gen_tcp:connect("localhost", Port, [{active, false}, {packet, 0}], 5000).

----------
