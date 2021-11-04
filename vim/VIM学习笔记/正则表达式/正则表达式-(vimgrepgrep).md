# 正则表达式-(vimgrep/grep)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

9 人赞同了该文章

在UNIX问世的前一年，1969年，Ken Thompson将正则表达式整合入QED文本编辑器。在Linux文本编辑器ed中，如果你希望显示包含字母“re”的行时，需要使用命令`g/re/p`，而grep也因此得名。可以看作此操作的缩写：g (globally), / (search), re (regular expression), / (delimit search), p (print)。

Vim提供以下两种grep（globally search a regular expression and print）搜索工具：

- `:vimgrep` 使用Vim内置的grep实现；
- `:grep` 调用外部的grep工具。

:grep命令会运行由选项grepprg所指定的程序。在Linux系统上，grepprg默认是[grep](https://link.zhihu.com/?target=http%3A//www.gnu.org/software/grep/manual/grep.html) -n：

![img](https://pic2.zhimg.com/80/v2-919a8ed02165610552c1c9df1e750a0d_720w.png)

在Windows系统上，grepprg默认是[findstr](https://link.zhihu.com/?target=https%3A//docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr) /n

![img](https://pic3.zhimg.com/80/v2-508316a980eef541a2bbb1944f8317e2_720w.png)

:vimgrep命令使用vim内置的搜索引擎，与`/`命令功能一致，但速度相对较慢。

由此可见，使用:vimgrep命令在不同平台上将获得一致的体验。而:grep命令则是与操作系统相关的，在不同平台会有不同的行为。

`:grep`和`:vimgrep`命令，都将在[QuickFix](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html)中显示搜索结果。

`:lgrep`和`:lvimgrep`命令实现相同的功能，但使用地址列表（Location List）来显示匹配结果。

使用`:copen`命令打开的Quickfix，是全局性的。而使用`:lopen`打开的Location List，则是独立存在于各个窗口中的。

对于Quickfix，使用`:cp`命令，跳转到上一个匹配处；使用`:cn`命令，跳转到下一个匹配处。

对于Location List，使用`:lpre`命令，跳转到上一个匹配处；使用`:lnext`命令，跳转到下一个匹配处。

## :vimgrep

使用以下命令，可以在当前目录下查找指定字符串：

```vim
:vimgrep grep *
```

如果希望在当前目录及其子目录中进行查找，那么可以使用**通配符：

```vim
:vimgrep blue **
```

以下命令将在当前目录及其子目录中的所有HTML文件中，查找指定字符串：

```vim
:vim blue **/*.html
```

请注意，:vimgrep命令可以缩写为`:vim`。

首先在常规模式下，使用`*`命令查找光标下的单词；然后使用以下命令，可以重用之前的查找：

```vim
:vim // *.html
```

默认情况下，将自动跳转至第一个匹配处；如果希望停留在当前位置，那么可以在命令中使用j参选：

```vim
:vimgrep /foo/j **/*.md
```

使用以下命令，可以查看更多帮助信息：

```vim
:help :vimgrep
```

## :grep

使用以下命令，将在当前目录下查找所有文件：

```vim
:grep block *.*
```

默认情况下，grep是区分大小写的，可以使用-i选项来忽略大小写：

```vim
:grep -i word filename
```

使用-o选项，将只显示匹配的字符，而不是整行内容：

```vim
:grep -o [[:punct:]] filename
```

使用以下命令，可以查看更多帮助信息：

```vim
:help :grep
```

请注意，递归搜索子目录的 **/*.* 通配符，对于Linux下的:vimgrep和:grep命令有效；但对于Windows下的:grep命令不起作用。

## 'grepprg'选项

使用以下命令，可以查看'grepprg'选项的当前设置：

```vim
:set grepprg?
```

在不同的操作系统下，Vim将默认使用不同的外部grep工具：

- 在Windows下
  `grepprg=findstr /n`
- 在Linux下
  `grepprg=grep -n $* /dev/null`

如果希望默认查询当前目录以及其子目录，那么可以使用以下设置：

- 在Windows下
  `set grepprg=findstr /S /n`
- 在Linux下
  `set grepprg=grep -nR $* /dev/null`

请注意，您可以使用`:pwd`命令来查看当前目录。

如果您在Windows中已经安装了[Git](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-803-Toolkit-Git.html)或[Cygwin](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-804-Toolkit-CLI-Win.html%23Cygwin)，那么只需要在环境变量PATH中增加相应目录，即可调用其自带的grep命令：

- C:\Program Files\Git\usr\bin
- D:\cygwin64\bin

在Windows命令行中，可以使用以下命令进行验证：

```vim
$ grep --version
```

![img](https://pic3.zhimg.com/80/v2-10d7d45f90532b64bc6992a0d82204a6_720w.jpg)

然后在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中，使用以下设置：

```vim
set grepprg=grep\ -rnIH\ --exclude-dir=.git
```

通过以上设置，可以在Windows环境中使用Linux风格的grep程序。

## 帮助信息

使用以下命令，可以查看更多帮助信息：

```vim
:help 'grepprg'
:help pattern
```

关于正则表达式的更多信息，可以参考以下网站：

- [Vim Regular Expressions 101](https://link.zhihu.com/?target=http%3A//vimregex.com/)
- [Regular-Expressions.info](https://link.zhihu.com/?target=https%3A//www.regular-expressions.info/)

使用以下网站，可以视觉化正则表达式，以便分步理解复杂的表达式：

- [REGEXPER](https://link.zhihu.com/?target=https%3A//regexper.com/)

![img](https://pic3.zhimg.com/80/v2-bc44d6e2938ede9ccedc312f6e73e6ae_720w.jpg)

- [Regular Expressions 101](https://link.zhihu.com/?target=https%3A//regex101.com/)

![img](https://pic1.zhimg.com/80/v2-dc34b0f72108f91763e33b4443e1bcb8_720w.jpg)

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-81-RegularExpressionBasic.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-82-RegularExpressionAdv.html)>

发布于 2020-06-14