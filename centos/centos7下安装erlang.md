背景
emqx中使用到了erlang作为其运行前提，为了编译相关插件，这里分享下如何在cento7下安装erlang。

安装方式
erlang两种主流安装方式：

1. 源码安装：http://erlang.org/download/otp_src_23.2.tar.gz

2.软件包管理器安装

For Homebrew on OS X: brew install erlang
For MacPorts on OS X: port install erlang
For Ubuntu and Debian: apt-get install erlang
For Fedora: yum install erlang
For FreeBSD: pkg install erlang
源码安装具体可参照：https://www.erlang.org/docs，这里主要介绍使用yum快捷安装erlang。

安装
1. 安装epel源

yum install -y epel-release

2. 添加存储库条目

wget https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
3、安装erlang

yum install -y erlang

4、验证是否安装成功

erl -version



看到上图信息则表示完成了erlang的安装。