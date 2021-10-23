# VIM学习笔记 撤销 (Undo)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

## **单线撤销**

在Normal mode下使用u命令，或者在Command mode下使用:undo命令，可以撤销上一次的操作。

使用U命令，可以撤销所有针对当前行最近所做的修改。

Vim可以进行多次撤销，这个次数是由选项undolevels来指定的。例如我们可以使用以下命令，设置撤消次数为5000：

:set undolevels=5000

如果希望重做被撤销的操作，可以使用:redo或CTRL-R命令。

## **分支撤销**

以下述操作为例：新建文件并输入“大象”，然后在新的一行中输入“小牛”，返回Normal mode并按下u命令。这时输入“小牛”的操作被撤消，文件将只包含“大象”。接着输入“猩猩”，然后返回Normal mode并按下u命令，此时将撤消输入“猩猩”的操作，文件仍然只包含“大象”。所以你的“小牛”就再也找不回来了。而撤消分支（Undo branches）就可以解决这个问题。使用g-可以使文件重新包含入“大象”和“小牛”。此过程如下图所示：

![img](https://pic2.zhimg.com/80/v2-c5e38593c67c4751cfa2892f50f94275_720w.png)

如果你先撤销了若干改变，然后又进行了一些其它的改变。此时，被撤销的改变就成为一个分支。我们可以使用:undolist命令查看修改的各个分支。

![img](https://pic1.zhimg.com/80/v2-692ec9c6942ac0c886ecafd5c4149b68_720w.png)

- "编号" 列是改变号。这个编号持续增加，用于标识特定可撤销的改变。
- "改变" 列是根结点到此叶结点所需的改变数目。
- "时间" 列是此改变发生的时间。

使用:undo命令并指定编号做为参数，则能够撤销到某个分支。

通过在不同的撤消分支间跳转，使用g-命令能够回到较早的文本状态；而g+命令则返回较新的文本状态。

我们还可以根据时间撤消操作：使用:earlier 10m命令退回到10分钟前的文本状态。也可以用:later 5s命令跳转到5秒以后的编辑状态。命令参数中的"s"代表秒，"m"代表分钟，"h"代表小时。

使用:help undo-tree和:help usr_32.txt命令，可以查看撤消操作的帮助信息。

命令小结u撤消:undoCTRL-R重做:redo:undolist查看撤消分支g-返回较早的文本状态g+返回较新的文本状态:earlier退回到指定时间前的文本状态:later退回到指定时间后的文本状态

Ver: 1.1<[上一篇](https://link.zhihu.com/?target=http%3A//tiny.cc/vim-search) |[ 目录 ](https://link.zhihu.com/?target=http%3A//tiny.cc/learn-vim)| [下一篇](https://link.zhihu.com/?target=http%3A//tiny.cc/vim-print)>