# 静默执行命令(silent)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

8 人赞同了该文章

通常在使用`!`[运行外部Shell命令](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-71-Shell.html)时，将显示提示信息“Press ENTER or type command to continue”，需要用户点击回车键才可以返回常规模式。

![img](https://pic2.zhimg.com/80/v2-a42da3d4704ac438c0552682b58f0e2d_720w.jpg)

## 使用silent静默执行命令

如果不希望显示提示信息，那么可以使用`:silent`命令：

```vim
:silent !echo 'Hello World'
```

如果需要清除命令本身及其输出信息，那么可以使用Ctrl-L快捷键或`:redraw!`命令来重画屏幕。

您可以[自定义命令](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-94-ScriptUDC.html)，来合并以上两步操作：

```vim
:command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'
```

使用以下自定义命令，将首先执行外部命令，然后重画屏幕：

```vim
:Silent echo 'Hello World'
```

通过结合`:execute`命令，可以生成并执行较复杂的命令：

```vim
:silent exec "!command"
```

定义以下快捷键，在Linux下静默执行命令。比如使用[eSpeak](https://link.zhihu.com/?target=http%3A//espeak.sourceforge.net/)将文字转换为语音：

```vim
:nnoremap <leader>es :silent exec '!espeak "hello world" &'<CR>
```

定义以下快捷键，在Windows下使用默认程序打开当前文件。比如使用默认浏览器，打开当前编辑的HTML文档：

```vim
:nmap <Leader>x :silent ! start "1" "%:p"<CR>
```

## 后台执行命令

使用以下命令，可以利用Shell后台执行命令和重定向的能力：

```vim
:silent exec "!(ping www.vim.org >ping.out >2&1) &"
```

- `>ping.out`，即`1>ping.out`，表示将命令的标准输出（stdout）重定向到名为“ping.out”的文件；因为默认值为1，所以可以省略；
- `>2&1`，表示将“2”代表的标准错误（stderr）也重定向至“1”代表的标准输出（stdout）；即标准输出和标准错误都输出至名为“ping.out”的文件；
- `&`，表示在后台执行命令。

如果不希望外部命令输出任何信息，那么可以将标准输出指向空设备文件“/dev/null”：

```vim
:silent exec "!(ping www.vim.org >/dev/null >2&1) &"
```

也可以静默执行外部命令，并在新建[标签页](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-15-Tabs.html)（Tab）内显示命令输出：

```vim
:silent exec "!(echo 'Hello World') > test.txt" | :tabedit test.txt
```

如果希望在[分割窗口](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-14-MultiWindows.html)内显示命令输出，那么可以使用:split命令：

```vim
:silent exec "!(echo 'Hello World') > test.txt" | :sp test.txt
```

## 后台打开应用窗口

使用以下命令，将打开与当前文件同名的PDF文档。由于[Zathura](https://link.zhihu.com/?target=https%3A//pwmt.org/projects/zathura/)窗口在前台显示，所以无法在Vim窗口中继续进行编辑；关闭zathura窗口之后，也需要在Vim中点击回车键以返回常规模式：

```vim
:!zathura %:r.pdf
```

![img](https://pic1.zhimg.com/80/v2-8b7a79a7b54dec7e81f5e43100956894_720w.jpg)

使用以下命令，将打开与当前文件同名的PDF文档。由于zathura窗口在前台显示，所以无法在Vim窗口中继续进行编辑；关闭zathura窗口之后，*不需要*在Vim中点击回车键即可返回常规模式：

```vim
:silent !zathura %:r.pdf
```

使用以下命令，将在后台打开与当前文件同名的PDF文档。由于zathura窗口在后台显示，所以*无需*关闭zathura窗口，也*无需*点击回车键，即可以在Vim窗口中继续进行编辑:

```vim
:silent exec '!zathura '.expand("%:r").'.pdf &'
```

## 实例：静默压缩文件

使用以下命令，可以使用[Zip](https://link.zhihu.com/?target=http%3A//infozip.sourceforge.net/Zip.html)压缩当前文件：

```vim
:!zip test.zip %:p
```

屏幕将显示以下信息，并等待用户按回车键以返回常规模式：

![img](https://pic2.zhimg.com/80/v2-e5d70c5669f9d17e238b8496f45133dd_720w.jpg)

使用以下命令，则屏幕不会显示任何信息，并且自动返回常规模式：

```vim
:silent !zip test.zip %:p
```

使用以下命令，可以批量压缩所有打开的文件：

```vim
:silent bufdo !zip test.zip %:p
```

## 实例：静默载入视图

如果希望记忆光标位置和手动[折叠](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-63-Fold.html)（Fold），以便在重新打开文件时恢复到之前的编辑状态。那么可以在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中，增加以下[自动命令](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-49-01-autocmd.html)：

```vim
set viewdir=$HOME/vimfiles/views/
autocmd BufWinLeave * mkview
autocmd BufWinEnter * silent loadview
```

## 使用system()函数静默执行命令

通过调用system()函数，也可静默执行命令：

```vim
:call system('espeak "hello world" &')
```

函数`system()`和`!`命令都可以调用外部命令，但system()函数不会切到shell终端，而是仍停留在vim界面。所调用外部命令的输出将会被system()函数捕获，可以将其保存在VimL变量中以供后续使用。

使用以下命令，可以查看更多帮助信息：

```vim
:help :silent
:help system()
```

关于本文中使用的第三方工具，请参阅以下网址：

- [eSpeak](https://link.zhihu.com/?target=http%3A//espeak.sourceforge.net/), text to speech
- [Zathura](https://link.zhihu.com/?target=https%3A//pwmt.org/projects/zathura/), document viewer
- [Zip](https://link.zhihu.com/?target=http%3A//infozip.sourceforge.net/Zip.html), compression and file packaging/archive utility

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-71-Shell.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-09-03-sort.html)>

编辑于 2020-11-13