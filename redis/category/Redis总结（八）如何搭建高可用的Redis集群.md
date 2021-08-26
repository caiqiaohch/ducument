# [Redis总结（八）如何搭建高可用的Redis集群](https://www.cnblogs.com/zhangweizhong/p/11301869.html)



以前总结Redis 的一些基本的安装和使用，大家可以这这里查看Redis 系列文章：https://www.cnblogs.com/zhangweizhong/category/771056.html。

今天补一下redis集群功能吧。需要注意，Redis 3.0 以后才有集群的功能，下载Redis的时候注意下版本。 



## 1. Redis集群原理

先看看redis-cluster架构图：

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190805105724315-1041896247.png)

架构细节:

(1)所有的redis节点彼此互联(PING-PONG机制)，内部使用二进制协议优化传输速度和带宽。

(2)节点的fail是通过集群中超过半数的节点检测失效时才生效。

(3)客户端与redis节点直连，不需要中间proxy层，客户端不需要连接集群所有节点，连接集群中任何一个可用节点即可。

(4)redis-cluster把所有的物理节点映射到[0-16383]slot（哈希槽）上，cluster 负责维护node<->slot<->value。

Redis 集群中内置了 16384 个slot（哈希槽），当需要在 Redis 集群中放置一个 key-value 时，redis 先对 key 使用 crc16 算法算出一个结果，然后把结果对 16384 求余数，这样每个 key 都会对应一个编号在 0-16383 之间的哈希槽，redis 会根据节点数量大致均等的将哈希槽映射到不同的节点。

 

### 容错机制： redis-cluster投票

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190805105818198-641254516.png)

 

(1)领着投票过程是集群中所有master参与,如果半数以上master节点与master节点通信超过(cluster-node-timeout),认为当前master节点挂掉.

(2):什么时候整个集群不可用(cluster_state:fail)? 

  a:如果集群任意master挂掉,且当前master没有slave.集群进入fail状态,也可以理解成集群的slot映射[0-16383]不完成时进入fail状态. 

  b:如果集群超过半数以上master挂掉，无论是否有slave集群进入fail状态.

 注意：1. 当集群不可用时,所有对集群的操作做都不可用，收到((error) CLUSTERDOWN The cluster is down)错误。

 　　 2. redis-3.0.0.rc1加入cluster-require-full-coverage参数，默认关闭，打开改配置，允许集群兼容部分失败。

 

## 2. 安装Redis

redis 的单机安装之前已经讲过，网络上也有很多教程，这里就不重复了。

文章最后提供了Redis 3.0 的源码，Redis集群脚本等资源。大家可以用我提供的版本来测试。

 

## 3. 安装ruby环境

redis3.0 源码中自带的集群管理工具redis-trib.rb依赖ruby环境，首先需要安装ruby环境：

\1. 安装ruby环境

```
yum install ruby

yum install rubygems   
```

 

\2. 安装ruby和redis的接口程序

拷贝redis-3.0.0.gem至/usr/local下

执行：gem install /usr/local/redis-3.0.0.gem

 

## 4. 创建集群

### 集群结点规划

一般Redis集群的实例，都安装在各个主从服务器上，这里为了演示方便，只是在同一台服务器用不同的端口表示不同的redis服务器，如下：

主节点：172.16.0.17:7001，172.16.0.17:7002，172.16.0.17:7003

从节点：172.16.0.17:7004，172.16.0.17:7005，172.16.0.17:7006

\1. 在/usr/local下创建redis-cluster目录，其下创建Redis01到Redis06等6个redis实例，端口号为：7001-7006，具体目录如下：

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190805111546018-299902340.png)

 

\2. 将redis源码目录src下的**redis-trib.rb**拷贝到redis-cluster目录下。

 

\3. 修改每个redis实例的redis.conf配置文件：

```
port 7001  //这里要改成各个实例对应的端口，7001-7006
#bind 172.16.0.17
cluster-enabled yes
```

 

### 启动每个结点redis服务

分别进入Redis01、Redis02、...Redis06目录，执行：

```
./redis-server ./redis.conf
```

 

查看redis进程：ps aux|grep redis

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190805112601872-1375959460.png)

以上，Redis 的6个实例，就已经启动了。

 

### 执行创建集群命令

执行**redis-trib.rb**，此脚本是ruby脚本，它依赖ruby环境。

```
./redis-trib.rb create --replicas 1 172.16.0.17:7001 172.16.0.17:7002 172.16.0.17:7003 172.16.0.17:7004 172.16.0.17:7005  172.16.0.17:7006
```

说明：

redis集群至少需要3个主节点，每个主节点有一个从节点总共6个节点

replicas指定为1表示每个主节点有一个从节点

 

注意：

如果执行时报如下错误：

[ERR] Node XXXXXX is not empty. Either the node already knows other nodes (check with CLUSTER NODES) or contains some key in database 0

解决方法是删除生成的配置文件nodes.conf，如果不行则说明现在创建的结点包括了旧集群的结点信息，需要删除redis的持久化文件后再重启redis，比如：appendonly.aof、dump.rdb

 

创建集群输出如下：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
>>> Creating cluster

Connecting to node 172.16.0.17:7001: OK

Connecting to node 172.16.0.17:7002: OK

Connecting to node 172.16.0.17:7003: OK

Connecting to node 172.16.0.17:7004: OK

Connecting to node 172.16.0.17:7005: OK

Connecting to node 172.16.0.17:7006: OK

>>> Performing hash slots allocation on 6 nodes...

Using 3 masters:

172.16.0.17:7001

172.16.0.17:7002

172.16.0.17:7003

Adding replica 172.16.0.17:7004 to 172.16.0.17:7001

Adding replica 172.16.0.17:7005 to 172.16.0.17:7002

Adding replica 172.16.0.17:7006 to 172.16.0.17:7003

M: cad9f7413ec6842c971dbcc2c48b4ca959eb5db4 172.16.0.17:7001

   slots:0-5460 (5461 slots) master

M: 4e7c2b02f0c4f4cfe306d6ad13e0cfee90bf5841 172.16.0.17:7002

   slots:5461-10922 (5462 slots) master

M: 1a8420896c3ff60b70c716e8480de8e50749ee65 172.16.0.17:7003

   slots:10923-16383 (5461 slots) master

S: 69d94b4963fd94f315fba2b9f12fae1278184fe8 172.16.0.17:7004

   replicates cad9f7413ec6842c971dbcc2c48b4ca959eb5db4

S: d2421a820cc23e17a01b597866fd0f750b698ac5 172.16.0.17:7005

   replicates 4e7c2b02f0c4f4cfe306d6ad13e0cfee90bf5841

S: 444e7bedbdfa40714ee55cd3086b8f0d5511fe54 172.16.0.17:7006

   replicates 1a8420896c3ff60b70c716e8480de8e50749ee65

Can I set the above configuration? (type 'yes' to accept): yes

>>> Nodes configuration updated

>>> Assign a different config epoch to each node

>>> Sending CLUSTER MEET messages to join the cluster

Waiting for the cluster to join...

>>> Performing Cluster Check (using node 172.16.0.17:7001)

M: cad9f7413ec6842c971dbcc2c48b4ca959eb5db4 172.16.0.17:7001

   slots:0-5460 (5461 slots) master

M: 4e7c2b02f0c4f4cfe306d6ad13e0cfee90bf5841 172.16.0.17:7002

   slots:5461-10922 (5462 slots) master

M: 1a8420896c3ff60b70c716e8480de8e50749ee65 172.16.0.17:7003

   slots:10923-16383 (5461 slots) master

M: 69d94b4963fd94f315fba2b9f12fae1278184fe8 172.16.0.17:7004

   slots: (0 slots) master

   replicates cad9f7413ec6842c971dbcc2c48b4ca959eb5db4

M: d2421a820cc23e17a01b597866fd0f750b698ac5 172.16.0.17:7005

   slots: (0 slots) master

   replicates 4e7c2b02f0c4f4cfe306d6ad13e0cfee90bf5841

M: 444e7bedbdfa40714ee55cd3086b8f0d5511fe54 172.16.0.17:7006

   slots: (0 slots) master

   replicates 1a8420896c3ff60b70c716e8480de8e50749ee65

[OK] All nodes agree about slots configuration.

>>> Check for open slots...

>>> Check slots coverage...

[OK] All 16384 slots covered.
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

## 5. 查询集群信息

集群创建成功登陆任意redis结点查询集群中的节点情况。

客户端以集群方式登陆：

```
./redis-cli -c -h 172.16.0.17 -p 7001 -c //其中-c表示以集群方式连接redis，-h指定ip地址，-p指定端口号
```

 

查询集群信息

cluster nodes 查询集群结点信息

![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190805191325252-986668820.png)

 

cluster info 查询集群状态信息

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190805191301477-1080268523.png)

 

 

## 6. 添加主节点

集群创建成功后可以向集群中添加节点，下面是添加一个master主节点

\1. 增加Redis07实例，参考集群结点规划章节添加一个“7007”目录作为新节点。

 

\2. 将Redis07实例添加到集群中，执行下边命令：

```
./redis-trib.rb add-node  172.16.0.17:7007 172.16.0.17:7001
```

 

\3. 查看集群结点发现7007已添加到集群中：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
[root@VM_0_17_centos redis-cluster]# ./redis-trib.rb add-node  172.16.0.17:7007 172.16.0.17:7001
>>> Adding node 172.16.0.17:7007 to cluster 172.16.0.17:7001
Connecting to node 172.16.0.17:7001: OK
...Connecting to node 172.16.0.17:7003: OK
Connecting to node 172.16.0.17:7005: OK
Connecting to node 172.16.0.17:7002: OK
Connecting to node 172.16.0.17:7006: OK
Connecting to node 172.16.0.17:7004: OK
>>> Performing Cluster Check (using node 172.16.0.17:7001)
M: 977962f18ec51f363747961137dc903f0078b248 172.16.0.17:7001
   slots:0-5460 (5461 slots) master
   1 additional replica(s)
M: defe4ce0421ee6b50bdab3da58754e98cc80fca3 172.16.0.17:7003
   slots:10923-16383 (5461 slots) master
   1 additional replica(s)
S: a64fc273c0b90700397f5bac2b393dc5587d8ba8 172.16.0.17:7005
   slots: (0 slots) slave
   replicates f277758189eba36c5b5732e9189d8554bf4385cb
M: f277758189eba36c5b5732e9189d8554bf4385cb 172.16.0.17:7002
   slots:5461-10922 (5462 slots) master
   1 additional replica(s)
S: 4f16e5adcc141ca284d4a9ec6d04f455aee84a48 172.16.0.17:7006
   slots: (0 slots) slave
   replicates defe4ce0421ee6b50bdab3da58754e98cc80fca3
S: 479d5a077893184cd0b05a8e1b6cb5c0625215f4 172.16.0.17:7004
   slots: (0 slots) slave
   replicates 977962f18ec51f363747961137dc903f0078b248
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
Connecting to node 172.16.0.17:7007: OK...
>>> Send CLUSTER MEET to node 172.16.0.17:7007 to make it join the cluster.
[OK] New node added correctly.
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

### 哈希槽重新分配

添加完主节点后，集群并不会自动给新添加的节点分配哈希槽，需要我们手动对主节点进行hash槽分配重新分配，这样该主节才可以存储数据。

redis集群有16384个槽，集群中的每个结点分配自已槽，通过查看集群结点可以看到槽占用情况。可以看到刚才添加的主节点Redis07，没有分配哈希槽（slot）。

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190806154723205-1887940089.png)

 

 下面就来说说如何给刚添加的Redis01结点分配槽：

第一步：连接上集群

```
./redis-trib.rb reshard 172.16.0.17:7001   //（连接集群中任意一个可用结点都行）
```

 

第二步：输入要分配的槽数量

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190806155700784-2005911659.png)

 

第三步：输入接收槽的结点id

![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190806160534198-221148114.png)

这里准备给Redis07分配哈希槽，通过cluster nodes查看Redis07节点id为：e8461f9743e186ae8f67ed301d2d971186b1cc93

输入：e8461f9743e186ae8f67ed301d2d971186b1cc93，

 

第四步：输入源结点id

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190806160145598-739701478.png)

如果只是想从单个主节点获取哈希槽，那直接输入相应的节点id即可。

如果想从所有的主节点获取输入：all，

 

第五步：输入yes开始移动槽到目标结点id

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190806160828723-1153029467.png)

 

第六步：分配完成之后，可以查询集群节点信息，查看哈希槽是否分配成功。

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190806185401425-615985010.png)

 

 

## 7. 添加从节点

集群创建成功后可以向集群中添加节点，下面是添加一个slave从节点的命令。

```
./redis-trib.rb add-node --slave --master-id 主节点id 添加节点的ip和端口 集群中已存在节点ip和端口
```

 

\1. 添加Redis08实例为从结点，将Redis08作为Redis07的从结点。

执行如下命令：

```
./redis-trib.rb add-node --slave --master-id e8461f9743e186ae8f67ed301d2d971186b1cc93  172.16.0.17:7008 172.16.0.17:7001
```

e8461f9743e186ae8f67ed301d2d971186b1cc93 是Redis07实例的节点id，可通过cluster nodes查看。

 

注意：如果原来该结点在集群中的配置信息已经生成集群节点的配置文件（如果集群配置cluster-config-file默认指定则为nodes.conf），这时可能会报错：

[ERR] Node XXXXXX is not empty. Either the node already knows other nodes (check with CLUSTER NODES) or contains some key in database 0

解决方法是：删除生成的配置文件nodes.conf，删除后再执行**./redis-trib.rb add-node**指令

 

\2. 查看集群中的结点，刚添加的Redis08已经成为Redis07的从节点：

 ![img](https://img2018.cnblogs.com/blog/306976/201908/306976-20190806181922353-1181908652.png)

 

## 8. 删除结点：

集群创建成功后可以向集群中删除其中的一个节点，应该怎么删除呢？

执行如下命令即可：

```
./redis-trib.rb del-node 172.16.0.17 :7005 e8461f9743e186ae8f67ed301d2d971186b1cc93
```

注意：删除已经分配了有hash槽的节点会失败，报错如下：

[ERR] Node 172.16.0.17:7007 is not empty! Reshard data away and try again.

解决办法就是：将该结点占用的hash槽分配出去，请参考前面哈希槽重新分配的操作，这里就不重复了。

 

## 最后

以上就已经将如何搭建redis的集群讲完了。

redis3.0源码和ruby脚本，[点击这里下载](https://files.cnblogs.com/files/zhangweizhong/redis集群.rar)。