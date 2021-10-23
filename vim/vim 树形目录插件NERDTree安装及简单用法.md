# [vim 树形目录插件NERDTree安装及简单用法](https://www.cnblogs.com/wangkongming/p/4050833.html)



1，安装NERDTree插件

　　先下载，官网：http://www.vim.org/scripts/script.php?script_id=1658

　　![img](https://images0.cnblogs.com/blog/424368/201410/252125047158225.gif)

　　解压缩之后，把 plugin/NERD_tree.vim 和doc/NERD_tree.txt分别拷贝到~/.vim/plugin 和 ~/.vim/doc 目录。

　　如果.vim下面没有这些目录，就手动创建。

　　或者：

```
/home/wangkongming/下载/nerdtree
cp -r doc/ ~/.vim/
cp -r doc/ ~/.vim/
```

 

2，使用

　　1、在linux命令行界面，用vim打开一个文件。

　　2、输入  :NERDTree ，回车

　　3、进入当前目录的树形界面，通过小键盘上下键，能移动选中的目录或文件

　　4、ctr+w+h  光标focus左侧树形目录，ctrl+w+l 光标focus右侧文件显示窗口。多次摁 ctrl+w，光标自动在左右侧窗口切换

　　5、输入:q回车，关闭光标所在窗口

 

NERDTree快捷键

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
o 打开关闭文件或者目录
t 在标签页中打开
T 在后台标签页中打开
! 执行此文件
p 到上层目录
P 到根目录
K 到第一个节点
J 到最后一个节点
u 打开上层目录
m 显示文件系统菜单（添加、删除、移动操作）
? 帮助
q 关闭
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

附件是我电脑上面的vimrc里面的配置

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin
set nobackup
set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
    "显示行号
     set nu!
     colorscheme desert 
     syntax enable 
     syntax on
     
    set encoding=utf-8
    set fileencodings=utf-8,chinese,latin-1
    if has("win32")
    set fileencoding=chinese
    else
    set fileencoding=utf-8
    endif
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    "解决consle输出乱码
    language messages zh_CN.utf-8
"NERDTree快捷键
nmap <F2> :NERDTree  <CR>
" NERDTree.vim
let g:NERDTreeWinPos="left"
let g:NERDTreeWinSize=25
let g:NERDTreeShowLineNumbers=1
let g:neocomplcache_enable_at_startup = 1 

"默认最大化窗口打开
au GUIEnter * simalt ~x 
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)