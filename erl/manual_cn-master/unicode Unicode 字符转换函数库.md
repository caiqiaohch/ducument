unicode:bom_to_encoding/1
检测一个二进制数据的 UTF 字节顺序标记

用法：

bom_to_encoding(Bin) -> {Encoding, Length}
内部实现：

-spec bom_to_encoding(Bin) -> {Encoding, Length} when
      Bin :: binary(),
      Encoding ::  'latin1' | 'utf8'
                 | {'utf16', endian()}
                 | {'utf32', endian()},
      Length :: non_neg_integer().

bom_to_encoding(>) ->
    {utf8,3};
bom_to_encoding(>) ->
    {{utf32,big},4};
bom_to_encoding(>) ->
    {{utf32,little},4};
bom_to_encoding(>) ->
    {{utf16,big},2};
bom_to_encoding(>) ->
    {{utf16,little},2};
bom_to_encoding(Bin) when is_binary(Bin) ->
    {latin1,0}.
检测一个二进制数据 Bin 的 UTF 字节顺序标记（Byte Order Mark）

unicode:bom_to_encoding(>).
unicode:bom_to_encoding(>).
unicode:bom_to_encoding(>).
如果找不到字节顺序标记，则返回 {latin1,0}。

unicode:bom_to_encoding(>).
下面把读入的文件 test.txt 的编码 encoding 设置为输出端的编码：

{ok, File} = file:open("test.txt", [read, binary]),
{ok, Bin} = file:read(File, 4),
{Encoding, _Length} = unicode:bom_to_encoding(Bin),
io:setopts(File, [{encoding, Encoding}]).

----------
unicode:characters_to_binary/1
把一个字符集数据转换为一个 UTF-8 的二进制数据

用法：

characters_to_binary(Data) -> Result
把一个字符集数据 Data 转换为一个 UTF-8 的二进制数据，其效用跟 unicode:characters_to_binary(Data, unicode, unicode) 一样。

unicode:characters_to_binary("中文字符").
Result = unicode:characters_to_binary("中文字符"),
io:format("~ts ~n", [Result]).

----------
unicode:characters_to_binary/2
把一个字符集数据转换为一个 UTF-8 的二进制数据

用法：

characters_to_binary(Data,InEncoding) -> Result
把一个字符集数据 Data 转换为一个 UTF-8 的二进制数据，并把传入的数据 Data 的编码定义解释为 InEncoding，其效用跟 unicode:characters_to_binary(Data, InEncoding, unicode) 一样。

unicode:characters_to_binary("中文字符", utf8).
Result = unicode:characters_to_binary("中文字符", utf8),
io:format("~ts ~n", [Result]).

----------
unicode:characters_to_binary/3
把一个字符集数据转换为一个 UTF-8 的二进制数据

用法：

characters_to_binary(Data, InEncoding, OutEncoding) -> Result
把一个字符集数据 Data 转换为一个 UTF-8 的二进制数据，并把传入的数据 Data 的编码定义解释为 InEncoding，把生产数据的编码定义为 OutEncoding。

unicode:characters_to_binary("中文字符", utf8, utf8).
Result = unicode:characters_to_binary("中文字符", utf8, utf8),
io:format("~ts ~n", [Result]).

----------
unicode:characters_to_list/1
把一个字符集数据转换为一个 Unicode 列表

用法：

characters_to_list(Data) -> Result
把一个字符集数据 Data 转换为一个 Unicode 列表，其效用跟 unicode:characters_to_list(Data,unicode) 一样。

unicode:characters_to_list("中文字符").
Chinese = unicode:characters_to_list("中文字符"),
io:format("~ts~n", [Chinese]).

----------
unicode:characters_to_list/2
把一个字符集数据转换为一个 Unicode 列表

用法：

characters_to_list(Data, InEncoding) -> Result
把一个字符集数据 Data 转换为一个 Unicode 列表，并把传入的数据 Data 的编码定义解释为 InEncoding

unicode:characters_to_list("中文字符", utf8).
Chinese = unicode:characters_to_list("中文字符", utf8),
io:format("~ts~n", [Chinese]).

----------
unicode:encoding_to_bom/1
从编码里生成一个二进制的 UTF 字节顺序标记

用法：

encoding_to_bom(InEncoding) -> Bin
内部实现：

-spec encoding_to_bom(InEncoding) -> Bin when
      Bin :: binary(),
      InEncoding :: encoding().

encoding_to_bom(unicode) ->
    >;
encoding_to_bom(utf8) ->
    >;
encoding_to_bom(utf16) ->
    >;
encoding_to_bom({utf16,big}) ->
    >;
encoding_to_bom({utf16,little}) ->
    >;
encoding_to_bom(utf32) ->
    >;
encoding_to_bom({utf32,big}) ->
    >;
encoding_to_bom({utf32,little}) ->
    >;
encoding_to_bom(latin1) ->
    >.
从输入编码 InEncoding 里生成一个二进制的 UTF 字节顺序标记

unicode:encoding_to_bom(unicode).
unicode:encoding_to_bom(utf8).
unicode:encoding_to_bom(utf16).
unicode:encoding_to_bom({utf16,big}).
unicode:encoding_to_bom({utf16,little}).
unicode:encoding_to_bom(utf32).
unicode:encoding_to_bom({utf32,big}).
unicode:encoding_to_bom({utf32,little}).
unicode:encoding_to_bom(latin1).

----------
