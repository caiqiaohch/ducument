1.生产上的服务器，运行到2天左右就会产生core文件，在家折腾了两天，把一些过程记录下来，
   希望能帮上有需要的人。
    gdb  /usr/lib64/erlang/xxx/xxx/beam.smp  core.3435
     ....

    gdb) bt
    #0  0x0000003b5bc30265 in raise () from /lib64/libc.so.6
    #1  0x0000003b5bc31d10 in abort () from /lib64/libc.so.6
    #2  0x000000000044f3b0 in erl_exit ()
    #3  0x00000000004380a4 in erts_alc_fatal_error ()
    #4  0x0000000000438131 in erts_alloc_n_enomem ()
    #5  0x000000000051e918 in ?? ()
    #6  0x000000000052090f in ?? ()
    #7  0x000000000051d8fc in erts_garbage_collect ()
    #8  0x00000000004bc3c0 in schedule ()

   

     看到erlang运行时分配内存不足

2. 代码有死循环？ or 非法的用户用脚本在刷服务
     那就远程看一下在线的服务器运行情况


3. 看日志和内存分配情况
   3.1 远程调用
      ctrl + G 
       r ' xxxx@127.XX.XX.XX'
       (或是 erl -name ' yyyyy@127.XX.XX.XX' -setcookie xxxx  -remsh ' xxxx@127.XX.XX.XX)

   3.2 查看内存使用情况
       erlang:memory(processes).
       3788 928 024

       erlang:memory(ets).
       970 627 328

     erlang:memory(total).
     4 863 713 656
   

       erlang 系统运行时，内存占了近5个G，用不了24小时，系统肯定会再崩溃，
       从上面可以看到ets表占用比较高，进程占用更高，
       猜想下，有没有可能，是ets表导致的owner进程 占用了过4G的内存？
   
    3.3 查看ets表的信息
         ets:i().

        sessions        sessions          set   232182 116713476   xxxx_service      (116713476 words = * 8 = 933 707 808 bytes  ~= 1G  )
        sys_dist        sys_dist          set   3      455      net_kernel
    
        发现sessions表有在线用户23W,这个在线用户量，到是在正常范围，但会话会轮询，定期清除闲置的进程用户，
        不应该一直保持在23w,一定是那里没有来得急释放。
        xxx_service 的代码里找到释放缓存的代码，在本地插入一些用户，测试下，结果释放sessions没有问题。
        怎么回事，可以释放，结果没有释放，代码应该没有问题。
        往往这时，请再坚持一下，代码可能有问题，接着找吧。

3.4 既然进程占内存那么高，那就看看是那些进程，运行 etop
      spawn(fun() ->    etop:start([{output, text}, {interval, 3}, {lines, 20}, {sort, memory}])  end).
      Pid            Name or Initial Func    Time    Reds  Memory    MsgQ Current Function
     ----------------------------------------------------------------------------------------
    <14099.124.0>  xxxxxxxxxxx_service          '-'****************       0 gen_server:loop/6   
     <14099.41.0>   xxxx_server              '-' 618605525150288       0 gen_server:loop/6 

      排第一的，内存多少都变*** 号了，这是非常高了才这样的。估计1G应该是有的，而且还一直在执行loop，说明
      是什么东西处理不过来。
    
    3.5 查看占用内存最多的进程的信息
      Pid = whereis(xxxxxxxxxxx_service).
      process_info(Pid) .


​     
     {
     {total_heap_size,456131400},
     {heap_size,228065700},
     {stack_size,9}



            456131400 * 8  = 3.6G 内存  （words * 8 ,64位系统）
            基本可以肯定问题出在了这个进程。
            这个进程很有可能是在操作ETS时，出的问题，应该找该模块与ets相关的代码。
    
    3.6  找是找到了，ets相关的操作，但测试还是可以清除，也没有生产的问题。
           猜想，是不是测试时用户的量没有达到。
           再看看那段代码，有一个select的操作，是查找某段时间内，所有sessions,
            然后对sessions进行持久化操作，然后清除，
           当23W 用户同时进行持久，这个进程会不会阻塞？
    3.7  分批次进次持久和清除操作，花了半天的时间，开发好，测试没问题了，
           但感觉还有点不爽快，因为效率不高啊。
    3.8  持久的清除解藕。


    4. 上线12小时后，再查看线上服务的结果
    
       11768  103  7.6 1110136 612668
      物理内存只存7.6,
    
     再看sessions 只有2W左右
     这样，码农的心情变好了点........

   5.谢谢。

————————————————
版权声明：本文为CSDN博主「whatiserlang」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/phyzhou/article/details/47706765



使用Erlang搭建游戏服务器时，运维往往会吐槽cpu占用过高、带宽太大或者内存消耗太快，本文总结一下排查内存占用过高的主要思路和流程。

1. 检查进程数
	erlang:system_info(process_count).
1
看是否有大量的异常进程在耗内存，之前写过一篇博文（点我查看文章）记录过一个类似的问题：项目因为错误使用了三方数据库连接池，连接进程异常重启，产生了大量的数据库连接耗尽mysql连接池。

进程数量过大的话，就要找出没有被链接或者被监控的“孤儿进程”：

	[P || P<-processes(),
		[{_,Ls},{_,Ms}] <- [process_info(P,[links,monitors])],
		[]==Ls,[]==Ms].
1
2
3
或通过

	supervisor:count_children/1
1
查看sup下进程数量和状态。

2.查看节点内存分配情况
	erlang:memory().
1
输出(单位是byte):

[{total,361896384},
 {processes,135616968},
 {processes_used,135616896},
 {system,226279416},
 {atom,1025185},
 {atom_used,1023118},
 {binary,1129328},
 {code,61757391},
 {ets,150573120}]
1
2
3
4
5
6
7
8
9
需要通过静态和动态两个维度对内存进行考核：

静态: 各类内存占用比例，是否有某种类的内存占用了节点总内存的绝大部分
动态: 各类内存增长特性，如增长速度，或是否长期增长而不回收(atom除外)
atom
atom不会被GC。

在编写代码时，尽量避免动态生成atom，因为一旦你的输入源不可靠或受到攻击(特别针对网络消息)，atom内存增长可能导致节点crash。

可以考虑将atom生成函数替换为更安全的版本：

	list_to_atom/1 -> list_to_existing_atom/1
	binary_to_atom/2 -> binary_to_existing_atom/2
	binary_to_term(Bin) -> binary_to_term(Bin,[safe])

ets
ets内存占用过高，可能是因为表过大，或者动态生成了太多的ets表。

通过

	ets:i().

查看ets表条目数，大小，占用内存等。

binary
erlang binary大致上分为两种，heap binary(<=64字节)和refc binary(>64字节)，分别位于进程堆和全局堆上，进程通过ProBin持有refc binary的引用，当refc binary引用计数为0时，被GC。
recon提供的关于binary问题检测的函数有：

	% 打印出引用的refc binary内存最高的N个进程
	recon:proc_count(binary_memory, N)
	% 对所有进程执行GC 打印出GC前后ProcBin个数减少数量最多的N个进程
	recon:bin_leak(N)

以上两个函数，通常可以找出有问题的进程，然后针对进程的业务逻辑和上下文进行优化。通常来说，针对于refc binary，有如下思路：

每过一段时间手动GC(高效，不优雅)
如果只持有大binary中的一小段，用binary:copy/1-2(减少refc binary引用)
将涉及大binary的工作移到临时一次性进程中，做完工作就死亡(变相的手动GC)
对非活动进程使用hibernate调用(该调用将进程挂起，执行GC并清空调用栈，在收到消息时再唤醒)
一种典型地binary泄露情形发生在当一个生命周期很长的中间件当作控制和传递大型refc binary消息的请求控制器或消息路由器时，因为ProcBin仅仅只是个引用，因此它们成本很低而且在中间件进程中需要花很长的时间去触发GC，所以即使除了中间件其他所有进程都已经GC了某个refc binary对应的ProcBin，该refc binary也需要保留在共享堆里。因此中间件进程成为了主要的泄漏源。

针对这种情况，有如下解决方案：

避免中间件接触到refc binary，由中间件进程返回目标进程的Pid，由原始调用者来进行binary转发
调整中间件进程的GC频率(fullsweep_after)
driver/nif
另一部分非Erlang虚拟机管制的内存通常来自于第三方Driver或NIF，要确认是否是这部分内存出了问题，可通过

recon_alloc:memory(allocated).

和OS所报告的内存占用进行对比，可以大概得到C Driver或NIF分配的内存，再根据该部分内存的增长情况和占用比例来判断是否出现问题。

如果是纯C，那么内存使用应该是相对稳定并且可预估的，如果还挂接了Lua这类动态语言，调试起来要麻烦一些，在我们的服务器中，Lua部分是无状态的，可以直接重新加载Lua虚拟机。其它的调试手段，则要透过Lua层面的GC机制去解决问题了。

process
进程内存占用过高可能是因为进程数量过大或者进程占用内存过高，通过打印占用内存最高的几个进程来检查：

	recon:proc_count(memory, 10). % 打印占用内存最高的10个进程
	recon:proc_count(message_queue_len, 10). % 打印消息队列最长的10个进程

或者可以通过etop的方式：

spawn(fun() -> etop:start([{output, text}, {interval, 1}, {lines, 20}, {sort, memory}]) end).

使用

etop:stop().

停止打印。

3.打印高内存占用的进程信息
	erlang:process_info(pid(0,1234,0)).  # 单位是word，64位机器*8才是byte
	erlang:process_info(pid(0,1234,0), memory). # 单位是byte

4. 尝试手动gc
	erlang:garbage_collect(pid(0,1234,0)).
1
5.看代码吧
gc玩没什么变化的话，估计是代码出了问题，看看是不是哪里用了不推荐使用的实现方式。

是否陷入非尾递归的死循环？

进程的主循环是否没用尾递归，导致调用栈无限增长？

是否存入过多不必要的数据到进程字典中且没有及时erase？

gen_server的state中是否存入过多内容？
————————————————
版权声明：本文为CSDN博主「zuimrs」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/zuimrs/article/details/104848260

首先使用erlang:memory()确定是哪个部分内存吃紧，根据输出的内容，比对内存占用大小，有针对性地进行分析。在erlang系统里内存的单位为word，通过erlang:system_info(wordsize)接口可以看到一个word占用多少个字节。如32位系统是4字节，64位系统是8字节。

```
`> memory().                  ``[{total,13079568},`` ``{processes,4214248},`` ``{processes_used,4213320},`` ``{system,8865320},`` ``{atom,202481},`` ``{atom_used,189725},`` ``{binary,52800},`` ``{code,4618749},`` ``{ets,263848}]`
```

1.进程占用过多内存的情况（processes值较大）

可用etop查找内存占用高的进程，也可以排序所有进程（erlang:processes/0可获得所有进程pid）的内存占用（erlang:process_info(Pid, heap_size)可获得进程内存占用）。

找到目标进程后分析该进程的信息process_info(Pid)进一步发现问题，通常找到目标进程，就能从代码和进程状态中分析出问题。可能的问题有：

   是否陷入非尾递归的死循环？（如果一直吃CPU不吃内存则可能是尾递归的死循环导致）

   进程的主循环是否没用尾递归，导致调用栈无限增长？

   是否存入过多不必要的数据到进程字典中且没有及时erase？

   gen_server的state中是否存入过多内容？

etop memory示例：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
> spawn(fun() -> etop:start([{sort, memory}]) end).
<0.34.0>
   
========================================================================================
 nonode@nohost                                                             11:50:35
 Load:  cpu         0               Memory:  total       12642    binary         29
        procs      28                        processes    4076    code         4454
        runq        0                        atom          198    ets           256
   
Pid            Name or Initial Func    Time    Reds  Memory    MsgQ Current Function
----------------------------------------------------------------------------------------
<0.7.0>        application_controll     '-'    7270  426440       0 gen_server:loop/6   
<0.12.0>       code_server              '-'   98774  142688       0 code_server:loop/1  
<0.26.0>       erlang:apply/2           '-'    9840  122072       0 shell:get_command1/5
<0.3.0>        erl_prim_loader          '-'  181804   62856       0 erl_prim_loader:loop
<0.23.0>       user_drv                 '-'    4122   26496       0 user_drv:server_loop
<0.0.0>        init                     '-'    2347   24520       0 init:loop/1         
<0.32.0>       erlang:apply/2           '-'    1668   21424       0 shell:eval_loop/3   
<0.11.0>       kernel_sup               '-'    1543   12152       0 gen_server:loop/6   
<0.25.0>       group:server/3           '-'    1613   11864       0 group:more_data/5   
<0.6.0>        error_logger             '-'     227    6904       0 gen_event:fetch_msg/
========================================================================================
>etop:stop().
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

2.ets表占用过多内存的情况（ets值较大）

  排序所有ets表（ets:all/0可获得所有ets表名Tab）的内存占用（ets:info(Tab, memory)可获得内存占用），找出最占内存的ets表进行分析。ets表过大，是因为insert过多内容，却很少delete。分析表的功能，寻求恰当的方式做优化，节源开流。

ets表内存战斗排序示例：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
> lists:sublist(lists:reverse(lists:keysort(2,[{T, ets:info(T, memory)} || T <- ets:all()])), 10).
[{1,11220},
 {4098,7022},
 {ac_tab,942},
 {inet_db,497},
 {global_locks,302},
 {global_names,302},
 {global_names_ext,302},
 {global_pid_names,302},
 {global_pid_ids,302},
 {inet_cache,302}]
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

一些优化的思路：

   定期将不常用数据清理出内存

   选择更优的数据结构（如选择binary存字符串，而不是list）

   优化掉冗余的数据（如相同数据拷贝多份的情况，可以优化成只保存一份数据

