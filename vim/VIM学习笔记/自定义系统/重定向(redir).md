# 重定向(redir)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

## **重定向到文件**

使用以下命令，在将信息输出到屏幕的同时，也会保存到指定的文件中：

```vim
:redir > {file}
```

如果指定的文件以及存在，那么需要使用!参数进行强制覆盖：

```vim
:redir! > {file}
```

如果希望信息被追加到文件末尾，那么可以使用以下命令：

```vim
:redir >> {file}
```

假设需要查询大量的信息输出（例如:version命令），或者保存调试信息，那么信息重定向就会非常有价值。

使用以下命令，可以停止信息的重定向：

```vim
:redir END
```

## **重定向到寄存器**

我们可以将信息输出重定至[寄存器](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-12-Register.html)之中，比如剪贴板寄存器（+）、命名寄存器（a-z,A-Z）和未命名寄存器（"）。

使用以下命令，可以将信息输出重定向至剪贴板寄存器：

```vim
:redir @+
```

这样您就可以使用`"+p`命令， 将信息输出粘贴到当前文本。

使用以下命令，可以将命令历史记录粘贴到当前文件中：

```vim
:redir @+
:set nomore
:history
:put +
:set more
:redir END
```

其中，`:set nomore`命令用于暂定显示“--More--”信息，否则在分页显示命令历史记录时，需要点击按键以继续下一页的显示。

使用以下命令，可以查看更多帮助信息：

```vim
:help :redir
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-message.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-01-History.html)>

发布于 2020-07-24