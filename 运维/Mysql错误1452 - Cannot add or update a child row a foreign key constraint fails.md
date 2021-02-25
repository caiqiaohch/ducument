**Mysql错误1452 - Cannot add or update a child row: a foreign key constraint fails怎么办？**


必须确保两个表都是InnoDB。如果其中一个表，即引用表是MyISAM，则约束将失败。

SHOW TABLE STATUS WHERE Name =  't1';

ALTER TABLE t1 ENGINE=InnoDB;