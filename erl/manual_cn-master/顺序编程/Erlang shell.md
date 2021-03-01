Erlang shell
绝大多数操作系统都有命令解释器或者外壳 (shell)，Unix 与 Linux 系统中有很多不同的 shell， windows 系统上也有命令行提示。 Erlang 自己的 shell 中可以直接编写 Erlang 代码，并被执行输出执行后的效果（可以参考 STDLIB 中 shell 手册)。

在 Linux 或 Unix 操作系统中先启动一个 shell 或者命令解释器，再输入 erl 命令即可启动 erlang 的 shell。启动 Erlang 的 shell 之后，你可以看到如下的输出效果:

% erl
Erlang R15B (erts-5.9.1) [source] [smp:8:8] [rq:8] [async-threads:0] [hipe] [kernel-poll:false]

Eshell V5.9.1  (abort with ^G)
1>
在 shell 中输入 "2+5." 后，再输入回车符。请注意，输入字符 "." 与回车符的目的是告诉 shell 你已经完成代码输入。

1> 2 + 5.
7
2>
如上所示，Erlang 给所有可以输入的行标上了编号（例如，>1，>2），上面的例子的意思就是 2+5 结果为 7。如果你在 shell 中输入错误的内容，则可以使用回退键将其删除，这一点与绝大多数 shell 是一样的。在 shell 下有许多编辑命令（ 参考 ERTS 用户指南中的 tty - A command line interface 文档）。

（请注意，下面的这些示例中所给出的 shell 行号很多都是乱序的。这是因为这篇教程中的示例都是单独的测试过程，而非连续的测试过程，所以会出现编号乱序的情况）。

下面是一个更加复杂的计算：

2> (42 + 77) * 66 / 3.
2618.0
请注意其中括号的使用，乘法操作符 “*” 与除法操作符 “/” 与一般算术运算中的含义与用法完全相同。(参见 表达式)。

输入 Ctrl 与 C 键可以停止 Erlang 系统与交互式命令行（shell）。

下面给出输入 Ctrl-C 后的输出结果：

BREAK: (a)bort (c)ontinue (p)roc info (i)nfo (l)oaded
       (v)ersion (k)ill (D)b-tables (d)istribution
a
%
输入 “a” 可以结束 Erlang 系统。

关闭 Erlang 系统的另一种途径则是通过输入 halt() :

3> halt().
%