maven项目报错error:

expression #2 of SELECT list contains nonaggregated column 'newhelp.appr.title'; this is incompatible with sql_mode=only_full_group_by

这是因为随着MySQL版本更新带来的问题，在MySQL5.7版本之后对group by进行了优化。他默认启动改进之后的

版本启动了ONLY_FULL_GROUP_BY模式。

这种模式的官方解释：ONLY_FULL_GROUP_BY是MySQL数据库提供的一个sql_mode，通过这个sql_mode来保证

SQL语句“分组求最值”合法性的检查。这种模式采用了与Oracle、DB2等数据库的处理方式。即不允许select target list

中出现语义不明确的列。

通俗的讲就是：对于用到GROUP BY的select语句，查出来的列必须是group by后面声明的列，或者是聚合函数里面的列

有这样一个数据库的表

select语句：select id, sum(appr_id) from appr group by id------------------------------------(合法)

select语句：select id, user_id, sum(appr_id) from appr group by id-------------------------(合法)

select语句：select id, sum(appr_id) from appr group by role----------------------------------(不合法)

select语句：select id, user_id, sum(appr_id) from appr group by role-----------------------(不合法)

select语句：select * from appr group by role-------------------------------------------------------(不合法)

经过大量测试：笔者发现了ONLY_FULL_GROUP_BY这种模式的特点：

1：只要有聚合函数sum()，count()，max()，avg()等函数就需要用到group by，否则就会报上面的错误。

2：group by id(id是主键)的时候，select什么都没有问题，包括有聚合函数。

3：group by role(非主键)的时候，select只能是聚合函数和role(group by的字段),否则报错

如果我们不想用用ONLY_FULL_GROUP_BY的模式。有两种解决这种问题的方案：

1：命令行中输入：

set @@GLOBAL.sql_mode='';

set sql_mode ='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION

_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

不过这种情况治标不治本，一旦mysql重启之后又会恢复。

2：修改MySQL的配置文件，

1、windows下找到MySQL的安装目录的my.ini文件，修改其中的配置为不启动ONLY_FULL_GROUP_BY模式

删掉带有ONLY_FULL_GROUP_BY的模式就ok了，如果没有找到my.ini文件。

去系统的隐藏文件夹查看，在某个盘下输入%ProgramData%然后搜索MySQL的my.ini文件

2、linux下找到my.cnf文件，这个是配置MySQL的文件。一般这个文件是在etc文件夹下。

vi my.cnf 编辑这个文件，然后在图示的位置上加入sql_mode =

"STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FO

R_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER"

然后重启MySQL服务：service mysqld restart

注意：服务重启之后不一定立即生效，尤其是你买的服务器，存在延时。所以可能等一两个小时才生效。

goodluck！