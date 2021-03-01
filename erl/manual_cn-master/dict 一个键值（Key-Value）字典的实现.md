dict:append/3
在字典里给一个键附加上一个值

用法：

append(Key, Value, Dict1) -> Dict2
给当前列表跟 Key 相关联的值附加上一个新值 Value

D = dict:new(),
D1 = dict:append(a, b, D),
dict:to_list(D1).
D = dict:new(),
D1 = dict:append(a, b, D),
D2 = dict:append(a, c, D1),
dict:to_list(D2).
如果跟 Key 相关联的值不是一个列表值，将会抛出一个异常错误，例如下面这种情况

D = dict:from_list([{a, b}]),
dict:append(a, c, D).

----------
dict:append_list/3
在字典里给一个键附加上一个列表值

用法：

append_list(Key, ValList, Dict1) -> Dict2
跟 dict:append/3 一样，都是给当前列表跟 Key 相关联的值附加上一个新值，只不过新加的值是一个列表值 ValList

D = dict:new(),
D1 = dict:store(k, [v1], D),
D2 = dict:append_list(k, [v2, v3], D1),
dict:to_list(D2).
如果跟 Key 相关联的值不是一个列表值，将会抛出一个异常错误，例如下面这种情况

D = dict:from_list([{a, b}]),
dict:append(a, [c, d], D).

----------
dict:erase/2
从字典里删除一个键

用法：

erase(Key, Dict1) -> Dict2
内部实现：

-spec erase(Key, Dict1) -> Dict2 when
      Key :: term(),
      Dict1 :: dict(),
      Dict2 :: dict().
%%  Erase all elements with key Key.

erase(Key, D0) -> 
    Slot = get_slot(D0, Key),
    {D1,Dc} = on_bucket(fun (B0) -> erase_key(Key, B0) end,
			D0, Slot),
    maybe_contract(D1, Dc).

erase_key(Key, [?kv(Key,_Val)|Bkt]) -> {Bkt,1};
erase_key(Key, [E|Bkt0]) ->
    {Bkt1,Dc} = erase_key(Key, Bkt0),
    {[E|Bkt1],Dc};
erase_key(_, []) -> {[],0}.
删除字典里跟键 Key 相关联的所有项

D = dict:from_list([{k1, v1}, {k2, v2}, {k3, v3}]),
dict:to_list(dict:erase(k1, D)).

----------
dict:fetch/2
在字典里查找值

用法：

fetch(Key, Dict) -> Value
内部实现：

-spec fetch(Key, Dict) -> Value when
      Key :: term(),
      Dict :: dict(),
      Value :: term().

fetch(Key, D) ->
    Slot = get_slot(D, Key),
    Bkt = get_bucket(D, Slot),
    try fetch_val(Key, Bkt)
    catch
	badarg -> erlang:error(badarg, [Key, D])
    end.

fetch_val(K, [?kv(K,Val)|_]) -> Val;
fetch_val(K, [_|Bkt]) -> fetch_val(K, Bkt);
fetch_val(_, []) -> throw(badarg).
获取在字典 Dict 里跟键 Key 相关联的值

D = dict:from_list([{k1, v1}, {k2, v2}, {k3, v3}]),
dict:fetch(k1, D).
如果键 Key 不存在字典 Dict 里，则会抛出一个异常错误，例如以下这种情况

D = dict:from_list([{1, a}, {2, b}, {3, c}]),
case dict:fetch(4, D) of
    badarg ->
        not found;
    Value ->
        Value
end.

----------
dict:fetch_keys/1
获取字典里所有键

用法：

fetch_keys(Dict) -> Keys
内部实现：

-spec fetch_keys(Dict) -> Keys when
      Dict :: dict(),
      Keys :: [term()].

fetch_keys(D) ->
    fold(fun (Key, _Val, Keys) -> [Key|Keys] end, [], D).
以列表的形式返回字典里所有的键

D = dict:from_list([{k1, v1}, {k2, v2}, {k3, v3}]),
dict:fetch_keys(D).

----------
dict:filter/2
筛选断言为真的元素

用法：

filter(Predicate, Dict1) -> Dict2
字典 Dict1 里的每一个键值以参数的方式被断言函数 Predicate 调用，如果该键值在断言函数 Predicate 执行中返回的是 true，那么则留下，否则被丢弃，最终返回一个符合断言条件的字段 Dict2

D = dict:from_list([{k1, 1}, {k2, 2}, {k3, 3}, {k4, 4}]),
Predicate = fun(_K, V) -> V rem 2 == 0 end,
D1 = dict:filter(Predicate, D),
dict:to_list(D1).

----------
dict:find/2
在字典里查找值

用法：

find(Key, Dict) -> {ok, Value} | error
内部实现：

-spec find(Key, Dict) -> {'ok', Value} | 'error' when
      Key :: term(),
      Dict :: dict(),
      Value :: term().

find(Key, D) ->
    Slot = get_slot(D, Key),
    Bkt = get_bucket(D, Slot),
    find_val(Key, Bkt).

find_val(K, [?kv(K,Val)|_]) -> {ok,Val};
find_val(K, [_|Bkt]) -> find_val(K, Bkt);
find_val(_, []) -> error.
跟 dict:fetch/2 一样，都是查找返回一个在字典 Dict 里跟键 Key 相关联的值，不过返回的格式不一样

D = dict:from_list([{k1, v1}, {k2, v2}, {k3, v3}]),
dict:find(k1, D).
而且字典里没有相关联的键值存在不会抛异常错误，只返回一个原子 error

D = dict:from_list([{k1, v1}, {k2, v2}, {k3, v3}]),
dict:find(k4, D).

----------
dict:fold/3
调用函数对字典里的键值进行递归遍历操作

用法：

fold(Fun, Acc0, Dict) -> Acc1
内部实现：

-spec fold(Fun, Acc0, Dict) -> Acc1 when
      Fun :: fun((Key, Value, AccIn) -> AccOut),
      Dict :: dict(Key, Value),
      Acc0 :: Acc,
      Acc1 :: Acc,
      AccIn :: Acc,
      AccOut :: Acc.

%%  Fold function Fun over all "bags" in Table and return Accumulator.

fold(F, Acc, D) -> fold_dict(F, Acc, D).

fold_dict(F, Acc, D) ->
    Segs = D#dict.segs,
    fold_segs(F, Acc, Segs, tuple_size(Segs)).

fold_segs(F, Acc, Segs, I) when I >= 1 ->
    Seg = element(I, Segs),
    fold_segs(F, fold_seg(F, Acc, Seg, tuple_size(Seg)), Segs, I-1);
fold_segs(F, Acc, _, 0) when is_function(F, 3) -> Acc.

fold_seg(F, Acc, Seg, I) when I >= 1 ->
    fold_seg(F, fold_bucket(F, Acc, element(I, Seg)), Seg, I-1);
fold_seg(F, Acc, _, 0) when is_function(F, 3) -> Acc.

fold_bucket(F, Acc, [?kv(Key,Val)|Bkt]) ->
    fold_bucket(F, F(Key, Val, Acc), Bkt);
fold_bucket(F, Acc, []) when is_function(F, 3) -> Acc.
字典里的每一对键值跟一个临时累积参数（Acc0）一起被函数（Fun）调用，并返回一个新的累积器（Accumulator）以传给下一次函数调用，直到字典里所有的键值对都被函数（Fun）遍历调用完，最后返回一个累积结果值 Acc1。例如下面求字典里所有值的平方和：

D = dict:from_list([{k1, 1}, {k2, 2}, {k3, 3}]),
dict:fold(fun(_Key, Val, Acc) -> Val * Val + Acc end, 0, D).

----------
dict:from_list/1
把一个 Key-Value 形式的列表转换为一个字典

用法：

from_list(List) -> Dict
内部实现：

 -spec from_list(List) -> Dict when
      List :: [{Key :: term(), Value :: term()}],
      Dict :: dict().

from_list(L) ->
    lists:foldl(fun ({K,V}, D) -> store(K, V, D) end, new(), L).
把一个 Key-Value 形式的列表转换为一个字典

dict:from_list([{k1, v1}, {k2, v2}, {k3, v3}]).

----------
dict:is_empty/1
判断字典是否为空

用法：

is_empty(Dict) -> boolean()
内部实现：

-spec is_empty(Dict) -> boolean() when
      Dict :: dict().

is_empty(#dict{size=N}) -> N =:= 0.
如果字典 Dict 没有元素，则返回 true，否则返回 false。

Dict = dict:new(),
dict:is_empty(Dict).
Dict = dict:from_list([{k1, v1}, {k2, v2}, {k3, v3}]),
dict:is_empty(Dict).

----------
dict:is_key/2
判断键是否在字典里

用法：

is_key(Key, Dict) -> bool()
内部实现：

-spec is_key(Key, Dict) -> boolean() when
      Key :: term(),
      Dict :: dict().

is_key(Key, D) ->
    Slot = get_slot(D, Key),
    Bkt = get_bucket(D, Slot),
    find_key(Key, Bkt).

find_key(K, [?kv(K,_Val)|_]) -> true;
find_key(K, [_|Bkt]) -> find_key(K, Bkt);
find_key(_, []) -> false.
判读键 Key 是否在字典 Dict 里存在

D = dict:from_list([{k1, v1}, {k2, v2}, {k3, v3}]),
dict:is_key(k1, D).

----------
dict:map/2
对字典里的每一对键值遍历调用函数

用法：

map(Fun, Dict1) -> Dict2
对字典里的每一对键值遍历调用函数(Fun)，最终返回一个新的字典

D = dict:from_list([{k1, 1}, {k2, 2}, {k3, 3}]),
dict:map(fun(_Key, Val) -> Val * Val end, D).

----------
dict:merge/3
合并 2 个字典

用法：

merge(Fun, Dict1, Dict2) -> Dict3
内部实现：

-spec merge(Fun, Dict1, Dict2) -> Dict3 when
      Fun :: fun((Key :: term(), Value1 :: term(), Value2 :: term()) -> Value :: term()),
      Dict1 :: dict(),
      Dict2 :: dict(),
      Dict3 :: dict().

merge(F, D1, D2) when D1#dict.size 
    fold_dict(fun (K, V1, D) ->
		      update(K, fun (V2) -> F(K, V1, V2) end, V1, D)
	      end, D2, D1);
merge(F, D1, D2) ->
    fold_dict(fun (K, V2, D) ->
		      update(K, fun (V1) -> F(K, V1, V2) end, V2, D)
	      end, D1, D2).
把 2 个字典合并成为一个新的字典，原来字典的键值都会保留下来，如果存在相同的键，则调用合并函数（Fun）处理并返回一个新值。例如下面存在有键相同时，则把值相加：

D1 = dict:from_list([{k1, 1}, {k2, 2}, {k3, 3}]),
D2 = dict:from_list([{k1, 1}, {k2, 2}, {k3, 3}, {k4, 4}]),
MergeFun = fun(_Key, V1, V2) -> V1 + V2 end,
dict:to_list(dict:merge(MergeFun, D1, D2)).

----------
dict:new/0
初始构造一个新的字典

用法：

new() -> dictionary()
内部实现：

%% Define a hashtable.  The default values are the standard ones.
-record(dict,
	{size=0		      :: non_neg_integer(),   	% Number of elements
	 n=?seg_size	      :: non_neg_integer(),   	% Number of active slots
	 maxn=?seg_size	      :: non_neg_integer(),	% Maximum slots
	 bso=?seg_size div 2  :: non_neg_integer(),   	% Buddy slot offset
	 exp_size=?exp_size   :: non_neg_integer(),   	% Size to expand at
	 con_size=?con_size   :: non_neg_integer(),   	% Size to contract at
	 empty		      :: tuple(),		% Empty segment
	 segs		      :: tuple()	      	% Segments
	}).

-spec new() -> dict().
new() ->
    Empty = mk_seg(?seg_size),
    #dict{empty=Empty,segs={Empty}}.
初始构造一个新的字典

dict:new().

----------
dict:size/1
返回字典里键值对的个数

用法：

size(Dict) -> int()
内部实现：

-spec size(Dict) -> non_neg_integer() when
      Dict :: dict().

size(#dict{size=N}) when is_integer(N), N >= 0 -> N. 
返回字典里所存储的键值对的个数

dict:size(dict:from_list([{k1, v1}, {k2, v2}, {k3, v3}])).

----------
dict:store/3
在字典里存储一个值

用法：

store(Key, Value, Dict1) -> Dict2
以键值（Key - Value）对的形式存储在字典里。如果字典里已经存在 Key 的键，则把跟 Key 相关的值替换为 Value

D = dict:new(),
D1 = dict:store(k1, v1, D).
D = dict:new(),
D1 = dict:store(k1, v1, D),
D2 = dict:store(k2, v2, D1),
dict:to_list(dict:store(k2, v3, D2)).

----------
dict:to_list/1
把字典转换成一个列表形式

用法：

to_list(Dict) -> List
内部实现：

 -spec to_list(Dict) -> List when
      Dict :: dict(),
      List :: [{Key :: term(), Value :: term()}].

to_list(D) ->
    fold(fun (Key, Val, List) -> [{Key,Val}|List] end, [], D).
把字典转换成一个列表形式

D = dict:from_list([{k1, v1}, {k2, v2}, {k3, v3}]),
dict:to_list(D).

----------
dict:update/3
更新字典里的一个值

用法：

update(Key, Fun, Dict1) -> Dict2
通过调用更新函数（Fun）来更新指定键 Key 在字典里的值

D = dict:from_list([{k1, 1}, {k2, 2}]),
D1 = dict:update(k1, fun(V)-> V * 2 end, D),
dict:to_list(D1).
如果指定的键在字典里不存在的话，则报错

D = dict:from_list([{k1, 1}, {k2, 2}]),
D1 = dict:update(k3, fun(V)-> V * 2 end, D),
dict:to_list(D1).

----------
dict:update/4
更新字典里的一个值

用法：

update(Key, Fun, Initial, Dict1) -> Dict2
跟 dict:update/3 一样，通过调用更新函数（Fun）来更新指定键 Key 在字典里的值，不同的是，如果指定的键在字典里不存在的话，不会报异常错误，而是用给出的指定初始值（Initial）替换

D = dict:from_list([{k1, 1}, {k2, 2}]),
D1 = dict:update(k3, fun(V)-> V * 2 end, 3, D),
dict:to_list(D1).

----------
dict:update_counter/3
对字典里指定键的值进行相加操作

用法：

update_counter(Key, Increment, Dict1) -> Dict2
如果指定键 Key 在字典里存在，则指定键在字典里的值跟参数 Increment 进行相加操作

D = dict:from_list([{k1,1}]),
D1 = dict:update_counter(k1, 1, D),
dict:to_list(D1).
如果指定键在字典里不存在，则在字典里插入（store）一个 {Key, Increment} 的键值对

D = dict:from_list([{k1,1}]),
D1 = dict:update_counter(k2, 1, D),
dict:to_list(D1).

----------
