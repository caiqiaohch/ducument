Erlang 消息传递

下面的例子中创建了两个进程，它们相互之间会发送多个消息。

-module(tut15).

-export([start/0, ping/2, pong/0]).

ping(0, Pong_PID) ->
    Pong_PID ! finished,
    io:format("ping finished~n", []);

ping(N, Pong_PID) ->
    Pong_PID ! {ping, self()},
    receive
        pong ->
            io:format("Ping received pong~n", [])
    end,
    ping(N - 1, Pong_PID).

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
    Pong_PID = spawn(tut15, pong, []),
    spawn(tut15, ping, [3, Pong_PID]).
1> c(tut15).
{ok,tut15}
2> tut15: start().
<0.36.0>
Pong received ping
Ping received pong
Pong received ping
Ping received pong
Pong received ping
Ping received pong
ping finished
Pong finished
start 函数先创建了一个进程，我们称之为 “pong”：

Pong_PID = spawn(tut15, pong, [])
这个进程会执行 tut15:pong 函数。Pong_PID 是 “pong” 进程的进程标识符。接下来，start 函数又创建了另外一个进程 ”ping“：

spawn(tut15,ping,[3,Pong_PID]),
这个进程执行：

tut15:ping(3, Pong_PID)
<0.36.0> 为是 start 函数的返回值。

”pong“ 进程完成下面的工作：

receive
    finished ->
        io:format("Pong finished~n", []);
    {ping, Ping_PID} ->
        io:format("Pong received ping~n", []),
        Ping_PID ! pong,
        pong()
end.
receive 关键字被进程用来接收从其它进程发送的的消息。它的使用语法如下：

receive
   pattern1 ->
       actions1;
   pattern2 ->
       actions2;
   ....
   patternN
       actionsN
end.
请注意，在 end 前的最后一个 actions 并没有 ";"。

Erlang 进程之间的消息可以是任何简单的 Erlang 项。比如说，可以是列表、元组、整数、原子、进程标识等等。

每个进程都有独立的消息接收队列。新接收的消息被放置在接收队列的尾部。当进程执行 receive 时，消息中第一个消息与与 receive 后的第一个模块进行匹配。如果匹配成功，则将该消息从消息队列中删除，并执行该模式后面的代码。

然而，如果第一个模式匹配失败，则测试第二个匹配。如果第二个匹配成功，则将该消息从消息队列中删除，并执行第二个匹配后的代码。如果第二个匹配也失败，则匹配第三个，依次类推，直到所有模式都匹配结束。如果所有匹配都失败，则将第一个消息留在消息队列中，使用第二个消息重复前面的过程。第二个消息匹配成功时，则执行匹配成功后的程序并将消息从消息队列中取出（将第一个消息与其余的消息继续留在消息队列中）。如果第二个消息也匹配失败，则尝试第三个消息，依次类推，直到尝试完消息队列所有的消息为止。如果所有消息都处理结束（匹配失败或者匹配成功被移除），则进程阻塞，等待新的消息的到来。上面的过程将会一直重复下去。

Erlang 实现是非常 “聪明” 的，它会尽量减少 receive 的每个消息与模式匹配测试的次数。

让我们回到 ping pong 示例程序。

“Pong” 一直等待接收消息。 如果收到原子值 finished，“Pong” 会输出 “Pong finished”，然后结束进程。如果收到如下形式的消息：

{ping, Ping_PID}
则输出 “Pong received ping”，并向进程 “ping” 发送一个原子值消息 pong：

Ping_PID ! pong
请注意这里是如何使用 “!” 操作符发送消息的。 “!” 操作符的语法如下所示：

Pid ! Message
这表示将消息（任何 Erlang 数据）发送到进程标识符为 Pid 的进程的消息队列中。

将消息 pong 发送给进程 “ping” 后，“pong” 进程再次调用 pong 函数，这会使得再次回到 receive 等待下一个消息的到来。

下面，让我们一起去看看进程 “ping”，回忆一下它是从下面的地方开始执行的：

tut15:ping(3, Pong_PID)
可以看一下 ping/2 函数，由于第一个参数的值是 3 而不是 0， 所以 ping/2 函数的第二个子句被执行（第一个子句的头为 ping(0,Pong_PID)，第二个子句的头部为 ping(N,Pong_PID)，因此 N 为 3 。

第二个子句将发送消息给 “pong” 进程：

Pong_PID ! {ping, self()},
self() 函数返回当前进程（执行 self() 的进程）的进程标识符，在这儿为 “ping” 进程的进程标识符。（回想一下 “pong” 的代码，这个进程标识符值被存储在变量 Ping_PID 当中）

发送完消息后，“Ping” 接下来等待回复消息 “pong”：

receive
    pong ->
        io:format("Ping received pong~n", [])
end,
收到回复消息后，则输出 “Ping received pong”。之后 “ping” 也再次调用 ping 函数：

ping(N - 1, Pong_PID)
N-1 使得第一个参数逐渐减小到 0。当其值变为 0 后，ping/2 函数的第一个子句会被执行。

ping(0, Pong_PID) ->
    Pong_PID !  finished,
    io:format("ping finished~n", []);
此时，原子值 finished 被发送至 “pong” 进程（会导致进程结束），同时将“ping finished” 输出。随后，“Ping” 进程结束。