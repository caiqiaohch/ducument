详解Redis开启远程登录连接
redis默认只能localhost登录，所以需要开启远程登录。

一、修改 redis.conf
1、将 bind 127.0.0.1 ::1 这一行注释掉。
这里的bind指的是只有指定的网段才能远程访问这个redis。 注释掉后，就没有这个限制了。或者bind 自己所在的网段。
band localhost 只能本机访问,局域网内计算机不能访问。
bind 局域网IP 只能局域网内IP的机器访问, 本地localhost都无法访问。
验证方法：

[work@el ~]$ ps -ef | grep redis
work     30830     1  0 11:38 ?        00:00:00 /usr/local/bin/redis-server *:6379
2、将 protected-mode 要设置成no （默认是设置成yes的， 防止了远程访问，在redis3.2.3版本后）
3、设置远程连接密码
取消注释 requirepass foobared，将 foobared 改成任意密码，用于验证登录。默认是没有密码的就可以访问的，我们这里最好设置一个密码。
4、重启 reids

二、防火墙放行 6379 端口
编辑/etc/sysconfig/iptables，添加

-A INPUT -m state --state NEW -m tcp -p tcp -s 127.0.0.1 --dport 6379 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp -s 126.212.173.185 --dport 6379 -j ACCEP
以上只对本机和126.212.173.185开放6379端口，其他ip用telnet是无法连接的。如果访问ip没有限制，就不需要添加-s ip地址了,例如

-A INPUT -m state --state NEW -m tcp -p tcp --dport 6379 -j ACCEPT
重新启动防火墙

 service iptables start
二、阿里云添加安全组

很明显，没有包含6379端口。然后点击右上的“添加安全组规则” 。填写如下内容即可。 同理，如果准备使用其它端口，务必来添加相应安全规则。

然后确定。再重启redis-server，就可以愉快的运行阿里云服务器上的redis了。o(￣▽￣)ｄ