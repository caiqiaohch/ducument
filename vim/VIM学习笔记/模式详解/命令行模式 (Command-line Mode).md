# 命令行模式 (Command-line Mode)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

## **命令行模式 (Command-line Mode)**

输入`:`命令，使用`/`或`?`搜索命令，都将进入命令行模式。用户可以在屏幕底部的命令行中输入命令，或者使用以下快捷键遍历之前的命令历史，然后点击<Enter>键来执行命令。

![img](https://pic1.zhimg.com/80/v2-eb1966f79ad64badb9b792e68b1519b4_720w.jpg)

输入部分命令，比如输入`:set`，然再点击上下光标键，将自动对命令历史纪录进行过滤，仅显示以“set”开头的命令历史纪录。在输入`/`和`?`查找命令时，此特性同样有效。请注意，此时是大小写敏感的。

继续键入命令`:set i`之后，按下Tab或Ctrl+D键，将显示以“i”开头的set命令；继续按Tab键，则可以在这些命令列表间移动，按下回车键就可以执行该命令。

![img](https://pic1.zhimg.com/80/v2-1770c1a7576355ead74f2443197b7458_720w.png)

进入命令行模式之后，点击Ctrl+rCtrl+w键可以将当前光标下的[word](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-09-word.html)粘贴到命令行中；点击Ctrl+rCtrl+a键可以将当前光标下的[WORD](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-09-word.html)粘贴到命令行；点击Ctrl+r%键可以将当前文件名粘贴到命令行。

利用以上快捷键，可以大大简化命令行的输入。比如想要替换光标下的单词，那么只要输入:substitute命令，然后再点击Ctrl+r和Ctrl+w键，就可以将光标下的单词插入到命令行中，而不需要手工输入替换的文字了。

```vim
:%s/<Ctrl+r><Ctrl+w>//g
```

比如在编辑[vimrc配置文件](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)时，会面对大量的设置命令，只需要将光标移动到配置选项之上，输入:help命令，然后点击Ctrl+r和Ctrl+w键，就可以查询该关键字的帮助信息：

```vim
:help <Ctrl+r><Ctrl+w>
```

使用`:help c_CTRL-R_CTRL-W`命令，可以查看关于Ctrl+r和Ctrl+w键的帮助信息。使用`:help cmdline-editing`命令，可以查看关于命令行编辑的帮助信息。使用`:help :`命令，可以查看关于命令行模式的帮助信息。

## **命令行窗口 (Command-line Window)**

可以使用以下四种方式，来打开命令行窗口：

- 在命令行模式下，使用CTRL-F快捷键打开命令行窗口，并显示命令历史纪录；
  请注意，您可以使用`:set cedit`命令，更改此快捷键。
- 在常规模式下，使用`q:`命令打开命令行窗口，并显示命令历史纪录；

![img](https://pic2.zhimg.com/80/v2-57bbbe8cc9149f48dbc74df99006cdc5_720w.jpg)

- 在常规模式下，使用`q/`命令打开命令行窗口，并显示向前查找（search forward）的历史纪录；

![img](https://pic4.zhimg.com/80/v2-c33914af8675ffb9b809a487b37f2a13_720w.jpg)

- 在常规模式下，使用`q?`命令打开命令行窗口，并显示向后查找（search backward）的历史纪录；

![img](https://pic2.zhimg.com/80/v2-b516546ec6e61d862dd591f4c5693e79_720w.jpg)

我们可以将命令行窗口，视为常规的[缓冲区 (Buffer)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-13-MultiBuffers.html)来操作。使用k和j键，可以在命令历史纪录中上下移动；也可以使用`/`命令查找命令历史纪录，并在此基础上进行修改，然后点击<Enter>键来执行命令（命令行窗口也将同时关闭）。

如果同时打开多个[缓冲区 (Buffer)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-13-MultiBuffers.html)，那么可以在一个缓冲区的命令行窗口使用`yy`命令复制一条命令，然后在另一个缓冲区的命令行窗口中粘贴并执行该命令，或者在命令行中使用`:@"`来执行复制的命令。也就是说，你可以很方便地在多个缓冲区中，重复执行命令（比如相同的:%s/old/new/g替换操作），而不必多次手工输入命令。

使用以下命令，可以设置命令行窗口的高度（默认值为7）：

```vim
:set cmdwinheight=n
```

使用`:q`命令，可以关闭命令行窗口。

使用`:help command-line-window`命令，可以查看命令行窗口的更多帮助信息。

发布于 2019-08-03