# 接入Erlang控制台的几种方法

rpc:call(Node, Mod, Func, [Arg1, Arg2, ..., ArgN])会在Node上执行一次远程过程调用。调用的函数是Mod:Func(Arg1, Arg2, ..., ArgN)。

参数-sname gandalf的意思是“在本地主机上启动一个名为gandalf的Erlang节点”。
注意一下Erlang shell是如何把Erlang节点名打印在命令提示符前面的。节点名的形式是Name@Host。
Name和Host都是原子，所以如果它们包含任何非原子的字符，就必须加上引号。
$erl -sname gandalf

