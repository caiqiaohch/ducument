# 非可见字符(Listchars)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

6 人赞同了该文章

## **显示/隐藏**

默认情况下，Vim是不会显示space,tabs,newlines,trailing space,wrapped lines等不可见字符的。我们可以使用以下命令打开*list*选项，来显示非可见字符：

```text
:set list
```

如下图所示，制表符被显示为“^I”，而行尾则标识为“$”。

![img](https://pic3.zhimg.com/80/v2-3b7aa483f64359e62c943609a1b37856_720w.png)

我们也可以使用以下命令，重新隐藏不可见字符：

```text
:set nolist
```

通常我们会利用以下命令，切换显示或隐藏不可见字符：

```vim
:set list!
```

## **显示符号**

使用:set listchars命令，可以配置使用何种符号来显示不可见字符。例如以下命令，将制表符（tab）显示为…；将尾部空格（trail）显示为·；将左则超出屏幕范围部分（precedes）标识为«；将右侧超出屏幕范围部分（extends）标识为»。

![img](https://pic4.zhimg.com/80/v2-9a3b1d293f0d064a46680d9590203c9f_720w.png)

其中，特殊符号是在插入状态下，点击快捷键Ctrl-k，然后键入编码来输入的。比如，中点是由.M输入；左书名号是由<<输入，右书名号是由>>输入。

可以使用以下命令，查看可以输入的特殊字符：

```text
:digraphs
```

![img](https://pic3.zhimg.com/80/v2-e12c63ab2209f8a88180aa15705ef086_720w.png)

如下图所示，通过选择合适的符号和色彩，非可见符号被低调地显示出来––即没有影响实际的文本内容，又能展示容易被忽视的重要信息：

![img](https://pic3.zhimg.com/80/v2-0a69d08f41321e99cc482fb9c56f9b72_720w.png)

## **显示颜色**

非可见字符"eol"、"extends"、"precedes"是由*NonText*高亮组来控制显示颜色的，而"nbsp"、"tab"、"trail"则是由"SpecialKey"高亮组来定义的。

我们可以使用以下[语法高亮 (Syntax Highlight)](https://link.zhihu.com/?target=https%3A//yyq123.blogspot.com/2017/02/vim-syntax-highlight.html)命令，来设置非可见字符的显示颜色和格式：

![img](https://pic4.zhimg.com/80/v2-fc01f62547abb84962f2edefb63c0a83_720w.png)

请使用以下命令，查看关于非可见字符的帮助信息：

```vim
:help listchars
```

![img](https://pic3.zhimg.com/80/v2-d4b6327fc92b69ab0ed7dafec37839da_720w.png)

编辑于 2017-03-16