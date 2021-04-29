背景: 项目GIT地址是A，fork后的项目GIT地址是B。A新增了一个分支branch_xxx后，需要把该分支同步到B。

切换当前路径至本地的fork项目下
cd /本地fork项目路径/
2. 为A起个主机名upstream，已加忽略此部

// 先通过git remote -v命令查看是否已经添加
git remote add upstream A
3. 更新upstream

// 执行后，用git branch -a查看remotes/upstream/branch_xxx是否存在
git fetch upstream
4. 在新分支branch_xxx上创建一个本地分支，创建后两个分支存在追踪关系

git checkout -b branch_xxx --track upstream/branch_xxx
5. 把本地新分支提交到B

// 执行后，用git branch -a查看remotes/origin/branch_xxx是否存在
git push origin branch_xxx
6. 改变本地分支branch_xxx的追踪关系至origin/branch_xxx

// 执行后，用git branch -vv查看
git branch -u origin/branch_xxx
————————————————
版权声明：本文为CSDN博主「mandagod」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/mandagod/article/details/109595428
