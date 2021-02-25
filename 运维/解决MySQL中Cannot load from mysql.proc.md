解决MySQL中Cannot load from mysql.proc.


2015-08-18 18:58:10
故障描述：

1548-Cannot load from mysql.proc. The table is probably corrupted


原因是mysql.proc升级时有个字段没有升级成功。

在5.1中mysql.proc表的comment字段是varchar(64)：

  `comment` char(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',

但在5.5中应该是text：

 `comment` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,   So，执行下面的语句，把这个字段修改为text，就彻底OK了： 

ALTER TABLE `proc`
MODIFY COLUMN `comment`  text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL AFTER `sql_mode`;


最后：
分享下我的阿里云幸运券（如需要购买阿里云服务的可以领取使用哈）：https://promotion.aliyun.com/ntms/act/ambassador/sharetouser.html?userCode=rziak7l4&utm_source=rziak7l4





