**openssl升级降级**

1、下载源码包：

wget http://www.openssl.org/source/openssl-1.0.2d.tar.gz    

2、安装到/usr/local/ssl/目录下：

tar zxvf openssl-1.0.2d.tar.gz    

cd openssl-1.0.2d

./config --prefix=/usr/local/ssl 

make && make install 

mv -f /usr/bin/openssl /usr/bin/openssl.old

mv -f /usr/include/openssl /usr/include/openssl.old

   

ln  -s /usr/local/ssl/bin/openssl /usr/bin/openssl    #修改软链，指向新版本的openssl路径

ln -s /usr/local/ssl/include/openssl /usr/include/openssl



echo "/usr/local/ssl/lib">>/etc/ld.so.conf 

#添加so库的路径，添加完成之后，运行ldconfig ,将新增的so 文件缓存到/etc/ld.so.cache中；



ldconfig -v    

openssl version -a   #确认版本是否为1.0.2d



3、以上编译过程，可以做成自动化脚本，用于快速升级openssl版本。