Mongodb学习（1）--- mongoose: Schema, Model, Entity
Schema ： 一种以文件形式存储的数据库模型骨架，不具备数据库的操作能力

Model ： 由 Schema 发布生成的模型，具有抽象属性和行为的数据库操作

Entity ： 由 Model 创建的实体，他的操作也会影响数据库

注意 三者关系：

Schema 生成 Model，Model创造 Entity;
Model 和 Entity 都可对数据库操作造成影响，但 Model 比Entity 更具操作性。


mongodb学习（2）--- nodeJS与MongoDB的交互（使用mongodb/node-mongodb-native）
转载：http://www.cnblogs.com/zhongweiv/p/node_mongodb.html

目录
简介
MongoDB安装(windows)
MongoDB基本语法和操作入门(mongo.exe客户端操作)
库操作
插入
查询
修改
删除
存储过程
nodejs操作MongoDB
插入
查询
修改
删除
调用存储过程
写在之后...
简介：MongoDB 
　　开源，高性能的NoSQL数据库；支持索引、集群、复制和故障转移、各种语言的驱动程序；高伸缩性；

　　NoSQL毕竟还处于发展阶段，也有说它的各种问题的：http://coolshell.cn/articles/5826.html

 　  官网地址：http://www.mongodb.org/

　　API Docs：http://docs.mongodb.org/manual/

　　node-mongodb-native

　　mongodb的nodejs驱动；

　　GitHub地址：https://github.com/mongodb/node-mongodb-native

MongoDB安装(windows)：参考前文nodeJS学习（7）--- WS开发 NodeJS 项目-节2 <安装&设置&启动 mongodb 数据库++遇到的问题>

MongoDB基本语法和操作入门(mongo.exe客户端操作)
　　MongoDB已经安装好，下面先对 MongoD B进行一个简单的入门，再用node-mongodb-native去操作MongoDB

　库操作

　　新建数据库：第一步：use 新建数据库名；第二步：进行此库相关的操作；如果不进行第二步，该数据库不会被创建

查看数据库：show dbs;
新建表：db.createCollection('要新建的表名');
查看当前数据库下表： show collections;
删除当前数据库指定表：db.表名.drop();
删除当前数据库：db.dropDatabase();
　　示例操作如下图：

           

　　1. 默认为存在“admin”和“local”两个数据库；admin数据库是存放管理员信息的数据库，认证会用到；local是存放replication相关的数据；这两处本篇都没有涉及到；

　　2. find()：是个查询操作，后面会讲到，上面用到主要是为了演示 use不存在的库后，进行相关操作会创建出这个库；

　　3. MongoDB 没有像 MySQL 或 MSSQL 等数据库这么严格的规定，不是非得要先建库、建表、建各种字段，以后的操作中慢慢的会体会到^_^！

　　

　插入

方法一：db.表名.insert(数据);
　　

　　1.从上图操作可以看出，没有去创建“tb1”表，其实通过插入操作也会自动创建

　　2._id，是mongodb自已生成的，每行数据都会存在，默认是ObjectId，可以在插入数据时插入这个键的值(支持mongodb支持的所有数据类型)　　

方法二：db.表名.save(数据);
　　 　　

　　1.从上图操作可以看出，save也可达到insert一样的插入效果

　　2._id可以自已插入

　　3.一个表中不一定要字段都相同

 

　　强调：那它们有什么区别?

　　

　　从图中操作就可以看出，

虽然insert和save方法都可以插入数据，当默认的“_id”值已存在时，调用insert方法插入会报错；而save方法不会,会更新相同的_id所在行数据的信息！！
 

　　查询　　

查询表中所有数据：db.表名.find();
按条件查询（支持多条件）：db.表名.find(条件); 
查询第一条（支持条件）：db.表名.findOne(条件);
限制数量：db.表名.find().limit(数量);
跳过指定数量：db.表名.find().skip(数量);
　　

　　从上图中可以看出具体用法，批量插入默认数据我用了一个 javascript 语法循环；

 

比较查询
大于：$gt
小于：$lt
大于等于：$gte
小于等于：$lte
非等于：$ne
     示例：

　　

　　上面看到了AND的关系（数组），或者的关系应该怎么用？

或者：$or
　　

 

in和not in查询(包含、不包含)　　
包含：  $in
不包含： $nin
　　 
 

查询数量：db.表名.find().count();
排序：db.表名.find().sort({"字段名":1}); 
1： 表示升序  
-1：表示降序
指定字段返回： db.表名.find({},{"字段名":0});　　
1：返回 
0：不返回   # 如下： _id 不返回，即不显示 _id。
      示例：

　　 

　　

　　查询就讲到这里了，感觉查询示例一下讲不完，还有些高级查询，大家自行去了解一下吧^_^!

　　

　　修改

　　前面 save 在 _id 字段已存在时，就是修改操作，按指定条件修改语法如下：　

db.表名.update({"条件字段名":"字段值"},{$set:{"要修改的字段名":"修改后的字段值"}});
　　示例：

　　

 

　　删除

　　db.表名.remove(条件);


　　存储过程

创建存储过程：
复制代码
db.system.js.save({
　　_id:"存储过程ID", 
　　value:function(参数){  
        -- 逻辑主体; 
        return 返回; 
　　}
});                
复制代码
调用存储过程
db.eval("存储过程ID()");
示例：



　　所有存储过程都存放在db.system.js中

 

　　MongoDB基本操作就讲这么多了，基本够用，深入学习大家自已去看看API^_^!

 

nodejs操作MongoDB
先用npm安装mongodb
npm install mongodb
安装成功后，继续在上面操作创建的库和表中操作

使用MongoDB命令连接远程服务器的MongoDB数据库

MongoDB连接远程服务器的命令格式如下:

mongo 远程主机ip或DNS:MongoDB端口号/数据库名 -u user -p password

MongoDB连接远程服务器的命令示例代码如下:

//使用默认端口连接MongoDB

mongo 192.168.1.100

MongoDB shell version: 2.4.8
connecting to: 192.168.1.100/test
//连接MongoDB并指定端口

mongo 192.168.1.100:27017

//连接到指定的MongoDB数据库

mongo 192.168.1.100:27017/test

//指定用户名和密码连接到指定的MongoDB数据库

mongo 192.168.1.200:27017/test -u user -p password
