# VIM学习笔记 在Windows下安装Vim

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

41 人赞同了该文章

## **安装gVim**

首先[下载](https://link.zhihu.com/?target=https%3A//www.vim.org/download.php%23pc)GVim安装包，然后按照屏幕提示进行安装。

如下图所示，建议安装Vim的完整特性（包括创建用于命令行的.bat文件）：

![img](https://pic2.zhimg.com/80/v2-6c59109bb693e6c2f505e4c2da7d9495_720w.jpg)

安装完成之后，即可以从开始菜单启动Vim：

![img](https://pic2.zhimg.com/80/v2-f47fb8ed100c8df8528d9320e6863b8d_720w.jpg)

以下表格列示了菜单项所对应的命令和参数：

![img](https://pic1.zhimg.com/80/v2-52723d0ee07d35f5e459c66329a90638_720w.jpg)

在Windows命令行中使用以下命令，可以查看已安装Vim的版本信息：

```
vim --version
```

![img](https://pic4.zhimg.com/80/v2-d2449dcd4e24f5cc6c8ddf3910a61f2f_720w.jpg)

在Vim中使用以下命令，可以看到Vim主要目录都指向了系统文件夹：

```vim
:echo $VIM
C:\Users\username
:echo $HOME
C:\Users\username
:echo $VIMRUNTIME
C:\Program Files (x86)\Vim\vim81
```

## **配置gVim**

首先在Windows用户目录\username之下，创建_vimrc文件；或者将安装目录下的示例文件C:\Program Files (x86)\Vim\vim81\vimrc_example.vim复制到用户目录之下并更名为_vimrc；

然后依据安装目录C:\Program Files (x86)\Vim\vim81的目录结构，在用户目录下的vimfiles目录中创建一致的目录结构；

![img](https://pic3.zhimg.com/80/v2-efe687bbc4da320730a4cb71828b4006_720w.png)

请确保在Windows环境变量Path中，包含以下Vim的安装目录：

```
C:\Program Files (x86)\Vim\vim81
```

## **安装gVim Portable**

如果你没有权限安装软件，或者不想安装软件，那么也可以选择便携/绿色版[gVim Portable](https://link.zhihu.com/?target=https%3A//portableapps.com/apps/development/gvim_portable)。

首先下载安装包，然后选择将程序放置到本地磁盘或者U盘中。

在安装目录中，双击gVimPortable.exe文件，即可启动gVim Portable：

![img](https://pic2.zhimg.com/80/v2-f2a9023d8c44a23a05c23eabd1899895_720w.jpg)

![img](https://pic1.zhimg.com/80/v2-7e0ba326561e1257e2a1e2f86d9a042c_720w.jpg)

在Vim中使用以下命令，可以查看详细的版本信息：

```
:version
```

![img](https://pic4.zhimg.com/80/v2-f68da624ce869099aedd1e463d0ffc1f_720w.jpg)

在Vim中使用以下命令，可以查看gVim Portable主要目录的指向：

```text
:echo $VIM
E:\Anthony_Tools\gVimPortable\App\vim
:echo $HOME
E:\Anthony_Tools\gVimPortable\Data\settings
:echo $VIMRUNTIME
E:\Anthony_Tools\gVimPortable\App\vim\vim80
```

对比之前安装的gVim，可以发现gVim Portable的主要目录都指向了软件所在的文件夹。也就是说，运行文件和配置文件都存放在同一目录结构之下；您只需要复制此目录就可以在不同的电脑中，使用完全一致的gVim，而省去了重复的安装和配置工作。您也可以将gVim Portable存放在U盘中，真正实现即插即用。

## **配置gVim Portable**

请在\gVimPortable\Data\settings目录中，保存配置信息和定制化内容，此目录不会在升级过程中被覆盖。

首先在\gVimPortable\Data\settings目录之下，已经预置了_vimrc文件，你可以在此基础上进行修改；

![img](https://pic1.zhimg.com/80/v2-2dec45a66650351f2d6c773154bc9a4c_720w.jpg)

然后依据安装目录C:\Program Files (x86)\Vim\vim81的目录结构，在\gVimPortable\Data\settings目录下的vimfiles目录中创建一致的目录结构。