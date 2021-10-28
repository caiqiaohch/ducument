# 缩进 (Indent)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

## **手动缩进**

在Normal Mode下，命令>>将对当前行增加缩进，而命令<<则将对当前行减少缩进。我们可以在命令前使用数字，来指定命令作用的范围。例如以下命令，将减少5行的缩进：

```text
5<<
```

如果代码没有正确排版，那么我们可以使用==命令来缩进当前行；也可以进入可视化模式并选择多行，然后使用=命令缩进选中的行。

![img](https://pic2.zhimg.com/80/v2-0514ef76bcf59a32521efd5a3122708d_720w.png)

通过与[文本对象](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2016/12/vim-text-objects.html)组合，使用以下命令可以缩进{}括号内的代码。

```text
=a{
```

如果需要缩进整个文件内的代码，则可以使用以下命令：

```text
gg=G
```

在Insert/Replace Mode下，Ctrl-Shift-t可以增加当前行的缩进，而Ctrl-Shift-d则可以减少当前行的缩进。使用0-Ctrl-Shift-d命令，将移除所有缩进。需要注意的是，当我们输入命令中的“0”时，Vim会认为我们要在文本中插入一个0，并在屏幕上显示输入的“0”；然后当我们执行命令0-Ctrl-Shift-d时，Vim就会意识到我们要做的是减少缩进，这时0会就会从屏幕上消失。

缩进宽度默认为8个空格。我们可以使用以下命令，来修改缩进宽度：

```text
:set shiftwidth=4
```

通过以下设置，每次点击Tab键，将增加宽度为8列的Tab缩进。

```text
:set tabstop=8
:set softtabstop=8
:set shiftwidth=8
:set noexpandtab
```

使用以下设置，每次点击Tab键，增加的缩进将被转化为4个空格。

```text
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set expandtab
```

其中，*expandtab*选项，用来控制是否将Tab转换为空格。但是这个选项并不会改变已经存在的文本，如果需要应用此设置将所有Tab转换为空格，需要执行以下命令：

```text
:retab!
```

## **自动缩进**

在Vim中还可以进行自动缩进，主要有cindent、smartindent和autoindent三种模式。

**autoindent** 在这种缩进形式中，新增加的行和前一行使用相同的缩进形式。可以使用以下命令，启用autoindent缩进形式。也可以点击==键进行缩进。

```text
:set autoindent
```

**smartindent** 在这种缩进模式中，每一行都和前一行有相同的缩进量，同时这种缩进形式能正确的识别出花括号，当遇到右花括号（}），则取消缩进形式。此外还增加了识别C语言关键字的功能。如果一行是以#开头的，那么这种格式将会被特殊对待而不采用缩进格式。可以使用以下命令，启用smartindent缩进结构：

```text
:set smartindent
```

**cindent** Vim可以很好的识别出C和Java等结构化程序设计语言，并且能用C语言的缩进格式来处理程序的缩进结构。可以使用以下命令，启用cindent缩进结构：

```text
:set cindent
```

![img](https://pic2.zhimg.com/80/v2-7f9cdd74efdb5aec7f7f1d2f789e2459_720w.png)

编辑于 2016-12-23