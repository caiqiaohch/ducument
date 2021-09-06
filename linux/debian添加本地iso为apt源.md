# debian添加本地iso为apt源

本文链接：https://blog.csdn.net/qq_21792169/article/details/80866564
通常虚拟机安装debian后安装软件，需要手动切换本地镜像软件源，这样非常麻烦，下面方法很实用。

1、上传debian-9.4.0-amd64-DVD-1.iso  debian-9.4.0-amd64-DVD-2.iso  debian-9.4.0-amd64-DVD-3.iso 三个镜像文件到debian系统中/home/google/debian/目录下。

2、分别挂在这三个文件到/media/debian1  /media/debian2   /media/debian3 目录下 挂在方法如下:

sudo vi /etc/fstab

/home/google/debian/debian-9.4.0-amd64-DVD-1.iso  /media/debian1 iso9660 defaults 0 0
/home/google/debian/debian-9.4.0-amd64-DVD-2.iso  /media/debian2 iso9660 defaults 0 0
/home/google/debian/debian-9.4.0-amd64-DVD-3.iso  /media/debian3 iso9660 defaults 0 0

3、添加本地原

sudo vi /etc/apt/sources.list
deb file:///media/debian1   stretch contrib main
deb file:///media/debian2   stretch contrib main

deb file:///media/debian3   stretch contrib main  //这里路径后面的字符串跟网络apt源一致就行，由于使用的debian不一致



debian 9.4 有一个bug待解决   nfs-kernel-server 这个服务其启动总是exited状态，其他版本不会出现这个问题。
 ———————————————— 
版权声明：本文为CSDN博主「HeroKern」的原创文章，遵循CC 4.0 by-sa版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_21792169/article/details/80866564