Erlang完整示例

接下来，我们会用一个更加完整的例子来巩固前面学到的内容。假设你有一个世界上各个城市的温度值的列表。其中，一部分是以摄氏度表示，另一部分是华氏温度表示的。首先，我们将所有的温度都转换为用摄氏度表示，再将温度数据输出。

%% This module is in file tut5.erl

-module(tut5).
-export([format_temps/1]).

%% Only this function is exported
format_temps([])->                        % No output for an empty list
    ok;
format_temps([City | Rest]) ->
    print_temp(convert_to_celsius(City)),
    format_temps(Rest).

convert_to_celsius({Name, {c, Temp}}) ->  % No conversion needed
    {Name, {c, Temp}};
convert_to_celsius({Name, {f, Temp}}) ->  % Do the conversion
    {Name, {c, (Temp - 32) * 5 / 9}}.

print_temp({Name, {c, Temp}}) ->
    io:format("~-15w ~w c~n", [Name, Temp]).
35> c(tut5).
{ok,tut5}
36> tut5:format_temps([{moscow, {c, -10}}, {cape_town, {f, 70}},
{stockholm, {c, -4}}, {paris, {f, 28}}, {london, {f, 36}}]).
moscow          -10 c
cape_town       21.11111111111111 c
stockholm       -4 c
paris           -2.2222222222222223 c
london          2.2222222222222223 c
ok
在分析这段程序前，请先注意我们在代码中加入了一部分的注释。从 % 开始，一直到一行的结束都是注释的内容。另外，-export([format_temps/1]) 只导出了函数 format_temp/1，其它函数都是局部函数，或者称之为本地函数。也就是说，这些函数在 tut5 外部是不见的，自然不能被其它模块所调用。

在 shell 测试程序时，输出被分割到了两行中，这是因为输入太长，在一行中不能被全部显示。

第一次调用 format_temps 函数时，City 被赋予值 {moscow,{c,-10}}, Rest 表示剩余的列表。所以调用函数 print_temp(convert_to_celsius({moscow,{c,-10}}))。

这里，convert_to_celsius({moscow,{c,-10}}) 调用的结果作为另一个函数 print_temp 的参数。当以这样嵌套的方式调用函数时，它们会从内到外计算。也就是说，先计算 convert_to_celsius({moscow,{c,-10}}) 得到以摄氏度表示的值 {moscow,{c,-10}}。接下来，执行函数 convert_to_celsius 与前面例子中的 convert_length 函数类似。

print_temp 函数调用 io:format 函数，~-15w 表示以宽度值 15 输出后面的项 (参见STDLIB 的 IO 手册。)

接下来，用列表剩余的元素作参数调用 format_temps(Rest)。这与其它语言中循环构造很类似 （是的，虽然这是规递的形式，但是我们并不需要担心）。再调用 format_temps 函数时，City 的值为 {cape_town,{f,70}}，然后同样的处理过程再重复一次。上面的过程一直重复到列表为空为止。因为当列表为空时，会匹配 format_temps([]) 语句。此语句会简单的返回原子值 ok，最后程序结束。