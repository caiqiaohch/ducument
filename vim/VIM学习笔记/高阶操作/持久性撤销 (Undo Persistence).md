# 持久性撤销 (Undo Persistence)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

持久性撒消（persistent undo），会将撒消树保存到撤销文件中，因而即使被编辑文件被关闭再打开多次，也可以撤销过去进行的所有修改（当然不能超过[undolevel](https://link.zhihu.com/?target=http%3A//vimdoc.sourceforge.net/htmldoc/options.html%23'undolevels')的限制）。

## **启用持久性撤销**

默认情况下，Vim并没有启用持久性撤销。使用以下命令，可以启用持久性撤销：

```vim
set undofile 
```

Vim将为正在编辑的文件，分别创建独立的撤销文件，用以保存支持撤销操作的信息。

## **生成撤销文件**

撤销文件通常保存在文件本身所在的目录里。使用以下命令，可以将撤销文件集中保存到指定的目录：

```vim
set undodir=$HOME/.vim/undodir
```

请注意，需要确保您指定的目录已经存在。

生成的撤销文件，将以所编辑文件的完整名称命名。其中包括了完整的路径名，其中“/”将以“%”代替：

![img](https://pic3.zhimg.com/80/v2-042e0822f776b33d7e3bffb0990b4db2_720w.png)

Vim只会创建撒消文件，而永远不会去删除它们；如果你更改了文件名称，那么旧文件名所对应的撤销文件也不会被自动删除。建议，将撤销文件存储到指定目录（比如temp临时目录），并定期进行手动清理。

## **撤销操作**

使用:earlier {N}f 和 :later {N}f 命令，可以根据写入次数进行撤销。

例如以下用命令，可以恢复到上次写入时的文本状态：

```vim
:earlier 1f
```

使用`:help persistent-undo`命令，可以查看关于持久性撤消的[帮助信息](https://link.zhihu.com/?target=http%3A//vimcdoc.sourceforge.net/doc/undo.html%23undo-persistence)。

编辑于 2020-03-13