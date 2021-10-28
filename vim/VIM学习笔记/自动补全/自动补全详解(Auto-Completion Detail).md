# 自动补全详解(Auto-Completion Detail)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

13 人赞同了该文章

在[插入模式](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-42-InsertMode.html)下，利用自动补全（[Insertion-Completion](https://link.zhihu.com/?target=http%3A//vimcdoc.sourceforge.net/doc/insert.html%23ins-completion)）功能，vim能够根据正在输入的字符，查找匹配的关键字并显示在弹出菜单（popup menu）中。通过选择匹配项，可以补全输入的部分关键字甚至整行文本。

Vim可以针对整行文字、关键字、字典、词典、标签、文件名、宏、命令和拼写等等进行补全。[上节](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-01-AutoCompletion-Intro.html)介绍了进入补全模式的操作方法；本节将详细介绍各种补全方式的特点。

## 整行补全（Whole line completion）

使用**Ctrl-X Ctrl-L**快捷键，将在['complet'](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-03-AutoCompletion-Option.html%23complete)选项定义的范围内查找匹配的行。假设在编辑网页文档时输入“<h”，然后调用整行匹配，将会显示所有以“h”开头的HTML标签。

![img](https://pic2.zhimg.com/80/v2-7943db085e2c0d1c07a4a79718ede2b9_720w.jpg)

## 当前文件内关键字补全（Keyword local completion）

使用**Ctrl-X Ctrl-N**或**Ctrl-X Ctrl-P**快捷键，将在当前文件中查找匹配的关键字。

此处的关键字，是指由['iskeyword'](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-09-word.html)选项定义的字符串。默认情况下，iskeyword=@,48-57,_,192-255，认为由数字、字母和下划线组成的字符串为关键词。而句点和短横线，则被是为关键词之间的分隔符。您可以使用`set iskeyword`命令，来改变关键词的定义。

## 字典补全（Dictionary completion）

使用**Ctrl-X Ctrl-K**快捷键，将在'dictionary'选项定义的文件中查找匹配的关键词。

默认情况下'dictionary'选项为空。可以使用`:set dictionary`命令，来指定字典文件。

对于Linux系统，通常会查找/usr/dict/words或/usr/share/dict/words：

```vim
:set dictionary=/usr/dict/words,/usr/share/dict/words
```

对于Windows系统，如果已经安装了[Cygwin](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-804-Toolkit-CLI-Win.html%23Cygwin)，那么可以选择添加[words](https://link.zhihu.com/?target=https%3A//cygwin.com/packages/summary/words.html)软件包；然后根据您的Cygwin安装目录，来指定字典文件：

```vim
set dictionary=D:\cygwin64\usr\share\dict\linux.words
```

![img](https://pic1.zhimg.com/80/v2-5237b20e490a429e796551fd3414db98_720w.jpg)

你也可以包括其它自定义的字典文件：

```vim
:set dictionary+=home/oualline/words
```

假设我们需要输入单词“acknowledged”，只需要首先输入“ack”三个字母，然后点击Ctrl-X Ctrl-K快捷键即可进行匹配：

![img](https://pic3.zhimg.com/80/v2-ecef1b3b2235e9896e982de77b31c01e_720w.jpg)

## 词典补全（Thesaurus completion）

使用**Ctrl-X Ctrl-T**快捷键，将在'thesaurus'选项定义的文件中查找匹配的关键词。

默认情况下'thesaurus'选项为空。可以使用`:set thesaurus`命令，指定字典文件。

首先[下载](https://link.zhihu.com/?target=https%3A//github.com/vim/vim/issues/629%23issuecomment-443293282)词典文件；然后解压缩后将其中的thesaurus.txt文件复制为~/.vim/thesaurus/english.txt；最后使用以下命令，来指定词典文件：

```vim
:set thesaurus=$HOME\vimfiles\thesaurus\english.txt
```

假设我们输入单词“enjoy”，然后点击Ctrl-X Ctrl-T快捷键，将会在词典文件中查找光标下的单词：

![img](https://pic1.zhimg.com/80/v2-9d03c5297545c24fe34367842f243f40_720w.jpg)

因为在词典文件中，每行会包含多个单词，所以将显示匹配行中的所有单词：

```text
bask enjoy relish savor savour lie
```

## 当前文件及其包含的文件关键字补全（Path pattern completion）

使用**Ctrl-X Ctrl-I**快捷键，将在当前文件以及由'include'选项指定的包含进来的文件中查找匹配的关键词。

很多编程语言都会提供从外部文件中调用代码的功能。比如，C语言的#include语法和Python的import语法等。Vim将根据文件类型所对应的'include'选项，来查找指定包含的文件。您可以使用`:set include?`命令，查看当前的'include'选项设置。

## 标签补全（Tag completion）

使用**Ctrl-X Ctrl-]**快捷键，将在当前文件以及由'include'选项指定的包含进来的文件中查找匹配的标签。

## 文件名补全（File name completion）

使用**Ctrl-X Ctrl-F**快捷键，可以匹配并补全文件名。

如果当前光标下的文本不包含任何路径信息，那么将显示当前目录下的文件列表。

如果当前光标下的文本包含任何（绝对或相对）路径信息，那么将显示其指定目录下的文件列表。

如果当前光标下的文本包含唯一的路径信息（比如“~”），那么将自动转换为目录的完整名称。

![img](https://pic1.zhimg.com/80/v2-d97fb1ae199dfd0a087edd1dfffa0e8c_720w.jpg)

## 定义补全（Definition completion）

使用**Ctrl-X Ctrl-D**快捷键，将在当前文件以及由'include'选项指定的包含进来的文件中，查找由'define'选项定义的宏（definition/macro）。

'define'选项定义的正则表达式默认为“^\s*#\s*define”，将查找以“define”语法定义的宏。您可以使用`:set define?`命令，查看当前的'define'选项设置。

## Vim命令补全（Command-line completion）

使用**Ctrl-X Ctrl-V**快捷键，将匹配Vim命令，以便在您开发Vim脚本时加速代码录入。

## 用户自定义补全（User defined completion）

使用**Ctrl-X Ctrl-U**快捷键，将由'completefunc'选项指定的自定义函数来进行匹配。

## 拼写建议补全（Spelling completion）

使用**Ctrl-X Ctrl-S**快捷键，将根据[拼写检查](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-24-SpellCheck.html)给出补全建议。

请注意，为了使用拼写补全，请确保已使用以下命令，打开了拼写检查特性：

```vim
:set spell
```

## 全能补全（Omni completion）

使用**Ctrl-X Ctrl-O**快捷键，将由'omnifunc'选项指定的自定义函数来进行匹配。Vim将通过$VIMRUNTIME/autoload/{filetype}complete.vim文件来实现全能补全特性，现在支持8种语言，包括C, (X)HTML with CSS, JavaScript, PHP, Python, Ruby, SQL和XML。

例如首先输入HTML标签的前几个字母“<p cl”，然后按下Ctrl+X和Ctrl+O键，将根据语法显示匹配菜单：

![img](https://pic1.zhimg.com/80/v2-b994c0577420b75c9674e1a2a40b6fa0_720w.jpg)

建议将以下命令，加入vimrc配置文件的:filetype命令之后，以更好地利用全能补全功能：

```vim
if has("autocmd") && exists("+omnifunc") 
autocmd Filetype * 
\ if &omnifunc == "" | 
\ setlocal omnifunc=syntaxcomplete#Complete | 
\ endif 
endif
```

您可以使用`:set omnifunc?`命令，查看当前的'omnifunc'选项设置。

![img](https://pic1.zhimg.com/80/v2-c4091188211694144634a8f11e3799b8_720w.jpg)



编辑于 2020-02-11