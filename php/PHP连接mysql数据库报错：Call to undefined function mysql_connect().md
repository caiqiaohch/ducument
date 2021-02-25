PHP连接mysql数据库报错：Call to undefined function mysql_connect()

问题描述
刚开始学php，系统环境是Ubuntu+PHP7.0+Mysql5.7+Apache2。 
运行一个数据库连接测试示例时报错：

[client 127.0.0.1:37496] PHP Fatal error:  Uncaught Error: Call to undefined function mysql_connect() in /var/www/html/test.php:2\nStack trace:\n#0 {main}\n  thrown in /var/www/html/test.php on line 2

示例代码是：

<?PHP
    $conn=mysql_connect("localhost","root","root");
    if($conn){
        echo"ok";
    }else{
        echo"error";    
    }
?>

解决办法
查阅资料后发现，原来是从PHP5.0开始就不推荐使用mysql_connect()函数，到了php7.0则直接废弃了该函数，替代的函数是：

mysqli_connect();

用法是：

$con=mysqli_connect("localhost","my_user","my_password","my_db");

官方的描述连接：http://php.net/manual/en/function.mysqli-connect.php 
正确的测试代码：

    <?PHP
    $conn=mysqli_connect("localhost","root","root");
    if($conn){
    echo"ok";
    }else{
    echo"error";
    }
    ?>

总结
在Ubuntu+PHP7.0+Mysql5.7+Apache2的系统环境下报该错，是因为mysql_connect()函数被弃用了，当跟着过时的教程学习时可能会遇到该错误。(注意：如果是windows系统，则更可能是Apache2没有启用mysql，详情自行百度)
当运行上面的测试代码时，界面上没有任何反应，错误是在日志中查阅出来的，日志目录在“/var/log/apache2/error.log”。
 ———————————————— 
版权声明：本文为CSDN博主「Star_Ship」的原创文章，遵循CC 4.0 by-sa版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/zhoucheng05_13/article/details/75082722