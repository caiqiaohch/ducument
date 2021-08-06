# Erlang 高阶函数 (Fun)

Erlang 作为函数式编程语言自然拥有高阶函数。在 shell 中，我们可以这样使用：

86> Xf = fun(X) -> X * 2 end.
 #Fun<erl_eval.5.123085357>
87> Xf(5).
10
这里定义了一个数值翻倍的函数，并将这个函数赋给了一个变量。所以，Xf(5) 返回值为 10。Erlang 有两个非常有用的操作列表的函数 foreach 与 map， 定义如下：

foreach(Fun, [First|Rest]) ->
    Fun(First),
    foreach(Fun, Rest);
foreach(Fun, []) ->
    ok.

map(Fun, [First|Rest]) -> 
    [Fun(First)|map(Fun,Rest)];
map(Fun, []) -> 
    [].
这两个函数是由标准模块 lists 提供的。foreach 将一个函数作用于列表中的每一个元素。 map 通过将一个函数作用于列表中的每个元素生成一个新的列表。下面，在 shell 中使用 map 的 Add_3 函数生成一个新的列表：

88> Add_3 = fun(X) -> X + 3 end.
 #Fun<erl_eval.5.123085357>
89> lists:map(Add_3, [1,2,3]).
[4,5,6]
让我们再次输出一组城市的温度值：

90> Print_City = fun({City, {X, Temp}}) -> io:format("~-15w ~w ~w~n",
[City, X, Temp]) end.
 #Fun<erl_eval.5.123085357>
91> lists:foreach(Print_City, [{moscow, {c, -10}}, {cape_town, {f, 70}},
{stockholm, {c, -4}}, {paris, {f, 28}}, {london, {f, 36}}]).
moscow          c -10
cape_town       f 70
stockholm       c -4
paris           f 28
london          f 36
ok
下面，让我们定义一个函数，这个函数用于遍历城市温度列表并将每个温度值都转换为摄氏温度表示。如下所示：

-module(tut13).

-export([convert_list_to_c/1]).

convert_to_c({Name, {f, Temp}}) ->
    {Name, {c, trunc((Temp - 32) * 5 / 9)}};
convert_to_c({Name, {c, Temp}}) ->
    {Name, {c, Temp}}.

convert_list_to_c(List) ->
    lists:map(fun convert_to_c/1, List).
92> tut13:convert_list_to_c([{moscow, {c, -10}}, {cape_town, {f, 70}},
{stockholm, {c, -4}}, {paris, {f, 28}}, {london, {f, 36}}]).
[{moscow,{c,-10}},
 {cape_town,{c,21}},
 {stockholm,{c,-4}},
 {paris,{c,-2}},
 {london,{c,2}}]
convert_to_c 函数和之前的一样，但是它现在被用作高阶函数：

lists:map(fun convert_to_c/1, List)
当一个在别处定义的函数被用作高阶函数时，我们可以通过 Function/Arity 的方式来引用它（注意，Function 为函数名，Arity 为函数的参数个数）。所以在调用 map 函数时，才会是 lists:map(fun convert_to_c/1, List) 这样的形式。如上所示，convert_list_to_c 变得更加的简洁易懂。

lists 标准库中还包括排序函数 sort(Fun,List)，其中 Fun 接受两个输入参数，如果第一个元素比第二个元素小则函数返回真，否则返回假。把排序添加到 convert_list_to_c 中：

-module(tut13).

-export([convert_list_to_c/1]).

convert_to_c({Name, {f, Temp}}) ->
    {Name, {c, trunc((Temp - 32) * 5 / 9)}};
convert_to_c({Name, {c, Temp}}) ->
    {Name, {c, Temp}}.

convert_list_to_c(List) ->
    New_list = lists:map(fun convert_to_c/1, List),
    lists:sort(fun({_, {c, Temp1}}, {_, {c, Temp2}}) ->
                       Temp1 < Temp2 end, New_list).
93> c(tut13).
{ok,tut13}
94> tut13:convert_list_to_c([{moscow, {c, -10}}, {cape_town, {f, 70}},
{stockholm, {c, -4}}, {paris, {f, 28}}, {london, {f, 36}}]).
[{moscow,{c,-10}},
 {stockholm,{c,-4}},
 {paris,{c,-2}},
 {london,{c,2}},
 {cape_town,{c,21}}]
在 sort 中用到了下面这个函数：

fun({_, {c, Temp1}}, {_, {c, Temp2}}) -> Temp1 < Temp2 end,
这儿用到了匿名变量 "_" 的概念。匿名变量常用于忽略一个获得的变量值的场景下。当然，它也可以用到其它的场景中，而不仅仅是在高阶函数这儿。Temp1 < Temp2 说明如果 Temp1 比 Temp2 小，则返回 true。