循环语句

mysql 操作同样有循环语句操作，网上说有3中标准的循环方式： while 循环 、 loop 循环和repeat循环。还有一种非标准的循环： goto。 鉴于goto 语句的跳跃性会造成使用的的思维混乱，所以不建议使用。

这几个循环语句的格式如下：

    WHILE……DO……END WHILE
    REPEAT……UNTIL END REPEAT
    LOOP……END LOOP
    GOTO。

 

目前我只测试了 while 循环：

 

一 、 while 循环

复制代码

    delimiter $$　　　　// 定义结束符为 $$
    drop procedure  if exists wk;  //  删除 已有的 存储过程
    create procedure wk()　　　　　　//　 创建新的存储过程
    begin 
    declare i int;　　　　　　　　　　// 变量声明
    set i = 1;　　　　　
    while i < 11 do 　　　　　　　　　　//   循环体
    insert into user_profile (uid) values (i);
    set i = i +1;
    end while;
    end $$　　　　　　　　　　　　　　　//  结束定义语句

// 调用

    delimiter ;　　　　　　　　　　//  先把结束符 回复为;
    call wk();   
            
复制代码
delimter : mysql  默认的  delimiter是;      告诉mysql解释器，该段命令是否已经结束了，mysql是否可以执行了。

这里使用 delimiter 重定义结束符的作用是： 不让存储过程中的语句在定义的时候输出。

创建 MySQL 存储过程的简单语法为：

复制代码
CREATE PROCEDURE 存储过程名称( [in | out | inout] 参数 )

BEGIN 

Mysql 语句

END
复制代码
调用存储过程：

call 存储过程名称()   // 名称后面要加() 
 

 二 、 REPEAT 循环

复制代码

    delimiter //
    drop procedure if exists looppc;
    create procedure looppc()
    begin 
    declare i int;
    set i = 1;
    
    repeat 
    insert into user_profile_company (uid) values (i+1);
    set i = i + 1;
    until i >= 20
    
    end repeat;
    
    
    end //
    
    ---- 调用
    call looppc()

复制代码
 

三、 LOOP 循环

复制代码

    delimiter $$
    drop procedure if exists lopp;
    create procedure lopp()
    begin 
    declare i int ;
    set i = 1;
    
    lp1 : LOOP　　　　　　　　　　　　　　//  lp1 为循环体名称   LOOP 为关键字insert into user_profile (uid) values (i);
    set i = i+1;
    
    if i > 30 then
    leave lp1;　　　　　　　　　　　　　　//  离开循环体
    end if;
    end LOOP;　　　　　　　　　　　　　　//  结束循环
    end $$

复制代码
 

 注意默认结束符 ";"， 在mysql 操作中语句结束要使用 ";", 不然会出现语法错误。

 X -- Y是列表移除操作符，它从X里移除Y中的元素。 

 注意这里的++是中缀插入操作符。

内置函数简称为BIF（built-in function），是那些作为Erlang语言定义一部分的函数。