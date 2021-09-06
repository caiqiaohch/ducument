# CentOS 7 上安装 Redis 服务器的方法

1、进入Redis官网获取Redis最新稳定版下载地址，通过wget命令下载 Redis 源代码。
Redis编译
1、通过tar -xvf redis-3.0.2.tar.gz命令解压下载Redis源码压缩包redis-3.0.2.tar.gz；
2、编译Redis。通过cd redis-3.0.2/进入Redis源码目录内，执行make编译Redis；
注意：make命令执行完成编译后，会在src目录下生成6个可执行文件，分别是redis-server、redis-cli、redis-benchmark、redis-check-aof、redis-check-dump、redis-sentinel。
Redis安装配置
1、安装Redis，执行make install。会将make编译生成的可执行文件拷贝到/usr/local/bin目录下；
2、执行./utils/install_server.sh配置Redis配置之后Redis能随系统启动。
Redis服务查看、开启、关闭
1、通过ps -efgrep redis命令查看Redis进程；
2、开启Redis服务操作通过/etc/init.d/redis_6379 start命令，也可通过（service redis_6379 start）；
3、关闭Redis服务操作通过/etc/init.d/redis_6379 stop命令，也可通过（service redis_6379 stop）；
通过以上的方法即可安装好Redis 服务器。

    出错问题解决:
    1. 执行make时候若出现：You need tcl 8.5 or newer in order to run the Redis test
    需要安装 tcl8.5 及以上版本
        wget http://downloads.sourceforge.net/tcl/tcl8.6.1-src.tar.gz  
        sudo tar xzvf tcl8.6.1-src.tar.gz  -C /usr/local/  
        cd  /usr/local/tcl8.6.1/unix/  
        sudo ./configure  
        sudo make  
        sudo make install   
    以上安装 tcl 完成
    
    2. 执行./utils/install_server.sh
    
     cd utils
    
    ./install_server.sh  报服务器安装到本地机上
    
     报了个这个错
    
    ./install_server.sh: line 178: update-rc.d: command not found
    
    exists, process is already running or crashed 第一种解决方案：
    
    按着错误提示，我们对/etc/init.d/redis_6379进行修改，只有要“\n”删除并且输入回车，修改完毕后，保存

   第二种解决方案：

#######因为install_server.sh这个安装脚本有bug#####################################
vim install_server.sh

##第一个点
###修改前
-if [ !`which chkconfig` ] ; then 
###修改后
+if [ ! `which chkconfig` ] ; then 
   #combine the header and the template (which is actually a static footer)
   echo $REDIS_INIT_HEADER > $TMP_FILE && cat $INIT_TPL_FILE >> $TMP_FILE || die "Could not write init script to $TMP_FILE"
 else

##第二个点
###修改前
-if [ !`which chkconfig` ] ; then 
###修改后
+if [ ! `which chkconfig` ] ; then 
   #if we're not a chkconfig box assume we're able to use update-rc.d
   update-rc.d redis_$REDIS_PORT defaults && echo "Success!"
 else

###修改完成后，再次执行，应该没问题的了

参考：http://blog.csdn.net/zzjjiandan/article/details/28855097

http://www.cnblogs.com/jackluo/archive/2013/06/15/3137182.html

https://jingyan.baidu.com/album/6dad507510ea07a123e36e95.html?picindex=4
