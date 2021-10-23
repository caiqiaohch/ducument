# 文本排序(sort)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

12 人赞同了该文章

Vim内置了针对文本进行排序的`:sort`命令。你可以使用`:help :sort`命令，查看详细的帮助信息。

请注意，Vim内置的sort命令与Linux系统下的[!sort](https://link.zhihu.com/?target=https%3A//tldr.ostera.io/sort)命令并非完全一致。

## 文本行排序

使用以下命令，可以针对指定行范围内的文本进行排序：

```vim
:3,16sort
```

如下图所示，将第3至16行内的CSS属性进行排序：

![img](https://pic2.zhimg.com/80/v2-04a5b05aa258e85e429f769c9ed2a6a1_720w.jpg)

在可视化模式下选中文本，然后执行以下命令可以对选择的文本进行排序：

```vim
:'<,'>sort
```

使用以下命令，将在排序时去除重复的行。对于重复的多行，将仅仅保留第一行，而其它的行将被删除。

```vim
:%sort u
```

使用以下命令，可以针对所有文本进行倒序排序：

```vim
:%sort!
```

使用以下命令，将按照数字进行排序：

```vim
:%sort n
```

组合以上命令，则可以按照数字倒序排序：

```vim
:%sort! n
```

![img](https://pic2.zhimg.com/80/v2-c089520e1e6ef8edecc5c9634e332205_720w.jpg)

## 文本块排序

假设我们需要对以下文本进行排序。其中，每个条目是被“.KS”和“.KE”包围的文本块；而其定义的每个术语则是以“.IP”开头的多行文字。

![img](https://pic4.zhimg.com/80/v2-d48241be5b6a3a41f2fc7f3fc0ae59d3_720w.jpg)

如果我们希望按术语进行排序，那么可以通过合并行将文本块整合为一个整体，然后进行排序；稍后再重新拆分行，来恢复原有的文本格式。具体步骤如下：

1）将换行符替换为“@@”字符：

```
:g/^\.KS/,/^\.KE/-1s/$/@@/
.KS@@
.IP "TTY_ARGV" 2n@@
The command, specified as an argument vector,@@
that the TTY subwindow executes.@@
.KE
.KS@@
.IP "ICON_IMAGE" 2n@@
Sets or gets the remote image for icon's image.@@
.KE
.KS@@
.IP "XV_LABEL" 2n@@
Specifies a frame's header or an icon's label.@@
.KE
.KS@@
.IP "SERVER_SYNC" 2n@@
Synchronizes with the server once.@@
Does not set synchronous mode.@@
.KE	
```

2）以“.KS”和“.KE”作为首尾标记来合并行：

```
:g/^\.KS/,/^\.KE/j
.KS@@ .IP "TTY_ARGV" 2n@@ The ... vector,@@ ... .@@ .KE
.KS@@ .IP "ICON_IMAGE" 2n@@ Sets or gets ... image.@@ .KE
.KS@@ .IP "XV_LABEL" 2n@@ Specifies a ... an icon's label.@@ .KE
.KS@@ .IP "SERVER_SYNC" 2n@@ Synchronizes with ... mode.@@ .KE	
	
```

3）对文本排序：

```
:%sort
.KS@@ .IP "ICON_IMAGE" 2n@@ Sets or gets ... image.@@ .KE
.KS@@ .IP "SERVER_SYNC" 2n@@ Synchronizes with ... mode.@@ .KE	
.KS@@ .IP "TTY_ARGV" 2n@@ The ... vector,@@ ... .@@ .KE
.KS@@ .IP "XV_LABEL" 2n@@ Specifies a ... an icon's label.@@ .KE
	
```

4）将“@@ ”字符重新替换为换行符，以恢复原有格式：

```
:%s/@@ /^M/g
.KS
.IP "ICON_IMAGE" 2n
Sets or gets the remote image for icon's image.
.KE
.KS
.IP "SERVER_SYNC" 2n
Synchronizes with the server once.
Does not set synchronous mode.
.KE
.KS
.IP "TTY_ARGV" 2n
The command, specified as an argument vector,
that the TTY subwindow executes.
.KE
.KS
.IP "XV_LABEL" 2n
Specifies a frame's header or an icon's label.
.KE
```

通过以上全局替换命令和排序命令，对文档中的特定术语进行了排序，而且保持格式不变。请注意：

- 为了缩短实例文字的长度，我们使用“...”来表示省略的文字；
- 在第2步使用`j`命令合并行时，自动新增了一个空格；所以在第3步的替换命令中，需要查找“@@”字符以及紧随其后的一个空格；
- 第4步命令中的“^M”，是使用Ctrl-V和Ctrl-M键输入的；如果Ctrl-V键已经被占用，那么可以使用Ctrl-Q键来替代。

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-22-LineFeed.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-23-Wrap.html)>