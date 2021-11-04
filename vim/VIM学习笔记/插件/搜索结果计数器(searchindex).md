# 搜索结果计数器(searchindex)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

更新 2019-11-18：自8.1.1270版本开始，Vim已经内置对搜索结果的计数显示，而不再需要安装额外的插件。

在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中增加以下设置，可以在屏幕底部，显示匹配搜索结果的总数，以及当前所处第几个匹配结果。

```vim
set shortmess-=S 
```

![img](https://pic3.zhimg.com/80/v2-c7bf32bb1eb5138780d6fbd95003500e_720w.jpg)

[vim-searchindex](https://link.zhihu.com/?target=https%3A//github.com/google/vim-searchindex)插件，可以在屏幕底部的命令行中，显示匹配搜索结果的总数，以及当前所处第几个匹配结果。

![img](https://pic3.zhimg.com/v2-4b2c5289dbd4c703488dc34e5149896e_b.jpg)

## **安装配置**

推荐您使用[vim-plug](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)或[Vundle](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html)等插件管理器，来安装GitHub上的[vim-searchindex](https://link.zhihu.com/?target=https%3A//github.com/google/vim-searchindex)插件。

使用`:help searchindex`命令，可以查看vim-searchindex插件的帮助文件。

编辑于 2019-11-28