centos7中的date命令

一、查看系统时间
[root@localhost ~]# date
2020年 03月 22日 星期日 10:50:42 CST
1
2
时区：
UTC：世界标准时间
GMT：格林威治标准时间
CST：中国标准时间

二、修改时间
[root@localhost ~]# date -s "2020-3-22 11:00"
#两种方式都可以

[root@localhost ~]# date --set "2020-3-22 11:00"

三、按照格式查看时间
%F：显示年月日

%y：年份的最后两位数字，范围是00 ~ 99

%Y：年份

%m：月份，范围01 ~ 12

%d：当前是几号，按月计算的日期

%M：分钟

%H：小时

%S：秒

[root@localhost ~]# date "+%F"
2020-03-22

[root@localhost ~]# date "+%Y%m%d"
20200322

[root@localhost ~]# date "+%Y-%m-%d %H:%M:%S"
2020-03-22 11:07:51

使用-d 或者 --date 参数查看某个特定的时间

#一个月之后的时间
[root@localhost ~]# date -d "+1 months" +%F
2020-04-22

[root@localhost ~]# date --date "+2 year" +%F
2022-03-22


service ntpdate stop

date -s "2020-4-20 7:55"
date -s "2020-4-21 9:55"