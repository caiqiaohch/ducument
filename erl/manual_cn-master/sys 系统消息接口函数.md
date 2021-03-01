sys:get_status/1
获取进程状态信息

用法：

get_status(Name) -> Status
获取进程的状态信息。

不同类型的进程返回的值也不同。例如，一个 gen_server 类型的进程返回的是回调模块的 State 信息，一个 gen_fsm 类型的进程返回的也是当前 State 信息。gen_server 和 gen_fsm 的回调模块可以通过 gen_server:format_status/2 或 gen_fsm:format_status/2 函数定制返回的值，从而有助于获取模块的特殊信息。

RegisteredList = erlang:registered(),
RegisteredListLen = length(RegisteredList),
ranDOM:seed(erlang:now()),
Rand = random:uniform(RegisteredListLen),
RegisterName = lists:nth(Rand, RegisteredList),
sys:get_status(RegisterName).

----------
sys:get_status/2
获取进程状态信息

用法：

get_status(Name, Timeout) -> Status
获取进程的状态信息，参数 Timeout 表示该操作的超时时间。

不同类型的进程返回的值也不同。例如，一个 gen_server 类型的进程返回的是回调模块的 State 信息，一个 gen_fsm 类型的进程返回的也是当前 State 信息。gen_server 和 gen_fsm 的回调模块可以通过 gen_server:format_status/2 或 gen_fsm:format_status/2 函数定制返回的值，从而有助于获取模块的特殊信息。

RegisteredList = erlang:registered(),
RegisteredListLen = length(RegisteredList),
ranDOM:seed(erlang:now()),
Rand = random:uniform(RegisteredListLen),
RegisterName = lists:nth(Rand, RegisteredList),
sys:get_status(RegisterName, 5000).

----------
sys:log/2
记录在内存里的系统事件

用法：

log(Name, Flag) -> `ok` | {`ok`, [system_event()]}
打开或关闭记录系统事件。如果打开，事件将保存在系统的调试结构里（默认最大保存 10 条）。如果参数 Flag 为 get，则返回一个事件记录的列表。如果参数 Flag 为 print，记录的事件将在标准输出端里输出。事件的格式是有产生事件的进程定义（通过调用 sys:handle_debug/4）。

sys:log(genfsm_server, true).
sys:log(genfsm_server, get).
sys:log(genfsm_server, print).
sys:log(genfsm_server, false).

----------
sys:log/3
记录在内存里的系统事件

用法：

log(Name, Flag, Timeout) -> `ok` | {`ok`, [system_event()]}
打开或关闭记录系统事件。如果打开，事件将保存在系统的调试结构里（默认最大保存 10 条）。如果参数 Flag 为 get，则返回一个事件记录的列表。如果参数 Flag 为 print，记录的事件将在标准输出端里输出。事件的格式是有产生事件的进程定义（通过调用 sys:handle_debug/4）。

参数 Timeout 是该操作的超时时间。

sys:log(genfsm_server, true, 5000).
sys:log(genfsm_server, get, 5000).
sys:log(genfsm_server, print, 5000).
sys:log(genfsm_server, false, 5000).

----------
sys:statistics/2
允许或禁止收集统计数据

用法：

statistics(Name, Flag) -> ok | {ok, Statistics}
允许或禁止收集统计数据。

参数 Flag 的取值有：

true：允许收集统计
get：获取收集的统计信息
false：禁止收集统计
RegisteredList = erlang:registered(),
RegisteredListLen = length(RegisteredList),
ranDOM:seed(erlang:now()),
Rand = random:uniform(RegisteredListLen),
RegisterName = lists:nth(Rand, RegisteredList),
sys:statistics(RegisterName, true).
RegisteredList = erlang:registered(),
RegisteredListLen = length(RegisteredList),
random:seed(erlang:now()),
Rand = random:uniform(RegisteredListLen),
RegisterName = lists:nth(Rand, RegisteredList),
sys:statistics(RegisterName, get).
RegisteredList = erlang:registered(),
RegisteredListLen = length(RegisteredList),
random:seed(erlang:now()),
Rand = random:uniform(RegisteredListLen),
RegisterName = lists:nth(Rand, RegisteredList),
sys:statistics(RegisterName, false).

----------
sys:statistics/3
允许或禁止收集统计数据

用法：

statistics(Name, Flag, Timeout) -> ok | {ok, Statistics}
允许或禁止收集统计数据，参数 Timeout 表示该操作的超时时间。

参数 Flag 的取值有：

true：允许收集统计
get：获取收集的统计信息
false：禁止收集统计
RegisteredList = erlang:registered(),
RegisteredListLen = length(RegisteredList),
ranDOM:seed(erlang:now()),
Rand = random:uniform(RegisteredListLen),
RegisterName = lists:nth(Rand, RegisteredList),
sys:statistics(RegisterName, true, 5000).
RegisteredList = erlang:registered(),
RegisteredListLen = length(RegisteredList),
random:seed(erlang:now()),
Rand = random:uniform(RegisteredListLen),
RegisterName = lists:nth(Rand, RegisteredList),
sys:statistics(RegisterName, get, 5000).
RegisteredList = erlang:registered(),
RegisteredListLen = length(RegisteredList),
random:seed(erlang:now()),
Rand = random:uniform(RegisteredListLen),
RegisterName = lists:nth(Rand, RegisteredList),
sys:statistics(RegisterName, false, 5000).

----------
sys:suspend/1
暂停一个进程

用法：

suspend(Name) -> `ok`
暂停一个进程。当进程被暂停，它只将对其他系统的消息有反应，而不是其他消息。

sys:suspend(genfsm_server).

----------
sys:suspend/2
暂停一个进程

用法：

suspend(Name, Timeout) -> `ok`
暂停一个进程。当进程被暂停，它只将对其他系统的消息有反应，而不是其他消息。参数 Timeout 是该操作的超时时间。

sys:suspend(genfsm_server, 5000).

----------
sys:trace/2
在标准输出端上打印所有系统事件信息

用法：

trace(Name, Flag) -> ok
内部实现：

&nbsp;
在标准输出端上打印所有系统事件信息。事件会被一个函数格式，该函数是由产生事件的进程定义。

RegisterName = hd(erlang:registered()),
sys:trace(RegisterName, true).
RegisterName = hd(erlang:registered()),
sys:trace(RegisterName, false).

----------
sys:trace/3
在标准输出端上打印所有系统事件信息

用法：

trace(Name, Flag, Timeout) -> ok
在标准输出端上打印所有系统事件信息，参数 Timeout 表示该操作的超时时间。事件会被一个函数格式，该函数是由产生事件的进程定义。

RegisterName = hd(erlang:registered()),
sys:trace(RegisterName, true, 5000).
RegisterName = hd(erlang:registered()),
sys:trace(RegisterName, false, 5000).

----------
