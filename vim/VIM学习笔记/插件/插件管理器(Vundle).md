# 插件管理器(Vundle)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

8 人赞同了该文章

[Vundle](https://link.zhihu.com/?target=https%3A//github.com/gmarik/vundle)是一个Vim插件管理器，用于方便地安装、更新和卸载插件。

## **在Mac中配置Vundle**

1. 安装[GitHub for macOS](https://link.zhihu.com/?target=https%3A//desktop.github.com/)；
2. 使用以下命令，将Vundle安装到指定目录：
   `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
3. 安装后目录结构如下：

![img](https://pic2.zhimg.com/80/v2-8773b9d9f7287ea333800431715ef179_720w.jpg)

\4. 将[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2012/01/vim-vimrc.html)配置文件中的*"set the runtime path to include Vundle and initialize*部分，更新如下：
`set rtp+=~/.vim/bundle/Vundle.vim`
`call vundle#begin()`

## **在Windows中配置Vundle**

1. 安装[Git for Windows](https://link.zhihu.com/?target=https%3A//git-for-windows.github.io/)；
2. 配置Path环境变量；

![img](https://pic1.zhimg.com/80/v2-f53da77efc7e67d84ba8a4fdf8cb8638_720w.jpg)

\3. 在Windows命令提示符下执行`git --version`命令，如果Git安装成功，那么将显示以下信息：

![img](https://pic2.zhimg.com/80/v2-912c834f3f266a8ea7f0372fb79a5309_720w.jpg)

\4. 使用以下命令，将Vundle安装到指定目录：
`git clone https://github.com/VundleVim/Vundle.vim.git %USERPROFILE%/vimfiles/bundle/Vundle.vim`

\5. 安装后目录结构如下：

![img](https://pic1.zhimg.com/80/v2-5bbc67f57c767b4a75219dea649668ec_720w.jpg)


\6. 将[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2012/01/vim-vimrc.html)配置文件中的*"set the runtime path to include Vundle and initialize*部分，更新如下：
`set rtp+=$VIM/vimfiles/bundle/Vundle.vim/`
`call vundle#begin('$VIM/vimfiles/bundle/')`

## **Vundel配置实例**

```vim
" Vundle
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set the runtime path to include Vundle and initialize
set rtp+=$VIM/vimfiles/bundle/Vundle.vim/
call vundle#begin('$VIM/vimfiles/bundle/')
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'mattn/emmet-vim'
"Plugin 'landonb/dubs_html_entities'
Plugin 'lilydjwg/colorizer'
Plugin 'kshenoy/vim-signature'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'yyq123/HTML-Editor'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'https://github.com/wincent/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
"Plugin 'ascenator/L9', {'name': 'newL9'}

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


" vim-signature 配置
hi SignColumn ctermbg=NONE guibg=#131313
hi SignatureMarkText ctermbg=NONE guibg=#131313 gui=bold term=bold cterm=bold

" vim-sinpmate 配置
" Alt+Space
imap <M-space> <Plug>snipMateNextOrTrigger
smap <M-space> <Plug>snipMateNextOrTrigger
xmap <M-space> <Plug>snipMateVisual
```

## **安装插件**

vundle支持源码托管在[GitHub](https://link.zhihu.com/?target=https%3A//github.com/)的插件，你可以在[github.com/vim-scripts/](https://link.zhihu.com/?target=https%3A//github.com/vim-scripts/)上找到[vim官网](https://link.zhihu.com/?target=http%3A//www.vim.org/)里所有插件的镜像。

如果希望安装新插件，首先找到其在[http://github.com](https://link.zhihu.com/?target=http%3A//github.com)的网址，然后将其追加至[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2012/01/vim-vimrc.html)配置文件中的`call vundle#begin()`和`call vundle#end()`之间，最后执行以下命令安装所有引用的插件：

```vim
:PluginInstall
```

![img](https://pic4.zhimg.com/80/v2-f544773610b50beb6ca604861e14b76f_720w.jpg)

你也可以使用以下命令，指定安装特定的插件：

```vim
:PluginInstall yyq123/HTML-Editor
```

## **卸载插件**

如果希望卸载插件，请先在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2012/01/vim-vimrc.html)配置文件中注释或者删除对应插件的 配置信息，然后再执行以下命令：

```vim
:PluginClean
```

## **更新插件**

使用以下命令，可以自动批量更新所有已安装的插件：

```vim
:PluginUpdate
```

## **帮助信息**

使用以下命令，可以查看更多帮助信息：

```vim
:help vundle
```

## **常见问题**

**1、在Windows系统下，安装插件时，出现“git不是内部或外部命令”或者“缺少某一个lib”的报错。**

请将Git安装目录添加到Path设置中（路径名需要根据Git的安装位置作出相应修改）：
`C:\Program Files (x86)\Git\libexec\git-core;`
`C:\Program Files (x86)\Git\bin;`

**2、在Mac系统下，安装插件时，出现报错信息“error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at:/Library/Developer/CommandLineTools/usr/bin/xcrun”**

请在终端窗口中，执行以下命令来安装Xcode命令行工具包：
`xcode-select --install`



编辑于 2018-07-11