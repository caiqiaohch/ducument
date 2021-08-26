# [Redis总结（三）Redis 的主从复制](https://www.cnblogs.com/zhangweizhong/p/4980639.html)

　　Redis跟MySQL一样，拥有非常强大的主从复制功能，而且还支持一个master可以拥有多个slave，而一个slave又可以拥有多个slave，从而形成强大的多级服务器集群架构。
　　　　　　　　　![img](H:\ducument\redis\category\img\306976-20151120150511061-1828785452.png)
　　redis的主从复制是异步进行的，它不会影响master的运行，所以不会降低redis的处理性能。主从架构中，可以考虑关闭Master的数据持久化功能，只让Slave进行持久化，这样可以提高主服务器的处理性能。同时Slave为只读模式，这样可以避免Slave缓存的数据被误修改。

　　**1.配置**

　　　　实际生产中，主从架构是在几个不同服务器上安装相应的Redis服务。为了测试方便，我这边的主从备份的配置，都是在我Windows 本机上测试。

　　　　1. 安装两个Redis 实例，Master和Slave。将Master端口设置为6379，Slave 端口设置为6380 。bind 都设置为：127.0.0.1。 具体Redis安装步骤，请参考前一篇博文 《[Redis总结（一）Redis安装](http://www.cnblogs.com/zhangweizhong/p/4969240.html)》。

　　　　![img](H:\ducument\redis\category\img\306976-20151120150606890-2125169644.png)

　　　　2. 在Slave 实例 ，增加：slaveof 127.0.0.1 6379 配置。如下图所示:

　　　　![img](H:\ducument\redis\category\img\306976-20151223154814484-2008387883.jpg)

 

　　　　配置完成之后，启动这两个实例，如果输出如下内容，说明主从复制的架构已经配置成功了。

　　　　![img](H:\ducument\redis\category\img\306976-20151120150708749-1279080080.png)

 

　　　　注意：在同一台电脑上测试，Master和Slave的端口不要一样，否则是不能同时启动两个实例的。

　　**2.测试**

　　　　在命令行，分别连接上Master服务器和Slave 服务器。然后在Master 写入缓存，然后在Slave 中读取。如下图所示：

　　　　　![img](H:\ducument\redis\category\img\306976-20151120150848108-1238440310.png)
　

  **3.C#中调用**

　　　　主从架构的Redis的读写其实和单台Redis 的读写差不多，只是部分配置和读取区分了主从，如果不清楚C#中如何使用redis，请参考我这篇文章 《[Redis总结（二）C#中如何使用redis](http://www.cnblogs.com/zhangweizhong/p/4972348.html)》。

　　　　需要注意的是：ServiceStack.Redis 中GetClient()方法，只能拿到Master redis中获取连接，而拿不到slave 的readonly连接。这样 slave起到了冗余备份的作用，读的功能没有发挥出来，如果并发请求太多的话，则Redis的性能会有影响。

　　　　所以，我们需要的写入和读取的时候做一个区分，写入的时候，调用client.GetClient() 来获取writeHosts的Master的redis 链接。读取，则调用client.GetReadOnlyClient()来获取的readonlyHost的 Slave的redis链接。

　　　　或者可以直接使用client.GetCacheClient() 来获取一个连接，他会在写的时候调用GetClient获取连接，读的时候调用GetReadOnlyClient获取连接，这样可以做到读写分离，从而利用redis的主从复制功能。

　　　　1. 配置文件 app.config

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
    <!-- redis Start   -->
    <add key="SessionExpireMinutes" value="180" />
    <add key="redis_server_master_session" value="127.0.0.1:6379" />
    <add key="redis_server_slave_session" value="127.0.0.1:6380" />
    <add key="redis_max_read_pool" value="300" />
    <add key="redis_max_write_pool" value="100" />
    <!--redis end-->
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

　　　　2. Redis操作的公用类RedisCacheHelper

![img](https://images.cnblogs.com/OutliningIndicators/ExpandedBlockStart.gif)

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Web;
using ServiceStack.Common.Extensions;
using ServiceStack.Redis;
using ServiceStack.Logging;

namespace Weiz.Redis.Common 
{
    public class RedisCacheHelper
    {
        private static readonly PooledRedisClientManager pool = null;
        private static readonly string[] writeHosts = null;
        private static readonly string[] readHosts = null;
        public static int RedisMaxReadPool = int.Parse(ConfigurationManager.AppSettings["redis_max_read_pool"]);
        public static int RedisMaxWritePool = int.Parse(ConfigurationManager.AppSettings["redis_max_write_pool"]);
        static RedisCacheHelper()
        {
            var redisMasterHost = ConfigurationManager.AppSettings["redis_server_master_session"];
            var redisSlaveHost = ConfigurationManager.AppSettings["redis_server_slave_session"];

            if (!string.IsNullOrEmpty(redisMasterHost))
            {
                writeHosts = redisMasterHost.Split(',');
                readHosts = redisSlaveHost.Split(',');

                if (readHosts.Length > 0)
                {
                    pool = new PooledRedisClientManager(writeHosts, readHosts,
                        new RedisClientManagerConfig()
                        {
                            MaxWritePoolSize = RedisMaxWritePool,
                            MaxReadPoolSize = RedisMaxReadPool,
                            
                            AutoStart = true
                        });
                }
            }
        }
        public static void Add<T>(string key, T value, DateTime expiry)
        {
            if (value == null)
            {
                return;
            }

            if (expiry <= DateTime.Now)
            {
                Remove(key);

                return;
            }

            try
            {
                if (pool != null)
                {
                    using (var r = pool.GetClient())
                    {
                        if (r != null)
                        {
                            r.SendTimeout = 1000;
                            r.Set(key, value, expiry - DateTime.Now);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = string.Format("{0}:{1}发生异常!{2}", "cache", "存储", key);
            }

        }

        public static void Add<T>(string key, T value, TimeSpan slidingExpiration)
        {
            if (value == null)
            {
                return;
            }

            if (slidingExpiration.TotalSeconds <= 0)
            {
                Remove(key);

                return;
            }

            try
            {
                if (pool != null)
                {
                    using (var r = pool.GetClient())
                    {
                        if (r != null)
                        {
                            r.SendTimeout = 1000;
                            r.Set(key, value, slidingExpiration);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = string.Format("{0}:{1}发生异常!{2}", "cache", "存储", key);
            }

        }



        public static T Get<T>(string key)
        {
            if (string.IsNullOrEmpty(key))
            {
                return default(T);
            }

            T obj = default(T);

            try
            {
                if (pool != null)
                {
                    using (var r = pool.GetClient())
                    {
                        if (r != null)
                        {
                            r.SendTimeout = 1000;
                            obj = r.Get<T>(key);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = string.Format("{0}:{1}发生异常!{2}", "cache", "获取", key);
            }


            return obj;
        }

        public static void Remove(string key)
        {
            try
            {
                if (pool != null)
                {
                    using (var r = pool.GetClient())
                    {
                        if (r != null)
                        {
                            r.SendTimeout = 1000;
                            r.Remove(key);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = string.Format("{0}:{1}发生异常!{2}", "cache", "删除", key);
            }

        }

        public static bool Exists(string key)
        {
            try
            {
                if (pool != null)
                {
                    using (var r = pool.GetClient())
                    {
                        if (r != null)
                        {
                            r.SendTimeout = 1000;
                            return r.ContainsKey(key);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = string.Format("{0}:{1}发生异常!{2}", "cache", "是否存在", key);
            }

            return false;
        }

        public static IDictionary<string, T> GetAll<T>(IEnumerable<string> keys) where T : class
        {
            if (keys == null)
            {
                return null;
            }

            keys = keys.Where(k => !string.IsNullOrWhiteSpace(k));

            if (keys.Count() == 1)
            {
                T obj = Get<T>(keys.Single());

                if (obj != null)
                {
                    return new Dictionary<string, T>() { { keys.Single(), obj } };
                }

                return null;
            }

            if (!keys.Any())
            {
                return null;
            }

            IDictionary<string, T> dict = null;

            if (pool != null)
            {
                keys.Select(s => new
                {
                    Index = Math.Abs(s.GetHashCode()) % readHosts.Length,
                    KeyName = s
                })
                .GroupBy(p => p.Index)
                .Select(g =>
                {
                    try
                    {
                        using (var r = pool.GetClient(g.Key))
                        {
                            if (r != null)
                            {
                                r.SendTimeout = 1000;
                                return r.GetAll<T>(g.Select(p => p.KeyName));
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        string msg = string.Format("{0}:{1}发生异常!{2}", "cache", "获取", keys.Aggregate((a, b) => a + "," + b));
                    }
                    return null;
                })
                .Where(x => x != null)
                .ForEach(d =>
                {
                    d.ForEach(x =>
                    {
                        if (dict == null || !dict.Keys.Contains(x.Key))
                        {
                            if (dict == null)
                            {
                                dict = new Dictionary<string, T>();
                            }
                            dict.Add(x);
                        }
                    });
                });
            }

            IEnumerable<Tuple<string, T>> result = null;

            if (dict != null)
            {
                result = dict.Select(d => new Tuple<string, T>(d.Key, d.Value));
            }
            else
            {
                result = keys.Select(key => new Tuple<string, T>(key, Get<T>(key)));
            }

            return result
                .Select(d => new Tuple<string[], T>(d.Item1.Split('_'), d.Item2))
                .Where(d => d.Item1.Length >= 2)
                .ToDictionary(x => x.Item1[1], x => x.Item2);
        }
    }
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 