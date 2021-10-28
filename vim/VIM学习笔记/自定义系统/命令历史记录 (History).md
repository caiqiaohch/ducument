# 命令历史记录 (History)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

6 人赞同了该文章

Vim会将命令历史记录，保存在[viminfo](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-01-viminfo.html)文件中；通过viminfo和history选项，可以控制存储历史记录的类型和数量；在[命令行模式](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-CommandlineMode.html)和[搜索文本](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/03/vim.html)时，则可以重新调用这些历史记录。

## 命令历史类型

命令历史可以分为以下几种类型（{name}）：

![img](https://pic3.zhimg.com/80/v2-dca2ca1237d08b4d820428418b1e3a82_720w.jpg)

## 查看命令历史

使用以下命令，可以显示命令行历史记录：

```vim
:history
```

![img](https://pic2.zhimg.com/80/v2-597a27c2d99bdc8c99319f8551f72635_720w.jpg)

使用以下命令，可以显示所有类型的历史记录：

```vim
:history all
```

![img](https://pic1.zhimg.com/80/v2-e2c31ba725554aae8a0d252fc81ed57c_720w.jpg)

使用以下格式的:history命令，可以查看指定类型和指定数目的历史记录：

```vim
:his[tory] [{name}] [{first}][, [{last}]]
```

- `{name}`，指定历史记录[类型](file:///E:/Anthony_GitHub/learn-vim/learn-vi-46-01-History.html#history_name)；
- `{first}`，指定命令历史的起始位置（默认为第一条记录）；
- `{last}`，指定命令历史的终止位置（默认为最后一条记录）。

如果没有指定 {first} 和 {last}，那么将会列出所有命令历史。

如果指定了 {first} 和 {last}，那么就会列出指定范围内的历史记录条目。例如以下命令，将列出第一到第五条命令行历史：

```vim
:history c 1,5
```

正数，表示历史记录的绝对索引，也就是:history命令列出的第一列数字。即使历史记录中的其它条目被删除了，该索引数字也会保持不变。例如以下命令，将列出指定位置（第五条）命令行历史：

```vim
:history c 5
```

负数，表示历史记录的相对索引。以最新一条记录 (索引号为 -1) 为基准向后算起。如以下命令，将列出所有历史记录中倒数第二条记录：

```vim
:history all -2
```

使用以下命令，则会列出所有历史记录中最近的两条记录：

```vim
:history all -2,
```

使用以下命令，可以查看:history命令的帮助信息：

```vim
:help :history
```

## 删除历史记录

使用以下命令，可以删除命令行历史记录：

```vim
:call histdel("")
```

可以删除指定类型的历史记录。例如使用以下命令，将删除所有查询历史记录：

```vim
:call histdel("seach")
```

您也可以直接编辑[viminfo](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-01-viminfo.html)文件，直接删除其中的历史记录。请注意，需要重启Vim，以重新读取修改后的viminfo文件。

## 命令历史选项

通过history选项，可以控制记录历史记录的数量（默认为50）。例如以下命令，设置保存1000条命令历史记录：

```vim
:set history=1000
```

请注意：在[viminfo](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-01-viminfo.html)选项中，也有命令历史相关参数；请在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中，检查'viminfo'和'history'设置的的一致性和优先级。

发布于 2019-09-28