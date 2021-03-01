Linux下安装redis-2.8.3

Linux下安装redis-2.8.3
安装

    下载安装包 wget http://download.redis.io/releases/redis-2.8.3.tar.gz)
    解压 tar -zxf redis-2.8.3.tar.gz
    cd redis-2.8.3
    sudo make
    sudo make install
    cp src/redis-server src/redis-cli /usr/bin/ #方便在终端在任何地方直接运行
    cp redis.conf /etc/
    修改/etc/redis.conf,让server以守护进程在后台执行。daemonize yes
    在进行编译与安装后会提示进行测试，键入命令： make test
    等待跑完之后，最后有提示：
    \o/ All tests passed without errors!
    恭喜你，安装成功！

配置

make install仅仅在你的系统上安装了二进制文件，不会替你默认配置init脚本和配置文件，为了把它用在生产环境而安装它

$ sudo cd utils # 进入 redis-2.8.3目录下的utils目录下

$ sudo ./install_server.sh

脚本执行时，会有几个设置config等的问题，一般选择默认即可(回车)。redis作为后台守护进程运行所需要的所有配置都设置好了。你可以使用/etc/init.d/redis_，例如/etc/init.d/redis_6379中的脚本来启动和停止Redis。

我执行/etc/init.d/redis_6379 start时遇到了

exists, process is already running or crashed

    1

应该环境变量pidfile有问题，直接执行命令/usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf启动成功。


===========================================================================

编译redis报错/deps/hiredis/libhiredis.a解决

在编译redis3.2.9时报错

cc: ../deps/hiredis/libhiredis.a: No such file or directory
cc: ../deps/lua/src/liblua.a: No such file or directory
cc: ../deps/geohash-int/geohash.o: No such file or directory
cc: ../deps/geohash-int/geohash_helper.o: No such file or directory
make[1]: * [redis-server] Error 1
make[1]: Leaving directory `/usr/local/src/redis-3.2.9/src'
make: * [all] Error 2


解决办法

进入源码包目录下的deps目录中执行

make geohash-int hiredis jemalloc linenoise lua


然后再进行make编译就可以了

===========================================================================================