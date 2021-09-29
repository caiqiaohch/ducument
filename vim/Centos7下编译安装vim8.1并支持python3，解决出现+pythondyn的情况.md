Centos7下编译安装vim8.1并支持python3，解决出现+python/dyn的情况

YongSangUn 2018-12-31 22:35:03  4738  收藏 3
分类专栏： Python
版权

Python
专栏收录该内容
3 篇文章0 订阅
订阅专栏
之前使用yum在centos7安装的vim7.4，当我想使用vim作为python的编辑器时，在配置.vimrc文件时，发现很多配置并不能生效，所以我打算重新编译安装以下更高版本的vim8.1.操作系统自带的vim只开了部分特性，安装之前的不支持python3，源码安装可以自由开启和关闭需要的特性。

但安装完成后出现了以下的样式：

[root@localhost ~]# vim --version |grep python
+cryptv          +linebreak       +python/dyn      +viminfo
+cscope          +lispindent      +python3/dyn     +vreplace
1
2
3
不是+python，而是后面多了一个/dyn。
看了下vim的帮助文档，在vim中输入：

:h python-2-and-3
1
显示这样的信息：

翻译一下：

Vim 7.4源码可以用四种方式编译 (:version OR 命令行vim --version输出结果):

无 Python 支持 (-python、-python3)
只有 Python 2 支持 (+python 或 +python/dyn、-python3)
只有 Python 3 支持 (-python、+python3 或 +python3/dyn)
Python 2 和 3 支持 (+python/dyn、+python3/dyn)
当支持Python 2和Python 3时，必须动态加载它们。
在Linux / Unix系统上执行此操作并导入global symbols时，这会导致使用第二个Python版本时发生崩溃。 所以要么加载global symbols只激活一个Python版本，要么不导入全局符号。 这会导致Python导入vim提供的全局符号的相关库的import出错。

即最好只安装支持一种python即可。
所以我为了避免麻烦，只编译安装支持python3 （按个人需求安装），在./configure 时 只选择支持python3，详细参数介绍见编译安装步骤。

//支持python2
--enable-pythoninterp --with-python-config-dir=/usr/lib64/python2.7/config							
OR
//支持python3
--enable-python3interp --with-python-config-dir=with-python3-config-dir=/usr/local/python3/lib/python3.5/config-3.5m	
1
2
3
4
5
安装前准备
首先卸载自带的vim
自带的可以使用yum卸载。

yum remove -y vim*
1
编译安装的直接删除整个安装目录即可。

rm -rf /usr/local/vim81
1
下载最新版本的vim源码（目录自定 本例放在/root/）
git clone https://github.com/vim/vim.git
1
编译安装
编译安装最重要的就是编译的参数，因为我只用的python3，需要其他特性的可以自行配。

首先进入工作目录
cd /root/vim/src
1
配置编译编译参数：
（建议在文本编辑器中编写好自己要配置的参数，以免出错后还需要重新编译安装）

./configure --with-features=huge --enable-multibyte  --enable-python3interp=yes --with-python3-config-dir=/usr/local/python3/lib/python3.5/config-3.5m --prefix=/usr/local/vim81
1
详细的参数说明
--with-features=huge：						//支持最大特性
--enable-rubyinterp：						//打开对ruby编写的插件的支持
--enable-luainterp：						//打开对lua编写的插件的支持
--enable-perlinterp：						//打开对perl编写的插件的支持
--enable-multibyte：						//打开多字节支持，可以在Vim中输入中文
--enable-cscope：							//打开对cscope的支持
--enable-pythoninterp：						//打开对python编写的插件的支持
--with-python-config-dir=/usr/lib64/python2.7/config							//指定python config路径。
--enable-python3interp：					//打开对python3编写的插件的支持
--with-python-config-dir=with-python3-config-dir=/usr/local/python3/lib/python3.5/config-3.5m		//指定python3 config路径。

--prefix=/usr/local/vim81					//指定安装路径，可自定义。	
1
2
3
4
5
6
7
8
9
10
11
12
注意指定python 和python3 config路径时需要你自己去找安装路径，确保正确的config路径。
例如我们要找python2的config路径:

[root@localhost ~]# which python2
/usr/bin/python2
[root@localhost ~]# whereis python2
python2: /usr/bin/python2 /usr/bin/python2.7 /usr/lib/python2.7 /usr/lib64/python2.7 /usr/include/python2.7 /usr/share/man/man1/python2.1.gz
[root@localhost ~]# python2
Python 2.7.5 (default, Jul 13 2018, 13:06:57) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-28)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import sys
>>> sys.path
>>> ['', '/usr/lib64/python27.zip', '/usr/lib64/python2.7', '/usr/lib64/python2.7/plat-linux2', '/usr/lib64/python2.7/lib-tk', '/usr/lib64/python2.7/lib-old', '/usr/lib64/python2.7/lib-dynload', '/usr/lib64/python2.7/site-packages', '/usr/lib/python2.7/site-packages']
>>> exit()

1
2
3
4
5
6
7
8
9
10
11
12
13
所以/usr/bin/python2.7就是我们要找的安装路径。

程序和可执行文件可以在许多目录，而这些路径很可能不在操作系统提供可执行文件的搜索路径中。
path(路径)存储在环境变量中，这是由操作系统维护的一个命名的字符串。这些变量包含可用的命令行解释器和其他程序的信息。
解释器中执行以下即可：

>>> import sys
>>> sys.path
>>> 1
>>> 2
>>> 配置参数完成后执行
>>> make 
>>> make install
>>> 1
>>> 2
>>> 如果make的时候出错，执行

make distclean
1
注：make clean仅仅是清除之前编译的可执行文件及配置文件，而make distclean要清除所有生成的文件。

最后创建软链即可：
ln -s /usr/local/vim81/bin/vim /usr/bin/vim
1
查看vim版本：
[root@localhost src]# vim --verison
VIM - Vi IMproved 8.1 (2018 May 18, compiled Dec 30 2018 13:13:49)
未知的选项参数: "--verison"
更多信息请见: "vim -h"
[root@localhost src]# vim --version
VIM - Vi IMproved 8.1 (2018 May 18, compiled Dec 30 2018 13:13:49)
包含补丁: 1-661
编译者 root@localhost.localdomain
巨型版本 无图形界面。  可使用(+)与不可使用(-)的功能:
+acl               +extra_search      +mouse_netterm     +tag_old_static
+arabic            +farsi             +mouse_sgr         -tag_any_white
+autocmd           +file_in_path      -mouse_sysmouse    -tcl
+autochdir         +find_in_path      +mouse_urxvt       +termguicolors
-autoservername    +float             +mouse_xterm       +terminal
-balloon_eval      +folding           +multi_byte        +terminfo
+balloon_eval_term -footer            +multi_lang        +termresponse
-browse            +fork()            -mzscheme          +textobjects
++builtin_terms    +gettext           +netbeans_intg     +textprop
+byte_offset       -hangul_input      +num64             +timers
+channel           +iconv             +packages          +title
+cindent           +insert_expand     +path_extra        -toolbar
-clientserver      +job               -perl              +user_commands
-clipboard         +jumplist          +persistent_undo   +vartabs
+cmdline_compl     +keymap            +postscript        +vertsplit
+cmdline_hist      +lambda            +printer           +virtualedit
+cmdline_info      +langmap           +profile           +visual
+comments          +libcall           -python            +visualextra
+conceal           +linebreak         +python3           +viminfo
+cryptv            +lispindent        +quickfix          +vreplace
+cscope            +listcmds          +reltime           +wildignore
+cursorbind        +localmap          +rightleft         +wildmenu
+cursorshape       -lua               -ruby              +windows
+dialog_con        +menu              +scrollbind        +writebackup
+diff              +mksession         +signs             -X11
+digraphs          +modify_fname      +smartindent       -xfontset
-dnd               +mouse             +startuptime       -xim
-ebcdic            -mouseshape        +statusline        -xpm
+emacs_tags        +mouse_dec         -sun_workshop      -xsmp
+eval              -mouse_gpm         +syntax            -xterm_clipboard
+ex_extra          -mouse_jsbterm     +tag_binary        -xterm_save
     系统 vimrc 文件: "$VIM/vimrc"
     用户 vimrc 文件: "$HOME/.vimrc"
 第二用户 vimrc 文件: "~/.vim/vimrc"
      用户 exrc 文件: "$HOME/.exrc"
       defaults file: "$VIMRUNTIME/defaults.vim"
         $VIM 预设值: "/usr/local/vim81/share/vim"
编译方式: gcc -std=gnu99 -c -I. -Iproto -DHAVE_CONFIG_H     -g -O2 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1       
链接方式: gcc -std=gnu99   -L/usr/local/lib -Wl,--as-needed -o vim        -lm -ltinfo -lnsl  -lselinux  -ldl     -L/usr/local/python3/lib/python3.5/config-3.5m -lpython3.5m -lpthread -ldl -lutil -lm      
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
后面就可以开始配置.vimrc文件，下载vundle插件，配置参数，开始DIY自己的编辑器了。

编译安装踩过很多坑，如果也遇到类似的问题，希望可以帮到你。
————————————————
版权声明：本文为CSDN博主「YongSangUn」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/Kardiyal/article/details/85383231