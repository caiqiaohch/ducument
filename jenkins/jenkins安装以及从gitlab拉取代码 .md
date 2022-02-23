# [ jenkins安装以及从gitlab拉取代码 ](https://www.cnblogs.com/yitianyouyitian/p/9244806.html)

讨论QQ群：135202158



**目录**

- [1. gitlab前面已经写过了，自己去参考](https://www.cnblogs.com/yitianyouyitian/p/9244806.html#_label0)
- \2. jenkins安装
  - [2.1 jdk 安装](https://www.cnblogs.com/yitianyouyitian/p/9244806.html#_label1_0)
  - [2.2 jenkins安装](https://www.cnblogs.com/yitianyouyitian/p/9244806.html#_label1_1)
- [3.  jenkins从gitlab拉取代码(实现持续集成)](https://www.cnblogs.com/yitianyouyitian/p/9244806.html#_label2)
- [ ](https://www.cnblogs.com/yitianyouyitian/p/9244806.html#_label3)

 

**正文**

[回到顶部](https://www.cnblogs.com/yitianyouyitian/p/9244806.html#_labelTop)

## 1. gitlab前面已经写过了，自己去参考

https://www.cnblogs.com/yitianyouyitian/p/9214940.html 

[回到顶部](https://www.cnblogs.com/yitianyouyitian/p/9244806.html#_labelTop)

## 2. jenkins安装



### 2.1 jdk 安装

下载linux jdk-8u11-linux-x64.tar.gz

到甲骨文官网或国内镜像下载JDK（www.oracle.com）

解压：

tar vxf jdk-8u11-linux-x64.tar.gz

配置环境变量：

\#set Maven environment vi /etc/profile

export JAVA_HOME=/usr/local/jdk1.8.0_11

export JRE_HOME=${JAVA_HOME}/jre

export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib

export PATH=${JAVA_HOME}/bin:$PATH

环境变量立即生效

source /etc/profile

 



### 2.2 jenkins安装

以下四种方法任选一种，我本人使用的最后一种方式。

1、 在线安装

wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo

sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key## 公钥

sudo yum install jenkins -y

2、 离线安装

\## http://pkg.jenkins-ci.org/redhat/

wget http://pkg.jenkins-ci.org/redhat/jenkins-2.39-1.1.noarch.rpm ## 下载(也可以Windows下载再转过来)

sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins.io.key ## 公钥

sudo yum -y install jenkins-*.noarch.rpm

3、基于 Tomcat 安装

安装并启动 Tomcat；

从官网下载 jenkins.war 至 $CATALINA_BASE/webapps，Tomcat 会自动部署；

浏览器访问：http://centos:8080/jenkins/

4、免安装方式

wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war

sudo java -jar jenkens.war --httpPort=8080 ## 启动服务，直至看到日志 `Jenkins is fully up and running`

curl http://localhost:8080/ ## Jenkins 已就绪

 

浏览器输入  ip:8080

 ![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702104859928-1429426697.png)

初始的管理员密码，jenkins自动生成的，根据上面红色的路径找到密码，拷到下面的输入框中。

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702104923937-456471331.png)

 

 安装插件，可以默认的安装，也可以自己选择，（jenkins配置好后也可以安装插件）这里我们选择默认的。

 

[回到顶部](https://www.cnblogs.com/yitianyouyitian/p/9244806.html#_labelTop)

## 3.  jenkins从gitlab拉取代码(实现持续集成)

参考: http://www.cnblogs.com/ceshi2016/p/6529532.html

 

备注:  用http  协议访问git源的时候， 在认证的时候输入用户名和密码也很简单。

 

注意，项目构建之前保证安装了git插件和ssh插件.

 

开始构建：

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702105120478-211636678.png)

 

填写描述

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702105401166-1196529031.png)

 

源码管理: 这个最重要(注意，git源码拉取的前提是，jfenkins服务器有私钥，gitlab服务器上面有公钥，即在jenkins上可以无密码进行正常git pull)

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702105826889-1398480332.png)

 

配置认证，即  上传可以访问 gitlab 项目的私钥。

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702112231928-1916932853.png)

 

出现这种没有报错的界面说明验证成功

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702112418991-883343859.png)

 

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702112616375-61506614.png)

 

保存配置后，进入下面的页面，点击左边的 [Build Now](http://172.10.30.245:8080/job/demo/build?delay=0sec) 来构建项目

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702112832189-943315288.png)

 

查看构建的结果

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702112945318-378391193.png)

 

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702113018564-586663048.png)

 

到此，拉取gitlab的代码就成功了.



 [持续集成部署 - 随笔分类 - 你的泪我的眼 - 博客园 (cnblogs.com)](https://www.cnblogs.com/yitianyouyitian/category/1391864.html) 