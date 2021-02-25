Erlang 头文件

Erlang头文件
如上所示，某些文件的扩展名为 .hrl。这些是在 .erl 文件中会用到的头文件，使用方法如下：

-include("File_Name").
例如：

-include("mess_interface.hrl").
在本例中，上面所有的文件与 messager 系统的其它文件在同一个目录下。

.hrl 文件中可以包含任何合法的 Erlang 代码，但是通常里面只包含一些记录和宏的定义。