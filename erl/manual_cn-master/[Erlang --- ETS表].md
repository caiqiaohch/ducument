# [Erlang --- ETS表]

ETS和进程字典都是Erlang所独有的。

ETS是Erlang Term Storage 的缩写，它是一个基于内存的KV( Key Value) Table，支持大数据量存储以及高效查询。

要使用ETS表，首先就要先新建ETS表。

1.ets:new(?ETS_SYS_BUILDING,[{keypos,#ets_sys_building.sysBuildingId},named_table,public,set])

其中

?ETS_SYS_BUILDING：是表名

{keypos,#ets_sys_building.sysBuilding}：将key设定为#ets_sys_building.sysBuildingId (可以省略)

注意：ets表是基于KV的，也就是key value即key -->{key,value},其中value是一个元组，而key默认为value的第一个元素，现在将key设为#ets_sys_building.sysBuildingId，从key可以看出，这个ets表的value是一个以ets_sys_building为开头的元组，所以要想知道ets表的value，可以看ets_sys_building记录的定义。

表名和value没有必要的联系，但为了操作方便，一般会把表名和记录名用作同一个名字。

named_table：若指定了named_table这个属性，就可以使用表名(也就是new函数的第一个参数Name)对表进行操作，而无需使用TableId。

public：指 定table的访问权限，若是public表示所有process都可以对该table进行读写(只要你知道TableId或者 TableName)，private表示只有创建表的process才能对table进行读写，而protected则表示所有的process都可以 对表进行读取，但是只有创建表的process能够对表进行写操作（可以省略,默认为protected）。

set：指定创建的table类型

 

2.ets:insert(Tab,ObjectOrObjects) -> true

向 ETS 表 Tab 插入一个对象数据或者一个对象列表数据 ObjectOrObjects。 如果表是一个 set 类型的表，并且插入的对象数据的键在表里可以匹配得到数据，那么旧的对象数据将会被替换。 如果表是一个 ordered_set 类型的表，并且在表里有跟插入的对象数据有相同的键，那么旧的对象数据将会被替换。 如果插入的对象列表数据里存在多个相同键的情况，并且表是一个 set 类型的表，那么只有一个对象数据可以被插入，不过不确定是哪一个。对于 ordered_set 类型的表，如果键一样时，操作的情况像上面一样。 整个操作都保持着原子性和独立性，即使有多个对象数据插入的情况。

 

3.ets:tab2list(Tab) -> [Object]

返回一个ETS表的所有对象数据的列表。

 

4.ets:lookup(Tab,Key) -> [Object]

返回表 Tab 里键为 Key 的所有对象数据的列表，注意，这里一定要用key进行匹配，不能用其他的字段。

在类型是 set、bag、duplicate_bag 表里，只有跟键 Key 相匹配的对象数据才会返回。如果是 ordered_set 类型的表的话，就只有跟键相等的情况下才会返回。这两者的区别就像 =:= 跟 == 一样。

如果是 set 或 ordered_set 类型的表，那么该函数会返回一个空列表或者一个元素的列表，因为这些类型的表里不可能存在多个相同键的对象数据。如果是 bag 或 duplicate_bag 类型的表，那么该函数则返回任意长度的列表。

数据插入的顺序是有保存的，第一笔插入的数据，返回的时候也是排在第一位。

在类型是 set、bag、duplicate_bag 表里，插入和查找的时间是恒定的，跟表的大小无关。对于 ordered_set 类型的表，插入和查找的时间跟表的大小成正比。

 

5.ets:fun2ms(LiteralFun) -> MatchSpec

使用一个解析转换的仿函数 ListeralFun 作为参数传递给该函数转换出一个匹配规范。"literal" 意味着函数必须以文本的形式作为函数的参数，它不能是依次传递给函数的变量。

匹配规范解析转换是在 ms_transform 模块里实现，源码里必须引入标准库（STDLIB）里的 "ms_transform.hrl" 的头文件才能使仿函数正常使用。源码里引入头文件失败的话，会报一个运行时错误，而不是一个编译时错误。包函此文件很简单，只要在代码文件里添加下面一行就行： `-include_lib(``"stdlib/include/ms_transform.hrl"``).`

伪函数 LiteralFun 的有很严格的限制条件，它只提供一个的参数（用于匹配的对象）：一个单一的变量或一个元组。而且必须使用像 is_XXX 类似的断言检测。例如：if、case、receive 之类的语法结果是不允许出现在匹配规范中的。 函数返回的值就是一个匹配规范。

Erlang 内置的函数可以被匹配规范函数调用。

 

6.ets:`select(``Tab``, ``MatchSpec``) -> [``Match``]`

使用一个匹配描述从表 Tab 里匹配对象。

 

ets:fun2ms函数和ets:select函数一般会一起使用，例如：

get_sys_award_info(SysActiveId) ->

 MS = ets:fun2ms(fun(T) when (T#ets_sys_activity_award.sysActivityId == SysActiveId) -> T end),

 ets:select(?ETS_SYS_ACTIVITY_AWARD, MS).

 

7.ets:i(Tab) -> 'ok' :在输出端上打印显示指定ETS表的Tab信息

ets:i() -> 'ok' :在输出端上打印显示所有ETS表的信息

 

8.ets: `delete_all_objects(``Tab``) -> true`

删除表 Tab 里的所有对象数据。该操作会保持数据的原子性（atomic）和独立性（isolated）。

心中有美景，走到哪都是美景。