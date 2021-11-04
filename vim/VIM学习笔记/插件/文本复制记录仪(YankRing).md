# 文本复制记录仪(YankRing)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

2 人赞同了该文章

Vim使用术语"yank"和"pull"，来指代我们所熟悉的复制和粘贴 ([Copy & Paste](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-03-yank.html)）。在Vim中，任何被复制和删除的文本，都会被保存在[寄存器(Regists)](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-12-Register.html)中。例如，使用`yy`命令复制当前行或使用`dd`命令删除当前行，都会同时将当前行放入默认寄存器中。当然，你也可以在命令中指定寄存器。比如使用`"ayy`命令，将复制的文本放到寄存器a中；然后使用`:pu a`命令，就可以粘贴寄存器a中的内容。

使用`:register`命令，可以查看完整的寄存器列表：

![img](https://pic3.zhimg.com/80/v2-fdd2efd87f69dad3afb0128631d3aa1a_720w.jpg)

面对大量的历史纪录，我们很难仅凭记忆来找到并粘贴之前复制的文本。而**[YankRing](https://link.zhihu.com/?target=https%3A//www.vim.org/scripts/script.php%3Fscript_id%3D1234)**插件，则可以更加方便地查找和粘贴文本。

## 安装配置

推荐使用[vim-plug](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)或[Vundle](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html)等插件管理器，来安装Vim.org上的[YankRing](https://link.zhihu.com/?target=https%3A//www.vim.org/scripts/script.php%3Fscript_id%3D1234)插件。

可以在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)文件中，自定义插件的选项。例如以下命令指定条目的最小长度为2个字符，以避免删除的单个字符也被记录到YankRing中：

```vim
let yankring_min_element_length = 2
```

以下表格列示了主要选项的默认设置：

- yankring_max_history，100，保存历史纪录的最大数目
- yankring_history_dir，$HOME，保存历史纪录的文件位置
- yankring_min_element_length，1，如果复制的文本长度小于此值，则不会被记录
- yankring_max_element_length，1MB，如果复制的文本长度大于此值，则会被截断
- yankring_enabled，1，自动启用
- YankRingyankring_ignore_duplicate，1，忽略重复的纪录
- yankring_window_auto_close，1，当选择某条纪录之后自动关闭YankRing窗口

## YankRing窗口

使用以下命令打开YankRing窗口，以显示复制和删除文本的历史记录：

```vim
:YRShow
```

![img](https://pic3.zhimg.com/80/v2-d985613412aae7570ddb130d2530b626_720w.jpg)

YankRing窗口顶端的状态行，显示以下向导信息，以帮助你操作列表中的历史记录：

![img](https://pic3.zhimg.com/80/v2-2c9159a7b9afc13959e7b13158061926_720w.jpg)

点击 **?** 键，将显示各个命令的说明：

![img](https://pic2.zhimg.com/80/v2-65828ed8a3680422bf46e8952072d809_720w.jpg)

您可以使用上下键、鼠标滚轮或移动命令，来浏览所有条目；当使用回车键、鼠标双击或命令，选择某条纪录之后，将完成粘贴操作并关闭YankRing窗口。

## YankRing命令

使用以下命令，可以将指定范围内的文本加入YankRing：

```vim
:5,10YRYankRange
```

在可视化模式下，使用`YRYankRange`命令，则会将所有选中的文本加入到YankRing中。

使用以下命令，将在屏幕底部提示你输入关键字（支持正则表达式）以进行查找，并将在YankRing窗口中显示匹配结果：

```vim
:YRSearch
```

## 帮助信息

使用`:h yankring`命令，可以查看YankRing插件的帮助文件。

使用`:h yankring-tutorial`命令，则可以参照实例以快速了解插件功能。

YankRing无疑大大增强了Vim复制粘贴的功能，但同时也引入了更多的快捷键和命令；通过新建YankRing窗口，来完成查找和粘贴历史条目的操作，对我个人来说也看不到效率的提升。

更重要的是，例如**[Ditto](https://link.zhihu.com/?target=https%3A//alternativeto.net/software/ditto/)**等操作系统层面的剪贴板工具，覆盖了更多的应用，而且操作也更直观。那么YankRing是不是一个多余的存在了呢？

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)>

发布于 2020-02-23