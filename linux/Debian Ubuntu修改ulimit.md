Debian/Ubuntu修改ulimit

使用ulimit -a 可以查看当前系统的所有限制值，使用ulimit -n 可以查看当前的最大打开文件数。
新装的linux默认只有1024，当作负载较大的服务器时，很容易遇到error: too many open files。因此，需要将其改大。
使用 ulimit -n 65535 可即时修改，但重启后就无效了。（注ulimit -SHn 65535 等效 ulimit -n 65535，-S指soft，-H指hard)
有如下三种修改方式：
1.在/etc/rc.local 中增加一行 ulimit -SHn 65535
2.在/etc/profile 中增加一行 ulimit -SHn 65535
3.在/etc/security/limits.conf最后增加如下两行记录

* soft nofile 65535
* hard nofile 65535
RedHat系的使用第一种和第三种，修改完成后reboot，就会发现已经是65535了，至于Debian/Ubuntu，总是出问题，以下是针对deb系的Linux发行版修改方法：
第一步：配置/etc/security/limits.conf

sudo vim /etc/security/limits.conf
在文件尾部追加 
* hard nofile 40960
* soft nofile 40960
4096可以自己设置，四列参数的设置见英文，简单讲一下：
第一列，可以是用户，也可以是组，要用@group这样的语法，也可以是通配符如*%
第二列，两个值：hard，硬限制，soft，软件限制，一般来说soft要比hard小，hard是底线，决对不能超过，超过soft报警，直到hard数
第三列，打开文件数是nofile
第四列，数量，这个也不能设置太大

第二步：/etc/pam.d/su(官方)或/etc/pam.d/common-session(网络)

sudo vim /etc/pam.d/su
将session    required   pam_limits.so这一行注释去掉 
重启系统

sudo vim /etc/pam.d/common-session
加上以下一行
session required pam_limits.so
打开/etc/pam.d/su，发现是包含/etc/pam.d/common-session这个文件的，所以修改哪个文件都应该是可以的
这个觉得修改su这个文件比较好，取消注释就OK了，不容易出错，vim打开，定位，x一下即可
官方只到第二步，就重启系统了，没有第三步，好象不行，感觉是不是全是第三步的作用？！

2015年03月01日更新：
_
在这个网址里描述了同样的问题和解决办法：http://askubuntu.com/questions/162229/how-do-i-increase-the-open-files-limit-for-a-non-root-user

At first I missed the wildcard on the end of /etc/pam.d/common-session* and just edited common-session, and even after a reboot it didn't work. But after adding the same line (for pam_limits.so) to common-session-noninteractive, ulimit -n displayed the new value after a fresh login (no reboot required). FWIW I was trying to change the limit for root (only).
_

第三步：配置/etc/profile
最后一行加上

ulimit -SHn 40960
重启，ulimit -n 验证，显示40960就没问题了