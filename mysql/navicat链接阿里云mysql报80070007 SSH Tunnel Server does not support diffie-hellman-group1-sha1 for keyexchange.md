navicat链接阿里云mysql报80070007: SSH Tunnel: Server does not support diffie-hellman-group1-sha1 for keyexchange

http://www.jianshu.com/p/200572ed066c
navicat 链接数据库

使用navicat 的ssh通道连接数据库回遇到权限问题
错误代码如下：

80070007: SSH Tunnel: Server does not support diffie-hellman-group1-sha1 for keyexchange

解决方案如下：
1、进入 /etc/ssh/sshd_config 在最下面 加入下面代码

KexAlgorithms diffie-hellman-group1-sha1,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1
Ciphers 3des-cbc,blowfish-cbc,aes128-cbc,aes128-ctr,aes256-ctr

2、执行下面代码

ssh-keygen -A

3.重启SSH
service ssh restart
