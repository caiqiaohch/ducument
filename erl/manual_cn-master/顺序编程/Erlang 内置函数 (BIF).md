# Erlang 内置函数 (BIF)

内置函数是指那些出于某种需求而内置到 Erlang 虚拟机中的函数。内置函数常常实现那些在 Erlang 中不容易实现或者在 Erlang 中实现效率不高的函数。某些内置函数也可以只用函数名就调用，因为这些函数是由于默认属于 erlang 模块。例如，下面调用内置函数 trunc 等价于调用 erlang:trunc。

如下所示，判断一个是否为闰年。如果可以被 400 整除，则为闰年。为了判断，先将年份除以 400，再用 trunc 函数移去小数部分。然后，再将结果乘以 400 判断是否得到最初的值。例如，以 2004 年为例：

2004 / 400 = 5.01
trunc(5.01) = 5
5 * 400 = 2000
2000 年与 2004 年不同，2004 不能被 400 整除。而对于 2000 来说，

2000 / 400 = 5.0
trunc(5.0) = 5
5 * 400 = 2000
所以，2000 年为闰年。接下来两个 trunc 测试例子判断年份是否可以被 100 或者 4 整除。 首先第一个 if 语句返回 leap 或者 not_leap，该值存储在变量 Leap 中的。这个变量会被用到后面 feb 的条件测试中，用于计算二月份有多少天。

这个例子演示了 trunc 的使用方法。其实，在 Erlang 中可以使用内置函数 rem 来求得余数，这样会简单很多。示例如下：

74> 2004 rem 400.
4
所以下面的这段代码也可以改写：

trunc(Year / 400) * 400 == Year ->
    leap;
可以被改写成：

Year rem 400 == 0 ->
    leap;
Erlang 中除了 trunc 之外，还有很多的内置函数。其中只有一部分可以用在 guard 中，并且你不可以在 guard 中使用自定义的函数 ( 参考 guard 序列 )。（高级话题：这不能保证 guard 没有副作用）。让我们在 shell 中测试一些内置函数：

75> trunc(5.6).
5
76> round(5.6).
6
77> length([a,b,c,d]).
4
78> float(5).
5.0
79> is_atom(hello).
true
80> is_atom("hello").
false
81> is_tuple({paris, {c, 30}}).
true
82> is_tuple([paris, {c, 30}]).
false
所有的这些函数都可以用到 guard 条件测试中。下现这些函数不可以用在 guard 条件测试中：

83> atom_to_list(hello).
"hello"
84> list_to_atom("goodbye").
goodbye
85> integer_to_list(22).
"22"
这三个内置函数可以完成类型的转换。要想在 Erlang 系统中（非 Erlang 虚拟机中）实现这样的转换几乎是不可能的。