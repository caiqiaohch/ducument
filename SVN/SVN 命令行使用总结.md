# SVN 命令行使用总结

[发表评论](https://www.jiloc.com/46003.html#respond)

Table of Contents

- [1 上传项目到SVN服务器上](https://www.jiloc.com/46003.html#SVN)
- [2 下载checkout svn项目到本地](https://www.jiloc.com/46003.html#checkout_svn)
- [3 添加新文件](https://www.jiloc.com/46003.html#i)
- [4 提交到版本库](https://www.jiloc.com/46003.html#i-2)
- [5 更新文件](https://www.jiloc.com/46003.html#i-3)
- [6 查看文件或者目录状态](https://www.jiloc.com/46003.html#i-4)
- [7 删除文件](https://www.jiloc.com/46003.html#i-5)
- [8 查看日志（显示文件的所有修改记录，及其版本号的变化）](https://www.jiloc.com/46003.html#i-6)
- [9 查看文件详细信息](https://www.jiloc.com/46003.html#i-7)
- [10 比较差异](https://www.jiloc.com/46003.html#i-8)
- [11 合并文件（将两个版本之间的差异合并到当前文件）](https://www.jiloc.com/46003.html#i-9)
- [12 SVN 帮助](https://www.jiloc.com/46003.html#SVN-2)
- [13 版本库下的文件和目录列表](https://www.jiloc.com/46003.html#i-10)
- [14 创建纳入版本控制下的新目录](https://www.jiloc.com/46003.html#i-11)
- [15 恢复本地修改](https://www.jiloc.com/46003.html#i-12)
- [16 代码库URL变更](https://www.jiloc.com/46003.html#URL)
- [17 解决冲突](https://www.jiloc.com/46003.html#i-13)
- [18 输出指定文件或URL的内容](https://www.jiloc.com/46003.html#URL-2)
- [19 查看svn版本](https://www.jiloc.com/46003.html#svn)
- [20 新建分支branchs，在分支上继续开发](https://www.jiloc.com/46003.html#branchs)
- [21 该版本完成，打tag，发布版本](https://www.jiloc.com/46003.html#tag)

## 上传项目到SVN服务器上

svn import project_dir（本地项目全路径） http://192.168.1.242:8080/svn/IOS/Ben/remote_dir（svn项目全路径） -m “必填, 不填此命令执行不会成功.”
注: 服务器上remote_dir若不存在, 会自动创建;
只会上传project_dir目录下的文件到remote_dir的目录下
import之后, project_dir并没有自动转化为工作目录, 需要重新checkout(后面会用到)

## 下载checkout svn项目到本地

svn checkout http://192.168.1.242:8080/svn/IOS/remote_dir (svn项目全路径）project_dir（本地目录全路径) –username 用户名 –password 密码

svn checkout 简写：svn co

## 添加新文件

svn add file（文件名）
svn add *.php(添加当前目录下所有的php文件)

## 提交到版本库

svn commit -m “LogMessage” [-N] [–no-unlock] PATH(如果选择了保持锁，就使用–no-unlock开关)
svn commit -m “提交当前目录下的全部在版本控制下的文件“ * （ *表示全部文件 ）

例如：svn commit -m “add test file for my test” test.php
svn commit -m “提交我的测试用test.php“ -N –no-unlock test.php （ 保持锁就用–no-unlock开关 ）
注意：必须带上-m参数，参数可以为空（””）

svn commit 简写：svn ci

## 更新文件

svn　update
svn　update　-r　修正版本　文件名
svn　update　文件名
例如：
svn update （后面没有目录，默认将当前目录以及子目录下的所有文件都更新到最新版本）
svn update -r 200 test.cpp （ 将版本库中的文件 test.cpp 还原到修正版本（revision）200）
svn update test.php （ 更新与版本库同步 ）
　　提交的时候提示过期冲突，需要先 update 修改文件，
　　然后清除svn resolved，最后再提交commit。

svn　update 间写： svn up

## 查看文件或者目录状态

1）svn status path（目录下的文件和子目录的状态，正常状态不显示）
【?：不在svn的控制中；M：内容被修改；C：发生冲突；A：预定加入到版本库；K：被锁定】
2）svn status -v path(显示文件和子目录状态)
第一列保持相同，第二列显示工作版本号，第三和第四列显示最后一次修改的版本号和修改人。
注：svn status、svn diff、svn revert这三条命令在没有网络的情况下也可以执行的，原因是svn在本地的.svn中保留了本地版本的原始拷贝。

svn status 简写：svn st

## 删除文件

svn delete path -m “delete test fle”
例如：svn delete svn://192.168.1.1/pro/domain/test.php -m “delete test file”
推荐使用：
svn delete test.php
svn ci -m ‘delete test file‘

svn delete 简写：svn del／remove／rm

## 查看日志（显示文件的所有修改记录，及其版本号的变化）

svn log path

svn log -l 3查看最新的三条记录
例如：svn log test.php

## 查看文件详细信息

svn info path
例如：svn info test.php

## 比较差异

svn diff path(将修改的文件与基础版本比较)
例如：svn diff test.php
svn diff -r m:n path(对版本m和版本n比较差异)
例如：svn diff -r 200:201 test.php

svn diff 简写：svn di

## 合并文件（将两个版本之间的差异合并到当前文件）

svn merge -r m:n path
例如：
svn merge -r 200:205 test.php（将版本200与205之间的差异合并到当前文件，但是一般都会产生冲突，需要处理一下）

## SVN 帮助

svn help 全部功能选项
svn help ci 具体功能的说明

## 版本库下的文件和目录列表

svn list path
显示path目录下的所有属于版本库的文件和目录

svn list 简写：svn ls

## 创建纳入版本控制下的新目录

svn mkdir newdir
例如：
svn mkdir -m “Making a new dir.” svn://localhost/test/newdir
用法: 1、mkdir PATH…
2、mkdir URL…
创建版本控制的目录。
1、每一个以工作副本 PATH 指定的目录，都会创建在本地端，并且加入新增
调度，以待下一次的提交。
2、每个以URL指定的目录，都会透过立即提交于仓库中创建。
（在这两个情况下，所有的中间目录都必须事先存在）

注：添加完子目录后，一定要回到根目录更新svn update一下，不然在该目录下提交文件会提示“提交失败”
注：如果手动在checkout出来的目录里创建了一个新文件夹newsubdir，
　　 再用svn mkdir newsubdir命令后，SVN会提示：
　　svn: 尝试用 “svn add”或 “svn add –non-recursive”代替？
　　svn: 无法创建目录“hello”: 文件已经存在
　　 此时，用如下命令解决：
　　svn add –non-recursive newsubdir
　　在进入这个newsubdir文件夹，用ls -a查看它下面的全部目录与文件，会发现多了：.svn目录
　　再用 svn mkdir -m “添hello功能模块文件” svn://localhost/test/newdir/newsubdir 命令，
　　SVN提示：
　　svn: File already exists: filesystem ‘/data/svnroot/test/db’, transaction ‘4541-1’,
　　path ‘/newdir/newsubdir ‘

## 恢复本地修改

svn revert: 恢复原始未改变的工作副本文件 (恢复大部份的本地修改)。
用法: revert PATH…
注意: 本子命令不会存取网络，并且会解除冲突的状况。但是它不会恢复
被删除的目录
svn revert foo.c ＜－ 丢弃对一个文件的修改
svn revert –recursive . ＜－恢复一整个目录的文件，. 为当前目录

## 代码库URL变更

svn switch (sw): 更新工作副本至不同的URL。
用法: 1、switch URL [PATH]
2、switch –relocate FROM TO [PATH…]
1、更新你的工作副本，映射到一个新的URL，其行为跟“svn update”很像，也会将
服务器上文件与本地文件合并。这是将工作副本对应到同一仓库中某个分支或者标记的
方法。
2、改写工作副本的URL元数据，以反映单纯的URL上的改变。当仓库的根URL变动
(比如方案名或是主机名称变动)，但是工作副本仍旧对映到同一仓库的同一目录时使用
这个命令更新工作副本与仓库的对应关系。

svn switch 间写： svn sw

## 解决冲突

svn resolved: 移除工作副本的目录或文件的“冲突”状态。
用法: resolved PATH…
注意: 本子命令不会依语法来解决冲突或是移除冲突标记；
它只是移除冲突的相关文件，然后让 PATH 可以再次提交。

## 输出指定文件或URL的内容

svn cat 目标[@版本]…如果指定了版本，将从指定的版本开始查找。
svn cat -r PREV filename > filename (PREV 是上一版本,也可以写具体版本号,这样输出结果是可以提交的)

## 查看svn版本

svn —-version

## 新建分支branchs，在分支上继续开发

1、svn mkdir branches
2、svn copy svn://server/trunk svn://server/branches/ep -m “init ep”

## 该版本完成，打tag，发布版本

1、svn mkdir tags
2、svn copy svn://server/trunk svn://server/tags/release-1.0 -m “1.0 released”

使用发生的一些问题：

1、错误：
svn: Could not use external editor to fetch log message; consider setting the $SVN_EDITOR environment variable or using the –message (-m) or –file (-F) options
svn: None of the environment variables SVN_EDITOR, VISUAL or EDITOR is set, and no ‘editor-cmd’ run-time configuration option was found

问题原因是：
没有设置svn编辑器的环境变量，主要是import、commit中填写comment要用

解决方法：
1、在 终端中 sudo vim /etc/bashrc 打开文件
加入：export SVN_EDITOR=vim
2、编辑完以后一般需要让配置文件立即生效，可执行命令：
source /etc/bashrc（也可以不进行这一步）


2、问题：
不小心提交了一些动态改变根本不需要的文件到svn服务器上
解决：
svn resolved filename 放弃对文件的修改，
svn ci -m “update” 提交所有文件
svn rm test.log 删除掉这个文件。
svn ci -m “update” 再次提交


3、发生冲突：
两人同时修改同一文件同一部分，先后提交，出现冲突
svn ci -m “update”
svn: Commit failed (details follow):
svn: Aborting commit: ‘test.log’ remains in conflict
解决：
A、放弃自己的更新，使用svn revert（回滚），然后提交。在这种方式下不需要使用svn resolved（解决）
B、放弃自己的更新，使用别人的更新。使用最新获取的版本覆盖目标文件，执行resolved filename并提交(选择文件—右键—解决)。
C、手动解决：冲突发生时，通过和其他用户沟通之后，手动更新目标文件。然后执行resolved filename来解除冲突，最后提交。

坚持使用自己的更新，找到.mine的文件名，恢复为原文件名，然后执行：
svn resolved file_name