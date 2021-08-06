# Erlang宏


在 messager 系统添加的另外一种东西是宏。在 mess_config.hrl 文件中包含如下的定义：

%%% Configure the location of the server node,
-define(server_node, messenger@super).
这个头文件被包括到了 mess_server.erl 文件中：

-include("mess_config.hrl").
这样，在 mess_server.erl 中出现的每个 server_node 都被替换为 messenger@super。

宏还被用于生成服务端进程：

spawn(?MODULE, server, [])
这是一个标准宏（也就是说，这是一个系统定义的宏而不是用户自定义的宏）。?MODULE 宏总是被替换为当前模块名（也就是在文件开始的部分的 -module 定义的名称）。宏有许多的高级用法，作为参数只是其中之一。

Messager 系统中的三个 Erlang（.erl）文件被分布编译成三个独立的目标代码文件（.beam）中。当执行过程中引用到这些代码时，Erlang 系统会将它们加载并链接到系统中。在本例中，我们把它们全部放到当前工作目录下（即你执行 "cd" 命令后所在的目录）。我们也可以将这些文件放到其它目录下。

在这个 messager 例子中，我们没有对发送消息的内容做出任何假设和限制。这些消息可以是任何合法的 Erlang 项。