io 标准输入输出（I/O）服务接口函数

io:columns/0
返回默认输出端的列数

用法：

columns() -> {ok, integer() >= 1} | {error, enotsup}
返回默认输出端的列数，该函数只在终端下调用才能返回正确的结果值，其他输出端只返回 {error, enotsup}

Columns = io:columns(),
io:format("Columns is ~p~n", [Columns]).

----------
io:columns/1
返回指定输出端的列数

用法：

columns(IoDevice) -> {ok, integer() >= 1} | {error, enotsup}
返回指定输出端 IoDevice 的列数，该函数只在终端下调用才能返回正确的结果值，其他输出端只返回 {error, enotsup}

{ok, IoDevice} = file:open("test.txt", write),
Columns = io:columns(IoDevice),
io:format("Columns is ~p~n", [Columns]).

----------
io:format/1
按照指定的格式把数据写入到输出端上

用法：

format(Format) -> ok
内部实现：

-spec format(Format) -> 'ok' when
      Format :: format().

format(Format) ->
    format(Format, []).
参数 Format 是要一个要被写入到默认输出端的字符串，io:format(Format) 跟函数 io:format/2 的 io:format(Format, []) 一样

io:format("Hello World!").

----------
io:format/2
按照指定的格式把数据写入到输出端上

用法：

format(Format, Data) -> ok
内部实现：

-spec format(Format, Data) -> 'ok' when
      Format :: format(),
      Data :: [term()].

format(Format, Args) ->
    format(default_output(), Format, Args).
把参数 Data 里的每一项根据 Format 的输出格式写入到默认输出端。

其中参数 Format 的写法形式是 "~F.P.PadModC"

F表示输出长度和格式
P表示输出精度
Pad表示输出填充字符
Mod控制类型的修饰
C表示控制类型
比如常见的格式参数有：

~c 表示只接受 ASCII 码所表示的数字，例如下面 10.5c 表示打印 5 次 a，长度是 10 的字符串（长度不足时空格表示）：

io:format("|~10.5c|", [$a]).  
~f 表示浮点数输出，默认保留 6 为小数，下面的 15.2f 表示数字总共占 15 位，小数保留 2 位（保留时四舍五入）

Pi = math:pi(),
io:format("Pi is ~15.2f", [Pi]).  
~s 表示按字符串形式输出：

io:format("abcdefg~s", [hijklmn]).  
Chinese = unicode:characters_to_list("中文测试"),
io:format("~ts~n", [Chinese]).
~w 表示输出一个 Erlang term

io:format("List is ~w", [[97]]).  
~p 与 ~w 类似，不过 ~p 的输出是有格式的，默认一行的显示的最大长度为80，则多行时会自动换行

L = lists:seq(1, 100),
io:format("L is ~p", [L]).
~n 表示换行符

io:format("newline1~n newline2~n", []).  

----------
io:format/3
按照指定的格式把数据写入到输出端上

用法：

format(IoDevice, Format, Data) -> ok
内部实现：

-spec format(IoDevice, Format, Data) -> 'ok' when
      IoDevice :: device(),
      Format :: format(),
      Data :: [term()].

format(Io, Format, Args) ->
    o_request(Io, {format,Format,Args}, format).
跟 io:format/2 唯一的区别就是多了一个输出端 IoDevice 参数，不用原来默认的输出端作为输出载体，其他参数 Format 和 Data 跟 io:format/2 一样。

这个函数需要指定一个输出端（通常，调用 file:open/2 会返回一个输出端）然后作为参数传入给函数，假设当前目录下有个 test.txt 的文件

{ok, IoDevice} = file:open("test.txt", write),
io:format(IoDevice, "~s~n", ["Just a test!"]).

----------
io:fread/2
读入一个格式化的数据

用法：

fread(Prompt, Format) -> Result
从当前默认输入端里读入一个指定格式 Format 的数据，参数 Format 的用法跟 io:format/2 里的 Format 参数一样。如果输入的数据跟期望的格式 Format 数据不一样的话，则抛出一个错误。

{ok, [Input]} = io:fread("Input something: ", "~s"),
io:format("Input is ~p~n", [Input]).
{ok, [Input1, Input2]} = io:fread("Input something: ", "~d, ~d"),
io:format("Input is ~p ~p~n", [Input1, Input2]).

----------
io:fread/2
读入一个格式化的数据

用法：

fread(Prompt, Format) -> Result
从当前默认输入端里读入一个指定格式 Format 的数据，参数 Format 的用法跟 io:format/2 里的 Format 参数一样。如果输入的数据跟期望的格式 Format 数据不一样的话，则抛出一个错误。

{ok, [Input]} = io:fread("Input something: ", "~s"),
io:format("Input is ~p~n", [Input]).
{ok, [Input1, Input2]} = io:fread("Input something: ", "~d, ~d"),
io:format("Input is ~p ~p~n", [Input1, Input2]).

----------
io:fread/3
读入一个格式化的数据

用法：

fread(IoDevice, Prompt, Format) -> Result
从一个指定输出端 IoDevice 里读入一个指定格式 Format 的数据，参数 Format 的用法跟 io:format/2 里的 Format 参数一样。如果输入的数据跟期望的格式 Format 数据不一样的话，则抛出一个错误。

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:fread/3 读取 test.txt 文件里的数据：

{ok, IoDevice} = file:open("test.txt", [read]),
{ok, [Input]} = io:fread(IoDevice, "", "~s").

----------
io:fwrite/1
按照指定的格式把数据写入到输出端上

用法：

fwrite(Format) -> ok
内部实现：

-spec fwrite(Format) -> 'ok' when
      Format :: format().

fwrite(Format) ->
    format(Format).
由其实现可知，其用法跟 io:format/1 一样，详细用法可看 io:format/1。

io:fwrite("Hello World!").

----------
io:fwrite/2
按照指定的格式把数据写入到输出端上

用法：

fwrite(Format, Data) -> ok
内部实现：

-spec fwrite(Format, Data) -> 'ok' when
      Format :: format(),
      Data :: [term()].

fwrite(Format, Args) ->
    format(Format, Args).
由其实现可知，其用法跟 io:format/2 一样，详细用法可看 io:format/2。

L = lists:seq(1, 100),
io:fwrite("L is ~p", [L]).

----------
io:fwrite/3
按照指定的格式把数据写入到输出端上

用法：

fwrite(IoDevice, Format, Data) -> ok
内部实现：

-spec fwrite(IoDevice, Format, Data) -> 'ok' when
      IoDevice :: device(),
      Format :: format(),
      Data :: [term()].

fwrite(Io, Format, Args) ->
    format(Io, Format, Args).
由其实现可知，其用法跟 io:format/3 一样，详细用法可看 io:format/3。

{ok, IoDevice} = file:open("test.txt", write),
io:fwrite(IoDevice, "~s~n", ["Just a test!"]).

----------
io:get_chars/2
读取默认输出端里输入的前 N 个字符

用法：

get_chars(Prompt, Count) -> Data | eof
读取默认输出端里输入的前 Count 个字符。

在终端输入下面代码，然后输入一些字符，便会从输入的字符中截取前 5 个字符出来：

io:get_chars("Enter something: ", 5).

----------
io:get_chars/3
读取指定输出端里的输入前 N 个字符

用法：

get_chars(IoDevice, Prompt, Count) -> Data | eof | {error, Reason}
读取指定输出端 IoDevice 里前 Count 个字符。

下面代码是读取文件 test.txt 的前 5 个字符，读取是循环读取，下一次读取会在上一次的地方开始读取

{ok, IoDevice} = file:open("test.txt", read),
io:get_chars(IoDevice, "Read file string: ", 5).

----------
io:get_line/1
读取 当前默认输入端的一行数据

用法：

get_line(Prompt) -> Data | eof | {error, Reason}
输出提示，并把当前默认输出端里输入的一行数据读取出来。

io:get_line("Read a line: ").

----------
io:get_line/2
读取指定输入端的一行数据

用法：

get_line(IoDevice, Prompt) -> Data | eof | {error, term()}
读取指定输入端 IoDevice 里的一行数据。

下面是读取文件 test.txt 的一行数据，读取循环读，下一次读取会接着上一次。

{ok, File} = file:open("test.txt", read), 
io:get_line(File, "Read a line").

----------
io:getopts/0
获取当前默认输出端的配置选项

用法：

getopts/0
获取当前默认输出端的配置选项。

Opts = io:getopts(),
io:format("Opts is ~p~n", [Opts]).

----------
io:getopts/1
获取指定输出端的配置选项

用法：

getopts/1
获取指定输出端 IoDevice 的配置选项，下面是获取 test.txt 文件的 IO 配置选项。

{ok, IoDevice} = file:open("test.txt", [read]),
io:getopts(IoDevice).

----------
io:nl/0
向默认输出端写入一个换行符

用法：

nl() -> ok
向默认输出端写入一个换行符

io:nl().

----------
io:parse_erl_exprs/1
读取并解析 Erlang 表达式

用法：

parse_erl_exprs(Prompt) -> Result
从当前默认输入端读入数据，并把它解析为 Erlang 表达式

io:parse_erl_exprs("Input something linke 'now().': ").

----------
io:parse_erl_exprs/2
读取并解析 Erlang 表达式

用法：

parse_erl_exprs(IoDevice, Prompt) -> Result
从指定输入端 IoDevice 读入数据，并把它解析为 Erlang 表达式

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:parse_erl_exprs/2 读取 test.txt 文件里的一行数据，并把它解析为 Erlang 表达式：

{ok, File} = file:open("test.txt", read), 
io:parse_erl_exprs(File, "").

----------
io:parse_erl_exprs/3
读取并解析 Erlang 表达式

用法：

parse_erl_exprs(IoDevice, Prompt, StartLine) -> Result
从指定输入端 IoDevice 读入第 StartLine 行数据，并把它解析为 Erlang 表达式

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:parse_erl_exprs/3 读取 test.txt 文件里的第 2 行数据，并把它解析为 Erlang 表达式：

{ok, File} = file:open("test.txt", read), 
io:parse_erl_exprs(File, "", 2).

----------
io:parse_erl_form/1
读取并解析 Erlang 表达式

用法：

parse_erl_form(Prompt) -> Result
跟 io:parse_erl_exprs/1 一样，都是从当前默认输入端读入数据，并把它解析为 Erlang 表达式

io:parse_erl_form("Input something linke 'now().': ").

----------
io:parse_erl_form/2
读取并解析 Erlang 表达式

用法：

parse_erl_form(IoDevice, Prompt) -> Result
跟 io:parse_erl_exprs/2 一样，从指定输入端 IoDevice 读入数据，并把它解析为 Erlang 表达式

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:parse_erl_form/2 读取 test.txt 文件里的一行数据，并把它解析为 Erlang 表达式：

{ok, File} = file:open("test.txt", read), 
io:parse_erl_form(File, "").

----------

io:parse_erl_form/3
读取并解析 Erlang 表达式

用法：

parse_erl_form(IoDevice, Prompt, StartLine) -> Result
跟 io:parse_erl_exprs/3 一样，从指定输入端 IoDevice 读入第 StartLine 行数据，并把它解析为 Erlang 表达式

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:parse_erl_form/3 读取 test.txt 文件里的第 2 行数据，并把它解析为 Erlang 表达式：

{ok, File} = file:open("test.txt", read), 
io:parse_erl_form(File, "", 2).

----------
io:put_chars/1
向默认输出端写入字符数据

用法：

put_chars(CharData) -> ok
向默认输出端写入字符数据 CharData

io:put_chars("Just a test!\n").

----------
io:put_chars/2
向指定输出端写入字符数据

用法：

put_chars(IoDevice, IoData) -> ok
向指定输出端 IoDevice 写入字符数据 IoData，假设当前目录下有个名为 test.txt 的文件，那么可以给这个 test.txt 文件的末尾上加上一行数据：

{ok, IoDevice} = file:open("test.txt", write),
io:put_chars(IoDevice, "Just a test!\n").

----------
io:read/1
读入一个 Erlang 项元

用法：

read(Prompt) -> Result
从默认输出端里读入一个 Erlang 项元

io:read("Input something: ").

----------
io:read/2
读入一个 Erlang 项元

用法：

read(IoDevice, Prompt) -> Result
从指定输出端 IoDevice 里读入一个 Erlang 项元。

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:read/2 读取 test.txt 文件里的数据：

{ok, File} = file:open("test.txt", read), 
io:read(File, "").

----------
io:read/3
读入一个 Erlang 项元

用法：

read(IoDevice, Prompt, StartLine) -> Result
从指定输出端 IoDevice 里的第 StartLine 行开始读入一个 Erlang 项元。

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:read/3 读取 test.txt 文件里的第 2 行数据：

{ok, File} = file:open("test.txt", read), 
io:read(File, "", 2).

----------
io:rows/1
返回指定输出端的行数

用法：

rows(IoDevice) -> {ok, integer() >= 1} | {error, enotsup}
返回指定输出端 IoDevice 的行数，该函数只在终端下调用才能返回正确的结果值，其他输出端只返回 {error, enotsup}

{ok, IoDevice} = file:open("test.txt", write),
Rows = io:columns(IoDevice),
io:format("Rows is ~p~n", [Rows]).

----------
io:scan_erl_exprs/1
读取并转换为 Erlang 表达式

用法：

scan_erl_exprs(Prompt) -> Result
从当前默认输入端读入数据，并把它转换为 Erlang 表达式

io:scan_erl_exprs("Input something linke 'now().': ").
如果输入的值不符合表达式的规则，则报错

io:scan_erl_exprs("Input something linke '1.0er.': ").

----------
io:scan_erl_exprs/2
读取并转换为 Erlang 表达式

用法：

scan_erl_exprs(Device, Prompt) -> Result
从指定输入端 Device 读入数据，并把它转换为 Erlang 表达式

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:scan_erl_exprs/2 读取 test.txt 文件里的一行数据，并把它转换为 Erlang 表达式：

{ok, File} = file:open("test.txt", read), 
io:scan_erl_exprs(File, "").

----------
io:scan_erl_exprs/3
读取并转换为 Erlang 表达式

用法：

scan_erl_exprs(Device, Prompt, StartLine) -> Result
从指定输入端 Device 读入第 StartLine 行数据，并把它转换为 Erlang 表达式

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:scan_erl_exprs/2 读取 test.txt 文件里的第 2 行数据，并把它转换为 Erlang 表达式：

{ok, File} = file:open("test.txt", read), 
io:scan_erl_exprs(File, "", 2).

----------
io:scan_erl_form/1
读取并转换为 Erlang 表达式

用法：

scan_erl_form(Prompt) -> Result
跟 io:scan_erl_exprs/1 一样，都是从当前默认输入端读入数据，并把它转换为 Erlang 表达式

io:scan_erl_form("Input something linke 'now().': ").
如果输入的值不符合表达式的规则，则报错

io:scan_erl_form("Input something linke '1.0er.': ").

----------
io:scan_erl_form/2
读取并转换为 Erlang 表达式

用法：

scan_erl_form(IoDevice, Prompt) -> Result
跟 io:scan_erl_exprs/2 一样，从指定输入端 Device 读入数据，并把它解析为 Erlang 表达式

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:scan_erl_form/2 读取 test.txt 文件里的一行数据，并把它转换为 Erlang 表达式：

{ok, File} = file:open("test.txt", read), 
io:scan_erl_form(File, "").

----------
io:scan_erl_form/3
读取并转换为 Erlang 表达式

用法：

scan_erl_form(IoDevice, Prompt, StartLine) -> Result
跟 io:scan_erl_exprs/3 一样，从指定输入端 Device 读入第 StartLine 行数据，并把它转换为 Erlang 表达式

假如有一个名为 test.txt 的文件，其内容如下：

{line1, "a", "b", [{key1, val1}]}.
{line2, "c", "d", [{key2, val2}]}.
那么可以用 io:scan_erl_form/2 读取 test.txt 文件里的第 2 行数据，并把它解析为 Erlang 表达式：

{ok, File} = file:open("test.txt", read), 
io:scan_erl_form(File, "", 2).

----------
io:setopts/1
设置当前默认输出端的配置选项

用法：

setopts(Opts) -> ok | {error, Reason}
设置当前默认输出端的配置选项

io:setopts([{encoding, unicode}]),
io:getopts().

----------
io:setopts/2
设置指定输出端的配置选项

用法：

setopts(IoDevice, Opts) -> ok | {error, Reason}
设置指定输出端 IoDevice 的配置选项 Opts，下面是设置 test.txt 文件的 IO 配置选项。

{ok, IoDevice} = file:open("test.txt", [read]),
io:setopts(IoDevice, [{encoding, unicode}]),
io:getopts(IoDevice).

----------
io:write/1
打印输出一个 Erlang 项元

用法：

write(Term) -> ok
打印输出一个 Erlang 项元 Term

io:write('Just a test!').

----------
io:write/2
打印输出一个 Erlang 项元

用法：

write(IoDevice, Term) -> ok
向指定输出端 IoDevice 打印输出一个 Erlang 项元 Term

{ok, IoDevice} = file:open("test.txt", [write]),
io:write(IoDevice, 'Just a test!'),
file:close(IoDevice). 

----------
