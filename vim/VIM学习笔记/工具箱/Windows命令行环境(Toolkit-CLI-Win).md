# Windows命令行环境(Toolkit-CLI-Win)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

通过命令行环境（Command-Line Interface, CLI），可以更快速地执行操作，并且能够自动化一系列繁琐的任务。比如在多个文件中，批量替换指定的字符串等。下文将介绍在Windows下，搭建运行Linux命令的虚拟终端，并将Vim配置至此Shell环境。

本文并不会详细介绍每个工具的安装步骤和使用细节，而是聚焦于各个工具与Vim相互配合。文中推荐的工具，完全基于个人主观的偏好，您可以在[AlternativeTo](https://link.zhihu.com/?target=https%3A//alternativeto.net/)网站中寻找功能类似的软件。

## Cygwin

**[Cygwin](https://link.zhihu.com/?target=https%3A//cygwin.com/)**，是 Windows下的Linux命令行环境。它包括一个提供GNU功能性基本子集的DLL以及在这之上的一组工具。

在安装过程中，您可以选择需要的软件包，比如grep、sed、curl等等。你也可以搜索“vim”关键字，找到vim以及相关的工具。

![img](https://pic1.zhimg.com/80/v2-8a3c1b7eceea94138325c6fc0dab5774_720w.jpg)



请选择安装“**zsh**”。之后您可以随时再次运行Cygwin安装程序，以安装和更新软件包。

## ConEmu

**[ConEmu](https://link.zhihu.com/?target=https%3A//conemu.github.io/)**，是一个美观易用的虚拟终端，可以在多个标签中，同时打开Windows命令提示符（Command Prompt）,powershell，Cygwin和Git bash等等。

![img](https://pic2.zhimg.com/80/v2-a608ce6cf2ba5a8c23510fca365b1c19_720w.jpg)

在“Settings...”窗口中，选择“Startup > Tasks”，然后在“Predefined Tasks”列表中新建打开Zsh的[任务](https://link.zhihu.com/?target=https%3A//conemu.github.io/en/CygwinMsysConnector.html)：

![img](https://pic3.zhimg.com/80/v2-cd1b2147c53f9660340a50845be14afe_720w.jpg)



请在以上屏幕截图的黄色高亮区域内，输入以下命令：

```text
set CHERE_INVOKING=1 & set  "PATH=D:\cygwin64\bin;%PATH%" &  %ConEmuBaseDirShort%\conemu-cyg-64.exe -new_console:p  D:\cygwin64\bin\zsh.exe --login -i  -new_console:C:"D:\cygwin64\Cygwin.ico"
```

请注意，本文假设Cygwin安装在“D:\cygwin64”目录；请根据您的实际安装位置，相应调整命令。

使用“Create new console”按钮，可以打开{Zsh::CygWin zsh}：

![img](https://pic3.zhimg.com/80/v2-0c34298771c4b4a9c68cd08b13ad2be2_720w.jpg)

在终端中使用`uname -a`命令，可以查看当前Cygwin的版本：

![img](https://pic2.zhimg.com/80/v2-74193327b526e75c0ba34262b6dbdf2d_720w.png)

使用`cygcheck --check-setup`命令，可以列示当前已安装的软件包：

![img](https://pic1.zhimg.com/80/v2-3f63d985d7eb8b9750c905c993ca3974_720w.jpg)

使用`echo $SHELL`命令，可以查看当前使用的shell：

![img](https://pic1.zhimg.com/80/v2-2a544cb9b02450bb06c75c6591315838_720w.jpg)

通过`/cygdrive`路径，可以访问本地磁盘：

![img](https://pic3.zhimg.com/80/v2-dd2835d62ea47c2d413e96c169f25aea_720w.png)

## Oh My Zsh

**[Oh My Zsh](https://link.zhihu.com/?target=http%3A//ohmyz.sh/)**，是由Robby Russell开发的zsh管理框架，使用其预配置的选项，可以大大提高使用zsh的便捷性。

使用以下命令，安装Oh My Zsh：

```bash
git clone git://github.com/robbyrussell/oh-my-zsh.git C:\Users\username\.oh-my-zsh
```

使用以下命令，生成默认的配置文件：

```bash
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

## 配置Vim使用Cygwin Shell

Vim在Windows下，默认使用命令提示符 "Command Prompt"：

```vim
:set shell=$COMSPEC
shell=C:\WINDOWS\system32\cmd.exe
```

在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中增加以下命令，将配置Vim使用Cygwin的Shell环境：

```text
" 在当前目录打开bash
let $CHERE_INVOKING=1
" 使用Cygwin bash
set shell=D:\cygwin64\bin\bash.exe
" 缺少--login参数将无法挂载/usr/bin/等目录
set shellcmdflag=--login\ -c
" 缺省值为(, 需要为bash设置成"
set shellxquote=\"
" 在路径中使用/以替代\
set shellslash
" 在PATH变量中增加cygwin目录
let $PATH .= ';D:\cygwin64\bin'
```

在Vim中使用`:terminal`命令，即可打开Cygwin bash终端窗口：

![img](https://pic2.zhimg.com/80/v2-558d4ff6d45be15f4e0a17753e324d99_720w.jpg)

你也可以使用`:!`或`:shell`命令，来[执行bash命令](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-71-Shell.html)。

## 配置Vim打开Windows命令行

在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中增加以下命令，将配置[leader](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-54-Leader.html)快捷键以打开Windows命令提示符：

```vim
nnoremap <leader>cc :!start cmd /k cd %:p:h:8<cr>
```

## One more thing...

我为ConEmu制作了一个暗黑系的[DarkSide](https://link.zhihu.com/?target=https%3A//github.com/yyq123/DarkSide-theme/tree/master/conemu)主题。关于安装和使用说明，请参考[自述文件](https://link.zhihu.com/?target=https%3A//github.com/yyq123/DarkSide-theme/blob/master/conemu/README.md)。

![img](https://pic2.zhimg.com/80/v2-cd0ddbe0f5bee03f93d9ba8ea32236dd_720w.jpg)



发布于 2019-10-30