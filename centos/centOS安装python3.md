centOS下安装python3 和 pip: command not found


在更新python3的时候会自动安装pip3，但是安装完成后，pip -V发现出错：command not found，找了好久，发现在建立软连接的时候路径写错了。

总结一下安装python3和发现pip:command not found 之后的思路。

centOS安装python3


准备编译环境
yum groupinstall 'Development Tools' 

yum install zlib-devel bzip2-devel openssl-devel ncurese-devel 

2. 下载python3.5包

wget http://www.python.org/ftp/python/3.6.5/Python-3.6.5.tar.xz

3. 解压，编译

tar Jxvf Python-3.6.5.tar.xz

cd Python-3.6.5

./configure --with-ssl

./configure --prefix=/usr/local/python3 --with-ssl

make && make install 

这里注意这个 –prefix选项，将python3安装在/usr/local/python3目录下，而之前下载的压缩包和安装包就都可以直接删除了。 

4. 更换系统默认的python和pip版本 

备份系统旧的python版本

mv /usr/bin/python /usr/bin/python2.6

建立指向新python3和pip3的软链接

ln -s /usr/local/python3/bin/python3.6 /usr/bin/python3

ln -s /usr/local/python3/bin/pip3 /usr/bin/pip 

之前出错就是把pip的软链接路径写错导致找不到pip3

检查python和pip版本 

python -V 

pip -V 

5. 更新yum相关设置 

因yum依赖python2，故修改文件

vim /usr/bin/yum 

将第一行改为

#!/usr/bin/python2.6

pip: command not found

参考链接  (https://www.quora.com/How-to-fix-%E2%80%9Cpip-command-not-found%E2%80%9D)

出现这个的原因一般有两个： 

1. 未安装pip 

2. pip安装了，但是没有配置$PATH环境变量

如果是第二个原因，此时echo $PATH 查看pip的安装目录是否在PATH中，如果没有，在~/.bash_profile中添加export PATH=$PATH:/usr/local/bin（假设pip的安装目录为/usr/local/bin）然后source ~/.bash_profile使之生效。

我之前其实已经配置$PATH，并且没有将系统的pip可执行路径指向了pip3的安装目录，但是在ln -s 的时候写错了pip3的路径，所以肯定找不到。愚蠢的错误。

安装xlrd、xlwt、xlutils很简单，直接【pip install xlrd】、【pip install xlwt】、【pip install xlutils】即可。


//=================================python3中pip3安装出错,找不到SSL的解决方式======
pip is configured with locations that require TLS/SSL, however the ssl module in Python is not available.
 
Could not fetch URL https:*******: There was a problem confirming the ssl certificate: 
Can't connect to HTTPS URL because the SSL module is not available. - skipping
本人安装Python3.6的操作如下：


1.wget获取安装包：
  wget http://www.python.org/ftp/python/3.6.2/Python-3.6.2.tgz
 
2.解压安装包：
  tar -xvzf Python-3.6.2.tgz
 
3.检查安装平台属性，系统是否有编译时所需要额库，以及库的版本是否满足编译需要
  ./configure
 
4.编译源码
  make
 
5.成功编译之后，安装
  sudo make install
在安装完之后，我们希望用pip3命令来安装numpy。首先，用如下命令安装pip3:


sudo install python3-pip
安装完之后，使用pip3安装numpy：


sudo pip install python-numpy
但是此时就出错了，显示本文开始提到的错误，大致意思就是安装过程需要SSL,但是那个SSL找不到。

本人查阅网上资料，发现openSSL是系统自带的，所以一定是安装了的，本人用以下命令尝试再次安装openssl:

sudo apt-get install openssl
sudo apt-get install libssl-dev
但是安装结果显示是对其进行更新(update)，这说明系统已经安装了openssl。但是pip3就是找不到ssl模块。

本人进入python3中，然后进行ssl导入操作:

import ssl
结果出错，错误如下：

no moudle named _ssl
显示没有ssl模块。本人再进入python中(即系统自带的python2.7中)，进行ssl导入操作:

import ssl
发现并没有显示错误，导入正常。这说明openssl已经安装了，只是python2可以调用，新安装的python3却不能调用。

本人查阅资料发现，在./configure过程中，如果没有加上–with-ssl参数时，默认安装的软件涉及到ssl的功能不可用，刚好pip3过程需要ssl模块，而由于没有指定，所以该功能不可用。

解决办法是重新对python3.6进行编译安装，用一下过程来实现编译安装:

cd Python-3.6.2
./configure --with-ssl
make
sudo make install
这样就允许安装的python3使用ssl功能模块,进入python3中，执行import ssl发现未出错，正常再次调用pip3指令来安装numpy，发现正常，问题解决！
