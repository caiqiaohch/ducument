使用vimplus打造强大的vim,带有C++重载函数提示.

夜晚不懂天的白 2020-07-02 11:50:43  500  收藏 1
文章标签： vim linux c++ ycm vim linux
版权
一.安装clangd
1.首先我们先安装clangd,vimplus默认是使用的clang,这个clang没有C++重载函数提示,所以在写代码的时候比较蛋疼.

2.进入https://clangd.llvm.org/installation.html,学习如何安装clangd.截图我就不截了,太麻烦了.我用的是Ubuntu,

所以还是直接上命令吧.

Installing the clangd package will usually give you a slightly older version.

Try to install the latest packaged release (9.0):

sudo apt-get install clangd-9
If that’s not found, at least clangd-9 or clangd-8 should be available. Versions before 8 were part of the clang-tools pacakge.

This will install clangd as /usr/bin/clangd-9. Make it the default clangd:

sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 100
 把上面这两个sudo命令敲一下就完成了clangd安装.

二.安装vimplus
1.使用git克隆vimplus到本地(这里是你的vimplus安装目录,请选择自己的目录,下载比较慢,耐心等等)

git clone https://github.com/chxuan/vimplus.git
2.下载完成之后进入vimplus目录:

cd vimplus
3.我们需要编辑install.sh这个文件. 因vimplus默认是使用的clang安装ycm

vim install.sh

进入之后我们打一个/install_ycm,会找到以下函数实现:
# 安装ycm插件
function install_ycm()
{
    git clone https://gitee.com/chxuan/YouCompleteMe-clang.git ~/.vim/plugged/YouCompleteMe

    cd ~/.vim/plugged/YouCompleteMe
     
    read -p "Please choose to compile ycm with python2 or python3, if there is a problem with the current selection, please    if [[ $version == "2" ]]; then                                                                                         
        echo "Compile ycm with python2."
        python2.7 ./install.py --clang-completer
    else
        echo "Compile ycm with python3."
        python3 ./install.py --clang-completer
    fi  
}
# 在android上安装ycm插件
function install_ycm_on_android()
{
    git clone https://gitee.com/chxuan/YouCompleteMe-clang.git ~/.vim/plugged/YouCompleteMe
    cd ~/.vim/plugged/YouCompleteMe
    read -p "Please choose to compile ycm with python2 or python3, if there is a problem with the current selection, please    if [[ $version == "2" ]]; then
        echo "Compile ycm with python2."
        python2.7 ./install.py --clang-completer --system-libclang
    else
        echo "Compile ycm with python3."
        python3 ./install.py --clang-completer --system-libclang
    fi
}

我们需要将install.py后面的clang全部更改为clangd.

4.接下来我们安装vimplus,在vimplus目录sudo ./install.sh安装,然后会有提示让你选择python2或者python3,这里我们使用python3.

输入一个3即可.接下来就是漫长的等待.

5.安装完成.还需要更改vimrc这个文件,添加ycm支持clangd功能,终端输入vim ~/.vimrc,然后我们输入/ycm敲个回车.



" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = exepath("clangd")
 将这段代码插入进去,我们测试一下.

使用clang安装ycm插件.std::vector是没有提示重载函数的.



使用clangd安装的ycm插件是有重载函数提示的.

 

三.介绍一下vimplus中的一些快捷键
leader键是,

1.函数的跳转到声明->(,u)

2.函数的跳转到头文件->(,o)

3.自动补全最后的分号(这个必须在你输入正确的情况下才可以补全)->(,ff)

4,右侧显示宏定义,typedef->(,t)

5.vim底部状态栏显示函数参数,需要做到ycm提示的时候,按tab键选择你所需要的函数然后打一个(才会有提示.

6.NERDTree显示左侧树目录

7.关闭一个标题栏就是vim上面显示的buffer->(,d)比如你跳到一个库函数的头文件中之后你不知道怎么关闭可以使用,d就给关了

8.切换标题栏,这个和7差不多,比如你跳到好几个库函数中,你不想关闭这几个库函数头文件可以使用,ctrl+p上一个,ctrl+n下一个,这样来回切换.

9,多个窗口来回切换

ctrl+h切换到左侧窗口,

ctrl+l切换到右侧窗口,

ctrl+k切换到上侧窗口,

ctrl+j切换到下侧窗口.

10.把上面所有演示给你看,如果还想了解更多快捷键,请使用vim ~/.vimrc进去查看



————————————————
版权声明：本文为CSDN博主「夜晚不懂天的白」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_31629063/article/details/107080087