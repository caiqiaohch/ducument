debugfs /dev/hda1的问题?/?
如果你不小心误删除了一个重要的文件，如rm -rf kkk ,而kkk是你的一个非常重要的文件，你肯定非常痛苦，这时你千万不能惊慌，应该马上停止向你的硬盘写入任何文件。它完全是可以恢复的。(我这里专门针对ext2文件系统写了如下的内容，其它的文件系统也有办法，我以后在写)：
#debugfs /dev/hda1(被删除文件所在的分区)
debugfs:lsdel
就可列出你最近被删除文件的inode表，大致如下：
Inode Owner Mode Size Blocks Time deleted
依此是节点表号，属主，文件属性(即读、写等)，大小，block(一般1block=1K),被删除时的时间。有了这些信息，你应该能很快就判断出那个文件是你想恢复的。这时用
debugfs:dump <你想恢复的inode表值> /home/directory(到那个目录)
OK！就这么简单,在/home/directory中可以找到它。



可我运行了,,

[root@Snoopy Desktop]# debugfs /dev/hda1
debugfs 1.32 (09-Nov-2002)
/dev/hda1: Bad magic number in super-block while opening filesystem
debugfs: lsdel
lsdel: Filesystem not open
debugfs:

我想知道这里为什么说filesystem not open???

如何给开启啊 ????在service里是哪一个啊 ???

作者: Snoopy   发布时间: 2003-06-08
man debugfs

作者: tmcco   发布时间: 2003-06-08
[root//root]debugfs
debugfs 1.27 (8-Mar-2002)
debugfs: open /dev/hda2
debugfs: lsdel
...
debugfs:? //可以获得关于debugfs帮助的命令列表
不过debugfs似乎只对ext2文件系统有效1

作者: KornLee   发布时间: 2003-06-08
[root@Snoopy c]# debugfs
debugfs 1.32 (09-Nov-2002)
debugfs: open /dev/hda10
debugfs: lsdel
Inode Owner Mode Size Blocks Time deleted
0 deleted inodes found.
debugfs:

是不是没得救了啊?

作者: Snoopy   发布时间: 2003-06-09
引用:
最初由 pinksnoopy 发表
[root@Snoopy c]# debugfs
debugfs 1.32 (09-Nov-2002)
debugfs: open /dev/hda10
debugfs: lsdel
Inode Owner Mode Size Blocks Time deleted
0 deleted inodes found.
debugfs:

是不是没得救了啊?
应该是debugfs不支持你的filesystem.
下面是使用debugfs的例子

/sbin/debugfs -w /dev/fd0
debugfs 1.32 (09-Nov-2002)
debugfs: lsdel
Inode Owner Mode Size Blocks Time deleted
12 0 100644 668 1/ 1 Mon Jun 9 10:36:10 2003
1 deleted inodes found.
debugfs: undel <12> test.txt 恢复test.txt
make_link: Ext2 inode is not a directory
debugfs: ls 看看恢复了没有
2 (12) . 2 (12) .. 11 (20) lost+found 12 (980) test.txt
debugfs:q 退出

作者: seablue   发布时间: 2003-06-09
可以先用 df 查看你的linux装在哪里,e.g.

# df
文件系统 容量 已用 可用 已用% 挂载点
/dev/hda4 1.8G 972M 751M 57% / <--linux partition
/dev/hda1 4.9G 980M 4.0G 20% /mnt/win_c

可是都不显示档案名,要如何知道哪一个才是我要的档案??

作者: firewolf   发布时间: 2003-06-09
Filesystem 1K-blocks Used Available Use% Mounted on
/dev/hda11 8554648 5228860 2891232 65% /
/dev/hda10 101089 9943 85927 11% /boot
none 256900 0 256900 0% /dev/shm
/dev/hda1 9757936 3112952 6644984 32% /mnt/c
/dev/hda5 10231392 8441584 1789808 83% /mnt/d
/dev/hda6 10231392 4413104 5818288 44% /mnt/e
/dev/hda7 20472816 5854848 14617968 29% /mnt/f
/dev/hda8 10231392 5150056 5081336 51% /mnt/g
/dev/hda9 9212256 8388432 823824 92% /mnt/h


[root@Snoopy root]# debugfs -w /dev/fd0
debugfs 1.32 (09-Nov-2002)
/dev/fd0: Read-only file system while opening filesystem
debugfs: lsdel
lsdel: Filesystem not open
debugfs: open /dev/sda1
debugfs: lsdel
Inode Owner Mode Size Blocks Time deleted
0 deleted inodes found.

作者: Snoopy   发布时间: 2003-06-09
/dev/fd0 是你的软盘啊
你的应该用

# debugfs -w /dev/hda11

作者: firewolf   发布时间: 2003-06-09
root@Snoopy root]# debugfs -w /dev/hda11
debugfs 1.32 (09-Nov-2002)
debugfs: lsdel
Inode Owner Mode Size Blocks Time deleted
0 deleted inodes found.
debugfs:

ls -d /usr/local/mysql

作者: Snoopy   发布时间: 2003-06-09
