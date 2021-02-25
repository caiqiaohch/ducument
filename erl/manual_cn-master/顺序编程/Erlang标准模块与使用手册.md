Erlang标准模块与使用手册

Erlang 有大量的标准模块可供使用。例如，IO 模块中包含大量处理格式化输入与输出的函数。如果你需要查看标准模块的详细信息，可以在操作系统的 shell 或者命令行（即开始 erl 的地方）使用 erl -man 命令来查看。示例如下：

% erl -man io
ERLANG MODULE DEFINITION                                    io(3)

MODULE
     io - Standard I/O Server Interface Functions

DESCRIPTION
     This module provides an  interface  to  standard  Erlang  IO
     servers. The output functions all return ok if they are suc-
     ...
如果在系统上执行命令不成功，你也可以使用 Erlang/OTP 的在线文档。 在线文件也支持以 PDF 格式下载。在线文档位置在 www.erlang.se (commercial Erlang) 或 www.erlang.org (open source)。例如，Erlang/OTP R9B 文档位于：

Http://www.erlang.org/doc/r9b/doc/index.HTML