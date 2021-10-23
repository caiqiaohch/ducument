# 全局命令(Global Command)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

10 人赞同了该文章

`:global`全局命令，通常简写为`:g`，可以针对匹配模式的行执行编辑命令；通过与正则表达式、寄存器和标记等功能相配合，可以高效地实现复杂的操作。

使用`:g`命令，可以针对所有匹配模式的行执行操作。其命令格式为：

```vim
:[range]g/{pattern}/[command]
```

即针对在[range]范围内，所有匹配{pattern}模式的行，执行[command]命令。

命令`:g!`及其同义词`:v`，则可以针对所有不匹配模式的行执行操作。其命令格式为：

```vim
:[range]g!/{pattern}/[command]
```

即针对在[range]范围内，所有不匹配{pattern}条件的行，执行[command]命令。

如果没有指定[range]，则针对文件中的所有行执行命令。也可以使用行地址，把全局搜索限定在指定的行或行范围内。

如果没有指定[command]，则执行`:print`命令来显示行内容。

使用以下命令，可以查看全局命令的帮助信息：

```vim
:h :g 
```

## 全局查找

查找并显示文件中所有包含模式pattern的行，并移动到最后一个匹配处：

```vim
:g/pattern
```

查找并显示文件中所有包含模式pattern的行：

```vim
:g/pattern/p
```

查找并显示文件中所有精确匹配单词pattern的行：

```vim
:g/\<pattern\>/p
```

查找并显示第20到40行之间所有包含模式pattern的行：

```vim
:20,40g/pattern/p
```

查找并显示文件中所有不包行模式pattern的行，并显示这些行号：

```vim
:g!/pattern/nu
```

## 全局删除

删除包含模式patternn的行：

```vim
:g/pattern/d
```

删除不包含模式pattern的行：

```vim
:g!/pattern/d
```

删除所有空行：

```vim
:g/^$/d
```

删除所有空行以及仅包含空格和Tab制表符的行：

```vim
:g/^[ tab]*$/d
```

删除指定范围内的文本，例如以下文本中的“DESCRIPTION”部分：

```vim
:g/DESCRIPTION/,/PARAMETERS/-1d
```

![img](https://pic3.zhimg.com/80/v2-2a30ca1d939ded1d5d703978e2c59dba_720w.jpg)

## 全局替换

利用全局命令，可以仅针对符合查询条件的行，进行替换操作。例如使用以下命令，将包含“microsoft antitrust”的行中的“judgment”替换为“ripoff”：

```vim
:g/microsoft antitrust/s/judgment/ripoff/
```

可以在命令中指定查找的范围。比如以下命令，将在包含“microsoft antitrust”的前两行及后两行中进行替换：

```vim
:g/microsoft antitrust/-2,/microsoft antitrust/+2s/judgment/ripoff/c
```

![img](https://pic3.zhimg.com/80/v2-34bde9b0183e00885fb38f5f9992a62a_720w.jpg)

以上命令末尾的c参数，用于提示用户对每一个替换操作进行确认。

假设希望在以“end”结尾的行中，将第1部分文字替换为“The greatest of times;”：

```
the best of times; the worst of times: end
```

由于会尽可能多（as much text as possible）的匹配，以下命令将替换至第2个“of”处：

```vim
:g/end$/s/.*of/The greatest of/
The greatest of times: end
```

为了只替换第1部分，则需要更精确的匹配条件：

```vim
:g/end$/s/.*of times;/The greatest of times;/
The greatest of times; the worst of times: end
```

## 全局移动

将所有的行按相反的顺序排列。其中，查找模式.*将匹配所有行，m0命令将每一行移动到0行之后：

```vim
:g/.*/m0
```

将指定[标记](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-53-Mark.html)（Mark）之间的行按相反的顺序排列：

```vim
:'a,'bg/^/m'b
```

![img](https://pic1.zhimg.com/80/v2-ae0bad1a5f24ad90729579bdbe2e3058_720w.jpg)

将以下文本中的“DESCRIPTION”部分，上移到“SYNTAX”之前：

```vim
:g /SYNTAX/.,/DESCRIPTION/-1 move /PARAMETERS/-1
```

首先匹配从包含“SYNTAX”的行到包含“DESCRIPTION”的上一行；然后将这些行移动到包含“PARAMETERS”的上一行。

![img](https://pic4.zhimg.com/80/v2-d8d9d679a715e7e089743a3015ef2a4b_720w.jpg)



以下两条命令均可以将所有不是以数字开头的行，移动到文件末尾：

```vim
:g!/^[[:digit:]]/m$
:g/^[^[:digit:]]/m$
```

## 全局复制

使用以下命令，可以重复每一行。其中`:t`或`:copy`为复制命令：

```vim
:g/^/t.
```

将包含模式pattern的行，复制到文件末尾：

```vim
:g/pattern/t$
```

重复每一行，并以“print ''”包围：

```vim
:g/./yank|put|-1s/'/"/g|s/.*/Print '&'/ 
```



```text
Chapter 1
Print 'Chapter 1'
```



编辑于 2020-10-30