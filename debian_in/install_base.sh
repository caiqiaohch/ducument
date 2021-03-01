#!/bin/bash

#cp /etc/apt/sources.list sources_bak.list 
#cp ./inst_base/sources.list /etc/apt/sources.list

apt-get update

apt-get install ntp

cp ./inst_base/rcS /etc/default/rcS

apt-get install psmisc -y

apt-get install bison -y

apt-get install libcurl4-openssl-dev -y

apt-get install uuid-dev -y

#----------------------安装lnmp6.0----------------------------

#echo "start install lnmp6.0"

#wget http://soft.vpser.net/lnmp/lnmp1.6.tar.gz -cO lnmp1.6.tar.gz && tar zxf lnmp1.6.tar.gz && cd lnmp1.6 && ./install.sh lnmp
#./debian.sh
#---------------------配置最大开启文件数--------------------------
echo "fs.file-max=65536" >> /etc/sysctl.conf 
sysctl -p 

cp ./inst_conf/limits.conf /etc/security/limits.conf
#----------------------修改时区------------------------------------
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime