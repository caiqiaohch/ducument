#!/bin/bash


cp ./inst_conf/my.cnf /etc/

#--------------------php-fpm.conf修改------------------------------------

cp ./inst_conf/php-fpm.conf /usr/local/php/etc/

cp ./inst_conf/cut_nginx_log.sh /usr/local/nginx/sbin/
cp ./inst_conf/crontab /etc/

#--------------------修改MySQL启动脚本/etc/init.d/mysql------------------

cp ./inst_conf/mysql /etc/init.d/
cp ./lib/libmysqlclient.so.15 /usr/lib

#--------------------nginx.conf修改--------------------------------------

cp ./inst_conf/nginx.conf /usr/local/nginx/conf/

/usr/local/nginx/sbin/nginx -s reload
 

#--------------------修改MySQL数据库路径---------------------------------

cd /home
mkdir data
/etc/init.d/mysql stop
mv /usr/local/mysql/var /home/data/

chown -R mysql:mysql /home/data/var/

#--------------------------启动MySQL-------------------------------------

cd /root
/etc/init.d/mysql start



