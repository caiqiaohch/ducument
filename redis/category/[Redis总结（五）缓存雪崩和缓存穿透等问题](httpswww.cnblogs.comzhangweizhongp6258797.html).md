# [Redis总结（五）缓存雪崩和缓存穿透等问题](https://www.cnblogs.com/zhangweizhong/p/6258797.html)

　　前面讲过一些redis 缓存的使用和数据持久化。感兴趣的朋友可以看看之前的文章，http://www.cnblogs.com/zhangweizhong/category/771056.html 。今天总结总结缓存使用过程中遇到的一些常见的问题。比如缓存雪崩，缓存穿透，缓存预热等等。

# **缓存雪崩**

　　缓存雪崩是由于原有缓存失效(过期)，新缓存未到期间。所有请求都去查询数据库，而对数据库CPU和内存造成巨大压力，严重的会造成数据库宕机。从而形成一系列连锁反应，造成整个系统崩溃。

![img](http://p3.pstatp.com/large/pgc-image/133adc7682ff40d19ce420a7ed53759f)

　　1. 碰到这种情况，一般并发量不是特别多的时候，使用最多的解决方案是加锁排队。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
        public object GetProductListNew()
        {
            const int cacheTime = 30;
            const string cacheKey = "product_list";
            const string lockKey = cacheKey;
            
            var cacheValue = CacheHelper.Get(cacheKey);
            if (cacheValue != null)
            {
                return cacheValue;
            }
            else
            {
                lock (lockKey)
                {
                    cacheValue = CacheHelper.Get(cacheKey);
                    if (cacheValue != null)
                    {
                        return cacheValue;
                    }
                    else
                    {
                        cacheValue = GetProductListFromDB(); //这里一般是 sql查询数据。              
                        CacheHelper.Add(cacheKey, cacheValue, cacheTime);
                    }                    
                }
                return cacheValue;
            }
        }    
      
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

　　2. 加锁排队只是为了减轻数据库的压力，并没有提高系统吞吐量。假设在高并发下，缓存重建期间key是锁着的，这是过来1000个请求999个都在阻塞的。同样会导致用户等待超时，这是个治标不治本的方法。

　　还有一个解决办法解决方案是：给每一个缓存数据增加相应的缓存标记，记录缓存的是否失效，如果缓存标记失效，则更新数据缓存。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
　　　　 public object GetProductListNew()
        {
            const int cacheTime = 30;
            const string cacheKey = "product_list";
            //缓存标记。
            const string cacheSign = cacheKey + "_sign";
            
            var sign = CacheHelper.Get(cacheSign);
            //获取缓存值
            var cacheValue = CacheHelper.Get(cacheKey);
            if (sign != null)
            {
                return cacheValue; //未过期，直接返回。
            }
            else
            {
                CacheHelper.Add(cacheSign, "1", cacheTime);
                ThreadPool.QueueUserWorkItem((arg) =>
                {
                    cacheValue = GetProductListFromDB(); //这里一般是 sql查询数据。
                    CacheHelper.Add(cacheKey, cacheValue, cacheTime*2); //日期设缓存时间的2倍，用于脏读。                
                });
                
                return cacheValue;
            }
        } 
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

　　缓存标记：记录缓存数据是否过期，如果过期会触发通知另外的线程在后台去更新实际key的缓存。

　　缓存数据：它的过期时间比缓存标记的时间延长1倍，例：标记缓存时间30分钟，数据缓存设置为60分钟。 这样，当缓存标记key过期后，实际缓存还能把旧数据返回给调用端，直到另外的线程在后台更新完成后，才会返回新缓存。

　　这样做后，就可以一定程度上提高系统吞吐量。

 

**缓存穿透**

　　缓存穿透是指用户查询数据，在数据库没有，自然在缓存中也不会有。这样就导致用户查询的时候，在缓存中找不到，每次都要去数据库再查询一遍，然后返回空。这样请求就绕过缓存直接查数据库，这也是经常提的缓存命中率问题。

![img](http://p9.pstatp.com/large/pgc-image/2fb0e48e753c4cdb84e1f1e210f9c67d)

　　解决的办法就是：如果查询数据库也为空，直接设置一个默认值存放到缓存，这样第二次到缓冲中获取就有值了，而不会继续访问数据库，这种办法最简单粗暴。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
        public object GetProductListNew()
        {
            const int cacheTime = 30;
            const string cacheKey = "product_list";

            var cacheValue = CacheHelper.Get(cacheKey);
            if (cacheValue != null)
                return cacheValue;
                
            cacheValue = CacheHelper.Get(cacheKey);
            if (cacheValue != null)
            {
                return cacheValue;
            }
            else
            {
                cacheValue = GetProductListFromDB(); //数据库查询不到，为空。
                
                if (cacheValue == null)
                {
                    cacheValue = string.Empty; //如果发现为空，设置个默认值，也缓存起来。                
                }
                CacheHelper.Add(cacheKey, cacheValue, cacheTime);
                
                return cacheValue;
            }
        }    
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

　　把空结果，也给缓存起来，这样下次同样的请求就可以直接返回空了，即可以避免当查询的值为空时引起的缓存穿透。同时也可以单独设置个缓存区域存储空值，对要查询的key进行预先校验，然后再放行给后面的正常缓存处理逻辑。

 

**缓存预热**

　　缓存预热就是系统上线后，将相关的缓存数据直接加载到缓存系统。这样避免，用户请求的时候，再去加载相关的数据。

![img](http://p1.pstatp.com/large/pgc-image/77085a460ef24405b668f7274593c181)

　　解决思路：

　　　　1，直接写个缓存刷新页面，上线时手工操作下。

　　　　2，数据量不大，可以在WEB系统启动的时候加载。

　　　　3，定时刷新缓存，

 

### **缓存****更新**

　　缓存淘汰的策略有两种：

　　　　(1) 定时去清理过期的缓存。

　　　　(2)当有用户请求过来时，再判断这个请求所用到的缓存是否过期，过期的话就去底层系统得到新数据并更新缓存。 

　　两者各有优劣，第一种的缺点是维护大量缓存的key是比较麻烦的，第二种的缺点就是每次用户请求过来都要判断缓存失效，逻辑相对比较复杂，具体用哪种方案，大家可以根据自己的应用场景来权衡。1. 预估失效时间 2. 版本号（必须单调递增，时间戳是最好的选择）3. 提供手动清理缓存的接口。

　　我前面有篇文章，是介绍缓存系统的缓存更新的。感兴趣的朋友可以看看：http://www.cnblogs.com/zhangweizhong/p/5884761.html

 

**总结**

　　这些都是实际项目中，可能碰到的一些问题。实际上还有很多很多各种各样的问题。缓存层框架的封装往往要复杂的多。应用场景不同，方法和解决方案也不同。具体要根据实际情况来取舍。  