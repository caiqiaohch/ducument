# [[Erlang 0031\] Erlang Shell中的输出完整数据](https://www.cnblogs.com/me-sa/archive/2012/01/10/erlang0031.html)

前两天群里面有人问shell里面长数据被省略为 [...]|...],如何查看被省略的部分,他是在调用os:getenv()的时候遇到的这个问题,咱们前面也遇到过类似的问题,比如[ string:tokens(binary_to_list(erlang:system_info(info)),"\n").](http://www.cnblogs.com/me-sa/archive/2012/01/04/erlang0028.html)

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
Eshell V5.9  (abort with ^G)1>  string:tokens( binary_to_list(erlang:system_info(info)),"\n").["=memory","total: 4331920","processes: 438877","processes_used: 438862","system: 3893043","atom: 146321","atom_used: 119102","binary: 327936","code: 1929551","ets: 123308","=hash_table:atom_tab","size: 4813","used: 3508","objs: 6410","depth: 7","=index_table:atom_tab","size: 7168","limit: 1048576","entries: 6410","=hash_table:module_code","size: 97","used: 52","objs: 72","depth: 4","=index_table:module_code","size: 1024","limit: 65536","entries: 72",[...]|...]
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

当时我在群里面给了一个不标准的解决方法:binary_to_list(list_to_binary(os:getenv())).这个很野的路子是以前调试代码的时候偶尔发现的;


标准的解决方案是使用shell中的rp方法格式化输出结果 比如 rp(os:getenv()).特此修正,抱歉

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
9> L=lists:seq(1,100).[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29|...]10> rp(L).[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]ok11>
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

有必要了解一下shell中提供的方法:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
Eshell V5.9  (abort with ^G)1> help().** shell internal commands **b()        -- display all variable bindingse(N)       -- repeat the expression in query <N>f()        -- forget all variable bindingsf(X)       -- forget the binding of variable Xh()        -- historyhistory(N) -- set how many previous commands to keepresults(N) -- set how many previous command results to keepcatch_exception(B) -- how exceptions are handledv(N)       -- use the value of query <N>rd(R,D)    -- define a recordrf()       -- remove all record informationrf(R)      -- remove record information about Rrl()       -- display all record informationrl(R)      -- display record information about Rrp(Term)   -- display Term using the shell's record informationrr(File)   -- read record information from File (wildcards allowed)rr(F,R)    -- read selected record information from file(s)rr(F,R,O)  -- read selected record information with options** commands in module c **bt(Pid)    -- stack backtrace for a processc(File)    -- compile and load code in <File>cd(Dir)    -- change working directoryflush()    -- flush any messages sent to the shellhelp()     -- help infoi()        -- information about the systemni()       -- information about the networked systemi(X,Y,Z)   -- information about pid <X,Y,Z>l(Module)  -- load or reload modulelc([File]) -- compile a list of Erlang modulesls()       -- list files in the current directoryls(Dir)    -- list files in directory <Dir>m()        -- which modules are loadedm(Mod)     -- information about module <Mod>memory()   -- memory allocation informationmemory(T)  -- memory allocation information of type <T>nc(File)   -- compile and load code in <File> on all nodesnl(Module) -- load module on all nodespid(X,Y,Z) -- convert X,Y,Z to a Pidpwd()      -- print working directoryq()        -- quit - shorthand for init:stop()regs()     -- information about registered processesnregs()    -- information about all registered processesxm(M)      -- cross reference check a moduley(File)    -- generate a Yecc parser** commands in module i (interpreter interface) **ih()       -- print help for the i moduletrue2>
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)


这些方法的内部实现为:

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
bi(I)           -> c:bi(I).bt(Pid)          -> c:bt(Pid).c(File)      -> c:c(File).c(File, Opt)    -> c:c(File, Opt).cd(D)           -> c:cd(D).erlangrc(X)      -> c:erlangrc(X).flush()         -> c:flush().i()           -> c:i().i(X,Y,Z)      -> c:i(X,Y,Z).l(Mod)            -> c:l(Mod).lc(X)            -> c:lc(X).ls()            -> c:ls().ls(S)           -> c:ls(S).m()           -> c:m().m(Mod)           -> c:m(Mod).memory()        -> c:memory().memory(Type)    -> c:memory(Type).nc(X)          -> c:nc(X).ni()            -> c:ni().nl(Mod)      -> c:nl(Mod).nregs()         -> c:nregs().pid(X,Y,Z)      -> c:pid(X,Y,Z).pwd()           -> c:pwd().q()          -> c:q().regs()          -> c:regs().xm(Mod)         -> c:xm(Mod).y(File)         -> c:y(File).y(File, Opts)   -> c:y(File, Opts).
```