Git查看更改

比如，我们查看提交详细信息后，需要修改代码，或添加更多的代码，或者对比提交结果。
下面使用git log命令查看日志详细信息。
$ git log
Shell
执行上面命令后，得到以下输出结果 - 
$ git log
commit be24e214620fa072efa877e1967571731c465884
Author: your_name <your_email@mail.com>
Date:   Fri Jul 7 18:58:16 2017 +0800

    ？？mark

commit 5eccf92e28eae94ec5fce7c687f6f92bf32a6a8d
Author: your_name <your_email@mail.com>
Date:   Fri Jul 7 18:52:06 2017 +0800

    this is main.py file commit mark use -m option

commit 6e5f31067466795c522b01692871f202c26ff948
Author: your_name <your_email@mail.com>
Date:   Fri Jul 7 18:42:43 2017 +0800

    this is main.py file commit mark without use "-m" option

commit 290342c270bc90f861ccc3d83afa920169e3b07e
Author: Maxsu <769728683@qq.com>
Date:   Fri Jul 7 16:55:12 2017 +0800

    Initial commit

Administrator@MY-PC /D/worksp/sample (master)
$
Shell
使用git show命令查看某一次提交详细信息。 git show命令采用SHA-1提交ID作为参数。
$ git show be24e214620fa072efa877e1967571731c465884
commit be24e214620fa072efa877e1967571731c465884
Author: your_name <your_email@mail.com>
Date:   Fri Jul 7 18:58:16 2017 +0800

    ？？mark

diff --git a/main.py b/main.py
index 91a1389..657c8d0 100644
--- a/main.py
+++ b/main.py
@@ -3,3 +3,5 @@

 print ("Life is short, you need Python !")

+# this is a comment line
+
Shell
上面显示的结果中，可以看到符号 “+“ ，表示添加的内容。如果有 “-”则表示删除的内容，现在我们打开 main.py ，把注释行去掉并定义一个变量。修改后的 main.py 的内容如下所示 - 
#!/usr/bin/python3
#coding=utf-8

print ("Life is short, you need Python !")

a = 10
b = 20
Python
然后使用命令：git stauts 查看当前工作区状态 - 
$ git status
On branch master
Your branch is ahead of 'origin/master' by 3 commits.
  (use "git push" to publish your local commits)

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   main.py

no changes added to commit (use "git add" and/or "git commit -a")
Shell
测试代码后，通过运行git diff命令来回顾他的更改。
$ git diff
diff --git a/main.py b/main.py
index 95053b4..a4f953e 100644
--- a/main.py
+++ b/main.py
@@ -4,4 +4,6 @@
 print ("Life is short, you need Python !")


-number = 100
+a = 10
+
+b = 20
Shell
可以看到符号 “+“ (绿色)，表示添加的内容。如果有 “-”(红色)则表示删除的内容。执行的效果如下所示 - 

现在使用以下命令将文件：main.py 添加到 git 暂存区，然后提交代码完成 - 
$ git add main.py
$ git commit -m "define two var a & b "
Shell
最近修改的代码已提交完成。//原文出自【易百教程】，商业转载请联系作者获得授权，非商业请保留原文链接：https://www.yiibai.com/git/git_review_changes.html

