# 模式行(Modeline)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

程序员对于制表符常常有不同的偏好，有的使用8个空格，而有的则使用4个空格。可以想见，如果使用不同设置的用户操作相同的文件，必将对文本格式造成影响。

如果希望针对特定文件应用特定的设置，那么修改全局性的vimrc配置文件就显得小题大做了；而使用模式行(modeline)，则可以将选项设置配置在文件本身当中。

例如将以下模式行放置到文件开头，将在打开该文件时设置制表符为4个空格：

```vim
/* vim:set tabstop=4: */
```

## **启用模式行**

默认设置下，‘modeline’选项是打开的，Vim将会在文件的开头5行和结尾5行中查找模式行：

```vim
:set modeline
```

如果希望改变扫描的行数，那么可以设置‘modelines’选项：

```vim
:set modelines=1
```

定义以下快捷键，可以启用模式行并自动应用到当前文件，而不需要重新打开文件：

```vim
:nnoremap <leader>ml :setlocal invmodeline <bar> doautocmd BufRead<cr>
```

模式行主要有以下两种格式：

（1）不包含set命令的格式

- [text{white}]{vi:|vim:|ex:}[white]{options}
- 模式行将持续到行尾处结束；
- 选项之间不能包含空格。

以下为正确的模式行：

```vim
/* vim:tabstop=4:expandtabs:shiftwidth=4 */
```

以下模式行选项中包含空格，将报错“Error E518: Unknown option: */”：

```vim
/* vim: noai:ts=4:sw=4 */
```

（2）包含set命令的格式

- [text{white}]{vi:|vim:|Vim:|ex:}[white]se[t] {options}:[text]
- 模式行将在第二个“:”处结束；
- 模式行的开头和结尾可放置任意字符，建议使用“/* */”；
- 开头字符之后的空格为必需的分隔符，不可以省略；
- 选项之间以空格分隔。

以下为正确的模式行：

```vim
/* vim: set ai tw=75: */
```

以下模式行开头字符之后缺少空格，将无法生效，但不会报错：

```vim
/*vim: set tabstop=4: */
```

## **模式行实例**

在Vim帮助文件的末尾，将发现以下模式行：

```vim
vim:tw=78:ts=8:noet:ft=help:norl:
```

其中，tw(textwidth)选项设置最大文本宽度为78；ts(tabstop)选项设置制表符为8个空格；noet(noexpandtab)选项设置为不扩展制表符；ft(filetype)选项设置文件类型为help；norl(norightleft)选项设置文本从左向右显示。

在Apache配置文件中，包含以下模式行：

```vim
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
```

其中，"#"标记本行为注释；syntax选项设置语法为apache；sw(shiftwidth)选项设置缩进为4个字符；sts(softtabstop)选项设置插入Tab时算作4个空格；sr(shiftround)选项设置缩进取整到'shiftwidth'的倍数。

通过使用模式行，可以确保文本被按照正确的格式展示，而不受本地设置的干扰。

## **禁用模式行**

使用以下设置，Vim将不会查找模式行：

```vim
:set nomodeline
```

## **帮助信息**

使用以下命令，可以查看当前设置：

```vim
:verbose set modeline? modelines?
```

使用以下命令，可以查看帮助信息：

```vim
:help 'modeline'
:help 'modelines' 
```



发布于 2020-06-28