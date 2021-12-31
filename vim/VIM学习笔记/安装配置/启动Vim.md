# VIM学习笔记 启动Vim(Starting)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

## **启动命令**

我们通常使用 vim [arguments] [file ..] 的形式，使用指定的选项打开指定的文件。例如使用以下命令，以只读模式打开virmc配置文件：

```bash
$ vim -R .vimrc
```

## **命令参数**

在操作系统中执行以下命令，可以查看完整的命令行参数列表：

```bash
$ vim --help
```

![img](https://pic4.zhimg.com/80/v2-7036bcd1b9de139cb762ea385b480f87_720w.jpg)

## **命令变体**

Vim编辑器实际上是一个有着不同的名字或链接的文件，执行以下不同的命令，就可以使编辑器在不同的模式下启动：

![img](https://pic2.zhimg.com/80/v2-71cd1d5d6fa3371880fec9607096cc01_720w.jpg)

## **操作实例**

例如，需要将多个文件中的字符串-person-替换成Jones：如果是手工方式，那么就需要打开多个文件进行重复操作；而利用命令行参数，则可以进行自动化地批处理。

首先，将以下命令保存为change.vim文件：

```vim
:%s/-person-/Jones/g
:write
:quit
```

然后，在操作系统中执行以下命令，以ex模式运行Vim，进行替换操作：

```bash
$ vim -es file.txt<change.vim 
```