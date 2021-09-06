# Debian 如何修改默认网卡为 eth0

Debian 系统安装以后，可能会遇到网卡设备名不是常见的 eth0 的情况。我们有没有办法统一网卡设备名称呢？

在服务器环境中，统一网卡设备名是很有必要的。标准化的配置会节省我们大量的时间，这些时间可能会花在排障、监控的配置、状态收集脚本的调整等。

这里我们介绍如何把 Debian 系统中的网卡从非 eth0，调整为 eth0，这个设备名是各 Linux 系统中比较通用的网卡设备名。下面我们以设备名 ens3 为例，介绍在Debian 系统中，如何修改网卡设备名为 eth0 的具体步骤。

首选，我们需要编辑 grub 的配置文件，修改启动参数。使用编辑器打开 /etc/default/grub， 查找：

GRUB_CMDLINE_LINUX=""


GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
修改后记得保存。随后修改网络的配置文件，调整网卡设备名：

sed -i 's/ens3/eth0/g' /etc/network/interfaces
sed -i 's/enp3s0/eth0/g' /etc/network/interfaces
最后重新生成 grub 引导配置文件，并重启系统。

grub-mkconfig -o /boot/grub/grub.cfg

debian9配置

IP配置
DNS配置
debian系统中重启网络
debian源设置
其他
IP配置
# vim /etc/network/interfaces

#开机自动激活eth0接口 
auto eth0 
#配置eth0接口为静态设置IP地址 
iface eth0 inet static 
address 192.168.60.110
netmask 255.255.255.0  
gateway 192.168.60.2

DNS配置
# vim /etc/resolv.conf
nameserver 114.114.114.114
1
2
debian系统中重启网络
systemctl restart networking
1
debian源设置
设置软件安装源
cp /etc/apt/sources.list /etc/apt/sources.list.ori
vi /etc/apt/sources.list    
#替换为以下内容    
deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib
deb http://mirrors.aliyun.com/debian-security stretch/updates main
deb-src http://mirrors.aliyun.com/debian-security stretch/updates main
deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib
deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib

更新软件包列表
apt-get update    
1
安装ssh服务
root@debian:~# apt-get install ssh -y
root@debian:~# grep Root /etc/ssh/sshd_config #修改sshd配置
#PermitRootLogin prohibit-password
PermitRootLogin yes
root@debian:~# systemctl restart sshd

其他
升级系统所有软件
# apt-get upgrade
1
升级系统版本
# apt-get dist-upgrade
1
也可以使用图形化管理工具 aptitude



1.Windows VMware tools安装步骤：

      如果虚拟机没有安装系统，“VMware Tools”是安装不上的，所以安装VMware Tools之前必须保证你已经安装了vmware

截图


      1、把你的VMware开机，正常进入虚拟的windows操作系统中。然后选择虚拟机菜单上的“虚拟机->安装 VMware Tools”菜单
      2、正常情况下，软件会自动加载windows的VMware Tools的镜像文件（windows.iso），并自动启动安装程序。
      3、如果你的虚拟机未能自动加载镜像文件，可以打开“虚拟机”-“设置”-“硬件（CD/DVD）”手动加载windows.iso文件，然后回到虚拟机系统，刷新一下，光驱盘符就会显示已经加载的镜像文件了。
      4、双击光驱盘即可启动VMware Tools安装程序（也可以打开光驱盘符，运行里面的setup.exe程序）


截图


      2.linux系统安装vmware Tools（下面以CentOS为例）：
    
      1、打开VMware Workstation虚拟机，开启CentOS系统
      虚拟机-安装VMware Tools
      登录CentOS终端命令行
      2、mkdir /media/mnt    #新建挂载目录
      mount /dev/cdrom    /media/mnt/      #挂载VMware Tools安装盘到/media/mnt/目录
      cd /media/mnt/    #进入安装目录
      ll   #查看
      cp    VMwareTools-8.8.1-528969.tar.gz    /home    #复制文件到/home目录
      3、tar -zxvf VMwareTools-9.6.2-1688356.tar.gz #解压（VMwareTools-9.6.2-1688356.tar.gz这个名称不同的版本是不同的，这里是以VMware 10.03的版本为例）
      cd vmware-tools-distrib   #进入文件目录
      ./vmware-install.pl  #安装
      一直按enter即可
      最后，重启服务器，VMwareTools安装成功。


after i update my sources.list, i enter the following on the terminal

apt-get update && apt-get dist-upgrade

after the updates type

apt-get install open-vm-tools-desktop fuse

then

reboot

apt-get install gcc-multilib
