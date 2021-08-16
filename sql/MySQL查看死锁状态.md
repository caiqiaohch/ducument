# MySQL查看死锁状态

查看下在锁的事务

```
SELECT * FROM INFORMATION_SCHEMA.INNODB_TRX;
```

查看当前锁定的事务

```
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCKS;
```

查看当前等锁的事务

```
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCK_WAITS;
```

查询是否锁表

```
SHOW OPEN TABLES WHERE In_use > 0;
```

查看InnoDB状态

```
SHOW ENGINE INNODB STATUS\G;
```

查询进程(如果有SUPER权限，可以看到所有线程，否则只能看到自己的线程)

```
SHOW PROCESSLIST;
```

杀死进程id

```
KILL id;
```