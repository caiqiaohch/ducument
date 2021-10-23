# Ex脚本 (Ex Script)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

6 人赞同了该文章

如果希望一次性执行多条Ex命令，那么可以将这些命令保存为脚本文件，然后即可重复调用。

例如我的这个[VIM学习笔记](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)，都是在Vim里手工编写HTML代码的。相同的代码也会同步粘贴到我的[blog](https://link.zhihu.com/?target=https%3A//yyq123.blogspot.com/)里。而在搬运代码之前，我需要删除其中的Tab制表符和换行符。也就是说，我需要重复执行几个删除和替换命令。

![img](https://pic2.zhimg.com/80/v2-6306c3db71eab500f465746084595ac5_720w.jpg)

## **创建脚本文件**

我将以下命令，存储名为[ExScript_Sample.vim](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/samples/ExScript_Sample.vim)的脚本文件。其中，所有以双引号（"）开头的文本，都将被视为注释。注释可以单独为一行，也可以被放置在行的末尾。

![img](https://pic4.zhimg.com/80/v2-32177d349bf4f7aca94b65e9d815abab_720w.jpg)

## **在Vim中执行脚本文件**

在Vim中编辑文件时，可以使用以下命令来调用Ex脚本：

```vim
:source ExScript_Sample.vim
```

Vim将在屏幕底部显示命令执行的结果（比如修改或替换的行数等）；点击Enter回车键，将返回常规模式：

![img](https://pic2.zhimg.com/80/v2-f7682ef3b02692cf1dfd1a0359a5e0b1_720w.jpg)

如果您对执行结果不满意，那么也可以使用`u`命令，[撤销 (Undo)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-06-Undo.html)以上操作。

在启动vim时，可以将文件名做为[参数(Arguments)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-16-MultiArguments.html)，以打开多个文件。例如使用以下操作系统命令，将打开当前目录下的所有网页文件：

```bash
$ vim *.html
```

我们可以先在当前文件下，使用`:source`命令执行脚本；然后使用`:next`命令，切换到下一个文件，依次针对各个文件分别执行脚本。

而使用以下命令，则可以一次性对所有参数列表中的文件执行脚本：

```vim
:argdo source ExScript_Sample.vim
```

## **在命令行中执行脚本文件**

在操作系统的命令行中，使用vim的-c选项，可以在加载文件之后自动执行Ex脚本文件：

```bash
$ vim -c "source ExScript_Sample.vim" test.html
```

利用竖直线“|”分割符，可以[组合执行](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-48-02-ExCommand-Run.html)Ex脚本文件和Ex命令：

```bash
$ vim -c "source ExScript_Sample.vim | w" test.html
```

利用竖直线“|”分割符和argdo命令，可以针对多个文件分别执行脚本文件，然后保存并退出：

```bash
$ vim -c "argdo source ExScript_Sample.vim | w" -c "qa" A.html B.html C.html 
```



发布于 2019-09-06