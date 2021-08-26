# [Redis总结（九）Linux环境如何安装redis](https://www.cnblogs.com/zhangweizhong/p/11378149.html)

以前总结Redis 的一些基本的安装和使用，由于是测试方便，直接用的window 版的reids，并没有讲redis在linux下的安装。今天就补一下Linux环境如何安装redis。

大家可以这这里查看Redis 系列文章：https://www.cnblogs.com/zhangweizhong/category/771056.html。

## 安装redis

版本说明：我这边使用的是redis3.0版本。3.0版本主要增加了redis集群功能。

安装的前提条件：

需要安装gcc：yum install gcc-c++

 

具体安装步骤如下：

1、下载redis的源码包。不愿去官网下载的，可以[点击这里](https://files.cnblogs.com/files/zhangweizhong/redis集群.rar)下载。

2、把源码包上传到待安装的linux服务器上

3、解压源码包到当前目录：tar -zxvf redis-3.0.0.tar.gz

![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190819162039645-1095915761.png)

4、编译redis源码，进入到刚刚解压出来的目录，执行编译命令：make

![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190819162635671-1981056534.png)

5、安装，编译成功之后，执行如下命令，安装redis：make install PREFIX=/usr/local/redis

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190819163209083-167569221.png)

 

## 启动redis

1、前端启动模式

进入redis的安装目录（我这里默认/usr/local/redis/bin）， 执行命令即可： ./redis-server

默认是前端启动模式，端口是6379

![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190819163458947-1983371219.png)

 

2、后端启动

1）从redis的源码目录中复制redis.conf到redis的安装目录，cp redis.conf /usr/local/redis/bin/。

![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190819164346623-43288530.png)

2）修改redis.conf配置文件，

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190819164536879-1413810054.png)

3）启动redis： ./redis-server redis.conf

 

## 测试

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190819165018481-1609434607.png)

 

## 最后

 以上，就把redis在linux下的安装讲完了。