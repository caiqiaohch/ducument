# Ctrl-F设置

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

## **Ctrl-F默认设置**

在Linux下的Vim中，Ctrl-F键默认设置为，向前（Forward）滚动屏幕；

而在Windows和Mac下的Vim中，Ctrl-F键默认设置为，打开查找对话框。

此设置是在2017年2月9日发布的8.0.0321版本中开始生效的。通过查看 "C:\Program Files (x86)\Vim\vim81\mswin.vim" 文件，可以发现 Ctrl-F 被设置为打开查找对话框。

![img](https://pic3.zhimg.com/80/v2-8428d5c93ecb21f31c4f918763497a3e_720w.jpg)

## **恢复Ctrl-F设置**

为了保持不同操作系统之间的操作一致性，建议在[配置文件(vimrc)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)中增加以下代码，以重新将Ctrl-F键设置为向前滚动屏幕：

```vim
unmap <C-F>
```

注意，以上设置命令必须放置在以下载入代码之后，以确保设置不会被覆盖：

```vim
source $VIMRUNTIME/mswin.vim 
```



发布于 2019-06-26