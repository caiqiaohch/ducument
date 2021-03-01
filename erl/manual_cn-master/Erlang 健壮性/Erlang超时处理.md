Erlang超时处理

Erlang超时处理
在改进 messager 程序之前，让我们一起学习一些基本的原则。回忆一下，当 “ping” 结束的时候，它向 “pong” 发送一个原子值 finished 的消息以通知 “pong” 结束程序。另一种让 “pong” 结束的办法是当 “pong” 有一定时间没有收到来自 “ping” 的消息时则退出程序。我们可在 pong 中添加一个 time-out 来实现它：

-module(tut19).

-export([start_ping/1, start_pong/0,  ping/2, pong/0]).

ping(0, Pong_Node) ->
    io:format("ping finished~n", []);

ping(N, Pong_Node) ->
    {pong, Pong_Node} ! {ping, self()},
    receive
        pong ->
            io:format("Ping received pong~n", [])
    end,
    ping(N - 1, Pong_Node).

pong() ->
    receive
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,
            pong()
    after 5000 ->
            io:format("Pong timed out~n", [])
    end.

start_pong() ->
    register(pong, spawn(tut19, pong, [])).

start_ping(Pong_Node) ->
    spawn(tut19, ping, [3, Pong_Node]).
编译上面的代码并将生成的 tut19.beam 文件拷贝到某个目录下，下面是在结点 pong@kosken 上的输出：

true
Pong received ping
Pong received ping
Pong received ping
Pong timed out
在结点 ping@gollum 上的输出结果为：

(ping@gollum)1> tut19:start_ping(pong@kosken).
<0.36.0>
Ping received pong
Ping received pong
Ping received pong
ping finished 
time-out 被设置在：

pong() ->
    receive
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,
            pong()
    after 5000 ->
            io:format("Pong timed out~n", [])
    end.
执行 recieve 时，超时定时器 （5000 ms）启动；一旦收到 {ping,Ping_PID} 消息，则取消该超时定时器。如果没有收到 {ping,Ping_PID} 消息，那么 5000 毫秒后 time-out 后面的程序就会被执行。after 必须是 recieve 中的最后一个，也就是说，recieve 中其它所有消息的接收处理都优先于超时消息。如果有一个返回值为整数值的函数，我们可以在 after 后调用该函数以将其返回值设为超时时间值，如下所示：

after pong_timeout() ->
一般地，除了使用超时来监测分布式 Erlang 系统的各分部外，还有许多更好的办法来实现监测功能。超时适用于监测来自于系统外部的事件，比如说，当你希望在指定时间内收到来自外部系统的消息的时候。举个例子，我们可以用超时来发现用户离开了messager 系统，比如说当用户 10 分钟没有访问系统时，则认为其已离开了系统。