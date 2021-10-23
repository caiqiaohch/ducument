# VIM学习笔记 在Mac下安装Vim

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

16 人赞同了该文章

## **查询当前安装版本**

使用以下命令，可以查看当前系统预装的Vim版本：

```bash
vim --version 
```

如下图所示，Mac预装的是不包括图形界面的Vim：

![img](https://pic3.zhimg.com/80/v2-06cca7c11722047299fb80ae0ce4c11a_720w.jpg)

不建议删除或更新系统预装的Vim，而是推荐新安装Vim的Mac实现--[MacVim](https://link.zhihu.com/?target=https%3A//macvim-dev.github.io/macvim/)。

## **安装MacVim**

[MacVim](https://link.zhihu.com/?target=https%3A//macvim-dev.github.io/macvim/)是在Vim基础上实现的完整的Cocoa用户界面。MacVim 采用了分离进程的方式，一个MacVim程序可以启动多个vim 进程，每个显示在一个MacVim窗口中，这是官方的vim和其他平台下的gvim所不支持的。MacVim 还支持很多 Mac OS X 原生的界面特性，比如工具栏、滚动条、全屏显示、Mac 菜单快捷键的绑定等。

首先[下载](https://link.zhihu.com/?target=https%3A//github.com/macvim-dev/macvim/releases)镜像文件，然后将程序拖拽到应用程序中即可完成安装。

双击MacVim图标，即可启动程序：

![img](https://pic3.zhimg.com/80/v2-e93b8a55c383d3d7f5f3b69c08c3ce0e_720w.jpg)

在MacVim中使用以下命令，可以查看详细的版本信息：

```vim
:version
```

如下图所示，已经安装了包括图形界面的MacVim：

![img](https://pic4.zhimg.com/80/v2-46ab94c4701a91a994e4af3edb928103_720w.jpg)

## **基本配置**

首先在HOME目录之下，创建.gvimrc文件；或者将安装目录下的示例文件/usr/share/vim/vim80/gvimrc_example.vim复制到用户目录之下并更名为~/.gvimrc；

然后依据安装目录/usr/share/vim/vim80的目录结构，在用户目录下的.vim目录中创建一致的目录结构；

![img](https://pic3.zhimg.com/80/v2-efe687bbc4da320730a4cb71828b4006_720w.png)

## **从命令行启动MacVim**

在Terminal中输入`/Applications/MacVim.app/Contents/bin/mvim filename`或者`open -a MacVim filename`命令，可以从命令行打开MacVim。