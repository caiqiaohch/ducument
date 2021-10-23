# 折行(Wrap)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

7 人赞同了该文章

## **折行显示**

在默认情况下，Vim会自动折行––将超出屏幕范围的文本打断并显示在下一行。我们也可以通过以下命令，取消自动折行––超出屏幕范围的文本将不会被显示，你需要向句末移动光标，以使屏幕水平滚动，查看一行的完整内容。

```vim
:set nowrap
```

默认设置**set sidescroll=0**之下，当光标到达屏幕边缘时，将自动扩展显示1/2屏幕的文本。



![img](https://pic4.zhimg.com/v2-eb880dcd963b21097e5f775a996724af_b.jpg)



通过使用**set sidescroll=1**设置，可以实现更加平滑的逐个字符扩展显示。



![img](https://pic3.zhimg.com/v2-cce0445382bcadfb146a985d436a09ce_b.jpg)



可以使用以下命令，恢复Vim的自动折行：

```vim
:set wrap
```

## **折行形式**

我们可以告诉Vim在合适的地方折行：

```vim
:set linebreak
```

所谓合适的地方，是由*breakat*选项中的字符来确定的。在默认的情况下，这些字符是“^I!@*-+_;:,./?”。如果我们不希望在下划线处打断句子，只要用下面的命令将“_”从这个列表移除就可以了：

```vim
:set breakat-=_
```

如果一行被打断，Vim可能不会在句子连接处显示任何内容。我们可以通过设置*showbreak*选项，来显示所希望的指示信息：

```text
:set showbreak=->
```

我们可以使用以下命令，取消自定义折行：

```vim
:set nolinebreak
```

## **在折行内移动**

如果设置了wrap选项，那么很长的行将被折回并连续显示在屏幕上。但使用j命令，将移动屏幕上显示为多行的一行；而如果希望在折行内向下移动，则需要使用gj或g<Down>命令。同理，gk或g<Up>命令，用于向上移动。

![img](https://pic2.zhimg.com/80/v2-e8af64f3b0682283d6363c33bd85aad5_720w.png)

在[vimrc配置文件](https://link.zhihu.com/?target=https%3A//bit.ly/vim-vimrc)中，定义以下[键盘映射](https://link.zhihu.com/?target=https%3A//bit.ly/vim-map)，可以使j和k命令自动判断是在折行内或是在折行间进行移动：

```vim
noremap j (v:count == 0 ? 'gj' : 'j')
noremap k (v:count == 0 ? 'gk' : 'k')
```

根据以下屏幕录像，当点击向下移动键时，光标会直接忽略折行，而跳转到下一行；而点击j键时，则可以在折行内移动。

![img](https://pic4.zhimg.com/v2-ebf9199f19be1dd9db2be8826f57d247_b.jpg)



编辑于 2019-02-12