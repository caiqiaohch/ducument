编译安装libiconv报错：./stdio.h:1010:1: error: 'gets' undeclared here (not in a function)

问题：

In file included from progname.c:26:0:
    ./stdio.h:1010:1: error: ‘gets’ undeclared here (not in a function)
    _GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
    ^
    make[2]: *** [progname.o] Error 1
    make[2]: Leaving directory `/usr/local/src/zabbix-2.4.7/libiconv-1.14/srclib'
    make[1]: *** [all] Error 2
    make[1]: Leaving directory `/usr/local/src/zabbix-2.4.7/libiconv-1.14/srclib'
    make: *** [all] Error 2
解决：

登录后复制
vi ./srclib/stdio.in.h
 
注释掉698这一行
/*_GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");*/
 
原处添加下面3行
#if defined(__GLIBC__) && !defined(__UCLIBC__) && !__GLIBC_PREREQ(2, 16)
 _GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
#endif
 
！注意下面还是有一个#endif