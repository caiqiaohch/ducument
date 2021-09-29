git删除远程分支

1. git删除远程分支

git push origin --delete [branch_name]

2. 删除本地分支区别
git branch -d 会在删除前检查merge状态（其与上游分支或者与head）。
git branch -D 是git branch --delete --force的简写，它会直接删除。

共同点
都是删除本地分支的方法（与删除远程分支命令相独立，要想本地和远程都删除，必须得运行两个命令）。

3. git查看分支：
查看本地分支 git branch
查看远程分支 git branch -r
查看本地和远程分支 git branch -a

4.git删除分支：
删除本地分支 git branch -d 本地分支名
删除远程分支 git push origin --delete 远程分支名
推送空分支到远程（删除远程分支另一种实现）git push origin :远程分支
————————————————
版权声明：本文为CSDN博主「mandagod」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/mandagod/article/details/115633164
