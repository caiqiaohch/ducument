# Erlang极简学习笔记<09>——进程篇

- Erlang的并发是基于消息传递和Actor模型的
- 在Erlang中，并发(Concurrncy)指的是有许多独立运行的actor，但是并不要求它们同时运行，而并行(Parallelism)指的是多个actor在同时运行
- Erlang对可靠性要求很高，因此采用了一种最彻底的做法，禁止进程之间共享内存
- 因为在出现崩溃之后，共享内存会导致系统中的状态不一致，使问题复杂化
- 与共享内存的方式不同，进程之间只能通过发送消息进行通信，所有的消息数据都是复制的。这种方式效率会低一点，但是更安全
- 当系统中的某个部分出现了错误，造成了数据破坏，那么这个部分应该尽快死亡以防止错误和坏数据传播到系统的剩余部分
- Erlang通过在VM中实现进程，这样实现者们可以对优化和可靠性进行完全掌控
- 一个Erlang进程大概占用300个字的内存空间，创建时间只有几微妙
- 为了管理程序所创建的所有进程，VM会为每个核启动一个线程来充当一个调度器(scheduler)
- 每个调度器有一个运行队列(run queue)，也就是一个Erlang进程列表，会给其中的每个进程分配一小段运行时间片
- 当某个调度器的运行队列中任务过多时，会把一部分任务迁移到其他队列中。这意味着，每个Erlang VM都会进行负载均衡操作，程序员无需关心
- Erlang并发编程需要3个原语：创建(spawn)进程、发送消息及接收消息
- 在Erlang中进程就是一个函数。进程运行一个函数，一般运行结束，进程就消失了
- 要启动一个新进程，可以使用Erlang提供的函数spawn/1，这个函数以一个函数为参数，并运行它

```erlang
> F = fun() -> 2 + 2 end.
> spawn(F).
<0.82.0>
```

- spawn/1的返回值(<0.82.0>)称为进程标识符，通常写成pid、Pid或PID
- pid是一个随意设定的值，用来表示虚拟机运行期间的某个时间点上存在(或曾经存在)的某个进程
- 可以用pid作为地址进行进程间的通信
- 在上面的例子中，我们无法得到函数F的返回值。我们只能得到它的pid。因为进程不会返回任何东西
- 使用BIF的self/0函数，可以返回当前进程的pid
- Erlang的消息传递原语——操作符!，也称为bang符号。该操作符的左边是一个pid，右边可以是任意Erlang数据项。这个数据项会被发送给左边的pid所代表的进程，这个进程就可以访问它了

```erlang
> self() ! hello.
```

- 消息会被放到接收进程的邮箱中，但是并没有被读取。上面例子中出现的第二个hello是这个发送函数的返回值。这意味着，可以用如下方式给多个进程发送同样的消息

```erlang
> self() ! self() ! double
```

- 进程邮箱中的消息是按照接收顺序保存的，每当读取一个消息时，就会把消息从邮箱中取出

```erlang
> flush().
Shell got hello
Shell got double
Shell got double
ok
```

- flush/0函数只是一种输出所收到的消息的快捷方法
- 使用receive表达式来接收消息。receive的语法和case...of非常相似。事实上，它们的模式匹配部分的工作原理完全一样，只是receive模式中变量会绑定到收到的消息，而不是case和of之间的表达式。receive表达式也可以有卫语句

```erlang
receive
    Pattern1 when Guard1 -> Expr1;
    Pattern2 when Guard2 -> Expr2;
    Pattern3 -> Expr3
end
```

- 要想知道进程是否收到了消息，唯一的方法是让它发送一条回应。我们的进程如果需要知道要把回应发送给谁，就必须在消息中添加我们的pid。
- 在Erlang中，我们通过把进程pid打包在一个元组中完成这项工作，如果不这样做，那么消息就都是匿名的。打包的结果是一条类似{Pid, Message}的消息
- 我们来编写一个海豚程序来展示消息的收发

```erlang
-module(dolphins).
-compile(export_all).

dolphin() ->
    receive
        {From, do_a_flip} ->
            From ! "How about no?",
            dolphin();
        {From, fish} ->
            From ! "So long and thanks for all the fish!";
        _ ->
            io:format("Heh, we're smarter than you humans.~n"),
            dolphin()
    end.

Eshell
> Dolphin = spawn(dolphins, dolphin, []).
  <0.85.0>
> Dolphin ! {self(), do_a_flip}.
  {<0.78.0>,do_a_flip}
> Dolphin ! {self(), unknown_message}.
  Heh, we're smarter than you humans.
  {<0.78.0>,unknown_message}
> Dolphin ! {self(), fish}.
  {<0.78.0>,fish}
> flush().
  Shell got "How about no?"
  Shell got "So long and thanks for all the fish!"
  ok
```

- 在上面的测试中，引入了一个新的进程创建函数spawn/3。不再只以一个函数为参数，spawn/3函数有3个参数：模块、函数、和函数参数
- 如果进程和actor只是一些能收发消息的函数，并不会带来多少好处。为了能够得到更大的好处，需要在进程中持有状态
- 借助于递归函数的帮助，进程的状态可以全部存放到递归函数的参数中
- 如果直接使用消息的收发，程序员则需要知道每个进程自身使用的协议。这是一个无意义的负担。
- 一种好的方式是，使用函数来处理消息的接收和发送，从而把消息隐藏起来

```erlang
store(Pid, Food) ->
    Pid ! {self(), {store, Food}},
    receive
        {Pid, Msg} -> Msg
    end.
```

- 同样Erlang中也习惯在模块中，增加一个start/1函数来隐藏进程启动

```erlang
start() ->
    spawn(?MODULE, dolphin, []).
```

- ?MODULE是一个宏，它的值是当前模块的名字
- receive可以使用after子句来处理超时

```erlang
receive
    Match -> Expression1
after Delay ->
    Expression2
end
```

- 当过了Delay(单位：毫秒)时间后，还没有收到和Match模式相匹配的消息，就会执行after部分
- 实际上after除了可以接收毫秒值外，还可以接收原子infinity
- 在大多数语言中，异常都是使用try...catch这种方式在程序执行流内处理的
- 这种常见的做法存在一个问题，要么必须在正常代码逻辑的每一层中处理异常错误，要么只好把错误处理的负担一直推到程序的最顶层中处理。这样做虽然可以捕获所有的错误，但却再也无法知道错误出现的原因了
- Erlang除了支持常见的异常处理模式，还支持另一种层次的异常处理。可以把异常处理逻辑从程序的正常执行流中移出来，放到另外一个并发进程中。这种方法会让代码更加整洁，只用考虑那些“正常的情况”
- 链接(link)是两个进程之间的一种特殊关系。当两个进程间建立了这种关系后，如果其中一个进程由于意外的抛出、出错或者退出而死亡时，另外一个进程也会死亡，把这两个进程独立的生存期绑定成一个关联在一起的生存期
- 从尽快失败阻止错误蔓延的角度来说，这是一个非常有用的概念。如果某个进程由于错误崩溃了，但依赖于它的进程却继续运行，那么所有这些依赖进程都必须要处理依赖缺失情况。让它们死亡，然后重启整个进程组通常是一种可以接受的替代方案。链接就是实现这种功能的
- Erlang中又一个原生函数link/1，用于在两个进程间建立一条链接，它的参数是进程的pid。当调用它时，会在当前进程和参数pid标识的进程之间建立一条链接。要去除链接可以使用unlink/1
- 当链接进程中的一个死亡时，会发送一条特殊的消息，其中含有死亡原因相关的信息。如果进程正常死亡了(函数执行完毕)，就不会发送这条消息

```erlang
-module(linkmon).
-compile(export_all).

myproc() ->
    timer:sleep(5000),
    exit(reason).

Eshell
> c(linkmon).
> spawn(fun linkmon:myproc/0).
> link(spawn(fun linkmon:myproc/0)).
  true
  ** exception error: reason
```

- 注意！链接不会堆叠，如果在同样的两个进程之间调用了多次link/1，那么这两个进程之间只会存在一条链接，只需一次unlink/1调用就可以解除这个链接
- link(spawn(Function))或者link(spawn(M, F, A))并不是一个原子操作。有时进程会在链接建立成功之前死亡，从而导致不期望的行为。因此，Erlang中增加了spawn_link/1-3函数。这个函数的参数和spawn/1-3完全一样，创建一个进程，并和它建立链接，就像使用了link/1一样，不过这是一个原子调用(两个操作被合并成一个操作，要么成功，要么失败，不会出现其他情况)

```erlang
> spawn_link(fun linkmon:myproc/0).
  <0.90.0>
  ** exception error: reason
```

- 跨进程的错误传播对进程来说和消息传递类似，不过使用的是一种称为信号(signal)的特殊消息。退出信号是一种“秘密”消息，会自动作用到进程上并杀死它们
- 链接可以完成快速杀死进程的工作，还缺少快速重启部分。要重启一个进程，首先需要知道它已经死亡了，有一种称为系统进程的概念，可以完成这项工作
- 系统进程就是一般的进程，只是它们可以把退出信号转换成普通的消息。进程可以通过调用process_flag(trap_exit, true)实现这一点

```erlang
> process_flag(trap_exit, true).
> spawn_link(fun linkmon:myproc/0).
> receive X -> X end.
  {'EXIT',<0.97.0>,reason}
```

- 也许杀死进程并不是你想要的，也许你只想当一个跟踪者。如果是这样，那么监视器(monitor)可能就是你想要的
- 监控器是一种特殊类型的链接
- 监控器是单向的
- 在两个进程之间可以设置多个监控器(监控器可以叠加，每个监控器有自己的标识)
- 如果一个进程想知道另外一个进程的死活，但是这两个进程之间并没有强的业务关联时，可以使用监视器
- 创建监控器的函数是erlang:monitor/2，它的第一个参数永远是原子process，第二个参数是pid

```erlang
> erlang:monitor(process, spawn(fun() -> timer:sleep(500) end)).
> flush().
  Shell got {'DOWN',#Ref<0.4159903409.3575906310.207444>,process,<0.80.0>,normal}
```

- 每当被监控的进程死亡时，监控进程都会收到一条消息，格式是{'DOWN', MonitorReference, process, Pid, Reason}。其中的引用可以用来解除对一个进程的监控
- 记住！监控器是可以叠加的，因此会收到多条DOWN消息。引用可以唯一确定一条DOWN消息
- 和链接一样，监控器也有一个原子性质的函数，可以在创建进程的同时监控它：spawn_monitor/1-3

```erlang
> {Pid, Ref} = spawn_monitor(fun() -> receive _ -> exit(boom) end end).
> erlang:demonitor(Ref).
> Pid ! dir.
> flush().
```

- 这个例子我们在进程死亡前解除了对它的监控，因此无法跟踪到它的死亡消息。还有另一个函数demonitor/2，它的功能会多一点。第二个参数是一个选项列表。不过，只有两个可用选项：info和flush

```erlang
> erlang:demonitor(Ref, [flush, info]).
  false
```

- info选项用来指示某个监控器在解除时是否还存在。这也是为何这里调用返回了false
- flush选项会把邮箱中存在的DOWN消息都清除掉
- Erlang还为进程提供了一个命名的方法。通过给进程起一个名字，可以用一个原子而不是一个不可理解的pid来标识一个进程。可以使用这个原子名给进程发送消息，和pid完全一样
- 可以使用函数erlang:register(Name, Pid)为进程命名。如果进程死亡，它会自动失去自己的名字。也可以使用函数unregister/1手工解除进程的名字注册
- 可以调用registered/0得到所有已注册进程的列表，或者通过Eshell命令regs()得到更详细的信息
- 通过函数whereis/1可以获取已注册进程的pid
- 如果有一个数据可以被多个进程看到，这就是大家熟知的**共享状态**
- 如果多个不同进程同时访问数据、修改数据的内容，导致信息不一致，发生软件错误。对这种情况有一个常用术语：**竞争条件(race condition)**
- 竞争条件非常危险，因为它们的出现依赖于事件的时序。在几乎所有现存的并发和并行语言中，这种时序都和一些不可预测的因素有关，如处理器的繁忙程度、进程运行的位置以及程序所处理的数据类型
- 在实际使用Erlang收发消息时，我们应该通过引用(make_ref())来作为识别消息的唯一值，并用它来保证从正确的进程收到了正确的消息

```erlang
judge2(Band, Album) ->
    Ref = make_ref(),
    critic ! {self(), Ref, {Band, Album}},
    receive
        {Ref, Criticism} -> Criticism
    after 2000 ->
        timeout
    end.

critic2() ->
    receive
        {From, Ref, {_Band, _Album}} ->
            From ! {Ref, "They are terrible!"}
    end,
    critic2().
```

- **最后请记住**，原子的个数是有限的。绝对不要动态创建原子。这意味着，命名进程应该保留给那些单个VM实例中唯一的、重要的并且在整个应用运行期间都要一直存在的服务。如果需要为那些暂时的或者VM中并不唯一的进程命名，就意味着可能需要把它们看成一个群组。明智的做法是把它们链接在一起，让它们共存亡，而不是试图使用动态的名字