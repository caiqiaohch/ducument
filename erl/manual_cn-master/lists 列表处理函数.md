lists 列表处理函数

lists:all/2
如果列表里的所有元素都满足条件则返回 true

用法：

all(Predicate, List) -> bool()
内部实现：

-spec all(Pred, List) -> boolean() when
      Pred :: fun((Elem :: T) -> boolean()),
      List :: [T],
      T :: term().

all(Pred, [Hd|Tail]) ->
    case Pred(Hd) of
	true -> all(Pred, Tail);
	false -> false
    end;
all(Pred, []) when is_function(Pred, 1) -> true. 
列表里的每一个元素以参数的方式被断言函数 Predicate 调用，并返回一个布尔值 true 或 false，如果所有元素执行的结果都是 true，那么函数 lists:all/2 返回 true，否则返回 false。

例如下面的 Predicate 函数是判断参数 E 是不是一个偶数，如果列表里的每个元素都是偶数，那么 lists:all/2 函数返回 true，否则返回 false：

Predicate = fun(E) -> E rem 2 == 0 end, 
lists:all(Predicate, [2, 4, 6, 8]).

----------
lists:any/2
如果列表里的某一个元素满足条件则返回 true

用法：

any(Predicate, List) -> bool()
内部实现：

-spec any(Pred, List) -> boolean() when
      Pred :: fun((Elem :: T) -> boolean()),
      List :: [T],
      T :: term().

any(Pred, [Hd|Tail]) ->
    case Pred(Hd) of
	true -> true;
	false -> any(Pred, Tail)
    end;
any(Pred, []) when is_function(Pred, 1) -> false. 
跟 lists:all 一样，列表里的每个元素给 Predicate 断言函数调用，并返回一个布尔值 true 或 false，不同的是，如果调用返回的结果中至少有一个是 true，那么函数 lists:any/2 返回 true，否则返回 false

Predicate = fun(E) -> E rem 2 == 0 end,
lists:any(Predicate, [3, 5, 6, 9]).

----------
lists:append/1
附加连接列表集里的每一个子列表

用法：

append(ListOfLists) -> List1
内部实现：

%% append(L) appends the list of lists L

-spec append(ListOfLists) -> List1 when
      ListOfLists :: [List],
      List :: [T],
      List1 :: [T],
      T :: term().

append([E]) -> E;
append([H|T]) -> H ++ append(T);
append([]) -> [].
把 ListOfLists 里的每一个子列表按顺序附加连接成一个新列表

lists:append([[1, 2, 3], [a, b], "just a test"]).

----------
lists:append/2
合并 2 个列表

用法：

append(List1, List2) -> List3
内部实现：

%% append(X, Y) appends lists X and Y

-spec append(List1, List2) -> List3 when
      List1 :: [T],
      List2 :: [T],
      List3 :: [T],
      T :: term().

append(L1, L2) -> L1 ++ L2.
返回一个由 List1 和 List2 合并而成的新列表 List3。由其内部实现可知，效果跟 List1 ++ List2 一样。

lists:append("Just ", "a test!").
fun lists:append/2([1, 2], [3, 4]).

----------
lists:concat/1
合并为一个文本形式的列表

用法：

concat(Things) -> string()
内部实现：

%% concat(L) concatenate the list representation of the elements
%%  in L - the elements in L can be atoms, numbers of strings.
%%  Returns a list of characters.

-spec concat(Things) -> string() when
      Things :: [Thing],
      Thing :: atom() | integer() | float() | string().

concat(List) ->
    flatmap(fun thing_to_list/1, List).

thing_to_list(X) when is_integer(X) -> integer_to_list(X);
thing_to_list(X) when is_float(X)   -> float_to_list(X);
thing_to_list(X) when is_atom(X)    -> atom_to_list(X);
thing_to_list(X) when is_list(X)    -> X.	%Assumed to be a string
把列表 Things 里的每个元素合并成一个文本字符表示的新列表，列表 Things 里的元素可以是原子，整数，浮点数，字符串

lists:concat(['/erlang/R', 16, "B/lib/erlang/lib/stdlib", "-", "1.19.1/src/lists", '.', erl]).

----------
lists:delete/2
从列表里面删除一个元素

用法：

delete(Element, List) -> List2
内部实现：

%% delete(Item, List) -> List'
%%  Delete the first occurrence of Item from the list L.

-spec delete(Elem, List1) -> List2 when
      Elem :: T,
      List1 :: [T],
      List2 :: [T],
      T :: term().

delete(Item, [Item|Rest]) -> Rest;
delete(Item, [H|Rest]) -> 
    [H|delete(Item, Rest)];
delete(_, []) -> [].
删除列表 List 里的一个元素 Element，只删除第一出现的元素，不会删除相同的元素

lists:delete(a, [a, a, b, c, d]).
lists:delete({3, 4}, [{1, 2}, {3,4}, {5, 6}, {7, 8}, {9, 10}]).

----------
lists:droplast/1
删除列表中的最后一个元素

用法：

droplast(List) -> InitList
内部实现：

-spec droplast(List) -> InitList when
      List :: [T, ...],
      InitList :: [T],
      T :: term().

%% This is the simple recursive implementation
%% reverse(tl(reverse(L))) is faster on average,
%% but creates more garbage.
droplast([_T])  -> [];
droplast([H|T]) -> [H|droplast(T)].
删除列表 List 中的最后一个元素。

lists:droplast([1, 2, 3, 4, 5]).
该列表不能为空列表，否则会报一个 function_clause 的错误。

lists:droplast([]).

----------
lists:dropwhile/2
当断言为真则从列表里丢弃该元素

用法：

dropwhile(Predicate, List1) -> List2
内部实现：

-spec dropwhile(Pred, List1) -> List2 when
      Pred :: fun((Elem :: T) -> boolean()),
      List1 :: [T],
      List2 :: [T],
      T :: term().

dropwhile(Pred, [Hd|Tail]=Rest) ->
    case Pred(Hd) of
	true -> dropwhile(Pred, Tail);
	false -> Rest
    end;
dropwhile(Pred, []) when is_function(Pred, 1) -> [].
列表 List1 里的每一个元素以参数的方式被函数 Predicate 调用，如果元素在函数 Predicate 中的执行结果是 true，则丢弃该元素，接着继续调用下一个元素；如果执行的结果是 false，则立刻结束，并返回一个由剩下的元素组成的列表。

lists:dropwhile(fun(E) -> E =

----------
lists:duplicate/2
返回一个由 N 个元素副本组成的列表

用法：

duplicate(N, Element) -> List
内部实现：

%% duplicate(N, X) -> [X,X,X,.....,X]  (N times)
%%   return N copies of X

-spec duplicate(N, Elem) -> List when
      N :: non_neg_integer(),
      Elem :: T,
      List :: [T],
      T :: term().

duplicate(N, X) when is_integer(N), N >= 0 -> duplicate(N, X, []).

duplicate(0, _, L) -> L;
duplicate(N, X, L) -> duplicate(N-1, X, [X|L]).
返回一个包含 N 个元素 Element 副本的列表

lists:duplicate(5, elem_copy).

----------
lists:filter/2
选择符合满足断言条件的元素

用法：

filter(Predicate, List1) -> List2
内部实现：

 -spec filter(Pred, List1) -> List2 when
      Pred :: fun((Elem :: T) -> boolean()),
      List1 :: [T],
      List2 :: [T],
      T :: term().

filter(Pred, List) when is_function(Pred, 1) ->
    [ E || E 
列表 List1 里的每一个元素以参数的方式被断言函数 Predicate 调用，如果该元素在断言函数 Predicate 执行中返回的是 true，那么则留下，否则被丢弃，最终返回一个符合断言条件的元素的列表。

Predicate = fun(E) -> E rem 2 == 0 end, 
lists:filter(Predicate, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).

----------
lists:filtermap/2
过滤并映射操作符合函数条件的元素

用法：

filtermap(Fun, List1) -> List2
内部实现：

-spec filtermap(Fun, List1) -> List2 when
      Fun :: fun((Elem) -> boolean() | {'true', Value}),
      List1 :: [Elem],
      List2 :: [Elem | Value],
      Elem :: term(),
      Value :: term().

filtermap(F, [Hd|Tail]) ->
    case F(Hd) of
	true ->
	    [Hd|filtermap(F, Tail)];
	{true,Val} ->
	    [Val|filtermap(F, Tail)];
	false ->
	    filtermap(F, Tail)
    end;
filtermap(F, []) when is_function(F, 1) -> [].
连续用函数 Fun(Elem) 调用列表 List1 里的元素 Elem。函数 Fun 必须返回一个布尔值或一个 {true, Value} 的元组。该函数返回的列表里的元素就是函数 Fun 调用后返回的新值，即被符合函数 Fun 调用返回 true 或 {true，Elem} 的值。

Fun = fun(X) -> 
    case X rem 2 of 
        0 -> 
            {true, X div 2}; 
        _ -> 
            false 
    end 
end,
lists:filtermap(Fun, [1,2,3,4,5]).
该函数可以这样定义：

filtermap(Fun, List1) ->
    lists:foldr(fun(Elem, Acc) ->
                       case Fun(Elem) of
                           false -> Acc;
                           true -> [Elem|Acc];
                           {true,Value} -> [Value|Acc]
                       end,
                end, [], List1).



----------
lists:flatlength/1
获取一个多层嵌套列表的长度

用法：

flatlength(DeepList) -> int()
内部实现：

 %% flatlength(List)
%%  Calculate the length of a list of lists.

-spec flatlength(DeepList) -> non_neg_integer() when
      DeepList :: [term() | DeepList].

flatlength(List) ->
    flatlength(List, 0).

flatlength([H|T], L) when is_list(H) ->
    flatlength(H, flatlength(T, L));
flatlength([_|T], L) ->
    flatlength(T, L + 1);
flatlength([], L) -> L.
获取一个多层嵌套列表的长度，即该嵌套列表里的非列表元素的个数，等同于调用 length(flatten(DeepList))

lists:flatlength([[1], [2], 3, [4, [5, 6, [7, 8]]]]).

----------

lists:flatmap/2
对映射 map 调用返回的列表进行附加 append 操作

用法：

flatmap(Fun, List1) -> List2
内部实现：

-spec flatmap(Fun, List1) -> List2 when
      Fun :: fun((A) -> [B]),
      List1 :: [A],
      List2 :: [B],
      A :: term(),
      B :: term().

flatmap(F, [Hd|Tail]) ->
    F(Hd) ++ flatmap(F, Tail);
flatmap(F, []) when is_function(F, 1) -> [].
列表 List1 里的每一个元素以参数的方式被函数 Fun 调用，并把调用返回的列表进行 "++" 合并操作，最终返回一个列表。其效用跟 lists:append(lists:map(Fun, List1)) 一样。

lists:flatmap(fun(X)->[X, X] end, [a, b, c])

----------
lists:flatten/1
将多层嵌套列表转为单层列表

用法：

flatten(DeepList) -> List
内部实现：

 %% flatten(List)
%% flatten(List, Tail)
%%  Flatten a list, adding optional tail.

-spec flatten(DeepList) -> List when
      DeepList :: [term() | DeepList],
      List :: [term()].

flatten(List) when is_list(List) ->
    do_flatten(List, []).

do_flatten([H|T], Tail) when is_list(H) ->
    do_flatten(H, do_flatten(T, Tail));
do_flatten([H|T], Tail) ->
    [H|do_flatten(T, Tail)];
do_flatten([], Tail) ->
    Tail.
将多层嵌套列表转为一个单层列表

lists:flatten([[1], [2], 3, [4, [5, 6, [7, 8]]]]).
Term = {1, a, [2, 3]},
lists:flatten(io_lib:format("~p", [Term])).

----------
lists:flatten/2
将多层嵌套列表转为单层列表

用法：

flatten(DeepList, Tail) -> List
内部实现：

 -spec flatten(DeepList, Tail) -> List when
      DeepList :: [term() | DeepList],
      Tail :: [term()],
      List :: [term()].

flatten(List, Tail) when is_list(List), is_list(Tail) ->
    do_flatten(List, Tail).

do_flatten([H|T], Tail) when is_list(H) ->
    do_flatten(H, do_flatten(T, Tail));
do_flatten([H|T], Tail) ->
    [H|do_flatten(T, Tail)];
do_flatten([], Tail) ->
    Tail.
跟 lists:flatten/1 一样，都是把多层嵌套列表转为单层列表，只是多了一个在后面加上的尾列表 Tail

Tail = [9, 10],
lists:flatten([[1], [2], 3, [4, [5, 6, [7, 8]]]], Tail).

----------
lists:foldl/3
列表里的元素递归调用函数

用法：

foldl(Fun, Acc0, List) -> Acc1
内部实现：

-spec foldl(Fun, Acc0, List) -> Acc1 when
      Fun :: fun((Elem :: T, AccIn) -> AccOut),
      Acc0 :: term(),
      Acc1 :: term(),
      AccIn :: term(),
      AccOut :: term(),
      List :: [T],
      T :: term().

foldl(F, Accu, [Hd|Tail]) ->
    foldl(F, F(Hd, Accu), Tail);
foldl(F, Accu, []) when is_function(F, 2) -> Accu.
列表 List 里的每一个元素按从左向右的顺序，依次跟一个累积器（accumulator）参数 Acc0 作为 Fun 的参数被调用执行，并返回一个新的累积器 Acc1 跟列表的下一个元素调用，直到调用完列表里的所有元素，最终返回累积器 Acc 的结果值。

lists:foldl(fun(X, Sum) -> X + Sum end, 0, [1, 2, 3, 4, 5]).
lists:foldl(fun(X, {Prod1, Prod2}) -> {X + Prod1, X * Prod2} end, {0, 1}, [1, 2, 3, 4, 5]).

----------
lists:foreach/2
列表里的每一个元素被函数调用

用法：

foreach(Fun, List) -> void()
内部实现：

-spec foreach(Fun, List) -> ok when
      Fun :: fun((Elem :: T) -> term()),
      List :: [T],
      T :: term().

foreach(F, [Hd|Tail]) ->
    F(Hd),
    foreach(F, Tail);
foreach(F, []) when is_function(F, 1) -> ok.
列表 List 里的每一个元素按从左向右的顺序被函数 Fun 调用，最后返回一个原子 ok。

lists:foreach(fun(E) -> E * E end, [1, 2, 3, 4, 5]).
try
    lists:foreach(
        fun(5) ->
                5 * 5,
                throw(foreach_done);
            (E) ->
                E * E
        end, 
        [1, 2, 3, 4, 5])
catch
    throw:foreach_done ->
        foreach_done
end.

----------
lists:keydelete/3
从元组列表里删除一个元素

用法：

keydelete(Key, N, TupleList1) -> TupleList2
内部实现：

-spec keydelete(Key, N, TupleList1) -> TupleList2 when
      Key :: term(),
      N :: pos_integer(),
      TupleList1 :: [Tuple],
      TupleList2 :: [Tuple],
      Tuple :: tuple().

keydelete(K, N, L) when is_integer(N), N > 0 ->
    keydelete3(K, N, L).

keydelete3(Key, N, [H|T]) when element(N, H) == Key -> T;
keydelete3(Key, N, [H|T]) ->
    [H|keydelete3(Key, N, T)];
keydelete3(_, _, []) -> [].
从元组列表 TupleList1 里删除元组的第 N 个值跟 Key 是一样的元素，只删除第一个匹配的元素，后面有相同的不做处理， 最后返回处理过的新列表 TupleList2

TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
lists:keydelete(b, 1, TupleList).

----------
lists:keyfind/3
在一个元组列表里查找一个元素

用法：

keyfind(Key, N, TupleList) -> Tuple | false
从元组列表 TupleList 里查找元组的第 N 个值跟 Key 是一样的元素。

TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
lists:keyfind(b, 1, TupleList).
只找第一个匹配到的元素，后面有相同的不做处理。

TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}, {b, 5}],
lists:keyfind(b, 1, TupleList).
找不到则返回 false。

TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
lists:keyfind(e, 1, TupleList).

----------
lists:keymap/3
元组列表里元组的值被函数调用

用法：

keymap(Fun, N, TupleList1) -> TupleList2
内部实现：

-spec keymap(Fun, N, TupleList1) -> TupleList2 when
      Fun :: fun((Term1 :: term()) -> Term2 :: term()),
      N :: pos_integer(),
      TupleList1 :: [Tuple],
      TupleList2 :: [Tuple],
      Tuple :: tuple().

keymap(Fun, Index, [Tup|Tail]) ->
   [setelement(Index, Tup, Fun(element(Index, Tup)))|keymap(Fun, Index, Tail)];
keymap(Fun, Index, []) when is_integer(Index), Index >= 1, 
                            is_function(Fun, 1) -> [].
元组列表 TupleList1 里每个元组的第 N 个值被函数 Fun 调用，调用产生的新值替换原来的，最后返回被函数 Fun 遍历调用过的新列表 TupleList2

TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
lists:keymap(fun(X) -> X * 2 end, 2, TupleList).

----------
lists:keymember/3
判断是否是元组列表里的成员

用法：

keymember(Key, N, TupleList) -> bool()
内部实现：

%% Shadowed by erl_bif_types: lists:keymember/3
-spec keymember(Key, N, TupleList) -> boolean() when
      Key :: term(),
      N :: pos_integer(),
      TupleList :: [Tuple],
      Tuple :: tuple().

keymember(_, _, _) ->
    erlang:nif_error(undef).
判断元组列表 TupleList 里元组的第 N 个值里是否有 Key 这个值存在

TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
lists:keymember(b, 1, TupleList).

----------
lists:keymerge/3
合并两个元组列表并排序

用法：

keymerge(N, TupleList1, TupleList2) -> TupleList3
内部实现：

-spec keymerge(N, TupleList1, TupleList2) -> TupleList3 when
      N :: pos_integer(),
      TupleList1 :: [T1],
      TupleList2 :: [T2],
      TupleList3 :: [(T1 | T2)],
      T1 :: Tuple,
      T2 :: Tuple,
      Tuple :: tuple().

keymerge(Index, T1, L2) when is_integer(Index), Index > 0 -> 
    case L2 of
	[] ->
	    T1;
	[H2 | T2] ->
	    E2 = element(Index, H2),
	    M = keymerge2_1(Index, T1, E2, H2, T2, []),
	    lists:reverse(M, [])
    end.
合并 2 个元组列表，合并好的新元组列表按元组的第 N 个值进行排序

TupleList1 = [{a, 1}, {d, 4}],
TupleList2 = [{b, 2}, {c, 3}],
lists:keymerge(2, TupleList1, TupleList2).

----------
lists:keyreplace/4
替换元组列表里的值

用法：

keyreplace(Key, N, TupleList1, NewTuple) -> TupleList2
内部实现：

-spec keyreplace(Key, N, TupleList1, NewTuple) -> TupleList2 when
      Key :: term(),
      N :: pos_integer(),
      TupleList1 :: [Tuple],
      TupleList2 :: [Tuple],
      NewTuple :: Tuple,
      Tuple :: tuple().

keyreplace(K, N, L, New) when is_integer(N), N > 0, is_tuple(New) ->
    keyreplace3(K, N, L, New).

keyreplace3(Key, Pos, [Tup|Tail], New) when element(Pos, Tup) == Key ->
    [New|Tail];
keyreplace3(Key, Pos, [H|T], New) ->
    [H|keyreplace3(Key, Pos, T, New)];
keyreplace3(_, _, [], _) -> [].
从元组列表 TupleList1 里查找元组的第 N 个值跟 Key 是一样的元素，如果找到则用新元组替换，并返回一个新的元组列表 TupleList1，找不到则返回原来的元组列表 TupleList1

TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
lists:keyreplace(b, 1, TupleList, {b, 22}).

----------
lists:keysearch/3
在一个元组列表里查找一个元素

用法：

keysearch(Key, N, TupleList) -> {value, Tuple} | false
内部实现：

%% Shadowed by erl_bif_types: lists:keysearch/3
-spec keysearch(Key, N, TupleList) -> {value, Tuple} | false when
      Key :: term(),
      N :: pos_integer(),
      TupleList :: [Tuple],
      Tuple :: tuple().

keysearch(_, _, _) ->
    erlang:nif_error(undef).
跟 lists:keyfind/3 一样，都是从元组列表 TupleList 里查找元组的第 N 个值跟 Key 是一样的元素，只不过成功匹配找到时，返回值的格式不一样。

TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
lists:keysearch(b, 1, TupleList).

----------
lists:keysort/3
对元组列表进行排序

用法：

keysort(N, TupleList1) -> TupleList2
内部实现：

-spec keysort(N, TupleList1) -> TupleList2 when
      N :: pos_integer(),
      TupleList1 :: [Tuple],
      TupleList2 :: [Tuple],
      Tuple :: tuple().

keysort(I, L) when is_integer(I), I > 0 ->
    case L of
	[] -> L;
	[_] -> L;
	[X, Y | T] ->
	    case {element(I, X), element(I, Y)} of
		{EX, EY} when EX =
		    case T of
			[] ->
			    L;
			[Z] ->
			    case element(I, Z) of
				EZ when EY =
				    L;
				EZ when EX =
				    [X, Z, Y];
				_EZ ->
				    [Z, X, Y]
			    end;
			_ when X == Y ->
			    keysort_1(I, Y, EY, T, [X]);
			_ ->
			    keysplit_1(I, X, EX, Y, EY, T, [], [])
		    end;
		{EX, EY} ->
		    case T of
			[] ->
			    [Y, X];
			[Z] ->
			    case element(I, Z) of
				EZ when EX =
				    [Y, X | T];
				EZ when EY =
				    [Y, Z, X];
				_EZ ->
				    [Z, Y, X]
			    end;
			_ ->
			    keysplit_2(I, X, EX, Y, EY, T, [], [])
		    end
	    end
    end.

keysort_1(I, X, EX, [Y | L], R) when X == Y ->
    keysort_1(I, Y, EX, L, [X | R]);
keysort_1(I, X, EX, [Y | L], R) ->
    case element(I, Y) of
	EY when EX =
	    keysplit_1(I, X, EX, Y, EY, L, R, []);
	EY ->
	    keysplit_2(I, X, EX, Y, EY, L, R, [])
    end;
keysort_1(_I, X, _EX, [], R) ->
    lists:reverse(R, [X]).
对元组列表 TupleList1 里按元组的第 N 个值进行排序，最后返回排序后的新元组列表 TupleList2

TupleList = [{a, 3}, {b, 4}, {c, 1}, {d, 2}],
lists:keysort(2, TupleList).

----------
lists:keystore/4
在元组列表里存储一个值

用法：

keystore(Key, N, TupleList1, NewTuple) -> TupleList2
内部实现：

-spec keystore(Key, N, TupleList1, NewTuple) -> TupleList2 when
      Key :: term(),
      N :: pos_integer(),
      TupleList1 :: [Tuple],
      TupleList2 :: [Tuple, ...],
      NewTuple :: Tuple,
      Tuple :: tuple().

keystore(K, N, L, New) when is_integer(N), N > 0, is_tuple(New) ->
    keystore2(K, N, L, New).

keystore2(Key, N, [H|T], New) when element(N, H) == Key ->
    [New|T];
keystore2(Key, N, [H|T], New) ->
    [H|keystore2(Key, N, T, New)];
keystore2(_Key, _N, [], New) ->
    [New].
从元组列表 TupleList1 里查找元组的第 N 个值跟 Key 是一样的元素，如果找到则用新元组替换，并返回一个新的元组列表 TupleList1，找不到则在原来的元组列表 TupleList1 后面加上新的元组

TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
lists:keystore(b, 1, TupleList, {b, 22}).
TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
lists:keystore(e, 1, TupleList, {e, 5}).

----------
lists:keytake/3
从元组列表里提取一个元素

用法：

keytake(Key, N, TupleList1) -> {value, Tuple, TupleList2} | false
内部实现：

-spec keytake(Key, N, TupleList1) -> {value, Tuple, TupleList2} | false when
      Key :: term(),
      N :: pos_integer(),
      TupleList1 :: [tuple()],
      TupleList2 :: [tuple()],
      Tuple :: tuple().

keytake(Key, N, L) when is_integer(N), N > 0 ->
    keytake(Key, N, L, []).

keytake(Key, N, [H|T], L) when element(N, H) == Key ->
    {value, H, lists:reverse(L, T)};
keytake(Key, N, [H|T], L) ->
    keytake(Key, N, T, [H|L]);
keytake(_K, _N, [], _L) -> false.
从元组列表 TupleList 里查找元组的第 N 个值跟 Key 是一样的元素，如果找到这个元素，则把这个元素从列表里提取出来，最后返回被提取的元素和提取后的元组列表

TupleList = [{a, 1}, {b, 2}, {c, 3}, {d, 4}],
lists:keytake(b, 1, TupleList).

----------
lists:last/1
返回列表里最后一个元素

用法：

last(List) -> Last
内部实现：

%% last(List) returns the last element in a list.

-spec last(List) -> Last when
      List :: [T,...],
      Last :: T,
      T :: term().

last([E|Es]) -> last(E, Es).

last(_, [E|Es]) -> last(E, Es);
last(E, []) -> E.
返回列表最后一个元素

lists:last([{a, 1}, {b, 2}, {c, 3}, {d, 4}]).

----------
lists:map/2
列表里的每一个元素被函数调用

用法：

map(Fun, List1) -> List2
内部实现：

-spec map(Fun, List1) -> List2 when
      Fun :: fun((A) -> B),
      List1 :: [A],
      List2 :: [B],
      A :: term(),
      B :: term().

map(F, [H|T]) ->
    [F(H)|map(F, T)];
map(F, []) when is_function(F, 1) -> [].
跟 lists:foreach/2 一样，都是列表 List 里的每一个元素按从左向右的顺序被函数 Fun 调用，不同的是，每次函数 Fun 执行的结果将保留，并组成一个列表返回。

lists:map(fun(E) -> E * E end, [1, 2, 3, 4, 5]).

----------
lists:mapfoldl/3
列表里的每一个元素被函数调用

用法：

mapfoldl(Fun, Acc0, List1) -> {List2, Acc1}
内部实现：

-spec mapfoldl(Fun, Acc0, List1) -> {List2, Acc1} when
      Fun :: fun((A, AccIn) -> {B, AccOut}),
      Acc0 :: term(),
      Acc1 :: term(),
      AccIn :: term(),
      AccOut :: term(),
      List1 :: [A],
      List2 :: [B],
      A :: term(),
      B :: term().

mapfoldl(F, Accu0, [Hd|Tail]) ->
    {R,Accu1} = F(Hd, Accu0),
    {Rs,Accu2} = mapfoldl(F, Accu1, Tail),
    {[R|Rs],Accu2};
mapfoldl(F, Accu, []) when is_function(F, 2) -> {[],Accu}.
这个函数是 map 和 foldl 函数结合体，把列表 List1 里的每一个元素被函数 Fun 调用，执行后花括号的第一个值作为返回值返回，第 2 个值作为函数 Fun 的参数，用在下一次调用。

lists:mapfoldl(fun(X, Sum) -> {2 * X, X + Sum} end, 0, [1, 2, 3, 4, 5]).

----------
lists:mapfoldr/3
列表里的每一个元素被函数调用

用法：

mapfoldr(Fun, Acc0, List1) -> {List2, Acc1}      Fun = fun(A, AccIn) -> {B, AccOut}
内部实现：

-spec mapfoldr(Fun, Acc0, List1) -> {List2, Acc1} when
      Fun :: fun((A, AccIn) -> {B, AccOut}),
      Acc0 :: term(),
      Acc1 :: term(),
      AccIn :: term(),
      AccOut :: term(),
      List1 :: [A],
      List2 :: [B],
      A :: term(),
      B :: term().

mapfoldr(F, Accu0, [Hd|Tail]) ->
    {Rs,Accu1} = mapfoldr(F, Accu0, Tail),
    {R,Accu2} = F(Hd, Accu1),
    {[R|Rs],Accu2};
mapfoldr(F, Accu, []) when is_function(F, 2) -> {[],Accu}.
这个函数是 map 和 foldr 函数结合体，把列表 List1 里的每一个元素被函数 Fun 调用，执行后花括号的第一个值作为返回值返回，第 2 个值作为函数 Fun 的参数，用在下一次调用。

lists:mapfoldr(fun(X, Sum) -> {2*X, X+Sum} end, 0, [1,2,3,4,5]).

----------
lists:max/1
返回列表里的最大值

用法：

max(List) -> Max
内部实现：

%% max(L) -> returns the maximum element of the list L

-spec max(List) -> Max when
      List :: [T,...],
      Max :: T,
      T :: term().

max([H|T]) -> max(T, H).

max([H|T], Max) when H > Max -> max(T, H);
max([_|T], Max)              -> max(T, Max);
max([],    Max)              -> Max.
返回列表里的最大值

lists:max([3, 1, 5, 2, 4]).

----------

lists:member/2
判断元素是否是列表里的成员

用法：

member(Elem, List) -> bool()
内部实现：

%% Shadowed by erl_bif_types: lists:member/2
-spec member(Elem, List) -> boolean() when
      Elem :: T,
      List :: [T],
      T :: term().

member(_, _) ->
    erlang:nif_error(undef).
判断元素是否是列表里的成员

lists:member(c, [a, b, c, d, e]).

----------
lists:merge/1
合并列表

用法：

merge(ListOfLists) -> List1
合并列表 ListOfLists 里的子列表

lists:merge([[1], [2], [3], [4], [5]]).

----------
lists:merge/2
将 2 个列表合并为一个列表

用法：

merge(List1, List2) -> List3
把列表 List1 和列表 List2 合并为一个列表 List3

lists:merge([1, 2], [3, 4]).

----------
lists:merge/3
根据排列函数来合并 2 个列表

用法：

merge(Fun, List1, List2) -> List3
根据排列函数来合并 2 个列表

SortFun = fun(A, B) ->
    A > B
end,
lists:merge(SortFun, [5, 4, 2], [1, 3]).

----------
lists:merge3/3
将 3 个列表合并为一个列表

用法：

merge3(List1, List2, List3) -> List4
将 3 个列表合并为一个列表

lists:merge3([1, 2], [3, 4], [5, 6]).

----------
lists:min/1
获取列表里的最少值

用法：

min(List) -> Min
内部实现：

%% min(L) -> returns the minimum element of the list L

-spec min(List) -> Min when
      List :: [T,...],
      Min :: T,
      T :: term().

min([H|T]) -> min(T, H).

min([H|T], Min) when H  min(T, H);
min([_|T], Min)              -> min(T, Min);
min([],    Min)              -> Min.
获取列表里的最少值

lists:min([5, 3, 1, 4, 2]).

----------
lists:nth/2
获取列表里的第 N 个元素

用法：

nth(N, List) -> Elem
内部实现：

%% nth(N, L) returns the N'th element of the list L

-spec nth(N, List) -> Elem when
      N :: pos_integer(),
      List :: [T,...],
      Elem :: T,
      T :: term().

nth(1, [H|_]) -> H;
nth(N, [_|T]) when N > 1 ->
    nth(N - 1, T).
获取列表里的第 N 个元素

lists:nth(3, [1, 2, 3, 4, 5]).
----------

lists:nthtail/2
获取列表里的第 N 个元素后的元素

用法：

nthtail(N, List1) -> Tail
内部实现：

-spec nthtail(N, List) -> Tail when
      N :: non_neg_integer(),
      List :: [T,...],
      Tail :: [T],
      T :: term().

nthtail(1, [_|T]) -> T;
nthtail(N, [_|T]) when N > 1 ->
    nthtail(N - 1, T);
nthtail(0, L) when is_list(L) -> L.
获取列表里的第 N 个元素后的元素

lists:nthtail(3, [1, 2, 3, 4, 5]).

----------
lists:partition/2
根据断言划分列表

用法：

partition(Pred, List) -> {Satisfying, NonSatisfying}
内部实现：

-spec partition(Predicate, List) -> {Satisfying, NotSatisfying} when
      Pred :: fun((Elem :: T) -> boolean()),
      List :: [T],
      Satisfying :: [T],
      NotSatisfying :: [T],
      T :: term().

partition(Pred, L) ->
    partition(Pred, L, [], []).

partition(Pred, [H | T], As, Bs) ->
    case Pred(H) of
	true -> partition(Pred, T, [H | As], Bs);
	false -> partition(Pred, T, As, [H | Bs])
    end;
partition(Pred, [], As, Bs) when is_function(Pred, 1) ->
    {reverse(As), reverse(Bs)}.
根据断言 Predicate 来把列表 List 划分 Satisfying 和 NotSatisfying 2 个列表，Satisfying 列表里的元素是被断言 Predicate 调用返回 true 的元素，而 NotSatisfying 则是被断言 Predicate 调用返回 false 的元素

Predicate = fun(E) -> E rem 2 == 0 end,
lists:partition(Predicate, [1, 2, 3, 4, 5, 6, 7, 8]).

----------
lists:prefix/2
判断列表前缀

用法：

prefix(List1, List2) -> bool()
内部实现：

%% prefix(Prefix, List) -> (true | false)

-spec prefix(List1, List2) -> boolean() when
      List1 :: [T],
      List2 :: [T],
      T :: term().

prefix([X|PreTail], [X|Tail]) ->
    prefix(PreTail, Tail);
prefix([], List) when is_list(List) -> true;
prefix([_|_], List) when is_list(List) -> false.
判断列表 List1 是否列表 List2 的前缀（列表 List2 的前头一部分）

lists:prefix([1, 2, 3], [1, 2, 3, 4, 5]).
lists:prefix([2, 3], [1, 2, 3, 4, 5]).

----------
lists:reverse/1
反转一个列表

用法：

reverse(List1) -> List2
把列表 List1 里的元素反转，并最终返回一个反转后的新列表 List2

lists:reverse([a, b, c, d, e]).

----------
lists:reverse/2
反转一个列表并加上一个列表

用法：

reverse(List1, Tail) -> List2
反转一个列表 List1 并在后面加上一个列表 Tail

lists:reverse([e, d, c, b, a], [f, g, h]).

----------
lists:seq/2
生成一个序列正数列表

用法：

seq(From, To) -> Seq
生成一个由 From 到 To 的序列正数列表，From、To必须是正数。

lists:seq(1, 10)

----------
lists:sort/1
排序一个列表

用法：

sort(List1) -> List2
将列表 List1 里的元素从小到大排序，然后返回一个排序后的新列表。

lists:sort([5, 1, 4, 3, 2]).

----------
lists:sort/2
排序一个列表

用法：

sort(Fun, List1) -> List2
根据排序函数 Fun 来对列表 List1 里的元素进行排序

SortFun = fun(A, B) ->
    A > B
end,
lists:sort(SortFun, [5, 4, 2, 1, 3]).
SortFun = fun(A, B) ->
    A 

----------
lists:split/2
把一个列表分成两个列表

用法：

split(N, List1) -> {List2, List3}
内部实现：

-spec split(N, List1) -> {List2, List3} when
      N :: non_neg_integer(),
      List1 :: [T],
      List2 :: [T],
      List3 :: [T],
      T :: term().

split(N, List) when is_integer(N), N >= 0, is_list(List) ->
    case split(N, List, []) of
	{_, _} = Result -> Result;
	Fault when is_atom(Fault) ->
	    erlang:error(Fault, [N,List])
    end;
split(N, List) ->
    erlang:error(badarg, [N,List]).

split(0, L, R) ->
    {lists:reverse(R, []), L};
split(N, [H|T], R) ->
    split(N-1, T, [H|R]);
split(_, [], _) ->
    badarg.
把列表 List1 以第 N 个元素为分离点，分成 List2 和 List3 这 2 个列表，列表 List2 包含列表 List1 前 N 个元素，列表 List3 则是剩下的。

lists:split(3, [a, b, c, d, e]).

----------
lists:splitwith/2
基于一个断言把一个列表分成两个列表

用法：

splitwith(Pred, List) -> {List1, List2}
内部实现：

-spec splitwith(Pred, List) -> {List1, List2} when
      Pred :: fun((T) -> boolean()),
      List :: [T],
      List1 :: [T],
      List2 :: [T],
      T :: term().

splitwith(Pred, List) when is_function(Pred, 1) ->
    splitwith(Pred, List, []).

splitwith(Pred, [Hd|Tail], Taken) ->
    case Pred(Hd) of
	true -> splitwith(Pred, Tail, [Hd|Taken]);
	false -> {reverse(Taken), [Hd|Tail]}
    end;
splitwith(Pred, [], Taken) when is_function(Pred, 1) ->
    {reverse(Taken),[]}.
基于一个断言 Pred 把一个列表分成 List1 和 List1 这两个列表，List1 里的元素是由在 Pred 函数调用返回 true 的组成，List2 则是直到断言判断遇到一个 false，List 剩下的元素

lists:splitwith(fun(E) -> E 

----------
lists:sublist/2
截取一定长度的列表

用法：

sublist(List1, Len) -> List2
内部实现：

-spec sublist(List1, Len) -> List2 when
      List1 :: [T],
      List2 :: [T],
      Len :: non_neg_integer(),
      T :: term().

sublist(List, L) when is_integer(L), is_list(List) ->
    sublist_2(List, L).

sublist_2([H|T], L) when L > 0 ->
    [H|sublist_2(T, L-1)];
sublist_2(_, 0) ->
    [];
sublist_2(List, L) when is_list(List), L > 0 ->
    [].
截取从第一个元素到第 Len 个元素的列表，如果 Len 大于 List1 的长度，则返回 List1。

lists:sublist([1, 2, 3, 4, 5], 3).

----------
lists:sublist/3
截取一定长度的列表

用法：

sublist(List1, Start, Len) -> List2
内部实现：

%% sublist(List, Start, Length)
%%  Returns the sub-list starting at Start of length Length.

-spec sublist(List1, Start, Len) -> List2 when
      List1 :: [T],
      List2 :: [T],
      Start :: pos_integer(),
      Len :: non_neg_integer(),
      T :: term().

sublist(List, S, L) when is_integer(L), L >= 0 ->
    sublist(nthtail(S-1, List), L).
截取从第 Start 个元素到第 Start + Len 个元素的列表。

lists:sublist([1, 2, 3, 4, 5], 2, 3).

----------
lists:subtract/2
删除一个列表在另一列表里出现的部分

用法：

subtract(List1, List2) -> List3
内部实现：

%% subtract(List1, List2) subtract elements in List2 form List1.

-spec subtract(List1, List2) -> List3 when
      List1 :: [T],
      List2 :: [T],
      List3 :: [T],
      T :: term().

subtract(L1, L2) -> L1 -- L2.
删除列表 List2 在列表 List1 里出现的部分，由其内部实现可知，其操作等价于 List1 -- List2。

lists:subtract("abcde", "bc").

----------
lists:suffix/2
判断列表后缀

用法：

suffix(List1, List2) -> bool()
内部实现：

%% suffix(Suffix, List) -> (true | false)

-spec suffix(List1, List2) -> boolean() when
      List1 :: [T],
      List2 :: [T],
      T :: term().

suffix(Suffix, List) ->
    Delta = length(List) - length(Suffix),
    Delta >= 0 andalso nthtail(Delta, List) =:= Suffix.
如果列表 List1 是列表 List2 的后缀（即出现在末尾），则返回 true，否则返回 false。

lists:suffix("de", "abcde").

----------
lists:sum/1
计算列表里每个元素的总和

用法：

sum(List) -> number()
内部实现：

%% sum(L) returns the sum of the elements in L

-spec sum(List) -> number() when
      List :: [number()].

sum(L)          -> sum(L, 0).

sum([H|T], Sum) -> sum(T, Sum + H);
sum([], Sum)    -> Sum.
计算列表里每个元素的总和

lists:sum([1, 2, 3, 4, 5]).

----------
lists:takewhile/2
基于一个断言提取一个列表

用法：

takewhile(Pred, List1) -> List2
内部实现：

-spec takewhile(Pred, List1) -> List2 when
      Pred :: fun((Elem :: T) -> boolean()),
      List1 :: [T],
      List2 :: [T],
      T :: term().

takewhile(Pred, [Hd|Tail]) ->
    case Pred(Hd) of
	true -> [Hd|takewhile(Pred, Tail)];
	false -> []
    end;
takewhile(Pred, []) when is_function(Pred, 1) -> [].
把列表 List1 里的每个元素依次被断言函数 Pred 调用执行，并返回一个列表 List2。如果元素在 Pred 函数中返回的结果为 true，则把该元素加入到返回列表，直到遇到返回值是 false，则结束断言 Pred 调用

lists:takewhile(fun(E) -> E 

----------
lists:ukeymerge/3
根据元组键值合并 2 个元组列表并删除重复的值

用法：

ukeymerge(N, TupleList1, TupleList2) -> TupleList3
以元组的第 N 个值为键，合并 2 个元组列表，如果这 2 个列表里存在有元组的第 N 个值相同的情况，则保留 TupleList1 里的，丢弃 TupleList2 的。如果这 2 个元组列表里有重复的值，则删除。

lists:ukeymerge(2, [{1, 10}, {2, 20}, {3, 30}], [{4, 20}, {3, 30}]).

----------
lists:ukeysort/2
排序一个元组列表并删除重复的值

用法：

ukeysort(N, TupleList1) -> TupleList2
以元组列表里的元组的第 N 个值为键，对元组列表 TuplleList1 进行排序，如果出现元组的第 N 个值有重复的，删除后面出现的

lists:ukeysort(1, [{c, 1},{b, 2}, {b, 3}, {d, 4}, {a, 5}]).

----------
lists:umerge/1
合并列表里的子列表并删除重复的值

用法：

umerge(ListOfLists) -> List1
合并列表 ListOfLists 里的每个子列表，并把重复的值删掉

lists:umerge([[1, 2], [2, 3], [3, 4], [4, 5]]).

----------
lists:umerge/2
合并两个列表并删除重复的值

用法：

umerge(List1, List2) -> List3
合并 2 个列表，并把重复的值删掉

lists:umerge([1, 2, 3, 4], [2, 3, 4, 5]).

----------
lists:umerge/3
根据排序函数合并两个列表并删除重复的值

用法：

umerge(Fun, List1, List2) -> List3
根据排序函数 Fun 的规则来合并 2 个两个列表，并吧重复的值删掉。

Fun = fun(A, B) -> A >= B end,
lists:umerge(Fun, [100, 10, 1], [10, 5]).

----------
lists:umerge3/3
合并 3 个列表并删除重复的值

用法：

umerge3(List1, List2, List3) -> List4
合并 3 个列表，并把重复的值删掉

lists:umerge3([1, 2, 3], [2, 3, 4], [3, 4, 5]).

----------
lists:unzip/1
把元组里的两个值分成为两个列表

用法：

unzip(List1) -> {List2, List3}
内部实现：

-spec unzip(List1) -> {List2, List3} when
      List1 :: [{A, B}],
      List2 :: [A],
      List3 :: [B],
      A :: term(),
      B :: term().

unzip(Ts) -> unzip(Ts, [], []).

unzip([{X, Y} | Ts], Xs, Ys) -> unzip(Ts, [X | Xs], [Y | Ys]);
unzip([], Xs, Ys) -> {reverse(Xs), reverse(Ys)}.
列表 List1 是由 2 个值组成的元组的列表，这个函数是把元组的第 1 个值分去列表 List2，第 2 个值分去列表 List3。

lists:unzip([{1, a}, {2, b}, {3, c}, {4, d}, {5, e}]).

----------
lists:unzip3/3
把元组里的 3 个值分成为 3 个列表

用法：

unzip3(List1) -> {List2, List3, List4}
内部实现：

-spec unzip3(List1) -> {List2, List3, List4} when
      List1 :: [{A, B, C}],
      List2 :: [A],
      List3 :: [B],
      List4 :: [C],
      A :: term(),
      B :: term(),
      C :: term().

unzip3(Ts) -> unzip3(Ts, [], [], []).

unzip3([{X, Y, Z} | Ts], Xs, Ys, Zs) ->
    unzip3(Ts, [X | Xs], [Y | Ys], [Z | Zs]);
unzip3([], Xs, Ys, Zs) ->
    {reverse(Xs), reverse(Ys), reverse(Zs)}.
列表 List1 是由 3 个值组成的元组的列表，这个函数是把元组的第 1 个值分去列表 List2，第 2 个值分去列表 List3，第 3 个值分去列表 List4。

lists:unzip3([{1, 2, 3}, {4, 5, 6}, {7, 8, 9}]).

----------
lists:usort/1
排序一个列表并删除重复值

用法：

usort(List1) -> List2
对列表 List1 继续升幂排序，并删除重复的值

lists:usort([3, 2, 2, 1, 5, 4]).

----------
lists:usort/2
排序一个列表并删除重复值

用法：

usort(Fun, List1) -> List2
根据排序函数 Fun 的规则来对列表 List1 进行排序，并删掉重复的值

SortFun = fun(A, B) ->
    A 
SortFun = fun(A, B) ->
    A > B
end,
lists:usort(SortFun, [5, 4, 1, 2, 1, 3]).

----------
lists:zip/2
把 2 个列表合成一个由 2 个值组成的元组列表

用法：

zip(List1, List2) -> List3
内部实现：

-spec zip(List1, List2) -> List3 when
      List1 :: [A],
      List2 :: [B],
      List3 :: [{A, B}],
      A :: term(),
      B :: term().

zip([X | Xs], [Y | Ys]) -> [{X, Y} | zip(Xs, Ys)];
zip([], []) -> [].
把 2 个列表合成一个由 2 个值组成的元组列表

lists:zip([1, 2, 3, 4, 5], [a, b, c, d, e]).

----------

lists:zip3/3
把 3 个列表合成一个由 3 个值组成的元组列表

用法：

zip3(List1, List2, List3) -> List4
内部实现：

-spec zip3(List1, List2, List3) -> List4 when
      List1 :: [A],
      List2 :: [B],
      List3 :: [C],
      List4 :: [{A, B, C}],
      A :: term(),
      B :: term(),
      C :: term().

zip3([X | Xs], [Y | Ys], [Z | Zs]) -> [{X, Y, Z} | zip3(Xs, Ys, Zs)];
zip3([], [], []) -> [].
把 3 个列表合成一个由 3 个值组成的元组列表

lists:zip3([a1, a2, a3], [b4, b5, b6], [c7, c8, c9]).

----------
lists:zipwith/3
根据一个合成函数规则把 2 个列表合为一个列表

用法：

zipwith(Combine, List1, List2) -> List3
内部实现：

-spec zipwith(Combine, List1, List2) -> List3 when
      Combine :: fun((X, Y) -> T),
      List1 :: [X],
      List2 :: [Y],
      List3 :: [T],
      X :: term(),
      Y :: term(),
      T :: term().

zipwith(F, [X | Xs], [Y | Ys]) -> [F(X, Y) | zipwith(F, Xs, Ys)];
zipwith(F, [], []) when is_function(F, 2) -> [].
根据一个合成函数 Combine 的规则把 2 个列表合为一个列表

lists:zipwith(fun(X, Y) -> X + Y end, [1, 2, 3], [4, 5, 6]).

----------

lists:zipwith3/4
根据一个合成函数规则把 3 个列表合为一个列表

用法：

zipwith3(Combine, List1, List2, List3) -> List4
内部实现：

-spec zipwith3(Combine, List1, List2, List3) -> List4 when
      Combine :: fun((X, Y, Z) -> T),
      List1 :: [X],
      List2 :: [Y],
      List3 :: [Z],
      List4 :: [T],
      X :: term(),
      Y :: term(),
      Z :: term(),
      T :: term().

zipwith3(F, [X | Xs], [Y | Ys], [Z | Zs]) ->
    [F(X, Y, Z) | zipwith3(F, Xs, Ys, Zs)];
zipwith3(F, [], [], []) when is_function(F, 3) -> [].
根据一个合成函数 Combine 的规则把 3 个列表合为一个列表

lists:zipwith3(fun(X, Y, Z) -> X + Y + Z end, [1, 2, 3], [4, 5, 6], [7, 8, 9]). 

----------

**一，带函数Pred****
**1, all(Pred, List) -> boolean()
如果List中的每个元素作为Pred函数的参数执行，结果都返回true，那么all函数返回true，
否则返回false

例子：

lists:all(fun(E) -> true end,[1,2,3,4]).

结果

true



例子

lists:any(fun(E) -> is_integer(E) end,[q,2,a,4]).

结果

true

 

3，dropwhile(Pred, List1) -> List2
将List1列表中的元素作为参数执行Pred函数，如果返回true，将其丢弃，最后返回剩余元素
组成的列表

例子

lists:dropwhile(fun(E) -> is_atom(E) end,[a,1,2,a,b]).

结果

[1,2,a,b]

4，filter(Pred, List1) -> List2
返回一个列表，这个列表是由List1中执行Pred函数返回true的元素组成。

lists:filter(fun(E) -> is_integer(E) end,[q,2,a,4]).

结果：

[2,4]

 

5，map(Fun, List1) -> List2
将List1中的每个元素去在Fun中执行，然后返回一个元素，最后返回的这些元素组成一个列表，
返回给List2
例子：
lists:map(fun(X)->[X,X] end, [a,b,c]).
结果：[[a,a],[b,b],[c,c]]

 

6，flatmap(Fun, List1) -> List2
这个函数和map比较类似，相当于执行了
lists:append(lists:map(List1)).
也就是把map的结果进行append处理
例子：
lists:flatmap(fun(X)->[X,X] end, [a,b,c]).
结果：[a,a,b,b,c,c]

 

7，foldl(Fun, Acc0, List) -> Acc1
Fun这个函数有两个参数
第一个参数是List中的元素，第二个参数是Fun函数执行完后的返回值，这个参数第一次执行时

就是Acc0

\##感觉原文这里表达有点问题，比较适合的说法应该是当List为空后，返回值是AccN（第二个参数），

lists：foldl源码：

foldl(F, Accu, [Hd|Tail]) ->
  foldl(F, F(Hd, Accu), Tail);
foldl(F, Accu, []) when is_function(F, 2) -> Accu.


例子：对[1,2,3,4,5]求和
lists:foldl(fun(X, Sum) -> X + Sum end, 0, [1,2,3,4,5]).
结果：15
执行过程：首先，Fun第一次执行时，X的值取列表List的第一个元素1，Sum取0,
 Fun第二次执行时，X的值取列表List的第二个元素2，Sum取Fun第一次的返回值
 依次轮推，直到List中每个元素执行完，最后foldl返回最后一次的结果。

 

8，foldr(Fun, Acc0, List) -> Acc1
foldr这个函数和foldl比较相似
不过是Fun执行时，X的值先取List的最后一个，然后取倒数第二个。

 

9，foreach(Fun, List) -> ok
以List中的每个元素为参数执行Fun函数，执行顺序按照List中元素的顺序，这个函数最后返回ok。是单边的
例子 lists:foreach(fun(X)->
 %%using X to do somethings 
 %%
 end,List)

 

10，keymap(Fun, N, TupleList1) -> TupleList2
对TupleList1中的每个元素的第N项作为参数在Fun中处理，然后这个第N项最后就被替换为Fun执行完返回的值
例子：
List1 = [{name,"zhangjing"},{name,"zhangsan"}].
lists:keymap(fun(X)->
 list_to_atom(X)
 end,2,List1).
结果：
[{name,zhangjing},{name,zhangsan}]

 

11，mapfoldl(Fun, Acc0, List1) -> {List2, Acc1}
这个函数等于是把map和foldl函数结合起来。将List1中的每一个元素执行Fun函数，执行后花括号的第一个值作为返回值返回，
第二个值作为参数传给Fun，作为下一次用。
例子：
lists:mapfoldl(fun(X, Sum) -> {2*X, X+Sum} end,
0, [1,2,3,4,5]).
{[2,4,6,8,10],15}

 

12，mapfoldr(Fun, Acc0, List1) -> {List2, Acc1}
这个函数相当于将map和foldr结合起来


13，merge(Fun, List1, List2) -> List3
这个函数的功能也是把List1和List2合并到一起，只不过是List1和List2的元素要作为参数在Fun中执行，如果
Fun返回true，那么返回值就是List1在前，List2在后。否则，反之。
例子
lists:merge(fun(A,B)-> false end, [3,4],[2,1]).
结果
[2,1,3,4]

 

14，partition(Pred, List) -> {Satisfying, NotSatisfying}
这个函数的功能是将List分成两个List1和List2，List1是将List元素作为参数去Pred函数中执行返回true的元素组成，
List2由Pred返回false的元素组成。
注意，返回的是一个元组
例子
lists:partition(fun(A) -> A rem 2 == 1 end, [1,2,3,4,5,6,7]).
结果
{[1,3,5,7],[2,4,6]}


15，sort(Fun, List1) -> List2
如果Fun函数返回true，则排序是从小到大的顺序，否则，从大到小。
其中Fun有两个参数。
例子
lists:sort(fun(A,B)-> false end,[1,2,3]).
结果
[3,2,1]


16，splitwith(Pred, List) -> {List1, List2}
将List分成List1和List2，
List1由List中元素在Pred函数返回true的组成，但是有一点，如果遇到为false的，则将剩下的元素
全部放到List2中，List1中就只有前面为true的。
例子
lists:splitwith(fun(A) -> is_atom(A) end, [a,b,1,c,d,2,3,4,e]).
结果
{[a,b],[1,c,d,2,3,4,e]}


17，takewhile(Pred, List1) -> List2
List1中的元素element依次执行Pred(element),如果返回true，则获取这个元素，直到有元素执行Pred(element)返回false
例子
lists:takewhile(fun(E)-> is_atom(E) end,[a,b,1,e,{c},[d]]).
结果
[a,b]


18,umerge(Fun, List1, List2) -> List3
这个函数和merge不同的是 当Fun返回true时，返回的List3中不能出现相同的元素
疑问：但是当Fun返回false时，List3中可以有相同的元素。
例子(Fun返回true的情况)
lists:umerge(fun(A,B)-> true end,[1,2],[2,3]).
结果
[1,2,3]
(Fun为false的情况)
lists:umerge(fun(A,B)-> false end,[1,2],[2,3]).
[2,3,1,2]
好神奇，竟然2有重复

 

19，usort(Fun, List1) -> List2
按照Fun函数进行排序，如果Fun返回true，那么只返回List1的第一个元素
如果Fun返回false，那么List1从大到小排序
例子1
lists:usort(fun(A,B) -> true end, [1,2,2,3,4]).
结果
[1]

例子2
lists:usort(fun(A,B) -> false end, [1,2,2,3,4]).
结果
[4,3,2,2,1]


20，zipwith(Combine, List1, List2) -> List3
将List1和list2中的每个元素执行Combine函数，然后返回一个元素，List3就是由Combine函数返回的一个个元素组成的。
功能和map有点像，但是这里是对两个列表的操作。
例子
lists:zipwith(fun(X, Y) -> X+Y end, [1,2,3], [4,5,6]).
结果
[5,7,9]

 

21，zipwith3(Combine, List1, List2, List3) -> List4
将List1和list2，list3中的每个元素执行Combine函数，然后返回一个元素，List4就是由Combine函数返回的一个个元素组成的。
功能和map有点像，但是这里是对三个列表的操作。
例子
lists:zipwith3(fun(X, Y, Z) -> X+Y+Z end, [1,2,3], [4,5,6],[7,8,9]).
结果
[12,15,18]

 

**二，不带函数Pred
**1，append(ListOfLists) -> List1
ListOfLists都是由List组成的，而List一个列表，里面可以是任何类型的元素
这个函数就是将ListOfLists里面的所有列表的元素按顺序编成一个列表
提示：ListOfLists里面的元素必须都是列表才能用这个函数

例子

lists:append([[1, 2, 3], [a, b], [4, 5, 6]]).

结果：

[1,2,3,a,b,4,5,6]



例子

lists:append("abc", "def").

结果

"abcdef"

 

3，concat(Things) -> string()
这里的Things是一个列表，里面由atom() | integer() | float() | string()
将这个列表里面的元素拼成一个字符串，然后返回

例子

lists:concat([doc, '/', file, '.', 3]).

结果

doc/file.3"

 

4，delete(Elem, List1) -> List2
List1是由很多Element组成的，这个函数的功能是在List1中寻找第一个和Elem元素一样的，
然后删除之，返回删除后新的列表。

例子

lists:delete({name,"zhangsan"},[{name,"lisi"},{name,"zhangsan"},{name,"wangmazi"})).

结果

[{name,"lisi"},{name,"wangmazi"}]

 

5，duplicate(N, Elem) -> List
返回一个由N个Elem组成的列表。

例子

lists:duplicate(5,"test").

结果

["test","test","test","test","test"]

 

6，flatlength(DeepList) -> integer() >= 0
我的理解是DeepList就是列表里面套列表
计算列表的长度，即用flatten函数将DeepList转化成List后元素的个数
这个函数和length()的区别就是：
length函数是得到列表元素的个数，
而flatlength函数是先将DeepList转化成List后的个数
譬如说List = [1,2,[3,4]]这个列表用
length(List)求的值是：3
lists:flatlength(List)求的值是：4
其实lists:flatlength(List) = length(flatten(List))

7，flatten(DeepList) -> List
将DeepList变成只有term()的list
例子：
lists:flatten([[a,a],[b,b],[c,c]]).
结果：
[a,a,b,b,c,c]

 

8，flatten(DeepList, Tail) -> List
就是将DeepList变成只有term的List后，在后面再加一个Tail。
例子：
lists:flatten([[a,a],[b,b],[c,c]],[dd]).
结果：
[a,a,b,b,c,c,dd]

 

9,keydelete(Key, N, TupleList1) -> TupleList2
这个函数适合处理列表里面的元素是元组的情况
删除TupleList1中元素第N个元素和Key一致的元素，只删除第一个一样的，后面一样的不删除
例子：
List = [{name,"zhangjing"},{sex,"male"},{name,"zhangsan"},{sex,"male"}],
lists:keydelete("male",2,List)
结果：
[{name,"zhangjing"},{name,"zhangsan"},{sex,"male"}]

 

10,keyfind(Key, N, TupleList) -> Tuple | false
查找TupleList中的一个Tuple，如果查找到，返回，如果没有查找到，则返回false
这个Tuple必须满足第N个元素和key是一样。
例子：
List1 = [{name,"zhangjing"},{name,"zhangsan"}].
lists:keyfind("zhangjing",2,List1)
结果：{name,"zhangjing"}

 

11，keymember(Key, N, TupleList) -> boolean()
如果TupleList中的元素中存在第N个元素和key一致，则返回true，否则返回false
例子：
List1 = [{name,"zhangjing"},{name,"zhangsan"}].
lists:keymember("zhangjing",2,List1).
结果：true

 

12，keymerge(N, TupleList1, TupleList2) -> TupleList3
将TupleList1和TupleList2进行混合，组成一个TupleList，
新组成的TupleList是按照Tuple的第N个元素进行排序的
例子：
List1 = [{name,"zhangjing"},{name,"zhangsan"}].
List2 = [{nick,"zj"},{nick,"zs"}].
lists:keymerge(2,List1,List2).
结果：
[{name,"zhangjing"},
 {name,"zhangsan"},
 {nick,"zj"},
 {nick,"zs"}]

 

13，keyreplace(Key, N, TupleList1, NewTuple) -> TupleList2
在TupleList1的Tuple中找出第N个元素和Key一致，然后用NewTuple将这个Tuple替换掉，如果没有找到
，则返回原来的TupleList1
例子：
List1 = [{name,"zhangjing"},{name,"zhangsan"}]
lists:keyreplace("zhangjing",2,List1,{nickname,"netzj"}).
结果：
[{nickname,"netzj"},{name,"zhangsan"}]

 

14，keysearch(Key, N, TupleList) -> {value, Tuple} | false
这个函数和keyfind差不多，就是返回值的结构不一样
也是在TupleList中找一个Tuple，这个Tuple的第N个元素和Key一样。
例子：
List1 = [{name,"zhangjing"},{name,"zhangsan"}]
lists:keysearch("zhangjing",2,List1).
结果：
{value,{name,"zhangjing"}}

 

15，keysort(N, TupleList1) -> TupleList2
对TupleList1中的Tuple按照第N个元素进行排序，然后返回一个新的顺序的TupleList。
不过这种排序是固定的。
例子：
List1 = [{name,"zhangsan"},{name,"zhangjing"}].
lists:keysort(2,List1).
结果：
[{name,"zhangjing"},{name,"zhangsan"}]

 

16，keystore(Key, N, TupleList1, NewTuple) -> TupleList2
这个函数和keyreplace函数比较像，不同的是，这个keystore在没有找到对应的Tuple时，
会将这个NewTuple追加在这个TupleList1的最后。
例子：
List1 = [{name,"zhangsan"},{name,"zhangjing"}].
找到了的情况
lists:keystore("zhangjing",2,List1,{name,"netzhangjing"}).
[{name,"netzhangjing"},{name,"zhangsan"}]
没有找到的情况
lists:keystore("zhanging",2,List1,{name,"netzhangjing"}).
[{name,"zhangjing"},{name,"zhangsan"},{name,"netzhangjing"}]

 

17，keytake(Key, N, TupleList1) -> {value, Tuple, TupleList2} | false
在TupleList1中找Tuple，这个Tuple的第N个元素和Key一致，如果找到了这么一个Tuple
那么返回，{value, Tuple, TupleList2} 其中TupleList2是去掉Tuple的TupleList1.
例子：
List1 = [{name,"zhangjing"},{name,"zhangsan"},{name,"lisi"}].
lists:keytake("zhangjing",2,List1).
结果：
{value,{name,"zhangjing"},[{name,"zhangsan"},{name,"lisi"}]}

 

18，last(List) -> Last
返回：List最后一个元素
例子：
List1 = [{name,"zhangjing"},{name,"zhangsan"},{name,"lisi"}].
lists:last(List1).
结果：
{name,"lisi"}

 

19，max(List) -> Max
取出List中最大的元素，一般List是整型时比较适合。
例子：
lists:max([1,10,15,6]).
结果：
15

 

20，member(Elem, List) -> boolean()
如果Elem和List中的某个元素匹配（相同），那么返回true，否则返回false
例子
lists:member({sex,"1"},[{sex,"1"},{sex,"2"},{sex,"3"}]).
结果：
true

21，merge(ListOfLists) -> List1
ListOfLists是一个列表，里面由子列表构成
这个函数的功能就是将这些子列表合并成一个列表。
例子：
lists:merge([[{11}],[{22}],[{33}]]).
结果
[{11},{22},{33}]

 

22，merge(List1, List2) -> List3
List1和List2分别是一个列表，这个函数的功能是将这两个列表合并成一个列表。
例子：
lists:merge([11],[22]).
结果
[11,22]
[2,1,3,4]


23, merge3(List1, List2, List3) -> List4
将List1，List2，List3合并成一个列表
例子
lists:merge3([11],[22],[33,44]).
结果：
[11,22,33,44]

 

24，min(List) -> Min
返回List中的最小的元素，和max函数对应
例子
lists:min([1,2,3]).
结果
1

 

25，nth(N, List) -> Elem
返回List中的第N个元素。
例子
lists:nth(2,[{name,"zhangsan"},{name,"lisi"},{name,"wangmazi"}]).
结果
{name,"lisi"}

 

26，nthtail(N, List) -> Tail
返回List列表中第N个元素后面的元素
例子
lists:nthtail(3, [a, b, c, d, e]).
结果
[d,e]


27，prefix(List1, List2) -> boolean()
如果List1是List2的前缀(也就是说List1和List2前部分相同)，那么返回true，否则返回false

28，reverse(List1) -> List2
将List1反转
例子
lists:reverse([1,2,3,4]).
结果
[4,3,2,1]

 

29,reverse(List1, Tail) -> List2
将List1反转，然后将Tail接在反转List1的后面，然后返回
例子
lists:reverse([1, 2, 3, 4], [a, b, c]).
[4,3,2,1,a,b,c]

 

30，seq(From, To) -> Seq
其中From和To都是整型，这个函数返回一个从From到To的一个整型列表。
例子
lists:seq(1,10).
结果
[1,2,3,4,5,6,7,8,9,10]

 

31，seq(From, To, Incr) -> Seq
返回一个整型列表，这个列表的后一个元素比前一个元素大Incr。
例子
lists:seq(1,10,4).
[1,5,9]

 

32，sort(List1) -> List2
将List1中的元素从小到大排序，然后返回新的一个列表。
例子
lists:sort([3,2,1]).
结果
[1,2,3]


33，split(N, List1) -> {List2, List3}
将List1分成List2和List3
其中List2包括List1的前N个元素，List3包含剩余的。
例子
lists:split(3,[1,2,3,4,5]).
结果
{[1,2,3],[4,5]}


这个函数和partition数有区别，partition是遍历全部的List，而splitwith在遍历时遇到false的情况
则马上结束遍历，返回结果。

34，sublist(List1, Len) -> List2
返回从第一个元素到第Len个元素的列表，这个Len大于List1的长度时，返回全部。
例子
lists:sublist([1,2,3,4,5,6],3).
结果
[1,2,3]

 

35，sublist(List1, Start, Len) -> List2
返回从List1的第Start个位置开始，后面Len个元素的列表。
例子
lists:sublist([1,2,3,4], 2, 2).
结果
[2,3]

 

36，subtract(List1, List2) -> List3
等同于 List1 -- List2
这个函数功能是返回一个List1的副本，对于List2中的每个元素，第一次在List1副本中出现时被删掉。
例子
lists:subtract("112233","12").
结果
"1233"

 

37，suffix(List1, List2) -> boolean()
如果List1是List2的后缀，那么返回true，否则返回false
例子
lists:suffix("22","1122").
结果
true

 

38，sum(List) -> number()
返回List中每个元素的和。其中List中的元素都应该是number()类型的。
例子
lists:sum([1,2,3,4]).
结果
10


39，ukeymerge(N, TupleList1, TupleList2) -> TupleList3
TupleList1和TupleList2里面的元素都是元组
将TupleList1和TupleList2合并，合并的规则是按照元组的第N个元素，如果第N个元素有相同的，那么保留TupleList1中
的，删除TupleList2中的。

 

40，ukeysort(N, TupleList1) -> TupleList2
TupleList1里面的元素都是元组
这个函数也同样返回一个元素是元组的列表，返回的这个列表是按照元组的第N个元素来排序的，如果元组中有出现
第N个元素相同的情况，删除掉后面的一个元组。
例子
lists:ukeysort(1,[{name,"zhangsan"},{sex,"male"},{name,"himan"}]).
结果
[{name,"zhangsan"},{sex,"male"}]

 

41，umerge(ListOfLists) -> List1
这个函数和merge唯一不同的就是，里面不能出现相同的元素，如果出现相同的，那么删除之，只保留一个唯一的
例子
lists:umerge([[1,2],[2,3]]).
结果
[1,2,3]
分析：由于[[1,2],[2,3]]中merge后是[1,2,2,3],这个时候有两个相同的元素2，所以只保存一个2，所以结果是[1,2,3].


42，umerge3(List1, List2, List3) -> List4
将List1, List2, List3合并
和merge3不同的是返回的List4中不能出现重复的元素
例子
lists:merge3([1,2],[2,3],[3,4]).
结果
[1,2,3,4]

 

43，unzip(List1) -> {List2, List3}
List1里面的元素是元组，每个元组由两个元素组成，返回值List2包含每个List1中每个元组的第一个元素
返回值List3包含每个List1中每个元组的第二个元素。
例子
lists:unzip([{name,"zhangsan"},{sex,"male"},{city,"hangzhou"}]).
结果
{[name,sex,city],["zhangsan","male","hangzhou"]}

 

44，unzip3(List1) -> {List2, List3, List4}
List1里面的元素是元组，每个元组由三个元素组成，返回值List2包含每个List1中每个元组的第一个元素；
返回值List3包含每个List1中每个元组的第二个元素；返回值List4包含每个List1中每个元组的第三个元素。
例子
lists:unzip3([{name,"zhangsan","apple"},{sex,"male","banana"},{city,"hangzhou","orange"}]).
结果
{[name,sex,city],
 ["zhangsan","male","hangzhou"],
 ["apple","banana","orange"]}
注意，最终返回的是一个元组。

45，usort(List1) -> List2
将List1按照从小到大的顺序排序，如果排序后有重复的元素，删除重复的，只保存一个唯一的。
例子
lists:usort([4,3,2,1,2,3,4]).
结果
[1,2,3,4]


46，zip(List1, List2) -> List3
将两个长度相同的列表合并成一个列表
List3是里面的每一个元组的第一个元素是从List1获取的，而每个元组的第二个元素是从List2中获取的
例子
lists:zip([name,sex,city],["zhangsan","male","hangzhou"]).
结果
[{name,"zhangsan"},{sex,"male"},{city,"hangzhou"}]
注意，如果List1和List2长度不一致，那么这个函数将会报错。

 

47，zip3(List1, List2, List3) -> List4
将三个长度相同的列表合并成一个列表
List3是里面的每一个元组的第一个元素是从List1获取的，而每个元组的第二个元素是从List2中获取的
每个元组的第三个元素是从List3中获取的。
例子
lists:zip3([name,sex,city],["zhangsan","male","hangzhou"],["nick","1","zhejiang"]).
结果
[{name,"zhangsan","nick"},
 {sex,"male","1"},
 {city,"hangzhou","zhejiang"}]