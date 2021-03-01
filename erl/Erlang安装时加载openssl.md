Erlang安装时加载openssl的libcrypto.a失败,执行crypto:start()报错的解决方案


刚开始碰到这个问题的时候，从网上找的例子。搞了半天不好使，后来发现了原因，主因是自己对linux认知不够，只有发布服务、查看日志的基本功。

先上原文连接：http://blog.csdn.net/zhongruixian/article/details/21076405

然后再讲自己操作失败的原因，主要是为了给自己做下记录。



错误信息：

[plain] view plain copy
 
Eshell V5.10.3  (abort with ^G)  
1> crypto:start().  
** exception error: undefined function crypto:start/0  
2>  
=ERROR REPORT==== 12-Mar-2014::17:09:15 ===  
Unable to load crypto library. Failed with error:  
"load_failed, Failed to load NIF library: '/usr/local/lib/erlang/lib/crypto-3.1/priv/lib/crypto.so: undefined symbol: EC_GROUP_new_curve_GF2m'"  
OpenSSL might not be installed on this system.  
  
  
=ERROR REPORT==== 12-Mar-2014::17:09:15 ===  
The on_load function for module crypto returned {error,  
                                                 {load_failed,  
                                                  "Failed to load NIF library: '/usr/local/lib/erlang/lib/crypto-3.1/priv/lib/crypto.so: undefined symbol: EC_GROUP_new_curve_GF2m'"}}  

解决办法：



1、下载openssl源码
    wget http://www.openssl.org/source/openssl-1.0.1f.tar.gz
    tar zxvf openssl-1.0.1f.tar.gz
2、进入源码目录，如果不是新下载解压的目录，而且以前有编译安装过的，进入目录后执行make clean以确保能重新编译
    cd openssl-1.0.1f
3、为了不要和已安装的openssl混淆，这里指定一个新的安装目录
    ./config --prefix=/opt/ssl 
4、config之后，会生成Makefile，打开Makefile找到gcc，在CFLAG参数列表里加上-fPIC
    vim Makefile

[cpp] view plain copy
 
CC= gcc    
CFLAG= -fPIC -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAVE_DLFCN_H -Wa,--noexecstack -m64 -DL_ENDIAN -DTERMIO -O3 -Wall -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT -DOPENSSL_BN_ASM_MONT5 -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DMD5_ASM -DAES_ASM -DVPAES_ASM -DBSAES_ASM -DWHIRLPOOL_ASM -DGHASH_ASM   

5、编译并安装
    make && make install
6、现在进入你的erlang源码安装目录，如果已经编译安装过erlang，为确保能重新编译，先执行：
    make clean
7、加上openssl安装路径重新configure，如果有安装多个版本的erlang，为了可以方便找到新安装的erl，这里可以指定一个新的安装目录，示例如下：
    ./configure --with-ssl=/opt/ssl/ --prefix=/opt/erlang
8、编译并安装
    make && make install
9、运行刚才安装的erlang
    /opt/erlang/bin/erl
[plain] view plain copy
 
Eshell V5.10.3  (abort with ^G)  
1> crypto:start().  
ok  
2>  


10、小结
很多同学根据我上一篇文章重装后仍然失败的原因，常见的有如下几个：

1、加-fPIC参数重装openssl后，不明确新编译出来的静态库libcrypto.a在哪里，如果以前有安装过的，不明确是否被覆盖；
2、对于已经编译安装过的源码目录，没有执行make clean；
2、重装erlang时，没有具体指定最新安装的ssl目录；
3、重装erlang后，直接执行erl时，仍然执行了老的erl，可以加上完整路径执行erl尝试，用whereis erl查看一下默认执行路径。






本人操作时就蠢在了第三个原因上面。先是进入了指定的erlang安装目录，但是，但是，进入目录后直接运行了erl 命令，而不是 ./erl ，饮恨此处。

解决方法： 

1、whereis erl    找到erl的运行路径:/usr/local/bin/erl（centos）

2、vi /usr/local/bin/erl（erl命令路径文件）

    修改：ROOTDIR="/app/erlang/lib/erlang"     切记修改ROOTDIR指定的路径。  就算修改了/etc/profile也不好使，切记修改此处。



这个问题找了半天，终究原因是自己对linux认知不够，这种问题之前根本不会的。


编译安装openssl报错：POD document had syntax errors at /usr/bin/pod2man line 69. make: *** [install_docs]
错误如下：

cms.pod around line 457: Expected text after =item, not a number
cms.pod around line 461: Expected text after =item, not a number
cms.pod around line 465: Expected text after =item, not a number
cms.pod around line 470: Expected text after =item, not a number
cms.pod around line 474: Expected text after =item, not a number
POD document had syntax errors at /usr/bin/pod2man line 69.
make: *** [install_docs] Error 1
解决方法： 

执行：

rm -f /usr/bin/pod2man 

