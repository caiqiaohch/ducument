killall svnserve
svnserve -d -r /home/svn/dyh
svnserve -d -r /data/svn/project/

[root@vdevops trunk]# svn --username dingyuehui list svn:

-----------------------------------------------------------------------
ATTENTION!  Your password for authentication realm:

   <svn://linuxprobe.org:3690> LinuxProbe Repository  # 仓库名称

can only be stored to disk unencrypted!  You are advised to configure
your system so that Subversion can store passwords encrypted, if
possible.  See the documentation for details.

You can avoid future appearances of this warning by setting the value
of the 'store-plaintext-passwords' option to either 'yes' or 'no' in
'/root/.subversion/servers'.
-----------------------------------------------------------------------
Store password unencrypted (yes/no)? yes #记住密码
index.go
index.html
index.php
index.py
info.php

环境

Centos7.3
禅道9.7开源集成版（集成了mysql、apache、php）不需要自己配置
下载

禅道下载地址：http://dl.cnezsoft.com/zentao/9.7/ZenTaoPMS.9.7.stable.zbox_64.tar.gz
安装
将我们下载好的安装包解压到/opt文件夹下

特别说明：不要解压到别的目录再拷贝到/opt/，因为这样会导致文件的所有者和读写权限改变，也不要解压后把整个目录777权限。
可以使用命令：

tar -zxvf  ZenTaoPMS.9.7.stable.zbox_64.tar.gz -C /opt


修改集成的mysql和apache端口号

为了不影响本地安装的mysql和apache服务的时候我们修改禅道默认的端口号：

#设置mysql端口号是3307：
[root@izuf6bopxrlqcajllezob1z zbox]# ./zbox -mp 3307
#设置apache端口号是90
[root@izuf6bopxrlqcajllezob1z zbox]# ./zbox -ap 90



Apache和Mysql常用命令

/opt/zbox/zbox start #命令开启Apache和Mysql。
/opt/zbox/zbox stop #命令停止Apache和Mysql。
/opt/zbox/zbox restart #命令重启Apache和Mysql。



添加数据库用户

运行auth下的adduser.sh进行添加数据库用户。如果不设置用户，我们访问禅道首页的时候会报错：
4:44:48 ERROR: SQLSTATE[HY000] [1045] Access denied for user ‘zentao’@’localhost’ (using password: YES) in framework/base/router.class.php on line 2145, last called by framework/base/router.class.php on line 2103 through function connectByPDO.
in framework/base/router.class.php on line 2195 when visiting
添加用户的命令如下，我设置的是root，root：

#运行添加用户的脚本
./adduser.sh


这里写图片描述
访问禅道

访问输入ip:90，点击开源版，输入默认的用户名admin密码123456 
————————————————
版权声明：本文为CSDN博主「w奔跑的蜗牛」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/plei_yue/article/details/79075298