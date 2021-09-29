Git下的冲突解决

Git在push时如果版本比服务器上的旧，会提示先进行pull。

问题是pull时如果服务器上的版本与你本地的版本在源文件修改上有冲突，那么在解决冲突前push都会失败。

用git status可以查看冲突文件。

pi@raspberrypi:~/project/XXX $ git status
On branch master
Your branch and 'origin/master' have diverged,
and have 1 and 2 different commits each, respectively.
  (use "git pull" to merge the remote branch into yours)
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)

    both modified:   Get-Data.py
接下来用git diff指令查看具体哪里起冲突
--- a/Get-Data.py 表示这是编辑分支a对该源文件的见解
+++ b/Get-Data.py表示这是编辑分支b对该源文件的见解

pi@raspberrypi:~/project/XXX $ git diff
diff --cc Get-Data.py
index 3d7faa9,b4c2d9a..0000000
--- a/Get-Data.py
+++ b/Get-Data.py
@@@ -97,12 -95,12 +95,18 @@@ end to start data collect thread of eac
  while True:
      time.sleep(Write_Freq)
  
 -    #print '=============Write Data==============='
 +    print '=============Write Data==============='
这里还有一些其他指令，在冲突规模比较大的时候可以很方便的确认哪里不对。
git diff --ours：看本体分支对源文件的改动
git diff --theirs：看服务器分支对源文件的改动
git diff --base：看双方对源文件的改动，base和不加base的区别就是base选项会现实双方改动中即使不冲突的部分，默认diff则只会显示冲突部分。

解决冲突有两种方式：
1：用checkout把本地或远程分支的改动全部取消

git checkout --ours
git checkout --theirs
2：使用git mergetool工具解决，其实就是用vim编辑，在解决大规模冲突的时候会比较累。而且由于vim的功能限制，颜色表现等等很多地方不尽如人意。
3：使用ATOM等编辑器的功能进行Merge【推荐使用】，以ATOM示例，编辑器会自动检测冲突的地方，然后让你自己选择a还是b，理想情况下鼠标点点点就能解决冲突。

解决冲突后再次查看git status

pi@raspberrypi:~/project/XXX $ git status
On branch master
Your branch and 'origin/master' have diverged,
and have 1 and 2 different commits each, respectively.
  (use "git pull" to merge the remote branch into yours)
All conflicts fixed but you are still merging.
  (use "git commit" to conclude merge)

Changes to be committed:

    modified:   Get-Data.py
接下来就可以放心大胆的commit了，当然如果冲突里改错了，就需要回溯再改。

作者：Kichirin
链接：https://www.jianshu.com/p/9382a0e3402a
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。