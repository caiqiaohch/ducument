# mysql重复插入时insert更改为update更新操作

在高并发项目中，使用多线程录入数据有可能造成重复录入，使用

关键字ON DUPLICATE KEY UPDATE

可以判断数据库是否已存在此主键，如果存在会将录入操作更改为更新操作。

 

案例：

常规方式：先查询，有则更新，没有就添加。如下

```mysql
select count(player_id) from player_count where player_id = 1;//查询统计表中是否有记录
insert into player_count(player_id,count,name) value(1,2,”张三”);//判读如果没有记录就执行insert 操作
//如果存在，执行录入操作
update from player_count set count=1 ，name=‘张三’ where player_id=1;
利用ON DUPLICATE KEY UPDATE关键字可以实现上诉逻辑
```

sql写法 

```mysql
insert into player_count(player_id,count,name) value(1,1,”张三”) 
on duplicate key update 
count= 2,
name=”张三”;
```


xml写法

```xml
<insert id="insert" parameterType="com.tsp.model.PlayerCount">
    insert into player_count(player_id,count_number,name) value (#{playerId,jdbcType=INTEGER}, #{countNumber,jdbcType=INTEGER}, #{name,jdbcType=VARCHAR})
    on duplicate key update
    count_number=#{countNumber,jdbcType=INTEGER},
    name=#{name,jdbcType=VARCHAR}
  </insert>
```

————————————————
版权声明：本文为CSDN博主「王侯 将相」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/hykwhjc/article/details/81121019