# [[Erlang 0042\] Erlang 动态执行](https://www.cnblogs.com/me-sa/archive/2012/02/29/erlang0042.html)

  之前遇到过把字符串解析成为Erlang数据项的问题, 参见: **[[Erlang 0021\] From String To Erlang Code](http://www.cnblogs.com/me-sa/archive/2011/12/15/erlang0021.html)**

  现在我们继续上文的话题,看看如何动态执行Erlang表达式,首先把方法简单封装一下:

```
eval(S) ->    {ok,Scanned,_} = erl_scan:string(S),    {ok,Parsed} = erl_parse:parse_exprs(Scanned),    {value, Value,_} = erl_eval:exprs(Parsed,[]),    Value.
```



在Shell里面练习一下,为了简单就直接在Shelll里面定义fun使用了:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
Eshell V5.9  (abort with ^G)1> F=fun(S) ->    {ok,Scanned,_} = erl_scan:string(S),    {ok,Parsed} = erl_parse:parse_exprs(Scanned),    {value, Value,_} = erl_eval:exprs(Parsed,[]),    Value end.#Fun<erl_eval.6.111823515>2> F("erlang:now()").** exception error: no match of right hand side value                    {error,{1,erl_parse,["syntax error before: ",[]]}}3> F("erlang:now().").{1330,525826,164710}4> F("A=2.").  %%绑定了A为225> F("B=2."). %%绑定了B为226> F("B=3."). %%绑定B为337> A.* 1: variable 'A' is unbound8> B.* 1: variable 'B' is unbound9> B=3.310> F("B=3.").311> F("B=31.").3112> F("A+B.").** exception error: {unbound_var,'A'}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)



  看第一个异常的位置,这是由于 F("erlang:now()").执行的语句并没有以"."结束,修改为F("erlang:now().").正常输出了时间;紧接着下面尝试绑定变量,通过连续绑定为B两次值可以知道这样操作的变量在Shell中是没有上下文的,在Shell中定义的变量也不能被使用.然后我们看最后一个表达式,在这个表达式里面有超过一个的变量,直接执行会有变量未绑定的异常,怎么消除这个异常呢?

当然我们可以这样:

```
13> F("A=12,B=3,A*B.").3614> F("A=12,B=33,A*B.").39615>
```



 消除上面的异常实际上就是要维护变量的绑定信息,在erl_eval模块可以找到和绑定相关的内容,在官方文档中,我们可以看到Binding的数据结构是怎样的:

> bindings() = [{name(), value()}]
> binding_struct() = orddict:orddict()
> orddict() = [{Key :: term(), Value :: term()}]
>
>  

官方文档地址:
http://www.erlang.org/doc/man/erl_eval.html#type-binding_struct 
http://www.erlang.org/doc/man/orddict.html#type-orddict 

练习一下几个绑定相关的方法:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
Eshell V5.9  (abort with ^G)1> erl_eval:new_bindings().[]2> erl_eval:bindings([{'B',23}]).[{'B',23}]3> erl_eval:bindings([{'B',23},{'A',34}]).[{'B',23},{'A',34}]4> B=[{'B',23},{'A',34}].[{'B',23},{'A',34}]5> erl_eval:bindings('B',[{'B',23},{'A',34}]).** exception error: undefined function erl_eval:bindings/26> erl_eval:binding('B',[{'B',23},{'A',34}]).{value,23}7> erl_eval:add_binding('C',34,[{'B',23},{'A',34}]).[{'B',23},{'A',34},{'C',34}]8> erl_eval:add_binding('C',34,[{'B',23},{'A',34}]).[{'B',23},{'A',34},{'C',34}]9> erl_eval:del_binding('C',[{'B',23},{'A',34}]).[{'B',23},{'A',34}]10> erl_eval:del_binding('B',[{'B',23},{'A',34}]).[{'A',34}]11>
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 怎么使用变量绑定呢? mryufeng http://blog.yufeng.info/archives/tag/erl_token 给了一个例子:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
eval(Str,Binding) ->    {ok,Ts,_} = erl_scan:string(Str),    Ts1 = case lists:reverse(Ts) of              [{dot,_}|_] -> Ts;              TsR -> lists:reverse([{dot,1} | TsR])          end,    {ok,Expr} = erl_parse:parse_exprs(Ts1),    erl_eval:exprs(Expr, Binding).
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 前面已经熟悉了绑定的数据结构,所以我们直接进入Shell实践:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
Eshell V5.9  (abort with ^G)1> erl_eval:new_bindings().[]2> F =fun(Str,Binding) ->    {ok,Ts,_} = erl_scan:string(Str),    Ts1 = case lists:reverse(Ts) of              [{dot,_}|_] -> Ts;              TsR -> lists:reverse([{dot,1} | TsR])          end,    {ok,Expr} = erl_parse:parse_exprs(Ts1),    erl_eval:exprs(Expr, Binding) end.#Fun<erl_eval.12.111823515>3> F("A=23.",[]).{value,23,[{'A',23}]}4> F("A+B.",[{'B',23}]).** exception error: {unbound_var,'A'}5> F("12+B.",[{'B',23}]).{value,35,[{'B',23}]}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

#  **有什么用呢?**

**[1]  erl -eval**


Scans, parses and evaluates an arbitrary expression Expr during system initialization. If any of these steps fail (syntax error, parse error or exception during evaluation), Erlang stops with an error message. Here is an example that seeds the random number generator:



```
% erl -eval '{X,Y,Z}' = now(), random:seed(X,Y,Z).'
```


This example uses Erlang as a hexadecimal calculator:



```
% erl -noshell -eval 'R = 16#1F+16#A0, io:format("~.16B~n", [R])' \\-s erlang haltBF
```

If multiple -eval expressions are specified, they are evaluated sequentially in the order specified. -eval expressions are evaluated sequentially with -s and -run function calls (this also in the order specified). As with -s and -run, an evaluation that does not terminate, blocks the system initialization process.



**[2] file:eval/1 file:eval/2** 

eval(Filename) -> ok | {error, Reason}
eval(Filename, Bindings) -> ok | {error, Reason}

Reads and evaluates Erlang expressions, separated by '.' (or ',', a sequence of expressions is also an expression), from Filename. The actual result of the evaluation is not returned; any expression sequence in the file must be there for its side effect. Returns one of the following:

http://www.erlang.org/doc/man/file.html#eval-1

**[3] 用Erlang实现领域特定语言 http://www.infoq.com/cn/articles/erlang-dsl**

**[4]一个有趣的项目Erlang Web Shell** : **erlwsh** https://github.com/killme2008/erlwsh.

**[5]** 当然也可以解决一些小问题,比如这个 [erlang字符串替换问题-字符串格式化](http://www.erlangqa.com/135/erlang字符串替换问题-字符串格式化)

动态拼接字符串的时候一些变量在字符串多个位置出现,除了使用正则表达式模块re之外,还可以这样做:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
F =fun(Str,Binding) ->    {ok,Ts,_} = erl_scan:string(Str),    Ts1 = case lists:reverse(Ts) of              [{dot,_}|_] -> Ts;              TsR -> lists:reverse([{dot,1} | TsR])          end,    {ok,Expr} = erl_parse:parse_exprs(Ts1),    erl_eval:exprs(Expr, Binding) end.6> F("lists:concat(["haha",B,"ok!"]).",[{'B',23}]).* 1: syntax error before: haha6> F("lists:concat(['haha',B,'ok!']).",[{'B',23}]).{value,"haha23ok!",[{'B',23}]}7> F("lists:concat(['国家',B,'ok!']).",[{'B',23}]).{value,"国家23ok!",[{'B',23}]} 9> F("lists:concat(['国家',B,'ok!',D,B,'hello ',C]).",[{'B',23},{'C',world},{'D',2012}]).{value,"国家23ok!201223hello world",       [{'B',23},{'C',world},{'D',2012}]}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

**[6] erlang-string-lambda**

项目地址: https://github.com/debasishg/erlang-string-lambda

可以做的事情很多,如果有局限,那就是我们的想象力了,晚安