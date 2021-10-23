# Ex模式 (Ex Mode)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

7 人赞同了该文章

很久很久以前，人们还是使用打印设备而非显示器来与计算机进行沟通。比如打印出某行代码以确定需要修改的内容，然后针对文本进行操作，再次打印以检查变更效果。在此情形之下，行号就成为有效的定位工具。虽然，今天我们已经不再如此依赖打印设备，但是基于行编辑的Ex模式，在操作文本时还是有某些优势的：比如将文本从一个文件移动到另一个文件；快速地对大于单个屏幕的文本块进行编辑；针对整个文件中的特定模式进行全局替换等等。

可以说，Vim是Ex行编辑器的可视模式。或者说，Ex是Vim的底层行编辑器。

## **进入Ex模式**

在操作系统的命令行中，使用以下Ex命令，可以进入Vim的Ex模式：

```bash
$ ex filename
```

![img](https://pic1.zhimg.com/80/v2-94101b65965ea00150366a784e0eb9c4_720w.png)

在Vim的常规模式下，使用`Q`或者`gQ`命令，可以进入Vim的Ex模式：

![img](https://pic2.zhimg.com/80/v2-04fa7f5c516a88597f0f20fb88cafbe9_720w.png)

## **执行Ex命令**

ex命令由行地址和命令组成，并以回车键结束。

如果我们在命令中没有指定行号，那么命令将默认作用于当前行。例如以下命令将在当前行中，将第一个"Hello"替换为"Hi"：

```vim
:s/Hello/Hi
```

请注意，在命令执行之后，受到影响的当前行，将会被重新打印到屏幕上：

![img](https://pic3.zhimg.com/80/v2-0e3d4306384eea445e139a3f515159ea_720w.jpg)

如果我们在命令中指定了行号，那么命令将作用于指定的行范围。例如以下命令将在多行中，将所有"Hello"替换为"Hi"：

```vim
:1,6s/Hello/Hi
```

请注意，在命令执行之后，受到影响的行信息，将会被重新打印到屏幕上：

![img](https://pic2.zhimg.com/80/v2-ab4c1a88ece7f6a9cc04823167baecd9_720w.jpg)

## **退出Ex模式**

使用以下命令，可以退出Ex模式，并进入常规模式：

```vim
:vi
```

使用以下命令，可以退出Ex模式，并返回到操作系统的命令行提示符下：

```vim
:q 
```

![img](https://pic1.zhimg.com/80/v2-606a667f18745458b3ffc32a9cdef94c_720w.jpg)



发布于 2019-08-19