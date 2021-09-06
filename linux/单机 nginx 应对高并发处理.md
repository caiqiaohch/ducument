# 单机 nginx 应对高并发处理

nginx 是一个高效的服务器，但是如果只是安装，没有做什么配置的话，那么它最多也就只能承受1000个左右的并发

那么如何可以让nginx能轻松应对5000甚至10000的高并发呢，下面就来进得讨论一下



nginx 响应请求的过程

1，建立soket连接

2，打开文件（如 index.html）,返回

就是这么简单

那么对于第一步，  我们就会希望可以找开更多的socket连接

第二步，就是可以找开更多的文件

一般的操作系统，对socket找开的数量是有限制的，对找开文件多少也是有限制的

下面就从这两个方面来着手处理



1.对socket方面的优化

这一步又要分为两个方面的设置：

1）操作系统（linux）的设置：

@ socket 的最大连接数的修改         在centos中修改socket最大连接数的方法     （这里的文件是进程文件已经在运得的，不能使用vim编辑器修改），方法如下

echo 50000 > /proc/sys/net/core/somaxconn   (系统默认的值是128，现在改成50000)

@  加快系统的tcp回收机制 （系统默认tcp在断开后还会存活一段时间） 方法如下

echo  1 > /proc/sys/net/ipv4/tcp_tw_recycle  (系统默认是0，修改为1)

                @ 允许空的tcp回收利用 方法如下

echo 1 >/proc/sys/net/ipv4/tcp_tw_reuse  (系统默认为0，修改为1)

@ 让系统不做洪水抵御保护，（当系统检测到80端口在大量的请求时，会自动给返回信息中增加 cookie ,还验证客户端身份，从而避免受到攻击，但这时只是高并发，并不是攻击，所以要把这个抵御机制给关闭） 方法如下

echo 0 >/proc/sys/net/ipv4/tcp_syncookie (系统默认为1，修改为0)



2）nginx的设置：

@  允许子进程打开的连接 ，在event段中   worker_connections 1024;  nginx默认能打开1024个连接

修改     worker_connections 10000;  修改为可以打开10000个socket连接



2.对文件系统方面的优化



1）操作系统方面：

@  让操作系统允许打开更多的文件 ulimit -n(设置一个比较大的值)

ulimit -n 10240;     (把操作系统允许打开文件的最大值设为10240，原本的默认值是1024)

2）nginx 配置子进程可以打开的文件个数

在nginx全局的配置中  worker_processes 1;下面加上worker_limit_nofile 10240;

@ work_limit_nofile 10240  ;  (nginx的子进程可以打开10240个文件)



以上几个方面都修改完毕后 你的nginx就可以扛压了
————————————————
版权声明：本文为CSDN博主「A黄俊辉A」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/hjh15827475896/article/details/53442800