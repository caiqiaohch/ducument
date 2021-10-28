# 色彩测试(colortest)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

## GVim中的色彩测试

运行以下内置脚本（Vimscript），可以查看各种颜色作为前景（foreground）和背景（background）的显示效果，以及在浅色（white）和深色（black）背景下的显示效果。

```vim
:runtime syntax/colortest.vim
```

![img](https://pic3.zhimg.com/80/v2-3f1c38cead95ae8b49d2699b959921ea_720w.jpg)

通过以下内置文件，可以查看Vim预定义的色彩名称：

```vim
:view $VIMRUNTIME/rgb.txt
```

![img](https://pic3.zhimg.com/80/v2-6998e365521b0a92bf7a32e0d0343af2_720w.jpg)

你可以下载并在GVim中打开[colorname.vim](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/samples/colorname.vim)，然后执行`:so %`命令。此脚本文件将新建缓冲区，显示rgb.txt文件中色彩的显示效果：

![img](https://pic4.zhimg.com/80/v2-be94e389fb7f84a4b898bbf1e54f30e3_720w.jpg)

你可以下载并在GVim中打开[colorlist.vim](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/samples/colorlist.vim)，然后执行`:so %`命令。此脚本文件将以紧凑列表的形式，显示rgb.txt文件中色彩的显示效果：

![img](https://pic3.zhimg.com/80/v2-af587dd6f8fccd7c7c7eb482bcfb990a_720w.jpg)

## Terminal中的色彩测试

现今，几乎所有虚拟终端（比如[GNOME Terminal](https://link.zhihu.com/?target=https%3A//wiki.gnome.org/Apps/Terminal)，[iTerm2](https://link.zhihu.com/?target=https%3A//iterm2.com/)，[ConEmu](https://link.zhihu.com/?target=https%3A//conemu.github.io/)等）都是支持256 (Xterm)色的。

在终端中执行以下命令，可以查看256色的显示效果：

```bash
$ curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
```

![img](https://pic1.zhimg.com/80/v2-5b0da376bad4e4f6671c93c9f6a6fa0c_720w.jpg)

为了启用256色，请在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件的[colorscheme](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-62-ColorScheme.html)配色方案设置之前增加以下命令：

```vim
set t_Co=256
```

你可以在[256 COLORS - CHEAT SHEET](https://link.zhihu.com/?target=https%3A//jonasjacek.github.io/colors/)中，查看256色的Xterm Number和Xterm Name，以及与HEX和RGB格式的对应关系：

![img](https://pic2.zhimg.com/80/v2-6411b944d8d16ae9f1b9e3d9d5f0a171_720w.jpg)

也就是说，在您选择使用特定色彩时，需要同时考虑在GUI图形界面和Xterm虚拟终端中的显示效果，以便能够获得理想且一致的感官。换句话说，在图形界面中可以正常显示的色彩，可能并无法在虚拟终端中使用。当然，您也可以针对不同的使用环境，选择使用不同的色彩。

编辑于 2019-11-22