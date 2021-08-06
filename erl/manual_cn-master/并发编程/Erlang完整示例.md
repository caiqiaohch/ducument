# Erlang完整示例


接下来这个示例是一个简单的消息传递者（messager）示例。Messager 是一个允许用登录到不同的结点并向彼此发送消息的应用程序。

开始之前，请注意以下几点：

这个示例只演示了消息传递的逻辑---没有提供用户友好的界面（虽然这在 Erlang 是可以做到的）。
这类的问题使用 OTP 的工具可以非常方便的实现，还能同时提供线上更新的方法等。（参考 OTP 设计原则）
这个示例程序并不完整，它没有考虑到结点离开等情况。这个问题在后面的版本会得到修复。
Messager 允许 “客户端” 连接到集中的服务器并表明其身份。也就是说，用户并不需要知道另外一个用户所在 Erlang 结点的名称就可以发送消息。

messager.erl 文件内容如下：

%%% Message passing utility.  
%%% User interface:
%%% logon(Name)
%%%     One user at a time can log in from each Erlang node in the
%%%     system messenger: and choose a suitable Name. If the Name
%%%     is already logged in at another node or if someone else is
%%%     already logged in at the same node, login will be rejected
%%%     with a suitable error message.
%%% logoff()
%%%     Logs off anybody at that node
%%% message(ToName, Message)
%%%     sends Message to ToName. Error messages if the user of this 
%%%     function is not logged on or if ToName is not logged on at
%%%     any node.
%%%
%%% One node in the network of Erlang nodes runs a server which maintains
%%% data about the logged on users. The server is registered as "messenger"
%%% Each node where there is a user logged on runs a client process registered
%%% as "mess_client" 
%%%
%%% Protocol between the client processes and the server
%%% ----------------------------------------------------
%%% 
%%% To server: {ClientPid, logon, UserName}
%%% Reply {messenger, stop, user_exists_at_other_node} stops the client
%%% Reply {messenger, logged_on} logon was successful
%%%
%%% To server: {ClientPid, logoff}
%%% Reply: {messenger, logged_off}
%%%
%%% To server: {ClientPid, logoff}
%%% Reply: no reply
%%%
%%% To server: {ClientPid, message_to, ToName, Message} send a message
%%% Reply: {messenger, stop, you_are_not_logged_on} stops the client
%%% Reply: {messenger, receiver_not_found} no user with this name logged on
%%% Reply: {messenger, sent} Message has been sent (but no guarAntee)
%%%
%%% To client: {message_from, Name, Message},
%%%
%%% Protocol between the "commands" and the client
%%% ----------------------------------------------
%%%
%%% Started: messenger:client(Server_Node, Name)
%%% To client: logoff
%%% To client: {message_to, ToName, Message}
%%%
%%% Configuration: change the server_node() function to return the
%%% name of the node where the messenger server runs

-module(messenger).
-export([start_server/0, server/1, logon/1, logoff/0, message/2, client/2]).

%%% Change the function below to return the name of the node where the
%%% messenger server runs
server_node() ->
    messenger@bill.

%%% This is the server process for the "messenger"
%%% the user list has the format [{ClientPid1, Name1},{ClientPid22, Name2},...]
server(User_List) ->
    receive
        {From, logon, Name} ->
            New_User_List = server_logon(From, Name, User_List),
            server(New_User_List);
        {From, logoff} ->
            New_User_List = server_logoff(From, User_List),
            server(New_User_List);
        {From, message_to, To, Message} ->
            server_transfer(From, To, Message, User_List),
            io:format("list is now: ~p~n", [User_List]),
            server(User_List)
    end.

%%% Start the server
start_server() ->
    register(messenger, spawn(messenger, server, [[]])).

%%% Server adds a new user to the user list
server_logon(From, Name, User_List) ->
    %% check if logged on anywhere else
    case lists:keymember(Name, 2, User_List) of
        true ->
            From ! {messenger, stop, user_exists_at_other_node},  %reject logon
            User_List;
        false ->
            From ! {messenger, logged_on},
            [{From, Name} | User_List]        %add user to the list
    end.

%%% Server deletes a user from the user list
server_logoff(From, User_List) ->
    lists:keydelete(From, 1, User_List).

%%% Server transfers a message between user
server_transfer(From, To, Message, User_List) ->
    %% check that the user is logged on and who he is
    case lists:keysearch(From, 1, User_List) of
        false ->
            From ! {messenger, stop, you_are_not_logged_on};
        {value, {From, Name}} ->
            server_transfer(From, Name, To, Message, User_List)
    end.
%%% If the user exists, send the message
server_transfer(From, Name, To, Message, User_List) ->
    %% Find the receiver and send the message
    case lists:keysearch(To, 2, User_List) of
        false ->
            From ! {messenger, receiver_not_found};
        {value, {ToPid, To}} ->
            ToPid ! {message_from, Name, Message}, 
            From ! {messenger, sent} 
    end.

%%% User Commands
logon(Name) ->
    case whereis(mess_client) of 
        undefined ->
            register(mess_client, 
                     spawn(messenger, client, [server_node(), Name]));
        _ -> already_logged_on
    end.

logoff() ->
    mess_client ! logoff.

message(ToName, Message) ->
    case whereis(mess_client) of % Test if the client is running
        undefined ->
            not_logged_on;
        _ -> mess_client ! {message_to, ToName, Message},
             ok
end.

%%% The client process which runs on each server node
client(Server_Node, Name) ->
    {messenger, Server_Node} ! {self(), logon, Name},
    await_result(),
    client(Server_Node).

client(Server_Node) ->
    receive
        logoff ->
            {messenger, Server_Node} ! {self(), logoff},
            exit(normal);
        {message_to, ToName, Message} ->
            {messenger, Server_Node} ! {self(), message_to, ToName, Message},
            await_result();
        {message_from, FromName, Message} ->
            io:format("Message from ~p: ~p~n", [FromName, Message])
    end,
    client(Server_Node).

%%% wait for a response from the server
await_result() ->
    receive
        {messenger, stop, Why} -> % Stop the client 
            io:format("~p~n", [Why]),
            exit(normal);
        {messenger, What} ->  % Normal response
            io:format("~p~n", [What])
    end.
在使用本示例程序之前，你需要：

配置 server_node() 函数。
将编译后的代码（messager.beam）拷贝到每一个你启动了 Erlang 的计算机上。
这接下来的例子中，我们在四台不同的计算上启动了 Erlang 结点。如果你的网络没有那么多的计算机，你也可以在同一台计算机上启动多个结点。

启动的四个结点分别为：messager@super，c1@bilo，c2@kosken，c3@gollum。

首先在 meesager@super 上启动服务器程序：

(messenger@super)1> messenger:start_server().
true
接下来用 peter 是在 c1@bibo 登录：

(c1@bilbo)1> messenger:logon(peter).
true
logged_on
然后 James 在 c2@kosken 上登录：

(c2@kosken)1> messenger:logon(james).
true
logged_on
最后，用 Fred 在 c3@gollum 上登录：

(c3@gollum)1> messenger:logon(fred).
true
logged_on
现在，Peter 就可以向 Fred 发送消息了：

(c1@bilbo)2> messenger:message(fred, "hello").
ok
sent
Fred 收到消息后，回复一个消息给 Peter 然后登出：

Message from peter: "hello"
(c3@gollum)2> messenger:message(peter, "go away, I'm busy").
ok
sent
(c3@gollum)3> messenger:logoff().
logoff
随后，James 再向 Fred 发送消息时，则出现下面的情况：

(c2@kosken)2> messenger:message(fred, "peter doesn't like you").
ok
receiver_not_found
因为 Fred 已经离开，所以发送消息失败。

让我们先来看看这个例子引入的一些新的概念。

这里有两个版本的 server_transfer 函数：其中一个有四个参数（server_transfer/4）另外一个有五个参数（server_transfer/5）。Erlang 将它们看作两个完全不一样的函数。

请注意这里是如何让 server_transfer 函数通过 server(User_List) 调用其自身的，这里形成了一个循环。 Erlang 编译器非常的聪明，它会将上面的代码优化为一个循环而不是一个非法的递规函数调用。但是它只能是在函数调用后面没有别的代码的情况下才能工作（注：即尾递规）。

示例中用到了lists 模块中的函数。lists 模块是一个非常有用的模块，推荐你通过用户手册仔细研究一下（erl -man lists）。

lists:keymemeber(Key,Position,Lists) 函数遍历列表中的元组，查看每个元组的指定位置 （Position）处的数据并判断元组该位置是否与 Key 相等。元组中的第一个元素的位置为 1，依次类推。如果发现某个元组的 Position 位置处的元素与 Key 相同，则返回 true，否则返回 false。

3> lists:keymember(a, 2, [{x,y,z},{b,b,b},{b,a,c},{q,r,s}]).
true
4> lists:keymember(p, 2, [{x,y,z},{b,b,b},{b,a,c},{q,r,s}]).
false
lists:keydelete 与 lists:keymember 非常相似，只不过它将删除列表中找到的第一个元组（如果存在），并返回剩余的列表：

5> lists:keydelete(a, 2, [{x,y,z},{b,b,b},{b,a,c},{q,r,s}]).
[{x,y,z},{b,b,b},{q,r,s}]
lists:keysearch 与 lists:keymember 类似，但是它将返回 {value,Tuple_Found} 或者原子值 false。

lists 模块中还有许多非常有用的函数。

Erlang 进程（概念上地）会一直运行直到它执行 receive 命令，而此时消息队列中又没有它想接收的消息为止。
这儿，“概念上地” 是因为 Erlang 系统活跃的进程实际上是共享 CPU 处理时间的。

当进程无事可做时，即一个函数调用 return 返回而没有调用另外一个函数时，进程就结束。另外一种终止进程的方式是调用 exit/1 函数。exit/1 函数的参数是有特殊含义的，我们稍后会讨论到。在这个例子中使用 exit(normal) 结束进程，它与程序因没有再调用函数而终止的效果是一样的。

内置函数 whereis(RegisteredName) 用于检查是否已有一个进程注册了进程名称 RegisteredName。如果已经存在，则返回进程 的进程标识符。如果不存在，则返回原子值 undefined。

到这儿，你应该已经可以看懂 messager 模块的大部分代码了。让我们来深入研究将一个消息从一个用户发送到另外一个的详细过程。

当第一个用户调用 “sends” 发送消息时：

messenger:message(fred, "hello")
首先检查用户自身是否在系统中运行（是否可以查找到 mess_client 进程）：

whereis(mess_client) 
如果用户存在则将消息发送给 mess_client：

mess_client ! {message_to, fred, "hello"}
客户端通过下面的代码将消息发送到服务器：

{messenger, messenger@super} ! {self(), message_to, fred, "hello"},
然后等待服务器的回复。服务器收到消息后将调用：

{messenger, messenger@super} ! {self(), message_to, fred, "hello"},
接下来，用下面的代码检查进程标识符 From 是否在 User_Lists 列表中：

lists:keysearch(From, 1, User_List)
如果 keysearch 返回原子值 false，则出现的某种错误，服务将返回如下消息：

From ! {messenger, stop, you_are_not_logged_on}
client 收到这个消息后，则执行 exit(normal) 然后终止程序。如果 keysearch 返回的是 {value,{From,Nmae}} ，则可以确定该用户已经登录，并其名字（peter）存储在变量 Name 中。

接下来调用：

server_transfer(From, peter, fred, "hello", User_List)
注意这里是函数 server_transfer/5，与其它的 server_transfer/4 不是同一个函数。还会再次调用 keysearch 函数用于在 User_List 中查找与 fred 对应的进程标识符：

lists:keysearch(fred, 2, User_List)
这一次用到了参数 2，这表示是元组中的第二个元素。如果返回的是原子值 false，则说明 fred 已经登出，服务器将向发送消息的进程发送如下消息：

From ! {messenger, receiver_not_found};
client 就会收到该消息。

如果 keysearch 返回值为：

{value, {ToPid, fred}}
则会将下面的消息发送给 fred 客户端：

ToPid ! {message_from, peter, "hello"}, 
而如下的消息会发送给 peter 的客户端：

From ! {messenger, sent} 
Fred 客户端收到消息后将其输出：

{message_from, peter, "hello"} ->
    io:format("Message from ~p: ~p~n", [peter, "hello"])
peter 客户端在 await_result 函数中收到回复的消息。