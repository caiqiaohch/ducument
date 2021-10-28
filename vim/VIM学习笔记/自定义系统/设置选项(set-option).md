# 设置选项(set-option)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

Vim是一个高度可定制的编辑器，我们可以使用 :set 命令来设置大量的选项，其大致可分为三种：布尔值选项、数值选项和字符串选项。

## **查看选项**

使用以下命令，可以列示所有选项：

```vim
:set all
```

![img](https://pic1.zhimg.com/80/v2-69ef717c0e75d50bc78ac3883ff47530_720w.jpg)

如果希望查看某个选项的当前值，那么可以使用 :set option? 命令，其返回值将显示在屏幕底部。例如：

```vim
:set list?
```

## **设置选项**

使用以下命令，可以设置布尔值选项：

![img](https://pic1.zhimg.com/80/v2-dc8bcf92d56add33a5457e116cf0a778_720w.jpg)

如果顺序执行这些命令，那么选项变化如下图所示：

![img](https://pic3.zhimg.com/80/v2-2a6254a40592ce5770eb6ff7060feb9a_720w.jpg)

使用以下命令，可以设置数值选项：

![img](https://pic2.zhimg.com/80/v2-e2f881223f4d95eb2867e659a2262a75_720w.jpg)

如果顺序执行这些命令，那么选项变化如下图所示：

![img](https://pic4.zhimg.com/80/v2-047d271e569936b73d58ff16b90894bb_720w.jpg)

使用以下命令，可以设置字符串选项：

![img](https://pic3.zhimg.com/80/v2-b0eb2b661ad4ea18d662e8cac68a282a_720w.jpg)

如果顺序执行这些命令，那么选项变化如下图所示：

![img](https://pic1.zhimg.com/80/v2-475b24bc7ce148010907b99d220229d8_720w.jpg)

我们可以在一行:set命令中，设置多个选项。例如以下命令，将设置三个不同的选项：

```vim
:set list shiftwidth=4 incsearch
```

使用以下命令，可以将所有的选项都重置为默认值：

```vim
:set all&
```

使用以下命令，将列示出所有与其默认值不同的选项：

```vim
:set
```

![img](https://pic2.zhimg.com/80/v2-41e56ddafa0c815c04c843c40f624315_720w.jpg)

使用`:help set-option`命令，可以查看设置选项的更多帮助信息。

编辑于 2019-06-04