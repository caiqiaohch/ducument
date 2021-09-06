#  tail

在centos 或者说是在 linux 系统中，例如 tomcat 或者是 ngixn 的log 日志等等

tail -n 20  error.log 

查看 error.log日志文件中的最后 20行 日志内容

tail -n +20  error.log 

查看 error.log日志文件中的最前面的 20行 日志内容

tail -f  error.log 

实时跟踪查看 error.log 日志文件中的内容

2 tail 分页查询日志内容
tail -n 10000  error.log |more -1000  

从 error.log 日志文件中末尾向前 10000 行的位置开始,然后往下找1000行
ctrl+f 快捷键翻页 ，按回车键一行一行的向下加载

tail -n 10000  error.log |less -1000  

从 error.log 日志文件中末尾向前 10000 行的位置开始,然后往上找1000行
ctrl+f 快捷键翻页 ，按回车键一行一行的向上加载

more 与 less 的不同就是一个向后翻页 一个向前翻页
