# Zeavim离线文档查看器

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

6 人赞同了该文章

[Zeal](https://link.zhihu.com/?target=https%3A//zealdocs.org/)是开源的跨平台软件，用于离线浏览各种开发文档。Zeal使用[Dash](https://link.zhihu.com/?target=https%3A//kapeli.com/dash)提供的文档集（[Docsets](https://link.zhihu.com/?target=https%3A//kapeli.com/docsets)），涵盖近200种开发语言。

**[Zeavim](https://link.zhihu.com/?target=https%3A//github.com/KabbAmine/zeavim.vim)**插件，可以在Vim中调用Zeal来查看离线文档。

## **安装配置**

推荐您使用[vim-plug](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)或[Vundle](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html)等插件管理器，来安装GitHub上的[Zeavim](https://link.zhihu.com/?target=https%3A//github.com/KabbAmine/zeavim.vim)插件。

[建议](https://link.zhihu.com/?target=https%3A//github.com/KabbAmine/zeavim.vim%23mapping)在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中增加以下设置，以利用[前缀键](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-54-Leader.html)（leader）来调用Zeavim功能：

```vim
nmap <leader>z <Plug>Zeavim
vmap <leader>z <Plug>ZVVisSelection
nmap gz <Plug>ZVOperator
nmap <leader><leader>z <Plug>ZVKeyDocset
```

## **查询文档**

使用**z**快捷键或`:Zeavim`命令，将根据当前文件类型在相应的Docset中，查找当前光标下的单词：

![img](https://pic4.zhimg.com/80/v2-90df4917ec28833b6a06b51b63aa3c9f_720w.jpg)

使用`gz`命令，将根据当前文件类型在相应的Docset中，查找文本对象指定的关键词。例如在Vim脚本文件中，使用`gziw`命令，将在Vim Docset中查找当前光标下的单词：

![img](https://pic2.zhimg.com/v2-7b8686c2b335026adc4722cf49aa9c9d_b.jpg)

使用**z**快捷键或`:Zeavim!`命令，将根据用户输入，在指定的Docset中，查找指定的关键词：

![img](https://pic2.zhimg.com/v2-d3363aeefa2c6cf95508d1c7a43b8e81_b.jpg)

使用以下命令，可以查看插件的帮助文件：

```vim
:help zeavim 
```

## **使用命令行调用Zeal**

如果不希望安装额外的插件，那么也可以用"zeal docset:keyword"的形式直接调用Zeal[命令行](https://link.zhihu.com/?target=https%3A//github.com/zealdocs/zeal/%23command-line)。例如以下命令，将在Vim文档中查找关键字"endif"：

```vim
:!zeal vim:endif
```

定义以下快捷键，将根据当前文件类型在相应的Docset中，查找当前光标下的单词：

```vim
:nnoremap <Leader>z :exec "!zeal " . expand(&ft) . ":" . "<cword>"<CR> 
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)>

发布于 2020-07-31