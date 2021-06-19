使用 git 自动部署代码

按照这套操作执行，你可以搭建一个小型的服务端 git 仓库，并支持自动更新。前提是本地和线上都安装有 git

线上执行，有以下前提，如果对 Linux 账户、权限这块不熟，服务器操作用 root

# 进入家目录
cd ~
# 创建服务器代码仓库文件夹，位置为 /root/code.git
mkdir code.git
# 创建裸仓库
git init --bare
本机执行，以下命令在代码根目录执行

# 创建本地代码仓库
git init
# 添加代码文件到仓库（会添加所有文件，需要排除文件自行编写 .gitignore）
git add .
# 提交到暂存区
git commit -m "init commit"
# 关联远程仓库
git remote add origin root@{你的线上IP}:/root/code.git
# 推送到远程仓库（会让你输入 root 密码，你可以配密钥来不用输密码）
git push origin master
在线上操作，在你的程序目录，即 www 目录，假定位置为 /var/www/

# 克隆线上仓库，此时线上会有你的初始代码库代码，此时程序代码位置为 /var/www/code
git clone /root/code.git
编写自动更新 hook

# 进入 hook 目录
cd ~/code.git/hooks
# 编写更新 hooks，创建 hook 文件，注意文件名必须一样
touch post-receive
# 将以下内容写入
unset GIT_DIR
cd /var/www/code
git pull origin master
exit 0
# 授予 hook 权限
chmod 777 post-receive
Copy
本地改动

git add .
git commmit -m "update something"
git push origin master
现在访问你的程序已经更新了。这套方法，适合小团队，而且多人合作开发用这套的话，还是需要要一个懂一个 git 的人。不然你肯定会面对：git 冲突、分离头指针问题、分支管理等问题。所以你还是要学习 git 相关的基础。当然操作中及后期使用有问题，可以在这里回复，我看了会帮你解决

————————————————
原文作者：夜晚的雨
转自链接：https://learnku.com/articles/50277
版权声明：著作权归作者所有。商业转载请联系作者获得授权，非商业转载请保留以上作者信息和原文链接。