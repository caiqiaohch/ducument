dbg:p/2
根据标志来监控项目

用法：

p(Item, Flags) -> {ok, MatchDesc} | {error, term()}
根据标志来监控项目。

例如下面监控本进程收到（receive）的消息：

dbg:p(self(), r).

----------
dbg:tracer/0
启动一个处理监控消息的监控服务

用法：

tracer() -> {ok, pid()} | {error, already_started}
启动一个处理监控消息的监控服务。

dbg:tracer().