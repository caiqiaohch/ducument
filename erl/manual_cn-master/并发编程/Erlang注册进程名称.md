# Erlang注册进程名称

上面的例子中，因为 “Pong” 在 “ping” 进程开始前已经创建完成，所以才能将 “pong” 进程的进程标识符作为参数传递给进程 “ping”。这也就说，“ping” 进程必须通过某种途径获得 “pong” 进程的进程标识符后才能将消息发送 “pong” 进程。然而，某些情况下，进程需要相互独立地启动，而这些进程之间又要求知道彼此的进程标识符，前面提到的这种方式就不能满足要求了。因此，Erlang 提供了为每个进程提供一个名称绑定的机制，这样进程间通信就可以通过进程名来实现，而不需要知道进程的进程标识符了。为每个进程注册一个名称需要用到内置函数 register：

register(some_atom, Pid)
接下来，让我们一起上面的 ping pong 示例程序。这一次，我们为 “pong” 进程赋予了一名进程名称 pong：

-module(tut16).

-export([start/0, ping/1, pong/0]).

ping(0) ->
    pong ! finished,
    io:format("ping finished~n", []);

ping(N) ->
    pong ! {ping, self()},
    receive
        pong ->
            io:format("Ping received pong~n", [])
    end,
    ping(N - 1).

pong() ->
    receive
        finished ->
            io:format("Pong finished~n", []);
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,
            pong()
    end.

start() ->
    register(pong, spawn(tut16, pong, [])),
    spawn(tut16, ping, [3]).
2> c(tut16).
{ok, tut16}
3> tut16:start().
<0.38.0>
Pong received ping
Ping received pong
Pong received ping
Ping received pong
Pong received ping
Ping received pong
ping finished
Pong finished
start/0 函数如下：

register(pong, spawn(tut16, pong, [])),
创建 “pong” 进程的同时还赋予了它一个名称 pong。在 “ping” 进程中，通过如下的形式发送消息：

pong ! {ping, self()},
ping/2 变成了 ping/1。这是因为不再需要参数 Pong_PID 了。