# 替换(Substitute)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

利用:substitute命令，可以将指定的字符替换成其他字符。通常，我们会使用命令的缩写形式:s，格式如下：

:[range] s/search/replace/[flags] [count]

其中，*range*是指定范围，也就是在哪些行里做替换。而后是将字符串from替换成字符串to。

## **替换标记**

在默认情况下，替换命令仅将本行中第一个出现的的字符替换成给定字符。如果我们想要将所有出现的字符都替换成给定字符，可以在命令中使用*g*（global）标记：

:%s/from/to/g

其他的标记（flags）包括：*p*（print），是要求打印所做的改动；*c*（confirm），是要求在做出改动以前先询问；*i*（ignorecase），是不区分大小写。我们可以组合使用标记，比如以下命令，将会显示将要做改动的文本并要求确认：

:1,$ s/Professor/Teacher/gc

replace with Teacher (y/n/a/q/l/^E/^Y)?

这时你可以做出以下回答：

- y Yes：执行这个替换
- n No：取消这个替换
- a All：执行所有替换而不要再询问
- q Quit：退出而不做任何改动
- l Last：替换完当前匹配点后退出
- CTRL-E 向上翻滚一行
- CTRL-Y 向下翻滚一行

## **指定范围**

如果没有在命令中指定范围，那么将只会在当前行进行替换操作。以下命令将把当前行中的I替换为We。命令中的/i标记，用于指定区分大小写。

:s/I/We/gi

以下命令将文中所有的字符串idiots替换成managers：

:1,$s/idiots/manages/g

通常我们会在命令中使用%指代整个文件做为替换范围：

:%s/search/replace/g

以下命令指定只在第5至第15行间进行替换:

:5,15s/dog/cat/g

以下命令指定只在当前行在内的以下4行内进行替换：

:s/helo/hello/g4

以下命令指定只在当前行至文件结尾间进行替换:

:.,$s/dog/cat/g

以下命令指定只在后续9行内进行替换:

:.,.+8s/dog/cat/g

你还可以将特定字符做为替换范围。比如，将SQL语句从FROM至分号部分中的所有等号（=）替换为不等号（<>）：

:/FROM/,/;/s/=/<>/g

在[可视化模式](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2010/11/vim-visual-mode.html)下，首先选择替换范围, 然后输入:进入命令模式，就可以利用s命令在选中的范围内进行文本替换。

![img](https://pic4.zhimg.com/80/v2-61f2b847b70fe32dbe898e1573843057_720w.png)

## **精确替换**

在搜索*sig*时，也将匹配*sig*, *signature*, *signing*等多个单词。如果希望精确替换某个单词，可以使用“\<”来匹配单词的开头，并用“\>”来匹配单词的结尾：

:s/\<term\>/replace/gc

## **多项替换**

如果想要将单词*Kang*和*Kodos*都替换为*alien*，那么可以使用|进行多项替换。

:%s/Kang\|Kodos/alien/gc

## **变量替换**

使用以下命令可以将文字替换为变量的内容：

:%s!\~!\= expand($HOME)!g

![img](https://pic1.zhimg.com/80/v2-50c15c88c652bb952413d108988841f4_720w.png)



Ver: 1.1<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/03/vim.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2010/08/vim-print.html)>