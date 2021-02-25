# systemctl restart network.service
Job for network.service failed because the control process exited with error code. See "systemctl status network.service" and "journalctl -xe" for details.

根据提示查看网卡信息
# systemctl status network.service

查看日志
# cat /var/log/messages |grep network


解决：
百度后很多说是MAC地址或者NetworkManager服务的问题，试过后仍未解决。解铃还须系铃人，试着修改网卡名---
（1）修改网卡名和配置文件
# mv /etc/sysconfig/network-scripts/ifcfg-eno16777736 /etc/sysconfig/network-scripts/ifcfg-eth0
修改配置文件里面name和device
# vi /etc/sysconfig/network-scripts/ifcfg-eth0
TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=eth0
UUID=d890d6e6-01f6-4063-bf70-cd4e1787d0a8
HWADDR=00:50:56:8b:57:82             #这里原文件没有，手动添加上去
DEVICE=eth0
ONBOOT=yes
IPADDR=192.168.70.42
NETMASK=255.255.255.0
GATEWAY=192.168.70.254
（2）修改/etc/sysconfig/grub，添加net.ifnames=0 biosdevname=0
# vi  /etc/sysconfig/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap net.ifnames=0 biosdevname=0 rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
（3）手动生成70-persistent-net.rules以及其他方法
查看接口的MAC地址
# ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno16777728: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
    link/ether 00:0c:29:28:ac:54 brd ff:ff:ff:ff:ff:ff
生成文件
# vi /etc/udev/rules.d/70-persistent-net.rules
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:0c:29:28:ac:54", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"


或

#grub2-mkconfig -o /boot/grub2/grub.cfg            #这个没有试过，有兴趣的可以自己试试

重启机器:
# reboot

重新启动网络：
systemctl start network.service
或者
service network restart

然后把这俩网卡的mac写到配置文件里：

/etc/sysconfig/network-scripts/ifcfg-enp8s0f0
/etc/sysconfig/network-scripts/ifcfg-enp8s0f1

添加：
HWADDR=00:0c:bd:05:4e:cc​

解决方式：禁用NetworkManager

1. systemctl stop NetworkManager
2. systemctl disable NetworkManager


