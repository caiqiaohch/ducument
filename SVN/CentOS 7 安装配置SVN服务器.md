1. 安装
  CentOS通过yum安装subversion。

  ```
  yum install subversion
  ```

   subversion安装在/bin目录：

  ```
  which svnserve #查看目录命令/usr/bin/svnserve
  ```

  检查一下subversion是否安装成功。不要使用1.8版本

  ```
  svnserve --version
  ```

  svnserve, version 1.7.14 (r1542130)

2. 建立版本库
  subversion默认以/var/svn作为数据根目录，可以通过/etc/sysconfig/svnserve修改这个默认位置。

```
vim /etc/sysconfig/svnserve
```

文件内容

```
OPTIONS="-r /var/svn"
```

可修改

可修改

使用svnadmin建立版本库svntest。
```
#### mkdir -p /home/svn/dyh //递归创建多个目录

#### svnadmin create /home/svn/dyh

#### ll /home/svn/dyh //查看目录中内容
```

drwxr-xr-x. 2 root root  51 Nov 10 14:42 conf
drwxr-sr-x. 6 root root 4096 Nov 10 14:42 db
-r--r--r--. 1 root root    2 Nov 10 14:42 format
drwxr-xr-x. 2 root root 4096 Nov 10 14:42 hooks
drwxr-xr-x. 2 root root  39 Nov 10 14:42 locks
-rw-r--r--. 1 root root  229 Nov 10 14:42 README.txt

3. 配置
cd /home/svn/dyh
a、编辑用户文件passwd，新增两个用户：admin和guest。
```
vim conf/passwd
```

[users]
admin = admin
guest = guest
b、编辑权限文件authz，用户admin设置可读写权限，guest设置只读权限。
```
vim conf/authz
```

[/]
admin = rw
guest = r
c、编辑svnserve.conf：
```
vim conf/svnserve.conf
```

[general]anon-access = none #控制非鉴权用户访问版本库的权限
auth-access = write #控制鉴权用户访问版本库的权限
password-db = passwd #指定用户名口令文件名
authz-db = authz #指定权限配置文件名
//realm = svntest #指定版本库的认证域，即在登录时提示的认证域名称 //测试不需要
 4. SVN服务
启动SVN服务。
```
systemctl start svnserve.service
```

检查服务是否启动成功。
```
ps aux | grep svnroot 16349 0.0 0.1 162180 900 ? Ss 15:01 0:00 /usr/bin/svnserve --daemon --pid-file=/run/svnserve/svnserve.pid -r /opt/svn
```

通过netstat可以看到SVN打开了3690端口。
```
netstat -tnlpProto Recv-Q Send-Q Local Address Foreign Address State PID/Program name tcp 0 0 0.0.0.0:3690 0.0.0.0:* LISTEN 16349/svnserve
```

设置成开机启动。
```
systemctl enable svnserve.servic
```

#### e

5. 更改防火墙设置
大坑，注意阿里云要开相应端口3690
```
vim /etc/sysconfig/iptables
```

添加一下两行 vim操作 yy p
-A INPUT -m state –state NEW -m tcp -p tcp –dport 3690 -j ACCEPT
-A OUTPUT -m state –state NEW -m tcp -p tcp –dport 3690 -j ACCEPT //不需要
然后退出编辑，重启防火墙
查看 # iptables -L -n
```
service iptables restart //这是centOS6 的命令
```



```
/bin/systemctl restart iptables.service
```



6. 客户端测试
客户端可以通过TortoriseSVN测试。

Linux下客户端使用SVN
将文件checkout到本地目录svn666
svn checkout svn://127.0.0.1 ./svn666
有修改的时候
```
svn add * //添加文件
```



```
svn commit -m '这是注释内容' //提交
```



```
svn update //更新
```

