# 多编码侦测器(fencview.vim)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

Vim内置的[多编码（Multi-Encodings）处理](https://link.zhihu.com/?target=https%3A//gist.github.com/)能力，可以很好地判断并显示不同编码格式的文件，而[fencview.vim](https://link.zhihu.com/?target=https%3A//www.vim.org/scripts/script.php%3Fscript_id%3D1708)插件，则提供了更强大地功能。

## **安装配置**

你可以直接下载[fencview.vim](https://link.zhihu.com/?target=https%3A//www.vim.org/scripts/script.php%3Fscript_id%3D1708)文件，然后将其放入vimfiles\plugin目录之中。

推荐的方法是，使用[vim-plug](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)或[Vundle](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html)等插件管理器，来安装GitHub上的[fencview.vim](https://link.zhihu.com/?target=https%3A//github.com/mbbill/fencview)插件。

## **自动侦测**

以下图所示的文件为例，文件被错误判断为latin1编码格式，故而显示乱码：

![img](https://pic4.zhimg.com/80/v2-38fc981fbcffaecb9fa7a8f133d1c9eb_720w.jpg)

使用 `:FencAutoDetect` 命令，将会自动侦测编码格式。

使用 Tools->Encoding->Auto Detect 菜单，也可以自动侦测编码格式。

![img](https://pic3.zhimg.com/80/v2-b11d4fb784b00303f9443902fba2cd82_720w.jpg)

## **手动侦测**

如果使用自动侦测，仍然没有正确判断文件编码，那么可以使用 `:FencView` 命令，来显示编码列表：

![img](https://pic4.zhimg.com/80/v2-d33d3a4bd1aedeedc96310b9af07d3df_720w.jpg)

在选择了正确的编码格式之后，文本显示正常：

![img](https://pic3.zhimg.com/80/v2-3d42efc158156645b9a99cba911f4ffa_720w.jpg)

在菜单`Tools`->`Encoding`中，也可以选择需要的编码格式：

![img](https://pic1.zhimg.com/80/v2-9a62251bc960a1314c5c0f8472e4ace0_720w.jpg)



发布于 2019-03-13