git mergetool命令

git mergetool命令用于运行合并冲突解决工具来解决合并冲突。
使用语法
git mergetool [--tool=<tool>] [-y | --[no-]prompt] [<file>…]
Shell
描述git mergetool命令用于运行合并冲突解决工具来解决合并冲突。使用git mergetool运行合并实用程序来解决合并冲突。它通常在git合并后运行。
如果给出一个或多个<file>参数，则将运行合并工具程序来解决每个文件的差异(跳过那些没有冲突的文件)。 指定目录将包括该路径中的所有未解析文件。 如果没有指定<file>名称，git mergetool将在具有合并冲突的每个文件上运行合并工具程序。
示例以下是一些示例 -
git设置 mergetool 可视化工具
可以设置BeyondCompare,DiffMerge等作为git的比较和合并的可视化工具,方便操作。
设置如下:先下载并安装 BeyondCompare,DiffMerge 等，这里以 BeyondCompare 为例。设置git配置,设置 BeyondCompare 的git命令如下:
#difftool 配置  
git config --global diff.tool bc4  
git config --global difftool.bc4.cmd "\"c:/program files (x86)/beyond compare 4/bcomp.exe\" \"$LOCAL\" \"$REMOTE\""


#mergeftool 配置  
git config --global merge.tool bc4
git config --global mergetool.bc4.cmd  "\"c:/program files (x86)/beyond compare 4/bcomp.exe\" \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\""  
git config --global mergetool.bc4.trustExitCode true

#让git mergetool不再生成备份文件(*.orig)  
git config --global mergetool.keepBackup false
Shell
使用方法如下:

diff使用方法:
git difftool HEAD // 比较当前修改情况
merge使用方法
git mergetool//原文出自【易百教程】，商业转载请联系作者获得授权，非商业请保留原文链接：https://www.yiibai.com/git/git_mergetool.html


git log --all --decorate --oneline --graph