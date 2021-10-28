# 语法高亮度-日志文件(Syntax-Logfile)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

9 人赞同了该文章

在系统排错过程中，常常需要在日志文件里大海捞针。面对数量巨大的繁杂信息，如何快速准确地找到线索，就显得格外重要了。

利用[语法高亮度(Syntax)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-64-Syntax.html)，可以突出显示重要的信息，比如：

- 包含“Error”和“Fail”等关键词的报错信息；
- 日期、网址、文件名等对象；
- 数字、字符串、操作符等元素。

## 定义语法高亮度

首先，定义需要着重显示的文本内容：

匹配指定的关键字：

```vim
syn keyword logLevelError error fail failure
```

匹配特定模式的字符串：

```vim
syn match logDate 'd{2}/d{2}/d{4}s*d{2}:d{2}:d{2}'
```

然后，定义如何显示特定的文本内容：

将以上定义的语法高亮组，链接到[配色方案](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-62-ColorScheme.html)定义过的语法高亮组：

```vim
hi def link logLevelError ErrorMsg
```

也可以直接定义文本的显示色彩：

```vim
hi def logLevelError guifg=#ddddff guibg=#444444
```

## 配置语法高亮度

首先，将[语法高亮文件](https://link.zhihu.com/?target=https%3A//github.com/yyq123/vim-syntax-logfile)，放置在以下目录：

- Linux: `$HOME/.vim/syntax`
- Windows: `$HOME/vimfiles/syntax`

然后，在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中增加以下命令，以侦测.log为后缀名的日志文件并启用语法高亮度：

```vim
au BufNewFile,BufRead *.log setfiletype log
```

## 语法高亮度效果

![img](https://pic4.zhimg.com/80/v2-0f7d649f184c366c037ab157d6874973_720w.jpg)

## 关于日志查看的一点想法

- 对于动辄百兆的大型日志文件，Vim并非理想的工具。通常情况下：首先，利用[tail](https://link.zhihu.com/?target=https%3A//tldr.ostera.io/tail)和[grep](https://link.zhihu.com/?target=https%3A//tldr.ostera.io/grep)等命令，将日志文件截取为较小的片段；然后，再使用Vim进行细致地分析。
- 过多的语法高亮度，不但会影响打开文件的速度，而且还会增加阅读的干扰。应该克制地使用视觉元素，仅仅突出显示最为关键的信息。比如，您可以在[语法高亮文件](https://link.zhihu.com/?target=https%3A//github.com/yyq123/vim-syntax-logfile)中，注释掉关于日期和网址等元素的定义，而仅仅保留对于报错信息的突出显示。
- 对于日志分析，并没有捷径。虽然[vim-logreview](https://link.zhihu.com/?target=https%3A//github.com/andreshazard/vim-logreview)等插件，可以移除日志文件中的正常统计输出，而仅仅保留报错信息。但异常事件通常并非孤立的单点问题，而其前后的上下文信息对于建立时间线和还原事件场景都有着极高的价值。对于大多数问题，并不能通过单一的报错信息，直接指向确定的解决方案。
- 由此看来，利用语法高亮度来突出显示报错信息，然后小心厘清来龙去脉，算是现实可行的权宜之计吧？

发布于 2019-12-10