如何缩小svn库

1.准备工作 　　打开命令行提示符,输入命令：

  svnlook youngest d:/SVNRepository ，查看当前最新的版本号，显示最新版本记录为755。

2.备份版本库 （很重要，我在尝试过程中出现过失败，幸亏有备份，不然就over了）

　把D盘的版本库，备份到C盘，同时清除历史日志，输入命令：svnadmin hotcopy --clean-logs d:/SVNRepository c:/SVNRepository ，这样备份后版本库从3.34G变为3.24G。

3.dump需要保留的版本

  输入：svnadmin dump c:/SVNRepository -r 745:755 > d:/repo_dump_745_755.dmp ，3.24G的版本库dump出来后变成760M，苗条不少。

4.删除就版本库

  输入命令：rmdir /s/q d:/SVNRepository ，删除旧版本库。也可以直接在资源管理器里删除。

5.创建空的版本库 　　输入命令：svnadmin create d:/SVNRepository ，检查空的版本库大概31.2K大小。

6.把dump文件导入版本库 　　输入命令：

   svnadmin load d:/SVNRepository < d:/repo_dump_745_755.dmp ，这时屏幕上会显示正在载入版本库中的文件或正在提交/装载的版本。

完成后，用命令svnlook youngest d:/SVNRepository 查看，显示当前版本库最新版本号是11，整个版本库大小501M。
————————————————
版权声明：本文为CSDN博主「寒天一点冰」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/cfl2011/java/article/details/78772564