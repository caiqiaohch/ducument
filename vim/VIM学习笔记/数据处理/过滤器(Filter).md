# 过滤器(Filter)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

13 人赞同了该文章

过滤程序是一个接受文本作为标准输入（stdin），然后进行某些处理，并把结果放置到标准输出（stdout）的程序。可以理解为，Vim将当前缓冲区同时作为输入和输出，并借助外部程序进行文字处理。例如使用外部sort命令进行排序，然后用输出结果替换当前文本内容。

## 过滤器命令

使用以下格式的过滤器命令，可以利用外部程序 {filter} 过滤 {motion} 跨越的多行：

```vim
:{range}!{motion}{filter}
```

使用%指代整个文件，可以将所有行的字母转换为大写：

```vim
:%!tr [:lower:] [:upper:]
```

![img](https://pic2.zhimg.com/80/v2-f4b18606318a9280d7ad1c4433a7ce19_720w.jpg)

连续点击!!键，将转到屏幕底部继续输入针对当前行的`:.!`命令。以下命令将本行的字母转换为大写：

```vim
:.!tr [:lower:] [:upper:]
```

![img](https://pic4.zhimg.com/80/v2-6e84e5a89d2bbdc5550c02dd8fe2f2bf_720w.jpg)

使用以下命令，将指定行的字母转换为大写：

```vim
:4,6!tr [:lower:] [:upper:]
```

![img](https://pic1.zhimg.com/80/v2-8c125387f868d41ebba27bc1d63c1e70_720w.jpg)

通过在命令之前增加数字前缀，也可以实现相同的功能。首先将光标移动到第4行，然后连续点击3!!键，将转到屏幕底部继续输入针对行范围`:.,.+2!`的命令。以下命令，将本行及后续2行（共计3行）的字母转换为大写：

```vim
:.,.+2!tr [:lower:] [:upper:]
```

使用以下命令，可以将指定[标记](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-53-Mark.html)（Mark）之间的行的字母转换为大写：

```vim
:'a,'b!tr [:lower:] [:upper:]
```

在可视化模式下，也可以使用外部程序 {filter} 过滤高亮选中的行。例如选中文本之后，点击!键，将转到屏幕底部继续输入针对选中范围`'<,'>!`的命令。以下命令，将注释选中的行：

```vim
'<,'>! perl -nle 'print "\#".$_'
```

请注意，过滤程序将对整行进行处理，所以请使用`V`命令进入的行可视化模式（Linewise visual mode)。

## 文本处理

使用以下命令，将按照数字顺序对当前文本进行排序。请注意，此处调用的是外部sort命令，与Vim内部的[:sort](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-09-03-sort.html)命令是不同的。

```vim
:%!sort -n
```

使用以下命令，将在行首增加行号：

```vim
:%!cat -n
```

![img](https://pic4.zhimg.com/80/v2-cb18dcac14b770dfdf2a4143c419787f_720w.jpg)

例如在当前文件中，包含以逗号分隔的多列文本：

```text
One,Two,Three,Four,Five
arborist,apple,artichoke,ant,author
branch,banana,broccoli,bee,book
```

使用以下Linux命令cut，可以仅保留其中的2-3列文本：

```vim
:%!cut -f2-3 -d,
Two,Three
apple,artichoke
banana,broccoli
```

## 生成并执行Shell命令

shell环境（比如sh和cmd），也可以作为过滤器来执行外部命令。

使用以下命令，可以将当前目录下的文件列表读取到当前文件中：

```vim
:r! ls *.html
```

利用替代命令，可以针对文件列表组合出需要的Shell命令。例如生成mv命令，将所有HTML文件重命名为XHTML文件：

```vim
:%s/\(.*\).html/mv & \1.xhtml
```

使用以下命令，则可以调用Shell来执行当前文件中的命令：

```vim
:!sh
```

可以看到，利用过滤器可以灵活生成并执行操作系统命令，以完成例如文件复制备份等批处理操作。

假设当前文件中包含以下Windows命令：

```powershell
ping -n 1 1.1.1.1
ping -n 1 1.1.1.2
ping -n 1 1.1.1.3
```

使用以下命令，将用文件中ping命令的输出来替换当前文本：

```
%!cmd
Microsoft Windows [Version 10.0.18362.720]
(c) 2019 Microsoft Corporation. All rights reserved.

D:\Temp>ping -n 1 1.1.1.1

Pinging 1.1.1.1 with 32 bytes of data:
Reply from 1.1.1.1: bytes=32 time=148ms TTL=54

Ping statistics for 1.1.1.1:
Packets: Sent = 1, Received = 1, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
Minimum = 148ms, Maximum = 148ms, Average = 148ms
...
```

在以上命令的执行过程中可以看到，Vim会将文本行保存为临时文件，然后调用外部程序进行过滤处理，然后再用输出结果替换当前文本。

![img](https://pic2.zhimg.com/80/v2-27799e3a476e54ebb13f22ee8f8d8dd1_720w.png)

过滤器使用的临时文件，通常保存在以下位置：

- Windows：$TMP、$TEMP、c:\TMP、c:\TEMP；
- Linux：$TMPDIR、/tmp、当前目录、$HOME。

请注意，Vim将依次检查以上目录，请确保有足够的权限读写这些目录。

使用以下命令，可以查看关于过滤程序的帮助信息：

```vim
:help filter
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-71-Shell.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-09-03-sort.html)>

发布于 2020-04-15