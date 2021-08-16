#  prim_inet 

1.异步接收用prim_inet:async_recv(Sock, Length, Timeout)

gen_server里面这样写

handle_info({inet_async, Socket, Ref, {ok, Data}}, State)，要两者配合一起用，即handle_info作为async_recv的回调函数返回

接收的结果

2.prim_inet:async_recv的receive接收写法如下

loop(Socket) ->
prim_inet:async_recv(Socket, 0, 1000),
receive
    {inet_async, _ ,_ ,{ok, Msg}} ->
        io:format("message received ~p~n",[Msg]),
        loop(Socket);
    {inet_async,_,_,{error,timeout}} ->
        io:format("timeout !"),
        catch gen_tcp:close(Socket);
    {fake, Msg} -> io:format("Message = ~p~n", [Msg]),
                   loop(Socket)
end.
3.用case Status of的时候，注意Status必须是一个已确定的值，不能是未绑定的变量

4.在erlang shell调用exit(Pid, Reason)时，Pid应该写成这样形式pid(0,37,0)或者c:pid(0,37,0)

5.spawn的两种形式

spawn(Mod, Func, Args)

spawn(Fun)
————————————————
版权声明：本文为CSDN博主「Tony_Xian」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/boiled_water123/article/details/80533502