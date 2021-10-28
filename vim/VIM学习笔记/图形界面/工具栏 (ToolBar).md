# 工具栏 (ToolBar)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

## **启用/禁用工具栏**

工具栏（ToolBar）是使用图标来调用菜单的图形界面元素。Vim默认设置是显示工具栏的。我们也可以使用以下命令来显示工具栏：

```vim
:set guioptions+=T
```

使用以下命令，则可以隐藏工具栏：

```vim
:set guioptions-=T
```

## **工具栏选项**

通过设置toolbar可以控制工具栏的显示外观，其选项包括：

- **icons** 显示工具栏图标
- **text** 显示文本
- **tooltips** 当光标悬浮图标上时显示提示文字

例如以下命令，将设置工具栏显示按钮图标和提示文字：

```vim
:set toolbar=icons,tooltips
```

![img](https://pic1.zhimg.com/80/v2-cacfa2fd1e8c684814b212e442fe6e34_720w.jpg)



## **工具栏按钮**

Vim将工具栏视为一种以ToolBar命名的特殊菜单。例如名为*ToolBar.New*的menu-item，就是在工具栏上的*New*图标。每一个基本图标都有两个名字，例如New图标可以用*ToolBar.New*或是*ToolBar.builtin00*来表示。可以使用`:help builtin-tools`命令，查看关于基本图标的帮助信息。



![img](https://pic3.zhimg.com/80/v2-d03cda14a78e07bdc145bdc8e43f43f2_720w.jpg)



## **新增工具栏按钮**

可以使用以下命令，新增工具栏按钮：

```vim
:amenu icon=/Users/yyq/.vim/bitmaps/TabNew 1.410 ToolBar.TabNew :tabnew<CR>
```

- **icon**，*icon=TabNew* 用于指定按钮图标的文件名，如果你只给出了图标的文件名，但没有明确指明文件的路径名，那么Vim将会在`$VIMRUNTIME/bitmaps`目录进行查找；如果你使用bmp格式的图标文件，那么不需要指明bmp后缀名；
- **priority**，*1.410* 表示按钮在工具栏上的位置；
- **action**，*:tabnew* 是点击按钮所执行的命令。

可以使用以下命令，新增工具栏分隔符：

```vim
amenu 1.400 ToolBar.-sep8- <Nop>
```

使用以下命令，可以定义鼠标停留在按钮时显示的提示文字：

```vim
:tmenu ToolBar.TabNew Open a new tab
```

可以使用以下命令，移除工具栏按钮的提示信息：

```vim
:tunmenu ToolBar.TabNew
```

## **移除工具栏按钮**

使用以下命令，将列示工具栏上的按钮名称：

```vim
:aunmenu ToolBar.<Tab>
```



![img](https://pic4.zhimg.com/80/v2-62e4f9983292ca28e938332be1ddb273_720w.jpg)



使用左右方向键，可以选择某个图标项（其中，"|"用于表示分隔符）, 按下**Enter**将从工具栏上移除此按钮，按下**Esc**则可以取消选择。



![img](https://pic2.zhimg.com/80/v2-4d925f2b605b69b8b8573c905c25c5d1_720w.jpg)



直接使用以下命令，将会移除工具栏上的所有按钮：

```vim
:aunmenu ToolBar 
```

![img](https://pic4.zhimg.com/80/v2-435f4a079e928c9b7b794525105e76a7_720w.jpg)



发布于 2018-07-02