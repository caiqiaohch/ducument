# 4种Magic模式

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

11 人赞同了该文章

根据对于特殊元字符的不同解释方式，Vim正则表达式可以分为四种模式：magic，no magic，very magic和very nomagic。

- **[magic](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-86-Magic.html)**模式，使用`\m`前缀，其后模式的解释方式为'magic'选项。`^`，`$`，`.`，`*`和`[]`等字符含有特殊意义；而`+`、`?`、`()`、和`{}`等其它字符则按字面意义解释。magic为默认设置，表达式中的\m前缀可以省略；
- **[no magic](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-86-Magic.html)**模式，使用`\M`前缀，其后模式的解释方式为'nomagic'选项。除了`^`和`$`之外的特殊字符，都将被视为普通文本；
- **[very magic](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Regex-VeryMagic.html%23regex-very-magic)**模式，使用`\v`前缀，其后模式中除 '0'-'9'，'a'-'z'，'A'-'Z' 和 '_' 之外的字符都当作特殊字符解释；
- **[very nomagic](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Regex-VeryMagic.html%23regex-very-no-magic)**模式，使用`\V`前缀，其后模式中只有反斜杠（`\`）具有特殊意义。

不同模式之间的区别，在于哪些特殊字符需要使用反斜杠（`\`）进行转义。例如星号（*），在magic和very magic模式下视为特殊修饰符；而在no magic和very nomagic模式下则被视为普通字符，必须使用“\*”恢复其特殊作用。

对于简单的正则表达式，使用“\”对特殊字符进行转义，可能并不会造成困扰；但在复杂的正则表达式中，对大量特殊字符的重复转义，将使得表达式过于繁琐且难以阅读。

例如在默认的magic模式下，使用以下命令查找十六进制色彩值。其中，使用`()`构建[捕获组](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Regex-Groups.html)；使用`{}`匹配6位和3位十六进制值。因为有多种特殊字符需要进行转义，造成表达式过于冗长：

```vim
/\m#\(\x\{6\}\|\x\{3\}\)
```

而使用very magic模式，则可以简化表达式：

```vim
/\v#(\x{6}|\x{3})
```

4种Magic模式的差异和用法，可以简单总结如下：

![img](https://pic2.zhimg.com/80/v2-6b5c9e9dd2feafceedf0aedeaed3e141_720w.jpg)

以下表格，列示了常用特殊字符在不同模式下的应用。其中，黄色高亮表示为无需转义的特殊字符：

![img](https://pic4.zhimg.com/80/v2-c0a945e07ad16064adb6a33db9a59dc3_720w.jpg)

请注意，”\{\}“也可简写为”\{}“；”\[]“必须仅保留开头的反斜杠；”\(\)“则需要完整的两个反斜杠。（感谢[liouperng](https://www.zhihu.com/people/liouperng)指教）

## magic默认模式

建议始终将['magic'](file:///E:/Anthony_GitHub/learn-vim/options.html#'magic')选项保持在缺省值。

建议在模式之前，通过使用“\v“或“\M“等前缀，来明确激活特定模式。

如果希望始终使用Very magic模式，那么请在vimrc中定义以下键盘映射，将在查找和替换时自动激活very magic模式：

```vim
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %s/\v
nnoremap :g/ :g/\v
```

## 模式转换

你甚至可以在表达式当中改变模式。例如以下命令，开头使用very magic模式，之后转换为magic模式，整体表达式将匹配“foo(bar)”：

```vim
/\vfoo\(\mbar)
```

当然，非常不建议采用此种易引起误解的表达式写法。我们可以将其改写为very nomagic模式：

```vim
/\Vfoo(bar)
```

请使用以下命令，查看更多帮助信息：

```vim
:help /magic
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-86-Magic.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Regex-VeryMagic.html)>

编辑于 2020-05-25