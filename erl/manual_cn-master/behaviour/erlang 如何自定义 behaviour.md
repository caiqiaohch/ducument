# erlang 如何自定义 behaviour

使用 erlang 编程的人都知道 OTP，而基于 OTP 框架创建进程的时候，常用的有四大 behaviour： 

- supervisor
- gen_server
- gen_fsm
- gen_event

那么什么是 behaviour？是做什么用的呢？ 
    在 StackOverFlow 上这篇[文章](http://stackoverflow.com/questions/6488002/how-to-define-customized-behavior-in-erlang-and-what-can-it-do-for-you)中指明了，在 erlang 的编译器中，**behaviour 的作用是用来定义一个规约**。定义好这个规约之后，任何遵守这个规约的模块，必须按照规约中的要求，使用 -export([]). 导出对应的函数，导出完这些函数后，这些导出函数的调用将由 behaviour 统一支配。
为什么要这么做呢？参照一句话：
这句话来自官方文档 OTP 设计原则的第一句话。那么，**behaviour 只不过是实现代码组织的一种手段而已**。那么，再应用一句：
behaviour 就是把代码分成**通用部分**，以及每一个回调模块需要去做的**特殊部分**。这样就好理解了，于是**使用 -behaviour() 定义的模块都是这个 behaviour 所要求实现的回调模块**。
   这是可以的，如果大家代码读得多了，就应该发现，很多优秀的开源项目中就自定义了 behaviour。例如经典的 rabbitmq 中，就将 erlang 自带的 gen_server 进行了改进，写了一个 gen_server2 的 behaviour，因为 **gen_server 中的消息队列是一个普通消息队列**不能满足需要，**改进后的 gen_server2 使用了带优先级的消息队列**。当然了，在 erlang 本身的底层代码里面，也有写过很多 behaviour，不细说了，总之 erlang 可以自定义 behaviour 。
   在写代码的时候发现有时候用的是 behaviour，而又有的时候用的是 behavior。这两个词应该是美式英语和英式英语的区别吧。说明一点，**在定义 behaviour 的时候**，erlang 是亲美一派的，**必须用 behaviour**，使用 behavior 将报错。而在使用已经定义好的 behavior 模块的时候，对编译器而言，两个词都可以用.....真是很诡异的。
   要定义一个 behaviour，首先你要创建一个模块，它必须导出 behaviour_info/1 这个函数（注意 behaviour 是带 u 的），函数定义如下：
传入 callbacks 参数，必须返回一个包含导出函数和参数个数的列表。
   这些导出函数，就是这些回调模块所特有的部分，而通用部分，则写在 behaviour 中。比如在 gen_server 中，当一个进程收到一个消息，在 behaviour 行为模型中，它会处理大部分通用的逻辑，例如，如果是 call 消息，它会根据 handle_call 函数的返回值对 From 进程发送返回消息，同时，处理完消息后，它会继续循环进行消息处理，不多说，亮代码：
   源代码是最好的老师！有时候我想，想要了解 gen_server ，为什么放着 gen_server.erl 这个源代码不去读，却宁愿相信百度上，或者谷歌上，或者别人说的话呢？还有什么比代码中的事实更真实吗？更可信的吗？
使用的时候，需要在模块开头 使用：
同时需要定义并且使用 -export([]) 导出这个 behaviour 所要求的导出函数。


## **何时使用 behaviour？**

   最后这个话题就比较广了，这是一个没有绝对意义正确的问题，在 erlang OTP 中，那几个主要进程的实现都是使用 behaviour 封装了基本的操作。 

   对于 behaviour 和进程的关系，我曾经有过这样的疑惑，只有在创建进程的时候才能用 behaviour 吗？最后得到的结论是：没有关系！ 因为在 erlang 的设计理念当中，模块与进程，这是两个概念，而 behaviour 与模块的组织相关，因此它与进程没有必然联系。 