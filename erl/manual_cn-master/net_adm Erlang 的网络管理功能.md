net_adm Erlang 的网络管理功能

net_adm:dns_hostname/1
获取 Host 主机的正式名字

用法：

dns_hostname(Host) -> {ok, Name} | {error, Host}
内部实现：

-spec dns_hostname(Host) -> {ok, Name} | {error, Host} when
      Host :: atom() | string(),
      Name :: string().

dns_hostname(Hostname) ->
    case inet:gethostbyname(Hostname) of
	{ok,{hostent, Name, _ , _Af, _Size, _Addr}} ->
	    {ok, Name};
	_ ->
	    {error, Hostname}
    end.
返回 Host 主机的正式名字，如果找不到这个主机名，则返回 {error, Host}。

net_adm:dns_hostname('127.0.0.1').

----------
net_adm:host_file/0
读取 .hosts.erlang 文件

用法：

host_file() -> Hosts | {error, Reason}
内部实现：

-spec host_file() -> Hosts | {error, Reason} when
      Hosts :: [Host :: atom()],
      %% Copied from file:path_consult/2:
      Reason :: file:posix() | badarg | terminated | system_limit
              | {Line :: integer(), Mod :: module(), Term :: term()}.

host_file() ->
    Home = case init:get_argument(home) of
	       {ok, [[H]]} -> [H];
	       _ -> []
	   end,
    case file:path_consult(["."] ++ Home ++ [code:root_dir()], ".hosts.erlang") of
	{ok, Hosts, _} -> Hosts;
	Error -> Error
    end.
读取文件 .hosts.erlang，文件里的 hosts 数据 以一个列表返回，如果文件不能被堵，或者文件里的 Erlang 项（terms）不能被解析，则返回 {error, Reason}。

net_adm:host_file().

----------
net_adm:localhost/0
获取本地主机名

用法：

localhost() -> Name
内部实现：

-spec localhost() -> Name when
      Name :: string().

localhost() ->
    {ok, Host} = inet:gethostname(),
    case inet_db:res_option(DOMain) of
	"" -> Host;
	Domain -> Host ++ "." ++ Domain
    end.
获取本地主机名，如果启动 Erlang 时带有 -name 参数标识启动，那么 Name 是完全合格域名（FQDN：Fully Qualified Domain Name）。

net_adm:localhost().

----------
net_adm:names/0
获取本地主机上 Erlang 节点的名字

用法：

names() -> {ok, [{Name, Port}]} | {error, Reason}
内部实现：

-spec names() -> {ok, [{Name, Port}]} | {error, Reason} when
      Name :: string(),
      Port :: non_neg_integer(),
      Reason :: address | file:posix().

names() ->
    names(localhost()).


-spec names(Host) -> {ok, [{Name, Port}]} | {error, Reason} when
      Host :: atom() | string(),
      Name :: string(),
      Port :: non_neg_integer(),
      Reason :: address | file:posix().

names(Hostname) ->
    case inet:gethostbyname(Hostname) of
	{ok, {hostent, _Name, _ , _Af, _Size, [Addr | _]}} ->
	    erl_epmd:names(Addr);
	Else ->
	    Else
    end.
返回一个以 {Name, Port} 的元组形式组成的本地主机上的 Erlang 节点列表信息，Name 是节点名，Port 是 Erlang 节点端口。

如果 epmd 没有运行，则返回 {error, address}。

net_adm:names().

----------
net_adm:names/1
获取指定主机上 Erlang 节点的名字

用法：

names(Host) -> {ok, [{Name, Port}]} | {error, Reason}
内部实现：

-spec names(Host) -> {ok, [{Name, Port}]} | {error, Reason} when
      Host :: atom() | string(),
      Name :: string(),
      Port :: non_neg_integer(),
      Reason :: address | file:posix().
 
names(Hostname) ->
    case inet:gethostbyname(Hostname) of
    {ok, {hostent, _Name, _ , _Af, _Size, [Addr | _]}} ->
        erl_epmd:names(Addr);
    Else ->
        Else
    end.
返回一个以 {Name, Port} 的元组形式组成的指定主机 Host 上的 Erlang 节点列表信息，Name 是节点名，Port 是 Erlang 节点端口。

如果 epmd 没有运行，则返回 {error, address}。

Host = net_adm:localhost(),
net_adm:names(Host).

----------
net_adm:ping/1
对一个节点建立一个连接

用法：

ping(Node) -> pong | pang
内部实现：

%% Check whether a node is up or down
%%  side effect: set up a connection to Node if there not yet is one.

-spec ping(Node) -> pong | pang when
      Node :: atom().

ping(Node) when is_atom(Node) ->
    case catch gen:call({net_kernel, Node},
			'$gen_call',
			{is_auth, node()},
			infinity) of
	{ok, yes} -> pong;
	_ ->
	    erlang:disconnect_node(Node),
	    pang
    end.
尝试对节点 Node 建立一个连接，如果成功则返回 pong，否则返回 pang。

net_adm:ping('genfsm@127.0.0.1').

----------
net_adm:world/0
查找并连接本地主机上的所有节点

用法：

world() -> [node()]
内部实现：

-spec world() -> [node()].

world() ->
    world(silent).

-spec world(Arg) -> [node()] when
      Arg :: verbosity().

world(Verbose) ->
    case net_adm:host_file() of
        {error,R} -> exit({error, R});
        Hosts -> expand_hosts(Hosts, Verbose)
    end.
这个函数查找本地主机上的 .hosts.erlang 文件上的节点信息，并对这些节点进行模拟 ping 操作，最后返回一个可以成功 ping 到的节点列表

这个函数经常用在当一个节点启动时，网络上的其他节点名最初不被知道。

如果调用 net_adm:host_file() 时报{error, Reason} 的错，该函数则返回 {error, Reason}。

net_adm:world().

----------
net_adm:world/1
查找并连接本地主机上的所有节点

用法：

world(Arg) -> [node()]
内部实现：

-spec world(Arg) -> [node()] when
      Arg :: verbosity().

world(Verbose) ->
    case net_adm:host_file() of
        {error,R} -> exit({error, R});
        Hosts -> expand_hosts(Hosts, Verbose)
    end.
这个函数查找本地主机上的 .hosts.erlang 文件上的节点信息，并对这些节点进行模拟 ping 操作，最后返回一个可以成功 ping 到的节点列表

参数 Arg 默认是 silent。如果 Arg 是 verbose，那么该函数会 ping 节点时的信息打印出来。

这个函数经常用在当一个节点启动时，网络上的其他节点名最初不被知道。

如果调用 net_adm:host_file() 时报{error, Reason} 的错，该函数则返回 {error, Reason}。

net_adm:world(verbose).

----------
net_adm:world_list/1
查找并连接指定主机上的所有节点

用法：

world_list(Hosts) -> [node()]
这个函数查找指定主机 Hosts 上的 .hosts.erlang 文件上的节点信息，并对这些节点进行模拟 ping 操作，最后返回一个可以成功 ping 到的节点列表

这个函数经常用在当一个节点启动时，网络上的其他节点名最初不被知道。

如果调用 net_adm:host_file() 时报{error, Reason} 的错，该函数则返回 {error, Reason}。

case net_adm:host_file() of
    {error, R} ->
        R; 
    Hosts -> 
        net_adm:world_list(Hosts)
end.

----------
net_adm:world_list/2
查找并连接指定主机上的所有节点

用法：

world_list(Hosts, Arg) -> [node()]
这个函数查找指定主机 Hosts 上的 .hosts.erlang 文件上的节点信息，并对这些节点进行模拟 ping 操作，最后返回一个可以成功 ping 到的节点列表

参数 Arg 默认是 silent。如果 Arg 是 verbose，那么该函数会 ping 节点时的信息打印出来。

这个函数经常用在当一个节点启动时，网络上的其他节点名最初不被知道。

如果调用 net_adm:host_file() 时报{error, Reason} 的错，该函数则返回 {error, Reason}。

case net_adm:host_file() of
    {error, R} ->
        R; 
    Hosts -> 
        net_adm:world_list(Hosts, verbose)
end.

----------
