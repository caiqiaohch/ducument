# 比较文件(diff)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

8 人赞同了该文章

Vim通过调用外部的diff命令，可以对相似的文件进行比较。使用`:help diff`命令，可以查看关于比较文件的更多信息。

## **配置**

在Windows系统下，请确认diff.exe已经存在于vim目录之下；并且在操作系统的PATH变量中，也包含了该目录：

![img](https://pic3.zhimg.com/80/v2-e252f88c5eb9b2d86478935efee4a72e_720w.png)

为了避免[配色方案](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-62-ColorScheme.html)对比较结果显示效果的影响，我们可以在[vimrc配置文件](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)中，增加以下命令，以便在比较文件时使用默认的显示颜色：

```vim
 	au FilterWritePre * if &diff | colorscheme default | endif
	if &diff
	  colorscheme default
	endif
```

## **比较**

可以从命令行调用以下命令，来打开两个文件进行比较：

```
vim -d file1 file2
```

如果已经打开了文件file1，那么可以在Vim中用以下命令，再打开另一个文件file2进行比较：

```
:diffsplit file2
```

如果已经使用split打开了两个文件，那么可以分别在两个窗口里面输入以下命令，进行比较：

```
:diffthis
```

屏幕将被水平分隔，分别显示一个文件，其中不同的部分将被高亮显示。

- 只在某一文件中存在的行，显示为蓝色；
- 而在另一文件中的对应位置的行，显示为绿色；
- 在两个文件中都存在的行，显示为紫色
- 行中不相同的字符，显示为红色；
- 相同的行，没有高亮显示并且会被折叠。

如果想要垂直比较两个文件，可以使用以下命令：

```
:vert diffsplit file2
```

![img](https://pic2.zhimg.com/80/v2-acc692ec7e180642615def68c689c54d_720w.jpg)

## **折叠**

使用`zo`命令，可以展开被折叠的相同的文本行；而`zc`命令，则可以重新折叠相同的行。

## **查看**

比较文件时，经常需要结合上下文来确定最终要采取的操作。缺省情况下，是会把不同之处上下各6行的文本显示出来以供参考。其他的相同的文本行被自动折叠。如果希望修改缺省的上下文行数为3行，可以使用以下命令：

```
:set diffopt=context:3
```

## **滚动**

如果你在一个文件中滚动屏幕，那么另一个文件也会自动滚动以显示相同的位置。你可以使用以下命令，取消联动：

```
:set noscrollbind
```

使用以下命令，将重新绑定联动：

```
:set scrollbind
```

利用以下命令，可以定义滚动方式：

```
:set scrollopt ver,hor,jump
```

其中：选项*ver* ，启用垂直同步滚动；选项*hor* ，启用水平同步滚动；而*jump* 选项，则在切换窗口时，使垂直滚动始终同步。

如果光标停留在两个文件的不同位置，那么可以使用下面的命令同步滚动：

```
:syncbind
```

## **更新**

如果更改了某个文件的内容，vim又没有自动更新diff检查，那么可以使用如下命令更新：

```
:diffupdate
```

## **跳转**

你可以用`[c`命令；跳转到前一个不同点；或者用`]c`命令，跳转到后一个不同点。

编辑于 2019-04-20