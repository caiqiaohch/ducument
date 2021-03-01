Erlang进程管理

Erlang进程管理
相比于其它函数式编程语言，Erlang 的优势在于它的并发程序设计与分布式程序设计。并发是指一个程序中同时有多个线程在执行。例如，现代操作系统允许你同时使用文字处理、电子制表软件、邮件终端和打印任务。在任意一个时刻，系统中每个处理单元（CPU）都只有一个线程（任务）在执行，但是可以通过以一定速率交替执行这些线程使得这些它们看上去像是在同时运行一样。Erlang 中创建多线程非常简单，而且很容易就可以实现这些线程之间的通信。Erlang 中，每个执行的线程都称之为一个 process（即进程，注意与操作系统中的进程概念不太一样）。

（注意：进程被用于没有共享数据的执行线程的场景。而线程（thread）则被用于共享数据的场景下。由于 Erlang 各执行线程之间不共享数据，所以我们一般将其称之为进程。)

Erlang 的内置函数 spawn 可以用来创建一个新的进程： spawn(Module, Exported_Function, List of Arguments)。假设有如下这样一个模块：

-module(tut14).

-export([start/0, say_something/2]).

say_something(What, 0) ->
    done;
say_something(What, Times) ->
    io:format("~p~n", [What]),
    say_something(What, Times - 1).

start() ->
    spawn(tut14, say_something, [hello, 3]),
    spawn(tut14, say_something, [goodbye, 3]).
5> c(tut14).
{ok,tut14}
6> tut14:say_something(hello, 3).
hello
hello
hello
done
如上所示，say_something 函数根据第二个参数指定的次数将第一个参数的值输出多次。函数 start 启动两个 Erlang 进程，其中一个将 “hello” 输出 3 次，另一个进程将 “goodbye” 输出三次。所有的进程中都调用了 say_something 函数。不过需要注意的是，要想使用一个函数启动一个进程，这个函数就必须导出此模块，同时必须使用 spawn 启动。

9> tut14:start().
hello
goodbye
<0.63.0>
hello
goodbye
hello
goodbye
请注意，这里并不是先输出 “goodbye” 三次后再输出 “goodbye” 三次。而是，第一个进程先输出一个 "hello"，然后第二个进程再输出一次 "goodbye"。接下来，第一个进程再输出第二个 "hello"。但是奇怪的是 <0.63.0> 到底是哪儿来的呢？在 Erlang 系统中，一个函数的返回值是函数最后一个表达式的值，而 start 函数的第后一个表达式是：

spawn(tut14, say_something, [goodbye, 3]).
spawn 返回的是进程的标识符，简记为 pid。进程标识符是用来唯一标识 Erlang 进程的标记。所以说，<0.63.0> 也就是 spawn 返回的一个进程标识符。下面一个例子就可会讲解如何使用进程标识符。

另外，这个例子中 io:format 输出用的不是 ~w 而变成了 ~p。引用用户手册的说法：“~p 与 ~w 一样都是将数据按标准语法的格式输出，但是当输出的内容需要占用多行时，~p 在分行处可以表现得更加智能。此外，它还会尝试检测出列表中的可输出字符串并将按字符串输出”。