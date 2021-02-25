string:centre/2
让字符串中间对齐

用法：

centre(String, Number) -> Centered
内部实现：

-spec centre(String, Number) -> Centered when
      String :: string(),
      Centered :: string(),
      Number :: non_neg_integer().

centre(String, Len) when is_integer(Len) -> centre(String, Len, $\s).

-spec centre(String, Number, Character) -> Centered when
      String :: string(),
      Centered :: string(),
      Number :: non_neg_integer(),
      Character :: char().

centre(String, 0, Char) when is_list(String), is_integer(Char) ->
    [];                       % Strange cases to centre string
centre(String, Len, Char) when is_integer(Char) ->
    Slen = length(String),
    if
	Slen > Len -> substr(String, (Slen-Len) div 2 + 1, Len);
	Slen 
	    N = (Len-Slen) div 2,
	    r_pad(l_pad(String, Len-(Slen+N), Char), N, Char);
	Slen =:= Len -> String
    end.
返回一个从字符串中间开始，扩充到指定长度 Number 的新字符串，不足则用空格填充，用法跟 string:centre(String, Number, $\s) 是一样

string:centre("123456789", 5)

----------
string:centre/3
让字符串中间对齐

用法：

centre(String, Number, Character) -> Centered
内部实现：

-spec centre(String, Number, Character) -> Centered when
      String :: string(),
      Centered :: string(),
      Number :: non_neg_integer(),
      Character :: char().

centre(String, 0, Char) when is_list(String), is_integer(Char) ->
    [];                       % Strange cases to centre string
centre(String, Len, Char) when is_integer(Char) ->
    Slen = length(String),
    if
	Slen > Len -> substr(String, (Slen-Len) div 2 + 1, Len);
	Slen 
	    N = (Len-Slen) div 2,
	    r_pad(l_pad(String, Len-(Slen+N), Char), N, Char);
	Slen =:= Len -> String
    end.
返回一个从字符串中间开始，扩充到指定长度 Number 的新字符串，不足则用字符 Character 填充

string:centre("123456789", 20, $a)

----------
string:chars/2
返回包含指定数目个字符的字符串

用法：

chars(Character, Number) -> String
内部实现：

-spec chars(Character, Number) -> String when
      Character :: char(),
      Number :: non_neg_integer(),
      String :: string().

chars(C, N) -> chars(C, N, []).

-spec chars(Character, Number, Tail) -> String when
      Character :: char(),
      Number :: non_neg_integer(),
      Tail :: string(),
      String :: string().

chars(C, N, Tail) when N > 0 ->
    chars(C, N-1, [C|Tail]);
chars(C, 0, Tail) when is_integer(C) ->
    Tail.
返回包含 Number 个字符 Character 的字符串 String

string:chars($a, 5).

----------
string:chars/3
返回包含指定数目个字符的字符串

用法：

chars(Character, Number, Tail) -> String
内部实现：

-spec chars(Character, Number, Tail) -> String when
      Character :: char(),
      Number :: non_neg_integer(),
      Tail :: string(),
      String :: string().

chars(C, N, Tail) when N > 0 ->
    chars(C, N-1, [C|Tail]);
chars(C, 0, Tail) when is_integer(C) ->
    Tail.
跟 string:chars/2 一样，都是返回包含 Number 个字符 Character 的字符串 String，只是最后多了一步在后面加上一个字符串列表 Tail 的操作

string:chars($a, 5, "tail").

----------
string:chr/2
获取字符在字符串里第一次出现的位置

用法：

chr(String, Character) -> Index
内部实现：

-spec chr(String, Character) -> Index when
      String :: string(),
      Character :: char(),
      Index :: non_neg_integer().

chr(S, C) when is_integer(C) -> chr(S, C, 1).

chr([C|_Cs], C, I) -> I;
chr([_|Cs], C, I) -> chr(Cs, C, I+1);
chr([], _C, _I) -> 0.
获取字符 Character 在字符串 String 第一次出现的位置。

string:chr("abcbdefg", $b).
如果不存在，则返回 0。

string:chr("abcdefg", $h).

----------
string:concat/2
合并连接 2 个字符串

用法：

concat(String1, String2) -> String3
内部实现：

%% concat(String1, String2)
%%  Concatenate 2 strings.

-spec concat(String1, String2) -> String3 when
      String1 :: string(),
      String2 :: string(),
      String3 :: string().

concat(S1, S2) -> S1 ++ S2.
把字符串 String1 和字符串 String2 合并连接起来，并返回一个合并后的新字符串 String3

string:concat("abcd", "efg").

----------

string:copies/2
复制一个字符串

用法：

copies(String, Number) -> Copies
内部实现：

-spec copies(String, Number) -> Copies when
      String :: string(),
      Copies :: string(),
      Number :: non_neg_integer().

copies(CharList, Num) when is_list(CharList), is_integer(Num), Num >= 0 ->
    copies(CharList, Num, []).

copies(_CharList, 0, R) ->
    R;
copies(CharList, Num, R) ->
    copies(CharList, Num-1, CharList++R).
返回一个包含复制过 Number 次字符串 String 的新字符串。

string:copies("abc", 5).

----------

string:cspan/2
字符在字符串里的跨度范围

用法：

cspan(String, Chars) -> Length
内部实现：

-spec cspan(String, Chars) -> Length when
      String :: string(),
      Chars :: string(),
      Length :: non_neg_integer().

cspan(S, Cs) when is_list(Cs) -> cspan(S, Cs, 0).

cspan([C|S], Cs, I) ->
    case member(C, Cs) of
	true -> I;
	false -> cspan(S, Cs, I+1)
    end;
cspan([], _Cs, I) -> I.
返回字符串 String 不匹配最多字符 Chars 的长度，就是从左开始，返回 Chars 第一次出现的位置，如果不存在字符 Chars，则是返回字符串 String 的长度。

string:cspan("abcdef", "d").
string:cspan("abcdef", "h").

----------
string:equal/2
判断 2 个字符串是否相等

用法：

equal(String1, String2) -> bool()
内部实现：

%% equal(String1, String2)
%%  Test if 2 strings are equal.

-spec equal(String1, String2) -> boolean() when
      String1 :: string(),
      String2 :: string().

equal(S, S) -> true;
equal(_, _) -> false.
判断字符串 String1 和 String2 是否相等，如果相等，返回 true，否则返回 false

string:equal("abc", "abc").
string:equal("abcd", "abc").

----------
string:join/2
通过一个分隔符把字符列表连接起来

用法：

join(StringList, Separator) -> String
内部实现：

-spec join(StringList, Separator) -> String when
      StringList :: [string()],
      Separator :: string(),
      String :: string().

join([], Sep) when is_list(Sep) ->
    [];
join([H|T], Sep) ->
    H ++ lists:append([Sep ++ X || X 
通过一个分隔符 Separator，把一个字符列表 StringList 里的元素连接起来

string:join(["a", "b", "c", "d"], "-").



string:join(["a", "b", "c", "d"], "").

----------
string:left/2
让字符串左对齐

用法：

left(String, Number) -> Left
内部实现：

-spec left(String, Number) -> Left when
      String :: string(),
      Left :: string(),
      Number :: non_neg_integer().

left(String, Len) when is_integer(Len) -> left(String, Len, $\s).

-spec left(String, Number, Character) -> Left when
      String :: string(),
      Left :: string(),
      Number :: non_neg_integer(),
      Character :: char().

left(String, Len, Char) when is_integer(Char) ->
    Slen = length(String),
    if
	Slen > Len -> substr(String, 1, Len);
	Slen  l_pad(String, Len-Slen, Char);
	Slen =:= Len -> String
    end.

l_pad(String, Num, Char) -> String ++ chars(Char, Num).
返回一个从字符串左边开始，扩充到指定长度 Number 的新字符串，不足则用空格填充，用法跟 string:left(String, Number, $\s) 是一样

string:left("1234567890", 5).

----------
string:left/3
让字符串左对齐

用法：

left(String, Number, Character) -> Left
内部实现：

-spec left(String, Number, Character) -> Left when
      String :: string(),
      Left :: string(),
      Number :: non_neg_integer(),
      Character :: char().

left(String, Len, Char) when is_integer(Char) ->
    Slen = length(String),
    if
	Slen > Len -> substr(String, 1, Len);
	Slen  l_pad(String, Len-Slen, Char);
	Slen =:= Len -> String
    end.

l_pad(String, Num, Char) -> String ++ chars(Char, Num).
返回一个从字符串左边开始，扩充到指定长度 Number 的新字符串，不足则用字符 Character 填充

string:left("1234567890", 20, $a).

----------
string:len/1
获取一个字符长度

用法：

len(String) -> Length
内部实现：

%% len(String)
%%  Return the length of a string.

-spec len(String) -> Length when
      String :: string(),
      Length :: non_neg_integer().

len(S) -> length(S).
获取一个字符的长度

string:len("abcdefg")

----------
string:rchr/2
获取字符在字符串里最后一次出现的位置

用法：

rchr(String, Character) -> Index
内部实现：

-spec rchr(String, Character) -> Index when
      String :: string(),
      Character :: char(),
      Index :: non_neg_integer().

rchr(S, C) when is_integer(C) -> rchr(S, C, 1, 0).

rchr([C|Cs], C, I, _L) ->			%Found one, now find next!
    rchr(Cs, C, I+1, I);
rchr([_|Cs], C, I, L) ->
    rchr(Cs, C, I+1, L);
rchr([], _C, _I, L) -> L.
获取字符 Character 在字符串 String 最后一次出现的位置。

string:rchr("abcbdefg", $b).
如果不存在，则返回 0。

string:rchr("abcdefg", $h).

----------
string:right/2
让字符串右对齐

用法：

right(String, Number) -> Right
内部实现：

-spec right(String, Number) -> Right when
      String :: string(),
      Right :: string(),
      Number :: non_neg_integer().

right(String, Len) when is_integer(Len) -> right(String, Len, $\s).

-spec right(String, Number, Character) -> Right when
      String :: string(),
      Right :: string(),
      Number :: non_neg_integer(),
      Character :: char().

right(String, Len, Char) when is_integer(Char) ->
    Slen = length(String),
    if
	Slen > Len -> substr(String, Slen-Len+1);
	Slen  r_pad(String, Len-Slen, Char);
	Slen =:= Len -> String
    end.

r_pad(String, Num, Char) -> chars(Char, Num, String).
返回一个从字符串右边开始，扩充到指定长度 Number 的新字符串，不足则用空格填充，用法跟 string:right(String, Number, $\s) 是一样

string:right("1234567890", 5).

----------
string:right/3
让字符串右对齐

用法：

right(String, Number, Character) -> Right
内部实现：

-spec right(String, Number, Character) -> Right when
      String :: string(),
      Right :: string(),
      Number :: non_neg_integer(),
      Character :: char().

right(String, Len, Char) when is_integer(Char) ->
    Slen = length(String),
    if
	Slen > Len -> substr(String, Slen-Len+1);
	Slen  r_pad(String, Len-Slen, Char);
	Slen =:= Len -> String
    end.

r_pad(String, Num, Char) -> chars(Char, Num, String).
返回一个从字符串右边开始，扩充到指定长度 Number 的新字符串，不足则用字符 Character 填充

string:right("1234567890", 20, $a).

----------
string:rstr/2
返回字符在字符串里最后一次出现的位置

用法：

rstr(String, SubString) -> Index
内部实现：

-spec rstr(String, SubString) -> Index when
      String :: string(),
      SubString :: string(),
      Index :: non_neg_integer().

rstr(S, Sub) when is_list(Sub) -> rstr(S, Sub, 1, 0).

rstr([C|S], [C|Sub], I, L) ->
    case prefix(Sub, S) of
	true -> rstr(S, [C|Sub], I+1, I);
	false -> rstr(S, [C|Sub], I+1, L)
    end;
rstr([_|S], Sub, I, L) -> rstr(S, Sub, I+1, L);
rstr([], _Sub, _I, L) -> L.

prefix([C|Pre], [C|String]) -> prefix(Pre, String);
prefix([], String) when is_list(String) -> true;
prefix(Pre, String) when is_list(Pre), is_list(String) -> false.
返回字符 SubString 在字符串 String 最后一次出现的位置。

string:rstr("abcbdefg", "b").
如果不存在，则返回 0。

string:rstr("abcdefg", "h").

----------
string:span/2
字符在字符串里的跨度范围

用法：

span(String, Chars) -> Length
内部实现：

-spec span(String, Chars) -> Length when
      String :: string(),
      Chars :: string(),
      Length :: non_neg_integer().

span(S, Cs) when is_list(Cs) -> span(S, Cs, 0).

span([C|S], Cs, I) ->
    case member(C, Cs) of
	true -> span(S, Cs, I+1);
	false -> I
    end;
span([], _Cs, I) -> I.
返回字符串 String 匹配最多字符 Chars 的长度。

string:span("aaaaabcdef", "a").
string:span("abcdef", "h").

----------
string:str/2
返回字符在字符串里第一次出现的位置

用法：

str(String, SubString) -> Index
内部实现：

-spec str(String, SubString) -> Index when
      String :: string(),
      SubString :: string(),
      Index :: non_neg_integer().

str(S, Sub) when is_list(Sub) -> str(S, Sub, 1).

str([C|S], [C|Sub], I) ->
    case prefix(Sub, S) of
	true -> I;
	false -> str(S, [C|Sub], I+1)
    end;
str([_|S], Sub, I) -> str(S, Sub, I+1);
str([], _Sub, _I) -> 0.
返回字符 SubString 在字符串 String 第一次出现的位置。

string:str("abcbdefg", "b").
如果不存在，则返回 0

string:str("abcbdefg", "h").

----------
string:strip/1
去除字符串两边的字符

用法：

strip(String :: string()) -> string()
内部实现：

-spec strip(string()) -> string().

strip(String) -> strip(String, both).

-spec strip(String, Direction) -> Stripped when
      String :: string(),
      Stripped :: string(),
      Direction :: left | right | both.

strip(String, left) -> strip_left(String, $\s);
strip(String, right) -> strip_right(String, $\s);
strip(String, both) ->
    strip_right(strip_left(String, $\s), $\s).

-spec strip(String, Direction, Character) -> Stripped when
      String :: string(),
      Stripped :: string(),
      Direction :: left | right | both,
      Character :: char().

strip(String, right, Char) -> strip_right(String, Char);
strip(String, left, Char) -> strip_left(String, Char);
strip(String, both, Char) ->
    strip_right(strip_left(String, Char), Char).

strip_left([Sc|S], Sc) ->
    strip_left(S, Sc);
strip_left([_|_]=S, Sc) when is_integer(Sc) -> S;
strip_left([], Sc) when is_integer(Sc) -> [].

strip_right([Sc|S], Sc) ->
    case strip_right(S, Sc) of
	[] -> [];
	T  -> [Sc|T]
    end;
strip_right([C|S], Sc) ->
    [C|strip_right(S, Sc)];
strip_right([], Sc) when is_integer(Sc) ->
    [].
去除字符串 String 两边的空格

string:strip("  abcdefg  ").

----------
string:strip/2
去除字符串两边的字符

用法：

strip(String, Direction) -> Stripped
内部实现：

-spec strip(String, Direction) -> Stripped when
      String :: string(),
      Stripped :: string(),
      Direction :: left | right | both.

strip(String, left) -> strip_left(String, $\s);
strip(String, right) -> strip_right(String, $\s);
strip(String, both) ->
    strip_right(strip_left(String, $\s), $\s).

-spec strip(String, Direction, Character) -> Stripped when
      String :: string(),
      Stripped :: string(),
      Direction :: left | right | both,
      Character :: char().

strip(String, right, Char) -> strip_right(String, Char);
strip(String, left, Char) -> strip_left(String, Char);
strip(String, both, Char) ->
    strip_right(strip_left(String, Char), Char).

strip_left([Sc|S], Sc) ->
    strip_left(S, Sc);
strip_left([_|_]=S, Sc) when is_integer(Sc) -> S;
strip_left([], Sc) when is_integer(Sc) -> [].

strip_right([Sc|S], Sc) ->
    case strip_right(S, Sc) of
	[] -> [];
	T  -> [Sc|T]
    end;
strip_right([C|S], Sc) ->
    [C|strip_right(S, Sc)];
strip_right([], Sc) when is_integer(Sc) ->
    [].
去除字符串 String 左/右边的空格，参数 Direction 标明要去除哪边的空格，left 表示只去除左边，right 表示只去除右边，both 表示两边都去除

string:strip("  abcdefg  ", both).

----------
string:strip/3
去除字符串两边的字符

用法：

strip(String, Direction, Character) -> Stripped
内部实现：

-spec strip(String, Direction, Character) -> Stripped when
      String :: string(),
      Stripped :: string(),
      Direction :: left | right | both,
      Character :: char().

strip(String, right, Char) -> strip_right(String, Char);
strip(String, left, Char) -> strip_left(String, Char);
strip(String, both, Char) ->
    strip_right(strip_left(String, Char), Char).

strip_left([Sc|S], Sc) ->
    strip_left(S, Sc);
strip_left([_|_]=S, Sc) when is_integer(Sc) -> S;
strip_left([], Sc) when is_integer(Sc) -> [].

strip_right([Sc|S], Sc) ->
    case strip_right(S, Sc) of
	[] -> [];
	T  -> [Sc|T]
    end;
strip_right([C|S], Sc) ->
    [C|strip_right(S, Sc)];
strip_right([], Sc) when is_integer(Sc) ->
    [].
去除字符串 String 左/右边的字符 Character，参数 Direction 标明要去除哪边的空格，left 表示只去除左边，right 表示只去除右边，both 表示两边都去除

string:strip("...abcdefg...", both, $.).
string:strip("...abcdefg...", left, $.).
string:strip("...abcdefg.,,", right, $,).

----------
string:sub_string/2
截取字符串的一部分

用法：

sub_string(String, Start) -> SubString
内部实现：

-spec sub_string(String, Start) -> SubString when
      String :: string(),
      SubString :: string(),
      Start :: pos_integer().

sub_string(String, Start) -> substr(String, Start).

-spec sub_string(String, Start, Stop) -> SubString when
      String :: string(),
      SubString :: string(),
      Start :: pos_integer(),
      Stop :: pos_integer().

sub_string(String, Start, Stop) -> substr(String, Start, Stop - Start + 1).
截取从 Start 开始到字符串 String 末尾之间的子字符串

string:sub_string("abcdefg", 3)

----------
string:sub_string/3
截取字符串的一部分

用法：

sub_string(String, Start, Stop) -> SubString
内部实现：

-spec sub_string(String, Start, Stop) -> SubString when
      String :: string(),
      SubString :: string(),
      Start :: pos_integer(),
      Stop :: pos_integer().

sub_string(String, Start, Stop) -> substr(String, Start, Stop - Start + 1).
在字符串 String 里截取从 Start 位置开始到 Stop 位置结束间的字符串

string:sub_string("Hello World", 4, 8).
PS：跟 string:substr/3 不同的地方在于， substr 指定的是开始位置和截取的长度，而这个函数 sub_string 指定的是截取的开始位置和结束位置。

----------
string:sub_word/2
获取指定位置的单词

用法：

sub_word(String, Number) -> Word
内部实现：

-spec sub_word(String, Number) -> Word when
      String :: string(),
      Word :: string(),
      Number :: integer().

sub_word(String, Index) -> sub_word(String, Index, $\s).

-spec sub_word(String, Number, Character) -> Word when
      String :: string(),
      Word :: string(),
      Number :: integer(),
      Character :: char().

sub_word(String, Index, Char) when is_integer(Index), is_integer(Char) ->
    case words(String, Char) of
	Num when Num 
	    [];
	_Num ->
	    s_word(strip(String, left, Char), Index, Char, 1, [])
    end.

s_word([], _, _, _,Res) -> reverse(Res);
s_word([Char|_],Index,Char,Index,Res) -> reverse(Res);
s_word([H|T],Index,Char,Index,Res) -> s_word(T,Index,Char,Index,[H|Res]);
s_word([Char|T],Stop,Char,Index,Res) when Index  
    s_word(strip(T,left,Char),Stop,Char,Index+1,Res);
s_word([_|T],Stop,Char,Index,Res) when Index  
    s_word(T,Stop,Char,Index,Res).
获取字符串 String 里的第 Number 个单词，默认使用空格来做单词的分隔符。

string:sub_word("a b c d e f g", 4).

----------
string:sub_word/3
获取指定位置的单词

用法：

sub_word(String, Number, Character) -> Word
内部实现：

-spec sub_word(String, Number, Character) -> Word when
      String :: string(),
      Word :: string(),
      Number :: integer(),
      Character :: char().

sub_word(String, Index, Char) when is_integer(Index), is_integer(Char) ->
    case words(String, Char) of
	Num when Num 
	    [];
	_Num ->
	    s_word(strip(String, left, Char), Index, Char, 1, [])
    end.

s_word([], _, _, _,Res) -> reverse(Res);
s_word([Char|_],Index,Char,Index,Res) -> reverse(Res);
s_word([H|T],Index,Char,Index,Res) -> s_word(T,Index,Char,Index,[H|Res]);
s_word([Char|T],Stop,Char,Index,Res) when Index  
    s_word(strip(T,left,Char),Stop,Char,Index+1,Res);
s_word([_|T],Stop,Char,Index,Res) when Index  
    s_word(T,Stop,Char,Index,Res).
通过一个分隔符 Character 来把字符串 String 分成若干个单词，然后返回第 Number 个的单词

string:sub_word("abxcdxefxg", 2, $x).

----------
string:substr/2
截取字符串

用法：

substr(String, Start) -> SubString
截取从 Start 开始到字符串 String 末尾之间的子字符串

string:substr("abcdefg", 3).

----------
string:substr/3
截取字符串

用法：

substr(String, Start, Length) -> Substring
从字符串 String 里截取一个从 Start 位置开始，长度是 Length 的子字符串 Substring。

string:substr("abcdefg", 3, 2).
Erlang 版实现的全排列：

Str = "abc",
Len = length(Str),
StrToListFun = fun(Start, AccList) ->
    Element = string:substr(Str, Start, 1),
    [Element | AccList]
end,
StringList = lists:foldr(StrToListFun, [], lists:seq(1, Len)),
NormalizeFun = fun
    Normalize([], _N, _I, R) ->
        lists:reverse(R);
    Normalize([H | L], I, I, R) ->
        [H] ++ lists:reverse(R) ++ L;
    Normalize([H | L], N, I, R) ->
        Normalize(L, N + 1, I, [H | R])
end,
PermutationFun = fun PermutationFun(N, [StrList, HeadList, Ret]) ->
    NewStrList = NormalizeFun(StrList, 1, N, []),
    iostrList = HeadList ++ NewStrList,
    NewRet = [string:join(IOStrList, "") | Ret],
    if
        length(NewStrList) > 1 ->
            [Item | AccStrList] = NewStrList,
            AccLen = length(AccStrList),
            NewHeadList = HeadList ++ [Item],
            [_SL, _HL, PermutationLoopRet] = lists:foldr(PermutationFun, [AccStrList, NewHeadList, []], lists:seq(2, AccLen)),
            [StrList, HeadList, PermutationLoopRet ++ NewRet];
        true ->
            [StrList, HeadList, NewRet]
    end
end,
[_StrList, _HeadList, RetList] = lists:foldr(PermutationFun, [StringList, [], []], lists:seq(1, Len)),
RetList.

----------
string:to_float/1
解析字符串中的浮点数

用法：

to_float(String) -> {Float,Rest} | {error,Reason}
把字符串 String 里的浮点数解析出来

string:to_float("123.4abc").

----------
string:to_integer/1
解析字符串中的整数

用法：

to_integer(String) -> {Int,Rest} | {error,Reason}
把字符串 String 里的整数解析出来

string:to_integer("1234abc").

----------
string:to_lower/1
把字符串里的字符转为小写字母

用法：

to_lower(String) -> Result
把字符串 String 里的字符转为小写字母

string:to_lower("AbCdEfg").

----------
string:to_upper/1
把字符串里的字符转为大写字母

用法：

to_upper(String) -> Result
把字符串 String 里的字符转为大写字母

string:to_upper("AbCdEfg").

----------
string:tokens/2
使用分隔符把字符串分割

用法：

tokens(String, SeparatorList) -> Tokens
内部实现：

%% tokens(String, Seperators).
%%  Return a list of tokens seperated by characters in Seperators.

-spec tokens(String, SeparatorList) -> Tokens when
      String :: string(),
      SeparatorList :: string(),
      Tokens :: [Token :: nonempty_string()].

tokens(S, Seps) ->
    tokens1(S, Seps, []).

tokens1([C|S], Seps, Toks) ->
    case member(C, Seps) of
	true -> tokens1(S, Seps, Toks);
	false -> tokens2(S, Seps, Toks, [C])
    end;
tokens1([], _Seps, Toks) ->
    reverse(Toks).

tokens2([C|S], Seps, Toks, Cs) ->
    case member(C, Seps) of
	true -> tokens1(S, Seps, [reverse(Cs)|Toks]);
	false -> tokens2(S, Seps, Toks, [C|Cs])
    end;
tokens2([], _Seps, Toks, Cs) ->
    reverse([reverse(Cs)|Toks]).
用分隔符把字符串 String 分割成一个字符串列表，分隔符参数 SeparatorList 可以为一个或多个符号。

string:tokens("a-b-c-d-e", "-").
string:tokens("abcdefghi jklmn", "bf l").
string:tokens/2 不支持 "空分隔符" 分割，因此不能把 "abcd" 这样的字符串里的每一个字符分割成 ["a", "b", "c", "d"]，不过利用 string:substr/3 函数实现。

Str = "abcd",
Len = length(Str),
F = fun(Start, AccList) ->
    Element = string:substr(Str, Start, 1),
    [Element | AccList]
end,
lists:foldr(F, [], lists:seq(1, Len)).

----------
string:words/1
返回字符串里的单词字符个数

用法：

words(String) -> Count
内部实现：

-spec words(String) -> Count when
      String :: string(),
      Count :: pos_integer().

words(String) -> words(String, $\s).

-spec words(String, Character) -> Count when
      String :: string(),
      Character :: char(),
      Count :: pos_integer().

words(String, Char) when is_integer(Char) ->
    w_count(strip(String, both, Char), Char, 0).

w_count([], _, Num) -> Num+1;
w_count([H|T], H, Num) -> w_count(strip(T, left, H), H, Num+1);
w_count([_H|T], Char, Num) -> w_count(T, Char, Num).
默认使用空格符作为分割点，返回字符串 String 里的单词字符个数

string:words("a b c d e f g").

----------
string:words/2
返回字符串里的单词字符个数

用法：

words(String, Character) -> Count
内部实现：

-spec words(String, Character) -> Count when
      String :: string(),
      Character :: char(),
      Count :: pos_integer().

words(String, Char) when is_integer(Char) ->
    w_count(strip(String, both, Char), Char, 0).

w_count([], _, Num) -> Num+1;
w_count([H|T], H, Num) -> w_count(strip(T, left, H), H, Num+1);
w_count([_H|T], Char, Num) -> w_count(T, Char, Num).
通过一个分隔符 Character 来获取字符串 String 中的单词字符的个数

string:words("ab~cd~ef~g", $~).

----------
