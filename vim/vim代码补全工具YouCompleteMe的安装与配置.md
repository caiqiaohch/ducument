# vim - YouCompleteMe 代码补全插件 2019

vim的插件安装过程其实并不复杂， 只要有照着正确的步骤， 一定能安装到位

安装将分为两大项
首先安装Vundle 插件管理器， 这是套插件管理器， 在安装及卸载插件上都有很大的帮助
PS. 如果已经安装请忽略

Vundle 插件管理器
以下分两步

install
终端中执行以下指令
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
1
配置.vimrc， 执行以下指令开启
vi .vimrc

进入后将以下贴上复制贴上

`set nocompatible               "去除VIM一致性，必须"`
`filetype off                   "必须"`

`"设置包括vundle和初始化相关的运行时路径"`
`set rtp+=~/.vim/bundle/Vundle.vim`
`call vundle#begin()`

`"启用vundle管理插件，必须"`
`Plugin 'VundleVim/Vundle.vim'`

`"在此增加其他插件，安装的插件需要放在vundle#begin和vundle#end之间"`
`"安装github上的插件格式为 Plugin '用户名/插件仓库名'"`

`call vundle#end()              
filetype plugin indent on      "加载vim自带和插件相应的语法和文件类型相关脚本，必须"`

这下我们能清楚看见代码中有
call vundle#begin()
call vundle#end()
这两项，接下来我们只要把要安装的插件， 写成代码插在这两行中间即可

接着安装今天的主角 YouCompleteMe
YouCompleteMe 代碼補全
直接利用Vundle插件管理器安装

vi .vimrc 进入vimrc配置

在call vundle#begin()以及call vundle#end() 之间 加入

Plugin 'Valloric/YouCompleteMe'

:wq 保存跳出

进入vim 使用 ：进行尾行命令 输入 PluginInstall 完成安装

执行 git submodule update --init --recursive
会开始下载细部文件到插件的各个文件夹中

执行编译(完成下面两步骤）

cd ~/.vim/bundle/YouCompleteMe:到安装的目录下
./install.py --clang-completer:执行isntall.py来进行编译安装
这个时候安装还没有完成， 打开cpp档案下方会出现
“No .ycm_extra_conf.py file detected, so no compile flags are available. Thus no semantic support for C/C++/ObjC/ObjC++”

我们要进行最后一步

进入vimrc 下方添加
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
1
注意网上还有很多估计是旧版本的插件， 所以.ycm_extra_conf.py的档案位置不同, 新版本的路径请依照上面

打开cpp档案， 补全功能正常运行
————————————————
版权声明：本文为CSDN博主「史蒂芬方」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_44638957/article/details/91985270