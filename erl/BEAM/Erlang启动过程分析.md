# [Erlang启动过程分析](https://www.cnblogs.com/zhengsyao/archive/2012/08/15/Erlang-otp_start_up.html)

本文从源代码出发简单地分析从在控制台输入erl按下回车到init完成启动步骤的过程。本文分析的环境为Unix环境，Erlang/OTP版本为R15B01，针对的虚拟机为SMP风格的虚拟机（也就是在代码中定义ERTS_SMP宏）。

# Erlang虚拟机的启动

erl实际上是一个shell脚本，设置几个环境变量之后，调用执行erlexec。erlexec的入口点在 otp_src_R15B01/erts/etc/common/erlexec.c 文件。erlexec的main函数首先分析erl传入的参数和环境变量，选择正确版本的beam可执行文件，然后将传入的参数整理好，加入一些默认参数，最后通过系统调用execv运行beam虚拟机。例如在smp环境中，运行的就是 beam.smp 版本的虚拟机。因此，erl和erlexec都是加载器，最终执行的Erlang虚拟机进程是名字为beam系列的进程。

 

beam进程的入口点在 otp_src_R15B01/erts/emulator/sys/unix/erl_main.c 。在这个文件中，main函数只有一行：

```
1 erl_start(argc, argv);
```

通过erl_start这个函数真正进入Erlang虚拟机的世界了。erl_start函数位于 otp_src_R15B01/erts/emulator/beam/erl_init.c 文件，Erlang虚拟机初始化相关的代码基本上都在这个文件中。这个函数大约600行，但是结构简单，大部分代码都是在处理参数。把erl_start的主干理出来，就是这样的：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 void erl_start(int argc, char **argv)
 2 {
 3     early_init(&argc, argv);
 4     处理各种参数
 5     设置信号处理函数
 6     erl_init(ncpu);
 7     init_shared_memory(boot_argc, boot_argv);
 8     load_preloaded();
 9     erts_initialized = 1;
10     erl_first_process_otp("otp_ring0", NULL, 0, boot_argc, boot_argv);
11     erts_start_schedulers();
12     erts_sys_main_thread(); 
13 }
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

early_init()函数进行一些非常底层的初始化工作。erl_init()处理一些和Erlang虚拟机本身的初始化操作，例如各种数据结构的初始化。init_shared_memory()进行一些和内存回收相关的初始化。

load_preloaded()函数将需要预加载的Erlang模块加载至虚拟机。需要预加载的模块都在 otp_src_R15B01/erts/preloaded/ebin 目录下。由于在build Erlang/OTP的时候，本地应该还没有Erlang编译器，所以这个目录下提供的都是编译好的.beam文件。这些模块的源码位于otp_src_R15B01/erts/preloaded/src 目录。预加载模块在build的时候由工具程序 make_preload 生成C语言文件硬编码在虚拟机中了。如果想要修改预加载的文件，例如在里面加上 erlang:display() 表达式打印调试信息，可以修改src中的文件，然后通过编译器erlc生成.beam文件保存在 otp_src_R15B01/erts/preloaded/ebin目录下覆盖原来的文件，再build即可。

在预加载的文件夹中可以看到，预加载的有以下模块：

- erl_prim_loader：主要加载器，负责所有模块的加载
- erlang：对虚拟机提供的一些BIF的接口
- init：init进程的代码
- otp_ring0：Erlang虚拟机中第一个进程的代码，启动init
- prim_file：文件操作接口
- prim_inet：网络操作接口
- prim_zip：压缩文件操作接口
- zlib：zlib库

 把这些必要模块都加载至虚拟机之后，通过erl_first_process_otp()函数创建了Erlang虚拟机上的第一个进程，调用 otp_ring0 模块中的start/2函数。start/2 函数运行init模块的 boot/1 函数，之后开始Erlang/OTP系统的引导过程。这里先把虚拟机的启动过程分析完再讲述Erlang/OTP的引导过程。

创建了第一个进程之后，进程还不能运行，因为还没有创建调度器。erts_start_schedulers()根据CPU的核心数和用户通过参数设置的数值启动某个数目的调度器线程。每一个调度器都在一个线程中运行。调度器挑选要执行的进程，然后执行进程，当进程的reds用完或进程等待IO挂起的时候再挑选另一个进程执行。以后再撰文详细分析Erlang调度器的工作原理。运行了erts_start_schedulers()函数之后Erlang虚拟机才真正运转起来。

启动调度器之后，调用erts_sys_main_thread()函数，也就是说beam进程的主线程进入了erts_sys_main_thread()函数。下面简单分析一下erts_sys_main_thread()函数。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
1 void erts_sys_main_thread(void)
2 {
3     erts_thread_disable_fpe();
4     smp_sig_notify(0); /* Notify initialized */
5     while (1) {
6         /* Wait for a signal to arrive... */
7         select(0, NULL, NULL, NULL, NULL);
8     }
9 }
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

这个函数很简单，屏蔽浮点数异常、通知信号处理线程已经完成了初始化，然后进入一个死循环等待信号。这个select调用表示永远等待文件IO操作，但是什么文件也不等，只是把线程挂起。但是这个函数在收到信号的时候会返回。这里顺便提一下Erlang虚拟机中的信号处理。在之前初始化的时候，设置了信号处理函数，也就是通过函数 init_break_handler() 设置了一些信号的处理函数。这些信号处理函数收到了信号之后实际上将信号通过管道转发给了一个专门处理信号的线程，之前在调用 early_init() 的时候创建了这个线程，这个信号处理线程运行的函数是 signal_dispatcher_thread_func()，这个函数是一个死循环，等待从管道中读取值。虚拟机的主线程通过 smp_sig_notify() 函数将通知消息写入管道发给信号处理线程。

从Erlang虚拟机处理信号的方式可以看出，这种处理方式也是Erlang提倡的进程间通信方式。

下面分析otp_ring0的start/2调用init的boot/1引导Erlang/OTP系统的过程。

# init进程的引导过程

init:boot/1的代码如下：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
1 boot(BootArgs) ->
2     register(init, self()),
3     process_flag(trap_exit, true),
4     start_on_load_handler_process(),
5     {Start0,Flags,Args} = parse_boot_args(BootArgs),
6     Start = map(fun prepare_run_args/1, Start0),
7     Flags0 = flags_to_atoms_again(Flags),
8     boot(Start,Flags0,Args).
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

第2行将当前进程注册为init，于是我们就有了init进程。第4行启动了一个新的进程ON_LOAD_HANDLER，这个进程处理一些和加载相关的事件。然后对传入的参数做一些处理，Start是erl -s参数传入的要运行的MFA列表，Flags0是调用erl传入的一些标志，Args是erl -extra 传入的一些额外参数。接下来这些参数传入boot/3。下面是boot/3的代码：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
1 boot(Start,Flags,Args) ->
2     BootPid = do_boot(Flags,Start),
3     State = #state{flags = Flags,
4            args = Args,
5            start = Start,
6            bootpid = BootPid},
7     boot_loop(BootPid,State).
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

boot/3调用do_boot/2，设置State，然后就进入boot_loop/2循环。下面是do_boot/2的代码：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 do_boot(Flags,Start) ->
 2     Self = self(),
 3     spawn_link(fun() -> do_boot(Self,Flags,Start) end).
 4 
 5 do_boot(Init,Flags,Start) ->
 6     process_flag(trap_exit,true),
 7     {Pgm0,Nodes,Id,Path} = prim_load_flags(Flags),
 8     Root = b2s(get_flag('-root',Flags)),
 9     PathFls = path_flags(Flags),
10     Pgm = b2s(Pgm0),
11     _Pid = start_prim_loader(Init,b2a(Id),Pgm,bs2as(Nodes),
12                              bs2ss(Path),PathFls),
13     BootFile = bootfile(Flags,Root),
14     BootList = get_boot(BootFile,Root),
15     LoadMode = b2a(get_flag('-mode',Flags,false)),
16     Deb = b2a(get_flag('-init_debug',Flags,false)),
17     catch ?ON_LOAD_HANDLER ! {init_debug_flag,Deb},
18     BootVars = get_flag_args('-boot_var',Flags),
19     ParallelLoad = 
20         (Pgm =:= "efile") and (erlang:system_info(thread_pool_size) > 0),
21 
22     PathChoice = code_path_choice(),
23     eval_script(BootList,Init,PathFls,{Root,BootVars},Path,
24                 {true,LoadMode,ParallelLoad},Deb,PathChoice),
25 
26     %% To help identifying Purify windows that pop up,
27     %% print the node name into the Purify log.
28     (catch erlang:system_info({purify, "Node: " ++ atom_to_list(node())})),
29 
30     start_em(Start).
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

do_boot/2创建了一个负责引导过程的进程（do_boot/3，没有register，让我们称为do_boot），boot/2最后进入了一个boot_loop循环，接受来自do_boot进程的消息。现在系统上有3个进程，如下图所示：

![img](https://pic002.cnblogs.com/images/2012/414649/2012081520300491.png)

 此时的<0.0.0>在boot_loop循环等待接受<0.2.0>发出的和boot相关的消息，<0.1.0>在等待接收和加载相关的消息。下面看do_boot/3的引导过程。第7-10行从传入的参数中获得加载器相关的参数，然后在第11行调用函数start_prim_loader通过erl_prim_loader模块的start/3函数创建了加载器进程。第13-14行从启动脚本中获得启动指令列表。有关启动脚本的格式参见文档 erl -man script ，启动脚本描述了Erlang运行时系统启动的过程，包含了启动过程要执行的一系列指令。如果启动erl的时候没有带-boot Name参数，那么默认使用start.boot启动脚本。start.boot是由start.script生成的。start.script内容摘要如下所示：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 {script,
 2     {"OTP  APN 181 01","R15B01"},
 3     [{preLoaded,
 4          [erl_prim_loader,erlang,init,otp_ring0,prim_file,prim_inet,prim_zip,zlib]},
 5      {progress,preloaded},
 6      {path,["$ROOT/lib/kernel/ebin","$ROOT/lib/stdlib/ebin"]},
 7      {primLoad,[error_handler]},
 8      {kernel_load_completed},
 9      {progress,kernel_load_completed},
10      {path,["$ROOT/lib/kernel/ebin"]},
11      {primLoad,
12          [application,application_controller,application_master,
13           ...
14           standard_error,user,user_drv,user_sup,wrap_log_reader]},
15      {path,["$ROOT/lib/stdlib/ebin"]},
16      {primLoad,
17          [array,base64,beam_lib,binary,c,calendar,dets,dets_server,dets_sup,
18           ...
19           supervisor_bridge,sys,timer,unicode,win32reg,zip]},
20      {progress,modules_loaded},
21      {path,["$ROOT/lib/kernel/ebin","$ROOT/lib/stdlib/ebin"]},
22      {kernelProcess,heart,{heart,start,[]}},
23      {kernelProcess,error_logger,{error_logger,start_link,[]}},
24      {kernelProcess,application_controller,
25          {application_controller,start,
26              [{application,kernel,
27                   ...}]}},
28      {progress,init_kernel_started},
29      {apply,
30          {application,load,
31              [{application,stdlib,
32                   ...}]}},
33      {progress,applications_loaded},
34      {apply,{application,start_boot,[kernel,permanent]}},
35      {apply,{application,start_boot,[stdlib,permanent]}},
36      {apply,{c,erlangrc,[]}},
37      {progress,started}]}.
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

do_boot/3中的BootFile就是这个文件，BootList就是从第3行开始的这个列表。列表中的每一项表示一个动作，这些动作包括preLoaded、progress、path、primLoad、kernelProcess和apply，这些动作在erl -man script文档中有详细的解释。do_boot/3的第23行调用eval_script/8函数负责执行这个列表中的每一个动作。下面是eval_script/8的代码节选：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 eval_script([{progress,Info}|CfgL],Init,PathFs,Vars,P,Ph,Deb,PathChoice) ->
 2     debug(Deb,{progress,Info}),
 3     init ! {self(),progress,Info},
 4     eval_script(CfgL,Init,PathFs,Vars,P,Ph,Deb,PathChoice);
 5 eval_script([{preLoaded,_}|CfgL],Init,PathFs,Vars,P,Ph,Deb,PathChoice) ->
 6     eval_script(CfgL,Init,PathFs,Vars,P,Ph,Deb,PathChoice);
 7 eval_script([{path,Path}|CfgL],Init,{Pa,Pz},Vars,false,Ph,Deb,PathChoice) ->
 8     ...
 9     eval_script(CfgL,Init,{Pa,Pz},Vars,false,Ph,Deb,PathChoice);
10 eval_script([{path,_}|CfgL],Init,PathFs,Vars,P,Ph,Deb,PathChoice) ->
11     eval_script(CfgL,Init,PathFs,Vars,P,Ph,Deb,PathChoice);
12 eval_script([{kernel_load_completed}|CfgL],Init,PathFs,Vars,P,{_,embedded,Par},Deb,PathChoice) ->
13     eval_script(CfgL,Init,PathFs,Vars,P,{true,embedded,Par},Deb,PathChoice);
14 eval_script([{kernel_load_completed}|CfgL],Init,PathFs,Vars,P,{_,E,Par},Deb,PathChoice) ->
15     eval_script(CfgL,Init,PathFs,Vars,P,{false,E,Par},Deb,PathChoice);
16 eval_script([{primLoad,Mods}|CfgL],Init,PathFs,Vars,P,{true,E,Par},Deb,PathChoice)
17     ...
18     eval_script(CfgL,Init,PathFs,Vars,P,{true,E,Par},Deb,PathChoice);
19 eval_script([{primLoad,_Mods}|CfgL],Init,PathFs,Vars,P,{false,E,Par},Deb,PathChoice) ->
20     eval_script(CfgL,Init,PathFs,Vars,P,{false,E,Par},Deb,PathChoice);
21 eval_script([{kernelProcess,Server,{Mod,Fun,Args}}|CfgL],Init,
22             PathFs,Vars,P,Ph,Deb,PathChoice) ->
23     start_in_kernel(Server,Mod,Fun,Args,Init),
24     eval_script(CfgL,Init,PathFs,Vars,P,Ph,Deb,PathChoice);
25 eval_script([{apply,{Mod,Fun,Args}}|CfgL],Init,PathFs,Vars,P,Ph,Deb,PathChoice) ->
26     ...
27     eval_script(CfgL,Init,PathFs,Vars,P,Ph,Deb,PathChoice);
28 eval_script([],_,_,_,_,_,_,_) ->
29     ok;
30 eval_script(What,_,_,_,_,_,_,_) ->
31     exit({'unexpected command in bootfile',What}).
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

eval_script/8对BootList中的每一个动作进行处理。有一些动作要给init进程发送消息，init进程的boot_loop/2循环接收这些消息。boot_loop/2接收的消息中有以下两个：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 boot_loop(BootPid, State) ->
 2     receive
 3         {BootPid,progress,started} ->
 4             {InS,_} = State#state.status,
 5             notify(State#state.subscribed),
 6             boot_loop(BootPid,State#state{status = {InS,started},
 7                                           subscribed = []});
 8         ......
 9         {'EXIT',BootPid,normal} ->
10             {_,PS} = State#state.status,
11             notify(State#state.subscribed),
12             loop(State#state{status = {started,PS},
13                              subscribed = []});
14         ......
15     end.
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

BootList最后一条指令是{progress,started}，对应了boot_loop/2第3行的消息，在执行完这一条指令之后，eval_script/8结束了执行，因此do_boot/3在结束eval_script/8之后调用start_em/1之后就正常退出了，进程<0.2.0>正常退出，boot_loop/2收到'EXIT'消息，init进程进入loop/1循环。此时，init作为初始化的任务已经完成。这一个默认的启动脚本启动了两个应用程序，kernel和STDLIB，前者是一个普通应用程序，后者只是一个库应用程序。如果erl没有传入-noshell参数，kernel还会启动shell和用户交互。这两个应用程序是Erlang最简系统的基础，前者提供了必要的系统服务，例如文件服务、网络服务和错误日志记录服务等，后者提供了编写程序需要使用的各种工具、数据结构以及OTP相关的重要模块。

# 小结 

通过本文的分析可以看出，Erlang虚拟机很像一个运行了操作系统的计算机。erl对应的是BIOS，加载对应bootloader的erlexec。erlexec加载BEAM虚拟机，BEAM虚拟机对应了操作系统。接下来BEAM进行初步的初始化，初始化执行环境，对应了操作系统的初始化。初始化完成之后，BEAM像Linux一样加载系统中的第一个进程init。init进程读取启动列表，执行启动系统的步骤。执行完这些步骤之后，Erlang成为了一个完全完成了初始化过程可以运行的系统。Erlang像操作系统一样，有自己的调度系统，内存管理系统，还有和外界交互的I/O系统。只不过内存管理系统更加的智能，可以主动帮助进程进行垃圾回收。I/O系统以系统服务的方式存在，通过Erlang消息通信的方式向其他进程提供服务，因此Erlang的进程只需要通过消息这一种语义就能和外界交换数据。Erlang中的模块就好像操作系统中的动态共享库，只要加载到系统中，就可以供所有的进程访问。多个模块可以组织为应用程序。Erlang的模块命名是平坦的，因此不同应用程序中的模块不能重名。Erlang的应用程序是对模块和进程的一种组织方式，从一个应用程序可以包含一组进程的角度看，Erlang的应用程序有点类似于Linux系统中的进程。