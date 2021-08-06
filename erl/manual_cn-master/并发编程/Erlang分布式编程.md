# Erlang分布式编程


下面我们进一步对 ping pong 示例程序进行改进。 这一次，我们要让 “ping”、“pong” 进程分别位于不同的计算机上。要想让这个程序工作，你首先的搭建一下分布式的系统环境。分布式 Erlang 系统的实现提供了基本的安全机制，它阻止未授权的外部设备访问本机的 Erlang 系统。同一个系统中的 Erlang 要想相互通信需要设置相同的 magic cookie。设置 magic cookie 最便捷地实现方式就是在你打算运行分布式 Erlang 系统的所有计算机的 home 目录下创建一个 .erlang.cookie 文件：

在 windows 系统中，home 目录为环境变量 $HOME 指定的目录--这个变量的值可能需要你手动设置
在 Linux 或者 UNIX 系统中简单很多，你只需要在执行 cd 命令后所进入的目录下创建一个 .erlang.cookie 文件就可以了。
.erlang.cookie 文件只有一行内容，这一行包含一个原子值。例如，在 Linux 或 UNIX 系统的 shell 执行如下命令：

$ cd
$ cat > .erlang.cookie
this_is_very_secret
$ chmod 400 .erlang.cookie
使用 chmod 命令让 .erlang.cookie 文件只有文件拥者可以访问。这个是必须设置的。

当你想要启动 erlang 系统与其它 erlang 系统通信时，你需要给 erlang 系统一个名称，例如：

$erl -sname my_name
在后面你还会看到更加详细的内容。如果你想尝试一下分布式 Erlang 系统，而又只有一台计算机，你可以在同一台计算机上分别启动两个 Erlang 系统，并分别赋予不同的名称即可。运行在每个计算机上的 Erlang 被称为一个 Erang 结点（Erlang Node）。

（注意：erl -sname 要求所有的结点在同一个 IP 域内。如果我们的 Erlang 结点位于不同的 IP 域中，则我们需要使用 -name，而且需要指定所有的 IP 地址。）

下面这个修改后的 ping pong 示例程序可以分别运行在两个结点之上：

-module(tut17).

-export([start_ping/1, start_pong/0,  ping/2, pong/0]).

ping(0, Pong_Node) ->
    {pong, Pong_Node} ! finished,
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
        finished ->
            io:format("Pong finished~n", []);
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,
            pong()
    end.

start_pong() ->
    register(pong, spawn(tut17, pong, [])).

start_ping(Pong_Node) ->
    spawn(tut17, ping, [3, Pong_Node]).
我们假设这两台计算分别称之为 gollum 与 kosken。在 kosken 上启动结点 ping。在 gollum 上启动结点 pong。

在 kosken 系统上（Linux/Unix 系统）：

kosken> erl -sname ping
Erlang (BEAM) emulator version 5.2.3.7 [hipe] [threads:0]

Eshell V5.2.3.7  (abort with ^G)
(ping@kosken)1>
在 gollum 上：

gollum> erl -sname pong
Erlang (BEAM) emulator version 5.2.3.7 [hipe] [threads:0]

Eshell V5.2.3.7  (abort with ^G)
(pong@gollum)1>
下面，在 gollum 上启动 "pong" 进程：

(pong@gollum)1> tut17:start_pong().
true
然后在 kosken 上启动 “ping” 进程（从上面的代码中可以看出，start_ping 的函数的其中一个参数为 “pong” 进程所在结点的名称）：

(ping@kosken)1> tut17:start_ping(pong@gollum).
<0.37.0>
Ping received pong
Ping received pong 
Ping received pong
ping finished
如上所示，ping pong 程序已经开始运行了。在 “pong” 的这一端：

(pong@gollum)2>
Pong received ping                 
Pong received ping                 
Pong received ping                 
Pong finished                      
(pong@gollum)2>
再看一下 tut17 的代码，你可以看到 pong 函数根本就没有发生任何改变，无论 “ping” 进程运行在哪个结点下，下面这一行代码都可以正确的工作：

{ping, Ping_PID} ->
    io:format("Pong received ping~n", []),
    Ping_PID ! pong,
因此，Erlang 的进程标识符中包含了程序运行在哪个结点上的位置信息。所以，如果你知道了进程的进程标识符，无论进程是运行在本地结点上还是其它结点上面，"!" 操作符都可以将消息发送到该进程。

要想通过进程注册的名称向其它结点上的进程发送消息，这时候就有一些不同之处了：

{pong, Pong_Node} ! {ping, self()},
这个时候，我们就不能再只用 registered_name 作为参数了，而需要使用元组 {registered_name,node_name} 作为注册进程的名称参数。

在之前的代码中了，“ping”、“pong” 进程是在两个独立的 Erlang 结点上通过 shell 启动的。 spawn 也可以在其它结点（非本地结点）启动新的进程。

下面这段示例代码也是一个 ping pong 程序，但是这一次 “ping” 是在异地结点上启动的：

-module(tut18).

-export([start/1,  ping/2, pong/0]).

ping(0, Pong_Node) ->
    {pong, Pong_Node} ! finished,
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
        finished ->
            io:format("Pong finished~n", []);
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,
            pong()
    end.

start(Ping_Node) ->
    register(pong, spawn(tut18, pong, [])),
    spawn(Ping_Node, tut18, ping, [3, node()]).
假设在 Erlang 系统 ping 结点（注意不是进程 “ping”）已经在 kosken 中启动（译注：可以理解 Erlang 结点已经启动），则在 gollum 会有如下的输出：

<3934.39.0>
Pong received ping
Ping received pong
Pong received ping
Ping received pong
Pong received ping
Ping received pong
Pong finished
ping finished
注意所有的内容都输出到了 gollum 结点上。这是因为 I/O 系统发现进程是由其它结点启动的时候，会自将输出内容输出到启动进程所在的结点。