erlang:abs/1
返回一个数字的绝对值

用法：

abs(Number) -> integer() | float()
返回一个数字 Number 的绝对值

abs(-3.33).
abs(-3).

----------
erlang:adler32/1
计算并返回一个数据的 Adler-32 校验值

用法：

adler32(Data) -> integer()
计算并返回一个数据 Data 的 Adler-32 校验值

erlang:adler32([]).
erlang:adler32([1, "a"]).
erlang:adler32("test").
Data = [>, "81", >, >,
    [[50,48,49,48,49,48,50,54,45,49,53,":",52,53,":",52,52]],
    >, >, [>,>,>], [>,>,>]
],
erlang:adler32(Data).

----------
erlang:adler32/2
计算并返回一个数据的 Adler-32 校验值

用法：

adler32(OldAdler, Data) -> integer()
用一个由函数 erlang:adler32/1 生成的旧的 Adler-32 校验值 OldAdler 跟一个数据 Data 组合起来计算，并返回一个新的 Adler-32 校验值。

Adler32 = erlang:adler32([1, "a"]),
erlang:adler32(Adler32, [3, 4]).
Adler32 = erlang:adler32([1, "a"]),
Data = [>, "81", >, >,
    [[50,48,49,48,49,48,50,54,45,49,53,":",52,53,":",52,52]],
    >, >, [>,>,>], [>,>,>]
],
erlang:adler32(Adler32, Data).

----------
erlang:adler32_combine/3
组合两个 Adler-32 效验值

用法：

adler32_combine(FirstAdler, SecondAdler, SecondSize) -> integer()
组合两个由函数 erlang:adler32/1 或 erlang:adler32/2 生成的 Adler-32 效验值，并返回一个新的 Adler-32 效验值，参数 SecondSize 是第二个效验值数据的长度。

Data1 = [1],
FirstAdler = erlang:adler32(Data1),
Data2 = ["a"],
SecondAdler = erlang:adler32(Data2), 
erlang:adler32_combine(FirstAdler, SecondAdler, iolist_size(Data2)). 
等同于使用 erlang:adler32/2：

Data1 = [1],
Adler = erlang:adler32(Data1),
Data2 = ["a"],
erlang:adler32(Adler, Data2).

----------
erlang:append_element/2
向元组添加一个额外的元素

用法：

append_element(Tuple1, Term) -> Tuple2
向元组 Tuple1 后面添加一个额外的元素 Term

erlang:append_element({one, two}, three).

----------
erlang:apply/2
用参数调用函数

用法：

apply(Fun, Args) -> term()
调用一个函数，把 Args 里的元素作为函数的参数。

erlang:apply({erlang, atom_to_list}, [abc]).
Fun = fun(P) -> 2 * P end, 
erlang:apply(Fun, [1]).

----------
erlang:apply/3
用参数调用模块的函数

用法：

apply(Module, Function, Args) -> term()
用参数 Args 调用模块 Module 的函数 Function

erlang:apply(math, sqrt, [4]).
erlang:apply(lists, reverse, [[a, b, c]]).
erlang:apply(erlang, atom_to_list, ['Erlang']).

----------
erlang:atom_to_binary/2
返回一个原子的二进制表示形式

用法：

atom_to_binary(Atom, Encoding) -> binary()
返回一个原子 Atom 的二进制表示形式，参数 Encoding 表示转换的编码，可选的编码有：latin1、utf8、unicode

atom_to_binary('Erlang', utf8).

----------
erlang:atom_to_list/1
返回原子的文本表示形式

用法：

atom_to_list(Atom) -> string()
返回原子 Atom 的文本表示形式

atom_to_list('Erlang').
atom_to_list(node()).

----------
erlang:binary_part/2
提取一个二进制数据的一部分

用法：

binary_part(Subject, PosLen) -> binary()
提取一个二进制数据 Subject 的一部分，参数 PosLen 的数据结构是一个元组 {Start, Length}，Start 表示提取的开始位置，Length 表示提取的数据长度

Bin = >,
erlang:binary_part(Bin, {2, 5}).

----------
erlang:binary_part/3
提取一个二进制数据的一部分

用法：

binary_part(Subject, Start, Length) -> binary()
提取一个二进制数据 Subject 的一部分，参数 Start 表示提取的开始位置，参数 Length 表示提取的数据长度

Bin = >,
erlang:binary_part(Bin, 2, 5).

----------
erlang:binary_to_atom/2
把二进制数据转为一个原子

用法：

binary_to_atom(Binary, Encoding) -> atom()
把一个二进制数据 Binary 转为一个原子。如果 Encoding 是 latin1, 不会有二进制字节数据转换. 如果 Encoding 是 utf8 或者 unicode, 那么该二进制数据必须是包含合法的 UTF-8 序列，而且, 只有在 0xFF 之上的 Unicode 字符才被允许的.

erlang:binary_to_atom(>, latin1).

----------
erlang:binary_to_existing_atom/2
把二进制数据转为一个现有已存在的原子

用法：

binary_to_existing_atom(Binary, Encoding) -> atom()
把二进制数据 Binary 转为一个现有已存在的原子，如果原子不存在，则返回 badarg。

binary_to_existing_atom(>, latin1).

----------
erlang:binary_to_list/1
把一个二进制转为一个列表

用法：

binary_to_list(Binary) -> [char()]
返回一个跟给出的二进制字节相对应的整数列表

binary_to_list(>).

----------
erlang:binary_to_list/3
把一个二进制数据的一部分转为一个列表

用法：

binary_to_list(Binary, Start, Stop) -> [char()]
跟 binary_to_list/1 一样，也是把把一个二进制字节数据转为一个整数列表，不过 binary_to_list/1 返回的是从 Start 开始至 Stop 结束的一部分二进制数据

binary_to_list(>, 2, 4).

----------
erlang:binary_to_term/1
把二进制数据转为一个原始 erlang 数据

用法：

binary_to_term(Binary) -> term()
把二进制数据 Binary 转为一个原始 Erlang 数据

binary_to_term(term_to_binary([a, b, c])).
binary_to_term(>).

----------
erlang:binary_to_term/2
把二进制数据转为一个原始 erlang 数据

用法：

binary_to_term(Binary, Opts) -> term()
跟 erlang:binary_to_term/1 一样，都是把二进制数据转为一个原始 Erlang 数据，不过多了一个选项参数 Opts，一般参数 Opts 的值为 safe，表示如果转换中的二进制数据 Binary 不是一个合法的 Erlang 项（term）数据时，则返回 badarg。

binary_to_term(>, [safe]).
binary_to_term(>, [safe]).

----------
erlang:bit_size/1
返回一个位串的长度大小

用法：

bit_size(Bitstring) -> integer() >= 0
返回一个位串 Bitstring 的长度大小

bit_size(>).
bit_size(>).
bit_size(>).

----------
erlang:bitstring_to_list/1
把一个位串转为一个列表

用法：

bitstring_to_list(Bitstring) -> [char()|bitstring()]
返回一个跟位串字节数 Bitstring 相对应的整数列表。

bitstring_to_list(>).
如果二进制里的位数不能被 8 整除，那么列表的末尾数据将是一个包含其余剩下的位（1 至 7）的位串。

bitstring_to_list(>).

----------
erlang:bump_reductions/1
增加缩减计数器数

用法：

bump_reductions(Reductions) -> true
这个执行依赖函数会提高当前调用进程的缩减计数器（该值确定一个进程的活动等级，值越高更有利于调度，当为 0 时进程被挂起）。在 Erlang 的虚拟机里，每一个函数或 BIF 的调用都会增加缩减计数器数。当一个进程的缩减计数器数达到它的最大值（R12B 是2000）时，它的上下文环境将会被强制切换。

erlang:bump_reductions(100).

----------
erlang:byte_size/1
获取一个字节串（二进制）数据的字节长度

用法：

byte_size(Bitstring) -> integer() >= 0
获取一个字节串（或二进制） Bitstring 数据的字节长度（如果字节串不能被 8 整除，则向上取整）。

byte_size(>).
byte_size(>).

----------
erlang:cancel_timer/1
取消一个定时器

用法：

cancel_timer(TimerRef) -> Time | false
取消由 erlang:send_after/3 或 erlang:start_timer/3 生成而返回的定时器。如果一个活跃中的定时器被删除，该函数将返回到过期时间所剩余的毫秒数。如果 TimerRef 不是一个定时器（它已经被取消掉），或它已经发送了它的信息，则返回 false。

NOTE：取消定时器并不一定保证消息已经不再消息队列上。

TimerRef = erlang:send_after(5000, self(), test),
erlang:cancel_timer(TimerRef).

----------
erlang:check_old_code/1
检测模块是否含有旧代码

用法：

check_old_code(Module) -> boolean()
检测模块 Module 是否含有旧代码，如果有则返回 true，否则返回 false。

erlang:check_old_code(genfsm).

----------
erlang:check_process_code/2
检测进程的运行代码是否为旧版本

用法：

check_process_code(Pid, Module) -> boolean()
如果进程 Pid 运行着模块的旧版本代码，那么该函数则返回 true。否则（这是指进程的当前调用运行这个模块的旧代码；或是进程有这个模块旧代码的引用；或是进程里所包含的函数有对这个模块旧代码的引用），返回 false。

erlang:check_process_code(self(), genfsm).

----------
erlang:crc32/1
计算并返回一个数据的 CRC 校验值

用法：

crc32(Data) -> integer() >= 0
计算并返回一个数据 Data 的 CRC（Cyclic redundancy check：循环冗余校验） 校验值。

erlang:crc32([]).
erlang:crc32([1, "a"]).
erlang:crc32("test").
Data = [>, "81", >, >,
    [[50,48,49,48,49,48,50,54,45,49,53,":",52,53,":",52,52]],
    >, >, [>,>,>], [>,>,>]
],
erlang:crc32(Data).

----------
erlang:crc32_combine/3
组合两个 CRC 效验值

用法：

crc32_combine(FirstCrc, SecondCrc, SecondSize) -> integer() >= 0
组合两个 CRC（Cyclic redundancy check：循环冗余校验） 效验值，并返回一个新的 CRC 效验值，参数 SecondSize 是第二个效验值数据的长度。

Data1 = [1],
FirstAdler = erlang:crc32(Data1),
Data2 = ["a"],
SecondAdler = erlang:crc32(Data2), 
erlang:crc32_combine(FirstAdler, SecondAdler, iolist_size(Data2)). 

----------
erlang:date/0
返回当前日期

用法：

date() -> Date
返回一个以 {Year, Month, Day} 元组形式的当前日期。

时区和夏令时的调整校正依赖于底层操作系统。

erlang:date().

----------
erlang:decode_packet/3
从一个二进制数据里解码一个协议包

用法：

decode_packet(Type,Bin,Options) -> {ok,Packet,Rest} | {more,Length} | {error,Reason}
根据指定类型 Type 的包协议，解码一个二进制数据 Bin。很像 Socket 的包处理选项 {packet,Type}。

如果整个数据包包含在二进制数据 Bin 里，那么它将以 {ok,Packet,Rest} 的形式，跟剩余的二进制数据一起返回。

如果二进制数据并不完全包含整个数据包，那么将返回 {more,Length}。变量 Length 或是数据包的总大小，或返回 undefined（如果包的大小读取不了的话）。后来添加的更多数据可以被函数 erlang:decode_packet/2 再次调用处理。

如果数据包并不符合协议格式，那么将返回 {error,Reason}。

erlang:decode_packet(1, >, []).
erlang:decode_packet(1, >, []).

----------
erlang:delete_element/2
删除元组里的值

用法：

delete_element(Index, Tuple1) -> Tuple2
把元组 Tuple1 里第 Index 个元素删除，并返回一个新的元组 Tuple2。

erlang:delete_element(2, {1, 2, 3}).

----------
erlang:delete_module/1
将模块的当前代码标记为旧版

用法：

delete_module(Module) -> true | undefined
把模块 Module 的当前代码标记为旧版，并从导出表里删除这个模块的所有引用。如果这个模块不存在，则返回 undefined，否则返回 true。

如果模块 Mudule 已经存在了旧版本，则返回 badarg。

erlang:delete_module(genfsm).

----------
erlang:demonitor/1
取消一个监控过程

用法：

demonitor(MonitorRef) -> true
如果 MonitorRef 是当前调用进程调用了 erlang:monitor/2 函数而返回来的一个监控引用，那么该监控过程将停止。如果该监控过程已经停止，则不作任何操作。

如果 MonitorRef 是另外一个进程的监控过程，那么调用该函数由可能会返回 bagarg 的错误。

MonitorRef = erlang:monitor(process, self()),
erlang:demonitor(MonitorRef).

----------
erlang:demonitor/2
取消一个监控过程

用法：

demonitor(MonitorRef, OptionList) -> boolean()
取消一个监控过程，返回值一般是 true，除非 OptionList 里有 info 这个原子。

erlang:demonitor(MonitorRef, []) 等同于 demonitor(MonitorRef)。

当前可选的选项有：

flush：如果调用消息队列里有 {_, MonitorRef, _, _, _} 这样的消息，先删除消息，再停止监控过程。

调用 demonitor(MonitorRef, [flush]) 等同于调用以下代码，而且更高效：

demonitor(MonitorRef),
receive
    {_, MonitorRef, _, _, _} ->
        true
    after 0 ->
        true
end
info。

返回值会是以下之一：

true：监控器被找到并被删除。这个情况是监控进程上的调用消息队列没有 'DOWN' 消息。

false：监控器没有被找到并不可以被删除。这也许是调用消息队列上已经有 'DOWN' 类似的消息。

如果选项 info 跟选项 flush 组合在一起，如果需要一个清除，那么则返回 false，否则返回 true。

如果 OptionList 不是一个列表，或者选项不是一个合法的选项，那么将返回 bagarg。

MonitorRef = erlang:monitor(process, self()),
erlang:demonitor(MonitorRef, [flush]).

----------
erlang:disconnect_node/1
强制断开一个节点连接

用法：

disconnect_node(Node) -> boolean() | ignored
内部实现：

-spec disconnect_node(Node) -> boolean() | ignored when
      Node :: node().
disconnect_node(Node) ->
    net_kernel:disconnect(Node).
强制断开一个节点 Node 的连接。被断开的节点将出现类似本地节点崩溃的情形。这个内置函数（BIF）经常用于 Erlang 的网络验证协议里。

如果成功断开，则返回 true，否则返回 false。如果本地节点已经不存在，那么函数将返回 ignored。

erlang:disconnect_node(node()).

----------
erlang:display/1
在标准输出端上输出一个数据项

用法：

display(Term) -> true
在标准输出端上输出一个文本形式的数据项 Term。

erlang:display(test).

----------
erlang:element/2
获取元组里的元素

用法：

element(N, Tuple) -> term()
返回元组 Tuple 里的第 N 个元素（编号从 1 开始）。

element(2, {a, b, c}).

----------
erlang:erase/0
返回所有进程字典数据并删除之

用法：

erase() -> [{Key, Val}]
返回所有进程字典数据并删除之。

erlang:erase().

----------
erlang:erase/1
获取并清除进程字典里跟键所对应的值

用法：

erase(Key) -> Val | undefined
获取并清除进程字典里跟键 Key 所对应的值，如果进程字典里没有跟键相关联的值，则返回 undefined。

erlang:put(test, 12345),
erlang:erase(test).
erlang:erase(test).

----------
erlang:error/1
以一个给定的原因停止执行当前进程

用法：

error(Reason) -> no_return()
以一个原因 Reason 停止执行当前进程，Reason 可以是任何 Erlang 项值。退出的原因返回的格式是 {Reason, Where}，Where 是最近调用的函数的列表（第一个是当前函数）。因为模拟执行这个函数将导致进程崩溃，所以这个函数是不会有返回值。

catch error(foobar).

----------
erlang:error/2
以一个给定的原因和参数停止执行当前进程

用法：

error(Reason, Args) -> no_return()
以一个原因 Reason 停止执行当前进程，Reason 可以是任何 Erlang 项值。退出的原因返回的格式是 {Reason, Where}，Where 是最近调用的函数的列表（第一个是当前函数）。Args 有可能成为当前函数的参数列表；在 Beam 虚拟机里它将用来给在 Where 项值里的当前函数提供实际参数。因为模拟执行这个函数将导致进程崩溃，所以这个函数是不会有返回值。

erlang:error(foobar, 1).
catch error(foobar, 1).

----------
erlang:exit/1
以一个给定的原因停止执行当前进程

用法：

exit(Reason) -> no_return()
以一个原因 Reason 停止执行当前进程，Reason 可以是任何 Erlang 项值。因为模拟执行这个函数将导致进程崩溃，所以这个函数是不会有返回值。

exit(foobar).
catch exit(foobar).

----------
erlang:exit/2
对一个进程发出一条退出消息

用法：

exit(Pid, Reason) -> true
向进程 Pid 以 Reason 退出原因发出一个退出信号。

如果进程 Pid 没有捕捉退出，那么进程将会以 Reason 的退出原因退出。如果进程 Pid 有捕捉退出，退出信号将转变为 {'EXIT', From, Reason} 格式的消息投送到进程的消息队列。From 是发送退出信号的进程的 pid。

如果 Reason 是 normal，Pid 将不会退出。如果进程捕捉了退出，，退出信号将转变为 {'EXIT', From, Reason} 格式的消息投送到进程的消息队列。

如果 Reason 是 kill，那么将给进程 Pid 发送一条不可捕获的退出信号，进程接收到信号后将以 killed 的原因无条件退出。

exit(self(), normal).

----------
erlang:float/1
把一个数字转为浮点数

用法：

float(Number) -> float()
把一个数字 Number 转为浮点数

erlang:float(55).

----------
erlang:float_to_binary/1
把一个浮点数转为二进制数据

用法：

float_to_binary(Float) -> binary()
把浮点数转为一个二进制数据，小数部分使用 20 位科学计数法来格式小数数字的精度。

Pi = math:pi(),
float_to_binary(Pi).
其效用跟 erlang:float_to_binary(Float, [{scientific, 20}]) 一样，具体详看 erlang:float_to_binary/2 的用法。

Pi = math:pi(),
erlang:float_to_binary(Pi, [{scientific, 20}]).

----------
erlang:float_to_binary/2
把一个浮点数转为二进制数据

用法：

float_to_binary(Float, Options) -> binary()
返回一个浮点数的指定小数点位数格式的二进制形式，参数 Options 的参数规则用法跟 erlang:float_to_list/2 一样。

指定小数点位数是 4 位，不够则补 0：

float_to_binary(3.14, [{decimals, 4}]).
指定小数点位数是 4 位，末尾为 0 会被截除：

float_to_binary(3.14, [{decimals, 4}, compact]).
指定小数点位数是 4 位，多余位数则四舍五入截取：

Pi = math:pi(),
float_to_binary(Pi, [{decimals, 4}, compact]).
用 20 位科学计数法来格式小数数字的精度：

Pi = math:pi(),
erlang:float_to_binary(Pi, [{scientific, 20}]).

----------
erlang:float_to_list/1
返回一个浮点数的文本形式

用法：

float_to_list(Float) -> string()
把浮点数转为一个文本形式的数据，小数部分使用 20 位科学计数法来格式小数数字的精度。

Pi = math:pi(),
float_to_list(Pi).
其效用跟 erlang:float_to_list(Float, [{scientific, 20}]) 一样，具体说明详看 erlang:float_to_list/2 的用法。

用 mochiweb 的 mochinum:digits/1 函数可以准确无偏差的把浮点数转为一个文本形式。

mochinum:digits(3.141592653589793).

----------
erlang:float_to_list/2
返回一个浮点数的文本形式

用法：

float_to_list(Float, Options) -> string()
返回一个浮点数的指定小数点位数格式的文本形式。

如果指定 decimals 参数，那么返回值的小数点后的位数将包含最多 Decimals 位值的数字的数。如位值大于内部 256 个字节的静态缓冲区的容量，函数将抛出一个异常。

Pi = math:pi(),
float_to_list(Pi, [{decimals, 4}]).
如果指定 compact 参数，那么文本后面的末尾 0 字符会被截除（这个选项同时跟 decimals 参数一起用才有意义）。

float_to_binary(3.140000, [{decimals, 4}, compact]).
如果指定 scientific 参数，那么浮点数将使用科学计数法来格式小数点后的数字的精度。

Pi = math:pi(),
erlang:float_to_binary(Pi, [{scientific, 20}]).
如果参数 Options 为 []，那么其效用跟 erlang:float_to_list/1 一样。

----------
erlang:fun_to_list/1
返回一个函数的文本形式

用法：

fun_to_list(Fun) -> string()
返回一个函数 Fun 的文本形式的字符

Fun = fun(X) -> 2 * X end,
erlang:fun_to_list(Fun).
Fun = fun(X) -> 2 * X end,
L = erlang:fun_to_list(Fun),
F = erlang:list_to_fun(L),
apply(F, [2]).

----------
erlang:function_exported/3
检测一个函数是否输出并被加载

用法：

function_exported(Module, Function, Arity) -> boolean()
检测模块 Module 是否已经加载并且是否包含一个输出的函数 Function/Arity，如果是，则返回 true，否则返回 false。任何的 BIF（用 C 实现而不是 Erlang 实现的函数） 都返回 false。

erlang:function_exported(lists, dropwhile, 2).

----------
erlang:garbage_collect/0
对当前进程进行垃圾回收操作

用法：

garbage_collect() -> true
对当前被调用中的进程强制立即执行一个垃圾回收操作（不正当使用也许会严重影响系统性能）。

erlang:garbage_collect().

----------
erlang:get/0
返回进程里的所有字典值

用法：

get() -> [{Key, Val}]
以一个 {Key, Val} 元组列表的形式返回进程里的所有字典值

erlang:get().

----------
erlang:get/1
从进程字典里获取一个值

用法：

get(Key) -> Val | undefined
在进程字典里获取一个跟键 Key 相关的值 Val，如果这个键不存在，则返回 undefined。

erlang:get(test).

----------
erlang:get_cookie/0
获取本地节点的魔饼值（magic cookie）

用法：

get_cookie() -> Cookie | nocookie
内部实现：

-spec erlang:get_cookie() -> Cookie | nocookie when
      Cookie :: atom().
get_cookie() ->
    auth:get_cookie().
如果本地节点处于活动状态，则返回本地节点的魔饼值（magic cookie），否则返回一个原子 nocookie。

erlang:get_cookie().

----------
erlang:get_keys/1
从进程字典里返回一个键列表

用法：

get_keys(Val) -> [Key]
返回一个在进程字典里跟值 Val 相关联的键的列表。

erlang:get_keys(test).

----------
erlang:get_module_info/2
获取模块的指定信息

用法：

get_module_info(Module, Item) -> ModuleInfo
获取模块 Module 的指定信息，参数 Item 是指模块的信息类型。

module：模块名。

{ok, Module} = application:get_application(),
erlang:get_module_info(Module, module).
imports：模块引入的函数。

{ok, Module} = application:get_application(),
erlang:get_module_info(Module, imports).
exports：模块导出的函数。

{ok, Module} = application:get_application(),
erlang:get_module_info(Module, exports).
functions：模块里的所有函数。

{ok, Module} = application:get_application(),
erlang:get_module_info(Module, functions).
attributes：模块的一些属性信息。

{ok, Module} = application:get_application(),
erlang:get_module_info(Module, attributes).
compile：模块的编译信息。

{ok, Module} = application:get_application(),
erlang:get_module_info(Module, compile).
native_addresses：模块原生地址。

{ok, Module} = application:get_application(),
erlang:get_module_info(Module, native_addresses).

----------
erlang:get_stacktrace/0
获取最近出现异常的堆栈跟踪信息

用法：

get_stacktrace() -> [{Module, Function, Arity | Args, Location}]
获取最近出现异常的堆栈跟踪信息。

erlang:get_stacktrace().

----------
erlang:group_leader/0
获取被调用进程的组长进程ID

用法：

group_leader() -> pid()
返回被调用函数的进程所在进程组的组长进程ID。

每一个进程是一些进程组的成员之一，进程组组都有一个进程组长（group leader）。进程组的所有 IO 输入输出都会引导到进程组长进程那里去。当一个进程被创建时，父进程的进程组长也看作是子进程的进程组长。系统初始化的时候，init 进程既是它自己的进程组长，同时也是其他所有进程的进程组长。

erlang:group_leader().

----------
erlang:group_leader/2
设置一个进程为组长

用法：

group_leader(GroupLeader, Pid) -> true
把进程 Pid 的进程组组长设置为 GroupLeader。这一般用于从某个 shell 创建的一个进程，想把它的进程组组长设置为别的进程，而不是初始赋予的 init 进程。

关于进程组组长（group leader）方面的更多描述可查看 erlang:group_leader/0 函数。

下面是把组长（group leader）设置为自己：

GroupLeader = self(),
Pid = self(),
erlang:group_leader(GroupLeader, Pid).

----------
erlang:hd/1
返回一个列表的第一个元素

用法：

hd(List) -> term()
返回一个列表 List 的第一个元素，如果列表是一个空列表，则返回 badarg。

erlang:hd([1,2,3,4,5]).

----------
erlang:insert_element/3
向元组插入一个元素

用法：

insert_element(Index, Tuple1, Term) -> Tuple2
在元组 Tuple1 的第 Index 个位置插入一个元素 Term，并返回一个新的元组 Tuple2。在新返回的元组 Tuple2 里，第 Index 位置后面的所有元组的索引值都会增加一位。

erlang:insert_element(2, {one, two, three}, new).

----------
erlang:integer_to_binary/1
把一个整数转换二进制数据

用法：

integer_to_binary(Integer) -> binary()
把一个整数 Integer 转换二进制数据（R16 版本新增的函数）：

integer_to_binary(123)

----------
erlang:integer_to_binary/2
把一个整数转换二进制数据

用法：

integer_to_binary(Integer, Base) -> binary()
返回一个整数 Integer 指定进制 Base 的二进制形式。

integer_to_binary(1023, 16).
integer_to_binary(1023, 2).

----------
erlang:integer_to_list/1
返回一个整数的文本形式

用法：

integer_to_list(Integer) -> string()
返回一个整数 Integer 的文本形式。

integer_to_list(77).

----------
erlang:integer_to_list/2
返回一个整数的文本形式

用法：

integer_to_list(Integer, Base) -> string()
返回一个整数 Integer 指定进制 Base 的文本形式。

integer_to_list(1023, 16).
integer_to_list(1023, 2).

----------
erlang:iolist_size/1
返回一个 iolist 的长度

用法：

iolist_size(Item) -> integer() >= 0
返回由函数 erlang:iolist_to_binary/1 转换而来的二进制的字节数大小的一个整数，即返回一个 iolist 的长度。

iolist_size([1, 2 | >]).
iolist_size(>).
iolist_size("abc").
iolist_size([]).

----------
erlang:iolist_to_binary/1
把一个 iolist 转为一个二进制数据

用法：

iolist_to_binary(IoListOrBinary) -> binary()
把一个列表转换为一个二进制数据，列表是由数字或者是包含二进制数据的列表 IoList 组成。

Bin1 = >,
Bin2 = >,
Bin3 = >,
iolist_to_binary([Bin1, 1, [2, 3, Bin2], 4 | Bin3]).
iolist_to_binary("this is a iolist").
iolist_to_binary([]).

----------
erlang:is_alive/0
检测本地节点是否还存活

用法：

is_alive() -> boolean()
如果本地节点（节点可以是一个分布系统的一部分）还存活，则返回 true，否则返回 false。

erlang:is_alive().

----------
erlang:is_atom/1
判断是否是一个原子类型

用法：

is_atom(Term) -> boolean()
判断变量 Term 是否是原子类型，是则返回 true，否则返回 false。

erlang:is_atom(test).

----------
erlang:is_binary/1
判断是否一个二进制类型

用法：

is_binary(Term) -> boolean()
判断 Term 是否是一个二进制类型，是则返回 true，否则返回 false。一个二进制总是包含一个完整的字节数。

erlang:is_binary(>).

----------
erlang:is_bitstring/1
是否是一个位串类型

用法：

is_bitstring(Term) -> boolean()
判断参数 Term 是否是一个位串类型，是则返回 true，否则返回 false。

erlang:is_bitstring(>).
erlang:is_bitstring(>).
erlang:is_bitstring(>).

----------
erlang:is_boolean/1
判断是否一个布尔类型

用法：

is_boolean(Term) -> boolean()
判断参数 Term 是否是一个布尔类型，是则返回 true，否则返回 false。

erlang:is_boolean(true).
erlang:is_boolean(false).
erlang:is_boolean(boolean).

----------
erlang:is_builtin/3
判断一个是否是由 C 实现的内置函数（BIF）

用法：

is_builtin(Module, Function, Arity) -> boolean()
如果函数 Module:Function/Arity 是一个由 C 实现的内置函数（BIF)，那么返回 true，否则返回 false。

erlang:is_builtin(erlang, md5, 1).
erlang:is_builtin(erlang, open_port_prim, 2).
erlang:is_builtin(unicode, characters_to_list, 2).

----------
erlang:is_float/1
判断是否是一个浮点数类型

用法：

is_float(Term) -> boolean()
如果参数 Term 是一个浮点数类型，则返回 true，否则返回 false。

erlang:is_float(3.141592653589793).

----------
erlang:is_function/1
判断是否是一个函数类型

用法：

is_function(Term) -> boolean()
如果参数 Term 是一个函数类型，则返回 true，否则返回 false。

Fun = fun() ->
    "just a test"
end,
erlang:is_function(Fun).

----------
erlang:is_function/2
判断是否是一个函数类型

用法：

is_function(Term, Arity) -> boolean()
如果参数 Term 是一个含有 Arity 个参数的函数，则返回 true，否则返回 false。

Fun = fun() ->
&nbsp;&nbsp;&nbsp;&nbsp;"just a test"
end,
erlang:is_function(Fun, 0).
Fun = fun(E) -> E end,
erlang:is_function(Fun, 1).

----------
erlang:is_integer/1
判断是否是一个整数

用法：

is_integer(Term) -> boolean()
如果参数 Term 是一个整数，则返回 true，否则返回 false。

erlang:is_integer(20130907).
erlang:is_integer(3.1415926).

----------
erlang:is_list/1
判断是否是一个列表类型

用法：

is_list(Term) -> boolean()
如果参数 Term 是一个列表类型，则返回 true，否则返回 false。

erlang:is_list([1, 2, 3, 4, 5]).

----------
erlang:is_number/1
判断是否是一个数字

用法：

is_number(Term) -> boolean()
如果参数 Term 是一个数子，则返回 true，否则返回 false。

erlang:is_number(20130907).
erlang:is_number(3.1415926).
erlang:is_number(number).

----------
erlang:is_pid/1
判断是否是一个进程

用法：

is_pid(Term) -> boolean()
如果参数 Term 是一个进程 pid（进程标识），则返回 true，否则返回 false。

Pid = self(),
erlang:is_pid(Pid).

----------
erlang:is_port/1
判断是否是一个端口（port）类型

用法：

is_port(Term) -> boolean()
如果参数 Term 是一个端口（port），则返回 true，否则返回 false。

Port = erlang:open_port({spawn, "ls"}, [exit_status]),
erlang:is_port(Port).
Port = hd(erlang:ports()),
erlang:is_port(Port).

----------
erlang:is_process_alive/1
检测进程是否存活

用法：

is_process_alive(Pid) -> boolean()
检测进程（必须是本地节点的进程）是否还存活（尚未关掉或已经被关掉的情况），如果是，则返回 true，否则返回 false。

Pid = self(),
erlang:is_process_alive(Pid).
跨节点的进程，可以调用 rpc:call/4 来检测：

IsProcessAlive = fun(Pid) ->
    case is_pid(Pid) of
        true ->
            case rpc:call(node(Pid), erlang, is_process_alive, [Pid]) of
                true -> true;
                _ -> false
            end;
        _ -> 
            false
    end
end,
Pid = self(),
IsProcessAlive(Pid).

----------
erlang:is_record/2
判断变量是否是一个记录

用法：

is_record(Term, RecordTag) -> boolean()
如果 Term 是一个元组，并且它的第一个元素是 RecordTag 的话（即 Term 是否是一个 RecordTag 记录），则返回 true，否则返回 false。

Record = {test, 1, 2, 3},
erlang:is_record(Record, test).

----------
erlang:is_record/3
判断变量是否是一个记录

用法：

is_record(Term, RecordTag, Size) -> boolean()
如果 Term 是一个元组，并且它的第一个元素是 RecordTag，它的长度大小是 Size 的话（即 Term 是否是一个 RecordTag 记录），则返回 true，否则返回 false。

Record = {test, 1, 2, 3},
erlang:is_record(Record, test, 3).

----------
erlang:is_reference/1
判断是否是一个引用类型

用法：

is_reference(Term) -> boolean()
如果参数 Term 是一个引用（reference）类型，则返回 true，否则返回 false。

Reference = erlang:make_ref(),
erlang:is_reference(Reference).
Timer = erlang:send_after(5000, self(), erlang_is_reference),
erlang:is_reference(Timer).

----------
erlang:is_tuple/1
判断是否是一个元组类型

用法：

is_tuple(Term) -> boolean()
如果参数 Term 是一个元组类型，则返回 true，否则返回 false。

erlang:is_tuple({1, 2, 3, 4, 5}).

----------
erlang:length/1
获取列表的长度

用法：

length(List) -> integer() >= 0
获取列表 List 的长度

erlang:length([1, 2, 3, 4, 5, 6, 7, 8, 9]).
Erlang 中的字符串实际上就是一个整数列表，用双引号（"）将一串字符括起来就是一个字符，因此 erlang:length/1 也可以获取字符串的长度。

Str = "abcdefg",
erlang:length(Str).

----------
erlang:list_to_atom/1
把一个文本形式的字符列表转为原子

用法：

list_to_atom(String) -> atom()
把一个文本形式的列表字符 String 转为一个原子 atom

list_to_atom("erlang").

----------
erlang:list_to_binary/1
把一个列表转为一个二进制数据

用法：

list_to_binary(IoList) -> binary()
把一个列表转换为一个二进制数据，列表是由数字或者是包含二进制数据的列表 IoList 组成。

Bin1 = >,
Bin2 = >,
Bin3 = >,
list_to_binary([Bin1, 1, [2, 3, Bin2], 4 | Bin3]).

----------
erlang:list_to_bitstring/1
把一个列表转为一个字节串

用法：

list_to_bitstring(BitstringList) -> bitstring()
把一个列表转换为一个字节串，列表是由数字或者是包含字节串列表 BitstringList（字节串列表的末尾允许是一个字节串） 的数据组成。

Bin1 = >,
Bin2 = >,
Bin3 = >,
list_to_bitstring([Bin1, 1, [2, 3, Bin2], 4 | Bin3]).

----------
erlang:list_to_existing_atom/1
把一个文本形式的字符列表转为原子

用法：

list_to_existing_atom(String) -> atom()
把一个文本形式的字符列表转为一个已经存在原子 atom，如果原子 atom 不存在，则返回一个 badarg 的错误。

list_to_existing_atom("test").

----------
erlang:list_to_float/1
把一个字符串转为一个浮点数

用法：

list_to_float(String) -> float()
返回一个文本形式是 String 的浮点数

list_to_float("2.2017764e+0").

----------
erlang:list_to_integer/1
把一个字符串转为一个整数

用法：

list_to_integer(String) -> integer()
返回一个文本形式是 String 的整数，如果 String 不是文本形式的整数，则返回 badarg。

list_to_integer("123").

----------
erlang:list_to_integer/2
把字符串转为一个整数

用法：

list_to_integer(String, Base) -> integer()
把一个 Base 进制的文本形式的字符串 String 转为一个整数。如果 String 不是一个合法的文本形式的整数，则返回 bagarg。

list_to_integer("3FF", 16).

----------
erlang:list_to_pid/1
将一个字符串转为一个 pid

用法：

list_to_pid(String) -> pid()
将一个字符串 String 转为一个 pid，如果 String 不是一个合法的文本形式的 pid，则返回 bagarg。

list_to_pid("").

----------
erlang:list_to_tuple/1
把一个列表转换为一个元组

用法：

list_to_tuple(List) -> tuple()
返回一个与列表 List 一致对应的元组，列表 List 可以包含任意的 Erlang 项（terms）。

list_to_tuple([share, ['EriCSSon_B', 163]]).

----------
erlang:load_module/2
加载一个模块的目标 BEAM 代码

用法：

load_module(Module, Binary) -> {module, Module} | {error, Reason}
如果 Binary 包含着模块 Module 的目标 BEAM 代码，那么这个内置函数（BIF）会加载这些目标代码。如果模块 Module 的目标代码已经存在，那么模块所有的对外引用接口都会被替换成新加载代码里的。之前加载的代码将作为就代码保存在系统里，因为也许还有进程还用那些代码在运行着。如果加载成功，则返回 {module, Module}，否则返回 {error, Reason}。

Reason 的选项：

badfile：Binary 是一个错误格式的目标代码
not_purged：模块的目标代码 Binary 不能被加载，因为该模块的旧代码已经存在
badfile：Binary是另外一个模块的目标代码
{ok, Module} = application:get_application(),
case code:get_object_code(Module) of
    {Module, Binary, _Filename} ->
        erlang:load_module(Module, Binary);
    GetObjectCodeError ->
        GetObjectCodeError
end.
{ok, Module} = application:get_application(),
case code:get_object_code(Module) of
    {_Module, Binary, _Filename} ->
        {ok, {_, [{abstract_code, {_, AbstractCode}}]}} = beam_lib:chunks(Binary, [abstract_code]),
        io:format("~s~n", [erl_prettypr:format(erl_syntax:form_list(AbstractCode))]);
    GetObjectCodeError ->
        GetObjectCodeError
end.

----------
erlang:load_nif/2
加载原生实现函数

用法：

load_nif(Path, LoadInfo) -> ok | {error, {Reason, Text}}
加载并连接一个包含原生实现函数的模块的动态库。

Path 是一个缺省系统文件后缀（例如 Unix 下的 .so 后缀，Windows 下的 .dll 后缀）的共享库的文件路径。

LoadInfo 可以是任何 Erlang 项元值（term），它将作为加载初始的一部分被传入到库里面。

erlang:load_nif("./niftest", 0).

----------
erlang:loaded/0
返回一个所有已经加载模块的列表

用法：

loaded() -> [Module]
返回一个所有已经加载的 Erlang 模块的列表，包括预加载模块。

erlang:loaded().

----------
erlang:localtime/0
获取现在的当地日期和时间

用法：

localtime() -> DateTime
获取现在的当地日期和时间 {{Year, Month, Day}, {Hour, Minute, Second}}。时区和夏令时的时间调整取决于底层的操作系统。

erlang:localtime().

----------
erlang:localtime_to_universaltime/1
把当地时间转为国际标准时间（UTC）

用法：

localtime_to_universaltime(Localtime) -> Universaltime
内部实现：

-spec erlang:localtime_to_universaltime(Localtime) -> Universaltime when
      Localtime :: calendar:datetime(),
      Universaltime :: calendar:datetime().
localtime_to_universaltime(Localtime) ->
    erlang:localtime_to_universaltime(Localtime, undefined).
把当地时间改为国际标准时间（UTC），如果底层操作系统支持的话。如果底层操作系统不支持，将不会有转为操作而是直接返回输入的时间。

erlang:localtime_to_universaltime({{2013, 9, 19}, {11, 55,17}}).

----------
erlang:localtime_to_universaltime/2
把当地时间转为国际标准时间（UTC）

用法：

localtime_to_universaltime({Date1, Time1}, IsDst) -> {Date2, Time2}
像 erlang:localtime_to_universaltime/1 一样，把当地时间改为国际标准时间（UTC），但是调用会判断是否在夏令时。

如果 IsDst 为 true，那么 {Date1, Time1} 是在夏令时期间；如果 IsDst 为 false，则不在夏令时期间；如果 IsDst 为 undefined，那么底层操作系统将会判断是否是在夏令时期间，就像调用 erlang:localtime_to_universaltime({Date1, Time1}) 那样。

如果 Date1 或 Time1 不是一个合法的日期或时间，则返回 badarg。

erlang:localtime_to_universaltime({{2013, 9, 19}, {11, 55,17}}, true).
erlang:localtime_to_universaltime({{2013, 9, 19}, {11, 55,17}}, false).
erlang:localtime_to_universaltime({{2013, 9, 19}, {11, 55,17}}, undefined).

----------
erlang:make_ref/0
返回一个几乎唯一的引用值

用法：

make_ref() -> reference()
返回一个几乎唯一的引用值。该函数被调用大约 2^82 次后，返回的应用值会重新计算；因此它的唯一性是足够满足实际需求的。

erlang:make_ref().

----------
erlang:max/2
返回两个项值里最大的一个

用法：

max(Term1, Term2) -> Maximum
内部实现：

-spec max(Term1, Term2) -> Maximum when
      Term1 :: term(),
      Term2 :: term(),
      Maximum :: term().
max(A, B) when A  B;
max(A, _) -> A.
获取项值 Term1 和 Term2 之中最大的那个项值，如果两个项值一样，则返回 Term1。

erlang:max(5, 2).
erlang:max(f, o).
erlang:max(1, e).

----------
erlang:md5/1
把一个数据加密为一个 MD5 值

用法：

md5(Data) -> Digest
把一个长度为 128 位（16个字节）的数据加密为一个 MD5（消息摘要算法第五版：Message-Digest Algorithm 5）值。参数 Data 可以是一个二进制数据或一个整数和二进制数据的列表。

erlang:md5("123456").
Erlang 输出的 md5 值是 一个 16 位二进制，需要额外转换才是我们平时看到的 32 位字符串，转换代码如下：

Data = "123456",
lists:flatten([io_lib:format("~2.16.0b", [D]) || D 

----------
完成一个 MD5 上下文的计算并返回计算后的 MD5 值

用法：

md5_final(Context) -> Digest
完成一个 MD5 上下文的更新，并返回最后计算得出的一个 MD5 消息摘要。

Context = erlang:md5_init(),
Data = "123456",
NewContext = erlang:md5_update(Context, Data),
erlang:md5_final(NewContext).
erlang:md5_final/1 跟 erlang:md5_init/0、erlang:md5_update/2 共同计算出的消息摘要值跟直接用 erlang:md5/1 计算出的消息摘要值一样：

Context = erlang:md5_init(),
Data = "123456",
NewContext = erlang:md5_update(Context, Data),
MD5Value1 = erlang:md5_final(NewContext),
MD5Value2 = erlang:md5(Data),
MD5Value1 =:= MD5Value2.
Erlang 输出的 md5 值是 一个 16 位二进制，需要额外转换才是我们平时看到的 32 位字符串，具体请查看 erlang:md5/1 里的介绍。

----------
erlang:md5_init/0
创建一个 MD5 上下文

用法：

md5_init() -> Context
创建一个 MD5 上下文。返回的值 Context 用来给 erlang:md5_update/2 调用。

erlang:md5_init().
erlang:md5_init/0 经常跟 erlang:md5_update/2、erlang:md5_final/1 共同计算出一个消息摘要值，该值跟直接用 erlang:md5/1 计算出的消息摘要值一样：

Context = erlang:md5_init(),
Data = "123456",
NewContext = erlang:md5_update(Context, Data),
MD5Value1 = erlang:md5_final(NewContext),
MD5Value2 = erlang:md5(Data),
MD5Value1 =:= MD5Value2.
Erlang 输出的 md5 值是 一个 16 位二进制，需要额外转换才是我们平时看到的 32 位字符串，具体请查看 erlang:md5/1 里的介绍。

----------
erlang:md5_update/2
用一个数据来更新一个 MD5 值

用法：

erlang:md5_update(Context, Data) -> NewContext
用一个数据 Data 来更新一个 MD5 值，并返回一个新的上下文 NewContext。

Context = erlang:md5_init(),
Data = "123456",
erlang:md5_update(Context, Data).
erlang:md5_update/2 经常跟 erlang:md5_init/0、erlang:md5_final/1 共同计算出一个消息摘要值，该值跟直接用 erlang:md5/1 计算出的消息摘要值一样：

Context = erlang:md5_init(),
Data = "123456",
NewContext = erlang:md5_update(Context, Data),
MD5Value1 = erlang:md5_final(NewContext),
MD5Value2 = erlang:md5(Data),
MD5Value1 =:= MD5Value2.
Erlang 输出的 md5 值是 一个 16 位二进制，需要额外转换才是我们平时看到的 32 位字符串，具体请查看 erlang:md5/1 里的介绍。

----------
erlang:memory/0
获取内存的动态分配信息

用法：

memory() -> [{Type, Size}]
返回一个包含 Erlang 虚拟机的内存动态分配的信息列表，列表里的每一个元素是一个 {Type, Size} 组成的元组。第一个元素 Type 是描述内存类型的原子，第二个元素 Size 是改类型在内存里的字节数。

erlang:memory().
内存类型有：

total：当前分配给进程 processes 和系统 system 的内存总量
processes：当前分配给 Erlang 进程的内存总量
processes_used：当前已被 Erlang 进程使用的内存总量（进程内存的一部分）
system：当前分配给 Erlang 虚拟机，不过没有被 Erlang 进程占用的内存总量。
atom：当前分配给原子的内存总量（系统进程的一部分）
atom_used：当前已被 原子使用的内存总量（系统进程的一部分）
binary：当前分配给二进制数据的内存总量（系统进程的一部分）
code：当前代码数据所占用的内存总量（系统进程的一部分）
ets：当前分配给 ETS 表的内存总量（系统进程的一部分）

----------
erlang:memory/1
获取指定内存类型的动态分配信息

用法：

memory(Type | [Type]) -> Size | [{Type, Size}]
获取指定类型内存 Type 的内存分配大小数据，参数 Type 可以是一个有内存类型原子组成的列表。如果 Type 不是内存类型默认定义的，则返回 badarg。

erlang:memory(processes_used).
erlang:memory([total, processes, processes_used, system, atom, atom_used, binary, code, ets]).

----------
erlang:min/2
返回两个项值里最小的那个

用法：

min(Term1, Term2) -> Minimum
内部实现：

-spec min(Term1, Term2) -> Minimum when
      Term1 :: term(),
      Term2 :: term(),
      Minimum :: term().
min(A, B) when A > B -> B;
min(A, _) -> A.
获取项值 Term1 和 Term2 之中最小的那个项值，如果两个项值一样，则返回 Term1。

erlang:min(5, 2).
erlang:min(f, o).
erlang:min(1, e).

----------
erlang:module_loaded/1
检测一个模块是否已经加载

用法：

module_loaded(Module) -> boolean()
如果模块 Module 已经加载，则返回 true，否则返回 false。该函数不会尝试去加载一个模块。

erlang:module_loaded(genfsm).
erlang:module_loaded(lists).

----------
erlang:monitor/2
开启一个监控过程

用法：

monitor(Type, Item) -> MonitorRef
对被调用的进程开启一个监控过程，参数 Type 是被监控对象 Item 的类型。

当前只有进程可以被监视，Type 的取值只允许是 process，但其他类型也许以后会被允许。

Item 可以是：

pid()：一个进程标识符是 pid 的进程被监控
{RegName, Node}：用元组包含着一个进程的注册名和一个节点名。驻留在节点 Node 的注册名为 RegName 的进程将被监控
RegName：本地节点上注册名为 RegName 的进程将被注册
如果被监控的对象 Item 死亡，或者是不存在，或者是对象 Item 所在的节点失去了连接，那么一个 'DOWN' 的信息将会发送到被监控的进程上。一个 'DOWN' 消息的格式如下：

{'DOWN', MonitorRef, Type, Object, Info}

MonitorRef 是该监控过程的一个引用，Type 是指上面所说的对象类型，

Object 是监控对象的一个引用。如果 Item 指定为 pid，那么 Object 是被监控进程的 pid。如果 Item 指定为 {RegName, Node}，那么 Object 则是 {RegName, Node}。如果 Item 指定为 RegName，那么 Object 则是 {RegName, Node}（这里的 Node 是指本地节点 node()）。

当接收到一条 'DOWN' 消息，或调用了 erlang:demonitor/1 函数，监控过程将被停止。

可以对同一个对象 Item 开启多个监控过程，他们只负责各自的监控事务，并不会报错。

erlang:monitor(process, self()).
spawn(fun()->
    erlang:monitor(process,Proc),
    receive
        {'DOWN', Ref, process, Pid,  normal} -> 
            io:format("~p said that ~p died by natural causes~n",[Ref,Pid]);
        {'DOWN', Ref, process, Pid,  Reason} ->
            io:format("~p said that ~p died by unnatural causes~n~p",[Ref,Pid,Reason])
    end        
end).

----------
erlang:nif_error/1
以一个给定的原因停止执行当前进程

用法：

nif_error(Reason) -> no_return()
用法很像 erlang:error/2，但是 Dialyzer 会认为这个内置函数（BIF）将返回一个任意的项值。当根（stub）函数使用 NIF 来产生异常错误，并 NIF 库没有被加载，Dialyzer 将不会产生错误警告。

erlang:nif_error(stop_reason).

----------
erlang:nif_error/2
以一个给定的原因和参数停止执行当前进程

用法：

erlang:nif_error(Reason, Args) -> no_return()
用法很像 erlang:error/2，但是 Dialyzer 会认为这个内置函数（BIF）将返回一个任意的项值。当根（stub）函数使用 NIF 来产生异常错误，并 NIF 库没有被加载，Dialyzer 将不会产生错误警告。

erlang:nif_error(stop_reason, 1).

----------
erlang:node/0
返回本地节点的名字

用法：

node() -> Node
返回本地节点的名字，如果节点不存在，则返回 nonode@nohost。

erlang:node().

----------
erlang:node/1
返回一个进程、端口或映射所在的节点

用法：

node(Arg) -> Node
返回参数 Arg 所在的节点，参数 Arg 可以是一个进程、一个映射，或者是一个端口。如果本地的节点不存在，则返回 nonode@nohost。

erlang:node(self()).

----------
erlang:nodes/0
返回系统里所有可访问的节点

用法：

nodes() -> Nodes
返回在系统里除了本地节点之外的其他可连接访问的一个节点列表。用法跟 erlang:nodes/1 的 erlang:nodes(visible) 一样。

nodes().
可调用函数 net_adm:ping/1 来检测节点间是否可连接访问。

----------
erlang:nodes/1
返回系统里某一个类型的所有节点

用法：

nodes(Arg | [Arg]) -> Nodes
根据给出的参数返回一个节点列表。Args 是一个列表，返回的节点列表都符合参数 Args 列表里的每一个元素。

Arg 的取值范围有：

visible：正常连接到该节点的其他节点

erlang:nodes(visible).
hidden：隐式连接到该节点的其他节点

erlang:nodes(hidden).
connected：所有连接到该节点的节点

erlang:nodes(connected).
this：当前节点

erlang:nodes(this).
known：已知到该节点的节点，例如 connected, previously connected 等等。

erlang:nodes(known).
一些等价的表达式：[node()] = nodes(this), nodes(connected) = nodes([visible, hidden]), 和 nodes() = nodes(visible)。

如果本地节点不存在，那么 nodes(this) == nodes(known) == [nonode@nohost]，其他参数则返回一个空列表 []。

----------
erlang:now/0
获取从 GMT 零点开始到当前的时间

用法：

now() -> timestamp()
如果底层操作系统支持的话，返回从 1970-1-1 00:00:00 开始到当前的时间元组 {MegaSecs, Secs, MicroSecs}。否则，将选择别的时间点。由于后续调用这个 BIF 函数返回的是一个连续累加的值，因此，这个函数的返回值可以用来当做唯一确定的时间戳。如果这个函数是在一个高速的机器上频繁调用，那么节点的时间是会有些偏差。

如果底层操作系统的 time-zone 预先设置好，该函数可以检测当前的本地时间。

如果不必需要返回一个唯一确定、单调累加的值，可以使用 os:timestamp/0 来避免服务器的一些负荷瓶颈。

erlang:now().
详细的 erlang:now/0 跟 os:timestamp/0 的时间获取优劣，可参看：Erlang取当前时间的瓶颈以及解决方案

----------
erlang:phash/2
小型便携的 hash 函数

用法：

phash(Term, Range) -> Hash
返回跟项元 Term 相关，范围在 1 至 Range 间的一个 hash 数值，Range 的取值范围是 1 至 2^32 之间

erlang:phash(test, 10000).
erlang:phash(now(), 10000).

----------
erlang:phash2/2
小型便携的 hash 函数

用法：

phash2(Term [, Range]) -> Hash
返回跟项元 Term 相关，范围在 0 至 Range - 1 间的一个 hash 数值，Range 的取值范围是 1 至 2^32 之间：

erlang:phash2(test, 10000).
erlang:phash2(now(), 10000).
缺少第二个参数 Range 时，将返回一个 0 至 2^27 - 1 hash 数值：

erlang:phash2(now()).

----------
erlang:pid_to_list/1
返回一个进程 Pid 的文本表示形式的字符串

用法：

pid_to_list(Pid) -> string()
返回一个进程 Pid 的文本表示形式的字符串。

Pid = self(),
erlang:pid_to_list(Pid).

----------
erlang:port_info/1
获取一个端口的信息

用法：

port_info(Port) -> [{Item, Info}] | undefined
返回以元组的形式构成的一个关于端口 Port 的信息，如果端口没打开，则返回 undefined。或是如果端口不是一个本地端口，则返回 badarg。返回的端口信息元组的顺序不是固定的，返回的元组值也不一定都出现。

{registered_name, RegName}：RegName 是端口的注册名。如果端口没注册，那么这个元组不会出现在列表里。
{id, Index}：Index 是端口的内部索引值，用作端口间的区分。
{connected, Pid}：Pid 是连接端口的进程。
{links, Pids}：Pids 是跟端口进程有链接关系的进程的列表。
{name, String}：Strng 是由 open_port 设置的命令名。
{input, Bytes}：Bytes 是从端口输入的总共字节数。
{output, Bytes}：Bytes 是从端口输出的总共字节数。
Port = hd(erlang:ports()),
erlang:port_info(Port).

----------
erlang:port_info/2
获取端口的指定信息

用法：

port_info(Port, Item) -> {Item, Info} | undefined | []
获取端口指定项 Item 的信息。如果端口没打开，则返回 undefined；如果端口不是一个本地列表，则返回 badarg；如果 Item 为 registered_name，但是端口没有被注册，那么则返回一个空列表 []。

Port = hd(erlang:ports()),
erlang:port_info(Port, id).
Port = hd(erlang:ports()),
erlang:port_info(Port, name).

----------
erlang:port_to_list/1
返回一个端口标识的文本表示形式的字符串

用法：

port_to_list(Port) -> string()
返回一个端口标识 Port 的文本表示形式的字符串。

Port = hd(erlang:ports()),
erlang:port_to_list(Port).

----------
erlang:ports/0
返回一个本地节点的所有端口的列表

用法：

ports() -> [port()]
返回一个本地节点的所有端口的列表。

erlang:ports().

----------
erlang:pre_loaded/0
列出所有预加载的模块

用法：

pre_loaded() -> [Module]
返回一个系统里所有预加载的 Erlang 模块的列表。由于所有代码的加载需要通过文件系统来完成，所以文件系统必须先加载。因此，至少 init 模块必须预先加载。

erlang:pre_loaded().

----------
erlang:process_display/2
获取进程的一些标准信息

用法：

process_display(Pid, Type) -> void()
获取进程 Pid 的一些标准信息，当前的 Type 值只允许有一个原子值 -- backtrace，它可以显示调用栈的内容，以及包括调用链的信息，和输出当前第一个调用的函数。

erlang:process_display(self(), backtrace).

----------
erlang:process_info/1
返回一个进程的信息

用法：

process_info(Pid) -> InfoResult
返回以元组的形式构成的一个关于进程 Pid 各方面信息的列表。如果进程已经不存活，则返回 undefined。返回的进程信息元组的顺序不是固定的，返回的元组项值也不一定都出现。

Pid = self(),
erlang:process_info(Pid).

----------
erlang:process_info/2
获取进程的相关信息

用法：

process_info(Pid, ItemSpec) -> InfoResult
返回进程 Pid 指定的 ItemSpec 的相关信息，如果进程不存在，则返回 undefined.

message_queue_len：进程消息队列的当前消息的数量。这是指定项 messages 所返回的消息队列列表的长度值。

erlang:process_info(self(), message_queue_len).
messages：返回进程还没有处理的消息列表。

erlang:process_info(self(), messages).
registered_name：返回进程注册的名。如果进程没有注册名，则返回一个空列表 []。

erlang:process_info(self(), registered_name).
reductions：返回进程执行 reductions 的次数，一般用来衡量进程负载。

erlang:process_info(self(), reductions).
heap_size：表示进程内存占用堆区的大小，单位是 words（一般 32 位系统 1 word 是为 4 字节，64 位系统 1 word 是 8 字节，系统具体占用多少字节数可通过 erlang:system_info(wordsize) 查看）。

erlang:process_info(self(), heap_size).
memory：进程占用内存的大小（单位是字节 bytes），这包括被调用的栈、堆和内部的一些结构数据。

erlang:process_info(self(), memory).
priority：获取进程的当前优先级。

erlang:process_info(self(), priority).
current_function：当前进程调用着的函数。

erlang:process_info(self(), current_function).
backtrace：当前进程的一些回溯追踪信息。

erlang:process_info(self(), backtrace).
group_leader：负责IO 进程管理的组管理者。

erlang:process_info(self(), group_leader).

----------
erlang:processes/0
获取本地节点上所有进程

用法：

processes() -> [pid()]
返回一个本地节点当前还存在的所有进程的进程标识列表。

Note：如果一个进程正在退出，它的状态还是存在的，只是被标识成没存活而已，例如对一个正在退出中的进程调用函数 erlang:is_process_alive/1，它返回的结果是 false，不过它在调用函数 erlang:processes/0 期间退出，它仍然包含在返回的进程标识结果里。

erlang:processes().

----------
erlang:purge_module/1
移除模块的旧代码

用法：

purge_module(Module) -> void()
移除模块的旧代码。在调用内置函数（BIF）之前，会先调用 erlang:check_process_code/2 来检测模块里的旧代码是否有进行在运行着，有则把进程杀掉。如果模块里没有旧的代码，则返回 badarg。

erlang:purge_module(genfsm).

----------
erlang:put/2
在进程字典里添加一个新键

用法：

put(Key, Val) -> OldVal | undefined
在进程字典里添加一个与值 Val 关联的新键 Key，并返回 undefined，如果键已经存在，则旧的值会被删除并被替换成 Val，最后函数返回旧的值。

put(test, test).

----------
erlang:read_timer/1
获取一个定时器的剩余毫秒数

用法：

read_timer(TimerRef) -> integer() >= 0 | false
TimerRef 是函数 erlang:send_after/3 或 erlang:start_timer/3 返回的定时器引用。如果定时器在活跃期间，那么这个函数将返回该定时器到过期时间的剩余毫秒数；如果 TimerRef 不是一个定时器，或者是被取消掉，或已经到了过期时间，则返回 false。

TimerRef = erlang:send_after(5000, self(), test),
erlang:read_timer(TimerRef).

----------
erlang:record_info/2
获取记录信息

用法：

record_info(type, record) -> RecordInfo
获取记录 record 的信息，例如：

获取记录的字段信息

record_info(fields, wm_reqdata).
获取记录的长度信息

record_info(size, wm_reqdata).

----------
erlang:register/2
给一个进程或端口注册一个名字

用法：

register(RegName, Pid | Port) -> true
给一个进程或一个端口标示关联一个名字 RegName。RegName 必须是一个原子，在发送信息（RegName ! Message）的操作中可以代替进程或端口标示使用。

如果进程 Pid 不存在；不是本地进程或端口；RegName 已经被使用；进程或端口已经被注册；RegName 是一个 undefined 的原子，都会返回 badarg。

erlang:register(genfsm, self()).

----------
erlang:registered/0
获取所有注册名

用法：

registered() -> [RegName]
内部实现：

返回一个通过 erlang:register/2 函数注册的所有注册名的列表。

erlang:registered().

----------
erlang:round/1
返回一个数四舍五入后的整数值

用法：

round(Number) -> integer()
返回一个数 Number 四舍五入后的整数值

erlang:round(5.5).

----------
erlang:self/0
返回当前调用进程的 pid

用法：

self() -> pid()
返回当前调用进程的进程标识 pid（(process identifier) ）。

erlang:self().

----------
erlang:send/2
发送一个信息

用法：

send(Dest, Msg) -> Msg
发送一条信息，并返回结果 Msg，这跟 Dest ! Msg 的效用是一样的。

Dest 可以是远程或本地的进程、本地的一个端口、本地的一个注册名、或者是以 {RegName, Node} 元组形式的另外一个节点的注册名。

Dest = self(),
erlang:send(Dest, test).

----------
erlang:send/3
发送一个条件信息

用法：

send(Dest, Msg, [Option]) -> Res
发送一条信息并返回 ok，或者不发送信息但是只返回其他结果。

可用的参数 Option 有：

nosuspend：如果发送方将暂停（suspended）发送信息，则返回 nosuspend
noconnect：如果目标节点必须自动连接（auto-connected）后才能发送信息，则返回 noconnect
case catch erlang:send(self(), test, [noconnect]) of
    noconnect ->
        noconnect;
    Other ->
        Other
end.

----------
erlang:send_after/3
开启一个定时器

用法：

send_after(Time, Dest, Msg) -> TimerRef
开启一个 Time 毫秒后将向 Dest 发送消息 Msg 的定时器

如果 Dest 是一个进程，那么它必须是一个本地进程，不管是被关闭的还是活跃的进程，否则会报 badarg 的错误。

在当前实现里，参数 Time 的值不能大于4294967295。

如果 Dest 是一个原子，它应该是被注册进程的名称。在投送消息的时候会查找与该名称相关联的进程。如果名字并不跟任何进程相关联，不会发生任何错误。

如果 Dest 是一个进程，那么当跟 Pid 关联的进程不存在或进程崩掉，该定时器将会自动取消。这个功能是在 ERTS 5.4.11 版本引入进来。当 Dest 是一个原子时，定时器不会自动取消。

跟定时器相关的一些函数：erlang:start_timer/3，erlang:cancel_timer/1，erlang:read_timer/1。

如果参数不满足上面指定的要求，那么将返回 bagarg。

erlang:send_after(5000, self(), test).

----------
erlang:setelement/3
设置一个元组的值

用法：

setelement(Index, Tuple1, Value) -> Tuple2
把元组 Tuple1 里的第 Index 个元素的值替换为 Value（元组的索引开始值是 1 ），最后返回一个替换后的副本元组 Tuple2。

Tuple = {a, 1, 2},
erlang:setelement(2, Tuple, 5).

----------
erlang:size/1
获取一个元组或二进制数据的大小

用法：

size(Item) -> integer() >= 0
获取参数 Item 的大小，参数 Item 的类型必须是元组或一个二进制的数据。

size({morni, mulle, bwange}).
size(>).

----------
erlang:start_timer/3
开启一个定时器

用法：

start_timer(Time, Dest, Msg) -> TimerRef
开启一个 Time 毫秒后将向 Dest 发送消息 {timeout, TimerRef, Msg} 的定时器

如果 Dest 是一个进程，那么它必须是一个本地进程，不管是死的还是活的进程。

在当前实现里，参数 Time 的值不能大于4294967295。

如果 Dest 是一个原子，它应该是被注册进程的名称。在投送时消息的时候会查找引用该名称的相关进程。如果名字并不跟任何进程关联，不会发生任何错误。

如果 Dest 是一个进程，那么当跟 Pid 关联的进程不存在或进程退出时，该定时器将会自动取消。这个功能是在 ERTS 5.4.11 版本引入进来。当 Dest 是一个原子时，定时器不会自动取消。

跟定时器相关的一些函数：erlang:send_after/3，erlang:cancel_timer/1，erlang:read_timer/1。

如果参数不满足上面指定的要求，那么将返回 bagarg。

erlang:start_timer(5000, self(), test).

----------
erlang:statistics/1
返回系统信息

用法：

statistics(Type) -> Res
返回跟指定类型 Type 相关的系统信息

context_switches：返回 {ContextSwitches, 0}，参数 ContextSwitches 指的是系统启动到当前上下文切换的总数。

erlang:statistics(context_switches).
exact_reductions：返回 {Total_Exact_Reductions, Exact_Reductions_Since_Last_Call}。

erlang:statistics(exact_reductions).
garbage_collection：返回 {Number_of_GCs, Words_Reclaimed, 0}。

erlang:statistics(garbage_collection).
io：返回 {{input, Input}, {output, Output}}，Input 是指端口接收到的总的字节数，Output 是指端口输出的总的字节数。

erlang:statistics(io).
reductions：返回 {Total_Reductions, Reductions_Since_Last_Call}。

erlang:statistics(reductions).
run_queue：返回执行队列的长度，就是准备运行的进程数量。

erlang:statistics(run_queue).
runtime：返回 {Total_Run_Time, Time_Since_Last_Call} 的格式数据，Total_Run_Time 是指总的 CPU 执行时间，Time_Since_Last_Call 是指从上次调用以来代码执行消耗 CPU 的时间。

erlang:statistics(runtime).
wall_clock：返回 {Total_Wallclock_Time, Wallclock_Time_Since_Last_Call} 的格式数据，Total_Wallclock_Time 是指代码总的运行时间，Wallclock_Time_Since_Last_Call 是指从上次调用以来代码的执行时间。

erlang:statistics(wall_clock).
利用 wall_clock 获取当前程序总的运行时间：

{Total_Wallclock_Time, _Wallclock_Time_Since_Last_Call} = erlang:statistics(wall_clock),
{D, {H, M, S}} = calendar:seconds_to_daystime(Total_Wallclock_Time div 1000),
lists:flatten(io_lib:format("~p days, ~p hours, ~p minutes and ~p seconds", [D, H, M, S])).

----------
erlang:system_info/1
返回系统的相关信息

用法：

system_info(Type) -> Res
返回当前系统指定类型 Type 的相关信息。常用的信息有：

alloc_util_allocators：获取一个使用 ERTS（Erlang 运行时系统） 内部 alloc_util（分配工具）框架的所有分配器名字的原子列表。

erlang:system_info(alloc_util_allocators).
info：获取经过格式化后的 Erlang 崩溃时的各种系统信息。

erlang:system_info(info).
otp_release：返回一个当前 OTP 发行数字的字符串。

erlang:system_info(otp_release).
process_count：返回本地节点当前存在的进程数，返回的结果跟 length(processes()) 一样。

erlang:system_info(process_count).
process_limit：返回本地节点当前最大可存在的进程数，这个限制数可以在启动 Erlang 虚拟机的时候由参数标识 +P 设置。

erlang:system_info(process_limit).
thread_pool_size：返回用于异步驱动调用的异步线程池的异步线程数量。

erlang:system_info(thread_pool_size).
wordsize：当前系统 1 word 代表的字节数。

erlang:system_info(wordsize).
system_version：返回当前 Erlang 系统的版本信息。

erlang:system_info(system_version).
os_type：返回当前操作系统的系统家族和系统名称。

erlang:system_info(os_type).

----------
erlang:system_profile/0
获取当前系统的属性信息

用法：

system_profile() -> ProfilerSettings
返回由 erlang:system_profile/2 函数设置的当前系统属性设置信息，如果没有设置信息，则返回 undefined。选项的顺序可能会跟设置时有所不同。

erlang:system_profile().

----------
erlang:term_to_binary/1
把一个 Erlang 转为一个二进制数据

用法：

term_to_binary(Term) -> ext_binary()
把一个 Erlang 项（term）转为一个由 Erlang 扩展项格式（External Term Format）编码后的二进制数据。

term_to_binary(test).
term_to_binary(123).
term_to_binary([1, 2, 3]).
term_to_binary("123").
term_to_binary({a, 1, 2, 3}).
term_to_binary(>).
Fun = fun()-> ok end,
term_to_binary(Fun).
Pid = self(),
term_to_binary(Pid).
这可用于多种用途，例如可以很方便的把一个 Erlang 项数据写入一个文件里，或是把一个 Erlang 项数据发送到不支持 Erlang 分布的其他类型的通信通道。

二进制数据转 Erlang 项的方法：erlang:binary_to_term/1。

----------
erlang:throw/1
抛出一个异常错误

用法：

throw(Any) -> no_return()
从函数里抛出一个不能从返回值获取的&ldquo;非本地&rdquo;结果，如果解析的语句在 catch 之内，catch 将会捕获得到返回值 Any。

catch throw({hello, there}).

----------
erlang:time/0
获取当前时间

用法：

time() -> {Hour, Minute, Second}
内部实现：

BIF_RETTYPE time_0(BIF_ALIST_0)
{
     int hour, minute, second;
     Eterm* hp;

     get_time(&amp;hour, &amp;minute, &amp;second);
     hp = HAlloc(BIF_P, 4);	/* {hour, minute, second}  + arity */
     BIF_RET(TUPLE3(hp, make_small(hour), make_small(minute),
		    make_small(second)));
}
返回当前时，分，秒时间。时区和夏令时的时间调整取决于底层的操作系统。

erlang:time().

----------
erlang:tl/1
获取一个列表的尾列表

用法：

tl(List1) -> List2
获取列表 List1 除去第一个元素之外的尾列表。如果列表是一个空列表 []，那么则返回一个原子 badarg。

tl([geesties, guilies, beasties]).

----------
erlang:trunc/1
截断一个数的小数部位

用法：

trunc(Number) -> integer()
截断一个数 Number 的小数部位。

trunc(5.5).

----------
erlang:tuple_size/1
返回一个元组的大小

用法：

tuple_size(Tuple) -> integer() >= 0
获取元组 Tuple 的元素个数。

tuple_size({morni, mulle, bwange}).

----------
erlang:tuple_to_list/1
把一个元组转为一个列表

用法：

tuple_to_list(Tuple) -> [term()]
把一个元组 Tuple 转为一个列表。元组里的元素可以是任何 Erlang 项值。

tuple_to_list({share, {'EriCSSon_B', 163}}).

----------
erlang:universaltime_to_localtime/1
把世界标准时间转为本地日期时间

用法：

universaltime_to_localtime(Universaltime) ->  Localtime
如果底层系统支持的话，该函数将协调世界时 (UTC) 日期时间转换为本地日期时间。否则，不会有任何转换操作，只返回传入的参数 Universaltime。

erlang:universaltime_to_localtime({{1996, 11, 6}, {14, 18, 43}}).
如果 Universaltime 并不是一个有效的日期时间，将返回 badarg 的错误。

erlang:universaltime_to_localtime({{996, 11, 6}, {14, 18, 43}}).

----------
erlang:unregister/1
去除一个进程或端口的注册名

用法：

unregister(RegName) -> true
去除一个进程或端口的注册名，如果注册名 RegName 没有被注册，则返回 undefined（不建议去除系统进程的注册名）。

erlang:unregister(test).

----------
erlang:whereis/1
通过给出的注册码获取一个进程或端口

用法：

whereis(RegName) -> pid() | port() | undefined
通过给出的注册名 RegName 获取一个进程或端口标识。

erlang:whereis(hd(erlang:registered())).
如果名字没有被注册，则返回 undefined。

erlang:whereis(genfsm_server).

----------
