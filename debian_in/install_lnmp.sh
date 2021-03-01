#!/bin/bash




#----------------------°²×°lnmp6.0----------------------------

echo "start install lnmp6.0"

wget http://soft.vpser.net/lnmp/lnmp0.6.tar.gz

tar -xvf lnmp0.6.tar.gz

cd lnmp0.6

./debian.sh 2>&1 | tee lnmp.log 
#./debian.sh

echo "install lnmp6.0 finish!"


