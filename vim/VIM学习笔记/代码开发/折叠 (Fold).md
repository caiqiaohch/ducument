# 折叠 (Fold)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

27 人赞同了该文章

当我们查看很长的文本时（比如程序代码），可以使用 **:set foldenable** 命令来启动折叠。首先将内容按照其结构折叠起来，查看文件的大纲，然后再针对特定的部分展开折叠，显示文本的详细内容。

![img](https://pic4.zhimg.com/80/v2-0e6126b958593972a97201fc249edc4b_720w.png)

Vim将折叠等同于行来对待——你可以使用j或k命令，移动跳过包含多行的整个折叠；也可以使用y或d命令，复制或删除某个折叠。

通常在折叠处向左或向右移动光标，或者进入插入模式，都将会自动打开折叠。我们也可以使用以下命令定义快捷键，使用空格键关闭当前打开的折叠，或者打开当前关闭的折叠。

```text
:nnoremap <space> za
```

按照折叠所依据的规则，可以分为Manual（手工折叠）、Indent（缩进折叠）、Marker（标记折叠）和Syntax（语法折叠）等几种。

## **Manual Fold**

使用以下命令，启用手工折叠。

```text
:set foldmethod=manual
```

在可视化模式下，使用以下命令，将折叠选中的文本：

```text
zf
```

通过组合使用移动命令，可以折叠指定的行。例如：使用zf70j命令，将折叠光标之后的70行；使用**5zF**命令，将当前行及随后4行折叠起来；使用zf7G命令，将当前行至全文第7行折叠起来。

我们也可以使用以下命令，折叠括号（比如()、[]、{}、><等）包围的区域：

```text
zfa(
```

Vim并不会自动记忆手工折叠。但你可以使用以下命令，来保存当前的折叠状态：

```text
:mkview
```

在下次打开文档时，使用以下命令，来载入记忆的折叠信息：

```text
:loadview
```

可以使用以下命令，查看关于手工折叠的帮助信息：

```text
:help fold-manual
```

## **Indent Fold**

使用以下命令，启用缩进折叠。所有文本将按照（选项*shiftwidth* 定义的）缩进层次自动折叠。

```text
:set foldmethod=indent
```

使用zm命令，可以手动折叠缩进；而利用zr命令，则可以打开折叠的缩进。

使用以下命令，将可以根据指定的级别折叠缩进：

```text
:set foldlevel=1
```

可以使用以下命令，查看关于缩进折叠的帮助信息：

```text
:help fold-indent
```

## **Syntax Fold**

使用以下命令，启用语法折叠。所有文本将按照语法结构自动折叠。

```text
:set foldmethod=syntax
```

可以使用以下命令，查看关于语法折叠的帮助信息：

```text
:help fold-syntax
```

## **Marker Fold**

使用以下命令，启用标记折叠。所有文本将按照特定标记（默认为{{{和}}}）自动折叠。

```text
:set foldmethod=marker
```

我们可以利用标记折叠，在文本中同时体现结构和内容，并且能够快速跳转到文件的不同部分。

![img](https://pic1.zhimg.com/80/v2-caf08704a3a849a14046bdfab866a96c_720w.png)

可以使用以下命令，查看关于标记折叠的帮助信息：

```text
:help fold-marker
```

## **折叠选项**

使用:set foldcolumn=N命令，将在屏幕左侧显示一个折叠标识列，分别用“-”和“+”而表示打开和关闭的折叠。其中，*N*是一个0-12的整数，用于指定显示的宽度。

![img](https://pic1.zhimg.com/80/v2-4f5b3a585fd7d4cac4f2595b17ec3d60_720w.png)

使用以下命令，可以查看关于折叠的帮助信息：

```text
:help folding
```

![img](https://pic4.zhimg.com/80/v2-c56f304dbf1566820b5f65e158560117_720w.png)

编辑于 2017-06-20