# 自动补全选项(Auto-Completion-Option)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

2 人赞同了该文章

在[插入模式](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-42-InsertMode.html)下，利用自动补全（[Insertion-Completion](https://link.zhihu.com/?target=http%3A//vimcdoc.sourceforge.net/doc/insert.html%23ins-completion)）功能，vim能够根据正在输入的字符，查找匹配的关键字并显示在弹出菜单（popup menu）中。通过选择匹配项，可以补全输入的部分关键字甚至整行文本。

## 关键字补全选项

使用Ctrl-N或Ctrl-P快捷键，将按照'complete'选项指定的范围来搜索匹配的关键字。其默认值为：

```vim
:set complete=.,w,b,u,t,i
```

也就是说，默认将在以下来源中查找关键字：

- 在当前缓冲区中进行查找；
- 在其他窗口中进行查找；
- 在其他已载入的缓冲区中进行查找；
- 在没有载入缓冲区的文件中进行查找；
- 在当前的标签（tags）列表进行查找；
- 在由当前文件（如#include）包含进来的头文件中进行查找。

假设文件中包含以下句子：

```text
I have beautiful flowers in my flower garden
```

我们另起一行并输入“f”字母，然后点击Ctrl-X Ctrl-N快捷键，将会在当前文件内查找已经存在的单词：

![img](https://pic4.zhimg.com/80/v2-9f0466038b8d83e4433b842d2f88733b_720w.jpg)

而使用Ctrl-N快捷键，将会根据'complete'选项指定的范围进行查找。比如在其它缓冲区内找到了更多以f开头的单词：

![img](https://pic1.zhimg.com/80/v2-ac7d7a74353467052622b7a6cc3ecb30_720w.jpg)

通过以下命令设置'complete'选项，可以定义自动补全的查找范围：

```vim
:set complete=key,key,key
```

命令中可能出现的key值如下：

![img](https://pic1.zhimg.com/80/v2-47389e5812a419c2cacac40fb97c1224_720w.jpg)

使用以下命令，可以将字典文件添加到搜索列表中：

```vim
:set complete+=k
```

使用以下命令，可以将包含的文件从搜索列表中移除：

```vim
:set complete-=i
```

使用`:h 'complete'`命令，可以查看'complete'选项的帮助信息。

## 忽略大小写

如果我们使用以下命令，设置了在查找过程中忽略大小写，那么在自动完成时，反而会造成区分大小写：

```vim
:set ignorecase
```

使用以下命令，则可以设置在自动完成时忽略大小写：

```vim
:set infercase
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-01-AutoCompletion-Intro.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-80-02-AutoCompletion-Detail.html)>

编辑于 2020-02-13