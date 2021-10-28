# 操作文件(Manipulate File)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

7 人赞同了该文章

## **:Explore**

使用`:Explore`命令（注意开头E大写）打开文件浏览器，可以在其中切换目录并选择打开文件。

![img](https://pic4.zhimg.com/80/v2-779a8a5ab0e3a38a3fa4c9ebc4f83a43_720w.jpg)

使用键盘移动光标至文件或文件夹名称上，然后点击**Enter**回车键，可以在当前窗口中打开该文件或文件夹；如果希望在新建窗口中打开文件或文件夹，那么可以点击**o**键。

直接使用鼠标点击文件或文件夹名称，也可以在当前窗口中打开该文件或文件夹。

点击大写**R**键，然后修改窗口底部信息中的第二个文件名，可以重命名当前光标下的文件。

![img](https://pic3.zhimg.com/80/v2-3a9e2283370ccd508378ff850e060346_720w.jpg)

点击大写**D**键，然后在窗口底部信息中进行确认，则可以删除当前光标下的文件。

![img](https://pic2.zhimg.com/80/v2-0535b80bccfd9149c1c89360e03b5f41_720w.jpg)

点击**/**键，可以在文件列表中进行查找。

![img](https://pic2.zhimg.com/80/v2-31ff96b2e7f281cea25bdadf9bc652cd_720w.jpg)

## **goto file**

如果当前文件中包含了其他文件名，那么我们可以移动到文件名位置，然后直接使用`gf`命令在新的[缓冲区](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/07/vim-buffer.html)中打开链接的文件。例如下图所示，在HTML文件中引用了CSS文件，那么只需要在CSS文件名处执行gf命令，Vim就会在当前文件夹中查找并打开引用的CSS文件。

![img](https://pic4.zhimg.com/80/v2-b9d83529635ab30c04abf461ab21e69f_720w.jpg)

如果文件名中没有指明扩展名称，那么可以使用以下命令来指定gf需要查找的文件类型：

```vim
:set suffixesadd+=.rb
```

如果我们希望gf在多个文件夹中尝试查找并打开文件，那么可以使用以下命令来定义文件夹列表：

```vim
:set path+=D:/Anthony_GitHub/learn-vim/**
```

使用以下命令可以查看当前path选项的设置：

```vim
:set path?
```

![img](https://pic1.zhimg.com/80/v2-794626cc36a149bef2b7624d03c31498_720w.jpg)

其中，“.”代表当前文件夹下的所有文件；“**”代表所有子文件夹；“,”用于分隔多个文件夹。

我们也可以使用`ctrl-Wf`命令，在新的分割窗口中打开光标下文件。

## **文件信息**

使用以下命令，可以显示当前文件的名字、状态以及行列相关的信息：

```vim
:file
```

"test.txt" [Modified] 134 lines --55%--

使用以下命令，则可以显示当前文件的总行数：

```vim
:= 
```

使用`g-Ctrl-g`命令，将在状态栏下方显示整个文档的字数和行数，以及当前所处的位置。

![img](https://pic3.zhimg.com/80/v2-c99e9a52f1fa2384c8794adb222ff132_720w.jpg)

如果想要统计当前行的字数，首先移动到行尾，然后使用`v`命令进入可视化模式，使用`0`命令移动到行头并选中整行文字，最后使用`g-Ctrl-g`命令显示选中文本的字数。

在插入模式下，使用`%`命令，或者在常规模式下，使用`"%p`命令，可以将当前文件名粘贴到文本中。

使用以下命令，可以在文本中查找当前文件名：

```vim
/<C-R>%
```

## **查看文件**

使用`:view file`命令，将以只读方式打开文件。

使用`:set ro`命令，会将当前文件置为只读状态。你在文件中进行的任何修改，都无法保存。当然我们也可以使用`:write!`命令，来强制保存文件。

![img](https://pic3.zhimg.com/80/v2-71f12504d98ab858d90e8d7ce109818a_720w.jpg)

使用`:set noma`命令，可以将当前文件置为不可修改状态，Vim会阻止任何修改操作。

![img](https://pic4.zhimg.com/80/v2-1f70e1aa965413d06408c8af1374b2cb_720w.jpg)



## **新建文件**

使用`:vi file`命令，在新建缓冲区中编辑名为file的新文件。如果当前文件没有保存，那么将会显示警告信息，此时可以输入`:write`命令，来保存当前文件。

![img](https://pic4.zhimg.com/80/v2-b5f3ecc5a410c49f17fcac669582cf9b_720w.jpg)

使用`:vi! file`命令，将不保存当前文件而强制开始编辑新文件。

## **另存文件**

使用以下命令，可以将当前文件另存为以name命名的新文件，并在当前缓冲区中开始编辑新文件：

```vim
:file name
```

## **工作目录**

使用以下命令，可以查看Vim所在的当前工作目录:

```vim
:pwd
```

## **切换目录**

如果想要切换到其它目录，可以使用以下命令:

```vim
:cd dir
```

注意：如果没有指定目录，那么使用`:cd`命令，在Linux下，将回到home用户主目录；而在Windows下，则会显示当前工作目录。

如果想要回到前一个工作目录，可以使用以下命令:

```vim
:cd - 
```



![img](https://pic2.zhimg.com/80/v2-68f6bb68d46d9cf4590a58b566714d51_720w.jpg)



编辑于 2018-08-06