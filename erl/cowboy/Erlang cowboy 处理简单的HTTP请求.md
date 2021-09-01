# Erlang cowboy 处理简单的HTTP请求 

原文出自：

[Handling plain HTTP requests](http://ninenines.eu/docs/en/cowboy/1.0/guide/http_handlers/)

处理请求的最简单的方式是写一个简单的HTTP处理器。它的模型参照Erlang/OTP的gen_server，但是做了简化，Cowboy按次序调用了3个回调函数。

## Initialization

第一个回调，`init/3`，所有处理器都有这个函数，用于区分处理器类型，简单的HTTP处理器仅仅返回ok。



```erlang
init(_Type, Req, _Opts) ->
    {ok, Req, no_state}.
```

这个函数接收用于处理请求的传输和协议模块的名字。可以快速处理请求。例如当采用TCP而不是SSL访问的时，下面的处理器会崩溃：





```erlang
init({ssl, _}, Req, _Opts) ->
    {ok, Req, no_state}.
```

 这个函数还可以接收与前面路由部分设置有关联的选项。如果你的处理器没有使用选项，推荐使用匹配[]，这样可以快速诊断设置错误：





```erlang
init(_Type, Req, []) ->
    {ok, Req, no_state}.
```



如果用户没有设置，你不用验证选项。如果用户设置了选项，并且存在设置错误，你可以令它崩溃。例如，要求的lang选项不存在的话，下面的代码会崩溃：



```erlang
init(_Type, Req, Opts) ->
    {_, _Lang} = lists:keyfind(lang, 1, Opts),
    {ok, Req, no_state}.
```



如果用户不想给出出错的原因，你可以返回一个有意义的错误给用户。既然这时返回给用户了，就不用继续处理器的代码了，因此使用shutdown返回值尽早结束调用：



```erlang
init(_Type, Req, Opts) ->
    case lists:keyfind(lang, 1, Opts) of
        false ->
            {ok, Req2} = cowboy_req:reply(500, [
                {<<"content-type">>, <<"text/plain">>}
            ], "Missing option 'lang'.", Req),
            {shutdown, Req2, no_state};
        _ ->
            {ok, Req, no_state}
    end.
```

一旦选项验证通过，我们就可以安全地使用它们。就可以传递给其余的处理器。这也是返回值元组的第3个元素state所要表达的。

我们建议在此创造一个state record。这个record会让处理器的代码更清晰，也可以更好地利用Dialyzer进行类型检查。



```erlang
-record(state, {
    lang :: en | fr
    %% More fields here.
}).
 
init(_Type, Req, Opts) ->
    {_, Lang} = lists:keyfind(lang, 1, Opts),
    {ok, Req, #state{lang=Lang}}.
```





## Handling the request

第2个回调函数, `handle/2`,是特定于简单HTTP处理器的。你将要在此处理请求的。一个什么都不做的占位的处理器如下：



```erlang
handle(Req, State) ->
    {ok, Req, State}.
```

上面函数没有返回值。为取得请求的信息或发送响应，应该在这里使用Req对象。Req 对象自成一章。下面的处理器发送一个相当原始的响应：





```erlang
handle(Req, State) ->
    {ok, Req2} = cowboy_req:reply(200, [
        {<<"content-type">>, <<"text/plain">>}
    ], <<"Hello World!">>, Req),
    {ok, Req2, State}.
```





## Cleaning up

第3个回调函数也是最后一个, `terminate/3`, 一般什么留空：



```erlang
terminate(_Reason, Req, State) ->
    ok.
```



这个回调严格用于必要的清理。不能在这个函数里发送响应。没有其他的返回值。

如果你使用进程字典，计时器，监控器或者正在接收消息，你可以使用这个函数进行清理，由于Cowboy可能为下一个活动的请求重用这个进程。

在你的处理器中，发生这些的机会是很渺茫的。通常在Erlang代码里不鼓励使用进程字典。如果想要使用计时器，监控器或接收消息，不如使用loop处理器——一种不同类型的处理器专门满足这种需要。

这个函数一直可用，所以你应该使用它。它一直被调用。