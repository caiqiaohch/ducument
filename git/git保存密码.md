1、执行保存账号命令

# 保存本地仓库的账号
git config --local credential.helper store

# 保存git全局账号
git config --global credential.helper store

 

2、执行一般git命令，clone、pull等。输入账号密码，命令执行完成后，即保存了账号密码。下次执行git命令不会要求再次输入。

 

注意：如果第一次输入账号密码是错的，一定要在下次执行一般git命令前，先执行保存命令以重新接受新的账号密码。

https方式每次都要输入密码，按照如下设置即可输入一次就可以很长时间不用再手输入密码。

首先执行下面的命令（如果不执行下面的命令，可能会导致设置无效）

git config --global user.email "你的git的注册邮箱"
git config --global user.user"你的git用户名"
然后输入一次用户密码，再根据自己的需求执行下面的任意一条命令


1、设置记住密码（默认15分钟）：
git config --global credential.helper cache

2、如果想自己设置时间，可以这样做：
git config credential.helper 'cache --timeout=3600'
这样就设置一个小时之后失效

3、长期存储密码：
git config --global credential.helper store

4、增加远程地址的时候带上密码也是可以的。(推荐)
http://yourname:password@git.oschina.net/name/project.git
