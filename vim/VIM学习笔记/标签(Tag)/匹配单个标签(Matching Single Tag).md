# 匹配单个标签(Matching Single Tag)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

[上节](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-79-01-Tag-File.html)介绍了如何使用Ctag工具来生成标签文件（Tags File）。本节将介绍基于标签文件，快速在标签之间进行跳转的操作。

标签是出现在标签文件（Tags File）中的一个标识符。它是一种能够跳转的标记。例如，在 C 程序里，每个函数名都可以是一个标签。

## 标签跳转

使用以下命令，可以直接跳转至定义标签的位置：

```vim
:tag {name}
```

在常规模式下，使用 **Ctrl-]** 快捷键，也可以查找光标下的标签（比如函数或宏等），并跳转到定义该标签的位置。

在常规模式和插入模式下，按住Ctrl键并点击鼠标左键（****），也可以跳转至标签定义处。

使用以下命令，可以在新建窗口中跳转到定义标签的位置：

```vim
:stag {name}
```

在常规模式下，使用 **Ctrl-W]** 快捷键，也可以在新建窗口中跳转到定义标签的位置。

## 标签栈（Tag Stack）

根据'tagstack'选项的默认设置，Vim会在标签栈中记录你跳转过的标签，以及是从哪里跳转到这些标签。

使用以下命令，可以查看标签栈的内容：

```vim
:tags
```

![img](https://pic4.zhimg.com/80/v2-f172a2e62e136048d54f36d0b75dd2ff_720w.jpg)

使用以下不带任何参数的命令，可以跳转到较新的标签处：

```vim
:tag
```

使用以下命令，可以返回到之前的标签处：

```vim
:pop
```

在常规模式下，使用使用 **Ctrl-T** 键，可以依次返回之前所处的位置。

在常规模式和插入模式下，按住Ctrl键并点击鼠标右键（****），也可以返回之前所处的位置。

如下图所示，首先使用:tag命令跳转至指定的标签，然后使用:pop命令返回到之前的位置。请留意屏幕底部输入的命令，以及白色高亮行的跳转过程：

![img](https://pic1.zhimg.com/v2-fcb968ad3269f2f250486b89c9a22cf8_b.jpg)

使用`:h tag-stack`命令，可以查看标签栈的帮助信息。

![img](https://pic3.zhimg.com/80/v2-f1de7c5c1dfb8dff7c441c81d32e79c2_720w.jpg)



编辑于 2020-02-17