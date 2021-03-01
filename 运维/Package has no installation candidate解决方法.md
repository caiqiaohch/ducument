Package has no installation candidate解决方法

今天在安装软件的时候出现了Package has no installation candidate的问题，如：
#  apt-get install <packagename>
Reading package lists... Done
Building dependency tree... Done
Package aptitude is not available, but is referred to by another package.
This may mean that the package is missing, has been obsoleted, or
is only available from another source
E: Package <packagename> has no installation candidate

解决方法如下：
# apt-get update
# apt-get upgrade
# apt-get install <packagename>
这样就可以正常使用apt-get了～
