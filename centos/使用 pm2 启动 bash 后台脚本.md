使用 pm2 启动 bash 后台脚本

我们常常会使用 bash 写一些后台运行的守护进程，然后使用 crontab 实现开机启动并监控，也可以改为使用 pm2 来运行，功能更强大，更简单规范。

使用 pm2 来管理后台进程仍然可以获得其大部分功能，如：

日志管理
监控
进程管理
开机启动
崩溃重启
如下定义 process.json

{
  apps : [{
    name      : "run-log-analyze",
    script    : "./tools/run-log-analyze.sh",
    env: {
    },
    merge_logs: true,
    error_file: "tools/run-log-analyze.log",
    out_file: "tools/run-log-analyze.log",
    exec_mode: "fork"
  }]
}
run-log-analyze.sh 用于实时分析应用的日志

tail -f ./run.log | bunyan --strict -c 'this.msg == "file uploaded"' -0 | json -ga file | ./tools/file-scan -o ./tools/file-scan-successed.log -e ./tools/file-scan-failed.log
上面的脚本不断读取 run.log，将上传的文件路径名提取出来，然后传给文件扫描程序（./tools/file-scan），扫描成功日志文件为 ./tools/file-scan-successed.log，扫描失败日志文件为 ./tools/file-scan-failed.log。

现在在尝试启动进程

pm2 start process.json
查看进程运行状态

pm2 list
然后尝试重启

pm2 restart process.json
发现后台有两个 file-scan 及 tail -f ./run.log 进程，restart 没有将子进程杀死，不过父进程 /bin/bash 进程倒是杀死了。

估计是 bash 使用 pm2 fork-mode 运行后，其终端被 detach 了，相当于是后台 daemon 进程，bash 进程死掉后， tail -f ./run.log 进程收不到 SIGHUP 信号也就没有跟着退出。

可以利用 tail 命令的参数 -pid ，指定 bash 结束时中断 tail -f 命令

man tail

–pid=PID with -f, terminate after process ID, PID dies

将 run-log-analyze.sh 改写如下

tail -f --pid=$$ ./run.log | bunyan --strict -c 'this.msg == "file uploaded"' -0 | json -ga file | ./tools/file-scan -o ./tools/file-scan-successed.log -e ./tools/file-scan-failed.log