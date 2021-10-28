



# 参数(Arguments)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

## **启动参数**

在启动vim时，可以指定多个文件做为参数，例如以下操作系统命令将打开多个文件，并显示第一个文件：

```bash
vim file1.txt file2.txt file3.txt
```

参数（Arguments）和[缓冲区（Buffer）](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-13-MultiBuffers.html)是不同的概念。早在Vi之中，就存在参数概念；而缓冲区则是在Vim之中新引进的。参数列表中的所有文件名，都会同时存在于缓冲区列表之中；但并不是所有缓冲区列表中的文件名，也都会出现在参数列表之中。

例如在启动vim之后，我们使用以下命令打开并编辑文件4：

```vim
:e file4.txt
```

此时显示以下3个参数：



![img](https://pic1.zhimg.com/80/v2-da8b1caf4dd140c20b11a754ae943f08_720w.jpg)



而缓冲区则为4个：



![img](https://pic4.zhimg.com/80/v2-7788255483bc99f838fd636eb8e08b47_720w.jpg)



## **参数列表**

命令`:args`可以列示打开的多个文件，并用中括号“[]”标识出正在编辑的文件名。

![img](https://pic4.zhimg.com/80/v2-45c2ccc1f3ff9f428705cb51bf6cc34b_720w.jpg)

## **切换多个文件**

可以使用:argument命令，直接切换到指定的文件。例如以下命令，将切换至列表中的第三个文件：

```vim
:argument 3
```

需要切换到下一个文件时，可以输入`:next`命令，如果你没有保存当前文件的修改，vim将给出提示信息，不允许切换到下一文件。输入`:write`和`:next`命令，则可以保存并切换到第二个文件（此命令也可简写为`:wnext`）。

使用`:next!`命令，可以强制切换到第二个文件，但所做改动也将会丢失。使用`:set autowrite`命令打开自动保存功能，可以避免数据丢失的意外情况；而命令`:set noautowrite`则可以关闭自动保存功能。

如果想要回到上一个文件，可以使用`:previous`或是`:Next`命令。如果要保存当前文件并切换到前一文件，可以使用`:wprevious`或是`:wNext`命令。

使用快捷键**ctrl+^**可以快速切换到上一个文件，以实现在#（current filename）和 %（alternate filename）文件之间快速切换的目的。

使用`:first`或`:rewind`命令，可以快速切换到第一个文件；而`:last`命令，则可以快速切换到最后一个文件。

![img](https://pic2.zhimg.com/80/v2-4949add0c262de9bb2dd63ff029e3de1_720w.jpg)



编辑于 2018-07-17