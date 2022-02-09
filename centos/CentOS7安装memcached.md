[南山以南丶](https://www.cnblogs.com/zhang-ding-1314/)

## [CentOS7安装memcached](https://www.cnblogs.com/zhang-ding-1314/p/9901610.html)

一、安装memcached


1.yum install memcached命令安装。

2.memcached -h命令查看帮助信息

3.查看配置信息/etc/sysconfig/memcached中：

 PORT="11211"
USER="root"
MAXCONN="1024"
CACHESIZE="64"
OPTIONS=""

3.memcached-tool 127.0.0.1:11211 stats命令查看memcached状态

 如果出现：Couldn't connect to 127.0.0.1:11211，很可能是memcached服务没有启动


出现如下信息成功安装了memcached：

 ![img](https://img2018.cnblogs.com/blog/987363/201811/987363-20181103181002197-1202062394.png)


4.服务启动命令：memcached -d -u root -l 127.0.0.1 -p 11211 -m 128(单位M) [-P filename(将pid写入文件)]

 

-p <num>   设置TCP端口号(默认不设置为: 11211)

-U <num>   UDP监听端口(默认: 11211, 0 时关闭) 

-l <ip_addr> 绑定地址(默认:所有都允许,无论内外网或者本机更换IP，有安全隐患，若设置为127.0.0.1就只能本机访问)

-d          以daemon方式运行

-u <username> 绑定使用指定用于运行进程<username>

-m <num>   允许最大内存用量，单位M (默认: 64 MB)

-P <file>   将PID写入文件<file>，这样可以使得后边进行快速进程终止, 需要与-d 一起使用

 

二、php-memcached 扩展安装

1.yum install php-memcached 命令安装

2.在/etc/php.d/z-memcached.ini中进行配置

 ![img](https://img2018.cnblogs.com/blog/987363/201811/987363-20181103181030987-1867040236.png)

3.php -m | grep memcached 命令查看是否有memcached模块

 ![img](https://img2018.cnblogs.com/blog/987363/201811/987363-20181103181059349-1476102303.png)

 

以上安装成功后就可以使用memcached了。

部分代码参考：

![img](https://img2018.cnblogs.com/blog/987363/201811/987363-20181103180934056-924960976.jpg)

 

\---------------------------------------------------------------------------------------------------

查看memcached进程：

ps aux|grep memcached 

![img](https://img2018.cnblogs.com/blog/987363/201811/987363-20181103181418015-557216923.png)

结束memcached进程

kill -9 pid  -------例去掉上图进程   kill -9 25850

一个勤劳的搬砖程序员