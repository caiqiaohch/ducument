1.2.1存储结构
    ●字符串类型
    ●散列类型
    ●列表类型
    ●集合类型
    ●有序集合类型

1. Redis可以为每个键设置生存时间（Time To Live，TTL），生存时间到期后键会自动被删
除。这一功能配合出色的性能让Redis可以作为缓存系统来使用，而且由于Redis支持持久化和
丰富的数据类型。
2. Redis是单线程模型
3. Redis还可以限定数据占用的最大内存空间，在数据达到空间限制后可以按照一定的规则自动淘汰不需要的键。
4. 在Redis中要读取键名为post:1的散列类型键的title字段的值：
        HGET post:1 title
5. 可以在Redis运行时通过CONFIG SET命令在不重新启动Redis的情况下动态修改部分Redis配置:
        CONFIG SET loglevel warning
6. 选择1号数据库：
        redis>SELECT 1
        