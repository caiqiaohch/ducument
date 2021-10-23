[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-GlobalCommand.html)介绍了`:global`全局命令的基本格式和使用场景。本篇将借助命令示例，来演示与寄存器、文件和自定义函数相配合的复杂操作。

## 执行单条命令

将所有未标志为“DONE”的行，都在行尾标注“TODO”：

```vim
:g!/DONE/s/$/ TODO/
:v/DONE/s/$/ TODO/
```

从第5行到第10行，在每一行下插入空行：

```vim
:5,10g/^/pu _
```

通过调用`:sort`命令，可以对指定范围内的文本进行[排序](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-09-03-sort.html)。例如以下命令，将对“{}”包围的CSS属性按字母排序：

```vim
:g/{/ .+1,/}/-1 sort
```

![img](https://pic1.zhimg.com/80/v2-eb9a6075a4c3ce4fff24fab20deda310_720w.jpg)

同理，使用以下命令，可以针对“{}”包围的文本增加[缩进](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-66-Indent.html)：

```vim
:g/{/ .+1,/}/-1 >
```

## 执行多条命令

使用以下命令，可以为“Chapter”开头的标题行增加分隔线：

```vim
:g/^Chapter/t.|s/./-/g
Chapter 1
---------
Chapter 2
---------
```

从以上命令可以看到，通过使用“`|`”可以组合执行多条命令。首先使用`:t`命令，复制行内容；然后执行`:s`命令，将文本替换为横线。

使用以下命令，可以进行多次替换。对于包含“apples”或“cherries”的行，进行两次替换：首先将“apples”替换为“bananas”，然后将“cherries”替换为“oranges”：

```vim
:g /apples\|cherries/ substitute /apples/bananas/g | substitute /cherries/oranges/g
```

![img](https://pic1.zhimg.com/80/v2-b813604dc7fd35c5dfcb8f09f2008e24_720w.jpg)

## 调用函数

首先在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中，新增以下自定义函数：

```vim
" Delete duplicate lines
function! DelDupLine()
  if getline(".") == getline(line(".") - 1)
    norm dd
  endif
endfunction
```

然后使用以下命令，调用函数来删除文件中重复的行：

```vim
:g/^/ call DelDupLine()
```

## 读取和写入文件

将所有不是以2个Tab制表符开头的行，增加到文件“top2levels.otl”的末尾：

```vim
:g!/^\t\t/.w>>top2levels.otl
```

首先移动到文件开头，然后执行以下命令，可以搜集相对于指定字符偏移位置的行：

```vim
:g /^Chapter/ .+2w >> begin
```

包含“Chapter”字符的章节号、名称和描述，分处在连续的行中。模式^Chapter将查找以“Chapter”字符开头的行；.+2将定位到匹配处之后的第2行；然后使用`:w`命令将其追加到名为“begin”的文件中。

![img](https://pic2.zhimg.com/80/v2-9ee5724bdb78391bea355f8da201f75d_720w.jpg)

拆分当前文件，将每一行内容，分别保存为一个文本文件（1.txt,2.txt,3,txt依次类推）：

```vim
:g/^/exe ".w ".line(".").".txt"
```

将字符串“MARK”替换为文件“tmp.txt”的内容：

```vim
:g/^MARK$/r tmp.txt | -d
```

## 读取和写入寄存器

假设需要从以下代码中，提取所有以“TODO”开头的注释文字：

```js
if ( m && m[2] )
    // TODO: something1
    return [ m[1].length + m[2].length ];
else {
    // TODO: something2
    return [ 1, "`" ];
}
```

首先，使用`qaq`命令来清除[寄存器](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-12-Register.html)a的内容，做为存储提取内容的中介位置；

然后，使用以下命令将包含“TODO”的行添加到寄存器a；请注意，使用大写的寄存器编号“A”以表示向寄存器添加内容（而小写字母则表示覆盖内容）；

```vim
:g/TODO/yank A
```

如果希望将文本同时放入指定寄存器和系统剪切板，那么可以使用以下命令：

```vim
:g/TODO/yank A | :let @+=@a
```

请注意，在Mac和Windows下，寄存器*和+都用于访问系统剪切板；在Linux下，寄存器+用于访问系统剪切板。

使用以下命令，可以看到内容已经被放入寄存器和剪切板：

```vim
:registers a+*
```

![img](https://pic4.zhimg.com/80/v2-078300bf717770ca032ca0261b577bcb_720w.jpg)

请注意，vim使用“^J”符号表示换行。

使用`"ap`命令，即可以将寄存器a中存储的TODO信息粘贴出来：

```text
    // TODO: something1
    // TODO: something2
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-GlobalCommand.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-48-ExMode.html)>

发布于 2020-11-05