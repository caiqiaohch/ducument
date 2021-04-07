CentOS安装NodeJS

在CentOS下安装NodeJS有以下几种方法。使用的CentOS版本为7.2。CentOS其他版本的NodeJS安装大同小异，也可以参看本文的方法。

安装方法1——直接部署
1.首先安装wget

yum install -y wget
如果已经安装了可以跳过该步

2.下载nodejs最新的bin包

可以在下载页面https://nodejs.org/en/download/中找到下载地址。然后执行指令

wget https://nodejs.org/dist/v9.3.0/node-v9.3.0-linux-x64.tar.xz
然后就是等着下载完毕。

另外你也可以在你喜欢的任意系统上下载最新的bin包，然后通过FTP上传到CentOS上。

3.解压包

依次执行

xz -d node-v9.3.0-linux-x64.tar.xz
tar -xf node-v9.3.0-linux-x64.tar
4. 部署bin文件

先确认你nodejs的路径，我这里的路径为~/node-v9.3.0-linux-x64/bin。确认后依次执行

ln -s ~/node-v9.3.0-linux-x64/bin/node /usr/bin/node
ln -s ~/node-v9.3.0-linux-x64/bin/npm /usr/bin/npm

ln -s /home/haoyou/sourse/node-v14.16.0-linux-x64/bin/node /usr/local/bin/node
ln -s /home/haoyou/sourse/node-v14.16.0-linux-x64/bin/npm /usr/local/bin/npm

ln -s  redis-* -> /home/haoyou/sourse/redis/bin/redis-*
注意ln指令用于创建关联（类似与Windows的快捷方式）必须给全路径，否则可能关联错误。

5.测试

node -v
npm
如果正确输出版本号，则部署OK
这种安装的方法好处是比较干净，安装也比较快速。个人认为比较适合新手。但是如果遇到nodejs插件全局安装时，需要自行去创建关联，参考第4步。

安装方法2——编译部署
1.安装gcc，make，openssl，wget

yum install -y gcc make gcc-c++ openssl-devel wget
2.下载源代码包

同样的，你可以在下载页面https://nodejs.org/en/download/中找到下载地址。然后执行指令

wget https://nodejs.org/dist/v9.3.0/node-v9.3.0.tar.gz
3.解压源代码包

tar -xf node-v9.3.0.tar.gz
4.编译

进入源代码所在路径

cd node-v9.3.0
先执行配置脚本

./configure
编译与部署

make -j4
make install
接着就是等待编译完成(时间较久)…

5.测试

node -v
npm
如果正确输出版本号，则部署OK

这种方式安装，个人觉得比较有点麻烦，还有安装gcc等其他程序，对应新人来说可能比较晕。而且编译比较久，切部署完成后nodejs为分别放在好几个文件夹内：

/usr/local/bin –放置nodejs 执行程序
/usr/lib –放置了node_modules，即nodejs的各种模块
/usr/include –放置了nodejs扩展开发用头文件
优点是全局安装nodejs模块，直接使用。