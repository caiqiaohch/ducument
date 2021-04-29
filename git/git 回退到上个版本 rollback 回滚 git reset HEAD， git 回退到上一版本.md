git回退到上个版本

 
git reset --hard HEAD^

 
 回退到前3次提交之前，以此类推，回退到n次提交之前

git reset --hard HEAD~3
查看commit的sha码

git log

git show dde8c25694f34acf8971f0782b1a676f39bf0a46

 退到/进到 指定commit的sha码

git reset --hard dde8c25694f34acf8971f0782b1a676f39bf0a46 
强推到远程

git push origin HEAD --force
https://www.cnblogs.com/spring87/p/7867435.html

 

# 把git add添加进去的文件撤销添加

git reset HEAD 相对路径名

git reset HEAD public/uploads/
git练习地址：

https://learngitbranching.js.org/?locale=en_US

相关文章: 

git add 后撤销 git reset HEAD 文件路径

git 准备提交代码，发现修改的分支不对。
————————————————
版权声明：本文为CSDN博主「mandagod」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/mandagod/article/details/110131879
https://blog.csdn.net/haluoluo211/article/details/80559341