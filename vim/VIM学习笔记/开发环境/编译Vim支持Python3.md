# 编译Vim支持Python3

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

11 人赞同了该文章

请注意，本文在Mac OS X 10.15.3下测试完成。以下命令中的参数，需要根据您的系统环境进行相应调整。

## 前置条件

首先确请认已安装Python3或Python2。关于安装和配置信息，请访问[Python](https://link.zhihu.com/?target=https%3A//www.python.org/downloads/)网站。

使用以下命令，查看当前Python2安装情况：

```bash
$ which python
/usr/bin/python
```

使用以下命令，查看当前Python3安装情况：

```bash
$ which python3 
/usr/bin/python3
```

## 编译Vim

使用Git命令，将Vim源码复制到本地：

```bash
$ git clone https://github.com/vim/vim.git
```

切换到下载的Vim源码目录：

```bash
$ cd vim
```

通过配置命令，启用需要的特性：

```bash
$ ./configure --with-features=huge \
--enable-multibyte \
--enable-rubyinterp=dynamic \
--with-ruby-command=/usr/bin/ruby \
--enable-pythoninterp=dynamic \
--with-python-config-dir=/usr/lib/python2.7/config \
--enable-python3interp=dynamic \
--with-python3-config-dir=/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.7/lib/python3.7/config-3.7m-darwin \
--enable-cscope \
--enable-gui=auto \
--enable-gtk2-check \
--enable-fontset \
--enable-largefile \
--disable-netbeans \
--with-compiledby="yyq123@email.com" \
--enable-fail-if-missing \
--prefix=/usr/local
```

其中，“–-enable-fail-if-missing”，用于显示错误信息；“--prefix=/usr/local”，用于指定生成可执行文件的位置。

命令将检查配置项，并输出以下类似信息：

```text
checking --enable-pythoninterp argument... dynamic
checking --with-python-command argument... no
checking for python2... /usr/bin/python2
checking Python version... 2.7
checking Python is 2.3 or better... yep
checking Python's install prefix... /System/Library/Frameworks/Python.framework/Versions/2.7
checking Python's execution prefix... /System/Library/Frameworks/Python.framework/Versions/2.7
checking Python's configuration directory... (cached) /usr/lib/python2.7/config
checking Python's dll name... Python.framework/Versions/2.7/Python
checking if -pthread should be used... no
checking if compile and link flags for Python are sane... yes
checking --enable-python3interp argument... dynamic
checking --with-python3-command argument... no
checking for python3... /usr/bin/python3
checking Python version... 3.7
checking Python is 3.0 or better... yep
checking Python's abiflags... m
checking Python's install prefix... /Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.7
checking Python's execution prefix... /Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.7
checking Python's configuration directory... (cached) /Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.7/lib/python3.7/config-3.7m-darwin
checking Python3's dll name... Python3.framework/Versions/3.7/Python3
checking if -pthread should be used... no
checking if compile and link flags for Python 3 are sane... yes
checking whether we can do without RTLD_GLOBAL for Python... no
checking whether we can do without RTLD_GLOBAL for Python3... yes
checking --enable-tclinterp argument... no
checking --enable-rubyinterp argument... dynamic
checking --with-ruby-command argument... /usr/bin/ruby
checking for /usr/bin/ruby... /usr/bin/ruby
checking Ruby version... OK
checking Ruby rbconfig... RbConfig
checking Ruby header files... /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/include/ruby-2.6.0
......
```

执行以下编译命令：

```
$ sudo make
Starting make in the src directory.
If there are problems, cd to the src directory and run make there
cd src && /Library/Developer/CommandLineTools/usr/bin/make first
/bin/sh install-sh -c -d objects
touch objects/.dirstamp
CC="gcc -Iproto -DHAVE_CONFIG_H   -DMACOS_X -DMACOS_X_DARWIN    " srcdir=. sh ./osdef.sh
......
```

执行以下安装命令，将编译后的二进制文件复制到 /usr/local/bin ：

```
$ sudo make install
Starting make in the src directory.
If there are problems, cd to the src directory and run make there
cd src && /Library/Developer/CommandLineTools/usr/bin/make install
if test -f /usr/local/bin/vim; then \
	  mv -f /usr/local/bin/vim /usr/local/bin/vim.rm; \
	  rm -f /usr/local/bin/vim.rm; \
	fi
cp vim /usr/local/bin
strip /usr/local/bin/vim
chmod 755 /usr/local/bin/vim
......
```

关闭并重新打开Terminal终端，执行以下命令将显示已使用新编译的Vim：

```
$ which vim
/usr/local/bin/vim
```

执行以下命令，将显示新编译的Vim已包含Python3特性：

```
$ vim --version
```

![img](https://pic2.zhimg.com/80/v2-dfbe590b07d0c0813f862215b08987bd_720w.jpg)

其中，与Python相关的特性主要包括：

- +python，内置支持Python 2；
- +python3，内置支持Python 3；
- +python/dyn，动态支持Python 2；
- +python3/dyn，动态支持Python 3；

根据以上步骤，我们保持/usr/bin目录下预装的Vim不变，另外在/usr/local/bin目录下安装了自已编译的Vim。

## 卸载Vim

使用以下命令，可以重置编译操作：

```text
$ sudo make distclean
```

使用以下命令，可以卸载Vim：

```text
$ sudo make uninstall
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-202-Install-Vim-Mac.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-209-Start.html)>

发布于 2020-03-07