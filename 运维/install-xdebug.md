# install-xdebug

Download xdebug-2.6.1.tgz , you can use wget ( wget -O ~/downlaods/xdebug-2.6.1.tgz http://xdebug.org/files/xdebug-2.6.0.tgz )
Unpack the downloaded file with tar -xvzf xdebug-2.6.1.tgz
Run: cd xdebug-2.6.1
Run: phpize (See the FAQ if you don't have phpize.)
As part of its output it should show:

Configuring for:
...
Zend Module Api No:      20170718
Zend Extension Api No:   320170718
Run: ./configure
./configure --with-php-config=/usr/local/php/bin/php-config
Run: make
Run: cp modules/xdebug.so /usr/lib/php/20170718
Update /etc/php/7.2/cli/php.ini and change the line
zend_extension = /usr/lib/php/20170718/xdebug.so


PHP Api Version:         20180731
Zend Module Api No:      20180731
Zend Extension Api No:   320180731

修改cdrom 挂载
:/etc# vim fstab