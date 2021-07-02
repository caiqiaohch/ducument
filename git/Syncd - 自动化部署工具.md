Syncd - 自动化部署工具

官网:https://gitee.com/dreamans/sy...
syncd是一款开源的代码部署工具，它具有简单、高效、易用等特点，可以提高团队的工作效率.

目前只支持类Linux系统.

特性

Go语言开发，编译简单、运行高效
Web界面访问，交互友好
灵活的角色权限配置
支持Git仓库
分支、tag上线
部署hook支持
完善的上线工作流
邮件通知机制
原理






Git

Syncd服务通过git-ssh(或password)方式从仓库中拉取指定tag(分支)代码.

构建

运行配置好的构建脚本, 编译成可上线的软件包

在这一环节中，可运行单元测试 (例如 go test`php phpunit, 下载依赖 (如 go: glide installphp: composer install`), 编译软件包 (如 `js: npm buildgo: go build xx.gojava: javac xx.javac: cc xx.c`) 等.

分发

通过 scp 命令分发软件包到各机房生产服务器的临时目录, 远程执行 pre-deploy 配置的命令, 执行完毕后解压缩软件包到目标目录，然后执行 post-deploy 命令

分发上线过程是串行执行，并且任意步骤执行失败整个上线单会终止上线并将状态置为上线失败，需要点击 再次上线 重试.

将来会支持同一集群服务器并行执行, 集群之间串行发布的特性
SSH信任

生产服务器与部署服务器之间通过ssh-key建立信任

配置方法请参考 秘钥配置 章节

安装

准备工作

Go
推荐Go1.10以上版本, 用来编译源代码

Git
请保持部署Syncd服务器的git版本为最新(>=2.20)

Nginx
Web服务依赖Nginx

MySQL
系统依赖Mysql存储持久化数据, 推荐版本 Mysql 5.7

Linux + Bash
系统会使用到 git, ssh, scp 等命令，所以目前只推荐在Linux上使用, 并且需要提前安装或更新这些命令道最新版本

秘钥配置
由于部署服务器(Syncd服务所在的服务器)与生产服务器(代码部署目标机)之间通过ssh协议通信，所以需要将部署机的公钥 (一般在这里: ~/.ssh/id_rsa.pub)加入到生产机的信任列表中(一般在这里 ~/.ssh/authorized_keys)

可使用 ssh-copy-id 命令添加，或手动拷贝. 拷贝后不要忘记进行测试连通性 ssh {生产机用户名}@{生产机地址}

最后建议将以下配置加入到部署服务器ssh配置/etc/ssh/ssh_config中，关闭公钥摘要的显示提示，防止后台脚本运行失败

Host *   StrictHostKeyChecking no
请注意: ssh目录权限需按此设置，否则会出现无法免密登录的情况

~/.ssh  0700~/.ssh/authorized_keys 0600
安装
二进制包安装
二进制包下载地址：https://github.com/dreamans/s...

源码编译安装
curl https://raw.githubusercontent.com/dreamans/syncd/master/install.sh |bash
当前路径中若生成 syncd-deploy 或者 syncd-deploy-xxx 目录则表明安装成功

生成的 syncd-deploy 目录可拷贝或移动到你想要的地方，但不要试图将此目录拷贝到其他服务器上运行，会造成不可预料的结果.
数据库依赖
你需要将 github.com/dreamans/syncd/syncd.sql 数据表结构和数据导入到MySQL数据库中

修改配置文件
修改 syncd-deploy/etc/syncd.ini 中相关配置信息, 具体配置描述可参考注释

启动服务
cd syncd-deploy
➜  syncd-deploy ./bin/syncd -c ./etc/syncd.ini   
__  _____   __  __   ____     _____   ____/ / / 
___/  / / / /  / __ \   / ___/  / __  /(__  )  / 
/_/ /  / / / /  / /__   / /_/ //____/   \__, /
/_/ /_/   \___/   \__,_/       /____/

Service:              s
yncdVersion:              1.0.0
Config Loaded:        ./etc/syncd.ini
Log:                  stdout
Database:             127.0.0.1
Mail Enable:          0
HTTP Service:         :8868
Start Running...
添加Nginx配置
upstream syncdServer {
server 127.0.0.1:8868 weight=1;
}

server {   
listen       80;
server_name  deploy.syncd.cc; # 此处替换成你的真实域名
access_log   logs/deploy.syncd.cc.log;   

location / { 
try_files $uri $uri/ /index.html; 
root /path/syncd-deploy/public; # 此处/path请替换成真实路径
index index.html index.htm;   
}   

location ^~ /api/ {  
proxy_pass          http://syncdServer;
proxy_set_header    X-Forwarded-Host $host:$server_port; 
proxy_set_header    X-Real-IP     $remote_addr; 
proxy_set_header    Origin        $host:$server_port; 
proxy_set_header    Referer       $host:$server_port; 
}
}
重启nginx服务

修改hosts
若域名未解析，可修改hosts进行临时解析

sudo vim /etc/hosts127.0.0.1  deploy.syncd.cc;
安装完成
打开浏览器，访问 http://deploy.syncd.cc

初始账号:

用户名: syncd邮箱: syncd@syncd.cc密码: syncd.cc
!!!登录后请尽快修改密码

使用
系统使用流程图



使用截图


帮助
遇到问题请提 issue：https://gitee.com/dreamans/sy...

LICENSE

本项目采用 MIT 开源授权许可证，完整的授权说明已放置在 LICENSE 文件中

如有错误或其它问题，欢迎小伙伴留言评论、指正。如有帮助，欢迎点赞+转发分享。

更多相关开源技术文章，请持续关注民工哥知乎技术专栏。

我是民工哥，一个爱折腾的IT技术老司机，欢迎关注我，我们一起学习，共同成长！！