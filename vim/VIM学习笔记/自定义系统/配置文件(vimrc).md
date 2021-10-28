# 配置文件(vimrc)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

14 人赞同了该文章

在vim启动过程中，首先将查找配置文件并执行其中的命令。初始化文件一般有vimrc、gvimrc和exrc三种。

使用`:version`命令，可以查看配置文件的详细列表：

![img](https://pic3.zhimg.com/80/v2-0f2f2a10817b30f70d42e59886a1e2ba_720w.jpg)

注意：如果执行gvim，那么$VIMRUNTIME/menu.vim也会被执行。

## **配置文件位置**

**vimrc**是主配置文件，它有全局和用户两种版本。

全局global vimrc文件，存放在Vim的安装目录中。可以使用以下命令，确定Vim的安装目录：

```vim
:echo $VIM
```

默认情况下，系统vimrc存放在以下位置：

Linux: /usr/share/vim/vimrc

Windows: c:\program files\vim\vimrc

用户personal vimrc文件，存放在用户主目录中。可以使用以下命令，确定用户主目录：

```vim
:echo $HOME
```

默认情况下，用户vimrc存放在以下位置：

Linux: /home/username/.vimrc

Windows: c:\documents and settings\username\_vimrc

用户personal vimrc文件，可以使用以下命令确定：

```vim
:echo $MYVIMRC
```

注意：用户配置文件优先于系统配置文件。

**gvimrc**是GVIM的配置文件，它也有全局和用户两种版本，并且存放在与vimrc相同的目录中。

默认情况下，系统gvimrc存放在以下位置：

Linux: /usr/share/vim/gvimrc

Windows: c:\program files\vim\_gvimrc

默认情况下，用户gvimrc存放在以下位置：

Linux: /home/username/.gvimrc

Windows: c:\documents and settings\username\_gvimrc

**exrc**文件，仅用于向后兼容olvi/ex，它的全局和用户两种版本也放置于vimrc相同的目录里。除非你使用vi-compatible模式，否则不需要关注exrc配置文件。

注意：在Unix和Linux下，vim的配置文件被命名为以点开头的隐藏文件；而在Windows下，配置文件则以下划线开头命名。

## **编辑配置文件**

可以使用以下命令，新建缓冲区来编辑配置文件：

```vim
:edit $MYVIMRC
```

也可以使用以下命令，新建标签页来编辑配置文件：

```vim
:tabedit $MYVIMRC
```

## **应用配置文件**

修改配置文件后，需要重新启动Vim，或使用:source命令来应用新的设置：

```vim
:source $MYVIMRC
```

我们可以在配置文件中增加以下命令，在保存后自动应用配置：

```vim
autocmd bufwritepost .vimrc source $MYVIMRC
```

## **配置文件实例**

为了更结构化和模块化的组织vimrc文件，通常会利用自动[折叠](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-63-Fold.html)功能来分节设置各类选项。

例如以下语法将设置一个章节，并将具体的选项包含其中：

```vim
" Section Name {{{
	set number "This will be folded
" }}}
```

打开vimrc文件之后，将仅仅显示折叠之后的章节结构：

![img](https://pic3.zhimg.com/80/v2-9dc922804bfbcebe6d2bdee23b3cadee_720w.jpg)

展开折叠将可以查看详细的配置命令。建议使用引号（"）进行详细注释：

![img](https://pic2.zhimg.com/80/v2-93903045265b4daf524ba49d4d4025c5_720w.jpg)

请参阅[折叠](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-63-Fold.html)章节，了解文本折叠及展开的操作方法。

在各个章节中，已经对具体选项进行详细介绍，在此不再赘述。

请参考以下本人的在Windows下的vim配置：

- [_vimrc](https://link.zhihu.com/?target=https%3A//github.com/yyq123/learn-vim/blob/master/samples/_vimrc)文件
- 使用`:TOhtml`命令生成的[HTML](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vim-vimrc-example.html)网页文件

使用以下命令，可以查看更多帮助信息：

```vim
:help vimrc
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-209-Start.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-modeline.html)>

发布于 2020-07-03