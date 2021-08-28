利用git和pm2实现快速部署多个服务

工作中用nodejs开发了企业短信平台，平台由3个服务组成：portal服务，数据api服务和短信网关服务。由于不同企业的portal、业务逻辑和短信通道要求都存在很多差别。为了降低代码维护的难度，在同一份代码的基础上再git上为每个企业创建了各自的发布分支，原则上公共代码在各发布分支相同，差异代码逻辑的文件名根据分支分别命名。各发布分支维护各自生产环境的数据库配置等参数。另外创建一个部署工具项目deployTool 来维护项目的多实例部署与更新，并利用git来管理该部署工具的版本。部署工具实际就包含了批量服务部署指令的shell脚本-install.sh和一个核心部署指令脚本-unit.sh。pm2可以监控服务的工作目录，文件发生改变时自动重启服务（为了手动控制重启服务，脚本中没有启用目录监控），服务已经启动的情况下不会重复执行start指令，可以利用pm2的指令控制服务的启动、停止等。服务部署失败的适合进入该服务目录利用git指令迅速回滚代码到上一个版本。

unit.sh内容如下：

#!/bin/bash
compName=$1
appFrom=$2
appTo=$3
serversHome=$4
main=$5
cd $serversHome
if [ ! -d $compName ]; then
    mkdir $compName
fi
cd $compName
if [ ! -d $appTo ]; then
    git clone http://xxxxx/gitbucket/git/xxx/$appFrom.git
    mv $appFrom $appTo
    cd $appTo
    git checkout $compName
    git fetch
    git pull
    workdir=`pwd`
    npm install
    mkdir logs
    cd ..
    echo -e  "#!/bin/bash/\ncd $workdir \npm2 start $main  --name \"$compName-$appTo\"">$appTo.sh
    sh $appTo.sh&
    echo "$compName-$appTo installed and started."
else
    cd $appTo
        git checkout $compName
        git fetch
        git pull
        workdir=`pwd`
        npm install
        mkdir logs
        cd ..
    #file="$workdir/../$appTo.sh"
    #echo -e "-------\nfile:$file\nworkdir:$workdir\nserversHome:$serversHome\ncompName:$compName\nappTo:$appTo" >>$appTo.debug.log
    if [ ! -f "./$appTo.sh" ]; then
        echo "generate $appTo.sh"
        echo -e  "#!/bin/bash/\ncd $workdir \npm2 start $main  --name \"$compName-$appTo\"">$appTo.sh
            sh $appTo.sh&
            echo "$compName-$appTo installed and started."
    fi
    echo "$compName-$appTo is exist,you can install it after stop and  delete app and rm $compName/$appTo."
    echo -e  "start app:\n  pm2 start $compName-$appTo\nstop app:\n pm2 stop $compName-$appTo\ndelete app:\n    pm2 delete $compName-$appTo\nremove dir:\n  mv $serversHome/$compName/$appTo $serversHome/$compName/$appTo.bak"
fi
cd $serversHome/deployTool 
install.sh内容如下：

#!/bin/bash
echo "部署AAA的短信网关"
sh unit.sh AAA sms_gateway gateway /home/node/servers www
echo "部署AAA的数据api服务"
sh unit.sh AAA sms_web web /home/node/servers www
echo "部署AAA的portal服务"
sh unit.sh AAA sms_cv cv /home/node/servers server.js
echo "部署BBB的短信网关"
sh unit.sh BBB sms_gateway gateway /home/node/servers www
echo "部署BBB的数据api服务"
sh unit.sh BBB sms_web web /home/node/servers www
echo "部署BBB的portal服务"
sh unit.sh BBB sms_cv cv /home/node/servers server.js