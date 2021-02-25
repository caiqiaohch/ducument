mysql控制自动重连行为

原文：https://dev.mysql.com/doc/refman/5.5/en/auto-reconnect.html

当向mysql server发送statement时，mysql客户端发现连接失效后会自动尝试重新连接server。如果"自动重连"状态是enabled，客户端尝试连接server,并在连接成功后重新发送statement.

"自动重连“默认是disabled的。

如果应用程序需要知道连接是否可用（可以退出程序或显示相应的提示信息），确认“自动重连”是disabled。可以通过调用包含MYSQL_OPT_RECONNECT参数的mysql_options()函数以确认"自动重连"是否disabled:

my_bool reconnect = 0;
mysql_options(&mysql, MYSQL_OPT_RECONNECT, &reconnect);
如果连接已经断开，mysql_ping()依赖“自动重连”的状态。如果“自动重连”是enabled,mysql_ping()会重新获取连接。否则，会返回错误。


有些客户端程序可能提供了控制自动重连的功能。比如，mysql默认是允许重连的，但是使用 --skip-reconnect 选项将关闭这个行为。

如果发生了自动重连（比如，调用了mysql_ping()）,自动重连是透明的。为了检查是否发生了重连，在调用mysql_ping()函数前，先调用mysql_thread_id()函数获取原始的连接id，然后调用mysql_ping()，在调用 mysql_thread_id()函数，对比两次 mysql_thread_id()的结果是否变化了。


“自动重连”很方便，因为你不需要再实现自己重连代码，但是一旦发生了自动重连，connection的一些状态在server端就会被重置，而你的应用程序得不到这些变化的通知。

下面列出连接相关的状态变化：

任何未提交的事务将会回滚并且连接autocommit属性将会重置

事务中的锁将会被释放。

所有的临时表将会关闭（并释放）。

Session中的变量会重新初始化为系统默认值，包括在statements中显式声明的变量，比如SET NAMES。

用户自定义的变量将会丢失。

Prepared statements将释放。

HANDLER 变量将会关闭。

LAST_INSERT_ID()的值将会重置为0.

通过GET_LOCK()获取的锁将会释放。

如果连接失效，可能connection的session在server端依然在运行，当server没有检测到客户端失去连接。在这种情况下，原来connection的锁依然属于那个session，你可以调用mysql_kill()函数kill掉它。