# 文件浏览器(Netrw)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

40 人赞同了该文章

在vim 7.0之前，文件浏览功能由explorer.vim插件提供；从vim 7.0之后，这个插件被netrw.vim插件所代替。Netrw插件伴随vim发行，不需要单独安装。

## **启动**

使用`:Explore`命令或缩写`:E`命令（注意E大写），将在当前窗口中打开文件浏览器：

![img](https://pic4.zhimg.com/80/v2-779a8a5ab0e3a38a3fa4c9ebc4f83a43_720w.jpg)

使用`:Sexplore`命令或缩写`:Sex`命令，将在水平拆分窗口中打开文件浏览器：

![img](https://pic1.zhimg.com/80/v2-60d4ed7082fab80291e3df757844e480_720w.jpg)

使用`:Vexplore`命令或缩写`:Vex`命令，将在垂直拆分窗口中打开文件浏览器：

![img](https://pic2.zhimg.com/80/v2-443beb3b6c84b0d8c0b6f0b3e7764ea5_720w.jpg)

当然，也可以在启动Netwr时，指定浏览特定的文件夹：

```
:Sex C:\Temp
```

## **打开文件**

在Netrw中，可以切换目录并打开文件。使用键盘移动光标至文件或文件夹名称上，然后点击Enter回车键，可以在当前窗口中打开该文件或文件夹；如果希望在新建窗口中打开文件或文件夹，那么可以点击o键。

直接使用鼠标点击文件或文件夹名称，也可以在当前窗口中打开该文件或文件夹。

点击/键，可以在文件列表中进行查找。

![img](https://pic2.zhimg.com/80/v2-31ff96b2e7f281cea25bdadf9bc652cd_720w.jpg)

## **改变盘符和目录**

通过编辑目录，可以使用Netrw来浏览该文件夹：

```
:edit E:\_ToDo
```

## **排序**

通过设置g:netrw_sort_by和g:netrw_sort_direction，可以按照最近修改时间来进行排序：

```vim
let g:netrw_sort_by = 'time'
let g:netrw_sort_direction = 'reverse'
```

## **重命名**

点击大写R键，然后修改窗口底部信息中的第二个文件名，可以重命名当前光标下的文件。

![img](https://pic3.zhimg.com/80/v2-3a9e2283370ccd508378ff850e060346_720w.jpg)

## **删除**

点击大写D键，然后在窗口底部信息中进行确认，则可以删除当前光标下的文件。

![img](https://pic2.zhimg.com/80/v2-0535b80bccfd9149c1c89360e03b5f41_720w.jpg)

## **配置文件打开方式**

默认情况下，Netrw将在当前窗口中打开文件。 使用以下命令，可以配置Netrw打开文件的方式：

```
let g:netrw_browse_split = n
```

其中，参数的值可以为以下四种：

1. 用水平拆分窗口打开文件
2. 用垂直拆分窗口打开文件
3. 用新建标签页打开文件
4. 用前一个窗口打开文件

## **定制外观**

点击i键，可以在thin/long/wide/tree这4种显示模式之间切换。也可以在[vimrc配置文件](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)中，使用以下命令来设置显示模式：

```
let g:netrw_liststyle = 3
```

点击I键，可以显示或隐藏Netrw顶端的横幅（Banner）。例如以下命令，将隐藏横幅：

```
let g:netrw_banner = 0
```

使用以下命令，可以设置文件浏览器的宽度，为窗口的25%：

```
let g:netrw_winsize = 25
```

通过以上配置，我们可以得到通常IDE环境的文件显示效果：

![img](https://pic4.zhimg.com/80/v2-5f89cf58be155f94e6d9382f1d9a3663_720w.jpg)

## **退出**

使用`:q`命令，可以退出当前的Netrw；如果Netrw是唯一打开的窗口，那么将同时退出Vim。

我们可以将Netrw理解为，使用编辑命令对于目录进行操作的特殊缓冲区。也就是说，我们可以使用`:bdelete`命令，来关闭Netwr打开的缓冲区，但不会退出Vim。

## **帮助信息**

Netrw不仅可以浏览本地文件，还支持远程文件的读写。你可以通过ftp，ssh，http等多种协议来浏览远程机器的目录并编辑远程文件。

如果你使用图形界面的GVim，那么也可以通过菜单来使用Netrw的功能：

![img](https://pic1.zhimg.com/80/v2-d9acd8e5fd290caa0296dbc49844af08_720w.jpg)

在Netrw中点击F1键，或者使用`:help netrw`命令，可以查看更多帮助信息。

发布于 2019-04-06