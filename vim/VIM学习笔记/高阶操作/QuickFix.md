# QuickFix

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

某些Vim命令，将会使用QuickFix列表在不同文件的不同位置间导航。例如：使用:make命令进行编译时，遍历编译错误；使用:vimgrep命令进行搜索时，遍历匹配结果；使用:helpgrep命令查找[帮助信息](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-08-help.html)时，遍历匹配的主题。

执行以下命令，将在当前文件夹中的所有HTML文件中，搜索字符串“options”：

```vim
:vimgrep options *.html
```

在屏幕底部，将显示查找到的第一个匹配结果：

![img](https://pic3.zhimg.com/80/v2-5b56f1cfce330da6fd1855300c95ebfa_720w.png)

## **打开QuickFix窗口**

输入`:copen`或`:cwindow`命令，将在水平分隔窗口中，打开QuickFix列表以显示所有匹配结果：

![img](https://pic3.zhimg.com/80/v2-348036e9f3f76639ba71ad7d99ae38c2_720w.jpg)

你可以使用ctrl+Wj快捷键，移动到QuickFix窗口。关于在多个窗口之间的跳转操作，请参阅[窗口(Window)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-14-MultiWindows.html)章节。

## **在QuickFix列表中导航**

使用以下快捷键，可以在QuickFix列表中进行移动或搜索；当到达想要查看的列表项时，点击Enter键，将会打开匹配文件并精确定位到查找结果所处的位置。

k向上移动↑j向下移动↓Ctrl+b向上翻页pageUpCtrl+f向下翻页PageDown/string向前（Forward）查找字符串string?string向后（Backward）查找字符串string

注意，如果您在Windows和Mac下，无法利用Ctrl+f键进行翻页，那么请重新恢复[Ctrl-F设置](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-11-01-Scroll-CtrlF.html)。

你也可以使用以下命令，直接跳转到匹配文件的查找结果所处位置：

- `:cnext`移动到下一个匹配处
- `:cprevious`移动到上一个匹配处
- `:cfirst`移动到第一个匹配处
- `:clast`移动到最后一个匹配处

![img](https://pic2.zhimg.com/80/v2-584d19762b9f9a1d584841494cdb37e5_720w.jpg)

## **关闭QuickFix窗口**

使用以下命令，可以关闭QuickFix窗口：

```vim
:cclose
```

使用`:help quickfix`命令，可以查看关于QuickFix的更多帮助信息。

编辑于 2019-07-01