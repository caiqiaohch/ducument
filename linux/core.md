# 二，coredump文件的存储位置

   core文件默认的存储位置与对应的可执行程序在同一目录下，文件名是core，大家可以通过下面的命令看到core文件的存在位置：

   cat  /proc/sys/kernel/core_pattern


​                                                                                                    
W: There is no public key available for the following key IDs:
9D6D8F6BC857C906
W: Failed to fetch http://suro.ubaya.ac.id/debian/dists/stable/main/source/Sources.gz  404  Not Found

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1520281423

vim /etc/resolv.conf


Had the same problem, an

sudo apt-get clean
followed by an

sudo apt-get update
followed by an

sudo apt-get upgrade -f
fixed it. I hope this helps!