ets:all/0
获取所有的 ets 表

用法：

all() -> [Tab]
返回当前节点里所有的 ETS 表，如果表有命名，则返回表的名字，否则返回表的标识符。

ets:all().

----------
ets:delete/1
删除整张表

用法：

delete(Tab) -> true
删除整张表 Tab。

TableId = ets:new(test_ets_new, [set, named_table]),
ets:insert(TableId, {a, 1}),
ets:delete(TableId).

----------
ets:delete/2
删除表里指定键的所有数据

用法：

delete(Tab, Key) -> true
删除表 Tab 里键为 Key 的所有数据。

TabId = ets:new(test_ets_new, [duplicate_bag, named_table]),
ets:insert(TabId, [{a, 1}, {b, 2}, {a, 3}]),
ets:delete(TabId, a).
TabId = ets:new(test_ets_new, [duplicate_bag, named_table]),
ets:insert(TabId, [{a, 1}, {b, 2}, {a, 3}]),
ets:delete(TabId, a),
ets:tab2list(TabId).

----------
ets:delete_all_objects/1
删除表里的所有数据

用法：

delete_all_objects(Tab) -> true
删除表 Tab 里的所有对象数据。该操作会保持数据的原子性（atomic）和独立性（isolated）。

TableId = ets:new(test_ets_new, [set, named_table]),
ets:insert(TableId, [{a, 1}, {b, 2}, {c, 3}]),
ets:delete_all_objects(TableId).

----------
ets:delete_object/2
删除表里的指定数据

用法：

delete_object(Tab,Object) -> true
删除与 Object 完全匹配的对象数据，只有键相同但有其他不匹配的，则不会被删除（这对 bag 类型的表很有用）。在类型是 duplicate_bag 的表里，所有匹配的对象数据都会被删除。

TableId = ets:new(test_ets_new, [named_table, bag]),
ets:insert(TableId, [{a, 1}, {b, 2}, {a, 3}, {c, 4}]),
ets:delete_object(TableId, {a, 3}),
ets:tab2list(TableId).
TableId = ets:new(test_ets_new, [named_table, bag]),
ets:insert(TableId, [{a, 1}, {b, 2}, {a, 3}, {c, 4}]),
ets:delete_object(TableId, {a, 5}),
ets:tab2list(TableId).

