# 标记(Mark)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

我们可以对文本进行标记，以方便在文档的不同位置间跳转。

## **创建标记**

将光标移到某一行，使用ma命令进行标记。其中，m是标记命令，*a*是所做标记的名称。

可以使用小写字母a-z或大写字母A-Z中的任意一个做为标记名称。小写字母的标记，仅用于当前缓冲区；而大写字母的标记，则可以跨越不同的缓冲区。例如，你正在编辑File1，但仍然可以使用'A命令，移动到File2中创建的标记A。

## **跳转标记**

创建标记后，可以使用'a命令，移动到指定标记行的首个非空字符。这里'是单引号。也可以使用`a命令，移到所做标记时的光标位置。这里`是反引号（也就是数字键1左边的那一个）。

## **列示标记**

利用:marks命令，可以列出所有标记。这其中也包括一些系统内置的特殊标记（Special marks）：

![img](https://pic3.zhimg.com/80/v2-3ad270e389126612cd2e5264a0930a4e_720w.png)

**.** 最近编辑的位置**0-9**最近使用的文件**∧** 
上一次跳转前的位置**"** 
上一次修改的开始处**]** 

## **删除标记**

如果删除了做过标记的文本行，那么所做的标记也就不存了。我们不仅可以利用标记来快速移动，而且还可以使用标记来删除文本，例如在某一行用ma做了标记，然后就可以使用d'a来删掉这一行。当然，我们也可以使用y'a命令就可以来复制这一行了。

使用:delmarks a b c命令，可以删除某个或多个标记；而:delmarks! 命令，则会删除所有标记。

利用:help mark-motions命令，可以查看关于标记的更多帮助信息。

## **plugin: vim-signature**

[vim-signature](https://link.zhihu.com/?target=https%3A//github.com/kshenoy/vim-signature)插件用于在屏幕最左侧显示标记。使用以下命令，可以定义标记的显示风格：

![img](https://pic2.zhimg.com/80/v2-5debae84f95300ed1ef227683aa46059_720w.png)

使用:help Signature命令，可以查看vim-signature插件定义的快捷键，用于在标记间快速移动。

编辑于 2017-03-06