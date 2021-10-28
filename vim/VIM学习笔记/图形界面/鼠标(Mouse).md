# 鼠标(Mouse)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

## **启用/禁用鼠标**

使用以下命令可以启用鼠标（默认选项）：

```vim
:set mouse=a
```

使用以下命令可以禁用鼠标：

```vim
:set mouse=""
```

## **鼠标选项**

在Windows和X Window这两种系统中，使用鼠标的方式是不同的。我们可以定制Vim编辑器，以启用不同的鼠标行为。命令`:behave xterm`设置使用X Window风格的鼠标行为。而命令`:behave mswin`则启用Windows风格的鼠标行为。

![img](https://pic1.zhimg.com/80/v2-8226f3e8f19e8d96041fe36fbee5c63c_720w.jpg)

使用以下命令，可以定义双击之间的最大时间间隔：

```vim
:set mousetime=time 
```

其中的时间以毫秒为单位，默认情况下为半秒（500ms）。

使用以下命令，可以设置鼠标的模式为extend,popup,popup_setpos其中之一：

```vim
:set mousemodel=mode
```

在所有模式之下，鼠标左键可以移动光标，拉动左键可以选择文本。在*extend*模式中，可以使用左键点中起始位置，然后按住**Alt**键的同时右击结束位置，将选中两点定义的可视化块（visual block）。在*popup*模式中，右键可以显示弹出菜单。而*popup_setpos*模式与popup模式相类似，所不同的只是当按下鼠标右键时，光标会移动到鼠标点击处，然后显示弹出菜单。

通过clipboard选项，可以控制Vim如何处理由鼠标选择的文本。使用以下设置，可以将所有鼠标选择的文本放在未命名寄存器中和剪切板寄存器中，这也意味着我们可以将文本粘贴到其他程序中。

```vim
:set clipboard=unnamed
```

如果设置如下选项，那么可视模式下选择的文本就会被放到系统剪切板中：

```vim
:set clipboard=autoselect
```

## **隐藏鼠标**

在图形界面下编辑时，如果认为鼠标光标的存在会打扰你的工作，可以设置隐藏鼠标光标。

```vim
:set mousehide
```

设置之后，当键盘输入时鼠标光标就会隐藏，而移动光标时鼠标光标就会再度出现。

## **帮助信息**

可以使用以下命令，查看关于鼠标使用的更多帮助信息：

```vim
:help mouse
:help mouse-using
:help scroll-mousewheel 
```

![img](https://pic2.zhimg.com/80/v2-52676cae7ab1cea829cb774ad899d8ed_720w.jpg)



编辑于 2018-06-25