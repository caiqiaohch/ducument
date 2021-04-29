修改文件后

git add file

用法

git commit --amend

合并缓存的修改和上一次的提交，用新的快照替换上一个提交。缓存区没有文件时运行这个命令可以用来编辑上次提交的提交信息，而不会更改快照。

修改提交信息

git commit --amend 

//修改提交信息操作
git push --force-with-lease origin master

修改用户信息

git commit --amend --author="userName <userMail>"
git push --force-with-lease origin master
————————————————
版权声明：本文为CSDN博主「mandagod」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/mandagod/article/details/115632978
