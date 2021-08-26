# [Redis总结（二）C#中如何使用redis](https://www.cnblogs.com/zhangweizhong/p/4972348.html)

　上一篇讲述了安装redis《[Redis总结（一）Redis安装](http://www.cnblogs.com/zhangweizhong/p/4969240.html)》，同时也大致介绍了redis的优势和应用场景。本篇着重讲解.NET中如何使用redis和C#。

 

　　Redis官网提供了很多开源的C#客户端。例如，Nhiredis ，ServiceStack.Redis ，StackExchange.Redis等。其中ServiceStack.Redis应该算是比较流行的。它提供了一整套从Redis数据结构都强类型对象转换的机制并将对象json序列化。所以这里只介绍ServiceStack.Redis，它也是目前我们产品中所使用的客户端。 

 

　　**ServiceStack.Redis地址**：https://github.com/ServiceStack/ServiceStack.Redis 

 

　　1. 建立一个控制台应用程序，并引用以下ServiceStack.Redis相关的四个类库。或者通过Nuget进行安装Redis常用组件ServiceStack.Redis。 [下载示例代码](http://files.cnblogs.com/files/zhangweizhong/Weiz.Redis.rar)。

   ![img](https://images2015.cnblogs.com/blog/306976/201511/306976-20151117172328499-185312386.png)

 

　　2. 创建一个Redis操作的公用类RedisCacheHelper，

[+ View Code](https://www.cnblogs.com/zhangweizhong/p/4972348.html#)

　　说明：RedisCacheHelper 使用的是客户端链接池模式，这样的存取效率应该是最高的。同时也更方便的支持读写分离，均衡负载。

 

　　3. 配置文件

```
​````"SessionExpireMinutes"` `value=``"180"` `/>```"redis_server_session"` `value=``"127.0.0.1:6379"` `/>```"redis_max_read_pool"` `value=``"3"` `/>```"redis_max_write_pool"` `value=``"1"` `/>```
```

　

　　4. 测试程序调用

```
`class` `Program``  ``{``    ``static` `void` `Main(``string``[] args)``    ``{``      ``Console.WriteLine(``"Redis写入缓存：zhong"``);` `      ``RedisCacheHelper.Add(``"zhong"``, ``"zhongzhongzhong"``, DateTime.Now.AddDays(1));` `      ``Console.WriteLine(``"Redis获取缓存：zhong"``);` `      ``string` `str3 = RedisCacheHelper.Get<``string``>(``"zhong"``);` `      ``Console.WriteLine(str3);` `      ``Console.WriteLine(``"Redis获取缓存：nihao"``);``      ``string` `str = RedisCacheHelper.Get<``string``>(``"nihao"``);``      ``Console.WriteLine(str);` `      ``Console.WriteLine(``"Redis获取缓存：wei"``);``      ``string` `str1 = RedisCacheHelper.Get<``string``>(``"wei"``);``      ``Console.WriteLine(str1);` `      ``Console.ReadKey();``    ``}``  ``}`
```

　　

　　5. 输出结果

 　　　![img](https://images2015.cnblogs.com/blog/306976/201511/306976-20151117172305483-1447643583.png)