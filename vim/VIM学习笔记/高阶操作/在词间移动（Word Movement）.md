# 在词间移动（Word Movement）

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

Vim有单词（word）和字串（WORD）两种概念。word是指由iskeyword选项定义的字符串；而WORD则是指用空白符分隔的字符串。可以使用:help word和:help WORD命令，查看更多帮助信息。

## **在word间移动**

[count]b 向后移动count个words



按照通常的定义，单词是一系列字母的组合。然而在C程序中，则认为字母、数字和下划线来组成一个单词，比如size56就会被认为是一个单词。但是在LISP程序中，可以在变量名中使用-，这时会认为total-size是一个单词，而在C程序中这却会被认为是两个单词。那么如何来解决这些定义的差异呢？Vim的解决方案是，使用以下选项来定义哪些是一个单词的，而哪些又不是。

```text
:set iskeyword=specification
```

查看当前选项，可以使用下面的命令：

```text
:set iskeyword?
```

命令会返回一组用逗号分隔的值（以下是在Windows下的默认值）：

```text
iskeyword=@,48-57,_,192_255
```

如果我们想要单词中的字母是专一的元音，可以使用以下命令：

```text
:set iskeyword=a,e,i,o,u
```

我们还可以使用横线来指定字母的范围。如果要指定所有的小写字母，可以用下面的命令：

```text
:set iskeyword=a-z
```

对于那些不能直接指定的字符，可以使用十进制的数字来表示。如果我们要指定小写字母和下划线为一个单词，可以使用下面的命令：

```text
:set iskeyword=a-z,45
```

排除某一个字符，可以在这个字符前加上一个前缀^。例如我们可以定义一个单词由除了q以外的小写字符组成：

```text
:set iskeyword=@,^q
```

iskeyword（命令iskeyword可以简记为isk）选项使用以下特殊字符：

a 字符
aa-z 所有由a到z的字符@ 由函数isalpha()所定义的所有字符@-@ 字符@^x 除了x以外的字符^a-c 除了a到c以外的字符

## **在WORD间移动**

[count]B 向后移动count个WORDS



可以使用:help word-motions命令，查看在词间移动的更多帮助信息。

![img](https://pic3.zhimg.com/80/v2-cb1141ec17155ba347b75c90ff397b22_720w.png)

![img](https://pic2.zhimg.com/80/v2-194cd3d300f47e011cae981aed7e8a45_720w.png)



Ver: 1.0<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/02/vim_4321.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/02/vim_4321.html)>