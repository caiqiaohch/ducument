一.什么是behavior？
使用erlang编程的人都知道OTP，而OTP里面创建进程的时候，常用的有四大behaviour， supervisor、gen_server、gen_fsm、gen_event。什么是behaviour？他是做什么用？

首先，写这篇文章之前我上谷歌查过人家对behavior的定义，当然，非官方，我一直没找着官方定义，如果有人有一个比较确切的定义，麻烦告诉我，大家共同学习嘛。

http://stackoverflow.com/questions/6488002/how-to-define-customized-behavior-in-erlang-and-what-can-it-do-for-you 在这篇文章中指明了，在erlang 的编译器中，behavior的作用是用来定义一个规约。定义好这个规约之后，任何遵守这个规约的模块，必须按照规约中的要求，使用-export([ ]). 导出对应的函数，导出完这些函数后，这些导出函数的调用由behaviour统一支配。为什么要这么做呢？参照一句话：

TheOTP Design Principles is a set of principles for how to structure Erlang code in terms of processes, modules and directories.

这句话来自官方文档OTP设计原则的第一句话。那么，behaviour只不过是实现代码组织的一种手段而已。那么，再应用一句：

The idea is to divide the code for a process in a generic part (a behaviour module) and a specific part (acallback module).

behaviour就是把代码分成通用部分，以及每一个回调模块需要去做的特殊部分。这样就好理解了，于是使用-behaviour（）定义的模块都是这一个behaviour的回调模块。

二.erlang可以自定义behavior吗？
这是可以的，如果大家代码读得多了，就应该发现，很多优秀的开源项目中就自定义了behaviour，例如经典的rabbitmq中，就将erlang自带的 gen_server 进行了改进，写了一个 gen_server2 的 behaviour，因为gen_server中的消息队列是一个普通消息队列不能满足需要，改进后的gen_server2使用了带优先级的消息队列。当然了，erlang本身的底层代码里面，也有写过很多behaviour，不细说了，总之，erlang可以自定义behaviour

三.是behavior还是behaviour
在写代码的时候发现有时候用的是behaviour，而又有的时候用的是behavior。这两个词应该是美式英语和英式英语的区别吧，说明一点：在定义behaviour的时候，erlang是亲美一派的，必须用behaviour，使用behavior将报错，而在使用已经定义好的behavior模块的时候，对编译器而言，两个词都可以用.....真是很诡异的

四.怎么定义一个behaviour？
要定义一个behaviour，首先你要创建一个模块，它必须导出 behaviour_info/1 这个函数（注意必须带u），函数的定义如下：

behaviour_info(callbacks) ->
    [{foo, 0}, {bar, 1}, {baz, 2}];
behavior_info(_) ->
    undefined.
当传入callbacks参数，必须返回一个包含导出函数和参数个数的列表

这些导出函数，就是这些回调模块所特有的部分，而通用部分，则写在behaviour中。比如，gen_server 中，当一个进程收到一个消息，在behaviour行为模型中，它会处理大部分通用的逻辑，比如，如果是call消息，它会根据handle_call 函数的返回值对From进程发送返回消息，同时，处理完消息后，它会继续循环进行消息处理，不多说，亮代码：

handle_msg({'$gen_call', From, Msg}, GS2State = #gs2_state { mod = Mod,
                                                             state = State,
                                                             name = Name,
                                                             debug = Debug }) ->
    case catch Mod:handle_call(Msg, From, State) of %%大家注意了，这里就是调用了模块中的handle_call()函数，并且获取它的返回值
        {reply, Reply, NState} ->
            Debug1 = common_reply(Name, From, Reply, NState, Debug),
            loop(GS2State #gs2_state { state = NState,%%在这里，处理完一条消息之后，继续转入到循环中去
                                       time  = infinity,
                                       debug = Debug1 });
        {reply, Reply, NState, Time1} ->
            Debug1 = common_reply(Name, From, Reply, NState, Debug),
            loop(GS2State #gs2_state { state = NState,
                                       time  = Time1,
                                       debug = Debug1});
        {noreply, NState} ->
            Debug1 = common_debug(Debug, fun print_event/3, Name,
                                  {noreply, NState}),
            loop(GS2State #gs2_state {state = NState,
                                      time  = infinity,
                                      debug = Debug1});
        {noreply, NState, Time1} ->
            Debug1 = common_debug(Debug, fun print_event/3, Name,
                                  {noreply, NState}),
            loop(GS2State #gs2_state {state = NState,
                                      time  = Time1,
                                      debug = Debug1});
        {stop, Reason, Reply, NState} ->
            {'EXIT', R} =
                (catch terminate(Reason, Msg,
                                 GS2State #gs2_state { state = NState })),
            reply(Name, From, Reply, NState, Debug),
            exit(R);
        Other ->
            handle_common_reply(Other, Msg, GS2State)
    end;
源代码是最好的老师！有时候我想，想要了解gen_server ，为什么放着gen_server.erl这个源代码不去读，却宁愿相信百度上，或者谷歌上，或者别人说的话呢？还有什么比代码中的事实更真实吗？更可信的吗？

五.怎么使用behaviour?
使用的时候，需要在模块开头 使用：

-behaviour(behaviour_name).

同时需要定义并且使用-export([ ])导出，这个behaviour所要求的导出函数。

注意了，一个模块是可以有多个-behaviour(behaviour_name). 的，也就是说，这个模块的一部分函数既是A behaviour的回调模块，又是B behaviour 的回调模块。

六.何时使用behaviour？
最后这个话题就比较广了，这是一个没有绝对意义正确的问题，在erlang OTP 中，那几个主要进程的实现都是使用behaviour 封装了基本的操作。

对于behaviour和进程的关系，我曾经有过这样的疑惑，只有在创建进程的时候才能用behaviour吗？最后得到的结论是：没有关系！ 因为在erlang的设计理念当中，模块与进程，这是两个概念，而behaviour与模块的组织相关，因此它与进程没有必然联系。
