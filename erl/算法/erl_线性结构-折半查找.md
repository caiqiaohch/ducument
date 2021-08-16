# erl_线性结构-折半查找



折半查找又叫二分查找：在有序表中，把待查找数据值与查找范围的中间元素值进行比较。
优点是比较次数少，查找速度快，平均性能好；其缺点是要求待查表为有序表，且插入删除困难。
经常用于变动不平凡的数据结构。

代码如下：

%% 有序列表可以用折半查找 min->max
half_find([],_)->
 false;
half_find(List,Data)->
 Len = length(List),
 HalfPos = ceil(Len/2),
 HalfData = lists:nth(HalfPos,List),
 {HList,TList} = lists:split(HalfPos,List),
 if Data > HalfData->
   half_find(HList,Data);
  Data < HalfData->
   half_find(TList,Data);
  true->
   HalfData
 end.

ceil(N) ->
 T = trunc(N),
 case N == T of
  true -> T;
  false -> 1 + T
 end.

总结：
其实这样的有序lists 和avl_tree 的查找差不错，gb_tree 的平衡（balance函数）处理就是先把二叉树变成有序lists让后再折半平衡重构。

感兴趣可以看看gb_tree 的balance代码

-spec balance(Tree1) -> Tree2 when
      Tree1 :: tree(Key, Value),
      Tree2 :: tree(Key, Value).

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
————————————————
版权声明：本文为CSDN博主「sugarO_o」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/u011518176/article/details/48348303