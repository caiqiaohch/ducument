# 打印(Print)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

## **打印到屏幕**

命令:print（简写为:p）可以显示出选定的行。如果没有指定参数，仅是打印当前行。打印完成以后，回到打印行的开头。

我们可以指定要打印的行的范围。例如以下命令，将打印1到5行。

:1,5 print

如果仅仅想打印第5行，可以使用以下命令：

:5 print

如果想要打印整个文件，可以使用以下命令：

:% print

我们还可以选择显示包含指定内容的行。例如使用以下命令，可以打印出含有“ex”的行，并会高亮显示“ex”。

:/ex/ print

我们可以组合使用标记命令m与print命令。例如：在一个地方用命令ma做上标记；然后在其他的地方用命令mb也打上标记；最后用以下命令打印这两个标记之间的内容：

:'a,'b print

命令:number和:#不仅可以显示选定范围的内容，同时还会其行号。

命令:list也可以列出指定的行，而且能够显示出回车，Tab等不可见的字符。

## **打印到打印机**

使用:hardcopy命令，将调出打印对话框，并将文本按照显示在Vim中的原样输出到打印机上。

使用:hardcopy!命令，则不会调出打印对话框，而是直接将文本输出到默认打印机上。

如果想要打印指定范围的行，可以使用以下命令：

:1,100 hardcopy

我们也可以进入可视化模式，然后选择指定的范围进行打印：

v100j:hardcopy

其中，命令v进入可视模式，100j向下移动100行，这些行将被高亮显示。然后用:hardcopy命令，打印出选中的行。

我们也可以使用命令V进入可视化模式，并选定一段内容，这时输入:就会在Vim的底部显示<,>两个字符，这两个字符分别指选定内容的开头和结束部分。然后就可以用:hardcopy命，令打印出选择的部分了。

## **打印选项**

利用以下命令，设置printoptions选项，可以控制Vim的打印效果。

set printoptions=paper:A4,syntax:y,wrap:y

*paper*选项，用于选择纸张。可以设置为A3、A4、letter和legal。

*syntax*选项，确定是否按照语法高亮度打印文件。默认值“a”，意味着仅在使用彩色打印机时，打印语法高亮度；你也可以将值设为“y” ，强制打印语法高亮度。

*wrap*选项，确定是否折行打印。默认值“:y”，意味着自动折行；如果你将值设为“n”，那么过长的行在打印时将被截断。

*header*选项，设为“0”时，将取消打印页眉。

*number*选项，设为“y”时，将会打印行号。

关于printoptions的更多选项，请使用:help popt命令，查看帮助信息。

![img](https://pic1.zhimg.com/80/v2-a45dad72434ab2fc222eef922e3b0328_720w.png)

Ver: 1.0<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2010/10/vim-undo.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2012/04/vim-help.html)>