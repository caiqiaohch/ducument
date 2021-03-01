修复/lib/ld-linux.so.2: bad ELF interpreter: No such file or directory问题

1、在64系统里执行32位程序如果出现/lib/ld-linux.so.2: 
bad ELF interpreter: No such file or directory，安装下glibc.i686 即可
 
sudo yum install glibc.i686
  www.2cto.com  
2、error while loading shared libraries: libz.so.1: 
cannot open shared object file: No such file or directory
sudo yum install zlib.i686 


编译时发现缺少lstdc++,其实是系统没有安装libstdc++的32位库
yum provides libstdc++.so.6

可以看到提示安装libstdc++-4.4.7-16.el6.i686

yum install libstdc++-4.4.7-16.el6.i686 即可


error while loading shared libraries: libz.so.1: cannot open shared object file: No such
yum install zlib.i686