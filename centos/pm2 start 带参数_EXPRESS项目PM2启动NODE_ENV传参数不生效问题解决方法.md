pm2 start 带参数_EXPRESS项目PM2启动NODE_ENV传参数不生效问题解决方法

expree项目开发完，涉及到不同环境，要在启动到时候就要配置好环境变量，

packge.json文件如下：

"scripts": {"dev": "NODE_ENV=development DEBUG=name nodemon ./bin/www --name 'name'","start": "NODE_ENV=production pm2 start ./bin/www --name 'name'","uat": "NODE_ENV=uat pm2 start ./bin/www --name 'name'","testStart": "cross-env node ./bin/www --name 'name'"}

在业务场景中，根据不同环境取不同到参数配置：

config/index.js 文件如下：

var path = require('path');//通过NODE_ENV来设置环境变量，如果没有指定则默认为开发环境

var env = process.env.NODE_ENV || 'development';

console.log('env='+env);

env=env.toLowerCase();//载入配置文件

var file =path.resolve(__dirname, env);try{var config = module.exports =require(file);//console.log('Load config: [%s] %s', env, file);

} catch(err) {//console.error('Cannot load config: [%s] %s', env, file);

throwerr;

}

同时 config文件夹下，以你到环境变量为名，命名如下文件 development.js 、 production.js、uat.js.

我本地的uat.js

module.exports ={
NODE_ENV:"uat",

ENV_CONFIG:"uat",

API_ROOT_ADJUSTDEVICE:"http://192.168.2.244:6820", //测试环境 http://192.168.0.111:36820

}

上述写法，本地mac上没有什么问题，执行 npm run uat 的时候，就是process.env.NODE_ENV=uat.

但是部署到linux 系统uat环境，process.env.NODE_ENV一直为undefined。也就是启动的时候

NODE_ENV=uat pm2 start ./bin/www --name 'name' 这个没有正确传递过去。

解决方案如下：

根目录新建一个ecosystem.config.js

module.exports ={
apps : [

{
name:"load",

script:"./bin/www",

watch:true,

env_native: {//"PORT": 3030,

"NODE_ENV": "native","ENV_CONFIG": "native","API_ROOT_ADJUSTDEVICE": "http://192.168.2.244:6820" //本地

},

env_development: {//"PORT": 3030,

"NODE_ENV": "development","ENV_CONFIG": "dev","API_ROOT_ADJUSTDEVICE": "http://192.168.0.16:6820" //开发

},

env_uat: {//"PORT": 3030,

"NODE_ENV": "uat","ENV_CONFIG": "uat","API_ROOT_ADJUSTDEVICE": "http://192.168.2.244:6820" //测试环境 http://192.168.0.111:36820

},

env_pre: {//"PORT": 80,

"NODE_ENV": "pre","ENV_CONFIG": "pre","API_ROOT_ADJUSTDEVICE": "http://192.168.0.60:46820" //预发

},

env_production: {//"PORT": 80,

"NODE_ENV": "production","ENV_CONFIG": "prod","API_ROOT_ADJUSTDEVICE": "http://192.168.0.60:36820" //生产

}

}

]

}

package.json修改如下：

"scripts": {
"dev": "NODE_ENV=development DEBUG=namexxx nodemon ./bin/www --name 'namexxx'",

"start": "pm2 start ecosystem.config.js --env production",

"uat": "pm2 start ecosystem.config.js --env uat"

},

注意  --env后面的参数，要跟ecosystem.config.js 配置项里面的env_后面的保持一致。

运行：

npm run uat

实际上执行的是：

pm2 start ecosystem.config.js --env uat

停止：

pm2 stop id

删除：

pm2 delete id