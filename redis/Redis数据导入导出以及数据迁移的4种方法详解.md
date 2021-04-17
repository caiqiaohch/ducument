Redis数据导入导出以及数据迁移的4种方法详解
1、aof 导入方式。
因为这种方式比较简单，所以我就先介绍它。

分两步来实现，第一步先让源 Redis 生成 AOF 数据文件。

# 清空上文目标实例全部数据
redis-cli -h 目标RedisIP -a password flushall
# 源实例开启 aof 功能，将在 dir 目录下生成 appendonly.aof 文件
redis-cli -h 源RedisIP -a password config set appendonly yes
dir 目录，可以通过 config get dir 目录获得。

config get dir
# 比如我的 Mac 上执行上面的命令后，返回如下内容
1) "dir"
2) "/usr/local/var/db/redis"
通过上面的命令，我们可以看到我本地的 dir 目录是：/usr/local/var/db/redis。

现在我们来做第二步操作，让目标 Redis 实例导入 aof 数据。

# 将 appendonly.aof 文件放在当前路径下
redis-cli -h 目标RedisIp -a password --pipe < appendonly.aof
# 源实例关闭 aof 功能
redis-cli -h 源RedisIp -a password config set appendonly no
上面的第一个命令，执行后，如果出现以下内容，则表示导入 aof 数据成功。

All data transferred. Waiting for the last reply...
Last reply received from server.
errors: 0, replies: 5
我这里是测试，数据比较少，所以提示有 5 个导入成功了。

AOF 的缺点也很明显，就是速度慢，并且如果内容多的话，文件也比较大。而且开启 AOF 后，QPS 会比 RDB 模式写的 QPS 低。还有就是 AOF 是一个定时任务，可能会出现数据丢失的情况。

2、通过我的 xttblog_redis_mv.sh 脚本来实现。
我的脚本内容如下：

#!/bin/bash
 
#redis 源ip
src_ip=192.168.1.4
#redis 源port
src_port=6379
 
#redis 目的ip
dest_ip=127.0.0.1
#redis 目的port
dest_port=6389
 
#要迁移的key前缀
key_prefix=
 
i=1
 
redis-cli -h $src_ip -p $src_port -a password keys "${key_prefix}*" | while read key
do
  redis-cli -h $dest_ip -p $dest_port -a password del $key
  redis-cli -h $src_ip -p $src_port -a password --raw dump $key | perl -pe 'chomp if eof' | redis-cli -h $dest_ip -p $dest_port -a password -x restore $key 0
  echo "$i migrate key $key"
  ((i++))
done
大家在使用的时候，只需要替换 IP 即可。

这个脚本同样有一个问题就是使用了 keys *，然后一个一个遍历，如果是生产环境，不建议这样使用！当然我的脚本也是可以再进行优化的！

3、使用 redis-dump 工具。

Redis-Dump 是一个用于 Redis 数据导入 / 导出的工具，是基于 Ruby 实现的,可以方便的进行 redis 的数据备份。这个工具需要先安装，以我的 Mac 为例，安装教程如下：

# 没安装 ruby 的话，先安装 ruby
brew install ruby
# 移除 gem 自带源
gem sources --remove https://rubygems.org/ 
# 添加淘宝源
gem sources -a https://ruby.taobao.org/ 
# 安装 redis-dump
gem install redis-dump -V
目前我发现，淘宝的镜像已经出现 bad response Not Found 404 了，被告知镜像维护站点已迁往 Ruby China 镜像。

# 替换镜像地址
gem sources --add http://gems.ruby-china.org/ --remove http://rubygems.org/
# 确认镜像地址是否替换成功
gem sources -l
# 替换成功后再安装 redis-dump
gem install redis-dump -V
安装完成后，就可以使用 redis-dump 工具进行数据的导入导出了！

# redis-dump 导出
redis-dump -u :password@源RedisIp:6379 > 源Redis数据文件.json
# redis-load 导入
cat 源Redis数据文件.json | redis-load -u :password@目标RedisIp:6379
cat 源Redis数据文件.json | redis-load -u :password@目标RedisIp:6379

Linux 系统或者 Window 系统也都类似，安装 redis-dump 工具完成后直接使用 redis-dump 导出，redis-load 导入即可完成数据的备份与迁移。

redis-dump 工具很强大，建议大家到官网上多看看它的官方文档。

4、rdb 文件迁移
redis-dump 麻烦就麻烦在需要进行安装，如果我的 Redis 已经有备份机制，比如有 rdb 文件，那么我们直接迁移 rdb 文件就可以达到同样的目的。

首先，我们可以先关闭源 Redis 实例的 aof 功能。如果不关闭 aof，Redis 默认用 aof 文件来恢复数据。

# 源实例关闭 aof 功能
redis-cli -h 源RedisIp -a password config set appendonly no
然后使用 save 命令把数据固化到 rdb 文件中。

# 固化数据到 RDB 文件
save
save 完成后，还是通过 config get dir 命令获得保存的 RDB 数据文件位置。

接下来，我们需要杀死 redis 进程。杀掉当前 redis 的进程，否则下一步的复制 rdb 文件，rdb 处于打开的状态，复制的文件，会占用同样的句柄。

kill -9 redis
# 或者
pkill -9 redis
# 或者手段关闭 Redis 服务
然后复制源 redis 的 rdb 文件到目标 Redis 的 dir 数据目录，名字为你要迁移的 redis 的 rdb 文件名。

复制完成后，重启目标 Redis 实例，数据就迁移完成了。 重启完成后可以验证一下数据是否成功的复制了。

更多关于Redis数据导入导出以及数据迁移的方法请查看下面的相关链接
