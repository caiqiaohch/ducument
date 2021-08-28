# erlang_mysql_driver 源码分析1

erlang_mysql_driver 是个mysql的数据库驱动
源码主要包含 mysql mysql_conn mysql_recv mysql_auth 这几个模块
mysql模块提供给外部调用的接口，包括启动、添加连接、执行sql语句。
mysql模块的另一主要功能是维护mysql_conn连接池，在执行sql语句时，选择合适的mysql_conn进程进行sql处理。
mysql_conn 和 mysql_recv 负责具体的sql执行逻辑和获取返回结果。

# 一、mysql模块的启动

1、mysql提供了两种启动方式 start 和start_link

```
start1(PoolId, Host, Port, User, Password, Database, LogFun, Encoding,
       StartFunc) ->
    crypto:start(),
    gen_server:StartFunc(
      {local, ?SERVER}, ?MODULE,
      [PoolId, Host, Port, User, Password, Database, LogFun, Encoding], []).
```


我们可以看上面代码，通过传入StartFunc值的不同（start_link或start），最终分别调用gen_server:start和gen_server:start_link


我们可以看上面代码，通过传入StartFunc值的不同（start_link或start），最终分别调用gen_server:start和gen_server:start_link

关于gen_server:start和gen_server:start_link的异同，我们可以查看官方文档：
gen_server:start启动一个独立的gen_server进程:

```
Creates a stand-alone gen_server process, i.e. a gen_server which is not part of a supervision tree and thus has no supervisor.
```

gen_server:start_link在监督树下启动一个gen_server进程:

```
Creates a gen_server process as part of a supervision tree. The function should be called, directly or indirectly, by the supervisor. It will, among other things, ensure that the gen_server is linked to the supervisor.
```

回到正题，当我们调用mysql:start/start_link后
这里启动的进程名是 mysql_dispatcher，并不是mysql，回调模块才是mysql。
启动成功后，通过sys:get_status(mysql_dispatcher) 可以查看mysql_dispatcher的state状态。

2、启动时的初始化准备

```
init([PoolId, Host, Port, User, Password, Database, LogFun, Encoding]) ->
    LogFun1 = if LogFun == undefined -> fun log/4; true -> LogFun end,
    case mysql_conn:start(Host, Port, User, Password, Database, LogFun1,
              Encoding, PoolId) of
    {ok, ConnPid} ->
        Conn = new_conn(PoolId, ConnPid, true, Host, Port, User, Password,
                Database, Encoding),
        State = #state{log_fun = LogFun1},
        {ok, add_conn(Conn, State)};
    {error, _Reason} ->
        ?Log(LogFun1, error,
         "failed starting first MySQL connection handler, "
         "exiting"),
         C = #conn{pool_id = PoolId,
          reconnect = true,
          host = Host,
          port = Port,
          user = User,
          password = Password,
          database = Database,
          encoding = Encoding},
          start_reconnect(C, LogFun),
        {ok, #state{log_fun = LogFun1}}
    end.
```


调用gen_server:start或gen_server:start_link时，init方法启动一个mysql_conn进程，并且在mysql_conn成功启动后将mysql_conn的进程信息记录在gen_server state的结构中，方便下次使用时，直接在state中找到需要的mysql_conn进程。

# 二、添加mysql_conn进程

1、mysql_conn进程 与 mysql:connect
mysql:connect 启动一个mysql_conn进程，（mysql_conn进程会建立一个和指定mysql数据库的连接），启动成功后记录下mysql_conn的进程ID。
这里在调用mysql:connect方法的时候，需要提供pool_id（atom），用来表示将这个进程添加到具体 哪个连接池中。
另外需要注意的是，mysql_conn进程与mysql_dispacher之间并不是父子进程关系，mysql_conn与调用这个方法（mysql:connect）的进程才具有监督关系（如果start_link）的话，mysql_dispacher只是在state上记录mysql_conn的pid。

```
connect(PoolId, Host, Port, User, Password, Database, Encoding, Reconnect,
       LinkConnection) ->
    Port1 = if Port == undefined -> ?PORT; true -> Port end,
    Fun = if LinkConnection ->
          fun mysql_conn:start_link/8;
         true ->
          fun mysql_conn:start/8
      end,

   {ok, LogFun} = gen_server:call(?SERVER, get_logfun),
    case Fun(Host, Port1, User, Password, Database, LogFun,
         Encoding, PoolId) of
    {ok, ConnPid} ->
        Conn = new_conn(PoolId, ConnPid, Reconnect, Host, Port1, User,
                Password, Database, Encoding),
        case gen_server:call(
           ?SERVER, {add_conn, Conn}) of
        ok ->
            {ok, ConnPid};
        Res ->
            Res
        end;
    Err->
        Err
    end.
```


2、 mysql:connect
1、启动mysql_conn
2、如果顺利启动了mysql_conn，则call add_conn消息给mysql_dispacher
发送add_conn消息给mysql_dispacher的时候，我们可以注意下，record #conn，在mysql里使用一个#conn来表示一个mysql连接。
#conn里也包含了一个mysql连接所需的数据（host ip port database encoding等信息），还有就是 pool_id和本身的pid。

# 三、mysql_dispacher是怎么处理的 add_conn 的消息的？

mysql_dispacher 对于这个消息的处理，都封装在 mysql:add_conn里

```
add_conn(Conn, State) ->
    Pid = Conn#conn.pid,
    erlang:monitor(process, Conn#conn.pid),
    PoolId = Conn#conn.pool_id,
    ConnPools = State#state.conn_pools,
    NewPool = 
    case gb_trees:lookup(PoolId, ConnPools) of
        none ->
        {[Conn],[]};
        {value, {Unused, Used}} ->
        {[Conn | Unused], Used}
    end,
    State#state{conn_pools =
        gb_trees:enter(PoolId, NewPool,
                   ConnPools),
        pids_pools = gb_trees:enter(Pid, PoolId,
                        State#state.pids_pools)}.
```

1、monitor 传过来的pid，这个monitor的目的是可以在mysql_conn挂掉的时候，收到一条通知消息{‘DOWN’…}，具体可以查看erlang:monitor文档
2、修改mysql_dispacher中的两个重要的数据 conn_pools和pid_pools
这两个数据结构都是使用的gb_trees，事实上state中有3个元素是使用gb_trees的。gb_trees就是二叉平衡树，使用二叉平衡树的目的是为了快速查找。
conn_pools ：连接池，如果添加连接的时候，发现这个连接对应的连接池PoolId并不存在，则新建一个PoolId
pid_pools: 进程池，添加mysql_conn对应的进程到进程池中
3、返回最终的State

# 四、conn_pools 的维护

mysql_dispatcher进程的主要作用就是维护多个连接池，管理连接池的连接。具体的业务就是，当用户请求使用连接时选择合适的连接，并记录该连接的使用情况。再到用户使用完连接收到消息，重新记录下连接的使用情况。
这个业务过程就是很常见的池的处理了，如emysql在处理这样情况的时候就是对连接进行分组，分为可用队列和已在使用队列，然后玩家请求则从可用组取，放入使用队列，用后再放回可用队列。
然而erlang_mysql_driver并不是这样处理的，但是他的处理也是一种不错的手段，对以后（进程池、连接池等）池的处理可以作为参考，所以我们重点关心mysql_dispatcher对于conn_pools的维护。
（注：conn_pools的存储位置在mysql_dispatcher中state中）

1、monitor 传过来的pid，这个monitor的目的是可以在mysql_conn挂掉的时候，收到一条通知消息{‘DOWN’…}，具体可以查看erlang:monitor文档
2、修改mysql_dispacher中的两个重要的数据 conn_pools和pid_pools
这两个数据结构都是使用的gb_trees，事实上state中有3个元素是使用gb_trees的。gb_trees就是二叉平衡树，使用二叉平衡树的目的是为了快速查找。
conn_pools ：连接池，如果添加连接的时候，发现这个连接对应的连接池PoolId并不存在，则新建一个PoolId
pid_pools: 进程池，添加mysql_conn对应的进程到进程池中
3、返回最终的State
四、conn_pools 的维护
mysql_dispatcher进程的主要作用就是维护多个连接池，管理连接池的连接。具体的业务就是，当用户请求使用连接时选择合适的连接，并记录该连接的使用情况。再到用户使用完连接收到消息，重新记录下连接的使用情况。
这个业务过程就是很常见的池的处理了，如emysql在处理这样情况的时候就是对连接进行分组，分为可用队列和已在使用队列，然后玩家请求则从可用组取，放入使用队列，用后再放回可用队列。
然而erlang_mysql_driver并不是这样处理的，但是他的处理也是一种不错的手段，对以后（进程池、连接池等）池的处理可以作为参考，所以我们重点关心mysql_dispatcher对于conn_pools的维护。
（注：conn_pools的存储位置在mysql_dispatcher中state中）

##### 1、conn_pools与pool_id的关系

gen_server进程mysql_dispatcher的state里有一个元素是conn_pools，conn_pools以gb_trees的形式维护所有的pool_id。
一个pool_id对应gb_trees上的一个节点，每次新添加一个关于pool_id_1的conn的时候。会现在conn_pools中寻找是否存在pool_id_1，
{value, ConnList} = gb_trees:lookup(pool_id_1, ConnPools)，如果已经存在则已添加列表的形式，将Conn添加到ConnList的列表头上。
none = gb_trees:lookup(pool_id_1, ConnPools)，如果不存在pool_id_1，则新建一个，最终gb_trees:enter到原先的conn_pools中。
也就是说，conn_pools是一个gb_trees的数据结构，而pool_id为这个结构上的key。
而这个key对应的value是ConnList。ConnList是一个列表，该列表的形式:
[{#conn{}, Num}, {#conn{}, Num}, {#conn{}, Num}…]，一个#conn表示一个mysql_conn进程，Num表示该进程当前执行的sql数。

##### 2、为什么要使用gb_trees ?

这里我们可以看到，在添加连接到连接池的操作中，pool_id的查询操作是需要经常用到的。
频繁地查询使用二叉查找树可以提高查询的效率。
不过在实际使用中，并不会有太多的连接池，一般来说有一个连接池专门负责select操作，一个连接池负责insert、delete和update操作，就可以了。

##### 3、当我们调用mysql:fetch(PoolId, Query)的时候，mysql_dispatcher是怎么选择mysql_conn进程来执行的？

查看代码 mysql:get_next_conn(PoolId, State)

###### 1、 在mysql_dispatcher的state里的conn_pools中找到PoolId

如果这个时候连PoolId都找不到的话，就失败了，证明不存在这个连接池。
或者说找到后，发现这个连接池里的conn数为空，那也失败了。这种情况正常逻辑下不会出现，因为在一开始的时候都是通过启动mysql_conn才添加pool的。

###### 2、lookup PoolId后，会获得一个列表，列表里面就是所有可用的conn，[{conn1, num1}, {conn2, num2}, {conn3, num3}…]。

每个conn后面都会有一个num，num表示当前这个conn被调用的次数。
这里我们会直接选择列表里的第一个Conn，选择后再把这个Conn对应的Num值加1。
最后根据Num值从小到大排序一遍，那么列表开头的conn又是被调用次数最少的一个。
下次调用的时候，有继续上面的过程。
所以回顾我们之前说的add_connect的过程，新添加的conn，其num为0，直接添加到列表头。
这里面还是有一个效率问题，就是每一次执行sql语句，其实都是需要对连接池里的连接进行重新排序的。

###### 4、sql执行完成后，Num数据减一

在上面，我们可以看到，当mysql_dispatcher发消息给mysql_conn的时候，该Conn对应的Num是会加一的。那么当mysql_conn执行完sql后，他又会发消息回来给mysql_dispatcher，将Num减一。
具体的这个处理过程，可以查看mysql_dispatcher：query_done。


————————————————
版权声明：本文为CSDN博主「aaaajw」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/aaaajw/article/details/51699213