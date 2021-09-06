# CROSS-GDB 嵌入式linux的 交叉调试

2009-12-02 0:11
从http://ftp.gnu.org/gnu/gdb下载GDB源代码--gdb-6.2.1.tar.bz2 
1－编译GDB客户端： 
#cd gdb-6.2.1 
#./configure --target=arm-linux --prefix=/root/arm-gdb -v 
#make                          //期间有可能会有错误，见上面 

Iwmmxt.c: 在函数 ‘WMAC’ 中： 
iwmmxt.c:2117: 错误：赋值运算中的左值无效 
iwmmxt.c:2133: 错误：赋值运算中的左值无效 
iwmmxt.c: 在函数 ‘WMADD’ 中： 
iwmmxt.c:2169: 错误：赋值运算中的左值无效 
iwmmxt.c:2177: 错误：赋值运算中的左值无效 
iwmmxt.c:2186: 错误：赋值运算中的左值无效 
iwmmxt.c:2191: 错误：赋值运算中的左值无效 
iwmmxt.c: 在函数 ‘WSLL’ 中： 
iwmmxt.c:2840: 警告：对 ‘long’ 类型而言整数常量太大 
iwmmxt.c: 在函数 ‘WSRA’ 中： 
iwmmxt.c:2917: 警告：对 ‘long’ 类型而言整数常量太大 
iwmmxt.c:2917: 警告：对 ‘long’ 类型而言整数常量太大 
iwmmxt.c:2919: 警告：对 ‘long’ 类型而言整数常量太大 
iwmmxt.c: 在函数 ‘WSRL’ 中： 
iwmmxt.c:2988: 警告：对 ‘long’ 类型而言整数常量太大 
iwmmxt.c: 在函数 ‘WUNPCKEH’ 中： 
iwmmxt.c:3290: 警告：对 ‘long’ 类型而言整数常量太大 
iwmmxt.c: 在函数 ‘WUNPCKEL’ 中： 
iwmmxt.c:3357: 警告：对 ‘long’ 类型而言整数常量太大 
iwmmxt.c: 在函数 ‘Fetch_Iwmmxt_Register’ 中： 
iwmmxt.c:3707: 警告：隐式声明与内建函数 ‘memcpy’ 不兼容 
iwmmxt.c:3712: 警告：隐式声明与内建函数 ‘memcpy’ 不兼容 
iwmmxt.c: 在函数 ‘Store_Iwmmxt_Register’ 中： 
iwmmxt.c:3722: 警告：隐式声明与内建函数 ‘memcpy’ 不兼容 
iwmmxt.c:3727: 警告：隐式声明与内建函数 ‘memcpy’ 不兼容 
make[2]: *** [iwmmxt.o] 错误 1 
make[2]: Leaving directory `/root/Documents/gdb-6.2.1/sim/arm' 
make[1]: *** [all] 错误 2 
make[1]: Leaving directory `/root/Documents/gdb-6.2.1/sim' 
make: *** [all-sim] 错误 2 


根据上面的提示找到错误的文件和在文件的那一行： 
c:2117: error: invalid lvalue in assignment 
c:2133: error: invalid lvalue in assignment 
c:2169: error: invalid lvalue in assignment 
c:2177: error: invalid lvalue in assignment 
c:2186: error: invalid lvalue in assignment 
c:2191: error: invalid lvalue in assignment 

方法同上，都是改gdb压缩包的文件，这次改的是 
gdb-6.2.1/sim/arm/iwmmxt.c文件里的： 

第2117、2133、2169、2177、2186、2191行； 

方法如下： 

将2117行的    (signed long long) t += s;    
改成        (signed long long)t;    t = (signed long long)(t + s); 


将2133行的    (signed long long) wR[BITS (12, 15)] += (signed long long) t;    
改成    {(signed long long) wR[BITS (12, 15)];    wR[BITS (12, 15)] = (signed long long)(wR[BITS (12, 15)] + t);} 


将2169行的    (signed long) s1 = a * b;    
改成    (signed long) s1;    s1 =(signed long)(a * b); 


将2177行的    (signed long) s2 = a * b; 
改成    (signed long) s2;    s2 =(signed long)(a * b); 


将2186行的    (unsigned long) s1 = a * b; 
改成    (unsigned long) s1;    s1 =(unsigned long)(a * b); 


将2191行的    (signed long) s2 = a * b; 
改成    (unsigned long) s2;    s2 =(unsigned long)(a * b); 



编译Gdbserver: 

linux-arm-low.c:26:21: error: sys/reg.h: No such file or directory 
make: *** [linux-arm-low.o] 错误 1 

根据在linux-arm-low.c中： 
#ifdef HAVE_SYS_REG_H 
#include <sys/reg.h> 
#endif 

在gdb/gdbserver/config.h修改如下： 
/* Define if you have the <sys/reg.h> header file.  */ 
#define HAVE_SYS_REG_H 1 

/* Define if you have the <sys/reg.h> header file.  */ 
//#define HAVE_SYS_REG_H 1 省略 


#make install 
#vi ~/.bash_profile        修改：PATH=$PATH:/root/arm-gdb/bin 
#source ~/.bash_profile 
#arm-linux-gdb -v 

2－编译Gdbserver 
#cd gdb-6.2.1 
#./configure --target=arm-linux --host=arm-linux 
#cd gdb/server 
#./configure --target=arm-linux --host=arm-linux 
修改 gdb/gdbserver/config.h   :      #define HAVE_SYS_REG_H 1    --> //#define HAVE_SYS_REG_H 1 
#make CC=arm-linux-gcc 
把gdb/gdbserver目录下的gdbserver复制到开发板系统（嵌入式linux）的／bin下 
实例： 
//hello.c 
#include<stdio.h> 
#include<string.h> 
int main() 
{ 
char *str=NULL; 
strcpy(str,"hello"); 
printf("str is %s\n",str); 
return 0; 
}     

#arm-linux-gcc -g hello.c -o hello 
设置主机IP地址为：192.168.1.10，开发板系统IP地址为：192.168.1.230（一般只需设置成同一个网段就行）， 
在开发板中： 
#gdbserver 192.168.1.230:1234 hello 
Process test created:pid=80   //使gdbserver在1234端口监听。 
在主机中： 
#arm-linux-gdb 
(gdb) target remote 192.168.1.230:1234    //若链接成功，开发板的串口终端会显示如下： 
Remote debugging from host 192.168.1.10 
(gdb) symbol file  hello                               //此处的hello是PC机上的所在路径的hello 
(gdb) list 
(gdb) break 5 
(gdb) continuing 
(gdb) step                //会提示出现段错误（通常有内存的非法访问引起的） 


常用的gdb调试命令：（某些唯一开头字母的命令可用开头字母直接替代，也可用Tab来显示其完整的命令名） 
file 文件名        在gdb中载入某可执行文件                    symbol file hello 
break n            设置断点                                break 5 
info                 查看和可执行程序相关的各种信息      info breakpoint   delete/disable/enable breakpoint num 
kill                终止正在调试的程序 
print                显示变量或者表达式的值 
set args         设置调试程序的运行参数 
watch                在程序中设置观测点（如果数据改变，将给出变化前后的情况） 
delete            删除设置的某个断点或观测点 
clear                删除设置的某个断点或观测点 
continue            从断点处继续执行程序 
list                列出gdb中加载的可执行程序的代码 
run                运行在gdb中加载的可执行程序 
next                单步执行所加载的程序 
step                单步，可进入函数内，查看执行情况（用finish回到调用处） 
whatis            查看变量或函数类型 
pype                显示数据结构定义情况 
make                在不退出gdb情况下，编译程序 
quit                退出gdb 

gdb调试带参数的程序 gdb --args ./testprg arg1 arg2