# 匹配多个标签(Matching Multiple Tags)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

如果您明确知道某个标签的名称，那么可以使用[匹配单个标签](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-79-02-Tag-SingleMatch.html)章节中介绍的命令直接跳转。本节将继续介绍搜索和匹配多个标签的操作。

## 标签搜索（Tag Search Pattern）

我们可以在文件的任意位置上执行`:tag`或`:tjump`命令，以跳转至指定的标签定义处。这样就省去了将光标移动至标签之上，然后再点击跳转快捷键的繁琐。

如果启用了[wildmenu](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-02-wildmenu.html)选项，那么在输入命令时，我们只需要输入标签的开头几个字母，然后点击Tab键即可以自动补全标签名。

![img](https://pic2.zhimg.com/80/v2-a314aa61b7b0a86664b374e885113b85_720w.jpg)

通过在命令中使用[正则表达式](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vi-81-RegularExpressionBasic.html)，可以查找符合条件的标签。例如以下命令，将查找所有以“HTML”开头的标签，并跳转至第一个匹配标签：

```vim
:tag /^HTML*
```

而以下命令，将会显示所有以“Color”开头的标签，你可以选择跳转至某一匹配标签：

```vim
:tjump /^Color*
```

![img](https://pic2.zhimg.com/80/v2-8eaced65bd2f6a9eca7ecd2f2372a969_720w.jpg)

如果有多个匹配项存在，比如在几个文件中都定义了同名的函数，那么默认情况下，将优先跳转至当前文件中的匹配项。

使用`:h tag-priority`命令，可以查看关于优先级的帮助信息。

## 标签匹配列表（Tag Match List）

使用以下命令，将在屏幕底部显示标签匹配列表，然后根据您的选择在当前窗口中跳转至标签定义处：

```vim
:tselect [name]
```

在常规模式下，使用 **g]** 快捷键，将显示与光标下标签匹配的列表：

![img](https://pic1.zhimg.com/80/v2-e920a665cbca34afc3dd67af71081928_720w.jpg)

使用以下命令，将在屏幕底部显示标签匹配列表，然后根据您的选择在新建窗口中跳转至标签定义处：

```vim
:stselect [name]
```

在常规模式下，使用 **Ctrl-Wg]** 快捷键，将在新建窗口中，针对光标下的标签执行:tselect命令。

使用以下命令，可以根据匹配列表中的顺序进行标签跳转：

- `:tnext`跳转至下一个匹配项
- `:tprevious`跳转至上一个匹配项
- `:tfirst`跳转至第一个匹配项
- `:tlast`跳转至最后一个匹配项

在进行标签跳转的过程中，将在屏幕底部显示其相对位置：

```text
tag 1 of n or more
```

## 预览窗口（Preview Window）

当我们在代码中遇到某个函数，但不太清楚其具体含义，那么可以使用 **Ctrl-]** 键跳转至函数定义处，而此时当前屏幕将会显示该函数的具体实现代码；稍后我们仍需退回到之前的位置继续编写程序。

如果我们希望在编辑当前代码段的同时参考具体的函数定义，那么可以使用预览窗口（Preview Window）。

请注意，为了使用预览窗口，Vim必须包含[QuickFix](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html)特性。

使用以下命令，将在屏幕上方的预览窗口中显示指定标签的定义，并且保持当前光标的位置不变。也即是说，你可以同时在屏幕上查看引用函数的代码和定义函数的代码。

```vim
:ptag [name] 
```

如果当前已经存在一个预览窗口，那么将重用此窗口。

使用 **Ctrl-W}** 快捷键，也可以针对当前光标下的标签执行:ptag命令。

使用以下命令，将执行:tjump命令，并在预览窗口中显示标签：

```vim
:ptjump [name]
```

使用 **Ctrl-Wg}** 快捷键，也可以针对当前光标下的标签执行:ptjump命令。

使用以下命令，将执行:tselect命令，并在预览窗口中显示标签：

```vim
:ptselect [name]
```

使用以下命令，可以在预览窗口中进行标签跳转：

- `:ptnext`在预览窗口中执行:tnext命令
- `:ptprevious`在预览窗口中执行:tprevious命令
- `:ptfirst`在预览窗口中执行:tfirst命令
- `:ptlast`在预览窗口中执行:tlast命令
- `:ppop`在预览窗口中执行:pop命令
- `:pclose`关闭预览窗口

使用 **Ctrl-Wz** 快捷键，也可以关闭预览窗口。

## 位置列表（Location List）

使用以下命令，可以跳转到指定标签，并在当前窗口的新位置列表中加入匹配的标签：

```vim
:ltag [name]
```

使用以下命令，可以显示位置列表：

```vim
:lopen 
```

例如，首先使用`:ltag /^HTML*`命令，查找所有以“HTML”开头的标签并将它们放入到位置列表当中；然后使用`:lopen`命令，查看位置列表。

![img](https://pic1.zhimg.com/80/v2-fb80c8af8398da117f190a26e255c8b8_720w.jpg)

使用以下命令，可以在位置列表中进行标签跳转：

- `:lnext`移动到下一个标签
- `:lprevious`移动到下一个标签
- `:lfirst`移动到第一个标签
- `:llast`移动到最后一个标签
- `:lclose`关闭位置列表

## 智能跳转（tjump）

看了这么多命令，是不是已经心烦意乱了？我们期待的理想状况应该是：如果只有一个匹配标签，那么直接跳转；如果发现多个匹配标签，则显示匹配列表。

使用`**:tjump {name}**`命令，如果只发现一个匹配标签，将直接跳转至标签定义处；如果发现多个匹配标签，那么将显示标签匹配列表。

在常规模式下，使用 **gCtrl-]** 快捷键，将针对光标下的标签执行:tjupm命令。

使用`**:stjump**`命令，则可以在新建窗口中执行:tjupm命令。

在常规模式下，使用 **Ctrl-W g Ctrl-]** 快捷键，将针对光标下的标签在新建窗口中执行:tjupm命令。

![img](https://pic1.zhimg.com/80/v2-9e31303a4a6c996ef9f806e5fb4d2f70_720w.jpg)



发布于 2020-02-19