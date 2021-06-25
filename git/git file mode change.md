近期在做ffmpeg版本合并时发现，TortoiseGit的Check for Modifications的修改对话框中有未修改的问题，直接导出diff，会有类似下面的输出：

compat/plan9/head            |   0

diff --git a/compat/plan9/head b/compat/plan9/head
old mode 100755
new mode 100644
但修改行和添加行都是0，搜索查找发现，主要问题是由于文件权限问题。
由于在windows下没有对应数字的文件权限，而在*nix中确有，上面的数字含义755=rwxrw_rw_, 644=rw_r__r__，而100表示文件。
由于直接从linux到windows下clone，相关权限信息可能丢失。
解决方法如下：

命令行下使用
git config core.filemode false

通过TortoiseGit的Setting配置
右键-TortoiseGit-Settings，选择左侧列表框中的Git，然后在右侧对话框中选择Edit Local .git/config
将下面配置项修改（filemode 改为 false）
[core]
  filemode = false
直接修改代码仓库 .git 目录里的 config 文件的 filemode (在 [core] 段中)字段，将其改为 false。
如果要全局修改的话，加 --global 选项：

git config --global core.filemode false
或者通过TortoiseGit配置。

core.fileMode
If false, the executable bit differences between the index and the
working copy are ignored; useful on broken filesystems like FAT.
See git-update-index(1). True by default.

通过上面修改之后，在命令行中调用git diff输出的patch是正常的，但是在TortoiseGit的修改对话框中可能还是不对，如果一定要解决，建议把当前代码修改备份下，重新pull一份就可以了。

参考：
[1] http://stackoverflow.com/questions/1257592/how-do-i-remove-files-saying-old-mode-100755-new-mode-100644-from-unstaged-cha