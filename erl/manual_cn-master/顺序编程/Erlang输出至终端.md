Erlang输出至终端

用例子来说明如何格式化输出到终端再好不过了，因此下面就用一个简单的示例程序来说明如何使用 io:format 函数。与其它导出的函数一样，你可以在 shell 中测试 io:format 函数：

31> io:format("hello world~n", []).
hello world
ok
32> io:format("this outputs one Erlang term: ~w~n", [hello]).
this outputs one Erlang term: hello
ok
33> io:format("this outputs two Erlang terms: ~w~w~n", [hello, world]).
this outputs two Erlang terms: helloworld
ok
34> io:format("this outputs two Erlang terms: ~w ~w~n", [hello, world]).
this outputs two Erlang terms: hello world
ok
format/2 （2 表示两个参数）接受两个列表作为参数。一般情况下，第一个参数是一个字符串（前面已经说明，字符串也是列表）。除了 ~w 会按顺序被替换为第二个列表中的的项以外，第一个参数会被直接输出。每个 ~n 都会导致输出换行。如果正常输出，io:formate/2 函数会返回个原子值 ok。与其它 Erlang 函数一样，如果发生错误会直接导致函数崩溃。这并 Erlang 系统中的错误，而是经过深思熟虑后的一种策略。稍后会看到，Erlang 有着非常完善的错误处理机制来处理这些错误。如果要练习，想让 io:format 崩溃并不是什么难事儿。不过，请注意，io:format 函数崩溃并不是说 Erlang shell 本身崩溃了。