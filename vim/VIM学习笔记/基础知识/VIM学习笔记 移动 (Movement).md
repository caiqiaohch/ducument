# VIM学习笔记 移动 (Movement)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

## **在行内移动**

我们可以用w命令向前移动一个单词，用b命令向后移动一个单词。我们也可以用数字做前缀组成新的命令，来快速的移动。例如4w就是向前移动4个单词，而5b则是向后移动5个单词。命令e也是向前移到一个单词，但是将光标定位在单词的结尾处；命令ge则是向后移到一个单词并到达前一个单词的结尾处。

利用$命令可以使光标移到一行的结尾处；而g_命令则会而将光标移到一行的最后一个非空字符处。

利用0命令可以使光标移到一行的开始处。而^命令则会忽略开头的空格，而将光标移到一行的第一个字符处。

![img](https://pic1.zhimg.com/80/v2-f2a1c270f1cd6582855516003c587cd0_720w.png)

## **在行间移动**

进入命令状态，直接输入行号，按下回车键就可以移动到指定的行。

使用G命令，可以移动到指定的行。例如3G可以使我们快速的移到第3行。而1G则可以使我们移到文章的最顶端，而G则是定位到文章的最后一行。

使用-命令，可以移动到上一行的第一个非空字符处；而+命令，则可以移动到下一行的第一个非空字符处。

使用)命令，可以向前移动一个句子；而(命令，则可以向后移动一个句子。

使用}命令，可以向前移动一个段落；而{命令，则向后移动一个段落。

将以上移动命令与数字相结合，可以进一步加快移动的速度。

![img](https://pic2.zhimg.com/80/v2-097c29bf4aaf330f2f97f439f3eb7899_720w.png)

除了在行间移动，我们还可以使用ctrl+U和ctrl+D命令进行向上和向下翻页，以快速移动到文章的不同部分。我们将在[滚动屏幕](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/02/vim_27.html)章节中做详细介绍。

## **显示位置信息**

那么又如何知道现在第几行呢？我们可以使用:set number命令使vi显示行号；而取消行号的命令为:set nonumber

即使没有显示行号，也可以使用CTRL-G命令在屏幕的下端显示当前所在位置的信息。我们还可以在CTRL-G命令加上一个数字参数，这个数字越大得到的信息就越详细。命令1CTRL-G会显示文件的全路径。命令2CTRL-G会同时显示缓冲区的数字标号。

![img](https://pic4.zhimg.com/80/v2-d6057c381a4c7e3259efffc363fb9c63_720w.png)

命令gCTRL-G可显示出当前文件中的字符数的信息。主要显示出当前行数（Line）、列数（Col）、字数（Word）、字符数（Char）和字节数（Byte）等信息。

![img](https://pic4.zhimg.com/80/v2-9756e96c027e410b0e94b1fd857f494b_720w.png)

命令:set ruler可以打开标尺选项(ruler option)。将在屏幕右下角，显示当前所在的行和列，以及相对于整个文件所处的位置。

![img](https://pic1.zhimg.com/80/v2-647415072cb10c794412cfb1bd6910b8_720w.png)

## **移动的历史记录**

Vim可以记录你曾经到过的地方，并且可以使你回到前一次到过的地方。例如在编辑文件时执行了下面的命令，从而到过不同的行：1G到第一行；10G到第十行；20G到第二十行。现在执行:jumps命令，就会看到一个曾到过的行的列表。使用命令CTRL-O跳转到移动记录列表中上一个位置。而命令CTRL-I跳转到移动记录列表中下一个位置。你不但可以在当前文件内跳转，甚至还可以移动到曾经涉足过的其它文件。

![img](https://pic2.zhimg.com/80/v2-5ff089b2b4d419c932a235caf1bc8f59_720w.png)

## **命令小结**

![img](https://pic2.zhimg.com/80/v2-1c0291d48e3b7d427c1a128742aaa1f5_720w.png)



Ver: 1.1<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/02/vim.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/02/vim_25.html)>