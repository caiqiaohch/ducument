# 工具箱-版本控制(Toolkit-Git)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

众所周知，几乎所有Vim插件管理器都是使用**[GitHub](https://link.zhihu.com/?target=http%3A//github.com/)**来安装和更新插件；你也可以直接从GitHub[下载](https://link.zhihu.com/?target=https%3A//github.com/vim)Vim安装程序；而我的这个[VIM学习笔记](https://link.zhihu.com/?target=https%3A//github.com/yyq123/learn-vim%22)也是托管在GitHub上的，以实现在多台电脑上同步文档并进行版本管理。

本文并不会详细介绍GitHub的安装与使用，而是聚焦于如何使用GitHub与Vim相互配合。GitHub有着非常完善的（中文）[文档](https://link.zhihu.com/?target=https%3A//help.github.com/cn)；而视觉化的[git简明指南](https://link.zhihu.com/?target=http%3A//rogerdudler.github.io/git-guide/index.zh.html)更便于快速入门；还有表格化的[速查表](https://link.zhihu.com/?target=http%3A//rogerdudler.github.io/git-guide/files/git_cheat_sheet.pdf)可以随时查阅各种命令的参考信息。

![img](https://pic1.zhimg.com/80/v2-5a4c22581cc628970d14a1d993294844_720w.png)

## **Git客户端**

除了GitHub官方出品的[客户端](https://link.zhihu.com/?target=https%3A//desktop.github.com/)，[git-scm.com](https://link.zhihu.com/?target=https%3A//git-scm.com/downloads/guis)列出了各种操作系统下的更多客户端软件供您选择。

我强烈建议您尽量使用[Git命令](https://link.zhihu.com/?target=https%3A//git-scm.com/docs)，而不是依赖于某个客户端软件。事实上，只需要记忆非常有限的几个常用命令，就可以毫无障碍地在各种命令行环境中进行Git操作了。关于详细操作说明，推荐阅读[Learn the Basics of Git in Under 10 Minutes](https://link.zhihu.com/?target=https%3A//www.freecodecamp.org/news/learn-the-basics-of-git-in-under-10-minutes-da548267cc91/)。

![img](https://pic4.zhimg.com/80/v2-faed018e9ef0493f932d06b1ddb52ddb_720w.jpg)

## **文档写作**

![img](https://pic2.zhimg.com/80/v2-10729ea9b2f78c7e7388903beeef0131_720w.jpg)

我的这个[VIM学习笔记](https://link.zhihu.com/?target=https%3A//github.com/yyq123/learn-vim%22)，都是通过手工编写HTML代码来完成的。也就是说，我需要在多台电脑上的不同操作系统之下测试命令执行，然后持续修改网页源文件。正是GitHub帮助我完美实现了文档的一致性和版本控制。同时，利用[GitHub Pages](https://link.zhihu.com/?target=https%3A//pages.github.com/)功能，还可以自动发布为[网页](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/)以供浏览器直接阅读。

![img](https://pic3.zhimg.com/80/v2-55835249219667ea333f89be102ffac2_720w.jpg)

在此过程中，也充分体现了如下图所示的Git工作流程：

1. 在电脑A上，编辑文档并使用以下命令将变更提交到服务器：

- `$ git add`
- `$ git commit`
- `$ git push`

\2. 在电脑B上，使用以下命令从服务器上获取最新版本的文件：

- - `$ git pull`

![img](https://pic4.zhimg.com/80/v2-b85882503ce4b597107d4051f7ee357b_720w.jpg)Source: medium.com/free-code-camp

同理，也可以使用GitHub，在多台电脑间同步你的[dotfiles](https://link.zhihu.com/?target=https%3A//dotfiles.github.io/)配置文件。例如通过同步[.vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件，可以在多台电脑上快速部署相同的Vim配置，以获得相同的使用体验。

## **插件管理**

不管您是通过[vim-plug](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)，还是[Vundle](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html)来安装和管理插件，首先都需要使用`$ git clone`命令来安装插件管理器本身。而之后在安装其它插件时，也需要在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中指定GitHub Repository的名称。

如果您仍然习惯于手工安装插件，那么也可以直接从[GitHub](https://link.zhihu.com/?target=https%3A//github.com/topics/vim-plugin)克隆或者下载插件。

![img](https://pic2.zhimg.com/80/v2-4ef689c4833cb3610630c3fd4120583d_720w.jpg)

在[Vim官方网站](https://link.zhihu.com/?target=https%3A//www.vim.org/scripts/index.php)和[VimAwesome](https://link.zhihu.com/?target=https%3A//vimawesome.com/)中查找插件时，你也会发现相对应的GitHub链接。

## **代码片段管理**

[Gist](https://link.zhihu.com/?target=https%3A//gist.github.com/)是[GitHub](https://link.zhihu.com/?target=https%3A//github.com/)服务的一部分，用户可以将常用的代码片段存储云端，然后在不同的客户端中进行复用；也可以将代码片段内置到网页内，或者通过网址与他人分享。

使用[Gist.vim](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-103-plugin-Gist.html)插件，可以直接在Vim中管理Gist代码片段。你也可以使用[Lepton](https://link.zhihu.com/?target=http%3A//hackjutsu.com/Lepton/)等客户端软件，来管理Gist代码片段。

![img](https://pic4.zhimg.com/80/v2-950d9fd24e448eae6106fc2e5991949f_720w.jpg)



编辑于 2019-09-16