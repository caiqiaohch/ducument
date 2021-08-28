PM2自动部署代码流程总结

公司的项目需要自动部署到服务器上，在网上查询后，发现PM2自带的发布程序可以自动部署并运行。

0x01 环境条件
本地环境：window10的WSL ubuntu16.04
服务器环境：ubuntu18.04
使用PM2进行部署，可以先查看官方的文档

这里需要在本地和服务器环境上同时安装好 PM2 、git ,本地PM2可以通过git向github、gitee等仓库提交代码，同时通知服务器的PM2拉取最新的代码，并在拉取成功后运行代码。

0x02 设置本地环境与服务器环境gitee仓库ssh
本地环境
执行 ssh-keygen -t rsa -b 2048 -f pm2deploy -C "PM2 deploy ssh key"
图片描述

执行后将得到本地环境生成的ssh key

执行 ssh-agent bash --login -i
执行 ssh-add pm2deploy
图片描述

执行后将pm2deloy添加到ssh高速代理中去。

将公钥添加入gitee或github中，注意本地环境添加的是个人公钥，而服务器环境需要添加在部署公钥下。
clipboard.png

添加成功以后，本地shell执行git -T git@gitee.com

clipboard.png

返回successfully后，则说明本地ssh已经部署完成。

添加config

如果你的公钥和私钥是有别名的，需要添加一个配置文件config来说明网站和密钥的对应关系
clipboard.png

如果有多个 ssh 账号需要配置，在 config 文件里隔行分开写就行

clipboard.png

服务器环境
服务器环境同理，不同的是服务器环境添加的公钥需要放在部署公钥下
图片描述
0x02 配置git
先将git origin 的地址修改成ssh的别名地址

vim /.git/config

修改origin 的中gitee.com 为别名gitee，然后保存

注意这里的别名是本地的别名gitee，但是git库需要保持一致，所以在服务器上配置的别名也为gitee，只需要配置别名即可，证书还是各有各的证书。

先到项目目录用git将刚刚创建的项目拉取下来，拉取后，我们随便部署一个测试的代码，看是否能提交进gitee
这里我使用的是node的官方测试代码

clipboard.png

clipboard.png

传输成功后，我们开始配置PM2的配置文件

0x03 配置PM2
官方说明中只需要配置好这里的ecosystem.config.js 配置文件,并且让本地环境和服务器环境可以通过ssh访问即可实现PM2自动部署

配置ssh
本地生成shh密钥
将密钥写入本地config文件中
将公钥写入到服务器环境中的authorized_keys中

配置ecosystem.config.js
使用 pm2 ecosystem 自动生成ecosystem.config.js

ecosystem.config.js:
    module.exports = {
        apps : [{
        name: 'test',
        script: 'test.js',

        // Options reference: https://pm2.io/doc/en/runtime/reference/ecosystem-file/
        // 远程服务器上的PM2参数配置
        args: 'one two',      //参数
        instances: 1,         //实例数量
        autorestart: true,    //自动启动：是
        watch: false,         //监视模式：否
        max_memory_restart: '1G',//如果超过内存多少后，将重启实例：1G
        env: {
          NODE_ENV: 'development'
        },
        env_production: {
          NODE_ENV: 'production'
        }
  }],

  deploy : {
    production : {
      user : '远程主机用户名',
      host : '远程主机的ssh-config中的别名',
      port : '远程主机ssh端口',
      ref  : 'origin/master',//远程gitee上的分支
      repo : 'git@[gitee别名]:[git库地址]',
      path : '远程服务器上的部署路径',
      'post-deploy' : 'npm install && pm2 reload ecosystem.config.js --env production'//部署完成后的操作
    }
  }
};
配置完成后，执行 pm2 deploy production setup 初始化PM2的部署

clipboard.png

以后更新，执行 pm2 deploy production update，则更新新的代码并运行了。

待定