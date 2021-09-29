# 超级强大的vim配置（vimplus）

2018-03-13阅读 19.6K0

最近在重新配置Vim，也在GitHub上找了三个star和fork数目很高的方案，在这里分享给大家：

- https://github.com/amix/vimrc - star 3,482 ; Fork 1,203
- https://github.com/humiaozuzu/dot-vimrc - star 781 ; Fork 304
- https://github.com/spf13/spf13-vim - star 5,287 ; Fork 1,593

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/mrka7i096h.png?imageView2/2/w/1620)

#  前言

 vim和emacs是linux环境下的文本编辑利器，关于vim和emacs谁更优秀的话题从来没有断过，我在这里就不再评判了，vim是linux下的默认编辑器，学好了vim将会一生受用，我之前学vim是在网上找的一些资料，读博客之类的，使用了几年vim始终感觉没有什么大的进步，后来在vim官网看到vim书籍推荐，其中一本就是《vim实用技巧》，后来果断在京东上买了一本，除了宏相关的没怎么看以外，其他的都看了，加上自己的实际操作，感觉vim技术又上了一个层次，《vim实用技巧》是教会vimer怎么使用vim，使用vim写代码时，给vim装上一些插件，将会如虎添翼，后来我在网上找一些插件来安装，或者在github上搜索别人的vimrc，看别人装了什么插件，自己选择性的安装了一些，使用一段时间后感觉使用vim编辑代码就是一件非常愉快的事情，再加上我最近买的忍者二代机械键盘那简直写代码很带感啊，我最开始自己家的电脑上给vim装了很多插件，后来在公司又要重新搭建vim开发环境，感觉有点麻烦，后来又想有没有什么一键安装、部署之类的小程序，就可以傻瓜式的把开发环境给搭建起来不是很爽吗，[vimplus](https://github.com/chxuan/vimplus)就运运而生了，如果喜欢的朋友请不要吝啬，给个star，废话不多说，直接上安装步骤(个人博客也发表了[《超级强大的vim配置(vimplus)》](http://chengxuan.me/2016/10/20/超级强大的vim配置-vimplus/))。

#  vimplus

 vimplus是vim的超级配置安装程序 

 github地址：https://github.com/chxuan/vimplus.git，欢迎star和fork。

 接触vim到现在也有几年了，但是之前用vim都是在网上找别人配置好了的vim，但是别人配置的始终都不能够满足自己的需求（自己需要有强大的C/C++代码提示补全功能、头文件/源文件切换、静态代码分析等功能），所以最近自己有时间，自己归纳了一些vim的插件，然后做成一键安装程序，供有相同需求的vimer们参考。

##  安装配置(Ubuntu、Centos)

```javascript
git clone https://github.com/chxuan/vimplus.git
cd ./vimplus
sudo ./install.sh
```

 现在vimplus支持ubuntu14.04之后的所有ubuntu 64位系列以及centos7 64位，运行`install.sh`脚本，你就可以一边喝咖啡，一遍看着屏幕刷刷刷的打印就安装部署好了开发环境了，整个过程大约持续40分钟，其中下载编译ycm耗费了大半时间，我有下载好了的[YouCompleteMe.tar.gz](http://pan.baidu.com/s/1kVdgsRl)，省得在github上去下载，很慢的，你懂的，若想要手动安装ycm，需要修改`vimplus`目录下的`.vimrc`文件。 

```javascript
Plugin 'Valloric/MatchTagAlways'
#Plugin 'Valloric/YouCompleteMe'
Plugin 'docunext/closetag.vim'
```

 将ycm插件那行注释掉，不然还会再去下载ycm，ycm可以最后等vimplus执行完成后再安装~~，接下来需要手动编译ycm。

```javascript
cd ~
mv YouCompleteMe.tar.gz ~/.vim/bundle/
cd ~/.vim/bundle/
tar -xvf YouCompleteMe.tar.gz
cd YouCompleteMe
./install.py --clang-completer
```

 vimplus将自动安装一些软件，比如说。

- vim
- g++
- ctags
- cmake
- python2
- python3

 安装的插件我也部分列出来。

- [Vundle](https://github.com/VundleVim/Vundle.vim)
- [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
- [NerdTree](https://github.com/scrooloose/nerdtree)
- [nerdcommenter](https://github.com/scrooloose/nerdcommenter)
- [Airline](https://github.com/vim-airline/vim-airline)
- [auto-pairs](https://github.com/jiangmiao/auto-pairs)
- [DoxygenToolkit](https://github.com/vim-scripts/DoxygenToolkit.vim)
- [ctrlp](https://github.com/ctrlpvim/ctrlp.vim)
- [tagbar](https://github.com/majutsushi/tagbar)
- [vim-devicons](https://github.com/ryanoasis/vim-devicons)
- [vim-surround](https://github.com/tpope/vim-surround)
- [vim-commentary](https://github.com/tpope/vim-commentary)
- [vim-repeat](https://github.com/tpope/vim-repeat)
- [vim-endwise](https://github.com/tpope/vim-endwise)
- [tabular](https://github.com/godlygeek/tabular)
- [vim-dirdiff](https://github.com/will133/vim-dirdiff)
- [vim-coloresque](https://github.com/gko/vim-coloresque)
- [incsearch.vim](https://github.com/haya14busa/incsearch.vim)
- [vim-startify](https://github.com/mhinz/vim-startify)
- [change-colorscheme](https://github.com/chxuan/change-colorscheme)
- etc...

##  配置YouCompleteMe

 到这一步，安装已经完成，你会发现`~`目录有两个文件，一个是vim的配置文件`.vimrc`，一个是YouCompleteMe的配置文件`[.ycm_extra_conf.py][25]`，一般来说建立一个main.cpp来写C、C++程序来说是没有问题的，都会有语法补全，当你需要写一些项目并涉及到第三方库时，就需要更改`[.ycm_extra_conf.py][26]`了，具体步骤如下。

1. 将.ycm_extra_conf.py拷贝的项目的根目录。
2. 更改.ycm_extra_conf.py里面的`flags`变量，添加三方库路径和工程子目录路径。

##  使用vim-devicons

 桌面版linux使用[vim-devicons](https://github.com/ryanoasis/vim-devicons)插件会出现乱码，需要设置终端字体为`Droid  Sans Mono for Powerline Nerd Font Complete`，使用xshell等工具连接服务器linux的用户就没有必要使用vim-devicons了，可以在插件目录将vim-devicons目录删除，不然会导致`NerdTree`的缩进有问题。

##  快捷键

 vim的插件需要设置好了快捷键才会发挥它的威力，有些插件的快捷键可以查看各自官网，有些快捷键我自己改过的，下面罗列部分插件的快捷键。

- 显示目录树 ``
- 显示函数、变量、宏定义等 ``
- 显示静态代码分析结果 ``
- .h .cpp 文件快速切换 ``
- 转到申明 `<,  + u>`
- 转到定义 `<,  + i>`
- 打开包含文件 `<,  + o>`
- Buffer切换 ``
- 光标位置切换 ``
- 模糊搜索文件 ``
- Surround ``
- 注释 ``
- DirDiff `:DirDiff   `
- 重复 `.`
- 改变主题 ``

 **下面这幅图是借用**[Valloric/YouCompleteMe](https://github.com/Valloric/YouCompleteMe)来展示强大的C++补全功能 

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/kfe0pxlezp.gif)

###  文件搜索

 ctrlp提供文件搜索，支持模糊查询。

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/kyy8rc4wca.png?imageView2/2/w/1620)

###  vim-airline

 vim-airline提供漂亮的状态栏支持。

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/9tlc9xum2l.gif)

###  vim-surround

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/iiaf6hif2z.gif)

###  vim-commentary

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/1vp3xvxhas.gif)

###  auto-pairs

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/pa82l275gb.gif)

###  incsearch.vim

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/dkv54ouzxz.gif)

###  vim-devicons

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/zzjc9u6nqd.png?imageView2/2/w/1620)

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/kv2ig0yokd.png?imageView2/2/w/1620)

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/6d9h4m7x7u.png?imageView2/2/w/1620)

###  vim-coloresque

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/0cvfvpavlt.png?imageView2/2/w/1620)

###  vim-dirdiff

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/bjl3p6xix7.png?imageView2/2/w/1620)

###  vim-startify

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/ld4iiyndmm.png?imageView2/2/w/1620)

###  Change the colorscheme

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/2vr61dk45x.gif)

##  安装完成后

 运行setup.sh脚本程序一键安装完成后，HOME目录将会存在[.ycm_extra_conf.py](https://raw.githubusercontent.com/chxuan/vimplus/master/.ycm_extra_conf.py)，该文件就是YCM实现C++等语言语法补全功能的配置文件，一般我会在HOME目录放一个，然后每一个项目拷贝一个[.ycm_extra_conf.py](https://raw.githubusercontent.com/chxuan/vimplus/master/.ycm_extra_conf.py)，更改[.ycm_extra_conf.py](https://raw.githubusercontent.com/chxuan/vimplus/master/.ycm_extra_conf.py)文件里面的flags  变量的值即可实现相关include文件的语法补全功能。

##  注意事项

 1.如果网络条件不好可能安装失败，基本上是Valloric/YouCompleteMe安装失败，安装失败后需要将~/.vim/bundle文件夹下的YouCompleteMe目录删除，然后重新执行setup.sh即可， 重新安装时，程序将自动安装安装失败的插件。

 2.在ubuntu16.04LTS下安装可能会失败(Valloric/YouCompleteMe安装失败)，因为vim默认支持python3进行插件编译，安装失败后，手动进入~/.vim/bundle/YouCompleteMe，然后运行python3 ./install.py --clang-completer即可。

# 强大的vim配置文件，让编程更随意

花了很长时间整理的，感觉用起来很方便，共享一下。 

我的vim配置主要有以下优点： 

1.按F5可以直接编译并执行C、C++、java代码以及执行shell脚本，按“F8”可进行C、C++代码的调试 2.自动插入文件头 ，新建C、C++源文件时自动插入表头：包括文件名、作者、联系方式、建立时间等，读者可根据需求自行更改 3.映射“Ctrl + A”为全选并复制快捷键，方便复制代码 4.按“F2”可以直接消除代码中的空行 5.“F3”可列出当前目录文件，打开树状文件目录 6. 支持鼠标选择、方向键移动 7. 代码高亮，自动缩进，显示行号，显示状态行 8.按“Ctrl + P”可自动补全 9.[]、{}、()、""、' '等都自动补全 10.其他功能读者可以研究以下文件 

vim本来就是很强大，很方便的编辑器，加上我的代码后肯定会如虎添翼，或许读者使用其他编程语言， 可以根据自己的需要进行修改，配置文件里面已经加上注释。  读者感兴趣的话直接复制下面的代码到文本文件，然后把文件改名为“ .vimrc” (不要忘记前面的“.”)，然后把文件放到用户文件夹的根目录下面即可。重新打开vim即可看到效果。 

 为方便管理，源码托管到了github，后期增加了好多新功能，

 具体详见：https://github.com/ma6174/vim

 这是在github上的vim配置的截图：

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/jdtutuo1r2.png?imageView2/2/w/1620)

 下面是精简的，没有插件的vim配置文件，保存到自己的.vimrc文件就能使用。 

```javascript
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set shortmess=atI   " 启动的时候不显示那个援助乌干达儿童的提示  
"winpos 5 5          " 设定窗口位置  
"set lines=40 columns=155    " 设定窗口大小  
"set nu              " 显示行号  
set go=             " 不要图形按钮  
"color asmanian2     " 设置背景主题  
set guifont=Courier_New:h10:cANSI   " 设置字体  
"syntax on           " 语法高亮  
autocmd InsertLeave * se nocul  " 用浅色高亮当前行  
autocmd InsertEnter * se cul    " 用浅色高亮当前行  
"set ruler           " 显示标尺  
set showcmd         " 输入的命令显示出来，看的清楚些  
"set cmdheight=1     " 命令行（在状态行下）的高度，设置为1  
"set whichwrap+=<,>,h,l   " 允许backspace和光标键跨越行边界(不建议)  
"set scrolloff=3     " 光标移动到buffer的顶部和底部时保持3行距离  
set novisualbell    " 不要闪烁(不明白)  
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set laststatus=1    " 启动显示状态行(1),总是显示状态行(2)  
set foldenable      " 允许折叠  
set foldmethod=manual   " 手动折叠  
"set background=dark "背景使用黑色 
set nocompatible  "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限  

" 显示中文帮助
if version >= 603
    set helplang=cn
    set encoding=utf-8
endif

" 设置配色方案
"colorscheme murphy

"字体 
"if (has("gui_running")) 
"   set guifont=Bitstream\ Vera\ Sans\ Mono\ 10 
"endif 

set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh' 
        call setline(1,"\#########################################################################") 
        call append(line("."), "\# File Name: ".expand("%")) 
        call append(line(".")+1, "\# Author: ma6174") 
        call append(line(".")+2, "\# mail: ma6174@163.com") 
        call append(line(".")+3, "\# Created Time: ".strftime("%c")) 
        call append(line(".")+4, "\#########################################################################") 
        call append(line(".")+5, "\#!/bin/bash") 
        call append(line(".")+6, "") 
    else 
        call setline(1, "/*************************************************************************") 
        call append(line("."), "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: ma6174") 
        call append(line(".")+2, "    > Mail: ma6174@163.com ") 
        call append(line(".")+3, "    > Created Time: ".strftime("%c")) 
        call append(line(".")+4, " ************************************************************************/") 
        call append(line(".")+5, "")
    endif

    if &filetype == 'cpp'
        call append(line(".")+6, "#include<iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    endif

    if &filetype == 'c'
        call append(line(".")+6, "#include<stdio.h>")
        call append(line(".")+7, "")
    endif

    "新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunc 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"键盘命令
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>w :w!<cr>
nmap <leader>f :find<cr>
" 映射全选+复制 ctrl+a
map <C-A> ggVGY
map! <C-A> <Esc>ggVGY
map <F12> gg=G
" 选中状态下 Ctrl+c 复制
vmap <C-c> "+y

"去空行  
nnoremap <F2> :g/^\s*$/d<CR> 

"比较文件  
nnoremap <C-F2> :vert diffsplit 

"新建标签  
map <M-F2> :tabnew<CR>  

"列出当前目录文件  
map <F3> :tabnew .<CR>  

"打开树状文件目录  
map <C-F3> \be  
"C，C++ 按F5编译运行
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!java %<"
    elseif &filetype == 'sh'
        :!./%
    endif
endfunc

"C,C++的调试
map <F8> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""实用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 设置当文件被改动时自动载入
set autoread
" quickfix模式
autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>

"代码补全 
set completeopt=preview,menu 

"允许插件  
filetype plugin on

"共享剪贴板  
set clipboard+=unnamed 

"从不备份  
set nobackup

"make 运行
:set makeprg=g++\ -Wall\ \ %

"自动保存

set autowrite
set ruler                   " 打开状态栏标尺
set cursorline              " 突出显示当前行
set magic                   " 设置魔术
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
"set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\

" 设置在状态行显示的信息
set foldcolumn=0
set foldmethod=indent 
set foldlevel=3 
set foldenable              " 开始折叠

" 不要使用vi的键盘模式，而是vim自己的
set nocompatible

" 语法高亮
set syntax=on

" 去掉输入错误的提示声音
set noeb

" 在处理未保存或只读文件的时候，弹出确认
set confirm

" 自动缩进
set autoindent
set cindent

" Tab键的宽度
set tabstop=4

" 统一缩进为4
set softtabstop=4
set shiftwidth=4

" 不要用空格代替制表符
set noexpandtab

" 在行和段开始处使用制表符
set smarttab

" 显示行号
set number

" 历史记录数
set history=1000

"禁止生成临时文件
set nobackup
set noswapfile

"搜索忽略大小写
set ignorecase

"搜索逐字符高亮
set hlsearch
set incsearch

"行内替换
set gdefault

"编码设置
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936

"语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn

" 我的状态行显示的内容（包括文件类型和解码）
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]

" 总是显示状态行
set laststatus=2

" 命令行（在状态行下）的高度，默认为1，这里是2
set cmdheight=2

" 侦测文件类型
filetype on

" 载入文件类型插件
filetype plugin on

" 为特定文件类型载入相关缩进文件
filetype indent on

" 保存全局变量
set viminfo+=!

" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-

" 字符间插入的像素行数目
set linespace=0

" 增强模式中的命令行自动完成操作
set wildmenu

" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2

" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l

" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
set mouse=a
set selection=exclusive
set selectmode=mouse,key

" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0

" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\

" 高亮显示匹配的括号
set showmatch

" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1

" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3

" 为C程序提供自动缩进
set smartindent

" 高亮显示普通txt文件（需要txt.vim脚本）
au BufRead,BufNewFile *  setfiletype txt

"自动补全
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {<CR>}<ESC>O
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction
filetype plugin indent on 

"打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags的设定  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Sort_Type = "name"    " 按照名称排序  
let Tlist_Use_Right_Window = 1  " 在右侧显示窗口  
let Tlist_Compart_Format = 1    " 压缩方式  
let Tlist_Exist_OnlyWindow = 1  " 如果只有一个buffer，kill窗口也kill掉buffer  
let Tlist_File_Fold_Auto_Close = 0  " 不要关闭其他文件的tags  
let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树  
autocmd FileType java set tags+=D:\tools\java\tags  
"autocmd FileType h,cpp,cc,c set tags+=D:\tools\cpp\tags  
"let Tlist_Show_One_File=1            "不同时显示多个文件的tag，只显示当前文件的

"设置tags  
set tags=tags  
"set autochdir 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"其他东东
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"默认打开Taglist 
let Tlist_Auto_Open=1 

"""""""""""""""""""""""""""""" 
" Tag list (ctags) 
"""""""""""""""""""""""""""""""" 
let Tlist_Ctags_Cmd = '/usr/bin/ctags' 
let Tlist_Show_One_File = 1 "不同时显示多个文件的tag，只显示当前文件的 
let Tlist_Exit_OnlyWindow = 1 "如果taglist窗口是最后一个窗口，则退出vim 
let Tlist_Use_Right_Window = 1 "在右侧窗口中显示taglist窗口

" minibufexpl插件的一般设置
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
```

# vim配置及插件安装管理（超级详细）

Linux下编程一直被诟病的一点是: 没有一个好用的IDE, 但是听说Linux牛人, 黑客之类的也都不用IDE. 但是对我等从Windows平台转移过来的Coder来说, 一个好用的IDE是何等的重要啊, 估计很多人就是卡在这个门槛上了, "工欲善其事, 必先利其器"嘛, 我想如果有一个很好用的IDE, 那些Linux牛人也会欢迎的. 这都是劳动人民的美好愿望罢了, 我今天教大家把gvim改装成一个简易IDE, 说它"简易"是界面上看起来"简易", 但功能绝对不比一个好的IDE差, 该有的功能都有, 不该有的功能也有, 你就自己没事偷着乐吧, 下面我开始介绍今天的工作了.

本文不会教你:

\1. 如何使用vim. 本文不会从零开始教你如何使用vim, 如果你是第一次接触vim, 

  建议你先看看其他的vim入门的教程, 或者在shell下输入命令: vimtutor, 

  这是一个简单的入门教程.

\2. 编程技巧.

\3. vim脚本的编写.

我的工作环境是: Fedora Core 5

gvim是自己编译的7.0, 如果你还没有安装gvim, 请看我的这篇文章[<在Redhat Linux 9中编译和配置gvim 7.0>](http://blog.csdn.net/wooin/archive/2006/12/30/1468797.aspx)

由于本人一直从事C语言工作, 所以下面这些例子都是在C语言程序中演示的, 其他语言的没有试过, 如果有朋友在别的语言下有问题, 可以跟我讨论一些, 我会尽量帮助你们的.

本文用的示范源码是vim7.1的源码, 可以在www.vim.org下载到源码包:vim-7.1.tar.bz2, 你也可以不用下载, 就用你自己程序的源码, 关系不大的. 我把源码解压在我的home目录下: ~/vim71

下面对文中的一些名字定义一下:

\1. 文中用到的一些用<>括起来的符号比如<C-T>, <C-S-A>, 之类的, 你可以用下面的命令看看解释:

```js
:help keycodes
```

\2. 文中说的一些路径, 比如:

 ~/.vim/plugin

 ~/.vim/doc

 ~/.vim/syntax

 如果你没有, 就自己创建.

\3. 文中说到的.vimrc文件都是指 ~/.vimrc

先给大家看张图片, 我是vim的界面, 解解馋先^_^

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/aql1fh054u.png?imageView2/2/w/1620)

(--- 图1 ---)

对照上图的图标, 我在本文中将教会你以下这些功能:

| 1    | 简洁明了的Buffer浏览和操作 |
| :--- | :------------------------- |
| 2    | 文件浏览器                 |
| 3    | tag浏览器                  |
| 4    | 高亮的书签                 |
| 5    | 更丰富的语法高亮           |
| 6    | 成员变量的下拉, 自动补全   |

中文帮助手册的安装

vim自带的帮助手册是英文的, 对平时编程的人来说没有多大阅读困难, 何况还有"星级译王"呢, 可偏偏有一帮人将其翻译成了中文, 可偏偏我又挡不住诱惑将它安装了, 唉.......又痛失一个学习英文的好机会, 下不为例.

大家看看我的中文帮助界面吧:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/oqlztvyxqt.png?imageView2/2/w/1620)

(--- 图2 ---)

安装方法:  

在下面的网站下载中文帮助的文件包:

$wget http://nchc.dl.sourceforge.net/sourceforge/vimcdoc/vimcdoc-1.5.0.tar.gz

解包后进入文件夹，使用以下命令安装：

$sudo ./vimcdoc.sh -i

启动vim，输入:help，看看帮助文档是否已经便成中文了？

一些注意事项：

1.vim中文文档不会覆盖原英文文档，安装后vim默认使用中文文档。若想使用英文文档，可在vim中执行以下命令：

   set helplang=en

同理，使用以下命令可重新使用中文文档：

   set helplang=cn

\2. 帮助文件的文本是utf-8编码的, 如果想用vim直接查看, 需要在~/.vimrc中设置:

  set encoding=utf-8



vim编程常用命令

建议先看看帮助手册中的下面章节, 其中有关tags文件的部分你可以先跳过, 在后面的章节中会讲到, 到时候你在回来看看, 就觉得很简单了:

```js
:help usr_29
:help usr_30
```

下面是我常用的一些命令, 放在这里供我备忘:

| %    | 跳转到配对的括号去                                    |
| :--- | :---------------------------------------------------- |
| [[   | 跳转到代码块的开头去(但要求代码块中'{'必须单独占一行) |
| gD   | 跳转到局部变量的定义处                                |
| ''   | 跳转到光标上次停靠的地方, 是两个', 而不是一个"        |
| mx   | 设置书签,x只能是a-z的26个字母                         |
| `x   | 跳转到书签处("`"是1左边的键)                          |
| >    | 增加缩进,"x>"表示增加以下x行的缩进                    |
| <    | 减少缩进,"x<"表示减少以下x行的缩进                    |



写程序没有语法高亮将是一件多么痛苦的事情啊, 幸亏vim的作者是个程序员(如果不是, 那可NB大了), 提供了语法高亮功能, 在上面的图片中大家也可以看到那些注释, 关键字, 字符串等, 都用不同颜色显示出来了, 要做到这样, 首先要在你的 ~/.vimrc 文件中增加下面几句话:



再重新启动vim, 并打开一个c程序文件, 是不是觉得眼前突然色彩缤纷了起来...

如果你不喜欢这个配色方案你可以在"编辑->配色方案"(gvim)中选择一个你满意的配色方案, 然后在~/.vimrc文件中增加下面这句:



desert是我喜欢的配色方案, 你可以改成你的. 如果菜单中的配色方案你还不满意(你也太花了吧), 没关系, 在 vim.org 上跟你一样的人很多, 他们做了各种各样的颜色主题, 你可以下载下来一个一个的试, 多地可以看到你眼花. 如果这样你还不满意(你还真是XXXX), 没关系, vim的作者早想到会有你这种人了, 你可以创建你自己的颜色主题, 把下面的这篇文档好好学习一些一下吧:



更炫的语法高亮:

你可能会发现很多东西没有高亮起来, 比如运算符号, 各种括号, 函数名, 自定义类型等, 但是看上面的图片, 我的运算符号和函数名都加亮了^_^, 想知道为什么吗? 哇哈哈哈哈.... 让我来教你吧 ...

主要的思路是新建一个语法文件, 在文件中定义你要高亮的东东, 想高亮什么就高亮什么, 用vim就是这么自信. 所谓的语法文件就是vim用来高亮各种源文件的一个脚本, vim靠这个脚本的描述来使文件中的不同文本显示不同的颜色, 比如C语言的语法文件放在类似于这样的一个路径中:

/usr/share/vim/vim64/syntax/c.vim

其他语言的语法文件也可以在这个路径中找到, 你的也许不在这个路径中, 不管它, 在你自己的HOME下新建一个语法文件, 新建一个空文件:

~/.vim/syntax/c.vim

在其中加入



再打开你的C文件看看, 是不是又明亮了许多. 还有一个压箱底的要告诉你, 如果你自己增加了一个类型或者结构之类的, 怎么让它也象"int", "void"这样高亮起来呢? 再在上面的文件~/.vim/syntax/c.vim中添加下面的东东:



这样你自己的类型My_Type_1, My_Type_2, My_Type_3就也可以向"int"一样高亮起来了, 这样的缺点是每增加一个类型, 就要手动在这里添加一下, 如果有人知道更简单的方法请一定一定要告诉我, 用下面的地址:

| Email    | : lazy.fox.wu#gmail.com      |
| :------- | :--------------------------- |
| Homepage | : http://blog.csdn.net/wooin |

在程序中跳来跳去: Ctags 的使用

哇, 这下可厉害了, Tag文件(标签文件)可是程序员的看家宝呀, 你可以不用它, 但你不能不知道它, 因为Linux内核源码都提供了"make tags"这个选项. 下面我们就来介绍Tag文件.

tags文件是由ctags程序产生的一个索引文件, ctags程序其是叫"Exuberant Ctags", 是Unix上面ctags程序的替代品, 并且比它功能强大, 是大多数Linux发行版上默认的ctags程序. 那么tags文件是做什么用的呢? 如果你在读程序时看了一个函数调用, 或者一个变量, 或者一个宏等等, 你想知道它们的定义在哪儿, 怎么办呢? 用grep? 那会搜出很多不相干的地方. 现在流行用是的<C-]>, 谁用谁知道呀, 当光标在某个函数或变量上时, 按下"Ctrl+]", 光标会自动跳转到其定义处, 够厉害吧, 你不用再羡慕Visual Studio的程序员了, 开始羡慕我吧~_~.

你现在先别急着去按<C-]>, 你按没用的, 要不要我干什么呀, 你现在要做的是查查你电脑里有没有ctags这个程序, 如果有, 是什么版本的, 如果是Ctags 5.5.4, 就象我一样, 你最好去装一个Ctags 5.6, 这个在后面的自动补全章节中会用到. 在这个网站: http://ctags.sourceforge.net, 下载一个类似 ctags-5.6.tar.gz 的文件下来(现在好像5.7版的也出来了, 不过我还没用过):

用下面的命令解压安装:



然后去你的源码目录, 如果你的源码是多层的目录, 就去最上层的目录, 在该目录下运行命令: ctags -R

我现在以 vim71 的源码目录做演示



此时在/home/wooin/vim71目录下会生成一个 tags 文件, 现在用vim打开 /home/wooin/vim71/src/main.c



再在vim中运行命令:



该命令将tags文件加入到vim中来, 你也可以将这句话放到~/.vimrc中去, 如果你经常在这个工程编程的话.

下面要开始真刀实枪的开干了, 如下图, 将光标放在setmouse()函数上

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/y43sqjplh5.png?imageView2/2/w/1620)

(--- 图3 ---)

此时按下<C-]>, 光标会自动跳到setmouse()函数的定义处, 见下图:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/7f8eq3y2am.png?imageView2/2/w/1620)

(--- 图4 ---)

如果此时你还想再跳回刚才的位置, 你还可以按<C-T>, 这样又跳回到setmouse()函数被调用的地方了, 变量, 结构, 宏, 等等, 都可以的, 赶快试试吧.....

此时在回头学习一下第3节中说的vim手册吧



不过还有一个小瑕疵, 你修改程序后, 比如增加了函数定义, 删除了变量定义, tags文件不能自动rebuild, 你必须手动再运行一下命令:



使tags文件更新一下, 不过让人感到欣慰的是vim不用重新启动, 正在编写的程序也不用退出, 马上就可以又正确使用<C-]>和<C-T>了. 如果有人知道更简单的方法请一定一定要告诉我, 用下面的地址:

| Email    | : lazy.fox.wu#gmail.com      |
| :------- | :--------------------------- |
| Homepage | : http://blog.csdn.net/wooin |

# VIM简单配置

在命令行下，输入命令：sudo vim /etc/vim/vimrc。会影响所有用户 在命令行下，输入命令：sudo ~/vimrc。只影响当前用户 

```javascript
syntax on          "语法高亮
set nu             "在左侧行号
set tabstop        "tab 长度设置为 4
set nobackup     "覆盖文件时不备份
set cursorline     "突出显示当前行
set ruler            "在右下角显示光标位置的状态行
set autoindent        "自动缩进
```



| 下载地址 | http://www.vim.org/scripts/script.php?script_id=273 |
| :------- | :-------------------------------------------------- |
| 版本     | 4.4                                                 |
| 安装     | 在 ~/.vim 目录下解压taglist_xx.zip                  |
| 手册     | :help taglist.txt                                   |

在Windows平台上用过Source Insight看程序的人肯定很熟悉代码窗口左边那个Symbol窗口, 那里面列出了当前文件中的所有宏, 全局变量, 函数名等, 在查看代码时用这个窗口总揽全局, 切换位置相当方便, 今天告诉你一个vim的插件: Taglist, 可以同样实现这个功能.

上一节已经告诉你ctags的用法了, ctags的基本原理是将程序程序中的一些关键字(比如:函数名, 变量名等)的名字, 位置等信息通过一个窗口告诉你, 如果你已经安装好taglist, 则可以用下面的命令看看taglist自带的帮助文件:



下面是我翻译的其中的第一段"Overview", 供大家现了解一下taglist, 翻译的不好, 请指教:

"Tab List"是一个用来浏览源代码的Vim插件, 这个插件可以让你高效地浏览各种不同语言编写的的源代码, "Tag List"有以下一些特点:

  \* 在Vim的一个垂直或水平的分割窗口中显示一个文件中定义的tags(函数, 类, 结构,

   变量, 等)

  \* 在GUI Vim中, 可以选择把tags显示在下拉菜单和弹出菜单中

  \* 当你在多个源文件/缓冲区间切换时, taglist窗口会自动进行相应地更新. 

   当你打开新文件时, 新文件中定义的tags会被添加到已经存在的文件列表中, 

   并且所有文件中定义的tags会以文件名来分组显示

  \* 当你在taglist窗口中选中一个tag名时, 源文件中的光标会自动跳转到该tag的定

   义处

  \* 自动高亮当前的tag名

  \* 按类型分组各tag, 并且将各组显示在一个可折叠的树形结构中

  \* 可以显示tag的原始类型和作用域

  \* 在taglist窗口可选择显示tag的原始类型替代tag名

  \* tag列表可以按照tag名, 或者时间进行排序

  \* 支持以下语言的源文件: Assembly, ASP, Awk, Beta, C,

   C++, C#, Cobol, Eiffel, Erlang, Fortran, HTML, Java, Javascript, Lisp,

   Lua, Make, Pascal, Perl, PHP, Python, Rexx, Ruby, Scheme, Shell, Slang,

   SML, Sql, TCL, Verilog, Vim and Yacc.

  \* 可以很简单的扩展支持新的语言. 对新语言支持的修改也很简单.

  \* 提供了一些函数, 可以用来在Vim的状态栏或者在窗口的标题栏显示当前的tag名

  \* taglist中的文件和tags的列表可以在被保存和在vim会话间加载

  \* 提供了一些用来取得tag名和原始类型的命令

  \* 在控制台vim和GUI vim中都可以使用

  \* 可以和winmanager插件一起使用. winmanager插件可以让你同时使用文件浏览器, 

   缓冲区浏览器和taglist插件, 就像一个IDE一样.

  \* 可以在Unix和MS-Windows系统中使用

首先请先在你的~/.vimrc文件中添加下面两句:



此时用vim打开一个c源文件试试:



进入vim后用下面的命令打开taglist窗口, 如图5:



![img](https://ask.qcloudimg.com/http-save/yehe-1164517/83xt8c8ah6.png?imageView2/2/w/1620)

(--- 图5 ---)

左边的窗口就是前面介绍的TagList窗口, 其中列出了main.c文件中的tag, 并且按照"typedef", "variable", "function"等进行了分类. 将光标移到VimMain上, 如图中左边红色的方框, 按下回车后, 源程序会自动跳转到VimMain的定义处, 如图中右边的红色方框. 这就是TagList最基本也是最常用的操作. 再教你一个常用的操作, 你在浏览TagList窗口时, 如果还不想让源码跳转, 但是想看看tag在源码中完整的表达, 可以将光标移到你想要看的tag上, 如图中上边黄色的方框, 然后按下空格键, 在下面的命令栏中, 如图下边黄色的方框, 会显示该tag在源码中完整的写法, 而不会跳转到源码处.

TagList插件我就介绍到这里, 其实它还有很多用法和设置, 我没法一一地教你了, 好在TagList有一份详细的帮助手册, 用下面的命令打开手册, 好好学习一下吧:



文件浏览器和窗口管理器 -- 插件: WinManager

| 下载地址 | http://www.vim.org/scripts/script.php?script_id=95 |
| :------- | :------------------------------------------------- |
| 版本     | 2.x                                                |
| 安装     | 在 ~/.vim 目录下解压winmanager.zip                 |
| 手册     | :help winmanager                                   |

在图1中大家可以看到在图标2标识的地方是一个文件浏览器, 里面列出了当前目录中的文件, 可以通过这个浏览器来浏览工程中的源文件, 是不是越来越像常见的IDE了, 当光标停在某个文件或文件夹的时候, 按下回车, 可以打开该文件或文件夹.

这个东东是怎么调出来的呢? 其实这个也是由插件实现的, 这个插件是netrw.vim, 只不过你不用下载和安装, 这个插件已经是标准的vim插件, 已经随vim一起安装进你的系统里了, 现在先简单演示一下, 进入"~/vim71"文件夹后运行vim, 然后在vim中运行命令:



你将在vim看到如下图所示的界面:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/grjwdv26in.png?imageView2/2/w/1620)

(--- 图6 ---)

在该界面上你可以用下面的一些命令来进行常用的目录和文件操作:

| <F1> | 显示帮助                                                     |
| :--- | :----------------------------------------------------------- |
| <cr> | 如果光标下是目录, 则进入该目录; 如果光标下文件, 则打开该文件 |
| -    | 返回上级目录                                                 |
| c    | 切换vim 当前工作目录正在浏览的目录                           |
| d    | 创建目录                                                     |
| D    | 删除目录或文件                                               |
| i    | 切换显示方式                                                 |
| R    | 文件或目录重命名                                             |
| s    | 选择排序方式                                                 |
| x    | 定制浏览方式, 使用你指定的程序打开该文件                     |

我这里不是教你怎么用netrw.vim插件, 而是要教你通过WinManager插件来将TagList窗口和netrw窗口整合起来, 就像图1中的图标2和3组成的那个效果

现在在你的~/.vimrc中增加下面两句



然后重启vim, 打开~/vim71/src/main.c, 在normal状态下输入"wm", 你将看到图7的样子:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/iei5r4vubm.png?imageView2/2/w/1620)

(--- 图7 ---)

其中左上边是netrw窗口, 左下边是TagList窗口, 当再次输入"wm"命令时这两个窗口又关闭了.

WinManager的功能主要就是我介绍的这些, 但是它还有其他一些高级功能, 还可以支持其他几个插件, 如果你觉得我介绍的还不够你用, 建议你把它的帮助手册好好研究一下, 用下面的命令可以调出帮助手册:



Cscope 的使用

这下更厉害了, 用Cscope自己的话说 - "你可以把它当做是超过频的ctags", 其功能和强大程度可见一斑吧, 关于它的介绍我就不详细说了, 如果你安装好了前文介绍的中文帮助手册, 用下面的命令看看介绍吧:



我在这里简单摘抄一点, 供还在犹豫的朋友看看:

Cscope 是一个交互式的屏幕下使用的工具，用来帮助你:

\* 无须在厚厚的程序清单中翻来翻去就可以认识一个 C 程序的工作原理。

\* 无须熟悉整个程序就可以知道清楚程序 bug 所要修改的代码位置。

\* 检查提议的改动 (如添加一个枚举值) 可能会产生的效果。

\* 验证所有的源文件都已经作了需要的修改；例如给某一个现存的函数添加一个参数。

\* 在所有相关的源文件中对一个全局变量改名。

\* 在所有相关的位置将一个常数改为一个预处理符号。

它被设计用来回答以下的问题:

\* 什么地方用到了这个符号？

\* 这是在什么地方定义的？

\* 这个变量在哪里被赋值？

\* 这个全局符号的定义在哪里？

\* 这个函数在源文件中的哪个地方？

\* 哪些函数调用了这个函数？

\* 这个函数调用了哪些函数？

\* 信息 "out of space" 从哪来？

\* 这个源文件在整个目录结构中处于什么位置？

\* 哪些文件包含这个头文件？

安装Cscope:

如果你的系统中有cscope命令, 则可以跳过这一小段, 如果没有, 就先跟着我一起安装一个吧.

在Cscope的主页: http://cscope.sourceforge.net 下载一个源码包, 解压后编译安装:



先在~/vimrc中增加一句:



这个是设定是否使用 quickfix 窗口来显示 cscope 结果, 用法在后面会说到。

跟Ctags一样, 要使用其功能必须先为你的代码生成一个cscope的[数据库](https://cloud.tencent.com/solution/database?from=10680), 在项目的根目录运行下面的命令:



进入vim后第一件事是要把刚才生成的cscope文件导入到vim中来, 用下面的命令:



上面这条命令很重要, 必须写全, 不能只写前半句:

:cs add /home/wooin/vim71/cscope.out

因为源码是多级目录的, 如果这样写, cscope是无法在子目录中的源码中工作的, 当然, 如果你的源码都在同一级目录中就无所谓了. 如果你要经常用cscope的话, 可以把上面那句加到~/.vimrc中去.

下面我们来操练一下, 查找函数vim_strsave()的定义, 用命令:



如下图:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/gy62nmnylt.png?imageView2/2/w/1620)

(--- 图8 ---)

按下回车后会自动跳转到vim_strsave()的定义处. 此时你肯定会说Ctags也可以做到这个呀, 那么下面说的这个Ctags就无法做到了, 我想查找vim_strsave()到底在那些地方被调用过了, 用命令:



按下回车后vim会自动跳转到第一个符合要求的地方, 并且在命令栏显示有多少符合要求的结果, 如图:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/kbmnjehbhs.png?imageView2/2/w/1620)

(--- 图9 ---)

如果自动跳转的位置你不满意, 想看其他的结果, 可以用下面的命令打开QuickFix窗口:



如图:

(--- 图10 ---)

这时你就可以慢慢挑选了^_^

cscope的主要功能是通过同的子命令"find"来实现的

"cscope find"的用法:

cs find c|d|e|f|g|i|s|t name

| 0 或 s | 查找本 C 符号(可以跳过注释) |
| :----- | :-------------------------- |
| 1 或 g | 查找本定义                  |
| 2 或 d | 查找本函数调用的函数        |
| 3 或 c | 查找调用本函数的函数        |
| 4 或 t | 查找本字符串                |
| 6 或 e | 查找本 egrep 模式           |
| 7 或 f | 查找本文件                  |
| 8 或 i | 查找包含本文件的文件        |

如果每次查找都要输入一长串命令的话还真是件讨人厌的事情, Cscope的帮助手册中推荐了一些快捷键的用法, 下面是其中一组, 也是我用的, 将下面的内容添加到~/.vimrc中, 并重启vim:



当光标停在某个你要查找的词上时, 按下<C-_>g, 就是查找该对象的定义, 其他的同理.

按这种组合键有一点技巧,按了<C-_>后要马上按下一个键,否则屏幕一闪就回到nomal状态了

<C-_>g的按法是先按"Ctrl+Shift+-", 然后很快再按"g"

很奇怪, 其中的这句:

nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

在我的vim中无法工作, 但是我改成:

nmap <C-_>i :cs find i <C-R>=expand("<cfile>")<CR><CR>

就可以正常工作了, 不知道是什么原因? 有哪位朋友知道请告诉我.

cscope的其他功能你可以通过帮助手册自己慢慢学习

reset : 重新初始化所有连接。

用法 : cs reset



QuickFix 窗口

在上一节的图10中大家可以看到在窗口下面有一个显示查询结果的窗口, 这个窗口中列出了查询命令的查询结果, 用户可以从这个窗口中选择每个结果进行查看, 这个窗口叫"QuickFix"窗口, 以前也是一个vim的插件来的, 只不过现在成了vim的标准插件, 不用你在去安装了, QuickFix窗口的主要作用就是上面看到的那个功能: 输出一些供选择的结果, 可以被很多命令调用, 更详细的介绍和使用方法请用下面的命令打开QuickFix的手册来学习吧:



这里我一个常用的例子来再介绍一种QuickFix窗口的使用方法. 这个例子是要模仿平时我们编程时, 当编译出错时, QuickFix会把出错的信息列出来, 供我们一条条地查看和修改. 首先还是用vim打开~/vim71/src/main.c, 事先最好先编译过vim71, 否则一会儿编译的时候有点慢, 或者你也可以自己写一个小的有错误的程序来跟着我做下面的步骤, 见下图:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/jsrqbnz1d9.png?imageView2/2/w/1620)

(--- 图11 ---)

我们修改一下main.c, 人为地造成几处错误, 在第1019行增加了一个baobao_wu的没有任何定义的字符串, 删除了第1020行最后的一个括号")", 然后用下面的命令进行编译:



显然编译会报很多错误, 当编译结束并退出到源码界面时, 刚才编译器报的错误都已经看不到了, 但是我们可以用QuickFix窗口再将错误信息找出来, 用下面的命令调出QuickFix窗口:



此时你就可以看如下图所示的QuickFix窗口了:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/fbox5g3nnp.png?imageView2/2/w/1620)

(--- 图12 ---)

在下面的QuickFix窗口中我们可以找到每一个编译错误, 同样你可以用鼠标点击每一条记录, 代码会马上自动跳转到错误处, 你还可以用下面的命令来跳转:



如果你经常使用这两个命令, 你还可以给他们设定快捷键, 比如在~/.vimrc中增加:



其还有其他的命令/插件也会用到QuickFix窗口, 但是用法基本上的都是类似的, 本文后面还会用到QuickFix窗口, 接着往下看吧.



快速浏览和操作Buffer -- 插件: MiniBufExplorer

| 下载地址 | http://www.vim.org/scripts/script.php?script_id=159         |
| :------- | :---------------------------------------------------------- |
| 版本     | 6.3.2                                                       |
| 安装     | 将下载的 minibufexpl.vim文件丢到 ~/.vim/plugin 文件夹中即可 |
| 手册     | 在minibufexpl.vim 文件的头部                                |

在编程的时候不可能永远只编辑一个文件, 你肯定会打开很多源文件进行编辑, 如果每个文件都打开一个vim进行编辑的话那操作起来将是多麻烦啊, 所以vim有buffer(缓冲区)的概念, 可以看vim的帮助:

:help buffer

vim自带的buffer管理工具只有:ls, :bnext, :bdelete 等的命令, 既不好用, 又不直观. 现在隆重向你推荐一款vim插件(plugin): MiniBufExplorer

使用方法:

重新启动vim, 当你只编辑一个buffer的时候MiniBufExplorer派不上用场, 当你打开第二个buffer的时候, MiniBufExplorer窗口就自动弹出来了, 见下图:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/ru4yngwhvt.png?imageView2/2/w/1620)

(--- 图13 ---)

上面那个狭长的窗口就是MiniBufExplorer窗口, 其中列出了当前所有已经打开的buffer, 当你把光标置于这个窗口时, 有下面几个快捷键可以用:

| <Tab>   | 向前循环切换到每个buffer名上 |
| :------ | :--------------------------- |
| <S-Tab> | 向后循环切换到每个buffer名上 |
| <Enter> | 在打开光标所在的buffer       |
| d       | 删除光标所在的buffer         |

以下的两个功能需要在~/.vimrc中增加:



| <C-Tab>   | 向前循环切换到每个buffer上,并在但前窗口打开 |
| :-------- | :------------------------------------------ |
| <C-S-Tab> | 向后循环切换到每个buffer上,并在但前窗口打开 |

如果在~/.vimrc中设置了下面这句:



则可以用<C-h,j,k,l>切换到上下左右的窗口中去,就像:

C-w,h j k l  向"左,下,上,右"切换窗口.

在~/.vimrc中设置:



是用<C-箭头键>切换到上下左右窗口中去



c/h文件间相互切换 -- 插件: A

| 下载地址 | http://www.vim.org/scripts/script.php?script_id=31 |
| :------- | :------------------------------------------------- |
| 版本     |                                                    |
| 安装     | 将a.vim 放到 ~/.vim/plugin 文件夹中                |
| 手册     | 无                                                 |

下面介绍它的用法:

作为一个C程序员, 日常Coding时在源文件与头文件间进行切换是再平常不过的事了, 直接用vim打开其源/头文件其实也不是什么麻烦事, 但是只用一个按键就切换过来了, 这是多么贴心的功能啊....

安装好a.vim后有下面的几个命令可以用了:

| :A   | 在新Buffer中切换到c/h文件   |
| :--- | :-------------------------- |
| :AS  | 横向分割窗口并打开c/h文件   |
| :AV  | 纵向分割窗口并打开c/h文件   |
| :AT  | 新建一个标签页并打开c/h文件 |

其他还有一些命令, 你可以在它的网页上看看, 我都没用过, 其实也都是大同小异, 找到自己最顺手的就行了.

我在~/.vimrc中增加了一句:



意思是按F12时在一个新的buffer中打开c/h文件, 这样在写程序的时候就可以不假思索地在c/h文件间进行切换, 减少了按键的次数, 思路也就更流畅了, 阿弥陀佛....



在工程中查找 -- 插件: Grep

| 下载地址 | http://www.vim.org/scripts/script.php?script_id=311 |
| :------- | :-------------------------------------------------- |
| 版本     | 1.8                                                 |
| 安装     | 把grep.vim 文件丢到 ~/.vim/plugin 文件夹就好了      |
| 手册     | 在grep.vim 文件头部                                 |

下面介绍它的用法:

vim有自己的查找功能, 但是跟shell中的grep比起来还是有些差距的, 有时Coding正火急火燎的时候, 真想按下F3, 对光标所在的词来个全工程范围的grep, 不用敲那些繁琐的命令, 现在福音来了, 跟我同样懒的人不在少数, 在grep.vim脚本的前部可以找到一些说明文档:

| :Grep       | 按照指定的规则在指定的文件中查找        |
| :---------- | :-------------------------------------- |
| :Rgrep      | 同上, 但是是递归的grep                  |
| :GrepBuffer | 在所有打开的缓冲区中查找                |
| :Bgrep      | 同上                                    |
| :GrepArgs   | 在vim的argument filenames (:args)中查找 |
| :Fgrep      | 运行fgrep                               |
| :Rfgrep     | 运行递归的fgrep                         |
| :Egrep      | 运行egrep                               |
| :Regrep     | 运行递归的egrep                         |
| :Agrep      | 运行agrep                               |
| :Ragrep     | 运行递归的agrep                         |

上面的命令是类似这样调用的:

| :Grep  [<grep_options>] [<search_pattern> [<file_name(s)>]]  |
| :----------------------------------------------------------- |
| :Rgrep [<grep_options>] [<search_pattern> [<file_name(s)>]]  |
| :Fgrep [<grep_options>] [<search_pattern> [<file_name(s)>]]  |
| :Rfgrep [<grep_options>] [<search_pattern> [<file_name(s)>]] |
| :Egrep [<grep_options>] [<search_pattern> [<file_name(s)>]]  |
| :Regrep [<grep_options>] [<search_pattern> [<file_name(s)>]] |
| :Agrep [<grep_options>] [<search_pattern> [<file_name(s)>]]  |
| :Ragrep [<grep_options>] [<search_pattern> [<file_name(s)>]] |
| :GrepBuffer [<grep_options>] [<search_pattern>]              |
| :Bgrep [<grep_options>] [<search_pattern>]                   |
| :GrepArgs [<grep_options>] [<search_pattern>]                |

但是我从来都不用敲上面那些命令的^_^, 因为我在~/.vimrc中增加了下面这句:



比如你想在/home/wooin/vim71/src/main.c中查找"FEAT_QUICKFIX", 则将光标移到"FEAT_QUICKFIX"上, 然后按下F3键, 如下图:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/c3cire9cpy.png?imageView2/2/w/1620)

(--- 图14 ---)

在最下面的命令行会显示:



此时你还可以编辑该行, grep支持正则表达式, 你想全词匹配的话可以改成:



然后按下回车:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/12eg1rp7xb.png?imageView2/2/w/1620)

(--- 图15 ---)

在最下面的命令行会显示:



是问你搜索范围, 默认是该目录下的所有文件, 此时你还可以编辑该行, 比如你只想搜索源码文件:



然后在按下回车, 会在弹出的QuickFix窗口中列出所有符合条件的搜索结果, 你可以在其中查找你想要的结果, 如下图:

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/4qpq992ls2.png?imageView2/2/w/1620)

(--- 图16 ---)

其实还有一些其他功能和设置, 但是我都没有用过, 这些功能再加上正则表达式, 已经够我用了, 其他的你可以在网页上看看它的文档, 如果有什么惊人发现记得跟我互通有无, 共同进步哦....



高亮的书签 -- 插件: VisualMark

| 下载地址 | http://www.vim.org/scripts/script.php?script_id=1026 |
| :------- | :--------------------------------------------------- |
| 版本     |                                                      |
| 安装     | 把visualmark.vim 文件丢到 ~/.vim/plugin 文件夹就好了 |
| 手册     | 无                                                   |

下面介绍它的用法:

vim也和其他编辑器一样有"书签"概念, 在vim中叫"Mark", 可以用下面的命令查看相关说明:



该"书签"有个很很大的缺点: 不可见.

我下面要介绍的Visual Mark插件跟vim中的"Mark"没有什么关系, 并不是使其可见, 而是自己本身就是"可见的书签", 接着往下看就明白了, 用作者的话说就是"类似UltraEdit中的书签".

另外, 网上也有使vim中的Mark可见的插件, 但是我试了一下, 好像没Visual Mark好用, 我就不介绍了.

按照上面的方法安装好Visual Mark后, 你什么也不用设置, 如果是gvim, 直接在代码上按下Ctrl+F2, 如果是vim, 用"mm", 怎么样, 发现光标所在的行变高亮了吧, 见下图:

(--- 图17 ---)

如果你设置了多个书签, 你可以用F2键正向在期间切换, 用Shift+F2反向在期间切换.

好了, 我Visual Mark介绍完了, 够简单吧^_^.

如果你嫌书签的颜色不好看, 你还可以自己定义, 不过是修改这个插件脚本的的源码, 在目录~/.vim/plugin/中找到并打开visualmark.vim, 找到下面这段代码:



安装 visualmark.vim 后，如果是在 Ubuntu 下做标记，会报一个“E197 不能设定语言为'en_US'"的错误，但是在 Windows 下却不会。在网上找了一下，发现修复方法。 只要将exec ":lan mes en_US" 修改为 exec ":lan POSIX" 即可，为了能够在两个系统中都能使用，于是修改了一下 visualmark.vim 源码，就是在 exec 外加了一个判断系统的语句。本来还想直接上传一份供大家下载使用，才发现 Iteye 居然只能上传图像.... 这里就提供具体修改方法： 使用文本编辑器打开 visualmark.vim 定位到 exec ":lan mes en_US" 修改为 if has("win32") || has("win95") || has("win64") || has("win16")   exec ":lan mes en_US" else   exec ":lan POSIX" endif 保存即可。 

 我还有几个不满意的地方: 1 这个书签不能自动保存, 关闭vim就没了. 2 切换书签时不能在不同文件间切换, 只能在同一个文件中切换 如果哪位朋友能解决这两个问题, 请一定要告诉寡人啊....还是用下面的地址: 

| Email    | : lazy.fox.wu#gmail.com      |
| :------- | :--------------------------- |
| Homepage | : http://blog.csdn.net/wooin |



自动补全

用过Microsoft Visual Studio的朋友一定知道代码补全功能, 输入一个对象名后再输入"."或者"->", 则其成员名都可以列出来, 使Coding流畅了许多, 实现很多懒人的梦想, 现在我要告诉你, 这不再是Microsoft Visual Studio的专利了, vim也可以做到! 下面由我来教你, 该功能要tags文件的支持, 并且是ctags 5.6版本, 可以看看前文介绍tags文件的章节.

我这里要介绍的功能叫"new-omni-completion(全能补全)", 你可以用下面的命令看看介绍:



你还需要在~/.vimrc文件中增加下面两句:



打开文件类型检测, 加了这句才可以用智能补全



关掉智能补全时的预览窗口

请确定你的Ctags 5.6已经安装好, 并且生成的tags文件已经可以用了, 那么我们就要抄家伙开搞了.

用vim打开源文件



设置tags文件



随便找一个有成员变量的对象, 比如"parmp", 进入Insert模式, 将光标放在"->"后面, 

然后按下"Ctrl+X Ctrl+O", 此时会弹出一个下列菜单, 显示所有匹配的标签, 如下图:

(--- 图18 ---)

此时有一些快捷键可以用:

| Ctrl+P | 向前切换成员                             |
| :----- | :--------------------------------------- |
| Ctrl+N | 向后切换成员                             |
| Ctrl+E | 表示退出下拉窗口, 并退回到原来录入的文字 |
| Ctrl+Y | 表示退出下拉窗口, 并接受当前选项         |

如果你增加了一些成员变量, 全能补全还不能马上将新成员补全, 需要你重新生成一下tags文件, 但是你不用重启vim, 只是重新生成一下tags文件就行了, 这时全能补全已经可以自动补全了, 还真够"全能"吧.

vim中的其他补全方式还有:

| Ctrl+X Ctrl+L | 整行补全                 |
| :------------ | :----------------------- |
| Ctrl+X Ctrl+N | 根据当前文件里关键字补全 |
| Ctrl+X Ctrl+K | 根据字典补全             |
| Ctrl+X Ctrl+T | 根据同义词字典补全       |
| Ctrl+X Ctrl+I | 根据头文件内关键字补全   |
| Ctrl+X Ctrl+] | 根据标签补全             |
| Ctrl+X Ctrl+F | 补全文件名               |
| Ctrl+X Ctrl+D | 补全宏定义               |
| Ctrl+X Ctrl+V | 补全vim命令              |
| Ctrl+X Ctrl+U | 用户自定义补全方式       |
| Ctrl+X Ctrl+S | 拼写建议                 |

加速你的补全 -- 插件: SuperTab使用

| 下载地址 | http://www.vim.org/scripts/script.php?script_id=1643 |
| :------- | :--------------------------------------------------- |
| 版本     | 0.43                                                 |
| 安装     | 把supertab.vim 文件丢到 ~/.vim/plugin 文件夹就好了   |
| 手册     | supertab.vim 文件头部, 和命令 ":SuperTabHelp"        |

在上面一节中你应该学会了自动补全代码的功能, 按下"Ctrl+X Ctrl+O"就搞定了, 如果你够懒的话肯定会说"这么麻烦啊, 居然要按四个键", 不必为此自责, 因为Gergely Kontra 和 Eric Van Dewoestine也跟你差不多, 只不过人家开发了supertab.vim这个插件, 可以永远懒下去了, 下面我来教你偷懒吧.

在你的~/.vimrc文件中加上这两句:



以后当你准备按"Ctrl+X Ctrl+O"的时候直接按<Tab>就好了, 够爽吧 ....

我稍微再介绍一下上面那两句配置信息:





问题:

但是现在我的<Tab>键不好用了, 我以前爱用<Tab>进行缩进, 如果前面有字符按下<Tab>键后就会进行补全, 而不是我想要的缩进功能, 不知道有没有快捷键可以暂时关闭和激活SuperTab键的功能. 如果哪位朋友知道, 请一定记得告诉我啊....还是用下面的地址:

| Email    | : lazy.fox.wu#gmail.com      |
| :------- | :--------------------------- |
| Homepage | : http://blog.csdn.net/wooin |





## 配置基本的展示形态

 首先, 我们建立目录存放我们的主题

```javascript
 mkdir -p  ~/.vim/colors
```

 这个目录就是给我们存放主题用的, 我们用什么主题呢? 这里我们采用molokai这个主题, 当然如果读者愿意用别的主题, 也是可以的, 下一个就行.

 http://www.vim.org/scripts/script.php?script_id=2340下载molokai主题,  拷贝到~/.vim/colors目录下, 创建.vimrc文件.

```javascript
touch ~/.vimrc
```

 将下面的内容拷贝到.vimrc中.

```javascript
set modelines=0

"设置更好的删除
set backspace=2

syntax on "语法高亮

"用浅色高亮当前行
autocmd InsertLeave * se nocul
autocmd InsertEnter * se cul

set smartindent "智能对齐

set autoindent "自动对齐

set confirm "在处理未保存或只读文件的时候，弹出确认框

set tabstop=4 "tab键的宽度
set softtabstop=4
set shiftwidth=4 "统一缩进为4
set expandtab "不要用空格替代制表符

set number "显示行号
set history=50  "历史纪录数
set hlsearch
set incsearch "搜素高亮,搜索逐渐高亮

set gdefault "行内替换
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1 "编码设置

colorscheme molokai

set guifont=Menlo:h16:cANSI "设置字体
set langmenu=zn_CN.UTF-8
set helplang=cn  "语言设置

set ruler "在编辑过程中，在右下角显示光标位置的状态行

set laststatus=1  "总是显示状态行

set showcmd "在状态行显示目前所执行的命令，未完成的指令片段也会显示出来

set scrolloff=3 "光标移动到buffer的顶部和底部时保持3行的距离
set showmatch "高亮显示对应的括号
set matchtime=5 "对应括号高亮时间(单位是十分之一秒)

set autowrite "在切换buffer时自动保存当前文件

set wildmenu  "增强模式中的命令行自动完成操作

set linespace=2 "字符间插入的像素行数目
set whichwrap=b,s,<,>,[,] "开启normal 或visual模式下的backspace键空格键，左右方向键,insert或replace模式下的左方向键，右方向键的跳行功能

filetype plugin indent on "分为三部分命令:file on,file plugin on,file indent on 分别是自动识别文件类型, 用用文件类型脚本,使用缩进定义文件

set foldenable  "允许折叠
set cursorline "突出显示当前行
set magic  "设置魔术？神马东东
set ignorecase "搜索忽略大小写
filetype on "打开文件类型检测功能
set background=dark
set t_Co=256   "256色
set mouse=a  "允许鼠标
```

 这时候, 我们可以发现我们的vim变成了: 

##  插件安装

 这一部分比上面的样式重要的多, 这里主要是讲插件的使用, 而这些插件大大增加了vim的性能.

###  1.vbundle 管理插件的插件

 我们的插件如果一个一个安装的话, 这可能会搞死你, 因此我们希望有一个能够自动安装和管理插件的插件. 这就是我们要说的vbundle, 可参考https://github.com/VundleVim/Vundle.vim.

 安装非常简单:

```javascript
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

 然后我们来看看配置, 也非常简单.

```javascript
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
```

 在vimrc中把上面的代贴在最前面即可.

 我们需要添加插件的话, 只要在begin和end之间加入即可.

###  2. nerdtree插件

 在begin和end之间加入

```javascript
Plugin 'scrooloose/nerdtree'
```

 输入命令

```javascript
:PluginInstall
```

 配置nerdtree:

```javascript
let NERDTreeQuitOnOpen=1 "打开文件时关闭树
let NERDTreeShowBookmarks=1 "显示书签
```

 配置快捷键:

```javascript
let mapleader = ","
map <leader>ne :NERDTreeToggle<CR>
map <leader>tl :TlistToggle<cr>
nnoremap <leader>ma :set mouse=a<cr>
nnoremap <leader>mu :set mouse=<cr>
```

 保存vimrc,输入,ne, 我们看看: 

 似乎有那么点意思!

###  3. tagbar插件

 安装方式:

```javascript
 Plugin 'majutsushi/tagbar' 
```

 设置键:

```javascript
nmap <leader>tb :TagbarToggle<CR>
```

 似乎已经越来越接近我们想要的了.

###  4.autopair插件

 这个插件就是给括号自动配对的.

```javascript
Plugin 'jiangmiao/auto-pairs'
```

###  5.minibuffer 插件

 安装插件:

```javascript
 Plugin 'minibufexpl.vim'
```

 配置插件

```javascript
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
```

 配置快捷键:

```javascript
nmap <leader>mmbe :MiniBufExplorer<CR>
nmap <leader>mmbc :CMiniBufExplorer<CR>
nmap <leader>mmbu :UMiniBufExplorer<CR>
nmap <leader>mmbt :TMiniBufExplorer<CR>
```

 效果如下: 

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/klcvquhts5.png?imageView2/2/w/1620)

###  6. taglist插件

 功能类似于tagbar 安装:

```javascript
Plugin 'taglist.vim' 
```

 配置:

```javascript
let Tlist_Use_Right_Window=1 "taglist 显示在右侧 
let Tlist_Exit_OnlyWindow=1 "taglist 只剩下一个窗口时，自动关闭
let Tlist_File_Fold_Auto_Close=1
```

 快捷键: map tl :TlistToggle nnoremap ev :vsplit $MYVIMRC nnoremap sv :source $MYVIMRC

###  7. nerd comment插件

 这个插件是用来自动添加注释的插件.

 安装:

```javascript
Plugin 'scrooloose/nerdcommenter'
```

###  8. 代码折叠

 配置:

```javascript
"使用语法高亮定义代码折叠
set foldmethod=syntax
"打开文件是默认不折叠代码
set foldlevelstart=99
```

 zc 折叠 zC 对所在范围内所有嵌套的折叠点进行折叠 zo 展开折叠 zO 对所在范围内所有嵌套的折叠点展开 [z 到当前打开的折叠的开始处。]z 到当前打开的折叠的末尾处。 zj 向下移动。到达下一个折叠的开始处。关闭的折叠也被计入。 zk 向上移动到前一折叠的结束处。关闭的折叠也被计入。

###  9. markdown插件安装

 安装:

```javascript
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
```

 配置:

```javascript
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1
```

 效果: 

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/o5mlm9sbec.png?imageView2/2/w/1620)

###  10.youcompleteme插件

 YouCompleteMe:一个随键而全的、支持模糊搜索的、高速补全的插件。YCM 由 google 公司搜索项目组的软件工程师 Strahinja Val Markovic 所开发,YCM 后端调用 libclang(以获取AST,当然还有其他语言的语义分析库)、前端由 C++ 开发(以提升补全效 率)、外层由 python 封装(以成为 vim 插件),这是至今为止最强大也是 最难安装的插件之一, 有很多人都砸在这个插件上了, 我们来看看如何安装这个插件.

 安装插件:

```javascript
 Plugin 'Valloric/YouCompleteMe'
```

 打开vim,输入:PluginInstall, vim会自动去从git上clone出项目, 把这个项目安装到项目目录上.

 安装完毕后. 我们进入到插件目录

```javascript
cd ~/.vim/bundle/YouCompleteMe/
./install.py --clang-completer
```

 又是需要漫长的等待, 等他安装好.

 在vimrc中配置YouCompleteMe:

```javascript
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_confirm_extra_conf=0 "关闭加载.ycm_extra_conf.py提示
let g:ycm_min_num_of_chars_for_completion=2 " 从第2个键入字符就开始罗列匹配项
let g:ycm_cache_omnifunc=0  " 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_seed_identifiers_with_syntax=1    " 语法关键字补全
" 在注释输入中也能补全
let g:ycm_complete_in_comments = 1
" 在字符串输入中也能补全
let g:ycm_complete_in_strings = 1
"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>lo :lopen<CR> "open locationlist                                                                                                                      
nnoremap <leader>lc :lclose<CR>   "close locationlist
inoremap <leader><leader> <C-x><C-o>"
inoremap <leader><leader> <C-x><C-o>
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
```

 我们开看看效果: 

![img](https://ask.qcloudimg.com/http-save/yehe-1164517/2l462958e3.png?imageView2/2/w/1620)

 完整配置文件如下:

```javascript
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" nerdtree插件
Plugin 'scrooloose/nerdtree'

" tagbar
Plugin 'majutsushi/tagbar'

" auto pair
Plugin 'jiangmiao/auto-pairs'

" mini buffer
Plugin 'minibufexpl.vim'

" tag list
Plugin 'taglist.vim'

" nerd commit
Plugin 'scrooloose/nerdcommenter'

" PHP mannual
Plugin 'alvan/vim-php-manual'

" snippets mate
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" markdown插件
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" you complete me插件
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on

"  Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set modelines=0

"设置更好的删除
set backspace=2

syntax on "语法高亮

"用浅色高亮当前行
autocmd InsertLeave * se nocul
autocmd InsertEnter * se cul

set smartindent "智能对齐

set autoindent "自动对齐

set confirm "在处理未保存或只读文件的时候，弹出确认框

set tabstop=4 "tab键的宽度
set softtabstop=4
set shiftwidth=4 "统一缩进为4
set expandtab "不要用空格替代制表符

set number "显示行号
set history=50  "历史纪录数
set hlsearch
set incsearch "搜素高亮,搜索逐渐高亮

set gdefault "行内替换
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1 "编码设置

colorscheme molokai

set guifont=Menlo:h16:cANSI "设置字体
set langmenu=zn_CN.UTF-8
set helplang=cn  "语言设置

set ruler "在编辑过程中，在右下角显示光标位置的状态行

set laststatus=1  "总是显示状态行

set showcmd "在状态行显示目前所执行的命令，未完成的指令片段也会显示出来

set scrolloff=3 "光标移动到buffer的顶部和底部时保持3行的距离
set showmatch "高亮显示对应的括号
set matchtime=5 "对应括号高亮时间(单位是十分之一秒)

set wildmenu  "增强模式中的命令行自动完成操作

set linespace=2 "字符间插入的像素行数目
set whichwrap=b,s,<,>,[,] "开启normal 或visual模式下的backspace键空格键，左右方向键,insert或replace模式下的左方向键，右方向键的跳行功能

filetype plugin indent on "分为三部分命令:file on,file plugin on,file indent on 分别是自动识别文件类型, 用用文件类型脚本,使用缩进定义文件


syntax enable
set foldenable  "允许折叠
set cursorline "突出显示当前行
set magic  "设置魔术？神马东东
set ignorecase "搜索忽略大小写
filetype on "打开文件类型检测功能
set background=dark
set t_Co=256   "256色
set mouse=a  "允许鼠标
"使用语法高亮定义代码折叠
set foldmethod=syntax
""打开文件是默认不折叠代码
set foldlevelstart=99"

" nerdtree 配置
let NERDTreeQuitOnOpen=1 "打开文件时关闭树
let NERDTreeShowBookmarks=1 "显示书签

" taglist 配置
let Tlist_Use_Right_Window=1 "taglist 显示在右侧 
let Tlist_Exit_OnlyWindow=1 "taglist 只剩下一个窗口时，自动关闭
let Tlist_File_Fold_Auto_Close=1

" -- MiniBufferExplorer --   
let g:miniBufExplMapWindowNavVim = 1  " 按下Ctrl+h/j/k/l，可以切换到当前窗口的上下左右窗口  
let g:miniBufExplMapWindowNavArrows = 1  "按下Ctrl+箭头，可以切换到当前窗口的上下左右窗口  
let g:miniBufExplMapCTabSwitchBufs = 1 "启用以下两个功能：Ctrl+tab移到下一个buffer并在当前窗口打开；Ctrl+Shift+tab移到上一个buffer并在当前窗口打开；ubuntu好像不支持  
let g:miniBufExplMapCTabSwitchWindows = 1 "  启用以下两个功能：Ctrl+tab移到下一个窗口；Ctrl+Shift+tab移到上一个窗口；ubuntu好像不支持  
let g:miniBufExplModSelTarget = 1     " 不要在不可编辑内容的窗口（如TagList窗口）中打开选中的buffer

" markdown 配置
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1

" YouCompleteMe配置
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_confirm_extra_conf=0 "关闭加载.ycm_extra_conf.py提示
let g:ycm_min_num_of_chars_for_completion=2 " 从第2个键入字符就开始罗列匹配项
let g:ycm_cache_omnifunc=0  " 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_seed_identifiers_with_syntax=1    " 语法关键字补全
" 在注释输入中也能补全
let g:ycm_complete_in_comments = 1
" 在字符串输入中也能补全
let g:ycm_complete_in_strings = 1
"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

let mapleader = ","
map <leader>ne :NERDTreeToggle<CR>
nmap <leader>tb :TagbarToggle<CR>
nmap <leader>mmbe :MiniBufExplorer<CR>
nmap <leader>mmbc :CMiniBufExplorer<CR>
nmap <leader>mmbu :UMiniBufExplorer<CR>
nmap <leader>mmbt :TMiniBufExplorer<CR>
map <leader>tl :TlistToggle<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ma :set mouse=a<cr>
nnoremap <leader>mu :set mouse=<cr>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>lo :lopen<CR> "open locationlist                                                                                                                      
nnoremap <leader>lc :lclose<CR>   "close locationlist
inoremap <leader><leader> <C-x><C-o>"
inoremap <leader><leader> <C-x><C-o>
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>

"对搜索的设置
map ft :call Search_Word()<CR>:copen<CR>
function Search_Word()
let w = expand("<cword>") " 在当前光标位置抓词
execute "vimgrep " . w . " %"
endfunction
```

#  总结

 这就是我们配置好的vim了, 如果你去配置, 我相信你一定会遇到不少问题, 但是我想, 这总是一个很好的经历, 它会培养你的耐心和毅力, 也会变得更加成熟.希望你也去试试哇!

 之前，为了解决一个语法加亮的问题更改了vimrc，之后，突然发现鼠标可以使用了，点到那里光标就定位到  那里，但是，随后发现，ctrl＋shift＋c不能用了，鼠标右键复制选项也是灰的。 到网上，搜了一下，发现是set mouse=a这句话的问题 这个是用来开启鼠标功能的。a表示所有模式

 vi的三种模式:命令模式,插入模式,可视模式.鼠标可以启动于各种模式中: The mouse can be enabled for different modes: n Normal mode v Visual mode i Insert mode c Command-line mode h all previous modes when editing a help file a all previous modes r for |hit-enter| and |more-prompt| prompt Normally you would enable the mouse in all four modes with: :set mouse=a When the mouse is not enabled, the GUI will still use the mouse for modeless selection. This doesn't move the text cursor.

 所以配置文件中的set mouse=a启动了所有模式,这样就屏蔽了鼠标右健功能.

 这里我设置为set mouse=v在可视模式下使用鼠标，然后搞定。

 但是，这样，其他模式就无法使用鼠标定位了，有点不爽。莫非鱼和熊掌不能兼得？？

 又到网上找了下，发现确实这样，不过却另有所获： 无须更改set mouse=a

 用鼠标选中，按y键复制，然后点击要粘贴的地方使用鼠标中键粘贴！！！ 支持夸文件粘贴，比使用命令方便多了