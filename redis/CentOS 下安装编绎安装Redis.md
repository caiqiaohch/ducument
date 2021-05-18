CentOS 下安装编绎安装Redis

 CentOS 下安装编绎安装Redis

先去http://www.redis.io/ 这个网站下载源码

tar -xvf redis-2.6.13.tar.gz

cd redis-2.6.13

可以先扯下 vi READMIN 这个文档，很不错的

make 

make test 

报了一个错 You need tcl 8.5 or newer in order to run the Redis test

缺tcl ，我就不下载源码包了

yum -y install tcl 

再来 make clean 

再来执行 make 

make test 这下就不报错了

make install 安装到本地服务器上

 cd utils

./install_server.sh  报服务器安装到本地机上

 报了个这个错

./install_server.sh: line 178: update-rc.d: command not found
exists, process is already running or crashed

按着错误提示，我们对/etc/init.d/redis_6379进行修改，只有要“\n”删除并且输入回车，修改完毕后，保存

==================

还有解决方案是　

vim install_server.sh

##第一个点###修改前-if[!`which chkconfig`];then###修改后+if[!`which chkconfig`];


##第二个点###修改前-if[!`which chkconfig`];then###修改后+if[!`which chkconfig`];then
也就是在

if[! `which chkconfig`];在！中间敲一个空格键
还有错误是:

Selected default - /var/lib/redis/6379
which: no redis-server in (/sbin:/bin:/usr/sbin:/usr/bin)
Please select the redis executable path [] vim ins ^H^H^H^H^H
Mmmmm... it seems like you don't have a redis executable. Did you run make install yet?

which redis找不能服
加入一个软件链接
ln -s /usr/local/redis/bin/redis-* /usr/local/bin/ 

service redis_6379 start  启动

ps -ef | grep redis 

基本操作 redis-cli 

redis 127.0.0.1:6379> info #查看server版本内存使用连接等信息

redis 127.0.0.1:6379> client list #获取客户连接列表

redis 127.0.0.1:6379> client kill 127.0.0.1:33441 #终止某个客户端连接

redis 127.0.0.1:6379> dbsize #当前保存key的数量

redis 127.0.0.1:6379> save #立即保存数据到硬盘

redis 127.0.0.1:6379> bgsave #异步保存数据到硬盘

redis 127.0.0.1:6379> flushdb #当前库中移除所有key

redis 127.0.0.1:6379> flushall #移除所有key从所有库中

redis 127.0.0.1:6379> lastsave #获取上次成功保存到硬盘的unix时间戳

redis 127.0.0.1:6379> monitor #实时监测服务器接收到的请求

redis 127.0.0.1:6379> slowlog len #查询慢查询日志条数
(integer) 3

redis 127.0.0.1:6379> slowlog get #返回所有的慢查询日志，最大值取决于slowlog-max-len配置

redis 127.0.0.1:6379> slowlog get 2 #打印两条慢查询日志

redis 127.0.0.1:6379> slowlog reset #清空慢查询日志信息

这样基本上就安装完成了


linux 安装Redis6.0.5时
进行到./install_server.sh时报错，

This systems seems to use systemd.
Please take a look at the provided example service unit files in this directory, and adapt and install them. Sorry!
解决方案：

vi ./install_server.sh
注释下面的代码即可

#bail if this system is managed by systemd
#_pid_1_exe="$(readlink -f /proc/1/exe)"
#if [ "${_pid_1_exe##*/}" = systemd ]
#then
#       echo "This systems seems to use systemd."
#       echo "Please take a look at the provided example service unit files in this directory, and adapt and install them. Sorry!"
#       exit 1
#fi
然后重新运行 ./install_server.sh即可。

1、初始化Redis密码：

在配置文件中有个参数： requirepass  这个就是配置redis访问密码的参数；

比如 requirepass test123；

（Ps:需重启Redis才能生效）

redis的查询速度是非常快的，外部用户一秒内可以尝试多大150K个密码；所以密码要尽量长（对于DBA 没有必要必须记住密码）；
2、不重启Redis设置密码：
在配置文件中配置requirepass的密码（当redis重启时密码依然有效）。
redis 127.0.0.1:6379> config set requirepass test123
auth redis123
#密码登录Redis
redis-cli -h 127.0.0.1 -p 6379 -a "root"
#登陆有密码的Redis：
#在登录的时候的时候输入密码： 
redis-cli -p 6379 -a test123
#先登陆后验证：
redis-cli -p 6379
redis 127.0.0.1:6379> auth test123
OK
redis-cli -h 192.168.1.222 -p 6379 -a root
#启动[root@localhost redis]# redis-server 6379.conf   
[root@localhost redis]# pwd
/home/haoyou/redis

./redis-cli -h 你服务器的ip -p 6379 -a 你的密码


3. 配置

　　3.1 配置redis.conf

　　　　将 bind 127.0.0.1 使用#注释掉，改为# bind 127.0.0.1（bind配置的是允许连接的ip，默认只允许本机连接；若远程连接需注释掉，或改为0.0.0.0）

　　　　将 protected-mode yes 改为 protected-mode no（3.2之后加入的新特性，目的是禁止公网访问redis cache，增强redis的安全性）

　　　　将 requirepass foobared 注释去掉，foobared为密码，也可修改为别的值（可选，建议设置）

　　3.2 设置iptables规则，允许外部访问6379端口

　　　　iptables -I INPUT 1 -p tcp -m state --state NEW -m tcp --dport 6379 -j ACCEPT

　　　　临时生效，重启后失效。若想永久生效，请参考另一篇文章：http://www.cnblogs.com/jinjiyese153/p/8600855.html

　　3.3 启动redis，并指定配置文件

　　　　./redis-server ../redis.conf

4. 检查

　　本机安装RedisDesktopManager进行redis远程连接。

 

CentOS配置iptables规则并使其永久生效
 
© 版权声明：本文为博主原创文章，转载请注明出处

 1. 目的

　　最近为了使用redis，配置远程连接的使用需要使用iptable是设置允许外部访问6379端口，但是设置完成后重启总是失效。因此百度了一下如何设置永久生效，并记录。

 2. 设置

　　2.1 添加iptables规则

iptables -I INPUT 1 -p tcp -m state --state NEW -m tcp --dport 6379 -j ACCEPT
　　2.2 保存

service iptables save
　　执行这个命令的时候有时候可能会报错：The service command supports only basic LSB actions (start, stop, restart, try-restart, reload, force-reload, status). For other actions, please try to use systemctl.

　　这是因为没有安装iptables服务，直接使用yum安装iptables服务即可.

yum install iptables-services
　　安装完成后，重新执行 service iptables save 命令即可保存成功。



　　2.3 配置iptables开机自启

　　保存后重启依然没有生效，后百度得知，需要设置iptables开机自启才可使配置生效。

　　执行如下命令（老版本命令为：service iptables on），设置iptables开机自启

systemctl enable iptables.service
 3. 注意

　　需关闭firewalld防火墙

　　systemctl stop firewalld.service

　　systemctl disable firewalld.service