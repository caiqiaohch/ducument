## **指定屏幕位置**

在操作系统的终端中执行以下命令，可以在指定的屏幕位置打开图形界面的GVim：

```bash
$ gvim -geometry width+ x heightx_offset-y_offset
```

请注意， -geometry 标记用于指定屏幕位置和窗口大小。此标记仅适用于Linux操作系统。

- *width*，窗口宽度；
- *height*，窗口高度；
- *x_offset*，以像素数指定屏幕的左边界和窗口的左边界的距离。如果此值为负数，那么则是指定编辑器的左边界和屏幕的右边界的距离；
- *y_offset*，以像素数指定与屏幕上边缘的距离。如果此值为负数，则是指定了与屏幕下边缘的距离。

使用以下命令，将在屏幕的左上角启动gvim：

```text
$ gvim -geometry +0+0
```

使用以下命令，将在屏幕的右下角启动gvim：

```text
$ gvim -geometry -0-0
```

使用以下命令，可以打开一个80行x24列的编辑窗口：

```text
$ gvim -geometry 80x24
```

使用以下命令，则可以在屏幕的左上角打开一个80行x24列的编辑窗：

```text
$ gvim -geometry 80x24+0+0
```

如果我们需要针对同样尺寸的窗口进行截图，那么此功能就非常有价值了。

## **移动窗口位置**

在GVim中使用以下命令，可以得到当前窗口（相对于左上角）的屏幕位置：

```vim
:winpos
```

![img](https://pic3.zhimg.com/80/v2-c1107ac6f0995d23021d4831c24d214e_720w.png)

使用:winpos X Y命令，则可以将当前窗口移动到指定的屏幕位置：

```vim
:winpos 20 30
```

## **指定窗口尺寸**

使用以下命令，可以显示当前窗口的行数：

```vim
:set lines?
```

使用以下命令，则可以设置窗口的行数为n：

```vim
:set lines=n
```

如果需要指定窗口的列数为n，则可以使用以下命令：

```vim
:set columns=n
```

当行过宽时，vim会自动进行回折以适应屏幕的宽度。如果设置了nowrap选项，则Vim不会自动折行，这时超出屏幕的部分将不会被显示出来。在默认的情况下，Vim也不会显示水平滚动条。我们可以使用`:set guioptions+=b`命令来显示水平滚动条。关于折行显示的更多信息，请参阅[折行(Wrap)](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2010/07/vim-wrap.html)章节。

在[配置文件(vimrc)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)中增加以下命令，将行和列都设置为足够大的值，可以在启动GVim时自动最大化窗口：

```vim
set lines=500 columns=500
```

## **标题栏**

使用以下命令，可以将当前窗口的标题设置为正在编辑的文件名：

```vim
:set title 
```

默认情况下，窗口标题将显示当前编辑的文件名，随后是一个状态标识码，以及文件路径：

![img](https://pic2.zhimg.com/80/v2-ee6e1092d21d7205188a71ccf6899495_720w.jpg)

其中，状态标识码有以下几种：

- `-`，文件不可更改；
- `+`，文件已经更改；
- `=`，只读文件；
- `=+`，只读文件，已经被更改。

有时文件全名会很长，我们可以使用以下命令，来指定文件名占用标题栏空间的百分比：

```vim
:set titlelen=85
```

使用以下命令，可以直接改变标题为指定字符串：

```vim
:set titlestring=Hello World!
```

使用`:help titlestring`命令，可以查看关于titlestring选项的更多帮助信息。

![img](https://pic4.zhimg.com/80/v2-8c41669bbd7bc57d82876e5ede2c2483_720w.jpg)



编辑于 2019-06-18