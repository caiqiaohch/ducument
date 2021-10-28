# wildmenu

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

9 人赞同了该文章

使用'wildmenu'选项，将启用增强模式的命令行补全。在命令行中输入命令时，按下'wildchar'键（默认为Tab）将自动补全命令和参数：此时将在命令行的上方显示可能的匹配项；继续按下'wildchar'键，可以遍历所有的匹配项；也可以使用方向键或者CTRL-P/CTRL-N键，在匹配列表中进行移动；最后点击回车键，选择需要的匹配项。

## **wildmenu**

使用以下命令，可以启用wildmenu：

```vim
:set wildmenu
```

例如在命令行中输入“:spe”，然后点击Tab键，将列出以spe开头的命令列表；再次点击Tab键，将可以在wildmenu中遍历匹配的命令：

![img](https://pic3.zhimg.com/80/v2-4473a8fee54b983b4d6a813b600c4642_720w.jpg)

使用以下命令，可以查看wildmenu的帮助信息：

```vim
:help wildmenu
```

## wildmode

在命令行中输入命令时，文件名也是可以自动补全的。例如希望编辑当前目录下的某个文件，在输入:e命令和空格之后，点击Tab键，将自动补全文件名。而补全的方式，则是通过以下'wildmode'选项来控制：

使用""选项，将仅仅使用第一个匹配结果；即使再次按下wildchar键，也不会继续查找其它匹配项：

```vim
:set wildmode=
```

使用"full"选项，将在wildmenu中显示匹配的文件；点击wildchar键，可以遍历匹配的文件：

```vim
:set wildmode=full
```

![img](https://pic1.zhimg.com/80/v2-5b7401b8e91cb1ae85ae0e9661cd0f3c_720w.png)

使用"longest"选项，将用最长的公共子串补全：

```vim
:set wildmode=longest
```

![img](https://pic2.zhimg.com/80/v2-6b8c53abedc2bdb8157026e36973b701_720w.png)

使用"longest:full"选项，将用最长的公共子串补全，并显示在wildmenu中：

```vim
:set wildmode=longest:full
```

![img](https://pic4.zhimg.com/80/v2-c0d269c277c1bd3cb3be9a03ad8e1677_720w.png)

使用"list"选项，将显示可能匹配的文件列表：

```vim
:set wildmode=list
```

![img](https://pic1.zhimg.com/80/v2-6f09b114ca9abc1a6519658876e014bc_720w.jpg)

使用"list:full"选项，将显示可能匹配的文件列表，并使用第一个匹配项进行补全：

```vim
:set wildmode=list:full
```

![img](https://pic2.zhimg.com/80/v2-da6d817b5e2b6cf16b2160a3f23b6795_720w.jpg)

使用"list:longest"选项，将显示可能匹配的文件列表，并使用最长的子串进行补全：

```vim
:set wildmode=list:longest
```

![img](https://pic4.zhimg.com/80/v2-383e4ac763bd545669f9d4411b6cf39b_720w.jpg)

推荐使用"**list:longest,full**"选项，点击Tab键，将显示可能匹配的文件列表，并使用最长的子串进行补全；再次点击Tab键，可以在wildmenu中遍历匹配的文件列表：

```vim
set wildmode=list:longest,full
```

![img](https://pic2.zhimg.com/80/v2-da6d817b5e2b6cf16b2160a3f23b6795_720w.jpg)

使用以下命令，可以查看wildmode的帮助信息：

```vim
:help wildmode
```

## wildignore

通过'wildignore'选项，可以在匹配列表中忽略指定类型的文件：

```vim
:set wildignore=*.dll,*.exe,*.jpg,*.gif,*.png
```

在'suffixes'选项中，会列出一系列文件名的前缀。当有多个文件符合匹配条件时，包含指定前缀的文件则会获得较低的优先级。也即是说，这些文件将会显示在匹配列表的最后。以下为suffixes选项的默认值：

```vim
:set suffixes=.bak,~,.o,.h,.info,.swp,.obj
```

## wildchar

通过'wildchar'选项，可以设置命令行自动补全的触发键。默认为Tab键。例如以下命令，将其设置为F12键：

```vim
:set wildchar=<F12>
```

## wildmenu应用

在命令行中输入`:color`以及空格，然后点击Tab键，将列出所有可用的[配色方案(Color Scheme)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-62-ColorScheme.html)，继续点击Tab键可以选用需要的配色方案。

```vim
:color 
```

![img](https://pic4.zhimg.com/80/v2-5447d52b27e613d79a2f7e23875af497_720w.png)

使用以下命令，可以查看所有外部（例如PATH）和内部（例如MYVIMRC）变量：

```vim
:echo $
```

![img](https://pic3.zhimg.com/80/v2-884c91d6d982c239ccad6d8407e50322_720w.jpg)



发布于 2019-10-16