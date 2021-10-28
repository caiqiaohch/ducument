# 会话(Session)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

2 人赞同了该文章

会话信息，将保存所有编辑窗口和全局设置。通过恢复会话，可以快速切换回之前工作环境。可以认为，会话是[viminfo](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-01-viminfo.html)的扩展补充，viminfo文件中保存了会话所需要使用的具体设置信息。

如下图所示，我在编辑本文档的同时，打开了帮助文件和命令终端。首先，将当前编辑状态保存到会话文件；稍后，只需要恢复会话，就可以继续使用之前的窗口布局进行编辑了，而省去了手动打开多个窗口的繁琐。

![img](https://pic3.zhimg.com/80/v2-04599d1db4e4250649d20b73f8e35652_720w.jpg)

## 保存会话

使用以下命令，将保存会话信息至当前目录下，以“Session.vim”命名的文件：

```vim
:mksession
```

如果已经存在同名的会话文件，那么需要在命令中使用“!”参数，进行强制覆盖：

```vim
:mks!
```

也可以在命令中，指定会话信息文件的位置：

```vim
:mksession ~/mysession.vim 
```

## 恢复会话

在[启动](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-209-Start.html)Vim时，通过指定“-S”参数，可以恢复之前保存的编辑会话：

```vim
$ vim -S Session.vim
```

在Vim中使用以下命令，也可以恢复会话信息：

```vim
:source Session.vim
```

使用以下命令，可以查看关于会话信息的帮助文件：

```vim
:help session
```

## 会话选项

会话选项sessionoptions，用于指定保存会话的内容，默认值如下：

```vim
:set sessionoptions = blank,buffers,curdir,folds,help,options,tabpages,winsize,terminal
```

sessionoptions选项是一组使用逗号分隔的字符串，包含以下参数：

- *blank*
  恢复编辑无名缓冲区的[窗口](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-14-MultiWindows.html)；
- *buffers*
  恢复所有[缓冲区](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-13-MultiBuffers.html)（包括隐藏和未载入的缓冲区）；
- *curdir*
  恢复当前目录；
- *folds*
  恢复[折叠](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-63-Fold.html)；
- *globals*
  恢复以大写字母开始并至少包含一个小写字母的全局变量；
- *help*
  恢复帮助窗口；
- *localoptions*
  恢复（限定于缓冲区内）本地选项；
- *options*
  恢复全局映射和选项；
- *resize*
  恢复以行列指定的窗口大小；
- *sesdir*
  设置当前目录为会话文件所在的位置；
- *salsh*
  在文件名中使用salsh（/），来代替backslah（\）；
- *tabpages*
  恢复所有[标签页](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-15-Tabs.html)；
- *terminal*
  恢复终端窗口；
- *unix*
  使用Unix模式的行尾标志（<NL>）；
- *winpos*
  恢复 GUI Vim 的窗口位置；
- *winsize*
  恢复窗口尺寸（相对于屏幕大小）；

使用以下命令，可以查看关于会话选项的帮助信息：

```vim
:help 'sessionoptions' 
```



发布于 2019-10-01