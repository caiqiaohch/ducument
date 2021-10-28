# 字体(Font)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

11 人赞同了该文章

在Mac系统中，可以在Font Book中查看字体列表；在Linux系统中，可以用命令xlsfonts列出所有可用的字体；在Windows系统中，可以在控制面板中检查字体列表。

## **更改字体**

可以使用:set guifont=*命令，来打开字体选择对话框。

![img](https://pic2.zhimg.com/80/v2-71d4a1b7ba989fdfffb636ee918b279d_720w.png)

可以使用:set guifont=fontname命令，来更改当前使用的字体。

以下为 **Linux** 风格的字体设置语法。其中：字体名称和尺寸是以空格（Space）分隔的。如果字体名称中含有空格，则需要在空格前面加上一个反斜杠进行转义。

```vim
:set guifont=Andale\ Mono\ 11
```

以下为 **Mac** 风格的字体设置语法。其中：字体名称和尺寸是以冒号（:）分隔的。字体尺寸以字母h为前缀。如果字体名称中含有空格或逗号，则需要在特殊字符前面加上一个反斜杠进行转义。

```vim
:set guifont=Monaco:h11
```

以下为 **Windows** 风格的字体设置语法。其中：字体名称和尺寸是以冒号（:）分隔的。字体尺寸以字母h为前缀。如果字体名称中含有空格，则可以用下划线（_）来代替。

```vim
:set guifont=Andale_Mono:h11
```

为了提高字体设置的适用范围，可以在命令中用逗号分隔多个字体，如果Vim没有在系统中找到第一个字体，则会自动寻找字体列表中的后续字体。

```vim
:set guifont=Droid\ Sans\ Mono:h10,Consolas:h11:cANSI
```

## **字体设置实例**

你可以将以下代码添加到[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2012/01/vim-vimrc.html)配置文件之中，并设置为自己喜欢的字体：

```vim
 if has('gui_running')
    if has("win16") || has("win32") || has("win95") || has("win64")
        set guifont=Consolas:h11,Courier_New:h11:cANSI
    else
        set guifont=MiscFixed\ Semi-Condensed\ 10
    endif
endif
```

编辑于 2017-02-24