CentOS7升级Git版本

前言
　　CentOS7上的Git版本太陈旧，在使用过程中会遇到问题，因此需要升级git版本。实时上，CentOS系统上各种软件版本都"巨陈旧"，哎...

# git --version
git version 1.8.3.1
　　系统版本：（CentOS 7.6）

# cat /etc/redhat-release 
CentOS Linux release 7.6.1810 (Core)
回到顶部
安装依赖
　　源代码安装和编译git，需安装一些依赖。

# yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel asciidoc
# yum install  gcc perl-ExtUtils-MakeMaker
回到顶部
卸载旧版本
# yum remove git
回到顶部
编译安装Git
　　Git软件包可在此获取：https://mirrors.edge.kernel.org/pub/software/scm/git/。

　　我们选择最新版的：

git-2.23.0.tar.xz                                  16-Aug-2019 20:17      5M
回到顶部
安装步骤
复制代码
# cd /usr/local/src/
# wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.23.0.tar.xz
# tar -xvf git-2.23.0.tar.xz
# cd git-2.23.0/
# make prefix=/usr/local/git all
# make prefix=/usr/local/git install
# echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile
# source /etc/profile
复制代码
回到顶部
验证版本
[root@localhost ~]# git --version
git version 2.23.0
回到顶部
非root用户使用
　　如果是非root用户使用git，则需要配置下该用户下的环境变量。

$ echo "export PATH=$PATH:/usr/local/git/bin" >> ~/.bashrc
$ source ~/.bashrc
　　以上，仅记录，以备忘。


1、# cd /usr/local/src
2、# wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
3、# tar -zxvf libiconv-1.14.tar.gz
4、# cd libiconv-1.14
5、# ./configure --prefix=/usr/local/libiconv  &&  make  && make install

二.创建一个软链接到/usr/lib

1、# ln -s /usr/local/lib/libiconv.so /usr/lib
2、# ln -s /usr/local/lib/libiconv.so.2 /usr/lib


cd /usr/local/src/
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.23.0.tar.xz
tar -xvf git-2.23.0.tar.xz
cd git-2.23.0/
make prefix=/usr/local/git all
make prefix=/usr/local/git install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile
source /etc/profile