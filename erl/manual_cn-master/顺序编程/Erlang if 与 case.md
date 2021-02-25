Erlang if 与 case

Erlang if 与 case
上面的 find_max_and_min 函数可以找到温度的最大值与最小值。这儿介绍一个新的结构 if。If 的语法格式如下：

if
    Condition 1 ->
        Action 1;
    Condition 2 ->
        Action 2;
    Condition 3 ->
        Action 3;
    Condition 4 ->
        Action 4
end
注意，在 end 之前没有 “;”。条件（Condidtion）的工作方式与 guard 一样，即测试并返回成功或者失败。Erlang 从第一个条件开始测试一直到找到一个测试为真的分支。随后，执行该条件后的动作，且忽略其它在 end 前的条件与动作。如果所有条件都测试失败，则会产生运行时错误。一个测试恒为真的条件就是 true。它常用作 if 的最后一个条件，即当所有条件都测试失败时，则执行 true 后面的动作。

下面这个例子说明了 if 的工作方式：

-module(tut9).
-export([test_if/2]).

test_if(A, B) ->
    if 
        A == 5 ->
            io:format("A == 5~n", []),
            a_equals_5;
        B == 6 ->
            io:format("B == 6~n", []),
            b_equals_6;
        A == 2, B == 3 ->                      %That is A equals 2 and B equals 3
            io:format("A == 2, B == 3~n", []),
            a_equals_2_b_equals_3;
        A == 1 ; B == 7 ->                     %That is A equals 1 or B equals 7
            io:format("A == 1 ; B == 7~n", []),
            a_equals_1_or_b_equals_7
    end.
测试该程序：

60> c(tut9).
{ok,tut9}
61> tut9:test_if(5,33).
A == 5
a_equals_5
62> tut9:test_if(33,6).
B == 6
b_equals_6
63> tut9:test_if(2, 3).
A == 2, B == 3
a_equals_2_b_equals_3
64> tut9:test_if(1, 33).
A == 1 ; B == 7
a_equals_1_or_b_equals_7
65> tut9:test_if(33, 7).
A == 1 ; B == 7
a_equals_1_or_b_equals_7
66> tut9:test_if(33, 33).
** exception error: no true branch found when evaLuating an if expression
     in function  tut9:test_if/2 (tut9.erl, line 5)
注意，tut9:test_if(33,33) 使得所有测试条件都失败，这将导致产生一个 if_clause 运行时错误。参考 Guard 序列 可以得到更多关于 guard 测试的内容。

Erlang 中还有一种 case 结构。回想一下前面的 convert_length 函数：

convert_length({centimeter, X}) ->
    {inch, X / 2.54};
convert_length({inch, Y}) ->
    {centimeter, Y * 2.54}.
该函数也可以用 case 实现，如下所示：

-module(tut10).
-export([convert_length/1]).

convert_length(Length) ->
    case Length of
        {centimeter, X} ->
            {inch, X / 2.54};
        {inch, Y} ->
            {centimeter, Y * 2.54}
    end.
无论是 case 还是 if 都有返回值。这也就是说，上面的例子中，case 语句要么返回 {inch,X/2.54} 要么返回 {centimeter,Y*2.54}。case 语句也可以用 guard 子句来实现。下面的例子可以帮助你分清二者。这个例子中，输入年份得到指定某月的天数。年份必须是已知的，因为闰年的二月有 29 天，所以必须根据年份才能判断二月的天数。

-module(tut11).
-export([month_length/2]).

month_length(Year, Month) ->
    %% 被 400 整除的为闰年。
    %% 被 100 整除但不能被 400 整除的不是闰年。
    %% 被 4 整除但不能被 100 整除的为闰年。
    Leap = if
        trunc(Year / 400) * 400 == Year ->
            leap;
        trunc(Year / 100) * 100 == Year ->
            not_leap;
        trunc(Year / 4) * 4 == Year ->
            leap;
        true ->
            not_leap
    end,  
    case Month of
        sep -> 30;
        apr -> 30;
        jun -> 30;
        nov -> 30;
        feb when Leap == leap -> 29;
        feb -> 28;
        jan -> 31;
        mar -> 31;
        may -> 31;
        jul -> 31;
        aug -> 31;
        oct -> 31;
        dec -> 31
    end
70> c(tut11).
{ok,tut11}
71> tut11:month_length(2004, feb).
29
72> tut11:month_length(2003, feb).
28
73> tut11:month_length(1947, aug).
31