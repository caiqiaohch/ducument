# 正则表达式(Regex-VeryMagic)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

9 人赞同了该文章

假设希望在以下CSS代码中，查找所有颜色代码：

```text
body { color: #3c3c3c; }
strong { color: #000; }
```

在默认的Magic模式下，使用以下命令可以匹配以“#”开头的十六进制色彩值：

```vim
/#\([0-9a-fA-F]\{6}\|[0-9a-fA-F]\{3}\)
```

在以上正则表达式中，`[]`用于指定可选字符范围，但不需要转义；`()`用于构建[捕获组(Groups)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim-Regex-Groups.html)，需要使用`\`进行转义；`{}`用于指定重复次数，但只需要对开括号进行转义，与之对应的闭括号可以不用转义。由此可见，在Magic模式下，需要对很多特殊符号进行转义，而且转义的方式也欠缺一致性。在编写较复杂的正则表达式时，显得琐碎且难以阅读。

使用`\v`激活Very Magic模式，则可简化为更加友好的正则表达式：

```vim
/\v#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})
```

![img](https://pic1.zhimg.com/80/v2-1aef1e9ad96e727f58ab665768936578_720w.jpg)

## Very magic

在模式开头使用`\v`激活very magic模式，其后除下划线（_）、大小写字母以及数字之外的所有字符都具有特殊含义。这样可以避免重复输入大量的转义符（\），也使得正则表达式更加清晰易读。

假设在以下文本中，希望搜索单引号包围的内容：

```text
you have mocking some 'bird of the year'.
you have mocking some 'the year's bird'.
```

在默认的magic模式下，使用以下模式来处理单词中的单引号：

```vim
/'\('\w\|[^']\)\+'
```

![img](https://pic1.zhimg.com/80/v2-6355f5a8adf4b6790c332d24d098e268_720w.jpg)

如果使用VeryMagic模式，命令则可以简化为：

```vim
/\v'('\w|[^'])+'
```

假设在以下文本中，希望仅保留英文字母：

```text
12345aaa678
12345bbb678
12345ccc678
```

使用以下替换命令，可以删除其中的数字部分：

```vim
:%s/\d\{5\}\(\D\+\)\d\{3\}/\1/
aaa
bbb
ccc
```

如果使用VeryMagic模式，命令则可以简化为：

```vim
:%s/\v\d{5}(\D+)\d{3}/\1/
```

由此可见，Very magic模式为使用正则表达式提供了极大的便利。但很不幸，我们并无法将Very magic模式设置为默认选项。潜在的替代方案是，定义以下键盘映射，在查找时自动激活very magic模式：

```vim
:noremap / /\v
```

使用以下命令，可以查看更多帮助信息：

```vim
:help /\v
```

## Very no magic

在模式开头使用`\V`指定Very No Magic模式，将使得其后模式中只有反斜杠（\）具有特殊意义，而`()`、`[]`、`|`、`.`、`*`和`?`等等元字符都将被视为普通文本。

如果您需要精确的完整匹配，并且查找字符串中包含特殊字符时，那么可以使用Very nomagic模式。

例如以下命令，将查找字符串“Fun.test(*args)” 。也就是说，其中的“*”和“.”都被视为普通字符，而不需要进行转义：

```vim
/\VFun.test(*args)
```

假设需要在以下文本中查找“a.k.a”：

```text
The N key searches backward
the \v pattern switch (a.k.a. very magic)
```

因为“.”在正则表达式中具有特殊含义，它将会匹配任意字符，所以使用以下命令，将会同时匹配单词“backward”中的部分字符：

```vim
/a.k.a
```

![img](https://pic4.zhimg.com/80/v2-cc7f6d37319da1136a00f47a7da128ab_720w.jpg)

当然，可以使用转义符来消除“.”的特殊含义：

```vim
/a\.k\.a\.
```

而更简单的方法是，在命令中使用`\V`激活very nomagic模式：

```vim
/\Va.k.a.
```

此时，将只会按字面匹配到单词“a.k.a”：

![img](https://pic3.zhimg.com/80/v2-8633d2f88c48bc7930eebb6776222e86_720w.jpg)

使用以下命令，可以查看更多帮助信息：

```vim
:help /\V
```

## 小结

我们可以将 very magic 和 very nomagic 模式，理解为对于正则表达式的两种极端处理方式。需要构建较复杂正则表达式时，推荐使用very magic模式；需要按字面意义查找文本时，则推荐使用very nomagic模式。

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-86-Magic.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Regex-Groups.html)>

编辑于 2020-05-16