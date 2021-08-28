debian系统mysql远程链接10060/10045

debian系统远程数据库连不上，首先要监听防火墙端口

iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
防火墙生效

iptables-save > /etc/iptables
再本机进入数据库

先改host=>%

mysql -u root -p
use mysql;
update user set host = '%' where user = 'root'  and host='localhost';
flush privileges;
再给远程权限

grant all privileges on *.* to 'root'@'%' identified by 'password' with grant option; 
 
FLUSH PRIVILEGES; 
 ———————————————— 
版权声明：本文为CSDN博主「Mitsubishi_Lancer」的原创文章，遵循CC 4.0 by-sa版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/lorraine_40t/article/details/83536963