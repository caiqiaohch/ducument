proplists:append_values/2
把列表里所有相同键的值追加起来

用法：

append_values(Key, ListIn) -> ListOut
内部实现：

-spec append_values(Key, ListIn) -> ListOut when
      Key :: term(),
      ListIn :: [term()],
      ListOut :: [term()].

append_values(Key, [P | Ps]) ->
    if is_atom(P), P =:= Key ->
	    [true | append_values(Key, Ps)];
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    case P of
		{_, Value} when is_list(Value) ->
		    Value ++ append_values(Key, Ps);
		{_, Value} ->
		    [Value | append_values(Key, Ps)];
		_ ->
		    append_values(Key, Ps)
	    end;
       true ->
	    append_values(Key, Ps)
    end;
append_values(_Key, []) ->
    [].
把列表 ListIn 所有相同的键 Key 的值追加起来，这个函数跟 proplists:get_all_values/2 类似。不同的是键里的每个值都包含在一个列表里（除它本身是一个列表之外）。

proplists:append_values(a, [{a, [1, 2]}, {b, 0}, {a, 3}, {c, -1}, {a, [4]}]).
proplists:append_values(a, [{a, 1}, {b, 2}, {a, 3}, {c, -4}, {d, 5}]).

----------
proplists:compact/1
最小化列表里所有条目的表现形式

用法：

compact(ListIn) -> ListOut
内部实现：

-spec compact(ListIn) -> ListOut when
      ListIn :: [property()],
      ListOut :: [property()].

compact(ListIn) ->
    [property(P) || P 
最小化列表里所有条目的表现形式。

proplists:compact([{a, true}, {b, false}, c, {a, true}, {a, 1}, {a, [2]}]).

----------
proplists:delete/2
删除列表里所有跟键相关联的元素

用法：

delete(Key, List) -> List
内部实现：

-spec delete(Key, List) -> List when
      Key :: term(),
      List :: [term()].

delete(Key, [P | Ps]) ->
    if is_atom(P), P =:= Key ->
	    delete(Key, Ps);
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    delete(Key, Ps);
       true ->
	    [P | delete(Key, Ps)]
    end;
delete(_, []) ->
    [].
删除列表 List 里所有跟键 Key 相关联的元素。

proplists:delete(a, [{a, true}, {b, false}, c, {a, true}, {a, 1}, {a, [2]}]).

----------
proplists:expand/2
把特定的属性扩展到对应的属性集合

用法：

expand(Expansions, ListIn) -> ListOut
把特定的属性扩展到对应的属性集合（或其他 Erlang 项）。参数 Expansions 里的每一个元组对 {Property, Expansion}，如果 E 是列表里有相同键 Property 的第一个条目，且 E 和 Property 拥有同等的标准数据形式，那么 E 被 Expansion 替换，且接下来拥有相同键的调用将从列表里被删除。

proplists:expand([{foo, [bar, baz]}], [fie, foo, fum]).
proplists:expand([{{foo, true}, [bar, baz]}], [fie, foo, fum]).
proplists:expand([{{foo, false}, [bar, baz]}], [fie, {foo, false}, fum]).
下面的调用不会扩展，因为 {foo, false} 不等于 {foo, true}。

proplists:expand([{{foo, true}, [bar, baz]}], [{foo, false}, fie, foo, fum]).
Note：扩展后，如果在返回的结果里还保留着原始的属性项，那么肯定是 expansion 列表里包含有。被插入的项值不是递归扩展。如果 Expansions 里含有多个相同键的属性，那么只有第一个会被使用。

----------
proplists:get_all_values/2
获取指定键的所有值

用法：

get_all_values(Key, List) -> [term()]
内部实现：

-spec get_all_values(Key, List) -> [term()] when
      Key :: term(),
      List :: [term()].

get_all_values(Key, [P | Ps]) ->
    if is_atom(P), P =:= Key ->
	    [true | get_all_values(Key, Ps)];
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    case P of
		{_, Value} ->
		    [Value | get_all_values(Key, Ps)];
		_ ->
		    get_all_values(Key, Ps)
	    end;
       true ->
	    get_all_values(Key, Ps)
    end;
get_all_values(_Key, []) ->
    [].
类似 proplists:get_value/2，但是它返回列表 List 里所有格式为 {Key, Value} 的条目的值的列表。如果不存在这种条目，则返回空列表。

List = [{a, 1}, {b, 2}, {b, 3}, {c, 4}, {b, 5}, {d, 6}],
proplists:get_all_values(b, List).

----------
proplists:get_bool/2
返回一个布尔键值选项的值

用法：

get_bool(Key, List) -> boolean()
内部实现：

-spec get_bool(Key, List) -> boolean() when
      Key :: term(),
      List :: [term()].

get_bool(Key, [P | Ps]) ->
    if is_atom(P), P =:= Key ->
	    true;
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    case P of
		{_, true} ->
		    true;
		_ ->
		    %% Don't continue the search!
		    false
	    end;
       true ->
	    get_bool(Key, Ps)
    end;
get_bool(_Key, []) ->
    false.
返回一个布尔键值选项的值。如果 proplists:lookup(Key, List) 返回 {Key, true}，那么这个函数返回 true，否则返回 false。

proplists:get_bool(k1, [{k1, 1}, {k2, 2}, k1, {k3, 3}, {k4, [[4]]}]).
proplists:get_bool(k3, [{k1, 1}, {k2, 2}, k3, {k3, 3}, {k4, [[4]]}]).
proplists:get_bool(k5, [{k1, 1}, {k2, 2}, k3, {k3, 3}, {k4, [[4]]}]).

----------
proplists:get_keys/1
获取列表里的所有键

用法：

get_keys(List) -> [term()]
返回包含列表 List 里所有键的一个无序列表，不包含重复出现的键。

proplists:get_keys([{a, 1}, {b, 2}, {c, 3}, {b, 3}, {d, 4}]).

----------
proplists:get_value/2
获取一个键值属性列表的值

用法：

get_value(Key, List) -> term()
内部实现：

%% @equiv get_value(Key, List, undefined)

-spec get_value(Key, List) -> term() when
      Key :: term(),
      List :: [term()].

get_value(Key, List) ->
    get_value(Key, List, undefined).

-spec get_value(Key, List, Default) -> term() when
      Key :: term(),
      List :: [term()],
      Default :: term().

get_value(Key, [P | Ps], Default) ->
    if is_atom(P), P =:= Key ->
	    true;
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    case P of
		{_, Value} ->
		    Value;
		_ ->
		    %% Dont continue the search!
		    Default
	    end;
       true ->
	    get_value(Key, Ps, Default)
    end;
get_value(_Key, [], Default) ->
    Default.
返回一个键值属性列表 List 里跟 Key 关联的值。如果列表存在这个键的值，则返回该值，否则返回 undefined。其效用跟 proplists:get_value(Key, List, undefined) 一样。

proplists:get_value(a, [{a, b}, {c, d}]).
proplists:get_value(e, [{a, b}, {c, d}]).
proplists:get_value(a, [a, b, c, d]).
proplists:get_value(b, [a, b, c, d]).
proplists:get_value(e, [a, b, c, d]).

----------
proplists:get_value/3
获取一个键值属性列表的值

用法：

get_value(Key, List, Default) -> term()
内部实现：

-spec get_value(Key, List, Default) -> term() when
      Key :: term(),
      List :: [term()],
      Default :: term().

get_value(Key, [P | Ps], Default) ->
    if is_atom(P), P =:= Key ->
	    true;
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    case P of
		{_, Value} ->
		    Value;
		_ ->
		    %% Dont continue the search!
		    Default
	    end;
       true ->
	    get_value(Key, Ps, Default)
    end;
get_value(_Key, [], Default) ->
    Default.
返回一个键值属性列表 List 里跟 Key 关联的值。如果列表存在这个键的值，则返回该值，否则返回默认值 Default。

proplists:get_value(a, [{a, b}, {c, d}], slate).
proplists:get_value(d, [{a, b}, {c, d}], slate).

----------
proplists:is_defined/2
判断列表里是否有指定键的条目

用法：

is_defined(Key, List) -> boolean()
内部实现：

%% @doc Returns true if List contains at least
%% one entry associated with Key, otherwise
%% false is returned.

-spec is_defined(Key, List) -> boolean() when
      Key :: term(),
      List :: [term()].

is_defined(Key, [P | Ps]) ->
    if is_atom(P), P =:= Key ->
	    true;
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    true;
       true ->
	    is_defined(Key, Ps)
    end;
is_defined(_Key, []) ->
    false.
如果列表 List 里至少包含一个跟键 Key 相关的条目，那么返回 true，否则返回 false。

List = [{a, 1}, {b, 2}, {c, 3}],
proplists:is_defined(b, List).

----------
proplists:lookup/2
返回在列表里第一个跟键相关联的条目

用法：

lookup(Key, List) -> none | tuple()
内部实现：

-spec lookup(Key, List) -> 'none' | tuple() when
      Key :: term(),
      List :: [term()].

lookup(Key, [P | Ps]) ->
    if is_atom(P), P =:= Key ->
	    {Key, true};
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    %% Note that Key does not have to be an atom in this case.
	    P;
       true ->
	    lookup(Key, Ps)
    end;
lookup(_Key, []) ->
    none.
返回在列表 List 里第一个跟键 Key 相关联的条目，如果有一个存在的话，否则返回 none。例如在列表里有一个原子 A，那么元组 {A, true} 就是跟 A 相关联的条目。

proplists:lookup(k1, [{k1, 1}, {k2, 2}, k1, {k3, 3}, {k4, [[4]]}]).
proplists:lookup(k3, [{k1, 1}, {k2, 2}, k3, {k3, 3}, {k4, [[4]]}]).

----------
proplists:lookup_all/2
返回列表里跟键相关联的所有条目的列表

用法：

lookup_all(Key, List) -> [tuple()]
内部实现：

-spec lookup_all(Key, List) -> [tuple()] when
      Key :: term(),
      List :: [term()].

lookup_all(Key, [P | Ps]) ->
    if is_atom(P), P =:= Key ->
	    [{Key, true} | lookup_all(Key, Ps)];
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    [P | lookup_all(Key, Ps)];
       true ->
	    lookup_all(Key, Ps)
    end;
lookup_all(_Key, []) ->
    [].
返回列表 List 里跟键 Key 相关联的所有条目的列表。如果没有这样的条目存在，则返回一个空列表。

proplists:lookup_all(k1, [{k1, 1}, {k2, 2}, k1, {k3, 3}, {k4, [[4]]}]).
proplists:lookup_all(k3, [{k1, 1}, {k2, 2}, k3, {k3, 3}, {k4, [[4]]}]).
proplists:lookup_all(k5, [{k1, 1}, {k2, 2}, k3, {k3, 3}, {k4, [[4]]}]).

----------
proplists:normalize/2
对列表里元素进行一系列的替换/扩展操作

用法：

normalize(ListIn, Stages) -> ListOut
内部实现：

-spec normalize(ListIn, Stages) -> ListOut when
      ListIn :: [term()],
      Stages :: [Operation],
      Operation :: {'aliases', Aliases}
                 | {'negations', Negations}
                 | {'expand', Expansions},
      Aliases :: [{Key, Key}],
      Negations :: [{Key, Key}],
      Expansions :: [{Property :: property(), Expansion :: [term()]}],
      ListOut :: [term()].

normalize(L, [{aliases, As} | Xs]) ->
    normalize(substitute_aliases(As, L), Xs);
normalize(L, [{expand, Es} | Xs]) ->
    normalize(expand(Es, L), Xs);
normalize(L, [{negations, Ns} | Xs]) ->
    normalize(substitute_negations(Ns, L), Xs);
normalize(L, []) ->
    compact(L).
对列表里元素进行替换/扩展等一系列操作。对于一个 aliases 操作，函数 proplists:substitute_aliases/2 将调用给定的 aliases 列表；对于一个 negations 操作，函数 proplists:substitute_negations/2 将调用给定的 negation 列表；对于一个 expand 操作，函数 proplists:expand/2 将调用给定的 expansions 列表。最后的结果将自动被函数 proplists:compact/1 进行压缩操作。

proplists:normalize([a, b, c, d], [{aliases, [{a, apple}, {b, banana}]}]).
proplists:normalize([a, b, c, d], [{expand, [{d, [d, e, f, g]}]}]).
proplists:normalize([a, b, c, d], [{aliases, [{a, apple}, {b, banana}]}, {expand, [{d, [d, e, f, g]}]}]).
proplists:normalize([a, b, c, d], [{expand, [{d, [d, e, f, g]}]}, {aliases, [{a, apple}, {b, banana}]}]).

----------
proplists:property/1
返回一个属性的正常格式（最小化）的表示

用法：

property(PropertyIn) -> PropertyOut
内部实现：

-spec property(PropertyIn) -> PropertyOut when
      PropertyIn :: property(),
      PropertyOut :: property().

property({Key, true}) when is_atom(Key) ->
    Key;
property(Property) ->
    Property.
返回一个属性的正常格式（最小化）的表示。如果 Property 的值 {Key, true}，且 Key 是一个原子，那么这个函数则返回 Key，否则返回整个 Property 项值。

proplists:property(k).
proplists:property({k, true}).
proplists:property({k}).
proplists:property({k, false}).
proplists:property([k, v]).
proplists:property([k, true]).

----------

proplists:property/2
返回一个简单键值属性的正常格式（最小化）的表示

用法：

property(Key, Value) -> Property
内部实现：

-spec property(Key, Value) -> Property when
      Key :: term(),
      Value :: term(),
      Property :: atom() | {term(), term()}.

property(Key, true) when is_atom(Key) ->
    Key;
property(Key, Value) ->
    {Key, Value}.
返回一个简单键值属性的正常格式（最小化）的表示。如果 Value 为 true 且 Key 是一个原子，那么返回 Key，否则返回一个 {Key, Value} 的元组。

proplists:property(k, true).
proplists:property(k, false).
proplists:property(k, v).
proplists:property({k}, true).

----------

proplists:split/2
按照键进行数据分割分组

用法：

split(List, Keys) -> {Lists, Rest}
内部实现：

-spec split(List, Keys) -> {Lists, Rest} when
      List :: [term()],
      Keys :: [term()],
      Lists :: [[term()]],
      Rest :: [term()].

split(List, Keys) ->
    {Store, Rest} = split(List, dict:from_list([{K, []} || K 
    if is_atom(P) ->
	    case dict:is_key(P, Store) of
		true ->
		    split(Ps, dict_prepend(P, P, Store), Rest);
		false ->
		    split(Ps, Store, [P | Rest])
	    end;
       tuple_size(P) >= 1 ->
	    %% Note that Key does not have to be an atom in this case.
	    Key = element(1, P),
	    case dict:is_key(Key, Store) of
		true ->
		    split(Ps, dict_prepend(Key, P, Store), Rest);
		false ->
		    split(Ps, Store, [P | Rest])
	    end;
       true ->
	    split(Ps, Store, [P | Rest])
    end;
split([], Store, Rest) ->
    {Store, Rest}.
把列表 List 分割成一个子列表 Lists 和一个剩余元素的列表 Rest。列表 Lists 是包含 Keys 里每一个键的一个子列表，并以相应的顺序排列。在子列表里元素的相对位置顺序的保存是按照原来列表 List 里的顺序。Rest 是跟给出的键没有相关联的元素的列表，它们的保存顺序也是按照原来列表里的顺序。

proplists:split([{c, 2}, {e, 1}, a, {c, 3, 4}, d, {b, 5}, b], [a, b, c]).

----------
proplists:substitute_aliases/2
替换列表里的键

用法：

substitute_aliases(Aliases, ListIn) -> ListOut
内部实现：

-spec substitute_aliases(Aliases, ListIn) -> ListOut when
      Aliases :: [{Key, Key}],
      Key :: term(),
      ListIn :: [term()],
      ListOut :: [term()].

substitute_aliases(As, Props) ->
    [substitute_aliases_1(As, P) || P 
    if is_atom(P), P =:= Key ->
	    property(Key1, true);
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    property(setelement(1, P, Key1));
       true ->
	    substitute_aliases_1(As, P)
    end;
substitute_aliases_1([], P) ->
    P.
替换列表里的键。列表里的每一个条目，如果参数 Aliases 是由 {K1, K2} 这种相关联的形式组成的列表，，那么跟键是 K1 的相关条目的键都会改为 K2。如果同样的 K1 不止一次出现在参数 Aliases，那么只有只有第一个会被使用。

proplists:substitute_aliases([{k1, a1}], [{k1, 1}, {k2, 2}, {k1, 3}, {k4, 4}, {k5, 5}]).
proplists:substitute_aliases([{k1, a1}, {k4, a4}], [{k1, 1}, {k2, 2}, {k1, 3}, {k4, 4}, {k5, 5}]).

----------
proplists:substitute_negations/2
替换列表里的键并对值取反

用法：

substitute_negations(Negations, List) -> List
内部实现：

-spec substitute_negations(Negations, ListIn) -> ListOut when
      Negations :: [{Key, Key}],
      Key :: term(),
      ListIn :: [term()],
      ListOut :: [term()].

substitute_negations(As, Props) ->
    [substitute_negations_1(As, P) || P 
    if is_atom(P), P =:= Key ->
	    property(Key1, false);
       tuple_size(P) >= 1, element(1, P) =:= Key ->
	    case P of
		{_, true} ->
		    property(Key1, false);
		{_, false} ->
		    property(Key1, true);
		_ ->
		    %% The property is supposed to be a boolean, so any
		    %% other tuple is interpreted as 'false', as done in
		    %% 'get_bool'.
		    property(Key1, true)
	    end;		    
       true ->
	    substitute_negations_1(As, P)
    end;
substitute_negations_1([], P) ->
    P.
替换列表里的键并对值取反。列表里的每一个条目，如果参数 Negations 是由 {K1, K2} 这种相关联的形式组成的列表，那么如果条目是 {K1, true} 的话，它将会被替换为 {K2, false}，否则，它将会被替换为 {K2, true}，即改变项的名字并对值的布尔属性（可由 proplists:get_bool/2 获得）取反。如果同样的 K1 不止一次出现在参数 Negations，那么只有只有第一个会被使用。

proplists:substitute_negations([{k1, a1}], [{k1, 1}, {k1, false}, {k2, 2}, {k1, true}, k1, {k4, 4}]).
proplists:substitute_negations([{k1, a1}, {k2, a2}], [{k1, 1}, {k1, false}, {k2, 2}, {k1, true}, k1, {k4, 4}]).

----------
proplists:unfold/1
把列表里的原子都打开呈现出来

用法：

unfold(List) -> List
内部实现：

-spec unfold(ListIn) -> ListOut when
      ListIn :: [term()],
      ListOut :: [term()].

unfold([P | Ps]) ->
    if is_atom(P) ->
	    [{P, true} | unfold(Ps)];
       true ->
	    [P | unfold(Ps)]
    end;
unfold([]) ->
    [].
把列表 List 里的原子都以 {Atom, true} 的形式呈现打开出来。

proplists:unfold([a, "b", 1, {c, false}, {d, true}, [e]]).