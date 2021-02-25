Erlang匹配、Guards 与变量的作用域

在某些场景下，我们可能需要找到最高温度或最低温度。所以查找温度值列表中最大值或最小值是非常有用的。在扩展程序实现该功能之前，让我们先看一下寻找列表中的最大值的方法：

-module(tut6).
-export([list_max/1]).

list_max([Head|Rest]) ->
   list_max(Rest, Head).

list_max([], Res) ->
    Res;
list_max([Head|Rest], Result_so_far) when Head > Result_so_far ->
    list_max(Rest, Head);
list_max([Head|Rest], Result_so_far)  ->
    list_max(Rest, Result_so_far).
37> c(tut6).
{ok,tut6}
38> tut6:list_max([1,2,3,4,5,7,4,3,2,1]).
7
首先注意这两个函数的名称是完全相同的。但是，由于它们接受不同数目的参数，所以在 Erlang 中它们被当作两个完全不相同的函数。在你需要使用它们的时候，你使用名称/参数数量的方式就可以了，这里名称就是函数的名称，参数数量是指函数的参数的个数。这个例子中为 list_max/1 与 list_max/2。

在本例中，遍历列表的中元素过程中 “携带” 了一个值（最大值），即 Result_so_far。 list_max/1 函数把列表中的第一个元素当作最大值元素，然后使用剩余的元素作参数调用函数 list_max/2。在上面的例子中为 list_max([2，3，4，5，6，7，4，3，2，1]，1)。如果你使用空列表或者非列表类型的数据作为实参调用 list_max/1，则会产生一个错误。注意，Erlang 的哲学是不要在错误产生的地方处理错误，而应该在专门处理错误的地方来处理错误。稍后会详细说明。

在 list_max/2 中，当 Head > Result_so_far 时，则使用 Head 代替 Result_so_far 并继续调用函数。 when 用在函数的 -> 前时是一个特别的的单词，它表示只有测试条件为真时才会用到函数的这一部分。这种类型的测试被称这为 guard。如果 guard 为假 （即 guard 测试失败），则跳过此部分而尝试使用函数的后面一部分。这个例子中，如果 Head 不大于 Result_so_far 则必小于或等于。所以在函数的下一部分中不需要 guard 测试。

可以用在 guard 中的操作符还包括：

<小于
> 大于
== 等于
>= 大于或等于
=< 小于或等于
/= 不等于
（详见 Guard Sequences）

要将上面找最大值的程序修改为查找最小值元素非常容易，只需要将 > 变成 < 就可以了。（但是，最好将函数名同时也修改为 list_min）

前面我们提到过，每个变量在其作用域内只能被赋值一次。从上面的例子中也可以看到，Result_so_far 却被赋值多次。这是因为，每次调用一次 list_max/2 函数都会创建一个新的作用域。在每个不同的作用域中，Result_so_far 都被当作完全不同的变量。

另外，我们可以使用匹配操作符 = 创建一个变量并给这个变量赋值。因此，M = 5 创建了一个变量 M，并给其赋值为 5。如果在相同的作用域中，你再写 M = 6, 则会导致错误。可以在 shell 中尝试一下：

39> M = 5.
5
40> M = 6.
** exception error: no match of right hand side value 6
41> M = M + 1.
** exception error: no match of right hand side value 6
42> N = M + 1.
6
除了创建新变量外，匹配操作符另一个用处就是将 Erlang 项分开。

43> {X, Y} = {paris, {f, 28}}.
{paris,{f,28}}
44> X.
paris
45> Y.
{f,28}
如上，X 值为 paris，而 Y 的值为 {f,28}。

如果同样用 X 和 Y 再使用一次，则会产生一个错误：

46> {X, Y} = {london, {f, 36}}.
** exception error: no match of right hand side value {london,{f,36}}
变量用来提高程序的可读性。例如，在 list_max/2 函数中，你可以这样写：

list_max([Head|Rest], Result_so_far) when Head > Result_so_far ->
    New_result_far = Head,
    list_max(Rest, New_result_far);
这样写可以让程序更加清晰。