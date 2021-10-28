# 对话框(Dialog)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

## **查找对话框**

使用以下命令，将会打开一个查找对话框：

```vim
:promptfind [string]
```

如果在命令中指定了[string]值，那么就会查找该字符串；如果没有指定[string]值，那么将会查找上次搜索的字符串。

![img](https://pic1.zhimg.com/80/v2-adb7bc873645757b16092eede3af0b80_720w.jpg)

## **替换对话框**

使用以下命令，将会打开一个替换对话框：

```vim
:promptrepl [string]
```

如果在命令中指定了[string]值，那么就会查找并替换该字符串；如果没有指定[string]值，那么将会查找并替换上次搜索的字符串。

![img](https://pic1.zhimg.com/80/v2-2306d466411f1d654a259be0a599ad90_720w.jpg)

## **文件对话框**

使用:browse命令，可以打开一个文件对话框，然后对选中的文件执行操作。例如以下命令，将在打开的文件对话框中选择文件，然后执行:edit命令：

```vim
:browse edit
```

![img](https://pic3.zhimg.com/80/v2-c443d665bf184865f5bc49240c87c2ee_720w.jpg)

:browse命令的一般形式如下：

```vim
:browse {command} [directory]
```

- *{command}*，需要执行的编辑器命令。例如，:read，:write，:edit等；
- *[directory]*，指定文件浏览器开始的目录。如果没有指定此参数，那么将会使用browsedir选项所指定的目录。

browsedir选项可以使用以下三个值：

- *last*，上次浏览的目录（默认值）；
- *buffer*，与当前缓冲区相同的目录；
- *current*，当前目录。

如果希望从当前目录开始选择文件，那么可以使用以下设置命令：

```vim
:set browsedir=current
```

可以使用以下命令，在指定目录中选择并打开文件：

```vim
:browse e E:\learn-vim\
```

## **选项对话框**

使用`:browse set`或`:options`命令，将会打开一个窗口并显示Vim选项：

![img](https://pic4.zhimg.com/80/v2-5b0dae5fe6f30f82c4fc8c969175696f_720w.jpg)

在目录行上（index line），点击<CR>回车键，将跳转到相应类别的具体选项：

![img](https://pic1.zhimg.com/80/v2-6517dae3bb32ea3b1dec3962b24ac9f0_720w.jpg)

在包含set命令的行上（set line），点击<CR>回车键，可以执行该设置命令。如果该选项是布尔值，那么点击回车键将立刻打开/关闭此选项；如果该选项是数值或者字符串，那么可以先修改此值，然后再点击回车键来变更选项。

在包含帮助信息关键字的行上（help line），点击<CR>回车键，可以显示该选项的帮助信息。

使用`:help :browse-set`命令，可以查看更多选项对话框的帮助信息。关于更多选项设置的信息，请参阅[设置选项(set-option)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-50-SetOption.html)章节。

![img](https://pic4.zhimg.com/80/v2-4c8c4d780ae5f65756e393123887da13_720w.jpg)