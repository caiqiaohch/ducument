# 大小写转换（Tilde）

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

## **转换字符大小写**

命令~可以改变字母的大小写。如果当前光标下的字母为小写，那么点击~可以将该字母转换为大写。同理如果当前光标下的字母为大写，那么点击~则可以将该字母转换为小写。

tildeop选项可以控制命令~的行为。默认设置下，只会对单个字符进行大小转换。

```text
:set notildeop
```

如果设置了tildeop选项，那么命令就会变为~motion的模式：

```text
:set tildeop
```

例如，在下面的句子中:

> this is a test

我们将光标放在第一个t上并执行~ft命令，则结果为：

> THIS IS A Test

命令使得当前光标以后第一个t和光标间的字符全部转换为大写，如果这个句子中还有小写字符，那么这个命令还可以执行第二次，直到句子中的字符全部为大写为止。

可以指定转换字符的个数和方向。例如命令3~l是从当前字符开始向右3个字符进行大小写的转换。

命令g~3w可以转换当前光标开始之后的3个单词；而命令g~iw则可以转换当前[inner word](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2016/12/vim-text-objects.html)；而命令g~$则可以转换从当前位置到行尾的所有字符。

命令g~g~和g~~可以转换整行的大小写。而且并不依赖于[tildeop](https://link.zhihu.com/?target=http%3A//vimcdoc.sourceforge.net/doc/options.html%23'notildeop')选项的设置。

在可视化模式下，可以使用u命令，将选中的字母转换为小写；也可以使用U命令，将选中的字母转换为大写。

gUU和gUgU命令，都可以将整行字符转换为大写。如果指定了数字参数，例如3gUU则可对指定行数进行转换。

相对应的guu和gugu命令，则是用于将整行字符转化为小写。

## **首字母大写**

选中文本，然后进入命令行模式并使用以下命令，可以将选中的文本转换为首字母大写（title case / initial capitals）。

```text
:s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g
```

![img](https://pic2.zhimg.com/80/v2-8ba561886b49db09b0a607e296eab901_720w.png)

![img](https://pic2.zhimg.com/80/v2-656332785914796579eea0ffe1443431_720w.png)

Ver: 1.0<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2010/10/vim-indent.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2011/01/vim-encyption.html)>

编辑于 2016-12-19