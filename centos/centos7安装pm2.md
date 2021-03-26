centos7安装pm2

centos安装pm2
需要先安装npm
yum  -y install npm
1
安装pm2
npm install pm2 -g
1
添加配置文件
vim  /etc/profile
PATH=$PATH:/usr/lib/node_modules/pm2/bin
source  /etc/profile

测试
pm2 -v

根据自己的安装路径修改配置文件


可能遇到的问题


问题原因
是node和npm版本太低，我这里版本分别是3.10和6.17


解决办法
先卸载之前的npm

npm uninstall npm -g
1
安装依赖

yum -y install gcc gcc-c++
1
下载高版本的node安装包

wget https://npm.taobao.org/mirrors/node/v10.14.1/node-v10.14.1-linux-x64.tar.gz
1
解压到相应的目录

tar -xf node-v10.14.1-linux-x64.tar.gz
1
重命名

mv node-v10.14.1-linux-x64 node
1
添加环境变量（根据自己的路径添加）

vim /etc/profile
export NODE_HOME=/myinstall/npm/node
export PATH=$NODE_HOME/bin:$PATH
1
2
3
重新加载环境

source /etc/profile
1
查看相应版本


安装pm2
npm  install pm2 -g
1
检测

pm2  list
1


常用命令






————————————————
版权声明：本文为CSDN博主「花老头vip」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_43811335/article/details/108215231