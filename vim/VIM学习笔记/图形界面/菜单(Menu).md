# 菜单(Menu)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

## **启用/禁用菜单**

使用以下命令，可以显示菜单栏：

```vim
:set guioptions+=m
```

使用以下命令，可以隐藏菜单栏：

```vim
:set guioptions-=m
```

## **查看菜单映射**

本质上，菜单项都是由命令定义的行为。使用以下命令，可以列出所有菜单定义的映射：

```vim
:menu
```

如果只需要显示特定的菜单（注意区分大小写），那么可以使用以下命令：

```vim
:menu File 
```



![img](https://pic1.zhimg.com/80/v2-ad1366ccd65701cbbdd660850693b274_720w.jpg)



命令执行结果的每一行首个字母指明了这个命令的模式。

而以下命令，则可以列出指定菜单项的内容：

```vim
:menu File.Save
```

## **定义新菜单**

Vim编辑器所使用的菜单是由文件`$VIMRUNTIME/menu.vim`定义的。

可以使用以下:menu命令，定义新的菜单内容：

```vim
:menu [priority] menu-item command-string
```

**menu-item**，描述了放置菜单项的路径，比如*File.Save*表明Save菜单在File菜单下；还可以依次创建子菜单，例如*Tabs.Navigation.Next*。菜单定义命令示例如下：

```vim
:menu 10.340 &File.&Save:w :confirm w
```

**priority**，为数字优先级，用于确定放置菜单项的位置。第一个数字*10*表明在菜单栏上的位置。数字越小越靠近左侧，而数字越大则越靠近右侧；第二个数字*340*则决定了下拉菜单的位置。数字越小越靠近上部，而数字越大则越靠近下部。如果你在新建菜单命令中没有指定优先级数字，那么默认值为*500*。你可以使用`:help menu-priority`帮助命令，查看Vim内置菜单的位置排列。

**&**，用于指定快捷键，例如*&File.&Save*可以表明用**Alt-F**键来选择File菜单，而用**S**键来选择保存菜单。

使用以下命令，将新建*Tabs.Next*菜单：

```vim
:menu <silent>Tabs.Next <Esc>:tabnext<cr>
```

****，用于进入常规模式；<cr>用于执行命令。

****，将屏蔽命令行的输出。

**-SEP-**，可以在下拉菜单中新建用于间隔菜单项的虚线。必须是以*-*开头和结尾的唯一名称；同时必须包含命令，例如以下定义中使用的**:**空命令。

```vim
:menu Tabs.-SEP- :
```

我们还可以使用以下指定模式的菜单定义命令：

- `:menu` 常规模式, 可视化模式, 操作待决模式
- `:nmenu` 常规模式(Normal mode)
- `:vmenu` 可视化模式(Visual mode)
- `:omenu` 操作待决模式(Operator-pending mode)
- `:imenu` 插入模式(Insert mode)
- `:cmenu` 命令行模式(Command-line mode)
- `:amenu` 所有模式

## **菜单实例**

如果希望始终显示自己新建的菜单，那么可以在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2012/01/vim-vimrc.html)文件中增加以下代码。请注意：代码不需要包括冒号（:）。

```vim
15amenu <silent>Tabs.New :tabnew<cr>amenu Tabs.-SEPT1- :
amenu <silent>Tabs.&Next :tabnext<cr>
amenu <silent>Tabs.&Previous :tabprevious<cr>
amenu Tabs.-SEPT2- :
amenu Tabs.&Close :confirm tabclose<cr>
```

新建的菜单显示如下：



![img](https://pic3.zhimg.com/80/v2-9799b7c0b1c652022a611362c9adf98a_720w.jpg)



## **移除菜单**

使用以下命令，可以从菜单中移除指定菜单项：

```vim
:[mode]unmenu menu-item
```

使用以下命令，则会移除所有菜单：

```vim
:aunmenu * 
```



编辑于 2018-06-26