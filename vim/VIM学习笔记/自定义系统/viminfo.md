# viminfo

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

16 人赞同了该文章

Vm使用viminfo选项，来定义如何保存会话（session）信息，也就是保存Vim的操作记录和状态信息，以用于重启Vim后能恢复之前的操作状态。

## **viminfo文件**

viminfo文件默认存储在以下位置：

- Linux和Mac：$HOME/.viminfo，例如：~/.viminfo
- Windows：$HOME\_viminfo，例如：C:\Users\yiqyuan\_viminfo

viminfo文件主要保存以下内容：

- Command Line History（命令行历史纪录）
- Search String History（搜索历史纪录）
- Expression History（表达式历史纪录）
- Input Line History（输入历史记录）
- Debug Line History（调试历史纪录）
- Registers（寄存器）
- File marks（标记）
- Jumplist（跳转）
- History of marks within files（文件内标记）

Vim在退出时，会将上述信息存放到viminfo文件中；在启动时，将会自动读取viminfo信息文件。

使用以下命令，可以手动创建一个viminfo文件：

```vim
:wviminfo file_name
```

使用以下命令，可以重新读去viminfo文件：

```vim
:rviminfo
```

使用以下命令，可以查看关于viminfo文件的帮助信息：

```vim
:help viminfo
```

## **viminfo选项**

viminfo选项可以指定保存哪些内容，以及在何处的viminfo文件中保存这些信息。viminfo选项是一组使用逗号分隔的字符串；其中每个参数，是以单个字符开头的数值或字符串值。

Windows下的默认值为：

```vim
set viminfo='100,<50,s10,h,rA:,rB:
```

Linux和Mac下的默认值为：

```vim
set viminfo='100,<50,s10,h
```

![img](https://pic3.zhimg.com/80/v2-8a207f9f9d39dadd8388b75dc3c3255e_720w.jpg)

在单独指定viminfo文件的位置时，为了不覆盖viminfo选项的当前值，通常会在设置命令中使用“+=”操作符：

```vim
:set viminfo+=n$LOCALAPPDATA/_viminfo
:set viminfo+=nC:\\_viminfo
```

您可以参考以下命令，在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中，定义viminfo选项：

```vim
set viminfo=\"50,'1000,h,f1,rA:,r$TEMP:,r$TMP:,r$TMPDIR:,:500,!,n$VIM/_viminfo
```

![img](https://pic4.zhimg.com/80/v2-5a979ee7e81157bb0f8d710b6faa47bb_720w.jpg)

请注意：

- 请不要将“<”设置过大，因为此选项将影响保存至viminfo文件中的信息量。在Vim启动时，如果读取尺寸过大的viminfo文件，将影响Vim启动速度；
- 请在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)文件开头，首先定义`:set nocompatible`选项。

使用以下命令，可以查看viminfo选项的更多信息：

```vim
:help 'viminfo' 
```



发布于 2019-09-23