TCP连接处理

上一篇文章大概捋了一下游戏服务器启动的时候对应模块的动作，现在我们来仔细研究一下其中的start_tcp/0和start_client/0部分。

在start_tcp/0中启动了sd_tcp_listener_sup监控树，并挂到sd_sup下。其后启动的进程树形关系如下：



这是游戏服务器启动后使用observer观察到的游戏内进程关系图，<0.68.0>为start_tcp/0启动的sd_tcp_listener_sup监控树，<0.70.0>为启动的sd_tcp_listener进程。跟随在sd_tcp_acceptor_sup后的十个进程为sd_tcp_acceptor进程。下面结合代码详细解释一下tcp连接的建立过程。

sd_tcp_listener：挂在sd_tcp_listener_sup监控树下的gen_server，用于监听tcp端口。看下它的初始化函数init/1：

init({AcceptorCount, Port}) ->
  process_flag(trap_exit, true),
  case gen_tcp:listen(Port, ?TCP_OPTIONS) of
    {ok, LSock} ->
      lists:foreach(fun (_) ->
        {ok, _APid} = supervisor:start_child(
          sd_tcp_acceptor_sup, [LSock])
                    end,
        lists:duplicate(AcceptorCount, dummy)),
      {ok, LSock};
    {error, Reason} ->
      {stop, {cannot_listen, Reason}}
  end.
使用gen_tcp:listen/2监听指定的端口，建立ListenSocket后通过lists:duplicate/2创建10个sd_tcp_acceptor_sup的子进程（此处传入的AcceptorCount为10）。

sd_tcp_acceptor：挂在sd_tcp_acceptor_sup下的gen_server，在建立ListenSocket之后被创建。看一下它的初始化函数init/1：

init({LSock}) ->
    gen_server:cast(self(), accept),
    {ok, #state{sock=LSock}}.
进程在初始化的时候给自己cast了一条消息，内容为原子accept，在hande_cast/2中接收到消息后调用accept/1函数，函数的实现：

accept(State = #state{sock=LSock}) ->
    case prim_inet:async_accept(LSock, -1) of
        {ok, Ref} -> {noreply, State#state{ref=Ref}};
        Error     -> {stop, {cannot_accept, Error}, State}
    end.
此处没有使用gen_tcp:receive或者gen_tcp:accept来接收客户端消息，而是使用了prim_inet:async_accept/2来进行异步的消息接收，如果有消息传来，此时进程本身会收到一条格式为{inet_async,S,Ref,Status}的消息，由于进程为一个gen_server，我们在handle_info里面处理：

handle_info({inet_async, LSock, Ref, {ok, Sock}}, State = #state{sock=LSock, ref=Ref}) ->
    case set_sockopt(LSock, Sock) of
        ok -> ok;
        {error, Reason} -> exit({set_sockopt, Reason})
    end,
    start_client(Sock),
    accept(State);
建立了与客户端的Socket连接后，调用start_client/1函数：

start_client(Sock) ->
    {ok, Child} = supervisor:start_child(sd_tcp_client_sup, []),
    ok = gen_tcp:controlling_process(Sock, Child),
    Child ! {go, Sock}.
在sd_tcp_client_sup监控树下新建客户端进程sd_reader，使用gen_tcp:controlling_process/2将建立的Socket控制进程修改为该客户端进程，并给该进程发送一条{go,Socket}的消息，客户端进程接收到这条消息后便开始接手与客户端的通信。

之后sd_tcp_acceptor调用accept/1函数，进入循环等待客户端连接的过程。
