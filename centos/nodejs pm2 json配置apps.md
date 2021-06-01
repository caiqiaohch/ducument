nodejs pm2 json配置apps

平时自己简单用pm2 start管理自己的node进程，现在机器上起了多个进程，一个个配置比较麻烦，今天查到pm2可以启动一个json配置文件，可以方便的管理多个app。
可以在 processes.json定义应用参数:

{
  "apps" : [{
    "name"        : "echo",
    "script"      : "examples/args.js",
    "args"        : "['--toto=heya coco', '-d', '1']",
    "log_date_format"  : "YYYY-MM-DD HH:mm Z",
    "ignoreWatch" : ["[\\/\\\\]\\./", "node_modules"],
    "watch"       : true,
    "node_args"   : "--harmony",
    "cwd"         : "/this/is/a/path/to/start/script",
    "env": {
        "NODE_ENV": "production",
        "AWESOME_SERVICE_API_TOKEN": "xxx"
    }
  },{
    "name"       : "api",
    "script"     : "./examples/child.js",
    "instances"  : "4",
    "log_date_format"  : "YYYY-MM-DD",
    "log_file"   : "./examples/child.log",
    "error_file" : "./examples/child-err.log",
    "out_file"   : "./examples/child-out.log",
    "pid_file"   : "./examples/child.pid",
    "exec_mode"  : "cluster_mode",
    "port"       : 9005
  },{
    "name"       : "auto-kill",
    "script"     : "./examples/killfast.js",
    "min_uptime" : "100",
    "exec_mode"  : "fork_mode"
  }]
}
然后运行:

$ pm2 start processes.json
$ pm2 stop processes.json
$ pm2 delete processes.json
$ pm2 restart processes.json
启动过以后，可以通过pm2 list查看app，并做相应的处理

name
app启动名称
script
脚本文件位置
cwd
脚本执行的相对路径
-args
脚本执行参数
env
脚本执行前设置的环境变量
log_file
保存log文件路径
error_file
error log文件路径
out_file
out log文件路径

作者：rill_
链接：https://www.jianshu.com/p/58197cb2de71
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。