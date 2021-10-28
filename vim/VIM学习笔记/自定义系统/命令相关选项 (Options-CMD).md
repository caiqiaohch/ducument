# 命令相关选项 (Options-CMD)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

## 路径分隔符选项

在Windows下，文件路径中使用反斜杠（Backslash）：

```vim
C:\Temp
```

在Linux和Mac下，文件路径中使用正斜杠（Forward slash）：

```vim
/etc/hosts
```

'shellslash'选项，仅适用于Windows操作系统，并且默认是关闭的。为了保证与Unix风格的兼容性，建议在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中，使用以下命令启用此选项：

```vim
:set shellslash
```

使用'shellslash'选项，可以在扩展文件名时使用正斜杠。即使你在输入文件名时使用反斜杠，Vim也会自动将其转换为正斜杠。

## 报错响铃选项

当Vim捕获一个错误时，将会显示错误信息。如果希望同时发出报错响铃 (鸣叫或屏幕闪烁)，那么可以启用'errorbells'选项：

```vim
:set errorbells
```

使用以下命令，则可以关闭'errorbells'选项：

```vim
:set noerrorbells
```

'visualbell'选项，用于设置响铃的行为：鸣叫、屏幕闪烁或什么都不做。默认情况下，'visualbell'选项是关闭的。通过以下命令启用visualbell选项，将使用可视响铃代替鸣叫。当输入错误时，屏幕就会闪动然后回到正常状态：

```vim
:set visualbell
```

通过以下命令，则可以关闭visualbell选项（而使用鸣叫）：

```vim
:set novisualbell
```

如果既不想要鸣叫也不想要屏幕闪烁，那么可以使用以下设置：

```vim
:set vb t_vb=
```

## 信息显示选项

启用'showmode'选项，将在屏幕底部显示当前所处的模式：

```vim
:set showmode
```

启用'showcmd'选项，将会在输入命令时，在屏幕底部显示出部分命令：

```vim
:set showcmd
```

例如希望输入fx命令来查找字符“x”时，当我们输入f时就会在底部显示“f”，这在输入复杂命令时将很有帮助。

在[可视化模式](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-45-VisualMode.html)下，将显示选择区域的大小：

- 在行内选择若干字符时，显示字符数；
- 选择多于一行时，显示行数；
- 选择可视化列块时，显示行乘以列数（比如“2x10”）。

![img](https://pic1.zhimg.com/80/v2-0715f2cbf740538d786f29dea46bd350_720w.jpg)

默认情况下，如果屏幕底部显示的消息长度超出一行时，将会显示类似于“按回车继续”的提示信息。通过设置'cmdheight'选项来增加消息的行数，可以显示更多的信息以避免不必要的提示。例如使用以下命令，设置命令行高度为3行：

```vim
:set cmdheight=3
```

默认情况下，'more'选项是启用的。当命令的输出超出一屏时（例如:version命令的输出），就会显示“-- More --”提示信息，并等待用户响应以继续显示屏更多信息：

![img](https://pic2.zhimg.com/80/v2-0386a17d53ce468b10ba0b597f00d799_720w.jpg)

使用以下命令关闭more选项，将会持续翻滚屏幕以显示信息，而不会暂停并显示提示信息：

```vim
:set nomore
```

当删除或修改多行文本时，如果被影响的行数超出了'report'选项所指定的行数（默认值为2行），那么Vim将会在屏幕底部显示所改变的行数。如果希望始终显示反馈信息，那么可以将report选项设置为0：

```vim
:set report=0
```

此时即使只是删除了一行文本，Vim也将显示反馈信息：

```text
1 line less
```

相反地，如果不希望显示变更信息，那么可以将report选项设置为较大的值。

## 选项小结

- [shellslash](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-03-CMD-Options.html) (ssl) (Default: off)
  使用正斜杠（Forward slash）作为路径分隔符；
- [errorbells](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-03-CMD-Options.html%23opt-errorbells) (eb) (Default: off)
  是否发出报错响铃；
- [visualbell](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-03-CMD-Options.html%23opt-visualbell) (vb) (Default: off)
  设置响铃的行为：鸣叫、屏幕闪烁或什么都不做；
- [showmode](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-03-CMD-Options.html%23opt-showmode) (smd) (Default: on)
  是否显示当前所处的模式；
- [showcmd](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-03-CMD-Options.html%23opt-showcmd) (sc) (Default: on, off for Unix)
  是否显示命令信息；
- [cmdheight](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-03-CMD-Options.html%23opt-cmdheight) (ch) (Default: 1)
  设置命令行高度；
- [more](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-03-CMD-Options.html%23opt-more) (Default: on)
  是否显示“-- More --”提示信息；
- [report](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-03-CMD-Options.html%23opt-report) (Default: 2)
  设置报告改变行数的阈值；

编辑于 2019-10-21