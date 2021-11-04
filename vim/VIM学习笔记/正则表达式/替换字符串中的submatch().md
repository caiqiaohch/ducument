# 替换字符串中的submatch()

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

`submatch({nr})`函数，只用于 :substitute 命令或 substitute() 函数中。它将返回匹配文本的第{nr}个子匹配。如果{nr}为0，则返回整个匹配文本。

将submatch()和其它函数相结合，可以对替换文本进行更丰富的操作。使用`:help submatch()`命令，可以查看更多帮助信息。

## 更新列表序号

如果希望在第1条之后插入一个新的条目，那么就意味着需要调整后续各个条目的序号：

```text
Article 1: 3 Steps To Enable Thesaurus Option
Article 2: Steps to Add Custom Header
Article 3: Automatic Word Completion
Article 4: How To Record and Play Macro
Article 5: Make Vim as Your C IDE
```

使用以下命令，将第2行及之后各行中的序号分别加1：

```vim
:2,$s/\d\+/\=submatch(0) + 1/ 
```



```text
Article 1: 3 Steps To Enable Thesaurus Option
Article 3: Steps to Add Custom Header
Article 4: Automatic Word Completion
Article 5: How To Record and Play Macro
Article 6: Make Vim as Your C ID
```

请注意，替换命令中并没有使用/g标志，因此将仅仅替换第一个匹配字符，以避免条目文本中的数字也被更改。

## 转换单词大小写

假设需要在以下条目中，将首个单词的首个字母转换为大写：

```text
The following activities can be done using vim:
a. source code walk through,
b. record and play command executions,
c. making the vim editor as ide
```

使用以下命令，将匹配“.”及空格之后的单词字符（0-9A-Za-z），并替换为大写：

```vim
:%s/\.\s*\w/\=toupper(submatch(0))/g
The following activities can be done using vim:
a. Source code walk through,
b. Record and play command executions,
c. Making the vim editor as ide
```

## 替换文件路径

将当前光标下的相对路径名，替换为完整的绝对路径名：

```vim
:s/\f*\%#\f*/\=fnamemodify(submatch(0), ':p')/
```

其中，\= 表示使用表达式作为替换字符串（请参考帮助信息`:help sub-replace-expression`）；\f*\%#\f* 将匹配文件名（请参考帮助信息`:help /\f`） 。

如果希望将可视化模式下选中的文件名，替换为完整的绝对路径名，那么在命令中使用\%V参数：

```vim
:s/\%V.*\%V/\=fnamemodify(submatch(0), ':p')/
```

## 数据补零

将每行数据中不满8位的字符串，向右对齐并在前部以0补足8位：

```vim
:%s/.*/\=printf('%08s',submatch(0))/g
```

![img](https://pic3.zhimg.com/80/v2-0fd3d9d605d6042dfac214640c5d97ea_720w.jpg)



Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-05-Substitute.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Regex-Metacharacters.html.html)>

发布于 2020-05-03