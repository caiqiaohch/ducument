# 生成标签文件(Generates Tags File)

[![YYQ](https://pic4.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

2 人赞同了该文章

本节将介绍如何使用Ctag工具，来扫描代码库并生成包含关键词索引的标签文件（Tags File）。基于标签文件，Vim可以在标签之间快速跳转，并可以针对[标签自动补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-tag)。

## Ctags

[Ctags](https://link.zhihu.com/?target=http%3A//ctags.sourceforge.net/)是一个开源的命令行工具，用于从代码中索引标签（比如method, class, function等）并生成tags文件。

目前Ctags支持包括Vim在内的41种[编程语言](https://link.zhihu.com/?target=http%3A//ctags.sourceforge.net/languages.html)。对于vimscript脚本，其中的functions, class, commands, menu, map, variable等语法，将会作为关键字被索引至tags文件中。

对于Mac操作系统，您可以使用包管理器[Homebre](https://link.zhihu.com/?target=https%3A//brew.sh/)进行安装：

```bash
$ brew install ctags
```

对于Linux操作系统，您可以使用相应的包管理器进行安装：

```bash
$ sudo yum install ctags
```

对于Windows操作系统，您可以直接将[可执行文件](https://link.zhihu.com/?target=https%3A//sourceforge.net/projects/ctags/files/ctags/)放置在 PATH 环境变量指定的目录之内；也可以使用包管理器[Chocolatey](https://link.zhihu.com/?target=https%3A//chocolatey.org/)进行安装：

```bash
$ choco install ctags
```

您可以在操作系统的命令行中使用以下命令，来验证ctags是否安装成功，并获得相关的帮助信息：

```bash
$ ctags --help
```

在Vim中使用以下命令，可以针对指定的文件生成tags文件：

```vim
:!ctags filename 
```

你也可以针对当前目录及其子目录中的所有文件生成tags文件：

```vim
:!ctags -R .
```

## 标签文件（Tags File）

默认生成的标签文件，是名为tags的文本文件。其开头包含若干行元数据，之后每行包含一个关键字以及与之匹配的文件名和位置信息。其中的关键字，按字母排序；并且以正则表达式作为定位信息。

![img](https://pic4.zhimg.com/80/v2-c6dc32fdb60a83476a1771af9459f73f_720w.jpg)

你可以使用`:help tags-file-format`命令，查看标签文件的格式说明。

## 自动生成标签文件

利用[自动命令](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-49-01-autocmd.html)（autocmd），可以在保存文件时自动更新tags文件：

```vim
:autocmd BufWritePost * call system("ctags -R")
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-49-01-autocmd.html)>

发布于 2020-02-15