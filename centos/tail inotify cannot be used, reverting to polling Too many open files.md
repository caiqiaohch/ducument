# tail: inotify cannot be used, reverting to polling: Too many open files

tail -f catalina.out 出现警告：

 tail: inotify cannot be used, reverting to polling: Too many open files

```
lsof | awk '{ print $2; }' | sort -rn | uniq -c | sort -rn | head
```

查到是tomcat进程打开了很多文件，处理方法：

在 /etc/sysctl.conf文件中加入下面的配置：

fs.inotify.max_user_watches=1048576
fs.inotify.max_user_instances=1048576

 

sysctl -p /etc/sysctl.conf 使修改生效。再次执行 tail -f catalina.out 就可以了。

转载于:https://www.cnblogs.com/digdeep/p/11153069.html