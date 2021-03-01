vmware共享文件夹
环境： 

VMware Workstation 11.0

虚拟机中的系统：Ubuntu 16.04

物理机：window 7

安装好vmware tools后在 /mnt/hgfs 里没有东西，是空白的！

解决办法：

安装open-vm-tools

sudo apt-get install open-vm-tools
然后一路按回车。

安装好后可以使用vmhgfs-fuse命令，比如在虚拟机里有个目录 ~/share,终端中切换到家目录，然后：

vmhgfs-fuse share
这样就把windows里的目录共享到了ubuntu里了。当然前提是在虚拟机设置里已经设置好了共享文件夹。

如果要在开机是自动挂载共享文件夹，则需更改/etc/fstab文件。打开文件后在最后添加：

.host:/         /mnt/hgfs               fuse.vmhgfs-fuse allow_other,defaults   0       0
 

 

在debian jessie中的方法不一样！

sudo apt-get install open-vm-tools
sudo apt-get install open-vm-tools-desktop
安装完这2个后，在终端中使用 vmhgfs-fuse不管用：

vmhgfs-fuse
bash: vmhgfs-fuse: command not found
挂载有个提示，但是实际上可以挂载：

sudo mount -t vmhgfs .host:/ /mnt/hgfs
Could not add entry to mtab, continuing
设置为开机挂载：

.host:/    /mnt/hgfs    vmhgfs    defaults    0    0


#mount -t cifs --verbose -o username=linking,password="841a",vers=2.1,sec=krb5 //192.168.1.29/kebie /home/haoyou/share
#mount -t cifs --verbose -o username=linking,password="8a",vers=2.1,sec=krb5 //192.168.1.35/share /home/haoyou/share35
mount.cifs //192.168.1.29/kebie /home/haoyou/share -o username=linking,password="84a"
mount.cifs //192.168.1.35/share /home/haoyou/share35 -o username=linking,password="84a"
#/mnt/hgfs/kebie

#/mnt/hgfs/kebie/skynet_server/server-master