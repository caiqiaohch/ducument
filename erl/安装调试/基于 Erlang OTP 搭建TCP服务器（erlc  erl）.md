# 基于 Erlang/OTP 搭建TCP服务器（erlc *.erl）

http://blog.csdn.net/mycwq/article/details/12914205

http://blog.csdn.net/mycwq
完整的源码下载地址：http://download.csdn.net/download/libaineu2004/10009111
这两天在研究 erlang 如何构建 TCP 服务器，看到一篇文章，基于Erlang OTP构建一个TCP服务器，里面讲述了两种混合型Socket的实现方法，着实让人欢欣鼓舞。对比老外写的Building a Non-blocking TCP server using OTP principles，作者写的那个有点简单。本文将结合这两篇文章，继续讨论Erlang/OTP 构建TCP服务器的具体实现，以示例演示如何如何使用标准Erlang/OTP行为创建一个简单的无阻塞的TCP服务器。

## TCP Socket模式

主动模式{active, true}，非阻塞方式接收消息，但在系统无法应对超大流量请求时，客户端发送的数据过快，而且超过服务器可以处理的速度，那么，系统就可能会造成消息缓冲区被塞满，出现持续繁忙的流量的极端情况，系统因请求过多而溢出，造成Erlang虚拟机内存不足而崩溃。

被动模式{active, false}，阻塞方式接收消息，底层的TCP缓冲区可用于抑制请求，并拒绝客户端的消息，在接收数据的地方都会调用gen_tcp:recv，造成阻塞（单进程模式下就只能消极等待某一个具体的客户端Socket ，很危险）。需要注意的是，操作系统可能还会做一些缓存允许客户端机器继续发送少量数据，然后才将其阻塞，但这个时候Erlang还没有调用recv函数。

混合型模式（半阻塞，{active, once}），主动套接字仅针对一条消息，在控制进程发送完一个消息数据后，必须显式地调用inet:setopts(Socket, [{active, once}]) 重新激活以便接受下一个消息（在此之前，系统处于阻塞状态）。可见，混合型模式综合了主动模式和被动模式的两者优势，可实现流量控制，防止服务器被过多消息淹没。

所以如果想构建TCP服务器，比较合理的是建立在TCP Socket 混合型模式（半阻塞）基础上。
TCP服务器设计
这个TCP服务器的设计包含了主应用程序 tcp_server_app 和监督者 tcp_server_sup 进程，监督者进程拥有 tcp_server_listener 和 tcp_client_sup 两个子进程。tcp_server_listener 负责处理客户端的连接请求，并通知 tcp_client_sup 启动一个 tcp_server_handler 实例进程来处理一条客户端的请求，然后由该实例进程负责处理服务器与客户端的交互数据。

## 应用程序和监督行为

为了构建一个 Erlang/OTP 应用程序，我们需要构建一些模块来实现应用程序和监督行为。当应用程序启动时，tcp_server_app:start/2 会调用 tcp_server_sup:start_link/1 来创建主监督进程。该监督进程通过回调 tcp_server_sup:init/1 来实例化子工作进程 tcp_server_listener 和子监督进程 tcp_client_sup。该子监督进程回调 tcp_server_sup:init/1 来实例化负责处理客户端连接的工作进程 tcp_server_handler。
TCP服务器应用程序 （tcp_server_app.erl）

```
[plain] view plain copy
-module(tcp_server_app).  
-behaviour(application).  
-export([start/2, stop/1]).  
-define(PORT,  2222).  

start(_Type, _Args) ->  
  io:format("tcp app start~n"),  
  case tcp_server_sup:start_link(?PORT) of  
    {ok, Pid} ->  
      {ok, Pid};  
    Other ->  
      {error, Other}  
  end.  

stop(_S) ->  
  ok.  
```


TCP服务器监督者进程（tcp_server_sup.erl）

```
[plain] view plain copy
-module(tcp_server_sup).  
-behaviour(supervisor).  
-export([start_link/1, start_child/1]).  
-export([init/1]).  

start_link(Port) ->  
  io:format("tcp sup start link~n"),  
  supervisor:start_link({local, ?MODULE}, ?MODULE, [Port]).  

start_child(LSock) ->  
  io:format("tcp sup start child~n"),  
  supervisor:start_child(tcp_client_sup, [LSock]).  

init([tcp_client_sup]) ->  
  io:format("tcp sup init client~n"),  
  {ok,  
   { {simple_one_for_one, 0, 1},  
    [  
     { tcp_server_handler,   
      {tcp_server_handler, start_link, []},  
      temporary,   
      brutal_kill,   
      worker,   
      [tcp_server_handler]  
     }  
    ]  
   }  
  };  

init([Port]) ->  
  io:format("tcp sup init~n"),  
  {ok,  
    { {one_for_one, 5, 60},  
     [  
      % client supervisor  
     { tcp_client_sup,   
      {supervisor, start_link, [{local, tcp_client_sup}, ?MODULE, [tcp_client_sup]]},  
      permanent,   
      2000,   
      supervisor,   
      [tcp_server_listener]  
     },  
     % tcp listener  
     { tcp_server_listener,   
      {tcp_server_listener, start_link, [Port]},  
      permanent,   
      2000,   
      worker,   
      [tcp_server_listener]  
     }  
    ]  
   }  
  }.  
```


TCP服务器 Socket 监听进程（tcp_server_listener.erl）

```
[plain] view plain copy
-module(tcp_server_listener).  
-behaviour(gen_server).  
-export([start_link/1]).  
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,  
         terminate/2, code_change/3]).  
-record(state, {lsock}).  

start_link(Port) ->  
  io:format("tcp server listener start ~n"),  
  gen_server:start_link({local, ?MODULE}, ?MODULE, [Port], []).  

init([Port]) ->  
  process_flag(trap_exit, true),  
  Opts = [binary, {packet, 0}, {reuseaddr, true},  
           {keepalive, true}, {backlog, 30}, {active, false}],  
  State =  
  case gen_tcp:listen(Port, Opts) of  
    {ok, LSock} ->  
      start_server_listener(LSock),  
      #state{lsock = LSock};  
    _Other ->  
      throw({error, {could_not_listen_on_port, Port}}),  
      #state{}  
  end,  
    {ok, State}.  

handle_call(_Request, _From, State) ->  
  io:format("tcp server listener call ~p~n", [_Request]),  
  {reply, ok, State}.  

handle_cast({tcp_accept, Pid}, State) ->  
  io:format("tcp server listener cast ~p~n", [tcp_accept]),  
  start_server_listener(State, Pid),  
    {noreply, State};  

handle_cast(_Msg, State) ->  
  io:format("tcp server listener cast ~p~n", [_Msg]),  
  {noreply, State}.  

handle_info({'EXIT', Pid, _}, State) ->  
  io:format("tcp server listener info exit ~p~n", [Pid]),  
  start_server_listener(State, Pid),  
  {noreply, State};  

handle_info(_Info, State) ->  
  io:format("tcp server listener info ~p~n", [_Info]),  
  {noreply, State}.  

terminate(_Reason, _State) ->  
  io:format("tcp server listener terminate ~p~n", [_Reason]),  
  ok.  

code_change(_OldVsn, State, _Extra) ->  
  {ok, State}.  

start_server_listener(State, Pid) ->  
  unlink(Pid),  
  start_server_listener(State#state.lsock).  

start_server_listener(Lsock) ->  
  case tcp_server_sup:start_child(Lsock) of  
    {ok, Pid} ->  
      link(Pid);  
    _Other ->  
      do_log  
  end.  
```

TCP服务器处理客户端请求进程（tcp_server_handler.erl）

TCP服务器处理客户端请求进程（tcp_server_handler.erl）

```
[plain] view plain copy
-module(tcp_server_handler).  
-behaviour(gen_server).  
-export([start_link/1]).  
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,  
         terminate/2, code_change/3]).  
-record(state, {lsock, socket, addr}).  
-define(Timeout, 120*1000).  

start_link(LSock) ->  
  io:format("tcp handler start link~n"),  
  gen_server:start_link(?MODULE, [LSock], []).  

init([LSock]) ->  
  io:format("tcp handler init ~n"),  
  inet:setopts(LSock, [{active, once}]),  
  gen_server:cast(self(), tcp_accept),  
  {ok, #state{lsock = LSock}}.  

handle_call(Msg, _From, State) ->  
  io:format("tcp handler call ~p~n", [Msg]),  
  {reply, {ok, Msg}, State}.  

handle_cast(tcp_accept, #state{lsock = LSock} = State) ->  
  {ok, CSock} = gen_tcp:accept(LSock),  
  io:format("tcp handler info accept client ~p~n", [CSock]),  
  {ok, {IP, _Port}} = inet:peername(CSock),  
   start_server_listener(self()),  
  {noreply, State#state{socket=CSock, addr=IP}, ?Timeout};  

handle_cast(stop, State) ->  
  {stop, normal, State}.  

handle_info({tcp, Socket, Data}, State) ->  
  inet:setopts(Socket, [{active, once}]),  
  io:format("tcp handler info ~p got message ~p~n", [self(), Data]),  
  ok = gen_tcp:send(Socket, <<Data/binary>>),  
  {noreply, State, ?Timeout};  

handle_info({tcp_closed, _Socket}, #state{addr=Addr} = State) ->  
  io:format("tcp handler info ~p client ~p disconnected~n", [self(), Addr]),  
  {stop, normal, State};  

handle_info(timeout, State) ->  
  io:format("tcp handler info ~p client connection timeout~n", [self()]),  
  {stop, normal, State};  

handle_info(_Info, State) ->  
  io:format("tcp handler info ingore ~p~n", [_Info]),  
  {noreply, State}.  

terminate(_Reason, #state{socket=Socket}) ->  
  io:format("tcp handler terminate ~p~n", [_Reason]),  
  (catch gen_tcp:close(Socket)),  
  ok.  

code_change(_OldVsn, State, _Extra) ->  
  {ok, State}.  

start_server_listener(Pid) ->  
  gen_server:cast(tcp_server_listener, {tcp_accept, Pid}).  
```

TCP服务器资源文件（tcp_server.app) 

TCP服务器资源文件（tcp_server.app) 

```
[plain] view plain copy
{application,tcp_server,  
  [{description,"TCP Server"},  
   {vsn,"1.0.0"},  
   {modules,[tcp_server,tcp_server_app,tcp_server_handler,  
         tcp_server_listener,tcp_server_sup]},  
   {registered,[]},  
   {mod,{tcp_server_app,[]}},  
   {env,[]},  
   {applications,[kernel,stdlib]}]}. 
```


编译程序
为应用程序创建如下的目录结构：

编译程序
为应用程序创建如下的目录结构：

```
[plain] view plain copy
./tcp_server  
./tcp_server/ebin/  
./tcp_server/ebin/tcp_server.app  
./tcp_server/src/tcp_server_app.erl  
./tcp_server/src/tcp_server_sup.erl  
./tcp_server/src/tcp_server_listener.erl  
./tcp_server/src/tcp_server_handler.erl  
Linux:

[plain] view plain copy
$ cd tcp_server/src  
$ for f in tcp*.erl ; do erlc -o ../ebin $f  
```

貌似不灵，请使用：

```
erlc -o ../ebin *.erl
Windows，cmd进入，记得环境变量要加入erl otp路径:
[plain] view plain copy
cd tcp_server/src  
for %i in (tcp*.erl) do erlc -o ../ebin %i  

```

运行程序
1、启动TCP服务器

```
[plain] view plain copy
erl -pa ebin  
...  
1> application:start(tcp_server).  
tcp app start  
tcp sup start link  
tcp sup init  
tcp sup init client  
tcp server listener start  
tcp sup start child  
tcp handler start link  
tcp handler init  
ok  
2> appmon:start().  
{ok,<0.41.0>}  

请注意，这个appmon，在erl17以后貌似改成observer了。所以如果你打命令appmon:start()无法启动，那可是试试observer:start()。
```

2、创建一个客户端来请求TCP服务器：

```
[plain] view plain copy
3> f(S), {ok,S} = gen_tcp:connect({127,0,0,1},2222,[{packet,0}]).  
{ok,#Port<0.1859>}  
tcp handler info accept client #Port<0.1860>  
tcp server listener cast tcp_accept  
tcp sup start child  
tcp handler start link  
tcp handler init  

```

3、使用该请求向服务端发送消息：

```
[plain] view plain copy
4> gen_tcp:send(S,<<"hello">>).  
ok  
tcp handler info <0.53.0> got message <<"hello">>  

```

4、接收到服务端发来的信息：

```
[plain] view plain copy
5> f(M), receive M -> M end.  
{tcp,#Port<0.1861>,"hello"}  

```

5、现在让我们尝试向服务端发送多个连接请求：

```
[plain] view plain copy
6> gen_tcp:connect({127,0,0,1},2222,[{packet,0}]).  
...  
7> gen_tcp:connect({127,0,0,1},2222,[{packet,0}]).  
...  
8> gen_tcp:connect({127,0,0,1},2222,[{packet,0}]).  

```

...  


6、服务端程序写有超时功能，如果2分钟内没操作，连接将自动退出

```
[plain] view plain copy
9> tcp handler info <0.39.0> client connection timeout  
9> tcp handler terminate normal  
9> tcp handler info <0.52.0> client connection timeout  
9> tcp handler terminate normal  
9> tcp handler info <0.54.0> client connection timeout  
9> tcp handler terminate normal  
9> tcp handler info <0.56.0> client connection timeout  
9> tcp handler terminate normal  
```

7、下面我们简单演示一下服务器的监督行为：

```
[plain] view plain copy
9> exit(pid(0,58,0),kill).  
tcp server listener info exit <0.58.0>  
true  
tcp sup start child  
tcp handler start link  
tcp handler init  
```

结束语
本例演示了如何创建一个简单的无阻塞的TCP服务器以及如何使用标准 Erlang/OTP 行为。作为一个练习，鼓励读者尝试通用的无阻塞TCP服务器功能抽象成一个独立式的行为。



完整的源码下载地址：http://download.csdn.net/download/libaineu2004/10009111