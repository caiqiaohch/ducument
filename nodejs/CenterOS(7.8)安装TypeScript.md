CenterOS(7.8)安装TypeScript 后执行tsc报tsc command not found 解决办法

我是一座离岛 2020-09-29 09:02:08  792  收藏
版权
起因：
在CenterOS安装typesctipt编译环境

npm install -g typescript

查看版本
tsc -v

报tsc command not found错误
解决：
进入nodejs安装目录bin目录

cd /usr/local/node-v12.18.4/bin/
查看文件

[root@flymegoc bin]# ls
node  npm  npx  tsc  tsserver
[root@flymegoc bin]#
正确的话能看到文件tsc
试试运行

[root@flymegoc bin]# ./tsc -v
Version 4.0.3
1
2
ok，没有问题，安装是成功

执行链接

ln -s /usr/local/node-v12.18.4/bin/tsc  /usr/local/bin/tsc
1
根据自己的路径修改

再次验证tsc

[root@flymegoc bin]# tsc -v
Version 4.0.3.

git clone https://github.com/chxuan/vimplus.git ~/.vimplus
cd ~/.vimplus
./install.sh
