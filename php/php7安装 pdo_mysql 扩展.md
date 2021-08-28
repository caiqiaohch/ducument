php7安装 pdo_mysql 扩展

tp5的项目，在本地能跑，在服务器（linux+php7+nginx）上时打开就提示

could not find driver

错误显示为PDO没找到这个，tp5是用PDO连接数据库的，连接不上，那就安装呗

第一步：
在php的解压出来安装包里，一般进入到/usr/local/src/etc/pdo_mysql里。假设你的php是安装在/usr/local/php里的。执行/usr/local/php/bin/phpize 
 
如果出现图上的红框，安装两个东西 
 
 
安装完成后应该OK了

继续执行./configure –with-php-config=/usr/local/php/bin/php-config –with-pdo-mysql=/usr/local/mysql/ 第二个为mysql安装路径 
 
执行完成，make编译一下，没问题继续make install 
 
完成，会生成一个文件夹，里面有pdo_mysql.so这就是我们要的东西。 
打印phpinfo()看一下extension_dir路径，有没有指向上面的路径 

如果没有，打开php.ini修改，php.ini路径在这个页面上面 
 
 
这里应该不用写绝对路径，但我还是谢了，确保这个路径下有pdo_mysql.so

忘了上面安装完可以运行看下/usr/local/php/bin/php -m有没有安装成功 


Nice，之前我一安装到这里一直重启nginx好几次，还是没开启，原来php也要重启

关闭PHP 
killall php-fpm

php重启 
/usr/local/php/sbin/php-fpm &

关闭nginx 
/usr/local/nginx/sbin/nginx -s stop //关闭服务器

开启nginx 
/usr/local/nginx/sbin/nginx 开启服务器

重启nginx 
/usr/local/nginx/sbin/nginx -s reload


OK，开启了，tp5也能正常访问了

如果src目录里面没有php安装包
直接下载pdo_mysql拓展源码包。下载页面在这里：http://pecl.php.net/package/PDO_MYSQL，可以先下载了然后用FTP传到服务器。 
我是在复制了下载地址以后使用wget直接下载到服务器端的。 
在/usr/local/src目录执行 
wget http://pecl.php.net/get/PDO_MYSQL-1.0.2.tgz

然后解压 
tar -zxvf PDO_MYSQL-1.0.2.tgz

进入解压后的目录，然后执行phpize，后面方法同上

这里放上一个测试pdo与的mysqli的demo

$pdo_startTime = microtime(true);

for($i=1;$i<=100;$i++){
    $pdo = new PDO("mysql:host=locahost;dbname=xf","root","root");
}

$pdo_endTime = microtime(true);

$pdo_time = $pdo_endTime - $pdo_startTime;
echo $pdo_time;
echo "<hr/>";

//通过mysql链接数据库
$mysqli_startTime = microtime(true);

for($i=1;$i<=100;$i++){
    mysqli_connect("host","username","123","xf");
}

$mysqli_endTime = microtime(true);

$mysqli_time = $mysqli_endTime - $mysqli_startTime;
echo $mysqli_time;

echo "<hr/>";

if($pdo_time > $mysqli_time){
    echo "pdo的连接时间是mysqli的".round($pdo_time/$mysqli_time)."倍";
}else{
    echo "mysqli的连接时间是pdo的".round($mysqli_time/$pdo_time)."倍";
}
 ———————————————— 
版权声明：本文为CSDN博主「机电爱迪生」的原创文章，遵循CC 4.0 by-sa版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_42161963/article/details/80536283