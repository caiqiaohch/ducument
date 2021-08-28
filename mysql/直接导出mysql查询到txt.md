
mysql直接导出查询数据到文本

控制台直接输入以下命令
比如导出mysql自带数据库中的user表信息

mysql -h127.0.0.1 -uroot -p -e “select *from user” mysql > info.txt
输入mysql密码即可

-h 数据库服务器地址
-u 数据库用户名
-p 数据库密码
-e 查询条件语句 后面跟上目标数据库（如例子中的mysql）
info.txt 导入的目标文件

例子：

mysql -uxxxx -p -hxxx -e "show databases;use xxx;select user_award_id,user_id,consumer_id,create_time,FROM_UNIXTIME(create_time,'%Y-%m-%d %H:%i:%s') 
————————————————
版权声明：本文为CSDN博主「野蛮秘籍」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/fationyyk/article/details/70144960


pager cat > /home/haoyou/record/test.txt ;

use pro4_db;
select * from `player_base_info`;

nopager



mysql -h 127.0.0.1 -u koagame --password=koa2801haoyou -P 3306 -e "use koa_game1_db1;
select * from player_base_info;
use koa_game1_db2;
select * from player_base_info;
use koa_game1_db3;
select * from player_base_info;
use koa_game1_db4;
select * from player_base_info;
use koa_game1_db5;
select * from player_base_info;
use koa_game1_db6;
select * from player_base_info;
use koa_game1_db7;
select * from player_base_info;
use koa_game1_db8;
select * from player_base_info;
use koa_game1_db9;
select * from player_base_info;
use koa_game1_db10;
select * from player_base_info;
use koa_game1_db11;
select * from player_base_info;
use koa_game1_db12;
select * from player_base_info;
use koa_game1_db13;
select * from player_base_info;
use koa_game1_db14;
select * from player_base_info;
use koa_game1_db15;
select * from player_base_info;
use koa_game1_db16;
select * from player_base_info;
use koa_game1_db17;
select * from player_base_info;
use koa_game1_db18;
select * from player_base_info;
use koa_game1_db19;
select * from player_base_info;
use koa_game1_db20;
select * from player_base_info;
use koa_game1_db21;
select * from player_base_info;
use koa_game1_db22;
select * from player_base_info;
use koa_game1_db23;
select * from player_base_info;
use koa_game1_db24;
select * from player_base_info;
use koa_game1_db25;
select * from player_base_info;
use koa_game1_db26;
select * from player_base_info;
use koa_game1_db27;
select * from player_base_info;
use koa_game1_db28;
select * from player_base_info;
use koa_game1_db29;
select * from player_base_info;
use koa_game1_db30;
select * from player_base_info;
use koa_game1_db31;
select * from player_base_info;
use koa_game1_db32;
select * from player_base_info;">info20191121.txt



mysql -h rm-0xi91gv0a2bp4nc92.mysql.rds.aliyuncs.com -u root -ph23a4o6y8o9u_1216


mysql -h rm-0xi91gv0a2bp4nc92.mysql.rds.aliyuncs.com -u koagame --password=koa2801haoyou -P 3306 -e "use koa_game1_db1;
select * from player_base_info;
use koa_game1_db2;
select * from player_base_info;
use koa_game1_db3;
select * from player_base_info;
use koa_game1_db4;
select * from player_base_info;
use koa_game1_db5;
select * from player_base_info;
use koa_game1_db6;
select * from player_base_info;
use koa_game1_db7;
select * from player_base_info;
use koa_game1_db8;
select * from player_base_info;
use koa_game1_db9;
select * from player_base_info;
use koa_game1_db10;
select * from player_base_info;
use koa_game1_db11;
select * from player_base_info;
use koa_game1_db12;
select * from player_base_info;
use koa_game1_db13;
select * from player_base_info;
use koa_game1_db14;
select * from player_base_info;
use koa_game1_db15;
select * from player_base_info;
use koa_game1_db16;
select * from player_base_info;
use koa_game1_db17;
select * from player_base_info;
use koa_game1_db18;
select * from player_base_info;
use koa_game1_db19;
select * from player_base_info;
use koa_game1_db20;
select * from player_base_info;
use koa_game1_db21;
select * from player_base_info;
use koa_game1_db22;
select * from player_base_info;
use koa_game1_db23;
select * from player_base_info;
use koa_game1_db24;
select * from player_base_info;
use koa_game1_db25;
select * from player_base_info;
use koa_game1_db26;
select * from player_base_info;
use koa_game1_db27;
select * from player_base_info;
use koa_game1_db28;
select * from player_base_info;
use koa_game1_db29;
select * from player_base_info;
use koa_game1_db30;
select * from player_base_info;
use koa_game1_db31;
select * from player_base_info;
use koa_game1_db32;
select * from player_base_info;">info20191121.txt



mysql -h 127.0.0.1 -u koagame --password=koa2801haoyou -P 3306 -e "use koa_web1_db;
select * from user_login_log2;">info2.txt

mysql -h 127.0.0.1 -u koagame --password=koa2801haoyou -P 3306 -e "use prj4_web_db2;
select * from (select *from user_login_log2 group by createtime having max(ServerState)<2) stu">info2.txt

