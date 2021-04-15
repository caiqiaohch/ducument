PM2的安装和使用简介

## 简介
PM2是node进程管理工具，可以利用它来简化很多node应用管理的繁琐任务，如性能监控、自动重启、负载均衡等，而且使用非常简单。

日志管理：应用程序日志保存在服务器的硬盘中~/.pm2/logs/

负载均衡：PM2可以通过创建共享同一服务器端口的多个子进程来扩展您的应用程序。这样做还允许您以零秒停机时间重新启动应用程序。

终端监控：可以在终端中监控您的应用程序并检查应用程序运行状况（CPU使用率，使用的内存，请求/分钟等）。

SSH部署：自动部署，避免逐个在所有服务器中进行ssh。

静态服务：支持静态服务器功能

多平台支持：适用于Linux（稳定）和macOS（稳定）和Windows（稳定）

## 前期必备
node 环境
npm
## 安装
npm install pm2 -g
yarn global add pm2
apt update && apt install sudo curl && curl -sL https://raw.githubusercontent.com/Unitech/pm2/master/packager/setup.deb.sh | sudo -E bash -

##centos安装pm2
需要先安装npm
yum  -y install npm
安装pm2
npm install pm2 -g

添加配置文件
vim  /etc/profile
PATH=$PATH:/usr/lib/node_modules/pm2/bin
source  /etc/profile

测试
pm2 -v

根据自己的安装路径修改配置文件

遇到问题node和npm版本太低解决办法：
先卸载之前的npm
npm uninstall npm -g

安装依赖
yum -y install gcc gcc-c++
下载高版本的node安装包

wget https://npm.taobao.org/mirrors/node/v10.14.1/node-v10.14.1-linux-x64.tar.gz

解压到相应的目录
tar -xf node-v10.14.1-linux-x64.tar.gz

重命名
mv node-v10.14.1-linux-x64 node

添加环境变量（根据自己的路径添加）
vim /etc/profile
export NODE_HOME=/myinstall/npm/node
export PATH=$NODE_HOME/bin:$PATH

重新加载环境
source /etc/profile
查看相应版本

安装pm2
npm  install pm2 -g

检测
pm2 list

四、入门教程
挑express应用来举例。一般我们都是通过npm start启动应用，其实就是调用node ./bin/www。那么，换成pm2就是

注意，这里用了–watch参数，意味着当你的express应用代码发生变化时，pm2会帮你重启服务(长时间监测有可能会出现问题，这时需要重启项目)

pm2 start ./bin/www –watch



#使用
##启动服务
pm2 start app.js                //启动app.js应用
pm2 start app.js --name demo    //启动应用并设置name
pm2 start app.sh                //脚本启动

参数说明：
–watch：监听应用目录的变化，一旦发生变化，自动重启。如果要精确监听、不见听的目录，最好通过配置文件。
-i –instances：启用多少个实例，可用于负载均衡。如果-i 0或者-i max，则根据当前机器核数确定实例数目。
–ignore-watch：排除监听的目录/文件，可以是特定的文件名，也可以是正则。比如–ignore-watch=”test node_modules “some scripts”“
-n –name：应用的名称。查看应用信息的时候可以用到。
-o –output ：标准输出日志文件的路径。
-e –error ：错误输出日志文件的路径。
–interpreter ：the interpreter pm2 should use for executing app (bash, python…)。比如你用的coffee script来编写应用。
完整命令行参数列表：地址
pm2 start app.js –watch -i 2

##停止服务
停止特定的应用。可以先通过pm2 list获取应用的名字（–name指定的）或者进程id。
pm2 stop app_name|app_id
如果要停止所有应用，可以
pm2 stop all
pm2 stop all               //停止所有应用
pm2 stop [AppName]        //根据应用名停止指定应用
pm2 stop [ID]             //根据应用id停止指定应用
pm2 stop app_name|app_id
pm2 stop all

##删除应用
pm2 delete all               //关闭并删除应用
pm2 delete [AppName]        //根据应用名关闭并删除应用
pm2 delete [ID]            //根据应用ID关闭并删除应用

##创建开机自启动
pm2 startup

##更新PM2
pm2 updatePM2
pm2 update

##监听模式
pm2 start app.js --watch    //当文件发生变化，自动重启

##静态服务器
pm2 serve ./dist 9090        //将目录dist作为静态服务器根目录，端口为9090

##启用群集模式（自动负载均衡）
//max 表示PM2将自动检测可用CPU的数量并运行尽可能多的进程
//max可以自定义，如果是4核CPU，设置为2者占用2个
pm2 start app.js -i max

##重新启动
pm2 restart app.js        //同时杀死并重启所有进程。短时间内服务不可用。生成环境推荐使用reload
##自动重启
pm2 start app.js –watch
*这里是监控整个项目的文件
##0秒停机重新加载
pm2 reload app.js        //重新启动所有进程，始终保持至少一个进程在运行
pm2 gracefulReload all   //优雅地以群集模式重新加载所有应用程序

##查看启动列表
pm2 list
##查看每个应用程序占用情况
pm2 monit
##显示应用程序所有信息 
pm2 show [Name]      //根据name查看
pm2 show [ID]        //根据id查看
##日志查看
pm2 logs            //查看所有应用日志
pm2 logs [Name]    //根据指定应用名查看应用日志
pm2 logs [ID]      //根据指定应用ID查看应用日志
除了可以打开日志文件查看日志外，还可以通过pm2 logs来查看实时日志。

##更新pm2
pm2 save # 记得保存进程状态
npm install pm2 -g
pm2 update

##保存当前应用列表
pm2 save
##重启保存的应用列表
pm2 resurrect
##清除保存的应用列表
pm2 cleardump
##保存并恢复PM2进程
pm2 update
##PM2配置文件方式
##生成示例配置文件
pm2 ecosystem        //生成一个示例JSON配置文件
pm2 init
##配置文件示例（实际使用自行删除）
module.exports = {
    apps : [{
        name      : 'API',      //应用名
        script    : 'app.js',   //应用文件位置
        env: {
            PM2_SERVE_PATH: ".",    //静态服务路径
            PM2_SERVE_PORT: 8080,   //静态服务器访问端口
            NODE_ENV: 'development' //启动默认模式
        },
        env_production : {
            NODE_ENV: 'production'  //使用production模式 pm2 start ecosystem.config.js --env production
        },
        instances:"max",          //将应用程序分布在所有CPU核心上,可以是整数或负数
        watch:true,               //监听模式
        output: './out.log',      //指定日志标准输出文件及位置
        error: './error.log',     //错误输出日志文件及位置，pm2 install pm2-logrotate进行日志文件拆分
        merge_logs: true,         //集群情况下，可以合并日志
        log_type:"json",          //日志类型
        log_date_format: "DD-MM-YYYY",  //日志日期记录格式
    }],
    deploy : {
        production : {
            user : 'node',                      //ssh 用户
            host : '212.83.163.1',              //ssh 地址
            ref  : 'origin/master',             //GIT远程/分支
            repo : 'git@github.com:repo.git',   //git地址
            path : '/var/www/production',       //服务器文件路径
            post-deploy : 'npm install && pm2 reload ecosystem.config.js --env production'  //部署后的动作
        }
    }
};

附pm2命令：
$ npm install pm2 -g     # 命令行安装 pm2 
$ pm2 start app.js -i 4  # 后台运行pm2，启动4个app.js 
                         # 也可以把'max' 参数传递给 start
                         # 正确的进程数目依赖于Cpu的核心数目
$ pm2 start app.js --name my-api # 命名进程
$ pm2 list               # 显示所有进程状态
$ pm2 monit              # 监视所有进程
$ pm2 logs               # 显示所有进程日志
$ pm2 stop all           # 停止所有进程
$ pm2 restart all        # 重启所有进程
$ pm2 reload all         # 0 秒停机重载进程 (用于 NETWORKED 进程)
$ pm2 stop 0             # 停止指定的进程
$ pm2 restart 0          # 重启指定的进程
$ pm2 startup            # 产生 init 脚本 保持进程活着
$ pm2 web                # 运行健壮的 computer API endpoint (http://localhost:9615)
$ pm2 delete 0           # 杀死指定的进程
$ pm2 delete all         # 杀死全部进程








