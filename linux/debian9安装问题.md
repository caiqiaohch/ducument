# **debian9安装问题**

aws磁盘扩展

Teng:
sudo su -
/sbin/parted ---pretend-input-tty /dev/nvme0n1 resizepart 2 yes 100%

Teng:
resize2fs /dev/nvme0n1p2


ssh-keygen -p -f andor.pem
ssh-keygen -e -f andor.pem > andor.pem.pub


$chmod 400 andor.pem

$ ssh-keygen -e -f andor.pem > andor.pem.pub

sudo -i

----------

root@instance-hjjm7257:/home/haoyou/lfs99/game_os# ./ActiveDB_f -mac                       
-bash: ./ActiveDB_f: No such file or directory
解决办法：
apt-get install lib32ncurses5 lib32z1  

----------
root@instance-hjjm7257:/home/haoyou/lfs99/game_os# ./ActiveDB_f -mac
./ActiveDB_f: error while loading shared libraries: libstdc++.so.6: wrong ELF class: ELFCLASS64

----------


(apt-get install nano sudo -y)

nano /etc/apt/sources.list 

deb http://httpredir.debian.org/debian/ jessie main contrib non-free

apt-get update && apt-get upgrade -y

sudo dpkg --add-architecture i386; sudo apt-get install libstdc++6:i386 -y

----------
默认网卡从eth0变成eth3了


centos 
yum install glibc-devel.i686 libstdc++-devel.i686
yum -y install glibc-devel
yum install xulrunner.i686