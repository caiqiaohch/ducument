# [Redis总结（四）Redis 的持久化](https://www.cnblogs.com/zhangweizhong/p/5018775.html)

redis跟memcached类似，都是内存数据库，不过redis支持数据持久化，也就是说redis可以将内存中的数据同步到磁盘来持久化，以确保redis 的数据安全。

 

**redis****持久化的两种方式**

redis提供了两种持久化的方式，分别是RDB（Redis DataBase）和AOF（Append Only File）。

RDB，简而言之，就是将存储的数据快照的方式存储到磁盘上，

AOF，则是将redis执行过的所有写指令记录下来，通过write函数追加到AOF文件的末尾。在下次redis重新启动时，只要把这些写指令从前到后再重复执行一遍，就可以实现数据恢复了。

 

其实RDB和AOF两种方式也可以同时使用，在这种情况下，如果redis重启的话，则会优先采用AOF方式来进行数据恢复，这是因为AOF方式的数据恢复完整度更高。

如果你没有数据持久化的需求，也完全可以关闭RDB和AOF方式，这样的话，redis将变成一个纯内存数据库，就像memcache一样。

 

**RDB**

RDB（Redis DataBase），是将redis某一时刻的数据持久化到磁盘中，是一种快照式的持久化方法。默认的文件名为dump.rdb。

redis在进行数据持久化的过程中，会先将数据写入到一个临时文件中，待持久化过程都结束了，才会用这个临时文件替换上次持久化好的文件，以确保数据完整可用。

**RDB的持久化配置**

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
# 时间策略
save 900 1
save 300 10
save 60 10000

# 文件名称
dbfilename dump.rdb

# 文件保存路径
dir /home/work/app/redis/data/

# 如果持久化出错，主进程是否停止写入
stop-writes-on-bgsave-error yes

# 是否压缩
rdbcompression yes

# 导入时是否检查
rdbchecksum yes　　 　　
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

配置其实非常简单，这里说一下持久化的时间策略具体是什么意思。

- `save 900 1` 表示900s内如果有1条是写入命令，就触发产生一次快照，可以理解为就进行一次备份
- `save 300 10` 表示300s内有10条写入，就产生快照

下面的类似，那么为什么需要配置这么多条规则呢？因为Redis每个时段的读写请求肯定不是均衡的，为了平衡性能与数据安全，我们可以自由定制什么情况下触发备份。所以这里就是根据自身Redis写入情况来进行合理配置。

**`stop-writes-on-bgsave-error yes`** 这个配置也是非常重要的一项配置，这是当备份进程出错时，主进程就停止接受新的写入操作，是为了保护持久化的数据一致性问题。**如果自己的业务有完善的监控系统，可以禁止此项配置，** 否则请开启。

关于压缩的配置 **`rdbcompression yes`** ，建议没有必要开启，毕竟Redis本身就属于CPU密集型服务器，再开启压缩会带来更多的CPU消耗，相比硬盘成本，CPU更值钱。

当然如果你想要禁用RDB配置，也是非常容易的，只需要在save的最后一行写上：`save ""`

```
　
```

 

**AOF**

AOF（Append Only File），即只允许追加不允许改写的文件。

Redis会将收到的每一个写操作（如SET等）通过write函数追加到AOF文件的末尾。默认的AOF持久化策略是每秒钟fsync一次（把缓存中的写指令记录到磁盘中）。当Redis重启时会通过重新执行文件中保存的写命令来在内存中重建整个数据库的内容。

**AOF的持久化配置**

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
# 是否开启aof
appendonly yes

# 文件名称
appendfilename "appendonly.aof"

# 同步方式
appendfsync everysec

# aof重写期间是否同步
no-appendfsync-on-rewrite no

# 重写触发配置
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# 加载aof时如果有错如何处理
aof-load-truncated yes

# 文件重写策略
aof-rewrite-incremental-fsync yes
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

还是重点解释一些关键的配置：

`appendfsync everysec` 它其实有三种模式:

- always：把每个写命令都立即同步到aof，很慢，但是很安全
- everysec：每秒同步一次，是折中方案
- no：redis不处理交给OS来处理，非常快，但是也最不安全

一般情况下都采用 **everysec** 配置，这样可以兼顾速度与安全，最多损失1s的数据。

**`aof-load-truncated yes`** 如果该配置启用，在加载时发现aof尾部不正确是，会向客户端写入一个log，但是会继续执行，如果设置为 `no` ，发现错误就会停止，必须修复后才能重新加载。

 

但AOF方式是将所有的命令记录下来，所以AOF文件要比RDB文件的体积大。而且，恢复速度也要慢于RDB方式。

redis提供了bgrewriteaof命令，会重新生成一个全新的AOF文件，其中便包括了可以恢复现有数据的最少的命令集。

 需要注意到是重写aof文件的操作，并没有读取旧的aof文件，而是将整个内存中的数据库内容用命令的方式重写了一个新的aof文件，这点和快照有点类似。

 

**如何选择RDB和AOF**

对于我们应该选择RDB还是AOF，取决于具体的应用场景，官方的建议是两个同时使用。这样可以提供更可靠的持久化方案。