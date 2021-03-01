#测试机器的硬件信息
#查看CPU信息（型号）
echo "cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c ----------------"
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c 
#      8  Intel(R) Xeon(R) CPU            E5410   @ 2.33GHz 
#(看到有8个逻辑CPU, 也知道了CPU型号) 
echo "cat /proc/cpuinfo | grep physical | uniq -c ------------------"
cat /proc/cpuinfo | grep physical | uniq -c 
#      4 physical id      : 0 
#      4 physical id      : 1 
#(说明实际上是两颗4核的CPU) 
echo "getconf LONG_BIT ----------------------------------"
getconf LONG_BIT 
#   32 
#(说明当前CPU运行在32bit模式下, 但不代表CPU不支持64bit) 
echo "cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l --------------------"
cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l 
#   8 
#(结果大于0, 说明支持64bit计算. lm指long mode, 支持lm则是64bit)
#再完整看cpu详细信息, 不过大部分我们都不关心而已. 
echo "dmidecode | grep 'Processor Information'-----------------------------"
dmidecode | grep 'Processor Information'
#查看内 存信息 
eecho "cat /proc/meminfo--------------------------------------"
cat /proc/meminfo
echo "";
echo "uname -a-----------------------------"
uname -a
echo "";
#Linux euis1 2.6.9-55.ELsmp #1 SMP Fri Apr 20 17:03:35 EDT 2007 i686 i686 i386 GNU/Linux 
#(查看当前操作系统内核信息)
echo "cat /etc/issue | grep Linux-----------------"
cat /etc/issue | grep Linux
echo "";
#Red Hat Enterprise Linux AS release 4 (Nahant Update 5) 
#(查看当前操作系统发行版信息)
#查看机器型号
echo "dmidecode | grep "Product Name"---------------"
dmidecode | grep "Product Name"
echo "";
#查看硬盘信息
echo "df----------------------------------------------"
df
echo "";
#查看网卡信息
echo "dmesg | grep -i eth-----------------------------"
dmesg | grep -i eth
echo "";