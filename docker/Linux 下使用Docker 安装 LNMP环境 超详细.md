# Linux 下使用Docker 安装 LNMP环境 超详细

首先在阿里云购买了一台服务器 选择了华南-深圳地区 操作系统选用了 CentOS8.0 64位

1. 初始化账号密码 登陆xshell，开始装Docker
一、安装docker
1、Docker 要求 CentOS 系统的内核版本高于 3.10 ，查看本页面的前提条件来验证你的CentOS 版本是否支持 Docker 。

通过 uname -r 命令查看你当前的内核版本

 $ uname -r
2、使用 root 权限登录 Centos。确保 yum 包更新到最新。

$ sudo yum update
3、卸载旧版本(如果安装过旧版本的话)

$ sudo yum remove docker  docker-common docker-selinux docker-engine
4、安装需要的软件包， yum-util 提供yum-config-manager功能，另外两个是devicemapper驱动依赖的

$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
5、设置yum源

$ sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

6、可以查看所有仓库中所有docker版本，并选择特定版本安装

$ yum list docker-ce --showduplicates | sort -r

7、安装docker

$ sudo yum install docker-ce  #由于repo中默认只开启stable仓库，故这里安装的是最新稳定版17.12.0
$ sudo yum install <FQPN>  # 例如：sudo yum install docker-ce-17.12.0.ce
安装过程报错了：

分析原因
看上面的内容，说的是containerd.io >= 1.2.2-3 ，意思就是 containerd.io 的版本必须大于等于 1.2.2-3

解决方案
1、要么就降低docker 的版本

2、如果不想降低docker 版本，那么就更新 containerd.io 的版本

$ wget https://download.docker.com/linux/centos/7/x86_64/edge/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
$ yum install -y containerd.io-1.2.6-3.3.el7.x86_64.rpm
然后回到第7步骤  输入 

8、启动并加入开机启动

$ sudo systemctl start docker
$ sudo systemctl enable docker
9、验证安装是否成功(有client和service两部分表示docker安装启动都成功了)

$ docker version

 10、查看docker列表

$ sudo systemctl docker images

以上安装docker 内容完毕，接下来通过运行环境.

-------------------------------------------------------------------------

## docker安装nginx 

1
docker search nginx

 2.拉取官方的镜像

1
docker pull nginx

 3.创建并运行容器，绑定映射端口

1
docker run --name nginx -p 80:80 -d nginx
　　--name 这里是别名，使用docker ps 会最后显示names

　　-p  80:80    第一个80是服务器的端口，第二个80是docker容器端口，

　　-d 要运行的容器名称 这里是nginx



 上面运行报错了，这里是以前装了nginx,通过docker ps -a 查看



 

 

 现在进行清除命令：

docker rm `docker ps -a -q`
现在运行第三步  ，会成功。

docker run --name nginx -p 80:80 -d nginx<br>通过netstat -nltp 可以查看到80 端口已经启动。




此刻访问IP,nginx 正常运行起来



 

 

 

 

 

 

docker安装php
1.查找Docker Hub上的php镜像

1
docker search php
　　

 

 

 2.拉取官方的镜像,标签为 phpdockerio/php72-fpm

docker pull phpdockerio/php72-fpm
　　

 

 3.现在需要查看nginx 默认运行的路径 先进入nginx 容器 再找到/etc/nginx/conf.d/default.conf    查看默认访问路径

docker exec -it nginx bash
cat /etc/nginx/conf.d/default.conf -n

 4.创建并运行php容器

1
docker run -p 9000:9000 --name phpfpm -v /var/www/html:/usr/share/nginx/html -d phpdockerio/php72-fpm
　　

5.进入php 容器，找到路径

1
/usr/share/nginx/html
创建一个文件 index2.php 文件

docker exec -it phpfpm bash
cd /usr/share/nginx/html/
vim index2.php
　　

 现在 vim 是没有安装，需要运行


apt-get update
apt-get install vim

cat << EOF > /root/.vimrc
:set encoding=utf-8
:set fileencodings=ucs-bom,utf-8,cp936
:set fileencoding=gb2312
:set termencoding=utf-8
EOF
　　

 

 保存退出！然后进入服务器  /var/www/html 发现生成了index2.php，其实这个就相当与映射docker 路径到服务器路径了



 

 6.现在就是要nginx 配置访问php 文件了,如果直接访问就会是404 



  6.1 获取到phpfpm 这个容器的ip

1
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' phpfpm
　　

 

 最后这个内网ip是：172.17.0.3,这个ip 会配置到/etc/nginx/conf.d/default.conf 

 6.2 配置nginx 支持php 文件访问


docker exec -it phpfpm bash
cd /etc/nginx/conf.d/

apt-get update
apt-get install vim
vim default.conf
在代码里面加入 9000 端口这段代码

server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;
     
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
     
    #error_page  404              /404.html;
     
    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
     
    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}
     
    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    # 加入以下的代码 可以访问php文件
    location ~ \.php$ {
        root           /usr/share/nginx/html;
        fastcgi_pass   172.17.0.3:9000;
        fastcgi_index  index.php;
    fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_name;
        #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        include        fastcgi_params;
    }
     
    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
  6.3 重启nginx ,即可访问index2.php

1
docker restart nginx
　　

 

 

docker安装mysql
1.查找镜像：

 docker search mysql
也可以去官网查看镜像tag，选择自己需要的版本，否则会下载最新版本：https://hub.docker.com/_/mysql/

2.下载镜像（如上一步，可以指定想要的版本，不指定则为最新版）：

docker pull mysql
3.通过镜像创建容器并运行：

复制代码
复制代码
docker run -p 3306:3306 --name mymysql -v $PWD/conf:/etc/mysql/conf.d -v $PWD/logs:/logs -v $PWD/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql
-p 3306:3306：将容器的 3306 端口映射到主机的 3306 端口。

-v -v $PWD/conf:/etc/mysql/conf.d：将主机当前目录下的 conf/my.cnf 挂载到容器的 /etc/mysql/my.cnf。

-v $PWD/logs:/logs：将主机当前目录下的 logs 目录挂载到容器的 /logs。

-v $PWD/data:/var/lib/mysql ：将主机当前目录下的data目录挂载到容器的 /var/lib/mysql 。

-e MYSQL_ROOT_PASSWORD=123456：初始化 root 用户的密码。

复制代码
复制代码
此时，用navicat for mysql连接mysql发现报错：Client does not support authentication protocol requested  by server。。。



解决方案：

进入容器：

docker exec -it 62349aa31687 /bin/bash
进入mysql：

mysql -uroot -p
授权：

mysql> GRANT ALL ON *.* TO 'root'@'%';
刷新权限：

mysql> flush privileges;
更新加密规则：

mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' PASSWORD EXPIRE NEVER;
更新root用户密码：

mysql> ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
刷新权限：

mysql> flush privileges;








 以上是MySQL安装的全过程，目前的环境搭建已经全部完成了。
