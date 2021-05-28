查了很多博客，最后看了 https://segmentfault.com/a/1190000007748862 成功地把本地的提交合并了。不过因为我这些commit已经push到远程上了，所以和文章里的步骤有点不同，这里把自己用的方法分享一下。

比如，如果我们想合并 最近三个 提交

首先查看提交历史： git log

commit 3ca6ec340edc66df13423f36f52919dfa3......
 
commit 1b4056686d1b494a5c86757f9eaed844......
 
commit 53f244ac8730d33b353bee3b24210b07......
 
commit 3a4226b4a0b6fa68783b07f1cee7b688.......
然后执行  git rebase -i HEAD~3

或执行  git rebase -i 3a4226     填的是第4个commit的版本号，即合并这个commit之后的所有commit (不包括这个)

执行了rebase命令之后，会弹出一个窗口

pick 3ca6ec3   '注释**********'
 
pick 1b40566   '注释*********'
 
pick 53f244a   '注释**********'
将除了第一个的pick，其他都改为 s 或 squash

pick 3ca6ec3   '注释**********'
 
s 1b40566   '注释*********'
 
s 53f244a   '注释**********'
修改后保存退出，这时 git log 一下，发现提交已经合并

到这里以后，  git status  后会看到，提示让你git pull一下，千万不要这样做！否则你会发现这三条白合并了，还平白多了两条commit

这时候，需要强制push上去  git push -f ， 当然要确保强制push不会覆盖了别人的代码，如果这个分支只有你维护那就可以为所欲为了

到此，合并多个远程分支成功~
————————————————
版权声明：本文为CSDN博主「c小刺猬」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_21744873/article/details/82629343

如果想要放弃当前rebase操作，用 git rebase --abort
如果冲突已经解决，先add冲突文件，之后 git rebase --continue