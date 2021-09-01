目前项目中将record结构转换为KVList, 然后保存到mongodb中
由于`record_info(fields,Record)`不支持传入参数,处理从record转换为kvlist比较麻烦



## 目前做法

目前的做法是罗列所有的record,如下:

```
save(Rec) when is_record(Rec, aaa) ->
    KvList = lists:zip(erlang:tl(tuple_to_list(Rec), record_info(fields, aaa)),
    %% 保存到mongodb
    save_db(KvList);
save(Rec) when is_record(Rec, bbb) ->
    KvList = lists:zip(erlang:tl(tuple_to_list(Rec), record_info(fields, bbb)),
    %% 保存到mongodb
    save_db(KvList);
...
```

如果存在`#aaa{id = #bbb{}}`这种结构,需要一层一层的手动解析

```
-define(REC_TO_KVLIST(Rec, RecName),        lists:zip(erlang:tl(tuple_to_list(Rec)), record_info(fields, RecName))        ).A = #aaa{id = #bbb{}},A1 = A#aaa{id = ?REC_TO_KVLIST(A#aaa.id, bbb)},A2 = ?REC_TO_KVLIST(A1, aaa),保存到mongodb中save_db(A2)
```

相应的,从mongodb中读取数据,也要进行多次转换
稍微不注意就会出现db升级失败,数据丢失

## 可能的解决方法(未在项目中使用)

**归根到底还是`record_info`,不支持传入参数**
搜索github, 发现[record_info_runtime](https://github.com/okeuday/record_info_runtime.git)

| erl文件                                                      |                                                              |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [`record_info_runtime.erl`](https://www.mingilin.com/downloads/code/record_info_runtime.erl) | Parse transform for using record_info(size, _) and record_info(fields, _) during runtime 增加了`record_init/1` |
| [`l2r.erl`](https://www.mingilin.com/downloads/code/l2r.erl) | record,kvlist互转                                            |
| [`rec_a.hrl`](https://www.mingilin.com/downloads/code/rec_a.hrl) | 测试头文件                                                   |

## 运行结果

```
Eshell V6.3  (abort with ^G)
1> rr("rec_a.hrl").
[name,person]
2> KV = l2r:rec_to_kvlist(#person{}).
[{'__record_name__',person},
 {id,0},
 {name,[{'__record_name__',name},{first,"aaa"},{last,"bbb"}]},
 {names,[[{'__record_name__',name},{first,"abc"},{last,[]}],
         [{'__record_name__',name},{first,[]},{last,"def"}]]},
 {sex,0}]
3> l2r:kvlist_to_rec(KV).
#person{id = 0,
        name = #name{first = "aaa",last = "bbb"},
        names = [#name{first = "abc",last = []},
                 #name{first = [],last = "def"}],
        sex = 0}
4> #person{}.
#person{id = 0,
        name = #name{first = "aaa",last = "bbb"},
        names = [#name{first = "abc",last = []},
                 #name{first = [],last = "def"}],
        sex = 0}
5>
```

## 最后贴代码凑字数

```
%% coding: latin-1
%%%-----------------------------------------------
%%% @doc
%%%     record,kvlist互转
%%%     包含头文件即可
%%% @end
%%%-----------------------------------------------
-module(l2r).

-include("rec_a.hrl").

-define(RECORD_NAME, '__record_name__').

-define(ERROR_MSG(Format, Args), io:format("[ERROR]" ++ Format ++ "\n", Args)).
-define(INFO_MSG(Format, Args), io:format("[INFO]" ++ Format ++ "\n", Args)).

-compile([{parse_transform, record_info_runtime}]).

-export([
         rec_to_kvlist/1,
         kvlist_to_rec/1
        ]).

-export([
         records/0,
         record_info_fields/1,
         record_info_size/1
        ]).

rec_to_kvlist(Rec) ->
    rec_to_kvlist_f1(Rec, 1).

rec_to_kvlist_f1(Rec, Depth) when Depth > 10 ->
    throw({error, Depth, Rec});
rec_to_kvlist_f1(Rec, Depth) when is_tuple(Rec) ->
    case is_record(Rec) of
        true ->
            RecName = erlang:element(1, Rec),
            Fields = [?RECORD_NAME|record_info_fields(RecName)],
            Values = tuple_to_list(Rec),
            Fun = fun({Field, Value}) when is_tuple(Value) ->
                          {Field, rec_to_kvlist_f1(Value, Depth + 1)};
                     ({Field, Value}) when is_list(Value) ->
                          {Field, [rec_to_kvlist_f1(V, Depth + 1) || V <- Value]};
                     ({Field, Value}) ->
                          {Field, Value}
                  end,
            lists:map(Fun, lists:zip(Fields, Values));
        false ->
            Rec
    end;
rec_to_kvlist_f1(Val, _) -> Val.

kvlist_to_rec(KvList) when is_list(KvList) ->
    case proplists:get_value(?RECORD_NAME, KvList) of
        undefined ->
            Fun = fun(Val) -> kvlist_to_rec(Val) end,
            lists:map(Fun, KvList);
        RecName ->
            InitList = lists:zip(
                         [?RECORD_NAME|record_info_fields(RecName)],
                         tuple_to_list(record_init(RecName))),
            Fun = fun(Field) ->
                          case proplists:get_value(Field, KvList) of
                              undefined ->
                                  proplists:get_value(Field, InitList);
                              Val when is_list(Val) ->
                                  kvlist_to_rec(Val);
                              Val ->
                                  Val
                          end
                  end,
            list_to_tuple(lists:map(Fun, [?RECORD_NAME|record_info_fields(RecName)]))
    end;
kvlist_to_rec(KvList) -> KvList.

is_record(Rec) when is_tuple(Rec), tuple_size(Rec) >= 1 ->
    RecName = erlang:element(1, Rec),

    is_list(record_info_fields(RecName))
    andalso length(tuple_to_list(Rec)) =:= record_info_size(RecName);
is_record(_Other) -> false.
```



[# erlang](https://www.mingilin.com/tags/erlang/)