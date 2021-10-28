# 自动命令(autocmd)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

25 人赞同了该文章

自动命令，是在指定事件发生时自动执行的命令。利用自动命令可以将重复的手工操作自动化，以提高编辑效率并减少人为操作的差错。

比如自定义以下函数，用于在文件中插入当前日期：

```vim
:function DateInsert()
:    $read !date
:endfunction
```

使用以下命令，可以手动调用此函数：

```vim
:call DateInsert()
```

而通过以下自动命令，则可以在保存文件时自动执行函数，而不再需要额外的手动操作：

```vim
:autocmd FileWritePre * :callDateInsert()<CR>
```

## 定义自动命令

可以使用以下格式的autocmd命令，来定义自动命令：

```vim
:autocmd [group] events pattern [nested] command
```

- *group*，组名是可选项，用于分组管理多条自动命令；
- *events*，事件参数，用于指明触发命令的一个或多个事件；
- *pattern*，限定针对符合匹配模式的文件执行命令；
- *nested*，嵌套标记是可选项，用于允许嵌套自动命令；
- *command*，指明需要执行的命令、函数或脚本。

**events参数**

Vim内置了近80个事件，以下表格按照类别列示了较为常用的事件：

![img](https://pic4.zhimg.com/80/v2-212dbfc1f437e9dfa7d2981c5522f827_720w.jpg)

假设我们打开文件并输入文本，然后保存并退出，那么这些操作将以下顺序触发一系列事件：

![img](https://pic2.zhimg.com/80/v2-a384d50505dc47a648844f87a6b3bb3d_720w.jpg)

[Source: Event-driven scripting and automation](https://link.zhihu.com/?target=https%3A//developer.ibm.com/tutorials/l-vim-script-5/)

您可以使用以下命令，获得各个事件的详细说明：

```vim
:help autocommand-events
```

**pattern参数**

匹配模式用来指定应用自动命令的文件。在匹配模式中，可以使用以下特殊字符：

`*` 匹配任意长度的任意字符
`?` 匹配单个字符
`\?`匹配字符'?'
`.` 匹配字符'.'
`,` 用于分割多个pattern
`\,`匹配字符','

可以使用逗号来分割多个模式，以匹配多种类型的文件。例如以下命令，将对于.c和.h文件设置'textwidth'选项：

```vim
:autocmd BufRead,BufNewFile *.c,*.h set tw=0
```

您可以使用以下命令，获得匹配模式的详细说明：

```vim
:help autocmd-patterns
```

**nested参数**

默认情况下，自动命令并不会嵌套执行。例如在自动命令中执行:e或:w命令，将不会再次触发BufRead和BufWrite事件。而使用nested参数，则可以激活嵌套的事件。

```vim
:autocmd FileChangedShell *.c nested e!
```

## 查看自动命令

使用以下命令，可以列出所有自动命令：

```vim
:autocmd
```

![img](https://pic2.zhimg.com/80/v2-6da59ced58fbad95328ef0612417ef69_720w.jpg)

你会发现自动命令的列表将会非常的长，其中既包括了在vimrc文件中用户定义的自动命令，也包括了各种插件定义的自动命令。

如果在命令中指定了group，那么将会列出所有与指定group相匹配的自动命令；同理，也可以在命令中指定event和pattern，以查看相匹配的自动命令：

```vim
:autocmd filetypedetect * *.htm
```

![img](https://pic3.zhimg.com/80/v2-f9d80883d5a2cbffbc5925ea3b64fece_720w.jpg)

## 删除自动命令

使用以下命令，可以删除所有自动命令：

```vim
:autocmd!
```

注意：此操作也将删除插件所定义的自动命令，请谨慎操作。

使用以下命令，可以删除指定组的自动命令：

```vim
:autocmd! group
```

在命令中指定组、事件和匹配模式，可以删除特定的自动命令：

```vim
autocmd! Unfocussed FocusLost *.txt
```

在命令中使用特殊字符“*”来指代所有事件或文件。例如以下命令，将删除Unfocussed组中所有针对txt文件的自动命令：

```vim
autocmd! Unfocussed * *.txt
```

在命令中忽略文件匹配模式，那么所有针对指定事件的针对命令都将被删除。例如以下命令，将删除Unfocussed组在所有针对FocusLost事件的自动命令：

```vim
autocmd! Unfocussed FocusLost
```

## 自动命令组

通过`:augroup`命令，可以将多个相关联的自动命令分组管理，以便于按组来查看或删除自动命令。例如以下命令，将C语言开发的相关自动命令，组织在“cprogram”组内：

```vim
:augroup cprograms
:    autocmd!
:    autocmd FileReadPost *.c :set cindent
:    autocmd FileReadPost *.cpp :set cindent
:augroup END
```

如果我们针对同样的文件和同样的事件定义了多条自动命令，那么当满足触发条件时将分别执行多条自动命令。因此，建议在自动命令组的开头增加:autocmd!命令，以确保没有重复的自动命令存在。

您可以使用以下命令，获得自动命令组的帮助信息：

```vim
:help :augroup
```

## 自动命令选项

通过eventignore选项，可以忽略指定的事件，而不触发自动命令。例如使用以下命令，将忽略进入窗口和离开窗口的事件：

```vim
:set eventignore=WinEnter,WinLeave
```

如果希望忽略所有事件，那么可以使用以下设置：

```vim
:set eventignore=all
```



发布于 2019-12-19