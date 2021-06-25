前言
最原始的软件开发流程是，在本地搭建好环境，进行开发测试，然后去服务器上搭建环境，手动上传代码，运行测试，然后启动服务。实际上，近些年来出现了很多的工具，使得这些步骤可以自动化，大大降低人工出错的概率，提高生产效率。下面，我就把GitLab+Jenkins+Rsync+PM2实现的Node项目的持续集成以及自动部署的实验过程记录下来。

搭建环境
需要两台服务器作为演示,A主要进行代码管理、构建和分发，B主要运行实际应用。我这边系统使用的是Debian系的。

服务器A
GitLab
准备工作：

apt-get update
apt-get install curl openssh-server ca-certificates postfix
安装postfix的时候，选internet site，之后的 system mail name 填写你的服务器的IP地址。

准备好后开始安装：

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
apt-get install gitlab-ee
如果 apt 下载很慢可以手动下载 https://packages.gitlab.com/gitlab/gitlab-ee/packages/ubuntu/trusty/gitlab-ee_10.2.2-ee.0_amd64.deb 然后用 dpkg -i 的方式安装。装了这个过后 NGINX, Postgres, Redis 就都装好了。

配置：

GitLab默认会占用80、8080和9090端口，Jenkins默认也会使用8080端口，所以将GitLab的默认端口为60200、60201、60202（你可以随意定制）

vim /etc/gitlab/gitlab.rb 修改

external_url 'http://<你的服务器ip>:60200'
unicorn['port'] = 60201
prometheus['listen_address'] = 'localhost:60202'
注意不能有多余空格。gitlab-ctl reconfigure生效配置，gitlab-ctl start启动。
如果要想发邮件的话还要配置第三方邮件 vim /etc/gitlab/gitlab.rb

gitlab_rails['smtp_enable'] = true 
gitlab_rails['smtp_address'] = "smtp.exmail.qq.com"
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = "***#**"
gitlab_rails['smtp_password'] = "**************"
gitlab_rails['smtp_domain'] = "qq.com"
gitlab_rails['smtp_authentication'] = :login 
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
gitlab_rails['gitlab_email_from'] = "***#**"
user["git_user_email"] = "***#**"
然后生效重启，打开http://<你的服务器IP>:60200访问，

Jenkins
准备工作：

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz"
tar xzvf jdk-8u151-linux-x64.tar.gz -C /usr/local/  
vim /etc/profile #(加入环境变量)
    export JAVA_HOME=/usr/local/jdk1.8.0_151
    export PATH=$JAVA_HOME/bin:$PATH
退出，source /etc/profile 生效，用 java -version 验证是否装好java。

开始安装：

curl -O http://mirrors.jenkins.io/war-stable/latest/jenkins.war 下载Jenkins，
nohup java -jar jenkins.war --httpPort=60203 & 后台启动并指定端口。
至此，Jenkins安装成功，可以用浏览器打开 http://<你的服务器ip>:60203
然后安装必要的插件（会提示你），依次点击 “系统管理” “管理插件”。
切换到“可选插件”，分别搜索“GitLab Plugin”和“Git Plugin”,然后点击“直接安装”。如果在“可选插件”里没有搜到，可能自带安装了

Node
apt-get update
apt-get install -y build-essential curl
curl -sL https://deb.nodesource.com/setup_8.x | bash 
apt-get install -y nodejs
node -v
v8.9.2
npm -v
5.5.1
Rsync
这个服务器主要使用Rsync来发布文件，所以不需要特殊配置，一般Linux都默认安装了，如果没有,则使用 apt-get install rsync。然后配置Rsync密码

echo "123" >> /etc/rsync.password
chmod -R 600 /etc/rsync.password
服务器B
Node
如A

PM2
npm install -g pm2
pm2 -v
2.8.0
Rsync
为了安全性不要直接使用ssh账号密码或者公钥私钥，而是构建Rsync服务。vim /etc/rsyncd.conf，修改配置，下面的配置只是一个示例，生产环境还要更安全的策略。

##rsyncd.conf start##
uid = root
gid = root
use chroot = yes
max connections = 200
timeout = 300
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
ignore errors
read only = false
list = false
hosts allow = * 
hosts deny =10.0.8.9
auth users = backuser
secrets file = /etc/rsync.password
[webapp]
path = /var/webapp/
上面的的路径path不存在则需要创建 mkdir /var/webapp
echo "backuser:123" >> /etc/rsync.password 添加账号和密码，密码要与客户端（A）一直
chmod -R 600 /etc/rsync.password 修改权限
rsync --daemon 以守护进程方式来启动rsync服务
chkconfig rsync on 将此服务设置成为开机自启动

应用开发
用express开发一个 hello world 作为演示，在本地工程目录

npm init #(按照提示输入参数)
npm install express --save  #（安装express）
然后创建app.js

var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hello World!');
});

var server = app.listen(3000, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);
});
node app.js 运行，然后http://localhost:3000/ 会得到 hello world

新建app.json

{
    "apps" : [
        {
            "name"        : "app",
            "script"      : "app.js",
            "log_date_format"  : "YYYY-MM-DD HH:mm:SS",
            "env": {
                "NODE_ENV": "production"
            },
            "watch" : [
                "app.js",
                "router",
                "util"
            ],
            "ignore_watch" : [
                "logs",
                "node_modules",
                "test"
            ]
        }
    ]
}
将代码上传至服务器B，然后 pm2 start app.json 运行 即可在浏览器访问 http://B-ip:3000 得到 hello world

持续集成和自动部署
配置 Gitlab
首次登陆的密码是会提示你去服务器找，用户是root，然后修改你的用户账号信息，添加你自己常用的电脑上的git公钥。
创建一个新项目 webapp ，创建好过后项目会显示该项目对应的用户信息（会提示你修改）

Git global setup

git config --global user.name "MageekChiu"
git config --global user.email "mageekchiu@mail.**.cn"
在本地项目目录下，新建 .gitignore 文件（window 要用 命令行 rename才可以）

### IntelliJ IDEA ###
.idea
*.iws
*.iml
*.ipr

node_modules/
然后执行

git init
git remote add origin git@A-ip:root/webapp.git
git add .
git commit -m "Initial commit"
git push -u origin master
即可提交服务器仓库，以后每次修改都要

git add .
git commit -m "修改备注"

配置 jenkins
首先配置GitLab插件：
打开GitLab，点击“setting”——“Account”，复制“Private token”，或者应该首先生成personal access token。
打开Jenkins，点击“系统管理”——“系统设置”，点击“配置”下拉框，点击“Gitlab”选项配置GitLab
Connection Name 随便，如 gitlab，“Git Host URL”填GitLab的访问地址，
然后Credentials点“Add”——“jenkins”，在弹出框里，“kind”选择“GitLab API Token”，将先前复制的“Private token”粘贴到“API token”输入框中，然后点击“Add”，添加后，Credentials选择刚刚新建的gitlab，
最后点击“test connection”,看到“Success”就成功了。然后点击页面底下的“apply”,再点击“save”

然后配置Git插件：
需要注意的是装Jenkins的机器上一定要装git: apt-get install git 这样Jenkins才能去 gitlab 拉取文件。
打开Jenkins，点击“系统管理”——“系统设置”，点击“配置”下拉框，选择“Git plugin”选项，设置Git插件的全局配置，填入上面的 global setting 如 global user.name等，然后点击“apply”——“save”

生成访问Gitlab的ssh秘钥：
打开GitLab，点击右上角的“setting”—— SSH Keys，就可以进入到添加界面。
在jenkins所在服务器上生成密钥

ssh-keygen -t rsa -C "root@<你服务器的ip地址>" -b 4096
ssh-keygen -t rsa -C "root@" -b 4096
全部按 Enter 使用默认值，这会生成一对公钥和私钥。打开公钥复制到gitlab的添加界面，然后点击“add key”，并记住私钥的存放路径。

创建一个Jenkins Job：
直接点新建，“item name”可以随便起，然后点击“构建一个自由风格的软件项目”，点击“OK”，至此，创建一个Job成功了。然后配置这个job，选择“源码管理”，选择“Git”,然后去GitLab中复制项目地址，粘贴到“Repository URL”,然后点击“credentials”后面的“Add”按钮
在弹出页面里面：
● Kind 选择 SSH Username with private key
● Username 填 root
● PrivateKey 选择 From a file on jenkins master ，然后将服务器的 私钥的存放路径（/root/.ssh/id_rsa ） 粘贴进去
然后点击“Add”，在“credentials”里选择我们刚刚创建的认证方式。如果没报错，说明成功了，点击页面底部的“apply”。如果出错了，会在“Repository URL”和“Credentials”之间显示红色的错误信息。

选择 构建触发器：
选择 Build when a change is pushed to GitLab. 记住这个 GitLab CI Service URL ，点击高级
Secret token 那一行下面 点击 generate。记住这个token
选择 构建：
选择 execute shell

npm install 
WEB_SERVER_IP=B的ip
PROJECT=webapp/
rsync -arqz --delete-before $WORKSPACE/ $WEB_SERVER_IP::$PROJECT --exclude ".git" --password-file=/etc/rsync.password 
这一段代码的主要目的是构建，并分发代码，如果有多个应用服务器就要分发到多个服务器上。

配置gitab的webhook:
点击webapp 项目下面的setting的integrations 输入刚才的 GitLab CI Service URL 和 Secret Token
然后点击add webhook ,再测试一下选择 push events 如果显示Hook executed successfully: HTTP 200 即成功，然后在jenkins里面查看是有一次构建记录的。

这样jenkins就会在代码发生变化时自动拉取代码到本地，构建，然后用rsync分发给各个应用服务器，结合PM2的watch功能实现自动发现代码更新并重启的功能，达到自动部署的目的

最终效果测试
修改代码，把hello world改为hello gitlab+enkins然后 add、commit、push 。在A上面gitlab有提交记录，jenkins有构建记录，在B上面用 pm2 ls 发现项目是restart了，浏览器查看也变成hello gitlab+enkins 了。
尝试成功！
虽然这个配置比较麻烦，但是持续集成和自动部署的带来的好处是更大的：代码有版本管理，可以快速迭代、快速回滚，同时保持高质量、自动多机部署防止人工错误，每次构建都有记录，构建幂等......

参考
http://blog.csdn.net/ruangong...

原文 mageek

后记
这个过程已经比较自动化了，但是还是有太多的环境搭建过程，比如webapp一般都会用到mysql、redis、MongoDB等等，一个更自动化的过程应该引入docker，这方面以后有机会再尝试。