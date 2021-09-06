# 阿里云lnmp安装

https://bbs.aliyun.com/read/115941.html
一句话开头：欲善其事，先利其器一直以来，在VPS上没少花时间折腾，本文针对新人，菜鸟级别的网站管理员，如果你是高手，请别吐槽，如发现我有错误，记得指点，小的先谢过。 
服务器配置硬件信息： 
CPU：Intel® Xeon® CPU E5620 @ 2.40GHz | 频率:2400.056 | 二级缓存:12288 KB | Bogomips:4800.11 
物理内存：1G 
硬盘：60G 
LNMP 安装环境步骤
阿里云主机的Linux系统挂载数据盘；
采用LNMP0.9 军哥一键安装包；
添加域名（包括数据库，URL重写规则，301，404错位）；
优化、配置（包括函数的开启，权限的配置）。

第一步 阿里云主机的Linux系统挂载数据盘 
适用系统：Redhat , CentOS 
Linux的云主机数据盘未做分区和格式化，可以根据以下步骤进行分区以及格式化操作。下面的操作将会把数据盘划分为一个分区来使用。
查看数据盘在没有分区和格式化数据盘之前，使用 “df –h”命令，是无法看到数据盘的，可以使用“fdisk -l”命令查看。如下图：
对数据盘进行分区执行“fdisk /dev/xvdb”命令，对数据盘进行分区；根据提示，依次输入“n”，“p”“1”，两次回车，“wq”，分区就开始了，很快就会完成。
查看新的分区使用“fdisk -l”命令可以看到，新的分区xvdb1已经建立完成了。


格式化新分区使用“mkfs.ext3 /dev/xvdb1”命令对新分区进行格式化，格式化的时间根据硬盘大小有所不同。
添加分区信息使用“echo ‘/dev/xvdb1 /mnt ext3 defaults 0 0’ >> /etc/fstab”命令写入新分区信息。然后使用“cat /etc/fstab”命令查看，出现以下信息就表示写入成功。
挂载新分区使用“mount -a”命令挂载新分区，然后用“df -h”命令查看，出现以下信息就说明挂载成功，可以开始使用新的分区了。

OK，到此阿里云主机的Linux系统挂载数据盘搞定，其实很简单。 
安装LNMP0.9 军哥一键安装包 
LNMP简介 
LNMP一键安装包是什么? 
LNMP一键安装包是一个用Linux Shell编写的可以为CentOS/RadHat、Debian/Ubuntu VPS(VDS)或独立主机安装LNMP(Nginx、MySQL、PHP、phpMyAdmin)生产环境的Shell程序。 
我们为什么需要它? 
编译安装需要输入大量的命令，如果是配置生产环境需要耗费大量的时间。不会Linux的站长或Linux新手想使用Linux作为生产环境…… 
它有什么优势? 
无需一个一个的输入命令，无需值守，编译安装优化编译参数，提高性能，解决不必要的软件间依赖，特别针对VPS用户进行了优化。 
如何获取它? 
你可以自由 下载 并使用它在VPS(VDS)或独立服务器上，做为真正的生产环境或测试环境。 
它安装那些软件： 
Nginx 
MySQL 
PHP 
PHPMyAdmin 
Zend Optimizer 
eAccelerator 
Apache(可选) 
ionCube(可选) 
PureFTPd(可选) 
imageMagick(可选) 
memcached(可选) 

菜鸟们如何安装LNMP？ 


LNMP的安装很简单，请查看LNMP安装教程网址： 
http://lnmp.org/install.html 
我这里就不提及如何安装了，主要是分享下安装成功后的经验： 
经验提醒：第一次填写的域名最好是二级域名或IP，这样方便以后管理，如下图： 

通常安装完之后：你会看到一下图片，表示LNMP环境成功了。 

接下来，添加域名（包括数据库，URL重写规则，301，404错误页面） 


添加域名 
执行如下命令：/root/vhost.sh 
根据提示输入要绑定的域名，回车，回车就会自动添加虚拟主机。 
这里经验分享： 网站目录我只定义输入到了 
/var/www/html/www.banyou001.com（请根据你的域名修改） 
如果删除虚拟主机 
ssh执行： rm /usr/local/nginx/conf/vhost/域名.conf 
添加数据库 
通常你第一次输入的二级域名，就可以看到，也就是下图：里面的phpmyadmin。 
经验分享：如果找不到数据库，可以用： 
phpMyAdmin : http://前面输入的域名或IP/phpmyadmin/ 
URL重写规则 
LNMP自带了Discuz、Discuzx、Wordpress、Sablog、Emlog、Dabr、Phpwind、Wp2(二级目录wp伪静态)，可直接输入以上名称即可; 
如果需要添加自定义伪静态规则，直接输入一个想要的名字，程序会自动创建伪静态文件，直接在/usr/local/nginx/conf/你自定义的伪静态名字.conf 里面添加伪静态规则就行。 
经验分享：(添加完自定义伪静态规则执行/etc/init.d/nginx restart 重启生效)。 
LNMP 将带www域名 301 到带www域名 
实现方法： 
以 http://banyou001.com/ 301到 http://www.banyou001.com/为例。 
命令：
cd /usr/local/nginx/conf/vhost下相应的.conf文件
vi cd /usr/local/nginx/conf/vhost下相应的.conf文件
i vhost下相应的.conf文件 开始修改
修改完之后，按ESC，再输入 :wq保存退出。

原代码如下：server { listen 80; server_name www.banyou001.com banyou001.com; index index.html index.htm index.php default.html default.htm default.php; root /var/www/html/www.banyou001.com; include none.conf; location ~ .*\.(php|php5)?$ { fastcgi_pass unix:/tmp/php-cgi.sock; fastcgi_index index.php; include fcgi.conf; } location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ { expires 30d; } location ~ .*\.(js|css)?$ { expires 12h; } access_log off; }  
修改为：server { listen 80; server_name www.banyou001.com;（#这里去除banyou001.com） index index.html index.htm index.php default.html default.htm default.php; root /var/www/html/www.banyou001.com; include none.conf; location ~ .*\.(php|php5)?$ { fastcgi_pass unix:/tmp/php-cgi.sock; fastcgi_index index.php; include fcgi.conf; } location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ { expires 30d; } location ~ .*\.(js|css)?$ { expires 12h; } access_log off; } (这里添加以下代码) server { server_name banyou001.com; rewrite ^(.*) http://www.banyou001.com$1 permanent; }  
最后结果代码如下：server { listen 80; server_name www.banyou001.com; index index.html index.htm index.php default.html default.htm default.php; root /var/www/html/www.banyou001.com; include none.conf; location ~ .*\.(php|php5)?$ { fastcgi_pass unix:/tmp/php-cgi.sock; fastcgi_index index.php; include fcgi.conf; } location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ { expires 30d; } location ~ .*\.(js|css)?$ { expires 12h; } access_log off; } server { server_name banyou001.com; rewrite ^(.*) http://www.banyou001.com$1 permanent; }  
OK 现在访问 http://banyou001.com/ 
试试看，是不是到了 http://www.banyou001.com/ 了呢？ 
404错误页面 
404错误页面对于SEO和用户体验来说都是很重要的。 
那么，LNMP如何实现呢？其实也很简单： 
第一步 编辑Nginx配置文件； 
命令是：vi /usr/local/nginx/conf/nginx.conf 
在http区段添加下面代码：fastcgi_intercept_errors on; 
如图： 
第二步骤编辑网站配置文件，比如本站：命令是： 
vi /usr/local/nginx/conf/vhost/www.banyou001.com.conf 
在server 区段添加下面代码： 
error_page 404 = /404.html; 
如下图： 
第三步 测试配置文件是否正确： 
命令：/usr/local/nginx/sbin/nginx -t 
返回下面代码通过： 
the configuration file /usr/local/nginx/conf/nginx.conf syntax is okconfiguration file /usr/local/nginx/conf/nginx.conf test is successful 
第四步 重启LNMP生效： 
命令：/root/lnmp restart 
404错误页面制作的注意事项：
不要将404错误转向到网站主页，否则可能会导致主页在搜索引擎中被降权或消失
不要使用绝对URL，如果使用绝对URL返回的状态码是302 200，这样会产生大量的重复网页。
404页面设置完成，一定要检查是否正确。http头信息返回的一定要是404状态。这个可以通过服务器头部信息检查工具进行检查。
404页面不要自动跳转，让用户来决定去向。
自定义的404页面必须大于512字节，否则可能会出现IE默认的404页面。


LNMP 优化、配置（包括函数的开启，权限的配置） 


函数的开启 
目前LNMP 0.9禁用了部分危险函数： 
passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_alter,ini_restore,dl,pfsockopen,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket,fsockopen 
手动开启函数 pfsockopen、fsockopen：由于禁用了pfsockopen、fsockopen 会造成 Discuzx Discuz X通行失败，通过Socket连接SMTP无法发送邮件 或wordrpess的Akismet 无法工作： 
解决方法：目前最常可能用到的就是pfsockopen、fsockopen，如果将这2个函数从禁用列表里删除可以执行： 
sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket/g' /usr/local/php/etc/php.ini 
然后执行：/etc/init.d/php-fpm restart重启生效 
手动开启函数scandir 
wordpress3.4后主题管理不显示其他的主题？ 
原因在于scandir没有启用，打开就可以了， 
解决办法：将scandir打开。 
执行： 
sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket/g' /usr/local/php/etc/php.ini 
同理执行：/etc/init.d/php-fpm restart重启生效 
用户的权限的配置 
WordPress后台不能修改主题或插件不能自动升级通常的原因在于权限不够。无法在线修改主题或者更新插件，修改主题无更新选项按钮，升级插件会弹出输入FTP信息的输入框界面，出现此类情况一般都是主题文件权限问题，需要把权限设置给www用户组，比如wordpress安装目录为/var/www/html/www.banyou001.com/ued/ 
解决办法：用Putty或Oppenssh登录VPS，执行： 
chown -R www /var/www/html/www.banyou001.com/ued/ 
伴游云集版权所有 未经应许不得转载 