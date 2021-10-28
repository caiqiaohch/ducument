# 自动补全(Auto-Completion)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

15 人赞同了该文章

在[插入模式](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-42-InsertMode.html)下，利用自动补全（[Insertion-Completion](https://link.zhihu.com/?target=http%3A//vimcdoc.sourceforge.net/doc/insert.html%23ins-completion)）功能，vim能够根据正在输入的字符，查找匹配的关键字并显示在弹出菜单（popup menu）中。通过选择匹配项，可以补全输入的部分关键字甚至整行文本。

Vim可以针对整行文字、关键字、字典、词典、标签、文件名、宏、命令和拼写等等进行补全。本节将首先介绍进入补全模式的操作方法；[下节](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html)将详细介绍各种补全方式的特点。

## 关键字补全（Generic keyword completion）

使用Ctrl-N或Ctrl-P键，将按照['complete'](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-03-AutoCompletion-Option.html%23complete)选项指定的范围来搜索匹配的关键字。其默认值为：

```vim
:set complete=.,w,b,u,t,i
```

也就是说，默认将在以下来源中查找关键字：

- 在当前缓冲区中进行查找；
- 在其他窗口中进行查找；
- 在其他已载入的缓冲区中进行查找；
- 在没有载入缓冲区的文件中进行查找；
- 在当前的标签（tags）列表进行查找；
- 在由当前文件（如#include）包含进来的头文件中进行查找。

## ^X模式（Ctrl-X Mode）

在插入模式下，输入Ctrl-X将进入^X模式（插入和替换模式的一个子模式）。屏幕底部将显示以下提示信息：

```text
-- ^X mode (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)
```

您可以选择以下自动补全方式：

- Ctrl-] ，[标签(tags)补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-tag)
- Ctrl-D ，[定义补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-define)
- Ctrl-E ，向上滚动文本
- Ctrl-F ，[文件名补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-filename)
- Ctrl-I ，[当前文件以及包含进来的文件补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-keyword)
- Ctrl-K ，[字典补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-dictionary)
- Ctrl-L ，[整行补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-whole-line)
- Ctrl-N ，当前文件内的关键字补全，向下选择匹配项
- Ctrl-O ，[全能补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-omni)
- Ctrl-P ，当前文件内的关键字补全，向上选择匹配项
- Ctrl-S ，[拼写建议补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-spelling)
- Ctrl-U ，[用户自定义补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-function)
- Ctrl-V ，[Vim命令补全](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html%23compl-vim)
- Ctrl-Y ，向下滚动文本

假设在编辑main.c文件时，想要查找一个宏定义，那么首先按下ctrl-X键进入^X模式，然后再按下CTRL-D键，这时就会在弹出菜单中显示匹配项。

## 补全弹出菜单（popupmenu-completion）

随着弹出菜单的显示，将会自动应用第一个匹配项。

使用以下快捷键，可以在弹出菜单中移动和选择匹配项：

- 使用**Ctrl-N**和**Ctrl-P**上下移动时，输入的文本也会随之变化。
- 使用****和****上下移动时，输入的文字并不会变化。
- 使用****和****键，可以在菜单中翻页。
- 使用**Ctrl-Y**或**Enter**回车键，将使用当前匹配项完成补全。
- 使用**Ctrl-E**键，将关闭菜单并退回到文字输入的原始状态。
- 使用**Esc**键，将关闭弹出菜单，但会保留之前应用的匹配项。

请注意，如果您不希望应用任何匹配项完成补全时，应该使用Ctrl-E键，而不是使用Esc键来取消操作。

![img](https://pic4.zhimg.com/v2-ca5a7f23000fbbc747b332b48ff5f557_b.jpg)

使用`:h popupmenu-keys`命令，可以查看关于弹出菜单快捷键的帮助信息。

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-66-Indent.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html)>

发布于 2020-02-09