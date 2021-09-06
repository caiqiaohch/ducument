# pm2 cluster模式下log4js日志不打印问题

上礼拜第一次使用pm2的cluster模式，因为我的是node，利用pm2的cluster模式比较简单，采坑采坑；

常规操作就是在pm2启动文件配置 instances 和 exec_mode 字段，前一个定义实例个数，后者指定模式（fork / cluster）

复制代码
{
  "apps": [{
    "name": "test",
    "script": "app.js",
    "watch": false,
    "error_file": "./logs/err.log",
    "out_file": "./logs/out.log",
    "log_date_format": "YYYY-MM-DD HH:mm Z",
    "instances" : 0,             // 0 和 max 同义
    "exec_mode" : "cluster",
    "env": {
      "NODE_ENV": "dev"
    }
  }]
}    
复制代码
然后在log4js配置文件加 pm2: true

复制代码
const log4js = require('log4js');

log4js.configure({
    pm2: true,        // 没错就是这行
    appenders: {....},
    categories: {....}
});
复制代码
但是！！！常规操作在我这竟然失误了！！！pm2启动项目 启动日志( info )没有 警告日志正常的 挠后脑勺ing 怎么办上网查

在网上看到有同道中人贴出了解决之法: 

1. 安装 pm2 的 pm2-intercom 进程间通信模块（其实我的日志不打印问题装了这个模块之后就正常了，但是人方法还没结束，继续往下看）

pm2 install pm2-intercom
2. 在启动文件里加个配置  instance_var

复制代码
{
  "apps": [{
    "name": "test",
    "script": "app.js",
    "watch": false,
    "error_file": "./logs/err.log",
    "out_file": "./logs/out.log",
    "log_date_format": "YYYY-MM-DD HH:mm Z",
    "instance_var": "INSTANCE_ID",   // 这里这里
    "instances" : 0,
    "exec_mode" : "cluster",
    "env": {
      "NODE_ENV": "dev"
    }
  }]
}
复制代码
3. 在log4js配置文件也加个配置 pm2InstanceVar 

复制代码
const log4js = require('log4js');

log4js.configure({
    pm2: true,        
    pm2InstanceVar: 'INSTANCE_ID',    // 这里这里
    appenders: {....},
    categories: {....}
});
复制代码
然后重新起项目，日志正常打印了，但是！！！有个问题，上图：



每条日志的id是同一个，我把请求日志的 pid 也就是进程id打印出来，发现是我的四个进程id，也就是说日志都由其中一个进程在打印，这无疑会给这个进程相对多的压力，这不是我想要的，pm2 cluster模式不是多实例多进程的吗，为什么日志统一由一个进程打印？？；据说是log4js在pm2 cluster模式下只有一个进程写日志，其他进程的日志会发送到这个进程，如果不是这个原因或者我的操作有问题请大家指正；

暂时只能这样，之后我会用其他方式吧，pm2 本身的日志分割我会去看看能不能按天分割，如果可以我会把log4js换下来，一个进程打日志实在不能忍

其实除了上面的这种方法，还有一种，但是这种方法多进程同时写一个文件的时候会有冲突，导致日志丢失，所以我没有用这个方法

上面的方法都不用做，只要在log4js配置里加 disableClustering

复制代码
const log4js = require('log4js');

log4js.configure({
    pm2: true,        
    disableClustering: true,    // 这里这里
    appenders: {....},
    categories: {....}
});
复制代码
就只加一行，每个进程个自打印日志；

就这样 明日周末万岁 L('ω')┘三└('ω')｣

PS: 我把log4js 换了 winston，有兴趣的可以看下篇。