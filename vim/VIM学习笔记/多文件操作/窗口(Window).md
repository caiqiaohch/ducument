# 窗口(Window)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

9 人赞同了该文章

窗口（Window）用来查看[缓冲区](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-13-MultiBuffers.html)（Buffer）的内容。你可以用多个窗口查看同一个缓冲区，也可以用多个窗口查看不同的缓冲区。利用多窗口，我们就能够很方便地对比多个文件，在不同文件之间复制粘贴或者查看同一文件的不同部分。

Vim主窗口可以容纳多个分割的窗口。也可以创建多个[标签页](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-15-Tabs.html)（tab-page），每个标签页也能容纳多个窗口。

在默认情况下，与Vi类似，Vim启动后只打开一个窗口。参数 "-o" 和 "-O" 可以让Vim为参数列表里的每一个文件打开一个窗口。参数 "-o" 水平分割窗口；参数 "-O" 垂直分割窗口。如果 "-o" 和 "-O" 都用了，那么最后一个参数决定分割的方向。例如，下面的例子打开三个水平分割的窗口。

```vim
vim -o file1 file2 file3
```

## **分割窗口**

`:split`命令，会将当前窗口水平分为两个，并且在这两个窗口中同时显示当前文件。如果你在其中一个窗口进行编辑，那么另一个窗口也会同步显示出你所做的更改。

默认情况下，每一个窗口都是独立滚动的。所以在编辑很长文档的时候，我们可以在不同窗口显示同一文档的不同部分。例如：一个窗口显示目录，另一个窗口显示正文。我们也可以使用`:set scrollbind`命令，绑定不同的窗口同步滚动。

如果想要在两个窗口中编辑不同的两个文件。使用`:split file`命令，就可以在另一个窗口中打开文件file了。

相对应的`:vsplit`命令，用于垂直分割窗口。

命令`:new`可以直接水平打开一个新窗口，并对新文件进行编辑。

相对应的`:vnew`命令，用于垂直分割窗口并编辑新文件。

`:sview`是:split和:view两个命令的组合，它可以分隔出一个新窗口，并以只读方式打开指定的文件。

与窗口操作相关的命令，通常也有相对应的ctrl+W快捷键：

![img](https://pic2.zhimg.com/80/v2-14a27f5dde15ed963d942e3962b31da5_720w.jpg)

![img](https://pic4.zhimg.com/80/v2-5742a61c0baa9ce3ba03e27e02918763_720w.jpg)



## **切换窗口**

在gvim和vim中，使用命令`:set mouse=a`启用鼠标支持，就可以通过点击鼠标来进入不同的窗口。

你也可以使用以下ctrl+W快捷键在多个窗口中进行切换：

![img](https://pic1.zhimg.com/80/v2-736a8a62c30686cf405ac0b8b14dc540_720w.jpg)

## **移动窗口**

命令ctrl+Wx，可以将当前窗口与下一窗口进行位置对换。如果当前窗口在底部，则没有下一个窗口，这时命令将当前窗口与上一个窗口进行位置对换。

![img](https://pic4.zhimg.com/80/v2-4da4658063cb893cb2f0be73df0675fb_720w.jpg)

命令ctrl+Wr命令可以使得窗口向右或向下进行循环移动。这个命令可以带一个数字作为参数，指明向下循环移动所执行的次数。与其相类似的ctrl+WR命令，可以使得窗口向左或向上循环移动。

以上命令在调换窗口位置时，会维持现有的窗口尺寸和布局；而以下命令，则会同时改变窗口的位置、尺寸和布局：

![img](https://pic1.zhimg.com/80/v2-73497e5d9aa807abb6af9191f4696f44_720w.jpg)

## **控制窗口尺寸**

在输入:split命令时，可以加入参数来指定打开窗口的大小。例如命令`:3 split file`，将在一个大小为三行的新窗口中打开文件file。我们也可以将这个命令中的空格去掉，写成`:3split file`。

使用ctrl+W+命令增大窗口高度，默认增量为1行；ctrl+W-命令减小窗口高度，默认值为1行。命令countCtrl+W_可以使得当前窗口变为count指定的高度；如果没有指定count，则将当前窗口变得尽可能最大。

使用`:resize`命令，可以精确控制窗口高度。例如：`:resize +3`将增大窗口高度3行；`:resize -3`将减少窗口高度3行；`:resize 3`则将精确指定窗口高度为3行。

命令ctrl+W=可以将几个窗口的大小变为相等。

使用ctrl+W>命令增大窗口宽带，默认增量为1列；ctrl+W<命令减小窗口宽度，默认值为1列。命令countCtrl+W|可以使得当前窗口变为count指定的宽度；如果没有指定count，则将当前窗口变得尽可能最大。

使用`:vertical resize`命令，可以精确控制窗口宽度。例如：`:vertical resize +3`将增大窗口宽度3列；`:vertical resize -3`将减少窗口宽度3列；`:vertical resize 3`则将精确指定窗口宽度为3列。

当然，你也可以用鼠标上下拖动状态行来改变窗口的高度。

![img](https://pic4.zhimg.com/80/v2-d3a920ed2a8879427532297035f3c4c3_720w.jpg)

## **关闭窗口**

可以使用以下命令来关闭窗口：

![img](https://pic3.zhimg.com/80/v2-75b9b0ce55609d583351064390d2f672_720w.jpg)

**帮助信息**

使用`:help CTRL-W`命令可以，查看关于窗口操作的帮助信息。

<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-13-MultiBuffers.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-15-Tabs.html)>

编辑于 2018-06-05