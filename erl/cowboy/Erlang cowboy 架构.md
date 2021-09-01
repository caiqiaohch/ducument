# Erlang cowboy Architecture架构

Erlang cowboy参考：

http://ninenines.eu/docs/en/cowboy/1.0/guide/

本章Architecture：

http://ninenines.eu/docs/en/cowboy/1.0/guide/architecture/



# Architecture



Cowboy 是轻量的HTTP server。 它构建在Ranch之上，请参考Ranch。

## 每个连接一个进程

cowboy每个连接使用一个进程。这个进程就是你的代码用来控制socket的进程。使用一个进程可以降低内存使用。

由于每个连接可以有多个请求，包括HTTP/1.1的keepalive，因此同一个进程将用于处理多个请求。由于这个原因，就要求用户确定进程在终止处理当前请求之前做好清理工作，可能包括清理进程字典，计时器，监控器等。

## Binaries

二进制比字符串更高效和节省资源。如果编译成本地代码更能提高进程的性能。更多内容参考HiPE文档。

## Date header

由于查询日期和时间是非常耗时的，Cowboy 每秒生成`Date` header，共享给所有进程，简单复制到响应中。这点遵从HTTP/1.1规范，没有性能损耗。

## Max connections

默认情况下，最大活动连接数设置成一个可接受的足够大的数目。这样可以防止大量进程处理繁重任务占用大量系统资源和消耗过多的内存。

如果你仅仅处理短连接的请求，可以禁用这个功能，协议选项（protocol option）设置成`{max_connections, infinity}`，会带来性能的极大提升。