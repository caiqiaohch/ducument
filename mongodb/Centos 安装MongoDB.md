MongoDB是一个文档数据库，它具有可伸缩性和灵活性，您可以根据需要进行查询和索引。

MongoDB 是由C++语言编写的，是一个基于分布式文件存储的开源数据库系统。

在高负载的情况下，添加更多的节点，可以保证服务器性能。

MongoDB 旨在为WEB应用提供可扩展的高性能数据存储解决方案。

MongoDB 将数据存储为一个文档，数据结构由键值(key=>value)对组成。MongoDB 文档类似于 JSON 对象。字段值可以包含其他文档，数组及文档数组。

既然mongodb那么多优点，接下来就安装mongodb一探究竟。

一，下载安装包

从mongodb官网上下载二进制安装包，下载地址是：https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.6.17.tgz，下载下来之后进行解压,提取mongodb。

# wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.6.17.tgz



解压该压缩包，把数据提取到/opt/目录下。

# sudo tar -zvxf mongodb-linux-x86_64-rhel70-4.4.4.tgz -C /home/haoyou



下面为了升级的方便，对该目录创建一个软连接。

# sudo ln -s /opt/mongodb-linux-x86_64-rhel70-3.6.17 /opt/mongodb



下面进入到mongodb目录下，创建一个data目录。



二，创建环境变量

为了确保您能够从您的shell访问mongod，您必须在 ~/.bashrc 中添加以下内容。

# sudo vi ~/.bashrc

在文件末尾添加以下内容并保存。

export PATH=/home/haoyou/mongodb/bin:$PATH



接着执行以下命令让其配置生效。

# source ~/.bashrc



三，创建启动服务

使用下面的命令创建脚本文件。

$ sudo vi /etc/init.d/mongod

现在，复制以下代码并使用文本编辑器修改DBPATH和OPT变量:

#!/bin/sh
 
# chkconfig: 35 85 15
# description: Mongo is a scalable, document-oriented database.
# processname: mongod
# config: /etc/mongod.conf
# pidfile: /var/run/mongo/mongo.pid
 
. /etc/rc.d/init.d/functions
 
MONGOHOME="/home/ec2-user/mongodb" 
CONFIGFILE="/etc/mongod.conf" 
DBPATH="/home/ec2-user/<data-path>" 
COMMAND="$MONGOHOME/bin/mongod" 
OPT="--config $CONFIGFILE " 
mongod=${MONGOD-$COMMAND}
 
usage() { 
  echo "Usage: $0 {start|stop|restart|status}"
  exit 0
}
 
if [ $# != 1 ]; then 
  usage
fi
 
start() 
{
  echo -n $"Starting mongod: "
  daemon $COMMAND $OPT
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && sudo touch /var/lock/subsys/mongod
}
 
stop() 
{
  echo -n $"Stopping mongod: "
  killproc -p "$DBPATH"/mongod.lock -d 300 "$COMMAND"
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && sudo rm -f /var/lock/subsys/mongod
}
case "$1" in 
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  status)
    status $mongod
    RETVAL=$?
    ;;
  * )
    usage
    ;;
esac 
　　接着修改执行权限

$ chmod +x  /etc/init.d/mongod
在配置文件中粘贴以下代码(更改data-path、log-path和log-file)。

# mongo.conf
dbpath = /home/ec2-user/<data-path>
 
#port = 27017
#
#where to log
logpath = /home/ec2-user/<log-path>/<log-file>.log 
logappend = true
 
#rest = true
 
verbose = true 
## for log , more verbose
##vvvvv = true
#
##profile = 2
##slowms = 10
 
 
# fork and run in background
fork = true
 
# Disables write-ahead journaling
# nojournal = true
 
# Enables periodic logging of CPU utilization and I/O wait
#cpu = true
 
# Turn on/off security.  Off is currently the default
#noauth = true
#auth = true
 
# Verbose logging output.
#verbose = true
 
# Inspect all client data for validity on receipt (useful for
# developing drivers)
#objcheck = true
 
# Enable db quota management
#quota = true
 
# Set oplogging level where n is
#   0=off (default)
#   1=W
#   2=R
#   3=both
#   7=W+some reads
#oplog = 0
 
# Ignore query hints
#nohints = true
 
# Disable the HTTP interface (Defaults to localhost:27018).
#nohttpinterface = true
 
# Turns off server-side scripting.  This will result in greatly limited
# functionality
#noscripting = true
 
# Turns off table scans.  Any query that would do a table scan fails.
#notablescan = true
 
# Disable data file preallocation.
#noprealloc = true
 
# Specify .ns file size for new databases.
# nssize = <size>
 
# Accout token for Mongo monitoring server.
#mms-token = <token>
 
# Server name for Mongo monitoring server.
#mms-name = <server-name>
 
# Ping interval for Mongo monitoring server.
#mms-interval = <seconds>
 
# Replication Options
 
# in replicated mongo databases, specify here whether this is a slave or master
#slave = true
#source = master.example.com
# Slave only: specify a single database to replicate
#only = master.example.com
# or
#master = true
#source = slave.example.com
　接下来进行检查配置。Chkconfig命令用于设置、查看或更改配置为在系统启动期间自动启动的服务。现在让我们添加mongod的信息，以便在服务器重新启动时启动服务。

1
$ chkconfig --add mongod
四，启动mongodb

通过以下命令来进行启动mongodb。

1
$ service mongod {start|stop|restart|status}
启动服务：

1
$ service mongod start
 启动成功之后通过简单地输入Mongo来使用Mongo shell进行连接。检查你的版本:

输入以下命令：

1
> version()