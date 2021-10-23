# 增减数值(CTRL-A/CTRL-X)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

12 人赞同了该文章

## 常规模式下的CTRL-A/CTRL-X

Vim可以对文本进行简单的算术运算。在常规模式下，使用CTRL-A快捷键，可以将当前光标下的数字加1；使用CTRL-X快捷键，可以将当前光标下的数字减1。

通过在命令之前指定次数，可以增加或减少指定的数字。例如当前光标下数字为1，依次输入5Ctrl-A，数字将变为6（=1+5）。

如果在当前光标下未发现数值，那么将继续在本行内向后查找并执行增减操作。

使用以下命令，可以查看相关帮助信息：

```vim
:help CTRL-A
```

## 其它模式下的CTRL-A/CTRL-X

自Vim8以后，在可视化模式和选择模式下，也可以使用CTRL-A和CTRL-X来增减数值（`:help new-items-8`）。

例如希望在第1条之后插入一个新的条目，那么就意味着需要调整后续各个条目的序号：

```text
Article 1: 3 Steps To Enable Thesaurus Option
Article 2: Steps to Add Custom Header
Article 3: Automatic Word Completion
Article 4: How To Record and Play Macro
Article 5: Make Vim as Your C IDE
```

进入[可视化模式](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-45-VisualMode.html)，或者直接选择2-5行，然后点击CTRL-A即可对选中各行中的序号分别加1：

```text
Article 1: 3 Steps To Enable Thesaurus Option
Article 3: Steps to Add Custom Header
Article 4: Automatic Word Completion
Article 5: How To Record and Play Macro
Article 6: Make Vim as Your C ID
```

在命令行中执行CTRL-A，也可以将第2行及之后各行中的序号分别加1：

```vim
:2,$g/\d\+/exe "normal! \<C-a>"
```

另外，您也可以使用[替换字符串中的submatch()](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-substitute-submatch.html)功能，实现相同的效果。

使用以下命令，可以查看相关帮助信息：

```vim
:help v_CTRL-A
```

## 'nrformats'选项

'nrformats'选项，用于控制CTRL-A和CTRL-X所识别的数字格式。

使用以下默认设置，Vim可以正确识别二进制和十六进制数；而十进制数，在所有设置下都可以被正确识别：

```vim
:set nrformats=bin,hex
```

使用以下命令清空选项，将所有数字识别为十进制：

```vim
:set nrformats=
```

如果希望只识别八进制数，那么可以使用以下命令：

```vim
:set nrformats=octal
```

如果在选项中增加"alpha"，那么也可以选择上一个和下一个字母：

```vim
:set nrformats+=al
```

以下表格，列示了针对“原始值”，分别点击CTRL-A和CTRL-X所产生的效果：

![img](https://pic3.zhimg.com/80/v2-405373aa6bcba1b07a5ff93e8c17d612_720w.jpg)

使用以下命令，可以查看相关帮助信息：

```vim
:help 'nrformats'
```

## 自定义CTRL-A/CTRL-X键盘映射

在Windows下的Vim中，使用以下命令可以看到vimrc自动加载了mswin.vim文件，CTRL-A已经被映射为选择全部，而CTRL-X则被映射为剪切：

```vim
:verbose map <C-a>
```

![img](https://pic1.zhimg.com/80/v2-c0a4744b7402a4e6e33e19b2e2716f40_720w.jpg)



使用以下命令，可以取消针对CTRL-A的键盘映射，以恢复其增加数值的功能：

```vim
:unmap <C-a>
```

如果希望保留当前Windows习惯的键盘映射，那么可以新增以下基于[前缀键](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-54-Leader.html)（leader）的定义：

```vim
:vnoremap <leader>a <C-a>
:vnoremap <leader>x <C-x> 
```



发布于 2020-06-07