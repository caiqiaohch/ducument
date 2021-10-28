# 编译源码(Compile Code)-C

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

2 人赞同了该文章

以下操作在[Fedora](https://link.zhihu.com/?target=https%3A//getfedora.org/)31下验证成功。在不同的操作系统中，以下命令和参数也可能略有不同，请根据实际情况进行调整。

## 设置编译器

使用以下命令，确认可以正常运行[GCC](https://link.zhihu.com/?target=https%3A//gcc.gnu.org/)编译器：

```bash
$ gcc --version 
```

![img](https://pic1.zhimg.com/80/v2-b56d46380d671831069fba5112d868f4_720w.jpg)

使用以下命令，设置'makeprg'选项为gcc命令：

```vim
:set makeprg=gcc\ -o\ %<\ %
```

## 编译源码

使用以下命令，将根据'makeprg'选项进行编译，并生成文件：

```vim
:make
```

如果编译出现错误，将在[QuickFix](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html)中显示错误列表，并自动跳转到第一个错误处：

![img](https://pic2.zhimg.com/80/v2-a9811a57c47b6a59041d0e34608255d1_720w.jpg)

如果希望在编译时保持当前光标位置不变，那么可以使用以下命令：

```vim
:make!
```

使用`:cw`命令，将打开quickfix窗口。使用`:cp`命令，跳转到上一个错误；使用`:cn`命令，跳转到下一个错误。关于QuickFix操作的更多信息，请参阅[QuickFix](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html)章节。

使用`:cl`命令，可以列示所有错误信息：

![img](https://pic3.zhimg.com/80/v2-970080d0d5b3134dc3a312df03773a2e_720w.jpg)

在修复错误并成功编译之后，将显示命令输出：

![img](https://pic1.zhimg.com/80/v2-2045e4e77f03761e011156ee8b50f490_720w.jpg)

使用以下命令，可以执行编译后的程序：

```vim
:!./%:r 
```

## 配置编译环境

通过在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)文件中增加以下[自动命令](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-49-01-autocmd.html)，可以为C语言文件设置编译快捷键：

```vim
augroup make_c
	au!
	au FileType c,cpp  set makeprg=gcc\ -o\ %<\ %
	au FileType c,cpp  map <buffer> <leader><space> :w<cr>:make<cr>
augroup end
```

如果不希望修改'makeprg'选项，那么可以定义快捷键来完成编译和执行程序的操作：

```vim
map <F8> :w <CR> :!gcc % -o %< && ./%< <CR>
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim--QuickFix-opt.html)>

发布于 2020-03-22