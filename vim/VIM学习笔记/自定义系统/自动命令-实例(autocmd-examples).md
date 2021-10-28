以下实例，将为您使用自动命令提高编辑效率提供灵感。关于自动命令的创建和管理，请参阅[自动命令(autocmd)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-49-01-autocmd.html)章节。

例如以下自动命令，将在离开Vim编辑器时，自动保存文件：

```vim
autocmd FocusLost * :wa
```

## 根据文件类型执行自动命令

可以根据文件类型，执行特定命令。例如以下自动命令，将删除php文件行尾的空格：

```vim
autocmd BufEnter *.php :%s/[ \t\r]\+$//e
```

可以根据文件类型，载入相关插件：

```vim
autocmd Filetype html,xml,xsl source $VIM/vimfile/plugin/closetag.vim
```

可以根据文件类型，设置[键盘映射](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-51-KeyMapping.html)：

```vim
autocmd bufenter *.tex map <F1> :!latex %<CR>
```

可以根据文件类型，设置不同的选项：

```vim
autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
```

## 自动创建目录

定义以下自动命令，将在保存文件时，检查所指定的目录是否存在：

```vim
augroup vimrc-auto-mkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir)
          \   && (a:force
          \       || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END
```

如果使用`:w`命令保存文件时，引用了不存在的目录，那么将显示以下询问信息：

```
'XXXXX' does not exist. Create? [y/N]
```

你可以输入“y”，以自动创建目录并保存文件。

如果使用`:w!`命令保存文件时，引用了不存在的目录，那么将不会显示询问信息，而直接创建目录并保存文件。

## 自动应用配置文件

在保存[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件时，将自动重载并生效变更之后设置，而免去了关闭并重新打开Vim的手工操作：

```vim
augroup Reload_Vimrc        " Group name.  Always use a unique name!
    autocmd!                " Clear any preexisting autocommands from this group
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
augroup END
```

## 自动更新时间戳

利用以下自动命令，将在保存文件时，自动更新文件中的时间戳信息。首先将查找以“This file last updated:”开头的行，然后将“:”之后的时间替换为当前时间。

```
This file last updated: 12/23/2019 4:05:10 PM
function! UpdateTimestamp ()
  '[,']s/^This file last updated: \zs.*/\= strftime("%c") /
endfunction

augroup TimeStamping
  autocmd!
  autocmd BufWritePre,FileWritePre,FileAppendPre * :call UpdateTimestamp()
augroup END
```



发布于 2019-12-23