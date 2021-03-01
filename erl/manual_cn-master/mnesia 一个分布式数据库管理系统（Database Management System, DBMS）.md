mnesia 一个分布式数据库管理系统（Database Management System, DBMS）

mnesia:create_schema/1
在指定的节点列表里初始化一个新的 Mnesia 数据库架构

用法：

create_schema(DiscNodes) -> ok | {error,Reason}
在指定的节点列表里的磁盘上初始创建一个新的 Mnesia 数据库架构。在每个节点的本地 Mnesia 目录里会创建各种各样的文件。注意该每个节点的目录必须是唯一的。两个节点可能永远不会共享相同的目录。如果可能的话，使用一个本地磁盘设备来提高性能。

如果给出的任何 Erlang 节点 DiscNodes 不存在，或 Mnesia 服务已经在任何节点里运行，或任何一个节点上已经创建了 Mnesia 的数据库架构，那么 mnesia:create_schema/1 将会创建失败。可以使用 mnesia:delete_schema/1 来清除旧的、有问题的 Mnesia 数据库架构。

mnesia:create_schema([node()]).

----------
mnesia:create_table/2
创建一个 Mnesia 表

用法：

create_table(Name, TabDef) -> {atomic, ok} | {aborted, Reason}
根据参数 TabDef 创建一个名为 Name 的 Mnesia 表。

mnesia:create_table(mnesia_table_name, [{ram_copies, [node()]}, {disc_only_copies, nodes()}, {storage_properties, [{ets, [compressed]}, {dets, [{auto_save, 5000}]} ]}]).

----------
mnesia:delete_schema/1
删除给出的节点里 Mnesia 数据库架构

用法：

delete_schema(DiscNodes) -> ok | {error,Reason}
删除一个由 mnesia:create_schema/1 创建的 Mnesia 数据库架构。如果给出的任何 Erlang 节点 DiscNodes 不存在，或 Mnesia 服务已经在任何节点里运行，那么 mnesia:delete_schema/1 将删除失败。

mnesia:delete_schema([node()]).
如果数据库架构是创建在一个无盘的节点上，那么删除该数据库架构后 Mnesia 服务可能仍然会被启动。这取决于 schema_location 参数的设置。

----------
mnesia:start/0
启动一个本地 Mnesia 系统

用法：

start() -> ok | {error, Reason}
启动一个 Mnesia 节点集群是一个相当复杂的操作过程。一个 Mnesia 系统由一个节点集群组成，这些节点都是会在本地启动 Mnesia 服务的节点。正常情况下，每个节点有一个给 Mnesia 写入文件数据的目录。该目录也将被看作是 Mnesia 服务的目录。Mnesia 也许会启动在一个无磁盘（disc-less）的节点上。于更多关于 Mnesia 无盘节点的信息可以查看 mnesia:create_schema/1 和 Mesia 用户指南。

组成 Mnesia 系统的集群节点是建立在一个架构模式下，并且可以从结构模式里添加或删除 Mnesia。架构模式的初始是用 mnesia:create_schema/1 函数在磁盘上创建。在无盘的节点上，一个极小默认的架构模式会在每次 Mnesia 启动的时候生成。在启动的过程中，节点间的 Mnesia 服务会互相交换架构模式信息，来验证表定义方面的兼容性。

每一个架构模式会有一个唯一的 cookie 来认作是一个唯一架构模式的标示符。该 cookie 必须是 Mnesia 启动的相同所有节点才能运行。关于这方面的更多细节信息可以查看 Mnesia 用户指南。

架构模式文件（同时也是 Mnesia 所需的其他所有文件）是保存在 Mnesia 服务目录里。在命令行里写上 "-mnesia dir Dir"，可以用来指定 Mnesia 系统保存数据所在的目录位置。如果命令行不指定，那么目录的命令默认为 "Mnesia.节点名"。

也可以使用 application:start/1 的 application:start(mnesia) 。

mnesia:start().

----------
mnesia:stop/0
关停 Mnesia 系统

用法：

stop() -> stopped
关停在当前节点的本地 Mnesia 服务。也可以使用 application:stop/1 的 application:stop(mnesia) 。

mnesia:stop().

----------
mnesia:wait_for_tables/2
等待一个 Mnesia 表直到表可以被访问

用法：

wait_for_tables(TabList,Timeout) -> ok | {timeout, BadTabList} | {error, Reason}
一些应用的某些表可能由于表数据很大，以至初始的适合需要一个初始等待的时间才能正常访问到该表的数据。mnesia:wait_for_tables/2 悬停等待一段时间，直到在 TabList 的所有表可以被访问，或超过等待的时间。

下面是等待 5 秒来确认 mnesia_table_name 已经加载：

mnesia:wait_for_tables([mnesia_table_name], 5000).
下面是无限等待：

mnesia:wait_for_tables([mnesia_table_name], infinity).

----------
