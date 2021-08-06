#  CentOS 下安装编绎安装Redis

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
