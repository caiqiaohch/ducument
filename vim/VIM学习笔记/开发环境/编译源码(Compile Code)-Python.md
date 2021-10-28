# 编译源码(Compile Code)-Python

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

[Python](https://link.zhihu.com/?target=https%3A//www.python.org/)作为一种解释型编程语言，需要解释器来编译并执行Python代码。

## 测试Python

对于Linux和Mac操作系统，均已预装Python。而在Windows下，可以使用安装包或者直接解压版zip文件。

使用以下命令，可以查看当前Python版本：

```bash
$ python --version
```

![img](https://pic2.zhimg.com/80/v2-fd497535eddc49ce7d33e8ddfa038a81_720w.jpg)

## 设置动态调用库

新版本的Vim已经默认支持Python。可以使用`:version`命令，确认是否包含“+python/dyn”和“+python3/dyn”特性。

![img](https://pic4.zhimg.com/80/v2-baec235e196a612f02b564d7a39a836b_720w.jpg)

其中dyn，即dynamic，表示可以通过'pythondll'和'pythonthreedll'选项动态调用Python库。

使用set pythonthreedll?命令，可以查看当前动态调用的Python库。以下为[Fedora](https://link.zhihu.com/?target=https%3A//getfedora.org/)31下的默认设置：

```vim
set pythonthreedll=libpython3.7m.so.1.0
```

如果您的Vim不支持动态调用Python库，那么以上命令将会报错。

如果您仅是[下载](https://link.zhihu.com/?target=https%3A//www.python.org/downloads/windows/)并解压程序包（而不是进行安装），那么同时需要设置pythonthreehome选项。例如以下命令，在Windows下设置Python3环境：

```vim
set pythonthreehome=C:\tools\Python3
set pythonthreedll=C:\tools\Python3\python38.dll
```

以下命令，可以在Mac下设置Python环境：

```vim
" for python 3.X
set pythonthreehome=/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.7
set pythonthreedll=/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.7/lib/libpython3.7m.dylib
" for python 2.X
set pythonhome=/System/Library/Frameworks/Python.framework/Versions/2.7
set pythondll=/System/Library/Frameworks/Python.framework/Versions/2.7/Python
```

请注意，在您的环境中Python所处的路径可能会不同。请在操作系统中使用以下命令，查看Python系统路径：

```bash
$ python -c "import sys; print(sys.path)" 
```

![img](https://pic3.zhimg.com/80/v2-9d759ee12e0280b74676a55c8cded46a_720w.png)

请使用以下命令，查看更多帮助信息：

```vim
:help python-dynamic
:help 'pythonhome'
:help 'pythonthreehome'
```

## 设置编译器

使用以下命令，设置'makeprg'选项为python3命令：

```vim
:set makeprg=python3\ %
```

通过在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)文件中增加以下[自动命令](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-49-01-autocmd.html)，可以为Python源码文件设置编译快捷键：

```vim
augroup make_python
	au!
	au FileType python set makeprg=python3\ %
	au FileType python map <buffer> <leader><space> :w<cr>:make<cr>
augroup end
```

## 编译Python代码

使用以下命令，将根据'makeprg'选项编译并执行Python文件：

```vim
:make
```

如果编译出现错误，将在[QuickFix](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html)中显示错误列表，并自动跳转到第一个错误处：

![img](https://pic2.zhimg.com/80/v2-756216bca40412040d2053c489824bc9_720w.jpg)

启用以下内置的编译器，再执行:make编译命令，报错信息将被整合为一行：

```vim
:compiler pyunit
```

![img](https://pic3.zhimg.com/80/v2-0d4fb6cedf487722e2f95f6c8c7d17ea_720w.jpg)

如果希望在编译时保持当前光标位置不变，那么可以使用以下命令：

```vim
:make!
```

使用`:cw`命令，将打开quickfix窗口。使用`:cp`命令，跳转到上一个错误；使用`:cn`命令，跳转到下一个错误。关于QuickFix操作的更多信息，请参阅[QuickFix](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html)章节。

在修复错误并成功编译之后，将显示命令输出：

![img](https://pic2.zhimg.com/80/v2-13f2af577c9b336e0ffec6997854d02d_720w.png)

使用以下命令，将解释执行当前文件：

```vim
:!python3 %
```

如果执行不带任何参数的python3命令，那么将进入交换模式的python shell，您可以在其中直接执行python命令：

```vim
:!python3
```

![img](https://pic4.zhimg.com/80/v2-63ebbc8013d3ef014f797ebb27c81d1b_720w.jpg)

使用以下命令，可以退出交换模式的python shell：

```bash
import sys; sys.exit()
```

您也可以直接使用Vim内置的`:python3`命令来执行代码：

```vim
:py3 print('hello world')
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-QuickFix-opt.html)>

发布于 2020-05-11