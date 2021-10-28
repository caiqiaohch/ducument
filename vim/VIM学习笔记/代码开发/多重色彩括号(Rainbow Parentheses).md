# 多重色彩括号(Rainbow Parentheses)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

在编写代码时，经常需要函数嵌套，这就会造成一行代码中会有很多括号，而变得难以阅读。我们可以使用[Rainbow Parenthesis](https://link.zhihu.com/?target=http%3A//www.vim.org/scripts/script.php%3Fscript_id%3D1561)插件或者[Rainbow Parentheses Improved](https://link.zhihu.com/?target=http%3A//www.vim.org/scripts/script.php%3Fscript_id%3D4176)插件，通过多种颜色来标识匹配的括号。

## **安装Rainbow Parentheses**

首先[下载](https://link.zhihu.com/?target=https%3A//www.vim.org/scripts/script.php%3Fscript_id%3D1561)Rainbow Parenthesis；然后在vim中打开下载的vba文件；最后执行:so %命令以完成安装。

![img](https://pic4.zhimg.com/80/v2-e24ad2881565e667ec71059542bcd69b_720w.png)

## **配置Rainbow Parentheses**

打开vimfiles\autoload\rainbow_parenthesis.vim文件，在第66行插入以下命令，以避免Rainbow Parentheses插件运行时报错。

![img](https://pic4.zhimg.com/80/v2-796b49cf3b7d2612a27ef619474d9393_720w.png)

将该文件第34-49行中的*guibg*部分删除，以避免Rainbow Parentheses插件改变括号的背景色。

![img](https://pic4.zhimg.com/80/v2-f30c4517fc61dee507d042feeb94c0b3_720w.png)

## **启用Rainbow Parentheses**

我们可以使用以下命令，手工启动Rainbow Parentheses插件：

```text
:ToggleRaibowParenthesis
```

显示效果如下图所示：

![img](https://pic1.zhimg.com/80/v2-c09e7b49ee1bd44bb6208c204b9011b0_720w.png)

也可以在*vimrc*文件里添加以下命令，在vim启动时自动加载Rainbow Parentheses插件：

![img](https://pic2.zhimg.com/80/v2-508039ac781580dd36263ea2b566d831_720w.png)

## **安装Rainbow Parentheses Improved**

[Rainbow Parentheses Improved](https://link.zhihu.com/?target=https%3A//www.vim.org/scripts/script.php%3Fscript_id%3D4176)在以下几个方面进行了改进：不再限制括号的嵌套层数；可以分别自定义图形界面下和终端上所使用的括号颜色；甚至可以为不同类型的文件设定不同的配置；增加了中文说明。

首先，将下载到的*rainbow.vim*文件放到*vimfiles/plugin*文件夹（在linux系统里是*~/.vim/plugin*文件夹）中。然后，将以下句子，加入到你的[vimrc](https://link.zhihu.com/?target=https%3A//yyq123.blogspot.com/2012/01/vim-vimrc.html)配置文件中：

```text
let g:rainbow_active = 1
```

## **启用Rainbow Parentheses Improved**

我们可以使用以下命令，手工启动Rainbow Parentheses插件：

```text
:RainbowToggle
```

显示效果如下图所示：

![img](https://pic4.zhimg.com/80/v2-014d3e7e229af194d5f3a919f7ce9f37_720w.png)

编辑于 2017-03-13