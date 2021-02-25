gb_trees 通用平衡树（General Balanced

gb_trees:balance/1
对树进行平衡操作

用法：

balance(Tree1) -> Tree2
内部实现：

-spec balance(Tree1) -> Tree2 when
      Tree1 :: gb_tree(),
      Tree2 :: gb_tree().

balance({S, T}) ->
    {S, balance(T, S)}.

balance(T, S) ->
    balance_list(to_list_1(T), S).

balance_list(L, S) ->
    {T, []} = balance_list_1(L, S),
    T.

balance_list_1(L, S) when S > 1 ->
    Sm = S - 1,
    S2 = Sm div 2,
    S1 = Sm - S2,
    {T1, [{K, V} | L1]} = balance_list_1(L, S1),
    {T2, L2} = balance_list_1(L1, S2),
    T = {K, V, T1, T2},
    {T, L2};
balance_list_1([{Key, Val} | L], 1) ->
    {{Key, Val, nil, nil}, L};
balance_list_1(L, 0) ->
    {nil, L}.
对树 Tree1 进行重新平衡操作。这是一个很少需要用到的函数，但是当大量节点从树中被删除而之后没有往树里添加新数据时，那么调用这个函数是很有必要的。重新平衡的操作可以减少查找数据时的查询次数，因为删除操作不会对树进行重新平衡。

Tree1 = gb_trees:empty(),
Tree2 = gb_trees:enter(a, 1, Tree1),
gb_trees:balance(Tree2).

----------
gb_trees:delete/2
从树里删除一个节点

用法：

delete(Key, Tree1) -> Tree2
从树里删除跟键 Key 相关的节点，并返回一个新树。这里假设树里是存在这个键，否则将报错。

Tree1 = gb_trees:empty(),
Tree2 = gb_trees:enter(a, 1, Tree1),
gb_trees:delete(a, Tree2).

----------
gb_trees:delete_any/2
从树里删除一个节点

用法：

delete_any(Key, Tree1) -> Tree2
如果键 Key 在树里存在，则从树里删除跟键相关的节点；如果不存在，则不作任何操作；最后返回一个新的树。

Tree1 = gb_trees:empty(),
Tree2 = gb_trees:enter(a, 1, Tree1),
gb_trees:delete_any(a, Tree2).

----------
gb_trees:empty/0
获取一个新的空树

用法：

empty() -> gb_tree()
内部实现：

-spec empty() -> gb_tree().

empty() ->
    {0, nil}.
获取一个新的空树。

gb_trees:empty().

----------
gb_trees:enter/3
向树里插入（或更新）一个跟键相关的值

用法：

enter(Key, Val, Tree1) -> Tree2
如果键 Key 在树里不存在，则向树 Tree1 插入一个跟 Key 相关的值 Val，否则在树 Tree1 里更新跟 Key 相关的值为 Val。最后返回一个新树 Tree2。

Tree1 = gb_trees:empty(),
gb_trees:enter(a, 1, Tree1).
Tree1 = gb_trees:empty(),
Tree2 = gb_trees:enter(a, 1, Tree1),
gb_trees:enter(b, 2, Tree2).
Tree1 = gb_trees:empty(),
Tree2 = gb_trees:enter(a, 1, Tree1),
gb_trees:enter(a, 2, Tree2).

----------
gb_trees:from_orddict/1
把一个有序字典列表转为一个树

用法：

from_orddict(List) -> Tree
把一个 key-value 形式的有序字典列表转为一个树，这个列表不能包含重复的键。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
gb_trees:from_orddict(Orddict). 

----------
gb_trees:get/2
在树里查找一个键（如果存在的话）

用法：

get(Key, Tree) -> Val
内部实现：

%% This is a specialized version of 'lookup'.

-spec get(Key, Tree) -> Val when
      Key :: term(),
      Tree :: gb_tree(),
      Val :: term().

get(Key, {_, T}) ->
    get_1(Key, T).

get_1(Key, {Key1, _, Smaller, _}) when Key 
    get_1(Key, Smaller);
get_1(Key, {Key1, _, _, Bigger}) when Key > Key1 ->
    get_1(Key, Bigger);
get_1(_, {_, Value, _, _}) ->
    Value.
获取保存在树里的跟键 Key 相关的值。这里假设树里是存在这个键，否则将报错。

Tree1 = gb_trees:empty(),
Tree2 = gb_trees:enter(a, 1, Tree1),
gb_trees:get(a, Tree2).

----------
gb_trees:insert/3
向树里插入一个新的键和值

用法：

insert(Key, Val, Tree1) -> Tree2
向树 Tree1 里插入一个跟键 Key 相关联的值 Val，最后返回一个新的树 Tree2。这里假设树里不存在这个键，否则将报错。

Tree1 = gb_trees:empty(),
Tree2 = gb_trees:enter(a, 1, Tree1),
gb_trees:insert(b, 2, Tree2).

----------
gb_trees:is_defined/2
检测键是否在树里存在

用法：

is_defined(Key, Tree) -> boolean()
内部实现：

-spec is_defined(Key, Tree) -> boolean() when
      Key :: term(),
      Tree :: gb_tree().

is_defined(Key, {_, T}) ->
    is_defined_1(Key, T).

is_defined_1(Key, {Key1, _, Smaller, _}) when Key 
    is_defined_1(Key, Smaller);
is_defined_1(Key, {Key1, _, _, Bigger}) when Key > Key1 ->
    is_defined_1(Key, Bigger);
is_defined_1(_, {_, _, _, _}) ->
    true;
is_defined_1(_, nil) ->
    false.
检测键是否在树里存在，如果存在则返回 true，否则返回 false。

Tree1 = gb_trees:empty(),
Tree2 = gb_trees:enter(a, 1, Tree1),
gb_trees:is_defined(a, Tree2).

----------
gb_trees:is_empty/1
判断是否一个空树

用法：

is_empty(Tree) -> boolean()
内部实现：

-spec is_empty(Tree) -> boolean() when
      Tree :: gb_tree().

is_empty({0, nil}) ->
    true;
is_empty(_) ->
    false.
判断是否一个空树，如果是则返回 true，否则返回 false。

Tree1 = gb_trees:empty(),
gb_trees:is_empty(Tree1).
Tree1 = gb_trees:empty(),
Tree2 = gb_trees:enter(a, 1, Tree1),
gb_trees:is_empty(Tree2).

----------
gb_trees:iterator/1
返回一个树的迭代器

用法：

iterator(Tree) -> Iter
返回一个可以用来遍历整个树 Tree 的迭代器。这个函数的执行是很有效率的；使用 gb_trees:next/1 方法遍历整个树只比用 gb_trees:to_list/1 先把树里的所有元素转为列表再遍历稍微慢一些；迭代器的优势在于它不用每一次调用的时候把整个列表的所有元素都加载在内存里。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
Iterator = gb_trees:iterator(Tree),
gb_trees:next(Iterator).
Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
gb_trees:iterator(Tree).
Erlang 的通用平衡树 gb_trees 模块没有内置的遍历（fold）函数，不过可以利用迭代函数 gb_trees:iterator/1 和 gb_trees:next/1 来模拟遍历二叉树的功能。下面是遍历获取树里的每个键和值：

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
GBTreesFold = fun GBTreesFold(AccIterator, AccList) ->
    case gb_trees:next(AccIterator) of
        none ->
            AccList;
        {Key, Val, NewAccIterator} ->
            GBTreesFold(NewAccIterator, [{Key, Val} | AccList])
    end
end,
Iterator = gb_trees:iterator(Tree),
GBTreesFold(Iterator, []).

----------
gb_trees:keys/1
返回一个包含树里所有键的有序列表

用法：

keys(Tree) -> [Key]
返回一个包含树里所有键的有序列表。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
gb_trees:keys(Tree). 

----------
gb_trees:largest/1
返回最大的键和值

用法：

largest(Tree) -> {Key, Val}
内部实现：

-spec largest(Tree) -> {Key, Val} when
      Tree :: gb_tree(),
      Key :: term(),
      Val :: term().

largest({_, Tree}) ->
    largest_1(Tree).

largest_1({Key, Value, _Smaller, nil}) ->
    {Key, Value};
largest_1({_Key, _Value, _Smaller, Larger}) ->
    largest_1(Larger).
返回一个 {Key, Val} 的元组，Key 是树里最大的键，Val 是与键相关联的值（这里假设这里树不是一个空树）。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
gb_trees:largest(Tree).

----------
gb_trees:lookup/2
在树里查找一个值

用法：

lookup(Key, Tree) -> none | {value, Val}
内部实现：

-spec lookup(Key, Tree) -> 'none' | {'value', Val} when
      Key :: term(),
      Val :: term(),
      Tree :: gb_tree().

lookup(Key, {_, T}) ->
    lookup_1(Key, T).

%% The term order is an arithmetic total order, so we should not
%% test exact equality for the keys. (If we do, then it becomes
%% possible that neither '>', '' first is statistically better than testing for
%% equality, and also allows us to skip the test completely in the
%% remaining case.

lookup_1(Key, {Key1, _, Smaller, _}) when Key 
    lookup_1(Key, Smaller);
lookup_1(Key, {Key1, _, _, Bigger}) when Key > Key1 ->
    lookup_1(Key, Bigger);
lookup_1(_, {_, Value, _, _}) ->
    {value, Value};
lookup_1(_, nil) ->
    none.
在树里查找一个跟键 Key 相关的值，如果存在，则返回 {value, Val}，否则返回 none。

Tree1 = gb_trees:empty(),
Tree2 = gb_trees:enter(a, 1, Tree1),
gb_trees:lookup(a, Tree2).
Tree1 = gb_trees:empty(),
gb_trees:lookup(a, Tree1).

----------
gb_trees:map/2
树里的每一个键值对都调用执行一次函数

用法：

map(Function, Tree1) -> Tree2
内部实现：

-spec map(Function, Tree1) -> Tree2 when
      Function :: fun((K :: term(), V1 :: term()) -> V2 :: term()),
      Tree1 :: gb_tree(),
      Tree2 :: gb_tree().

map(F, {Size, Tree}) when is_function(F, 2) ->
    {Size, map_1(F, Tree)}.

map_1(_, nil) -> nil;
map_1(F, {K, V, Smaller, Larger}) ->
    {K, F(K, V), map_1(F, Smaller), map_1(F, Larger)}.
树 Tree1 里的每一个键值对都调用执行一次 Function 函数，最后返回跟树 Tree1 有同键和新值的一个新树 Tree2。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
Fun = fun(K, V) -> lists:concat([K, "+", V]) end,
gb_trees:map(Fun, Tree).

----------
gb_trees:next/1
使用迭代器获取树的下一个节点

用法：

next(Iter1) -> none | {Key, Val, Iter2}
这个函数是通过调用 gb_trees:iterator/1 返回的迭代器 Iter1，来获取树里的键值。调用获取到的是一个 {Key, Val, Iter2} 格式的元组，Key 是迭代器引用 Iter1 最小的键，Val 就是跟键 Key 相关联的值，Iter2 是一个用来遍历剩下节点的新的迭代器。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
Iterator = gb_trees:iterator(Tree),
{Key, Val, NewIterator} = gb_trees:next(Iterator).
如果没有剩下节点，则返回一个原子 none。

Orddict = orddict:from_list([{pear, 7}]),
Tree = gb_trees:from_orddict(Orddict),
Iterator = gb_trees:iterator(Tree),
{_Key, _Val, NewIterator} = gb_trees:next(Iterator),
gb_trees:next(NewIterator).
Tree = gb_trees:empty(),
Iterator = gb_trees:iterator(Tree),
gb_trees:next(Iterator).

----------
gb_trees:size/1
返回树的节点数量

用法：

size(Tree) -> integer() >= 0
内部实现：

-spec size(Tree) -> non_neg_integer() when
      Tree :: gb_tree().

size({Size, _}) when is_integer(Size), Size >= 0 ->
    Size.
返回树的节点数量。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
gb_trees:size(Tree).

----------
gb_trees:smallest/1
返回最小的键和值

用法：

smallest(Tree) -> {Key, Val}
内部实现：

-spec smallest(Tree) -> {Key, Val} when
      Tree :: gb_tree(),
      Key :: term(),
      Val :: term().

smallest({_, Tree}) ->
    smallest_1(Tree).

smallest_1({Key, Value, nil, _Larger}) ->
    {Key, Value};
smallest_1({_Key, _Value, Smaller, _Larger}) ->
    smallest_1(Smaller).
返回一个 {Key, Val} 的元组，Key 是树里最小的键，Val 是与键相关联的值（这里假设这里树不是一个空树）。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
gb_trees:smallest(Tree).

----------
gb_trees:take_largest/1
从树里提取最大的元素

用法：

take_largest(Tree1) -> {Key, Val, Tree2}
内部实现：

-spec take_largest(Tree1) -> {Key, Val, Tree2} when
      Tree1 :: gb_tree(),
      Tree2 :: gb_tree(),
      Key :: term(),
      Val :: term().

take_largest({Size, Tree}) when is_integer(Size), Size >= 0 ->
    {Key, Value, Smaller} = take_largest1(Tree),
    {Key, Value, {Size - 1, Smaller}}.

take_largest1({Key, Value, Smaller, nil}) ->
    {Key, Value, Smaller};
take_largest1({Key, Value, Smaller, Larger}) ->
    {Key1, Value1, Larger1} = take_largest1(Larger),
    {Key1, Value1, {Key, Value, Smaller, Larger1}}.
返回一个 {Key, Val, Tree2} 的元组，Key 是树 Tree1 里最大的键，Val 是跟键 Key 相关联的值，Tree2 是删去该键相应节点后的树（这里假设该树不是一个空树）。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
gb_trees:take_largest(Tree).

----------
gb_trees:take_smallest/1
从树里提取最小的元素

用法：

take_smallest(Tree1) -> {Key, Val, Tree2}
内部实现：

-spec take_smallest(Tree1) -> {Key, Val, Tree2} when
      Tree1 :: gb_tree(),
      Tree2 :: gb_tree(),
      Key :: term(),
      Val :: term().

take_smallest({Size, Tree}) when is_integer(Size), Size >= 0 ->
    {Key, Value, Larger} = take_smallest1(Tree),
    {Key, Value, {Size - 1, Larger}}.

take_smallest1({Key, Value, nil, Larger}) ->
    {Key, Value, Larger};
take_smallest1({Key, Value, Smaller, Larger}) ->
    {Key1, Value1, Smaller1} = take_smallest1(Smaller),
    {Key1, Value1, {Key, Value, Smaller1, Larger}}.
返回一个 {Key, Val, Tree2} 的元组，Key 是树 Tree1 里最小的键，Val 是跟键 Key 相关联的值，Tree2 是删去该键相应节点后的树（这里假设该树不是一个空树）。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
gb_trees:take_smallest(Tree).

----------
gb_trees:to_list/1
把一个树转为一个列表

用法：

to_list(Tree) -> [{Key, Val}]
内部实现：

-spec to_list(Tree) -> [{Key, Val}] when
      Tree :: gb_tree(),
      Key :: term(),
      Val :: term().
			   
to_list({_, T}) ->
    to_list(T, []).

to_list_1(T) -> to_list(T, []).

to_list({Key, Value, Small, Big}, L) ->
    to_list(Small, [{Key, Value} | to_list(Big, L)]);
to_list(nil, L) -> L.
把一个树 Tree 转为一个 key-value 的元组形式的列表。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
gb_trees:to_list(Tree).

----------
gb_trees:update/3
更新树里键的值

用法：

update(Key, Val, Tree1) -> Tree2
内部实现：

-spec update(Key, Val, Tree1) -> Tree2 when
      Key :: term(),
      Val :: term(),
      Tree1 :: gb_tree(),
      Tree2 :: gb_tree().

update(Key, Val, {S, T}) ->
    T1 = update_1(Key, Val, T),
    {S, T1}.

%% See 'lookup' for notes on the term comparison order.

update_1(Key, Value, {Key1, V, Smaller, Bigger}) when Key  
    {Key1, V, update_1(Key, Value, Smaller), Bigger};
update_1(Key, Value, {Key1, V, Smaller, Bigger}) when Key > Key1 ->
    {Key1, V, Smaller, update_1(Key, Value, Bigger)};
update_1(Key, Value, {_, _, Smaller, Bigger}) ->
    {Key, Value, Smaller, Bigger}.
把树 Tree1 里键 Key 的值更为 Val，最后返回一个新树 Tree2（这里假设该键在树里存在）。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
gb_trees:update(apple, 10, Tree).

----------
gb_trees:values/1
返回一个包含树里所有值的有序列表

用法：

values(Tree) -> [Val]
返回一个包含树里所有值的有序列表，值的排列由他们相应的键决定，重复值不会被删除。

Orddict = orddict:from_list([{pear, 7}, {orange, 5}, {apple, 2}]),
Tree = gb_trees:from_orddict(Orddict),
gb_trees:values(Tree).

----------
