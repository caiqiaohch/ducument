Erlang错误处理


在讨论监督与错误处理细节之前，让我们先一起来看一下 Erlang 进程的终止过程，或者说 Erlang 的术语 exit。

进程执行 exit(normal) 结束或者运行完所有的代码而结束都被认为是进程的正常（normal）终止。

进程因为触发运行时错误（例如，除零、错误匹配、调用不存在了函数等）而终止被称之为异常终止。进程执行 exit(Reason) （注意此处的 Reason 是除 normal 以外的值）终止也被称之为异常终止。

一个 Erlang 进程可以与其它 Erlang 进程建立连接。如果一个进程调用 link(Other_Pid)，那么它就在其自己与 Othre_Pid 进程之间创建了一个双向连接。当一个进程结束时，它会发送信号至所有与之有连接的进程。

这个信号携带着进程的进程标识符以及进程结束的原因信息。

进程收到进程正常退出的信号时默认情况下是直接忽略它。

但是，如果进程收到的是异常终止的信号，则默认动作为：

接收到异常终止信号的进程忽略消息队列中的所有消息

杀死自己
将相同的错误消息传递给连接到它的所有进程。
所以，你可以使用连接的方式把同一事务的所有进程连接起来。如果其中一个进程异常终止，事务中所有进程都会被杀死。正是因为在实际生产过程中，常常有创建进程同时与之建立连接的需求，所以存在这样一个内置函数 spawn_link，与 spawn 不同之处在于，它创建一个新进程同时在新进程与创建者之间建立连接。

下面给出了 ping pong 示例子另外一种实现方法，它通过连接终止 "pong" 进程：

-module(tut20).

-export([start/1,  ping/2, pong/0]).

ping(N, Pong_Pid) ->
    link(Pong_Pid),
    ping1(N, Pong_Pid).

ping1(0, _) ->
    exit(ping);

ping1(N, Pong_Pid) ->
    Pong_Pid ! {ping, self()},
    receive
        pong ->
            io:format("Ping received pong~n", [])
    end,
    ping1(N - 1, Pong_Pid).

pong() ->
    receive
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,
            pong()
    end.

start(Ping_Node) ->
    PongPID = spawn(tut20, pong, []),
    spawn(Ping_Node, tut20, ping, [3, PongPID]).
(s1@bill)3> tut20:start(s2@kosken).
Pong received ping
<3820.41.0>
Ping received pong
Pong received ping
Ping received pong
Pong received ping
Ping received pong
与前面的代码一样，ping pong 程序的两个进程仍然都是在 start/1 函数中创建的，“ping”进程在单独的结点上建立的。但是这里做了一些小的改动，用到了内置函数 link。“Ping” 结束时调用 exit(ping) ，使得一个终止信号传递给 “pong” 进程，从而导致 “pong” 进程终止。

也可以修改进程收到异常终止信号时的默认行为，避免进程被杀死。即，把所有的信号都转变为一般的消息添加到信号接收进程的消息队列中，消息的格式为 {'EXIT',FromPID,Reason}。我们可以通过如下的代码来设置：

process_flag(trap_exit, true)
还有其它可以用的进程标志，可参阅 erlang (3)。标准用户程序一般不需要改变进程对于信号的默认处理行为，但是对于 OTP 中的管理程序这个接口还是很有必要的。下面修改了 ping pong 程序来打印输出进程退出时的信息：

-module(tut21).

-export([start/1,  ping/2, pong/0]).

ping(N, Pong_Pid) ->
    link(Pong_Pid), 
    ping1(N, Pong_Pid).

ping1(0, _) ->
    exit(ping);

ping1(N, Pong_Pid) ->
    Pong_Pid ! {ping, self()},
    receive
        pong ->
            io:format("Ping received pong~n", [])
    end,
    ping1(N - 1, Pong_Pid).

pong() ->
    process_flag(trap_exit, true), 
    pong1().

pong1() ->
    receive
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,
            pong1();
        {'EXIT', From, Reason} ->
            io:format("pong exiting, got ~p~n", [{'EXIT', From, Reason}])
    end.

start(Ping_Node) ->
    PongPID = spawn(tut21, pong, []),
    spawn(Ping_Node, tut21, ping, [3, PongPID]).
(s1@bill)1> tut21:start(s2@gollum).
<3820.39.0>
Pong received ping
Ping received pong
Pong received ping
Ping received pong
Pong received ping
Ping received pong
pong exiting, got {'EXIT',<3820.39.0>,ping}