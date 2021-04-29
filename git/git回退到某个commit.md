git回退到某个commit

git log查看提交历史及提交的commit_id

回退命令：
  
$ git reset --hard HEAD^         回退到上个版本
$ git reset --hard HEAD~3        回退到前3次提交之前，以此类推，回退到n次提交之前
$ git reset --hard commit_id     退到/进到 指定commit的sha码
 
 
强推到远程：
 
$ git push origin HEAD --force
————————————————
版权声明：本文为CSDN博主「mandagod」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/mandagod/article/details/110225778