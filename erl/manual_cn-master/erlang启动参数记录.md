erlang启动参数记录

erlang启动参数记录
　　不管在erlang的shell下还是脚本里，启动参数都是非常有用的，抽空儿整理下erlang的常用启动参数：

+A size   异步线程池的线程数，范围为0~1024，默认为10

+P Number|legacy   最大进程数，范围为1024-134217727 ，默认为  262144

+K true | false  是否启用的kernel的poll机制，默认为false

-config Config  加载指定的配置文件，config.config

-heart  开启erlang的心跳检测 

　　 这里细说下这个参数：% erl -heart ... 开启心跳监测，默认为60s;

　　　　　还有一种是 % erl -heart -env HEART_BEAT_TIMEOUT 30 ... 如果这里添加 -env HEART_BEAT_TIMEOUT 30 参数，可修改心跳监测时间，范围为：10 < X <= 65535(s).

还有一个参数是：% erl -heart -env ERL_CRASH_DUMP_SECONDS (0、1、seconds)三种情况，用于分析dump文件.

　　　　

-name Name  运行分布式节点名

-setcookie Cookie  在一个分布式集群中，不同节点间设置同一个cookie，保证节点互联

-boot File  用来启动系统，一般设置为start_sasl

-env Variable Value  用来设置宿主系统环境变量

+W w | i  设置error_logger的告警信息，+W w 为waring  +W i 为info report

+e Number 设置最大ets表数量  没有设置默认1400  可设置 ERL_MAX_ETS_TABLES,用 -env ERL_MAX_ETS_TABLES

-pa Dir1 Dir2 ...  添加指定代码目录由开始代码的路径 ，如：code:add_pathsa/1

-pz Dir1 Dir2 ...  添加指定的目录的代码路径的末端 ，如：code：pathsz/1

-remsh Node  启动远程节点

 

## Increase number of concurrent ports/sockets
-env ERL_MAX_PORTS 4096

## Tweak GC to run more often
-env ERL_FULLSWEEP_AFTER 10

-env ERL_MAX_ETS_TABLES 200000

18904086003

 +sbt db        
 +sub true                                         %% R17版本之后，调度器测量 （多核平均分配cpu）

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
erlang 默认启动参数更多的是针对电信平台实时特性，简单调整参数能很大程度降低CPU消耗，提高处理能力。

1. 关闭spin_wait

　　设置参数：+sbwt none

erlang 调度器CPU利用率低排查，关闭spin_wait 可能增加了调度器需要唤醒延时。

关闭后CPU 基本能够简单30%以上，且几乎没有任何副作用，调度器唤醒微妙级，延时可忽略。

 

2. 调度器唤醒策略

　　默认设置：+swt medium

　　默认设置下，长时间运行后部分node运行进入一种非正常状态，如：不管高峰还是低峰，cpu 200%一条直线，且在高峰期间处理不过来，造成timeout，

　　也就是说，除了前两个调度器，后面的调度器都睡死了，业务大量堆积也无法唤醒。

　　

　　解决方案：

　　1. 定时维护性重启，当然业务允许的话，对于类似长连接服务就不行了

　　2. 调整：+swt low （whatsapp ppt 中提到），CPU占用稍高

　　3. 使用R17 +sub true，保证每个调度器业务平均

 

　　当然： +swt very_high 能够再次降低30%+ 的cpu

　　同时也很大程度增加 调度器睡死的几率，会不会睡死看业务服务状态，可以观察，对性能提升还是很有帮助的。