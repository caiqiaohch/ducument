# VIM学习笔记 在Linux下安装Vim

几乎所有的Linux发行版本都预装了Vi或Vim。比如Fedora就默认安装了vim-minimal。下文将以Fedora为例，介绍Vim的安装和基本配置。

## **查询当前安装版本**

使用以下命令，可以发现当前已经安装了vim-minimal：

```
sudo dnf list installed | grep vi
```

使用以下命令，可以查看vim-minimal的详细信息：

```
dnf info vim-minimal
```

![img](https://pic1.zhimg.com/80/v2-e8f7c6c70a8664f818a6a3a32d56e770_720w.jpg)

在Terminal中输入`vi --version`命令，可以看到vim-minimal是一个仅提供vi兼容命令的精简版本。以“-”标识的未启用特性中，包括[语法高亮度显示](https://link.zhihu.com/?target=http%3A//bit.ly/vim-syntaxHL)和[折叠](https://link.zhihu.com/?target=http%3A//bit.ly/vim-Fold)等重要功能。因此，我们需要安装完整版本的vim-enhanced。

![img](https://pic1.zhimg.com/80/v2-7571e93173be26e9ca9683d560b8d4c8_720w.jpg)

## **安装Vim**

使用以下命令，可以查看vim-enhanced的详细信息：

```
dnf info vim-enhanced
```

![img](https://pic3.zhimg.com/80/v2-b371d113bf92dff3c497e3b4b316b78a_720w.jpg)

使用以下命令，可以安装vim-enhanced：

```
sudo dnf install vim-enhanced
```

在Terminal中输入`vim --version`命令，可以看到vim-enhanced包含除图形界面之外的更多特性。如果你需要GUI版本的Vim，可以安装GVim：

![img](https://pic1.zhimg.com/80/v2-9ca6c4a748a90b17219bf8afb0773d98_720w.jpg)

## **安装gVim**

打开Fedora预装的软件管理器Software，然后在其中搜索“gVim”，就可以进行安装：

![img](https://pic1.zhimg.com/80/v2-fef5c49b3d808667a6646685bfd65098_720w.jpg)

## **基本配置**

首先在HOME目录之下，创建.vimrc文件；或者将安装目录下的示例文件/usr/share/vim/vim81/vimrc_example.vim复制到用户目录之下并更名为~/.vimrc；

然后依据安装目录/usr/share/vim/vimfiles的目录结构，在用户目录下的.vim目录中创建一致的目录结构；

![img](https://pic3.zhimg.com/80/v2-efe687bbc4da320730a4cb71828b4006_720w.png)

## **验证安装**

在Terminal中输入`vim`命令，可以打开命令行版本的vim：

![img](https://pic3.zhimg.com/80/v2-cea837eca6a7e3753f2caec2cc2f0fc6_720w.jpg)

在Terminal中输入`gvim`命令，可以打开图形界面版本的gVim：

![img](https://pic1.zhimg.com/80/v2-d5232e86fe3cae961a08a447248b69c8_720w.jpg)