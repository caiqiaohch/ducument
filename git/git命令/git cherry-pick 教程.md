对于多分支的代码库，将代码从一个分支转移到另一个分支是常见需求。

这时分两种情况。一种情况是，你需要另一个分支的所有代码变动，那么就采用合并（git merge）。另一种情况是，你只需要部分代码变动（某几个提交），这时可以采用 Cherry pick。

一、基本用法
git cherry-pick命令的作用，就是将指定的提交（commit）应用于其他分支。

$ git cherry-pick <commitHash>
上面命令就会将指定的提交commitHash，应用于当前分支。这会在当前分支产生一个新的提交，当然它们的哈希值会不一样。

举例来说，代码仓库有master和feature两个分支。


    a - b - c - d   Master
         \
           e - f - g Feature
现在将提交f应用到master分支。

# 切换到 master 分支
$ git checkout master

# Cherry pick 操作
$ git cherry-pick f
上面的操作完成以后，代码库就变成了下面的样子。

    a - b - c - d - f   Master
         \
           e - f - g Feature
从上面可以看到，master分支的末尾增加了一个提交f。

git cherry-pick命令的参数，不一定是提交的哈希值，分支名也是可以的，表示转移该分支的最新提交。

$ git cherry-pick feature
上面代码表示将feature分支的最近一次提交，转移到当前分支。

二、转移多个提交
Cherry pick 支持一次转移多个提交。


$ git cherry-pick <HashA> <HashB>
上面的命令将 A 和 B 两个提交应用到当前分支。这会在当前分支生成两个对应的新提交。

如果想要转移一系列的连续提交，可以使用下面的简便语法。


$ git cherry-pick A..B 
上面的命令可以转移从 A 到 B 的所有提交。它们必须按照正确的顺序放置：提交 A 必须早于提交 B，否则命令将失败，但不会报错。

注意，使用上面的命令，提交 A 将不会包含在 Cherry pick 中。如果要包含提交 A，可以使用下面的语法。


$ git cherry-pick A^..B 
三、配置项
git cherry-pick命令的常用配置项如下。

（1）-e，--edit

打开外部编辑器，编辑提交信息。

（2）-n，--no-commit

只更新工作区和暂存区，不产生新的提交。

（3）-x

在提交信息的末尾追加一行(cherry picked from commit ...)，方便以后查到这个提交是如何产生的。

（4）-s，--signoff

在提交信息的末尾追加一行操作者的签名，表示是谁进行了这个操作。

（5）-m parent-number，--mainline parent-number

如果原始提交是一个合并节点，来自于两个分支的合并，那么 Cherry pick 默认将失败，因为它不知道应该采用哪个分支的代码变动。

-m配置项告诉 Git，应该采用哪个分支的变动。它的参数parent-number是一个从1开始的整数，代表原始提交的父分支编号。


$ git cherry-pick -m 1 <commitHash>
上面命令表示，Cherry pick 采用提交commitHash来自编号1的父分支的变动。

一般来说，1号父分支是接受变动的分支（the branch being merged into），2号父分支是作为变动来源的分支（the branch being merged from）。

四、代码冲突
如果操作过程中发生代码冲突，Cherry pick 会停下来，让用户决定如何继续操作。

（1）--continue

用户解决代码冲突后，第一步将修改的文件重新加入暂存区（git add .），第二步使用下面的命令，让 Cherry pick 过程继续执行。


$ git cherry-pick --continue
（2）--abort

发生代码冲突后，放弃合并，回到操作前的样子。

（3）--quit

发生代码冲突后，退出 Cherry pick，但是不回到操作前的样子。

五、转移到另一个代码库
Cherry pick 也支持转移另一个代码库的提交，方法是先将该库加为远程仓库。


$ git remote add target git://gitUrl
上面命令添加了一个远程仓库target。

然后，将远程代码抓取到本地。


$ git fetch target
上面命令将远程代码仓库抓取到本地。

接着，检查一下要从远程仓库转移的提交，获取它的哈希值。


$ git log target/master
最后，使用git cherry-pick命令转移提交。


$ git cherry-pick <commitHash>
（完）

概述
git cherry-pick可以理解为”挑拣”提交，它会获取某一个分支的单笔提交，并作为一个新的提交引入到你当前分支上。当我们需要在本地合入其他分支的提交时，如果我们不想对整个分支进行合并，而是只想将某一次提交合入到本地当前分支上，那么就要使用git cherry-pick了。

用法
git cherry-pick [<options>] <commit-ish>...

常用options:
    --quit                退出当前的chery-pick序列
    --continue            继续当前的chery-pick序列
    --abort               取消当前的chery-pick序列，恢复当前分支
    -n, --no-commit       不自动提交
    -e, --edit            编辑提交信息
git cherry-pick commitid
在本地仓库中，有两个分支:branch1和branch2，我们先来查看各个分支的提交：

# 切换到branch2分支
$ git checkout branch2
Switched to branch 'branch2'
$
$
# 查看最近三次提交
$ git log --oneline -3
23d9422 [Description]:branch2 commit 3
2555c6e [Description]:branch2 commit 2
b82ba0f [Description]:branch2 commit 1
# 切换到branch1分支
$ git checkout branch1
Switched to branch 'branch1'
# 查看最近三次提交
$ git log --oneline -3
20fe2f9 commit second
c51adbe commit first
ae2bd14 commit 3th

现在，我想要将branch2分支上的第一次提交内容合入到branch1分支上，则可以使用git cherry-pick命令：

$ git cherry-pick 2555c6e
error: could not apply 2555c6e... [Description]:branch2 commit 2
hint: after resolving the conflicts, mark the corrected paths
hint: with 'git add <paths>' or 'git rm <paths>'
hint: and commit the result with 'git commit'

当cherry-pick时，没有成功自动提交，这说明存在冲突，因此首先需要解决冲突,解决冲突后需要git commit手动进行提交：

$ git commit
[branch1 790f431] [Description]:branch2 commit 2
 Date: Fri Jul 13 18:36:44 2018 +0800
 1 file changed, 1 insertion(+)
 create mode 100644 only-for-branch2.txt
或者git add .后直接使用git cherry-pick --continue继续。现在查看提交信息：

$ git log --oneline -3
790f431 [Description]:branch2 commit 2
20fe2f9 commit second
c51adbe commit first
branch2分支上的第二次提交成功合入到了branch1分支上。以上就是git cherry-pick的基本用法，如果没有出现冲突，该命令将自动提交。

git cherry-pick -n
如果不想git cherry-pick自动进行提交，则加参数-n即可。比如将branch2分支上的第三次提交内容合入到branch1分支上：

$ git cherry-pick 23d9422
[branch1 2c67715] [Description]:branch2 commit 3
 Date: Fri Jul 13 18:37:05 2018 +0800
 1 file changed, 1 insertion(+)
$
查看提交log,它自动合入了branch1分支：

$ git log --oneline -3
2c67715 [Description]:branch2 commit 3
f8bc5db [Description]:branch2 commit 2
20fe2f9 commit second
如果不想进行自动合入，则使用git cherry-pick -n：

# 回退上次提交，再此进行cherry-pick
$ git reset --hard HEAD~
HEAD is now at f8bc5db [Description]:branch2 commit 2
$ git cherry-pick -n 23d9422
$ git status
On branch branch1
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    modified:   only-for-branch2.txt

$
这时通过git status查看，发现已将branch2的提交获取但是没有合入

git cherry-pick -e
如果想要在cherr-pick后重新编辑提交信息，则使用git cherry-pick -e命令，比如我们还是要将branch2分支上的第三次提交内容合入到branch1分支上，但是需要修改提交信息：

$ git cherry-pick -e 23d9422

  1 [Description]:branch2 commit 3
  2 #
  3 # It looks like you may be committing a cherry-pick.
  4 # If this is not correct, please remove the file
  5 #       .git/CHERRY_PICK_HEAD
  6 # and try again.
git cherry-pick –continue, –abort，–quit
当使用git cherry-pick发生冲突后,将会出现如下信息：

$ git cherry-pick 23d9422
error: could not apply 23d9422... [Description]:branch2 commit 3
hint: after resolving the conflicts, mark the corrected paths
hint: with 'git add <paths>' or 'git rm <paths>'
hint: and commit the result with 'git commit'
这时如果要继续cherry-pick，则首先需要解决冲突，通过git add .将文件标记为已解决，然后可以使用git cherry-pick --continue命令，继续进行cherry-pick操作。如果要中断这次cherry-pick,则使用git cherry-pick --quit，这种情况下当前分支中未冲突的内容状态将为modified，如果要取消这次cherry-pick,则使用git cherry-pick --abort，这种情况下当前分支恢复到cherry-pick前的状态，没有改变。

git cherry-pick < branchname >
如果在git cherry-pick后加一个分支名，则表示将该分支顶端提交进cherry-pick

$ git cherry-pick master
git cherry-pick ..< branchname >
git cherry-pick ^HEAD < branchname >
以上两个命令作用相同，表示应用所有提交引入的更改，这些提交是branchname的祖先但不是HEAD的祖先，比如，现在我的仓库中有三个分支，其提交历史如下图：

C<---D<---E  branch2
              /
master   A<---B
              \
F<---G<---H  branch3
                         |
HEAD
如果我使用git cherry-pick ..branch2或者git cherry-pick ^HEAD branch2,那么会将属于branch2的祖先但不属于branch3的祖先的所有提交引入到当前分支branch3上，并生成新的提交，执行命令如下:

$ git cherry-pick ..branch2
[branch3 c95d8b0] [Description]:branch2  add only-for-branch2
 Date: Fri Jul 13 20:34:40 2018 +0800
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 only-for-branch2
[branch3 7199a67] [Description]:branch2 modify for only-for-branch2--1
 Date: Fri Jul 13 20:38:35 2018 +0800
 1 file changed, 1 insertion(+)
[branch3 eb8ab62] [Description]:branch2 modify for only-for-branch2--2
 Date: Fri Jul 13 20:39:09 2018 +0800
 1 file changed, 1 insertion(+)
执行后的提交历史如下：

C<---D<---E  branch2
/
master   A<---B
\
F<---G<---H<---C'<---D'<---E'  branch3
|
HEAD
常见问题
1.The previous cherry-pick is now empty, possibly due to conflict resolution.
原因:
在cherry-pick时出现冲突，解决冲突后本地分支中内容和cherry-pick之前相比没有改变，因此当在以后的步骤中继续git cherry-pick或执行其他命令时，由于此时还处于上次cherry-pick，都会提示该信息，表示可能是由于解决冲突造成上一次cherry-pick内容是空的。

解决方案:
1.执行git cherry-pick --abort取消上次操作。2.执行git commit --allow-empty,表示允许空提交。

2.fatal: You are in the middle of a cherry-pick – cannot amend.
原因:
在cherry-pick时出现冲突，没有解决冲突就执行git commit --amend命令，从而会提示该信息。

解决方案:
首先在git commit --amend之前解决冲突，并完成这次cherry-pick:

$ git add .
$ git cherry-pick --continue 