# [gitlab访问：Whoops, GitLab is taking too much time to respond.](https://www.cnblogs.com/stronger-xsw/p/12804002.html)

#### gitlab访问提示502错误：如图：

![img](https://img2020.cnblogs.com/blog/1276937/202004/1276937-20200429182434258-302272417.png)

#### 原因：

机器内存太小，百度说最小需要小号2G内存

#### 解决办法

关闭虚拟机
增加机器处理内存，如图
![img](https://img2020.cnblogs.com/blog/1276937/202004/1276937-20200429182737093-214220458.png)

突然发现再次访问还是不行
所以8080端口会不会是被占用了，所以我打开配置文件，修改端口
`vim /etc/gitlab/gitlab.rb`
将external_url添加一个未被使用的端口
external_url '[http://192.168.110.132:8080](http://192.168.110.132:8080/)
修改为没有使用的端口即可：
external_url '[http://192.168.110.132:8899](http://192.168.110.132:8899/)'
![img](https://img2020.cnblogs.com/blog/1276937/202004/1276937-20200429184605317-1535839454.png)

将下面这3行打开注释
默认注释：

```
unicorn['port'] = 8088
postgresql['shared_buffers'] = "256MB"
postgresql['max_connections'] = 200
```

![img](https://img2020.cnblogs.com/blog/1276937/202004/1276937-20200429184637047-2115892106.png)
![img](https://img2020.cnblogs.com/blog/1276937/202004/1276937-20200429184730204-2133015320.png)

更新配置：
`gitlab-ctl reconfigure`
重启：
`gitlab-ctl restart`
访问`http://192.168.110.132:8899`
如图：
![img](https://img2020.cnblogs.com/blog/1276937/202004/1276937-20200429184831109-764233793.png)
ok，成功访问

分类: [linux](https://www.cnblogs.com/stronger-xsw/category/1694624.html), [git](https://www.cnblogs.com/stronger-xsw/category/1695014.html)





GitLab学习笔记：报502错误，信息内容为502-Whoops, GitLab is taking too much time to respond
Gitlab服务器突然宕机，报：502-Whoops, GitLab is taking too much time to respond


网上搜到解决办法：
https://gitlab.com/gitlab-org/gitlab-foss/-/issues/30095

Thank you for the guidance to resolve this problem. Now this problem is resolved by changing the unicorn worker time out.

修改Gitlab配置文件：/etc/gitlab/gitlab.rb

 unicorn['worker_timeout'] = 90
1
修改完配置文件后重启Gitlab服务，问题解决。
gitlab-ctl reconfigure不推荐使用，网上有帖子说会把一些过去的config还原，导致修改的端口以及域名等都没有了，但是我执行了没有出现这个问题。

gitlab-ctl reconfigure
gitlab-ctl stop
gitlab-ctl start
gitlab-ctl restart
————————————————
版权声明：本文为CSDN博主「xiangcns」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/xiangcns/article/details/106827202