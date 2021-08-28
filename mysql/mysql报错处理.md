**InnoDB: Error: log file ./ib_logfile0 is of different size 0 5242880 bytes**

    3.2.1 停mysql实例
    
    mysqladmin -uroot -p -S /var/lib/mysql/mysql.sock shutdown
    
    3.2.2 修改原有ib_logfile文件名
    
    mv ib_logfile0 ib_logfile0.bak
    
    mv ib_logfile1 ib_logfile1.bak
    
    3.2.3 启动mysql实例
    
    mysqld_safe --defaults-file=/etc/my.cnf &


**2 ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)**


    最近新装好的mysql在进入mysql工具时，总是有错误提示:
    # mysql -u root -p
    Enter password:
    ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)
    或者
    # mysql -u root -p password 'newpassword'
    Enter password:
    mysqladmin: connect to server at 'localhost' failed
    error: 'Access denied for user 'root'@'localhost' (using password: YES)' 
    
    现在终于找到解决方法了。本来准备重装的，现在不必了。
    方法操作很简单，如下：
    
    # /etc/init.d/mysqld stop //停止mysql服务的运行
    # mysqld_safe --user=mysql --skip-grant-tables --skip-networking & //跳过受权表访问
    # mysql -u root mysql //登录mysql



	在mysql5.7以下的版本如下：
    mysql> UPDATE user SET Password=PASSWORD('newpassword') where USER='root' and host='127.0.0.1' or host='localhost';//把空的用户密码都修改成非空的密码就行了。
    
    在mysql5.7版本如下：
    
    update mysql.user set authentication_string=password('newpassword') where user='root' and host='127.0.0.1' or host='localhost';
    
    
    mysql> FLUSH PRIVILEGES;
    mysql> quit # /etc/init.d/mysqld restart //离开并重启mysql
    # mysql -uroot -p
    Enter password: <输入新设的密码newpassword> 






