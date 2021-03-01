file 文件接口模块

file:advise/4
对文件数据预声明一个访问模式

用法：

advise(IoDevice, Offset, Length, Advise) -> ok | {error, Reason}
函数 file:advise/4 经常用来对一个文件的数据预声明一个指定的模式来访问，从而可以让操作系统进行一些适当的优化（在某些操作系统无效）。

参数 Advise 的选项有：normal、sequential、ranDOM。

{ok, File} = file:open("./rebar.config", read),
file:advise(File, 10, 10, normal).

----------
