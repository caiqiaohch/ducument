如何实时查看mysql当前连接数?

1、查看当前所有连接的详细资料:
./mysqladmin -uadmin -p -h10.140.1.1 processlist


2、只查看当前连接数(Threads就是连接数.):
./mysqladmin  -uadmin -p -h10.140.1.1 status


、查看当前所有连接的详细资料:
mysqladmin -uroot -proot processlist
D:\MySQL\bin>mysqladmin -uroot -proot processlist
+-----+------+----------------+---------+---------+------+-------+------------------+
| Id | User | Host | db | Command | Time | State | Info |
+-----+------+----------------+---------+---------+------+-------+------------------+
| 591 | root | localhost:3544 | bbs | Sleep | 25 | | |
| 701 | root | localhost:3761 | | uery | 0 | | show processlist |
+-----+------+----------------+---------+---------+------+-------+------------------+
2、只查看当前连接数(Threads就是连接数.):
mysqladmin -uroot -proot status
D:\MySQL\bin>mysqladmin -uroot -proot status
Uptime: 2102 Threads: 3 Questions: 15531 Slow queries: 0 Opens: 0 Flush tab
les: 1 Open tables: 61 Queries per second avg: 7.389
3、修改mysql最大连接数：
打开my.ini，修改max_connections=100(默认为100)。


今天有一台mysql服务器突然连接数暴增，并且等待进程全部被锁...因为问题解决不当，导致被骂...OTL

总结：以后要快速定位错误，布置解决方案

登录到mysql客户端后，使用status命令也能获得thread连接数以及当前连接的id

或者用

show full processlist

看一下所有连接进程，注意查看进程等待时间以及所处状态 是否locked

如果进程过多，就把进程打印下来，然后查看

mysql -e 'show full processlist;' > 111

查找非locked的进程，一般就是当前执行中卡死，导致后面的进程排队的原因。

另外，修改mysql最大连接数的方法：

编辑MySQL(和PHP搭配之最佳组合)配置文件　
my.cnf 或者是 my.ini

在[MySQL(和PHP搭配之最佳组合)d]配置段添加：
max_connections = 1000

保存，重启MySQL(和PHP搭配之最佳组合)服务。

然后用命令：
MySQL(和PHP搭配之最佳组合)admin -uroot -p variables
输入root数据库账号的密码后可看到
| max_connections | 1000 |
查看MySQL连接数和当前用户Mysql连接数
先用管理员身份进入mysql提示符。
#mysql -uroot -pxxxx
mysql> show processlist; 可以显示前100条连接信息 show full processlist; 可以显示全部。随便说下，如果用普通账号登录，就只显示这用户的。注意命令后有分号。

如果我们想查看这台服务器设置。 #vi /etc/my.cnf
set-variable=max_user_connections=30 这个就是单用户的连接数
set-variable=max_connections=800 这个是全局的限制连接数

