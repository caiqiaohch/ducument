参考:[ http://blog.sina.com.cn/s/blog_b5fe6b270102v7xo.html](http://blog.sina.com.cn/s/blog_b5fe6b270102v7xo.html)

　　https://blog.csdn.net/xueyingqi/article/details/53216506

 

们需要使用Poll SCM和Build periodically，我们在构建触发中选择这两项即可，其实他们两个就是一个自动任务，这里的语法也是cron的语法，没有什么特别

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702161549234-1646759846.png)

 

触发远程构建:
Build after other projects are built:在其他项目触发的时候触发，里面有分为三种情况，也就是其他项目构建成功、失败、或者不稳定（这个不稳定我这里还木有理解）时候触发项目
Poll SCM：定时检查源码变更（根据SCM软件的版本号），如果有更新就checkout最新code下来，然后执行构建动作。我的配置如下：
*/5 * * * * （每5分钟检查一次源码变化）
Build periodically：周期进行项目构建（它不care源码是否发生变化），我的配置如下：
0 2 * * * （每天2:00 必须build一次源码）

 

比如说我创建了一个 拉取gitlab版本库存的项目，我就可以选择Poll SCM 方式来自动构建，每当gitlab上的代码发生变化，jenkins这便就会自动构建项目来更新最新的源码到jenkins上面。

一搭搭 二搭搭 三搭搭