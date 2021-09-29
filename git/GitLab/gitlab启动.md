# [Gitlab启动、停止、重启（两种启动方式）](https://www.cnblogs.com/wei9593/p/11382805.html)

 因为Gitlab不是我部署的，是之前总监部署的，服务器突然更新系统了，Git服务器就没有自启··自启··自启······，自己操作启动没有成功，然后网上搜了一下都是这三种启动关闭重启的方式，可是我这里显示命令错误，what？？？

启动gitlab服务

sudo gitlab-ctl start

 

gitlab服务停止

sudo gitlab-ctl stop

 

重启gitlab服务

sudo gitlab-ctl restart

 

·······································分割··························································································

于是从各种途径查到有这个操作方式

在gitlab-7.8.1-0的安装目录下，有个启动的脚本叫ctlscript.sh

![img](http://www.codingyun.com/articleDirectory/69B155A773B17CA47BEF48E0B1A93725.png)

读了脚本以后，可以这样操作：

\1. gitLab重启服务

> ./ctlscript.sh restart

\2. gitLab的启动，停止等服务，只需替换参数即可

下面这两个分别是启动，去停止的命令

>  ./ctlscript.sh start
>
>  ./ctlscript.sh stop