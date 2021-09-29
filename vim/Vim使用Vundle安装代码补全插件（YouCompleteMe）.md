# Vim使用Vundle安装代码补全插件（YouCompleteMe）

安装 Vundle
它的使用方法很简单，安装一个插件只需要在 ~/.vimrc 按照规则中添加 Plugin 的名称，某些需要添加路径，之后在 Vim 中使用:PluginInstall既可以自动化安装。

1、先新建目录

mkdir ~/.vim/bundle/Vundle.vim
2、git 克隆 Vundle 工程到本地

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
 3、修改 ~/.vimrc 配置 Plugins。在 ~/.vimrc 文件中添加如下内容并保存

set nocompatible " be iMproved, required
filetype off " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

" All of your Plugins must be added before the following line
call vundle#end() " required
filetype plugin indent on " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList - lists configured plugins
" :PluginInstall - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
4、进入 vim 运行命令

:PluginInstall
Vundle 命令
# 安装插件
:BundleInstall
# 更新插件
:BundleUpdate
# 清除不需要的插件
:BundleClean
# 列出当前的插件
:BundleList
# 搜索插件
:BundleSearch
注意
插件配置不要在 call vundle#end() 之前，不然插件无法生效
如果配置错误，需要重新配置后，在vim中运行命令 :PluginInstall

使用 Vundle 安装 YouCompleteMe
在 ~/.vimrc 中添加如下内容 位置在call vundle#begin()和call vundle#end()之间

Bundle 'Valloric/YouCompleteMe'
在vim中运行以下命令就会自行安装，安装时间有点长，请耐心等待

:BundleInstall
安装完成后需要编译 YouCompleteMe
编译过程需要CMake，没有安装CMake可使用以下命令进行安装

sudo apt install cmake
然后切换到以下目录

cd ~/.vim/bundle/YouCompleteMe 
最后输入以下命令即可（默认支持python）

./install.sh
配置 YouCompleteMe
在 ~/.vimrc 中添加配置

" 自动补全配置
set completeopt=longest,menu "让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
autocmd InsertLeave * if pumvisible() == 0|pclose|endif "离开插入模式后自动关闭预览窗口
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>" "回车即选中当前项
"上下左右键的行为 会显示其他信息
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"youcompleteme 默认tab s-tab 和自动补全冲突
"let g:ycm_key_list_select_completion=['<c-n>']
let g:ycm_key_list_select_completion = ['<Down>']
"let g:ycm_key_list_previous_completion=['<c-p>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_confirm_extra_conf=0 "关闭加载.ycm_extra_conf.py提示

let g:ycm_collect_identifiers_from_tags_files=1 " 开启 YCM 基于标签引擎
let g:ycm_min_num_of_chars_for_completion=2 " 从第2个键入字符就开始罗列匹配项
let g:ycm_cache_omnifunc=0 " 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_seed_identifiers_with_syntax=1 " 语法关键字补全
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR> "force recomile with syntastic
"nnoremap <leader>lo :lopen<CR> "open locationlist
"nnoremap <leader>lc :lclose<CR> "close locationlist
inoremap <leader><leader> <C-x><C-o>
"在注释输入中也能补全
let g:ycm_complete_in_comments = 1
"在字符串输入中也能补全
let g:ycm_complete_in_strings = 1
"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0

nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR> " 跳转到定义处
到此，YouCompleteMe 已安装成功。
————————————————
版权声明：本文为CSDN博主「成为菜鸟hh」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_42165891/article/details/119492512