array:from_list/1
把一个列表转为一个可扩展的数组

用法：

from_list(List :: list()) -> array()
把一个列表转为一个可扩展的数组。如果列表 List 不是一个正确的列表，那么该次调用将以 badarg 的原因调用失败。用法跟 array:from_list(List, undefined) 一样。

array:from_list(["a", "b", "c"]).

----------
array:from_list/2
把一个列表转为一个可扩展的数组

用法：

from_list(List :: list(), Default :: term()) -> array()
把一个列表转为一个可扩展的数组。参数 Default 是用来作为数组未初始条目的值。如果列表 List 不是一个正确的列表，那么该次调用将以 badarg 的原因调用失败。

array:from_list(["a", "b", "c"], pink).

----------
array:from_orddict/1
把一个有序列表转为一个可扩展的数组

用法：

from_orddict(Orddict :: indx_pairs()) -> array()
把一个 {Index, Value} 对的有序列表转为一个相应的、可扩展的数组。如果 Orddict 不是一个正确的、列表键值对的第一个元素不是一个非负数的有序列表，那么该次调用将以 badarg 的原因调用失败。

array:from_orddict([{1, "a"}, {3, "b"}, {5, "c"}]).
array:from_orddict([{1, "a"}, {3, "b"}, {5, "c"}, {12, "k"}]).

----------
array:from_orddict/2
把一个有序列表转为一个可扩展的数组

用法：

from_orddict(Orddict :: indx_pairs(), Default :: term()) -> array()
把一个 {Index, Value} 对的有序列表转为一个相应的、可扩展的数组。参数 Default 是用来作为数组未初始条目的值。如果 Orddict 不是一个正确的、列表键值对的第一个元素不是一个非负数的有序列表，那么该次调用将以 badarg 的原因调用失败。

array:from_orddict([{1, "a"}, {3, "b"}, {5, "c"}], pink).
array:from_orddict([{1, "a"}, {3, "b"}, {5, "c"}, {12, "k"}], pink).

----------
array:get/2
获取数组指定条目的值

用法：

get(I :: array_indx(), Array :: array()) -> term()
获取数组第 I 个条目的值。如果 I 不是一个非负整数，或者数组是一个固定大小的数组且 I 大于数组的最大索引值，那么该次调用将以 badarg 的原因调用失败。

Array = array:from_list(["a", "b", "c"], pink),
array:get(2, Array).
如果数组的大小没有固定，那么索引值 I 大于数组本身大小（size(Array) - 1）的话，这个函数将返回数组的默认值。

Array = array:from_list(["a", "b", "c"], pink),
array:get(6, Array).

----------
array:is_array/1
是否一个数组

用法：

is_array(X :: term()) -> boolean()
内部实现：

-spec is_array(X :: term()) -> boolean().

is_array(#array{size = Size, max = Max})
  when is_integer(Size), is_integer(Max) ->
    true;
is_array(_) ->
    false.
判断参数 X 是否是一个数组，如果是则返回 true，否则返回 false。该检测只是一个简单的检测；它并不保证参数 X 是一个格式良好的数组形式，即使该函数返回的结果是 true。

Array = array:new(100, {default, 0}),
array:is_array(Array).
Array = [1, 2, 3],
array:is_array(Array).

----------
 is_fix/1 判断是否一个固定大小的数组
array:is_fix/1
判断是否一个固定大小的数组

用法：

is_fix(Array :: array()) -> boolean()
内部实现：

-spec is_fix(Array :: array()) -> boolean().

is_fix(#array{max = 0}) -> true;
is_fix(#array{}) -> false.
检测十足是否一个固定大小的数组，如果是则返回 true，否则返回 false。

Array = array:new([{fixed, true}]),
array:is_fix(Array).
Array = array:new([{fixed, false}]),
array:is_fix(Array).
Array = array:new(),
array:is_fix(Array).

----------
array:new/0
创建一个初始大小为 0 的新的可扩展的数组

用法：

new() -> array()
内部实现：

-spec new() -> array().

new() ->
    new([]).
创建一个初始大小为 0 的新的可扩展的数组。

array:new().

----------
array:new/1
根据给出的选项创建一个新的数组

用法：

new(Options :: array_opts()) -> array()
根据给出的选项创建一个新的数组。默认，数组是可扩展，并初始的大小是 0。数组的索引值开始是 0。

参数 Options 是一个单一的项或一个项列表，有一下选值：

N or {size, N}：N 是大于等于 0 的整数；表示初始数组的大小；跟 {fixed, true} 的作用一样。如果 N 不是一个非负的整数，该函数将以 badarg 的原因调用失败。
fixed or {fixed, true}：创建一个固定大小的数组。
{fixed, false}：创建一个可扩展的数组。
{default, Value}：把数组的默认值设置为 Value。
数据的选项以它们出现在列表里的顺序处理，即最后的选项具有更高的优先权。

默认值经常作为未初始的条目的值，并且一旦数组创建它们不能被改变。

创建一个大小为 100 的固定大小数组。

array:new(100).
创建一个空的、可扩展、默认值为 0 的数组。

array:new({default, 0}).
创建一个可扩展，初始大小是 10，且默认值为 -1 的数组。

array:new([{size, 10}, {fixed, false}, {default, -1}]).

----------
array:new/2
根据给出的选项创建一个新的数组

用法：

new(Size :: non_neg_integer(), Options :: array_opts()) -> array()
根据给定的大小和选项创建一个新的数组。如果 Size 不是一个非负的整数，那么该函数将以 badarg 的原因调用失败。默认，数组是固定大小的。参数 Options 里任何指定的数组大小选项都会覆盖参数 Size 的效用。

如果 Options 是一个列表，那么该函数的效用等同于 array:new([{size, Size} | Options]，否则等同于 array:new([{size, Size} | [Options]]。但是，使用这个函数是更有效率。

创建一个固定大小是 100，且默认是为 0 的数组。

array:new(100, {default, 0}).

----------
array:reset/2
把数组里某个指定项的值重置为默认值

用法：

reset(I :: array_indx(), Array :: array()) -> array()
内部实现：

-spec reset(I :: array_indx(), Array :: array()) -> array().

reset(I, #array{size = N, max = M, default = D, elements = E}=A) 
    when is_integer(I), I >= 0 ->
    if I 
	    try A#array{elements = reset_1(I, E, D)} 
	    catch throw:default -> A
	    end;
       M > 0 ->
	    A;
       true ->
	    erlang:error(badarg)
    end;
reset(_I, _A) ->
    erlang:error(badarg).

reset_1(I, E=?NODEPATTERN(S), D) ->
    I1 = I div S + 1,
    setelement(I1, E, reset_1(I rem S, element(I1, E), D));
reset_1(_I, E, _D) when is_integer(E) ->
    throw(default);
reset_1(I, E, D) ->
    Indx = I+1,
    case element(Indx, E) of
	D -> throw(default);
	_ -> setelement(I+1, E, D)
    end.
把数组里第 I 个项的值重置为默认值，如果第 I 个项的值是默认值，则不作任何改变。重置操作不会改变数组的大小。如果想改变数组的大小，可以调用 array:resize/2 函数。

如果参数 I 不是一个非负整数，或者数组是一个固定大小的数组，参数 I 的值大于数组的最大索引值，那么将返回 bagarg 的调用失败原因。

Array = array:from_list(["a", "b", "c"], pink),
array:reset(1, Array).

----------
array:set/3
设置数组条目的值

用法：

set(I :: array_indx(), Value :: term(), Array :: array()) -> array()
把数组 Array 第 I 个条目的值设置为 Value。如果 I 不是一个非负整数，或者数组是一个固定大小的数组且 I 大于数组的最大索引值，那么该次调用将以 badarg 的原因调用失败。

如果数组没有固定大小，且 I 大于数组本身的大小（size(Array) - 1），那么数组将把它的大小增加到 I + 1。

Array = array:from_list(["a", "b", "c"], pink),
array:set(2, apple, Array).
Array = array:from_list(["a", "b", "c"], pink),
array:set(12, apple, Array).
Array = array:from_list(["a", "b", "c"], pink),
array:set(7, apple, Array).

----------
array:size/1
获取数组的条目数量

用法：

size(Array :: array()) -> integer() >= 0
内部实现：

-spec size(Array :: array()) -> non_neg_integer().

size(#array{size = N}) -> N;
size(_) -> erlang:error(badarg).
获取数组的条目数量。条目的序号是从 0 到 size(Array) - 1；因此，这也是第一个条目的索引值，如果确保先前没有被设置的话。

Array = array:new(),
array:size(Array).
Array = array:from_list(["a", "b", "c"]),
array:size(Array).

----------
array:sparse_to_list/1
把数组转为一个列表

用法：

sparse_to_list(Array :: array()) -> list()
把数组 Array 转为一个列表，忽略掉值为默认值的条目。

Array = array:from_orddict([{1, "a"}, {3, "b"}, {5, "c"}], pink),
array:sparse_to_list(Array).
Array = array:new(10, {default, 0}),
array:sparse_to_list(Array).

----------
array:sparse_to_orddict/1
把数组转为一个有序的列表

用法：

sparse_to_orddict(Array :: array()) -> indx_pairs()
把数组 Array 转为一个 {Index, Value} 键值对的有序列表。忽略掉值为默认值的条目。

Array = array:from_orddict([{1, "a"}, {3, "b"}, {5, "c"}], pink),
array:sparse_to_orddict(Array).
Array = array:new(10, {default, 0}),
array:sparse_to_orddict(Array).

----------
array:to_list/1
把数组转为一个列表

用法：

to_list(Array :: array()) -> list().
把数组 Array 转为一个列表

Array = array:new(10, {default, 0}),
array:to_list(Array).
Array = array:from_orddict([{1, "a"}, {3, "b"}, {5, "c"}], pink),
array:to_list(Array).

----------
array:to_orddict/1
把数组转为一个有序的列表

用法：

to_orddict(Array :: array()) -> indx_pairs()
把数组 Array 转为一个 {Index, Value} 键值对的有序列表。

Array = array:new(10, {default, 0}),
array:to_orddict(Array).
Array = array:from_orddict([{1, "a"}, {3, "b"}, {5, "c"}], pink),
array:to_orddict(Array).
