# 前缀键(leader)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

27 人赞同了该文章

Vim预置有很多快捷键，再加上各类插件的快捷键，大量快捷键出现在单层空间中难免引起冲突。为缓解该问题，而引入了前缀键<leader>。藉由前缀键， 则可以衍生出更多的快捷键命名空间（namespace)。例如将r键配置为<leader>r、<leader><leader>r等多个快捷键。

使用`:help `命令，可以查看关于前缀键的更多信息。

## **定义前缀键**

前缀键默认为“\”。使用以下命令，可以将前缀键定义为逗号：

```vim
let mapleader=","
```

使用以下命令，利用转义符“\”将前缀键设置为空格键也是不错的主意：

```vim
let mapleader = "\<space>"
```

## **配置实例**

定义以下快捷键，用于删除当前文件中所有的行尾多余空格：

```vim
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
```

定义以下快捷键，用于快速编辑和重载[vimrc配置文件](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)：

```vim
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
```

定义以下快捷键，使用前缀键和数字键快速切换[缓冲区](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-13-MultiBuffers.html)：

```vim
nnoremap <leader>1 :1b<CR>
nnoremap <leader>2 :2b<CR>
nnoremap <leader>3 :3b<CR> 
```



发布于 2019-04-24