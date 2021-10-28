# 图形界面选项(guioptions)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

## **GUI选项**

使用以下命令，可以通过guioptions选项来设置GUI特征：

```vim
:set guioptions=options
```

其中 *options* 是一个字母集合，每个字母代表一个选项：

- **`a`，**Autoselect，如果设定了此选项，那么在可视化模式下选中文本，Vim会将所选文本放置到系统的全局寄存器中。这就意味着，可以将当前选中的文本用命令 "*p 粘贴到其他文件。如果没有设定此选项，那么就需要使用命令 "*y 将所选择的文本复制到系统寄存器中。在系统寄存中的文本，也可以被其他程序所使用。
- `**P**`，类似Autoselect，但使用"+寄存器，而不是"*寄存器。
- **`f`，**Foreground，在Linux系统上，gvim可以执行fork()命令，让编辑器在后台运行。通过设置此选项，可以禁用此行为。如果在一个脚本程序中，需要执行gvim命令使得用户可以编辑文件而且要等待到编辑工作结束，此选项就会显得更为有用。（注意：这个选项需要在初始文件中进行设置）
- **`i`，**Icon，如果设置了这个选项，gvim就会在X Windows系统上运行而且最小化时会显示一个图标。如果没有设置这个选项，只会显示正在编辑的文件名称而不会显示图标。
- **`m`，**Menu，显示菜单栏。
- **`M`，**Nomenu，如果设置了此选项，那么系统菜单的定义文件$VIMRUNTIME/menu.vim就不会被读入。（注意：此选项需要在初始文件中进行设置）
- **`g`，**Gray，将不可用的菜单显示为灰色。如果没有设置此选项，那么不可用的菜单就会从菜单栏或是工具栏中移除。

![img](https://pic2.zhimg.com/80/v2-5f8bbd9bab756c073af5617ce988a2b5_720w.png)

- **`t`，**Tear off，启用Tear off菜单（可以将菜单从界面中分离出来）

![img](https://pic4.zhimg.com/80/v2-12262c6b4dd6dc7a001977c0315b78df_720w.jpg)

- **`T`，**Tool bar，显示工具栏。
- **`r`，**Always Right scrollbar，总是在编辑器右侧放置滚动条。
- **`R`，**Display Right scrollbar，如果窗口垂直分隔，将在编辑器右侧放置滚动条
- **`l`，**Always Left scrollbar，总是在编辑器左侧放置滚动条。
- **`L`，**Display Left scrollbar，如果窗口垂直分隔，将在编辑器左侧放置滚动条
- **`b`，**Bottom scrollbar，在编辑器底部放置滚动条。
- **`v`，**Vertical dialog boxes，对话框中的按钮采用垂直排列。

![img](https://pic3.zhimg.com/80/v2-b56eade867bfd3f6cadd2207104420ea_720w.jpg)

## **GUI选项实例**

使用以下命令，可以隐藏菜单栏、工具栏和滚动条，以获得更大的屏幕空间用于文本编辑；同时，摆脱了对于菜单和工具栏的依赖，也可以死心塌地的使用命令了：

```vim
 :set guioptions-=m
 :set guioptions-=T
 :set guioptions-=r
 :set guioptions-=l
 :set guioptions-=b 
```

![img](https://pic3.zhimg.com/80/v2-3b33f1bcd7686b49d0f1889451fc25ca_720w.jpg)

如果想要重新显示隐藏的窗口部件，可以使用以下命令：

```vim
:set guioptions+=T
```

使用`:help guioptions`命令，可以查看关于GUI选项的更多帮助信息。

发布于 2019-06-23