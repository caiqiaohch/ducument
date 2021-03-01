re:compile/1
把一个正则表达式编译成一个正则匹配指令

用法：

compile(Regexp) -> {ok, MP} | {error, ErrSpec}
把一个正则表达式编译成一个匹配模式的正则指令，参数 Regexp 可以是任意 Perl 风格的正则表达式，其效用跟 re:compile/2 的 re:compile(Regexp, []) 一样

获取 IP 的正则

re:compile("\\d{1,3}\.\\d{1,3}\.\\d{1,3}\.\\d{1,3}").
获取邮箱地址的正则

re:compile("[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-z]{2,3}").
如果一个正则表达式多次使用到，那么把正则表达式预先编译是一种很高效的做法，可以有一次编译，多次重复调用的效果。

re:compile/1 经常跟 re:run/2、re:run/3、re:replace/3、re:replace/4、re:split/2、re:split/3 这几个正则函数搭配使用：

Url = "Http://220.181.112.143/",
{ok, MatchPattern} = re:compile("\\d{1,3}\.\\d{1,3}\.\\d{1,3}\.\\d{1,3}"),
re:run(Url, MatchPattern, [{capture, first, list}]).
{ok, MatchPattern} = re:compile("[^A-Za-z]"),
re:replace("abcd123 *ef% 456gh**ijklmn~~~", MatchPattern, "", [global, {return, list}]).
Content = "sdfsdfsdfLJDSLFJDSLFJDSL",
re:split(Content, "", [{return, list}])

----------
re:compile/2
把一个正则表达式编译成一个正则匹配指令

用法：

compile(Regexp,Options) -> {ok, MP} | {error, ErrSpec}
跟 re:compile/1 一样，都是把一个正则表达式编译成一个匹配模式的正则指令，参数 Regexp 可以是任意 Perl 风格的正则表达式，只是多了一个选项参数 Options

匹配中文的正则表达式

re:compile("[\x{4e00}-\x{9fa5}]+", [unicode])
如果一个正则表达式多次使用到，那么把正则表达式预先编译是一种很高效的做法，可以一次编译，多次调用。

re:compile/2 经常跟 re:run/2、re:run/3、re:replace/3、re:replace/4、re:split/2、re:split/3 这几个正则函数搭配使用

Url = "Http://220.181.112.143/",
{ok, MatchPattern} = re:compile("\\d{1,3}\.\\d{1,3}\.\\d{1,3}\.\\d{1,3}", [{capture, first, list}]),
re:run(Url, MatchPattern).
{ok, MatchPattern} = re:compile("[^A-Za-z]"),
re:replace("abcd123 *ef% 456gh**ijklmn~~~", MatchPattern, "", [global, {return, list}]).
Content = "sdfsdfsdfLJDSLFJDSLFJDSL",
re:split(Content, "", [{return, list}])

----------
re:replace/3
根据正则表达式来替换数据

用法：

replace(Subject,RE,Replacement) -> iodata() | charlist()
用一个替换值（Replacement）去替换正则表达式（RE）匹配到的数据，参数 Subject 是要匹配替换的数据，参数 RE 是替换的正则表达式，参数 Replacement 是要替换的值。

如果匹配替换成功，默认返回的数据格式是 iodata：

re:replace("Red Green Blue", "e+", "*").
其效用跟 re:replace(Subject,RE,Replacement,[]) 一样，更多信息请看 re:replace/4

----------
re:replace/4
根据正则表达式来替换数据

用法：

replace(Subject,RE,Replacement,Options) -> iodata() | charlist() | binary() | list()
用一个替换值（Replacement）去替换正则表达式（RE）匹配到的数据，参数 Subject 是要匹配替换的数据，参数 RE 是替换的正则表达式，参数 Replacement 是要替换的值，参数 Options 的用法跟 re:run/3 一样，除了 capture 之外。

Erlang 里的字符串（string）替换主要也是用该函数来实现，下面是该方法的一些例子：

全局匹配替换，并返回字符串形式的数据：

re:replace("just a test", "s\\w+", "*", [global, {return, list}]).
把字符串里的数字去掉：

re:replace("j1u223s5t a6 t7e8s9t", "[0-9]", "", [global, {return, list}]).
去除字符里的斜杠（"/"）和反斜杠（"\"）等特殊符号：

re:replace("He/llo Wo\rld", "\/", "", [global, {return, list}]).
去除字符两边里的非字符等特殊符号：

re:replace(" \nabc defg\r \t", "(^\\s+)|(\\s+$)", "", [global, {return, list}]).

----------
re:run/2
根据正则表达式去匹配数据并返回匹配结果

用法：

run(Subject,RE) -> {match, Captured} | nomatch
执行一个正则匹配，匹配成功则返回 {match, Captured}，否则返回一个 nomatch 的原子。参数 RE 可以是正则字符串，也可以是用 re:compile 预编译过的正则匹配指令。

返回的 Captured 值包含匹配结果的开始的位置和匹配结果的长度，例如下面返回的是 [{4,4}]，表示匹配结果在第 4 个字符后出现，匹配结果值的长度是 4。

re:run("abc 1234 @#$", "\\d+").
其效用跟 run(Subject,RE,[]) 一样，详细参数说明请看 re:run/3

----------
re:run/3
根据正则表达式去匹配数据并返回匹配结果

用法：

run(Subject,RE,Options) -> {match, Captured} | match | nomatch
执行一个正则匹配，匹配成功则返回 {match, Captured}，否则返回一个 nomatch 的原子。参数 RE 可以是正则字符串，也可以是用 re:compile/1 或 re:compile/2 预编译过的正则匹配指令。参数 Options 是一个匹配选项参数。

如果编译正则表达式时发生了异常错误，只会返回一个 badarg 的提示，错误的详细定位信息可以通过 re:compile/2 方法来查看

缺省第三个参数的情况下，返回的 Captured 值会包含匹配结果的开始的位置和匹配结果的长度，例如下面返回的是 [{2,1}]，表示匹配结果在第 2 个字符后出现，匹配结果值的长度是 1。

re:run("just a test!", "s").
添加一个 global 参数，把所有匹配结果的匹配出来

re:run("just a test!", "s", [global]).
把第一个匹配结果以字符串的形式截取下来

re:run("just a test!", "s", [{capture, first, list}]).
把所有结果截取下来，并以字符串的形式返回

re:run("just a test!", "s", [global, {capture, all, list}]).
字符串里是否存在某个字符：

re:run("abc'defg", "j|k|'|m", [{capture, none}]).
一些常用例子：

匹配 IP：

re:run("HostName                    107.170.96.117", "(\\d{1,3}\\.){3}\\d{1,3}", [{capture, first, list}]).

----------
re:split/2
用正则表达式去截取数据

用法：

split(Subject,RE) -> SplitList
通过正则表达式（RE）来找到截取标记，然后把数据（Subject）截取。

默认返回的数据格式是 iodata

re:split("123|456","\\|"). 
其效用跟 re:split(Subject,RE,[]) 一样，更多信息请看 re:split/3

----------
re:split/3
用正则表达式去截取数据

用法：

split(Subject,RE,Options) -> SplitList
通过正则表达式（RE）来找到截取标记，然后把数据（Subject）截取分开。同时，这是一个全局匹配截取，只要出现截取标记的地方都会被截取分开。返回的截取列表（SplitList）里只返回被截取分开的数据，截取标记不会返回。

参数 Options 提供一些截取匹配选项，例如要求返回的数据是字符串形式：

re:split("red - green - blue", "-", [{return, list}]).
Str = "The text matching the subexpression (marked by the parentheses in the regexp) is inserted in the result list where it was found.",
re:split(Str, "[|,|\\.|;|:|\\t|\\n|\\(|\\)|\\s|]+", [{return, list}]).

----------
