版权声明：本文为博主原创文章，未经博主允许不得转载。	https://blog.csdn.net/Chen_Victor/article/details/53092712
debian 8
#vi /etc/apt/sources.list
将文件里的源都注释掉（前面加#）

保存文件。 然后执行 apt-get update && apt-get upgrade 

新的稳定的源，可以安装ffmpeg

#163 stable
deb http://mirrors.163.com/debian/ stable main contrib non-free
deb-src http://mirrors.163.com/debian/ stable main contrib non-free
deb http://security.debian.org/ stable/updates main

debian 9
deb http://mirrors.163.com/debian/ stretch main non-free contrib 
deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib 
deb http://mirrors.163.com/debian/ stretch-backports main non-free contrib 
deb-src http://mirrors.163.com/debian/ stretch main non-free contrib 
deb-src http://mirrors.163.com/debian/ stretch-updates main non-free contrib 
deb-src http://mirrors.163.com/debian/ stretch-backports main non-free contrib 
deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib 
deb-src http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib
--------------------- 
作者：bin_csdn_ 
来源：CSDN 
原文：https://blog.csdn.net/chen_victor/article/details/53092712 
版权声明：本文为博主原创文章，转载请附上博文链接！