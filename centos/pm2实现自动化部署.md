pm2实现自动化部署

基于git，使用node的pm2实现项目的自动化部署，服务器环境以centos为例

环境配置
因为是基于git和node，所以本机和部署项目的服务器都需要安装node和git，然后安装pm2
本地环境比较简单，不赘述，centos下可以借助yum来安装

yum install -y nodejs
# 装完以后继续安装pm2，本地环境同理
npm install pm2 -g
# 接下来安装git
yum install -y git
# 安装完以后可以git -v查看版本
配置ssh key
这一步是为了让本地计算机、github、服务器之间建立连接，因此本机和部署项目的服务器都需要添加ssh，这个比较简单，不会的可以参考Github 简明教程

添加pm2配置文件
在本地项目根目录添加ecosystem.json
！！！注意：因为是json格式，实际使用请删除注释

{
    "apps":[
        {
            "name": "app", // 项目名称
            "script": "app.js", // 入口文件
            "env": {
                "COMMON_VARIABLE": "true"
            },
            "env_production": {
                "NODE_ENV": "production" // 环境变量
            }
        }
    ],
    // 环境部署的配置
    "deploy": {
        "production": {
            // 登录服务器的用户名
            "user":"slevin",
            // 服务器ip
            "host": ["12.34.56.78"],
            // 服务器ssh登录端口，未修改的话一般默认为22
            "port": "22",
            // 指定拉取的分支
            "ref": "origin/master",
            // 远程仓库地址
            "repo": "git@github.com:yourName/xxx.git",
            // 指定代码拉取到服务器的目录
            "path": "/home/projects/xxx",
            "ssh_options": "StrictHostKeyChecking=no",
            "env": {
                "NODE_ENV": "production"
            }
        }
    }
}
本地push与服务器端pull
github上创建仓库，比如xxx
在本地项目根目录执行以下命令
git init # 初始化仓库
git commit -m "init project" # 添加提交信息
git remote add origin git@github.com:yourName/xxx.git # 指定remote地址
git push -u origin master # 推送
在服务器端
cd /home/projects/
git clone git@github.com:yourName/xxx.git # 克隆github项目，(非node项目略过下面2步)
cd xxx
npm install # 安装依赖
ps：以上步骤首次操作可能会提示你输入github登陆密码

自动化部署
pm2 deploy ecosystem.json production setup # 首次部署执行一次即可
pm2 deploy ecosystem.json production
后续开发中，提交本地代码到remote后，只需要执行pm2 deploy ecosystem.json production即可

问题处理
提示bash: pm2: command not found post-deploy hook failed Deploy failed 1
即是：找不到pm2命令，解决办法，添加pm2的软链接，在服务器端执行：

# 查找pm2的路径
whereis pm2
# pm2: /usr/bin/pm2 /root/node/bin/pm2，添加软连接
#
sudo ln -s [查找到的链接] /usr/bin/pm2
# 即是： sudo ln -s /usr/bin/pm2 /root/node/bin/pm2 /usr/bin/pm2