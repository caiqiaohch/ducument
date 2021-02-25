binary:at/2
返回一个二进制数据里指定位置的数据

用法：

at(Subject, Pos) -> byte()
返回一个二进制数据里指定位置（从 0 开始）的数据（整数的形式），如果 Pos >= byte_size(Subject)，则会发生一个 badarg 的异常错误。

Subject = >,
SubjectLen = byte_size(Subject), 
{MegaSecs, Secs, MicroSecs} = erlang:now(),
State = {MegaSecs, Secs, MicroSecs},
{Pos, _State} = ranDOM:uniform_s(SubjectLen - 1, State),
binary:at(Subject, Pos).

----------
binary:bin_to_list/1
把一个二进制数据转为一个整数列表

用法：

bin_to_list(Subject) -> [byte()]
跟 binary:bin_to_list/2 一样，都是把一个二进制数据 Subject 转为一个字节形式的列表，每个元素代表一个字节的值。用法等同于 binary:bin_to_list(Subject, {0, byte_size(Subject)})。

binary:bin_to_list(>).

----------
binary:bin_to_list/2
把一个二进制数据转为一个整数列表

用法：

bin_to_list(Subject, PosLen) -> [byte()]
把一个二进制数据 Subject 转为一个字节形式的列表，每个元素代表一个字节的值。参数 PosLen 是一个 {Pos, Len} 形式的元组，Pos 表示要开始转换的位置，Len 表示要转换的长度。

binary:bin_to_list(>, {1 ,3}).
如果参数 PosLen 超出了二进制的任何引用范围，那么将会抛出一个 badarg 的错误。

binary:bin_to_list(>, {1 ,33}).

----------
binary:bin_to_list/3
把一个二进制数据转为一个整数列表

用法：

bin_to_list(Subject, Pos, Len) -> [byte()]
跟 binary:bin_to_list/2 一样，都是把一个二进制数据 Subject 转为一个字节形式的列表，每个元素代表一个字节的值。参数 Pos 表示要开始转换的位置，Len 表示要转换的长度。

binary:bin_to_list(>, 1, 3).
如果参数 PosLen 超出了二进制的任何引用范围，那么将会抛出一个 badarg 的错误。

binary:bin_to_list(>, 1, 33).

----------
binary:copy/1
创建一个二进制数据副本

用法：

copy(Subject) -> binary()
创建二进制数据 Subject 的一个副本。

Binary = >,
binary:copy(Binary).

----------
binary:first/1
返回一个二进制的第一个字节

用法：

first(Subject) -> byte()
返回一个二进制 Subject 的第一个字节的 ASCII 码。如果二进制 Subject 的长度为 0，那么会有一个异常抛出。

binary:first(>).
binary:first(>).

----------
binary:last/1
返回一个二进制的最后一个字节

用法：

last(Subject) -> byte()
返回一个二进制 Subject 的最后一个字节的 ASCII 码。如果二进制 Subject 的长度为 0，那么会有一个异常抛出。

binary:last(>).
binary:last(>).

----------
binary:longest_common_suffix/1
返回在列表二进制数据里最长的公共后缀长度

用法：

longest_common_suffix(Binaries) -> integer() >= 0
返回在二进制数据列表里最长的公共后缀长度。如果参数不是一个扁平的二进制数据列表，那么将会出现一个 badarg 的异常。

binary:longest_common_suffix([>, >]).
binary:longest_common_suffix([>, >]).

----------
binary:match/2
在一个二进制数据里查找符合一个模式的第一个匹配

用法：

match(Subject, Pattern) -> Found | nomatch
在一个二进制数据 Subject 里查找符合一个模式 Pattern 的第一个匹配，用法跟 match(Subject, Pattern, []) 一样。

binary:match(>, [>, >]).

----------
binary:referenced_byte_size/1
检测一个二进制引用的实际二进制数据的大小

用法：

referenced_byte_size(Binary) -> integer() >= 0
如果 Binary 是一个很大二进制数据的一个二进制引用，那么该函数可以获取所引用的二进制数据的实际大小。

Binary = >,  
> = Binary,  
binary:referenced_byte_size(Bin).  

----------
binary:split/2
根据一个模式分割二进制数据

用法：

split(Subject, Pattern) -> Parts
根据模式把一个二进制数据 Subject 分割成一个二进制列表，在 Subject 里实际匹配到的那部分是不会包括在结果里。用法跟 binary:split/3 的 binary:split(Subject, Pattern, []) 一样。

binary:split(>, [>,>]).
binary:split(>, >, [global, trim]).

----------
