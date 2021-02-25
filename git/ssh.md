执行ssh-add ~/.ssh/rsa

 报标题上的错误

先执行  eval `ssh-agent`  （是～键上的那个`） 再执行 ssh-add ~/.ssh/rsa成功

ssh-add -l 就有新加的rsa了
如果出现 Permissions 0644 for ‘/root/.ssh/id_rsa’ are too open. 等错误显示了，原来只要把权限降到0600就ok了
输入命令

chmod 0600 /root/.ssh/id_rsa
1
然后就可以密钥登陆了

sftp  -oPort=50022  x@IP

linux，配置ssh方式git clone

JustMarker 2018-09-07 16:00:24  3244  收藏 1
分类专栏： php 文章标签： git ssh git clone linux 克隆
版权
1. cd ~/.ssh，看.ssh目录是否存在，这是存放公钥和私钥的目录（如果存在，可以备份改名）；

2. 设置git的user.name和user.email，这个需要和git仓库保持一致；

3. 用ssh-keygen -t rsa -C "【user.email】" 命令，生成公钥和私钥，在root/.ssh文件夹下（生成过程，一致按回车，默认路径，默认无密码）；

4. 将公钥内容，复制下，到gitee仓库下，添加公钥；

5. 就可以在本地通过git clone 【ssh地址】 【本地项目文件夹】克隆项目了。

  983  ls
  984  ./mongod start
  985  service mongod start
  986  systemctl start mongod
  987  sudo systemctl start mongod
  988  service mongodb start
  989  sudo systemctl unmask mongodb
  990  sudo service mongod start
  991  service mongodb start
  992  ls
  993  cd ..
  994  ls
  995  cd /etc/init.d/
  996  ls
  997  vim mongod
  998  cd /mnt/hgfs/share/server
  999  node app
 1000  cd /home/haoyou
 1001  ls
 1002  cd sourse/
 1003  ssh-add ~/.ssh/id_rsa
 1004  yum install git
 1005  ssh-add ~/.ssh/id_rsa
 1006  eval `ssh-agent`
 1007  ssh-add ~/.ssh/id_rsa
 1008  cd /root/
 1009  chmod -R 0644 .ssh/id_rsa
 1010  ssh-add ~/.ssh/id_rsa
 1011  chmod -R 0644 .ssh
 1012  ssh-add ~/.ssh/id_rsa
 1013  cd /root/
 1014  ls
 1015  cd .ssh
 1016  ls
 1017  ls -la
 1018  chmod 0600 /root/.ssh/id_rsa
 1019  ssh-add id_rsa