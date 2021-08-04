CentOS下修改MySQL密码
1．修改MySQL的登录设置：
vim /etc/my.cnf
在[mysqld]的段中加上一句：skip-grant-tables

2．重新启动mysql
service mysql restart

3．登录并修改MySQL的root密码

 mysql> use mysql; 
 Database changed 
 mysql> update user set password = password ('new-password') where user = 'root'; 
 Query OK, 0 rows affected (0.00 sec) 
 Rows matched: 5 Changed: 0 Warnings: 0 
 mysql> flush privileges; 
 Query OK, 0 rows affected (0.01 sec) 
 mysql> quit

4．将MySQL的登录设置修改回来
vim /etc/my.cnf
将刚才在[mysqld]的段中加上的skip-grant-tables注释
保存并且退出vim

5．重新启动mysql
service mysql restart
