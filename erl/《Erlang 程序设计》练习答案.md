《Erlang 程序设计》练习答案

《Erlang 程序设计》练习答案 -- 第三章 基本概念

% (1).快速浏览 3.13 节，然后测试并记忆这些行编辑命令

在 Erlang shell 中输入

    Ctrl + A  行首
    Ctrl + D  删除当前字符
    Ctrl + E  行尾
    Ctrl + F或右箭头  向前的字符（类似跨越一个单词）
    Ctrl + B或左箭头  向后的字符
    Ctrl + P或上箭头  前一行
    Ctrl + N或下箭头  下一行
    Ctrl + T  调换最近两个字符的位置
    Ctrl + Tab  尝试扩展当前模块或函数的名称（补全）

% (2).在 shell 里输入 help() 命令。你将会看到一长串命令。
% 可以试一试其中一些命令。 

    1> help().
    ** shell internal commands **
    b()-- display all variable bindings
    e(N)   -- repeat the expression in query <N>
    f()-- forget all variable bindings
    f(X)   -- forget the binding of variable X
    h()-- history
    history(N) -- set how many previous commands to keep
    results(N) -- set how many previous command results to keep
    catch_exception(B) -- how exceptions are handled
    v(N)   -- use the value of query <N>
    rd(R,D)-- define a record
    rf()   -- remove all record information
    rf(R)  -- remove record information about R
    rl()   -- display all record information
    rl(R)  -- display record information about R
    rp(Term)   -- display Term using the shell's record information
    rr(File)   -- read record information from File (wildcards allowed)
    rr(F,R)-- read selected record information from file(s)
    rr(F,R,O)  -- read selected record information with options
    ** commands in module c **
    bt(Pid)-- stack backtrace for a process
    c(File)-- compile and load code in <File>
    cd(Dir)-- change working directory
    flush()-- flush any messages sent to the shell
    help() -- help info
    i()-- information about the system
    ni()   -- information about the networked system
    i(X,Y,Z)   -- information about pid <X,Y,Z>
    l(Module)  -- load or reload module
    lc([File]) -- compile a list of Erlang modules
    ls()   -- list files in the current directory
    ls(Dir)-- list files in directory <Dir>
    m()-- which modules are loaded
    m(Mod) -- information about module <Mod>
    memory()   -- memory allocation information
    memory(T)  -- memory allocation information of type <T>
    nc(File)   -- compile and load code in <File> on all nodes
    nl(Module) -- load module on all nodes
    pid(X,Y,Z) -- convert X,Y,Z to a Pid
    pwd()  -- print working directory
    q()-- quit - shorthand for init:stop()
    regs() -- information about registered processes
    nregs()-- information about all registered processes
    uptime()   -- print node uptime
    xm(M)  -- cross reference check a module
    y(File)-- generate a Yecc parser
    ** commands in module i (interpreter interface) **
    ih()   -- print help for the i module

----------



% (3).试着用一个元祖来表示一座房子，

% 再用一个贩子列表来表示一条街道。

% 请确保你能向这些结构中加入数据结构或从中取出数据。
    
    1> BigHouse = {bigHouse, piano, cat, dog}.
    {bigHouse,piano,cat,dog}
    2> SmallHouse = {smallHouse, tortoise}.
    {smallHouse,tortoise}
    3> Street = {street, BigHouse, SmallHouse}.
    {street,{bigHouse,piano,cat,dog},{smallHouse,tortoise}}
    4> {street, B, S} = Street. 
    {street,{bigHouse,piano,cat,dog},{smallHouse,tortoise}}
    5> B.
    {bigHouse,piano,cat,dog}
    6> S.
    {smallHouse,tortoise}
    7> 


例子

结果

atom_to_list(hello).

"hello"

list_to_atom("hello").

hello

binary_to_list(<<"hello">>).

"hello"

binary_to_list(<<104,101,108,108,111>>).

"hello"

list_to_binary("hello").

<<104,101,108,108,111>>

float_to_list(7.0).

"7.00000000000000000000e+00"

list_to_float("7.000e+00").

7.0

integer_to_list(77).

"77"

list_to_integer("77").

77

tuple_to_list({a,b,c}).

[a,b,c]

list_to_tuple([a,b,c]).

{a,b,c}

term_to_binary({a,b,c}).

<<131,104,3,100,0,1,97,100,0,1,98,100,0,1,99>>

binary_to_term(<<131,104,3,100,0,1,97,
100,0,1,98,100,0,1,99>>).

{a,b,c}