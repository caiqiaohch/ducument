#���Ի�����Ӳ����Ϣ
#�鿴CPU��Ϣ���ͺţ�
echo "cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c ----------------"
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c 
#      8  Intel(R) Xeon(R) CPU            E5410   @ 2.33GHz 
#(������8���߼�CPU, Ҳ֪����CPU�ͺ�) 
echo "cat /proc/cpuinfo | grep physical | uniq -c ------------------"
cat /proc/cpuinfo | grep physical | uniq -c 
#      4 physical id      : 0 
#      4 physical id      : 1 
#(˵��ʵ����������4�˵�CPU) 
echo "getconf LONG_BIT ----------------------------------"
getconf LONG_BIT 
#   32 
#(˵����ǰCPU������32bitģʽ��, ��������CPU��֧��64bit) 
echo "cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l --------------------"
cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l 
#   8 
#(�������0, ˵��֧��64bit����. lmָlong mode, ֧��lm����64bit)
#��������cpu��ϸ��Ϣ, �����󲿷����Ƕ������Ķ���. 
echo "dmidecode | grep 'Processor Information'-----------------------------"
dmidecode | grep 'Processor Information'
#�鿴�� ����Ϣ 
eecho "cat /proc/meminfo--------------------------------------"
cat /proc/meminfo
echo "";
echo "uname -a-----------------------------"
uname -a
echo "";
#Linux euis1 2.6.9-55.ELsmp #1 SMP Fri Apr 20 17:03:35 EDT 2007 i686 i686 i386 GNU/Linux 
#(�鿴��ǰ����ϵͳ�ں���Ϣ)
echo "cat /etc/issue | grep Linux-----------------"
cat /etc/issue | grep Linux
echo "";
#Red Hat Enterprise Linux AS release 4 (Nahant Update 5) 
#(�鿴��ǰ����ϵͳ���а���Ϣ)
#�鿴�����ͺ�
echo "dmidecode | grep "Product Name"---------------"
dmidecode | grep "Product Name"
echo "";
#�鿴Ӳ����Ϣ
echo "df----------------------------------------------"
df
echo "";
#�鿴������Ϣ
echo "dmesg | grep -i eth-----------------------------"
dmesg | grep -i eth
echo "";