# VIM学习笔记 目录结构 (Directory Structure)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

9 人赞同了该文章

使用`:version`命令，可以查看Vim查找配置文件的位置和顺序：

Windows下的查找路径：

![img](https://pic3.zhimg.com/80/v2-0f2f2a10817b30f70d42e59886a1e2ba_720w.jpg)

Linux下的查找路径：

![img](https://pic2.zhimg.com/80/v2-d21d18fa94cdf696b26a763c97e673e9_720w.jpg)

从虚拟的变量对应物理的目录结构，左侧为安装Vim的目录，而右侧为用户目录：

![img](https://pic4.zhimg.com/80/v2-f36fb0e7f843be6053e115d352464157_720w.jpg)

## **VIM 安装目录**

使用以下命令，可以查看$VIM所代表的Vim安装目录：

```vim
:echo $VIM
```

对于Linux操作系统，Vim通常被安装在以下目录：

```text
/usr/share/vim
```

对于Windows操作系统，Vim将被安装在以下目录：

```text
C:\Program Files\vim
```

对于以上默认安装目录，您不应该修改其中的内容，也不应该在其中存放用户相关的文件。安装目录主要包括以下内容：

![img](https://pic4.zhimg.com/80/v2-d2b35d8192c7a3f92b4a8b53f4c6727b_720w.jpg)

## **HOME 用户目录**

使用以下命令，可以查看$HOME所代表的用户目录：

```text
:echo $HOME
```

对于Linux操作系统，用户目录为：

```text
/home/username
```

对于Windows操作系统，用户目录为：

```text
C:\Users\username
```

由于用户目录在vim版本升级时也不会被覆盖，建议在其中存放用户设置信息。

如果本机上有多个用户，那么每个用户都可以将自己的vim设置和插件，存放在自己的目录里，以实现不同用户使用各自不同的独立设置。

在首次使用Vim之前，请先创建[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)用户配置文件：

```text
Linux: /home/username/.vimrc
Windows: c:\users\username\_vimrc
```

用户应该将个性化设置存放在用户配置文件（personal vimrc），而不应修改系统配置文件（global vimrc）。

## **VIMRUNTIME 运行时目录**

使用以下命令，可以查看$VIMRUNTIME所代表的运行时目录：

```vim
:echo $VIMRUNTIME
```

对于Linux操作系统，运行时目录为：

```text
/usr/share/vim/vim81
```

对于Windows操作系统，运行时目录为：

```text
C:\Program Files\Vim\vim81
```

在Vim启动时，会遍历运行时目录，以载入并运行其中的脚本文件。

使用以下命令，可以查看运行时目录的详细列表：

```vim
:set rtp?
```

使用以下命令，可以修改或增加运行时目录：

```vim
:set runtimepath+=c:/blahblah/vimfiles
```

Vim通常会搜索以下三个运行时目录及其子目录：

- $HOME/vimfiles（用户目录下的vimfiles）
- $VIM/vimfiles （安装目录下的vimfiles）
- $VIMRUNTIME （安装目录下的vimxx，比如vim72）

![img](https://pic3.zhimg.com/80/v2-f2ab85f4153b3dd14b677066169cdaba_720w.jpg)

请注意：vimfiles目录中的设置，优先于runtime目录中的设置。例如，vimfiles/plugin/myplug.vim 将优先于 $VIMRUNTIME/plugin/myplug.vim。

使用`:help rtp`命令，可以查看更多帮助信息。

![img](https://pic3.zhimg.com/80/v2-305b71074500c8218ba308d4a8e5e6f2_720w.jpg)



发布于 2019-05-18