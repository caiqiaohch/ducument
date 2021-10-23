# 帮助信息 (Help)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

## **查看帮助**

使用以下命令或直接按下F1键，可以查看帮助文件：

:help

![img](https://pic3.zhimg.com/80/v2-14afca9a4390c3be923126e7e76749f6_720w.png)

使用查询命令，可以在帮助文件中查找特定主题的帮助信息。例如使用/mode命令，即可找到关于模式的帮助信息。

在帮助信息中的命令、选项或章节等链接上双击鼠标或点击ctrl-]键，就可以跳转到相关的帮助信息。点击ctrl-o或ctrl-t则可以在查阅过的帮助信息之间进行跳转。

## **帮助目录**

使用以下命令，可以显示用户手册的目录：

:help usr_toc

![img](https://pic2.zhimg.com/80/v2-f9b3ef5524d092791226d3430adba775_720w.png)

## **精确查找**

如果你想要查看特定命令的帮助信息，那么可以直接在帮助命令中指定命令做为参数：

:help :undo

通过set wildmenu设置命令，可以在窗口底部显示菜单选项。当我们并不知道确切的命令名称时，可以只输入开头的几个字母，然后按下Tab键，就将在wildmenu中显示可能匹配的命令。继续按Tab键，可以在这些命令列表间移动，按下回车键就会显示选中命令的帮助信息。

![img](https://pic1.zhimg.com/80/v2-5d6e3274c3a0f86c70287de51a703310_720w.png)

使用:help ctrl<Tab>命令，可以列出所有和CTRL键相关的帮助主题。使用:help i_CTRL-R命令，则只显示在插入模式下CTRL-R的帮助信息；而:help c_CTRL-R命令，则显示在常规模式下CTRL-R的帮助信息。

## **模糊查询**

如果不知道具体的命令名称，那么可以使用以下命令在所有帮助文件中查询相关信息。例如，使用此命令，将逐一显示所有与插入模式相关的帮助信息。

:helpgrep insert mode

![img](https://pic3.zhimg.com/80/v2-1c11aefcc954dce8518e9628d975210e_720w.png)

可以使用:cnext命令，查看下一条帮助信息；使用:cprev命令，查看上一条帮助信息。

如果有很多相关的帮助信息，可以使用:clist命令，列示所有包含指定主题的帮助信息。

![img](https://pic4.zhimg.com/80/v2-5f5c5171513cb6099cb001e44e69c9bb_720w.png)

使用:cwin命令，则可以在QuickFix窗口中列示所有相关帮助信息的条目。利用鼠标滚轴、方向键或j,k移动命令可以在条目间移动，按下回车键则可以打开当前条目的帮助信息。使用:cclose命令，可以关闭QuickFix窗口。

![img](https://pic3.zhimg.com/80/v2-3bf663e5951ae32d420b88bfccc49cb6_720w.png)

## **更多帮助资源**

:help quickref命令，可以查看快速索引：

![img](https://pic3.zhimg.com/80/v2-6dbd17a3b4932146a2b0518352a52fb2_720w.png)

:help tips命令，可以查看使用技巧：

![img](https://pic4.zhimg.com/80/v2-21589f91a3d93950e8d69391f6be47c3_720w.png)

我们还可以访问网页版的Vim帮助文件：[English Version](https://link.zhihu.com/?target=http%3A//vimdoc.sourceforge.net/htmldoc/help.html)|[中文版](https://link.zhihu.com/?target=http%3A//vimcdoc.sourceforge.net/doc/help.html)。

![img](https://pic1.zhimg.com/80/v2-b944d71ce2452640784630fd8614f1ac_720w.png)

Ver: 1.0<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2010/08/vim-print.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/02/vim_4321.html)>