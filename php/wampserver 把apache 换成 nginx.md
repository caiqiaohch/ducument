# wampserver 把apache 换成 nginx

张映 发表于 2014-05-08

分类目录： [apache/nginx](http://blog.51yip.com/category/apachenginx)

标签：[apache](http://blog.51yip.com/tag/apache), [nginx](http://blog.51yip.com/tag/nginx), [wampserver](http://blog.51yip.com/tag/wampserver), [windows](http://blog.51yip.com/tag/windows)

习惯了windows下wamp，为了和服务器一至，所以把wamp中的apache换成了nginx，其他的不动。实现方法很简单



**1，下载windows下的nginx**

nginx下载地址：http://nginx.org/en/download.html

**2，把wampserver中的apache服务停掉，如果你想apache和nginx同时用的话，也可以，只不过不能同时监听80端口**

**3，启动php-cgi和nginx**

wampserver版本不一样的话，调用的php.ini位置也不一样。如果apache调用的是php根目录下的php.ini，那就不做任何操作；如果不是，copy一份apache调用的php.ini到wampserver中php的根目录，这样做的目的，不想重新配置php.ini

**新建start.bat**

[查看](http://blog.51yip.com/apachenginx/1611.html#)[复制](http://blog.51yip.com/apachenginx/1611.html#)[打印](http://blog.51yip.com/apachenginx/1611.html#)[?](http://blog.51yip.com/apachenginx/1611.html#)

1. @echo off 
2. echo Starting PHP FastCGI... 
3. D:\nginx-1.5.0\RunHiddenConsole.exe D:\wamp\bin\php\php5.3.13\php-cgi.exe -b 127.0.0.1:9000 -c D:\wamp\bin\php\php5.3.13\php.ini 
4. echo Starting nginx... 
5. D:\nginx-1.5.0\RunHiddenConsole.exe D:/nginx-1.5.0/nginx.exe -p D:/nginx-1.5.0 

这里RunHiddenConsole.exe，是WINDOWS下的将程序运行到后一个工具，网上很多。

**4，停止php-cgi和nginx**

**新建stop.bat**

[查看](http://blog.51yip.com/apachenginx/1611.html#)[复制](http://blog.51yip.com/apachenginx/1611.html#)[打印](http://blog.51yip.com/apachenginx/1611.html#)[?](http://blog.51yip.com/apachenginx/1611.html#)

1. @echo off 
2. echo Stopping nginx... 
3. taskkill /F /IM nginx.exe > nul 
4. echo Stopping PHP FastCGI... 
5. taskkill /F /IM php-cgi.exe > nul 
6. exit 

# [Windows使用RunHiddenConsole一键启动nginx,php-cgi服务](https://www.cnblogs.com/liujie-php/p/12035572.html)

新建start.bat
其中php_home,nginx_home是php和nginx安装的路径
D:/dev/RunHiddenConsole.exe 不是windows系统自带,需下载并放置指定位置

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

@echo off
color 3

echo Start Php-cgi...
@ping -n 2 127.0.0.1 >nul
"D:\nginx\util\RunHiddenConsole.exe" "D:\php\php7.3.11\php-cgi.exe" -b 127.0.0.1:9001 -c "D:\php\php7.3.11\php.ini"
echo Start Nginx...
"D:\nginx\util\RunHiddenConsole.exe" "D:\nginx\nginx-1.16.1\nginx.exe" -p "D:\nginx\nginx-1.16.1"
@ping -n 2 127.0.0.1 >nul

exit

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

上面已测试成功。做bat脚本遇到几个坑，set 变量 直接拼接可执行程序，变量没有输出。这里直接用字符串拼接。懒得弄了目前可运行。

新建stop.bat

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
@echo off
echo Stopping nginx...  
taskkill /F /IM nginx.exe > nul
echo Stopping PHP FastCGI...
taskkill /F /IM php-cgi.exe > nul
exit
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

RunHiddenConsole.zip下载链接

链接：https://pan.baidu.com/s/1d6eTrJ_p3yCHHGx3KqYcPw
提取码：i9er