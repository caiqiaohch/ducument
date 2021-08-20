## 关于对erlang中由于没有return导致嵌套太深的解决办法
在一些语言中,比如erlang,是没有return语句的,这也就意味着像一些需要立即返回的语句,erlang却无法做到,比如说以下的c语言:

在一些语言中,比如erlang,是没有return语句的,这也就意味着像一些需要立即返回的语句,erlang却无法做到,比如说以下的c语言:

```
void test(){
    if(! check_one()){
        return;
    }
    if(! check_two()){
        return;
    }
    if(! check_three()){
        return;
    }
}
```


在erlang中也就只能这样写:

```
do_check(Params)->
    case check_one(Params) of
        false ->
            error;
        true ->
            case check_two(Params) of
                false ->
                    error;
                true ->
                    case check_three(Params) of
                        false ->
                            error;
                        true ->
                            %% all check passed, do the real logic
                            todo
                    end
            end
    end.
```



就算是在一个普通项目中的普通逻辑中,需要使用到的检查函数也远不止3个,可以想象这种方式在正常项目中写出来的代码,嵌套会有多深,可读性也不好,那么该怎么解决呢?
下面是三种将深嵌套转化为浅嵌套的解决办法.

流程式调用, 主要特点是整个检查函数是按顺序组织起来的, 前一个函数调用成功后, 才会调用下一个函数进行检查, 否则就返回结果不再调用之后的检查函数,如以下示例:
%% 在每次check时,可能需要将一些在当前函数中得出的结果延续给下一个函数,这些数据可放在此record中



```
-record(data,{
                    one,
                    two,
                    three
                 }).
do_check(Params) ->
    Data = #data{},
    case check_one(Params, Data#data{}) of
        {false, Result} ->
            Result;
        {true, NewData} ->
            %% 验证通过,做点什么吧
            todo
    end.
check_one(Params, Data) ->
    %% 如果验证没通过,就返回{false, Result},下面的check_two,check_three同
    %% condition1为函数中的整个判断流程的简写,下同
    case condition1() of
        true ->
            NewData = Data#data{one=1},
            check_two(Params, NewData);
        Error ->
            {false, Error}
    end.
check_two(Params, Data) ->
    case condition2() of
        true ->
            NewData = Data#data{two=2},
            check_three(Params, NewData);
        Error ->
            {false, Error}
    end.
check_three(Params, Data) ->
    case condition3() of
        true ->
            NewData = Data#data{three=3},
            {true, NewData};
        Error ->
            {false, Error}
    end.
```

利用异常处理,在中断处直接抛出异常,如下列代码所示:

```
check() ->
    case catch do_check() of
        {false, Reason} ->
            %% do something for the error reason
            todo_error;
        _ ->
            %% to do the real logic
            todo
    end.

do_check()->
    case condition1() of
        false ->
            throw({false, reason1});
        _ ->
            continue
    end,
    case condition2() of
        false ->
            throw({false, reason2});
        _ ->
            continue
    end,
    case condition3() of
        false ->
            throw({false, reason3});
        _ ->
            continue
    end.
```


利用erlang的尾递归特性自己写了一个bfoldl/3的函数, 可以有效地减少嵌套层数, 这也是我最常用的一种方法, 如下列代码所示:

```
%% 可以中断(break)的lists:foldl().无需将lists全部遍历完
bfoldl(Fun, Acc0, [Head | Tail]) ->
    case Fun(Head, Acc0) of
        {ok, Acc} ->
            bfoldl(Fun, Acc, Tail);
        {break, Acc} ->
            Acc;
        NewAcc ->
            {ok, NewAcc}
    end;
bfoldl(_Fun, Acc0, []) ->
    case Acc0 of
        {ok, Acc} ->
            Acc;
        {break, Acc} ->
            Acc;
        Other ->
            Other
    end.

-record(check, {
                    param1,
                    param2,
                    param3
                 }).

new_do_check(Params) ->
    FunList = [
                         fun new_check_one/2,
                         fun new_check_two/2,
                         fun new_check_three/2
                        ],
    Result = bfoldl(fun(Fun, CheckRecord) -> 
                                            Fun(Params, CheckRecord)
                                    end, #check{}, FunList),
    case Result of
        #check{} ->
            %% do the real logic
            todo;
        _Other ->
            %% for the error todo
            todo_error
            end.

new_check_one(_Params, CheckRecord) ->
    %% todo something with check, or check error, simply return below
    %% {break, Error}, this will break the rest check
    {ok, CheckRecord#check{param1=1}}.
new_check_two(_Params, CheckRecord) ->
    %% todo something with check, or check error, simply return below
    %% {break, Error}, this will break the rest check
    {ok, CheckRecord#check{param2=2}}.
new_check_three(_Params, CheckRecord) ->
    %% todo something with check, or check error, simply return below
    %% {break, Error}, this will break the rest check
    {ok, CheckRecord#check{param3=3}}.
```

————————————————
版权声明：本文为CSDN博主「hahaliu005」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/hahaliu005/article/details/48463959