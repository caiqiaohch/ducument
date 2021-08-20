YouCompleteMe这个Vim插件还真不好安装，挺多坑的，折腾了挺久终于最后用上了。

测试环境：

```
[broly@localhost ~]$ cat /etc/redhat-release 
CentOS Linux release 7.4.1708 (Core)12
```

## 一、更新Vim

我安装这个插件的时候，提示：YouCompleteMe unavailable : YouCompleteMe unavailable: requires Vim 7.4.1578+

所以不得不把系统自带的Vim更新到8.0

```
# 移除旧版本
sudo yum remove vim -y
# 安装必要组件
sudo yum install ncurses-devel python-devel -y
# 下载源码编译安装
git clone https://github.com/vim/vim.git
cd vim/src
# 根据自己实际情况设置编译参数
./configure --with-features=huge --enable-pythoninterp=yes --enable-cscope --enable-fontset --with-python-config-dir=/usr/lib64/python2.7/config
make
sudo make install1234567891011
```

编译参数说明：
–with-features=huge：支持最大特性
–enable-rubyinterp：打开对ruby编写的插件的支持
–enable-pythoninterp：打开对python编写的插件的支持
–enable-python3interp：打开对python3编写的插件的支持
–enable-luainterp：打开对lua编写的插件的支持
–enable-perlinterp：打开对perl编写的插件的支持
–enable-multibyte：打开多字节支持，可以在Vim中输入中文
–enable-cscope：打开对cscope的支持
–with-python-config-dir=/usr/lib64/python2.7/config 指定python 路径
–with-python-config-dir=/usr/lib64/python3.5/config 指定python3路径

注意：必须带上Python编写插件支持，最好带上Python路径，否则使用时会报这个错误：YouCompleteMe unavailable: requires Vim compiled with Python (2.6+ or 3.3+) support

编译安装好Vim后，默然是安装在/usr/local/bin目录下，所以把该目录加入到PATH方便terminal全局使用：

```
sudo nano /etc/profile1
```

在尾部添加：

```
export PATH=$PATH:/usr/local/bin/vim1
```

然后使环境变量生效：

```
source /etc/profile1
```

## 二、安装Vundle和YouCompleteMe

Vundle是Vim的插件管理工具，官方文档：https://github.com/VundleVim/Vundle.vim

安装步骤很简单：

```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim1
```

编辑配置文件

```
vim ~/.vimrc1
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Bundle 'altercation/vim-colors-solarized'
Plugin 'vim-scripts/OmniCppComplete'
Plugin 'Valloric/YouCompleteMe'

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

syntax enable
colorscheme monokai

let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'12345678910111213141516171819202122232425262728293031323334353637383940414243444546474849505152
```

### **这里要注意加上, 在我自己的vimrc上**

```
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'1
```

执行插件安装

```
:
```

## 三、增加配色方案

我这里使用monokai 配色方案 ：https://github.com/sickill/vim-monokai

下载对应的monokai.vim 文件 放到 ~/.vim/colors/ 即可

```
mkdir ~/.vim/colors
wget -O ~/.vim/colors/monokai.vim https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim12
```

## 四、安装Clang

（此步骤可选，因为安装这个是为了C语言家族语法补全功能）
**原文说的是这个步骤可选，但是如果不安装Clang，可能会出现 bug：the ycmd server SHUT DOWN (restart with ‘:…low the instructions in the documentation.**

```
sudo yum install cmake -y
cd ~/.vim/plugin/YouCompleteMe  
./install.py --clang-completer123
```

## 五、测试

打开个cpp文件，测试下是否还会报错吧~~

```
vim demo.cpp
```