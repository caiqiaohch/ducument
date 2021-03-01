## 1.1.1 开始模拟 ##


spawn是一个Erlang基本函数，它会创建一个并发进程并返回一个进程标识符。 spawn可以这样调用：

    spawn(ModName, FuncName, [Arg1,Arg2, ..., ArgN])

当Erlang运行时系统执行spawn时，它会创建一个新进程（不是操作系统的进程，而是一个由Erlang系统管理的轻量级进程）。当进程创建完毕后，它便开始执行参数所指定的代码。ModName是包含想要执行代码的模块名。 FuncName是模块里的函数名，而[Arg1, Arg2, ...]是一个列表，包含了想要执行的函数参数。

spawn的返回值是一个进程标识符（PID， Process IDentifier），可以用来与新创建的进程交互。


## 2.1.2 变量和原子的语法 ##

所以X、 This和A_long_name都是变量。以小写字母开头的名称（比如monday或friday）不是变量，而是符号常量，它们被称为原子（atom）。

2.2.1 在 shell 里编译并运行 Hello World

    $erl
    Erlang R15B ...
    1> c(hello).
    {ok,hello}
    2> hello:start().
    Hello world
    ok
    3>halt().
    $

接受内部模式：

    receive
    	Pattern1->
    		Actions1;
    	Pattern2->
    		Action2->
    	...
    end

2.2.2 在Eralang shell 外编译

	$ erlc hello.erl
	$ erl -noshell -s hello start -s init stop

2.3 你好，并发
2.3.1 文件服务器进程

3.3 变量
	可以把某个命令的结果保存在变量里。请注意Erlang的变量以大写字母开头。所以X、 This和A_long_name都是变量。以小写字母开头的名称（比如monday或friday）不是变量，而是符号常量，它们被称为原子（atom）。

4.算数表达式
	8> 1 + 2 * 3 + 4.
	11
	遵循算数表达式的一般规则。
	10> 123456789 * 123456789 * 999999999.
	15241578734948942249809479
	Erlang可以使用任意长度的整数，不用担心溢出。


5.8进制和16进制
	18> 8#1234567.
	342391
	19> 16#123abc.
	1194684
	在使用数字的时候，在前面加上8#和16#
	试了一下11#、123#这些也是行的。看来理论上是支持任意进制的运算。


6.浮点数

	两个整数相除，得出的是浮点数。
	34> 4/2.
	2.0
	要想得到C++里面的整除和求余的效果。
	31> 5 div 3.
	1
	32> 5 rem 3.
	2
	div是整除，rem是求余。
	%已经被用来做注释了。
	erlang的浮点数，也会存在精度问题。


3.3.1 Erlang的变量不会变

而在Erlang里， =是一次模式匹配操作。 Lhs = Rhs的真正意思是：计算右侧（Rhs）的值，然后将结果与左侧（Lhs）的模式相匹配。

3.5 原子

在Erlang里，原子被用于表示常量值。
在Erlang里，原子是全局性的，而且不需要宏定义或包含文件就能实现。
原子以小写字母开头，后接一串字母、 数字、 下划线（_）或at（@）符号， 例如red、 december、cat、 meters、 yards、 joe@somehost和a_long_name。

3.6 元组

如果想把一些数量固定的项目归组成单一的实体，就会使用元组（tuple）。创建元组的方法
是用大括号把想要表示的值括起来，并用逗号分隔它们。
P= {joe, 1.82}
P= {{joe2, 1.82},{joe, 1.82},{joe, 1.82}}

4.1.2 目录和代码路径

pwd()打印当前工作目录。
ls()列出当前工作目录里所有的文件名。
cd(Dir)修改当前工作目录至Dir。


----------

1. is_atom(X) X是一个原子
1. is_binary(X) X是一个二进制型
1. is_constant(X) X是一个常量
1. is_float(X) X是一个浮点数
1. is_function(X) X是一个fun
1. is_function(X, N) X是一个带有N个参数的fun
1. is_integer(X) X是一个整数
1. is_list(X) X是一个列表
1. is_map(X) X是一个映射组
1. is_number(X) X是一个整数或浮点数
1. is_pid(X) X是一个进程标识符
1. is_pmod(X) X是一个参数化模块的实例
1. is_port(X) X是一个端
1. is_reference(X) X是一个引用
1. is_tuple(X) X是一个元组
1. is_record(X,Tag) X是一个类型为Tag的记录
1. is_record(X,Tag,N) X是一个类型为Tag、大小为N的记录

----------


3.6.2 提取元组的值

	这里需要用到=，真正意义上的模式匹配
	例如：
	1> Point = {point, 10, 45}.
	{point,10,45}
	2> {point, X, Y} = Point.
	{point,10,45}
	3> X.
	10
	4> Y.
	45
	注意的是，如果X和Y上面之前已经用过了，就会匹配不上的。
	只有首次匹配，才能抽取元组中的值。
	可以使用_来作为占位符，表示不感兴趣的变量，成为匿名变量，同一个模式里面可以有多个。
	例如上面只抽取X：{_, X, _} = Point.

3.7 列表

列表（list）被用来存放任意数量的事物。创建列表的方法是用中括号把列表元素括起来，并用逗号分隔它们。
Drawing = [{square,{10,10},10},{triangel,{1,2},{3,5},{7,3}}},...]

列表的第一个元素为表头（head），剩下的成为表尾（tail）。
如果T是一个列表，[H|T]也是一个列表，它的头是H，尾是T。竖线（|）把列表的头与尾分开。[]是一个空列表。
如果有一个非空列表L，通过[X|Y] = L会提取列表头作为X，列表尾作为Y。

11.字符串

	严格来说Erlang里没有字符串。字符串实际是是一个整数列表。每个字符对于列表里一个Unicode代码点（codepoint）。
	可以使用字符串字面量来创建一个列表。字符串字面量（string literal）用双引号包着。
	5> H = "Hello World, Fable.".
	"Hello World, Fable."
	如果打印列表的时候，列表内所有整数都代表可打印字符，就会自动打印成字符串字面量。
	6> [83,117,114,112,114,105,115,101].
	"Surprise"
	7> [1,83,117,114,112,114,105,115,101].
	[1,83,117,114,112,114,105,115,101]
	1不是可打印字符，加上之后就不能自动转换了。
	使用$可以打印出某个字符的整数。
	9> $1.
	49
	10> $a.
	97

3.7.1 专用术语

列表的第一个元素被称为列表头（head）。假设把列表头去掉，剩下的就被称为列表尾（tail）。

3.7.2 定义列表

如果T是一个列表，那么[H|T]也是一个列表，它的头是H，尾是T。竖线（|）把列表的头与
尾分隔开。 []是一个空列表。

3.7.3 提取列表元素

和其他情况一样，我们可以用模式匹配操作来提取某个列表里的元素。如果有一个非空列表L，那么表达式[X|Y] = L（X和Y都是未绑定变量）会提取列表头作为X，列表尾作为Y。
[Buy1|TingsToBuy2] = ThingsToBuy1.

3.8 字符串

严格来说， Erlang里没有字符串。要在Erlang里表示字符串，可以选择一个由整数组成的列表或者一个二进制型（详细请参见7.1节）。当字符串表示为一个整数列表时，列表里的每个元素都代表了一个Unicode代码点（codepoint）。可以用字符串字面量来创建这样一个列表。 字符串字面量（string literal）其实就是用双引号（"）围起来的一串字符。比如，我们可以这么写：
 Name = "Hello"

3.9 模式匹配再探

4.1 模块是存放代码的地方
模块是Erlang的基本代码单元。模块保存在扩展名为.erl的文件里，而且必须先编译才能运
行模块里的代码。编译后的模块以.beam作为扩展名。
子句没有返回语句，则最后一条表达式的值就是返回值。
从shell里的模式匹配到函数里的模式匹配只需要很小的一步。让我们从一个名为area的函数
开始，它将计算长方形和正方形的面积。我们会把它放入一个名为geometry（几何）的模块里，并把这个模块保存在名为geometry.erl的文件里。整个模块看起来就像这样：

-module(geometry). %模块声明，模块名必须与文件名相同。
-export([area/1]). %导出声明，声明可以外部使用的函数
area({rectangle, Width, Height}) -> Width*Height; %子句1
area({square, Side}) -> Side * Side.%子句2
这个函数area有多个子句，子句之间用;分开。

area函数有两个子句。这些子句由一个分号隔开，最后的子句以句号加空白结束。
每条子句都有一个头部和一个主体，两者用箭头（->）分隔。
头部包含一个函数名，后接零个或更多个模式，主体则包含一列表达式（8.13节对表达式进行了定义），它们会在头部里的模式与调用参数成功匹配时执行。这些子句会根据它们在函数定义里出现的顺序进行匹配。

2.编译
在控制台中，使用c(geometry).可以对geometry.erl进行编译。
在当前目录生成对应的geometry.beam文件。
17> c("ErlangGame/geometry.erl").
ErlangGame/geometry.erl:1: Warning: Non-UTF-8 character(s) detected, but no encoding declared. Encode the file in UTF-8 or add "%% coding: latin-1" at the beginning of the file. Retrying with latin-1 encoding.
{ok,geometry}

3.路径
c的参数，是文件名。带不带扩展名.erl都可以。是绝对路径，相对路径，都可以。
例如我的目录是e:/mywokespace/ErlangGame/geometry.erl
c("e:/mywokespace/ErlangGame/geometry.erl").%使用绝对路径
c("ErlangGame/geometry.erl").%使用相对路径，这个时候我所在的目录是e:/mywokespace/
c(geometry).%使用相对路径、去掉双引号。因为没有.号，可以使用原子。
编译的输出了警告：
ErlangGame/geometry.erl:1: Warning: Non-UTF-8 character(s) detected, but no encoding declared. Encode the file in UTF-8 or add "%% coding: latin-1" at the beginning of the file. Retrying with latin-1 encoding.
这是因为我写了注释，注释是汉字，使用了UTF-8。去掉的话，就会：
{ok,geometry}
只有这个了。
编译之后，调用模块是不用加这个路径了。

4.1.4 扩展程序

请注意，这个例子里的子句顺序无关紧要。无论子句如何排列，程序都是一个意思，因为子句里的各个模式是互斥的。这让编写和扩展程序变得非常简单：只要添加更多的模式就行了。不过一般来说，子句的顺序还是很重要的。当某个函数执行时，子句与调用参数进行模式匹配的顺序就是它们在文件里出现的顺序。


4.1.5 分号放哪里

逗号（,）分隔函数调用、数据构造和模式中的参数。
分号（;）分隔子句。我们能在很多地方看到子句，例如函数定义，以及case、 if、
try..catch和receive表达式。
句号（.）（后接空白）分隔函数整体，以及shell里的表达式。

4.3 fun：基本的抽象单元

Erlang是一种函数式编程语言。此外，函数式编程语言还表示函数可以被用作其他函数的参数，也可以返回函数。操作其他函数的函数被称为高阶函数（higher-order function），而在Erlang中用于代表函数的数据类型被称为fun.

可以通过下列方式使用fun:

 对列表里的每一个元素执行相同的操作。在这个案例里 ，将fun作为参数传递给lists:map/2和lists:filter/2等函数。 fun的这种用法是极其普遍的。

 创建自己的控制抽象。这一技巧极其有用。例如， Erlang没有for循环，但我们可以轻松创建自己的for循环。创建控制抽象的优点是可以让它们精确实现我们想要的做法，而不是依赖一组预定义的控制抽象，因为它们的行为可能不完全是我们想要的。

 实现可重入解析代码（reentrant parsing code）、解析组合器（parser combinator）或惰性求值器（lazy evaluator）等事物。在这个案例里，我们编写返回fun的函数。这种技术很强大，但可能会导致程序难以调试。

定义一个函数
1> Double = fun(x)->2*x end.
#Fun<erl_eval.6.52032458>
2> Double(2).
** exception error: no function clause matching 
                    erl_eval:'-inside-an-interpreted-fun-'(2)
函数定义是成功了，但是怎么调用都报错。
试了好久好久，突然发现x是小写的。在Erlang里面，x就相当于C++的'x'。是不能做变量的。
变量都是大写开头的。
3> Three = fun(X)-> 3 * X end. 
#Fun<erl_eval.6.52032458>
4> Three(2).
6
ok。成功了。

5.函数可以作为参数
5> L = [1,2,3,4].
[1,2,3,4]
6> lists:map(Three, L).
[3,6,9,12]
这里调用了标准库的模块。标准库是已经编译好的，可以直接使用。
直接把函数名传进去就行了。
lists:map相当于for循环


6.=:=测试是否相等。
8> lists:filter(fun(X)->(X rem 2)=:=0 end,[1,2,3,4,5,6,7,8]).
[2,4,6,8]
llists:filter根据条件过滤列表的元素。


7.函数作为返回值
9> Fruit = [apple, pear, orange]. %创建一个列表
[apple,pear,orange]
10> MakeTest = fun(L)->(fun(X)->lists:member(X,L) end) end.%创建一个测试函数。
#Fun<erl_eval.6.52032458>
11> IsFruit = MakeTest(Fruit).%这里不是函数声明，而是匹配了MakeTest的返回值。
#Fun<erl_eval.6.52032458>
12> IsFruit(pear).%调用函数
true
13> lists:filter(IsFruit, [dog, orange, cat, apple, bear]).%过滤
[orange,apple]
MakeTest内声明了一个函数，因为是最后一个语句，所以被作为返回值。
在模块里面加个函数
-module(test). %模块声明，模块名必须与文件名相同。
-export([area/1,test/0,for/3]). %导出声明，声明可以外部使用的函数
area({rectangle, Width, Height}) -> Width*Height; %子句
area({square, Side}) -> Side * Side.
test() ->
	12 = area({rectangle, 3, 4}),
	144 = area({square, 13}),
	tests_worked.

控制结构，其实可以分成两种，一种是循环，另一种是选择分支。

1.for循环的实现 
for(Max, Max, F)->[F(Max)];        
for(I, Max, F)->[F(I)|for(I+1, Max, F)].
在Erlang Shell里面声明这个for()函数会报错，暂时不深究，反正很少会用到shell编写函数。
再调用：
22> c(test).
{ok,test}
23> test:for(1,10,fun(X)->X*X end.
* 1: syntax error before: '.'
23> test:for(1,10,fun(X)->X*X end).
[1,4,9,16,25,36,49,64,81,100]

2.列表求和
%求和
sum([H|T])->H + sum(T);
sum([])->0.
要记得在export出加上函数，声明为公开的。


3.映射,对每一个元素执行处理，只是个数学的概念，真是好久没有听说过了。
其实就是一个for循环，更加像C++的for_each。
-module(test). %模块声明，模块名必须与文件名相同。
-export([for/3,for/2,sum/1]). %导出声明，声明可以外部使用的函数


%for循环
%按数值执行N次循环
for(Max, Max, F)->[F(Max)];  
for(I, Max, F)->[F(I)|for(I+1, Max, F)].
%函数映射，对每一个函数元素执行处理
for(_,[])->[];
for(F, [H|T])->[F(H)|for(F,T)].


%求和
sum([H|T])->H + sum(T);
sum([])->0.
试了好久，继续用for这个函数名是可以的。
因为参数个数不同，相当于一个新的函数。仅仅只是名字相同而已。
让编译器自动匹配就行了。
23> A = test:for(1,10,fun(X)->X end).
[1,2,3,4,5,6,7,8,9,10]
24> test:for(fun(X)->X*X end, A).    
[1,4,9,16,25,36,49,64,81,100]

4.导入标准库的函数
-import(lists, [map/2, sum/1]).
下面就可以直接使用了。


5.列表推导
[F(X) || X <- L].
按照F(X)来创建列表，X从L中抽取，可以通过匹配模式来抽取指定类型的元素


6.内置函数，简称为BIF（built-in function）
提供操作系统的接口，
执行一些无法用Erlang编写或者编写后非常低效的操作。
官网http://erlang.org/doc/man/erlang.html


4.7 关卡（guard）
max(X,Y) when X>Y -> X;
max(X,Y) ->Y.
这个when语句就是关卡，关卡放在函数头部。
可以有多个关卡，用“,”分隔，是并操作，用“;”分隔，表示或操作。
orelse跟C++的||语义才是相同的，前面判断正确了，后面就不会求值了。
andalso跟C++的&&语义是相同的，前面为false，后面的就不会求值了。

4.8.1 case表达式

为了不总是需要些一个函数而加的。
case Expression of
Pattern1 [when Guard1]-> Expr_seq1;
Pattern2 [when Guard2]-> Expr_seq2;
...
end

4.8.2 if表达式
if
Guard1 -> Expr_seq1;
Guard2 -> Expr_seq2;
...
end

总结一下：
循环可以通过函数进行递归来实现。这样肯定会比C++慢的，而且需要的空间肯定也更多。
就看编译器对函数堆栈的优化做得如何了。不过肯定会慢一点的。
至于分支结构，其实就是if和switch。Erlang实现了if，还有case表达式。
因为函数的编写方式比较特别，多了个when表达式。

记录record：

是元组的另一种形式

-record(Name, {
				key1 = Default1,
				key2 = Default2,
				...
				key3,
				...
				}).
记录比较像C++的结构和类。
.hrl有点想C++的.h文件
test.hrl
-record(fight
-record(todo, {status = reminder, who = joe, text}).
定义一个叫做todo的记录。指定了默认值。
31> rr("test.hrl").
[todo]
在shell里面读入记录的定义。rr()是read records的缩写。
32> #todo{}. %创建一个todo对象
#todo{status = reminder,who = joe,text = undefined}
33> X1 = #todo{status=urgent, text="Fix errata in book"}.%创建一个to对象
#todo{status = urgent,who = joe,text = "Fix errata in book"}
34> X2 = X1#todo{status=done}.%创建一个to对象，使用X1来复制
#todo{status = done,who = joe,text = "Fix errata in book"}
提取字段，采用模式匹配的方式，或者单个字段访问
37> #todo{who = W, text = Txt} = X2.
#todo{status = done,who = joe,text = "Fix errata in book"}
38> W.
joe
39> Txt.
"Fix errata in book"
40> X2#todo.text.
"Fix errata in book"
函数里模式匹配记录
f(#todo{status= S, who=W} = R)->
	R#todo{status=finished}%整个记录进行操作
	S = finished%单个字段操作
do_something(X) when is_record(X, todo) ->%匹配特定类型的记录
	...

4.10 归集器

映射组map

5.2.1 创建和更新记录

创建一个映射组：
A = #{Key1 Op Val1, Key2 Op Val2, ..., KeyN Op ValN}.
B = A#{Key1 Op Val1, Key2 Op Val2, ..., KeyN Op ValN}.
表达式K => Val1有两种用途，一种是现有键K的值更新为新值V，另一种是给映射组添加一个全新的K-V对。
表达式K:=V的作用是将现有的键K的值更新为新值V。而且，这个方式效率高，一般优先使用这个。
映射组的内置函数

2>#todo{}.
#todo{status = reminder,who= joe,text = undefined}
3>X1 = #todo{status=urgent, text="Fix errata in book"}.
#todo{status = urgent,who = joe,text = "Fix errata in book"}
4>X2 = X1#todo{status=done}.
#todo{status = done,who = joe,text = "Fix errata in book"}


5.3.3 操作映射组的内置函数

maps:new()->#{} 返回一个空映射组。
erlang:is_map(M)->bool() 如果M是映射组就返回true，否则返回false。
maps:to_list(M)->[{K1,V1},...,{KN,VN}]
把映射组M里的所有键和值转换成为一个键值列表。
maps:from_list([{K1,V1},...,{KN,VN}])->M 把一个包含键值对的列表转换成映射组。
maps:map_size(Map)->NumberOfEntries 返回映射组的条目数量
maps：is_key(key,Map)->bool() 如果映射组包含一个键为Key的项就返回true，否则返回false。
maps:get(Key,Map)->Val 返回映射组里与Key关联的值，否则抛出一个异常错误。
maps:find(Key,Map)->{ok,Value}|error 返回应这组里与Key关联的值，否则返回error。
maps:keys(Map)->[Key1,...,KeyN] 返回映射组包含的键列表，按升序排列。
maps:remove(Key,M)->M1 返回一个新映射组M1，移除了Key。
maps:without([Key1,...,KeyN],M)->M1 返回一个新的映射组M1，移除了[Key1,...,KeyN]列表的元素。
maps:difference(M1, M2)->M3 M3是M1的复制，移除了M2。
映射组可以比较大小，先按长度，然后按元素的键值比较。
maps:to_json(Map)->Bin 把映射组转换成二进制型，包含了JSON表示的该映射组。
maps:from_json(Bin)->Map 把一个包含JSON数据的二进制型转换成映射组。
maps:safe_from_json(Bin)->Map 把一个包含JSON数据的二进制型转换成映射组。Bin里面的任何原子都必须已经存在，否则会抛异常。

5.3.4 映射组排序

映射组在比较时首先会比大小，然后再按照键的排序比较键和值。
如果A和B是映射组，那么当maps:size(A) < maps:size(B)时A < B。
如果A和B是大小相同的映射组，那么当maps:to_list(A) < maps:to_list(B)时A < B。

列表是放置可变数量项目的容器，而元组是放置固定数量项目的容器。记录的作用是给元组里的各个元素添加符号名称，映射组则被当作关联数组使用。


第 6 章 顺序程序的错误处理

显式生成错误的方法：
exit(Why) 广播一个信号给当前进程链接的所有进程。
throw(Why) 抛出一个调用者可能想要捕捉的异常错误。
error(Why) 指示奔溃性错误，非常严重的错误。

6.2 用 try...catch 捕捉异常错误

try FuncOrExpressionSeq of
	Pattern1[when Guard1] -> Expressions1;
	Pattern2[when Guard2] -> Expressions2;
	...
catch
	ExceptionType1: ExPattern1 [when ExGuard1] -> ExExpressions1;
	ExExpressions2: ExPattern2 [when ExGuard2] -> ExExpressions2;
	...
after
	AfterExpressions
end
提供了概括的信息


catch 语句，比try...catch更加早引入Erlang。

提供了详细的栈跟踪信息。


经常出现错误的时候的代码：

case f(x) of
    {ok, Val} ->
         do_some_thing_with(Val);
    {error, Why} ->
          %% ... 处理这个错误...
end,
...

错误可能有但罕见时的代码
try my_func(X)
catch
    throw:{thisError, X} -> ...
    throw:{someOtherError, X} -> ...
end

捕捉一切异常错误：
try Expr
catch
    _:_ -> ... 处理所有异常错误的代码
end

erlang:get_stacktrace()获得最近的栈跟踪信息。

有错误，就要尽量往外面抛，展现出来。让程序彻底奔溃。这是Erlang 的原则。

或许吧。

但是不是做游戏的原则。

至少不是做游戏服务端的原则。

我们可以容忍错误的存在。因为我们是快速开发。bug是修不完的。

只能建一个修一个。

第 7 章 二进制型与位语法

大多数情况下，二进制型里的位数都会是8的整数倍，因此对应一个字节串。如果位数不是8的整数倍，就称这段数据为位串。

7.1 二进制型

二进制型的编写和打印形式是双小于号和双大于号之间的一列整数或字符串
2> <<5,10,20>>.
<<5,10,20>>
3> <<"Hello Fable!">>.
<<"Hello Fable!">>
---------------------------------------------------------------------
第1行等号两边的空白是必需的。如果没有空白， Erlang的分词器就会把第二个符
号看作是原子=<，即小于等于操作符。有时候必须在二进制型数据的周围加上空
白或括号来避免语法错误。
----------------------------------------------------------------------
操作二进制型

binary模块
list_to_binary(L)->B 把io列表（iolist）L里的素有元素压扁后形成的二进制
split_binary(Bin,Pos)->{Bin1,Bin2} 在pos处把二进制型Bin一分为二
term_to_binary(Term)->Bin 把任何erlang数据类型转换成二进制型。
binary_to_term(Bin)->Term 将二进制型转回来
byte_size(Bin)->Size 返回二进制型的字节数

位语法 
用于从二进制数据里提取或加入单独的位或者位串。
用于协议编程以及生产操作二进制数据的高效代码。
开发位语法是为了进行协议编程（这是Erlang的强项），以及生成操作二进制数据的高效代码。

如果是8的整倍，类型就是binary。如果不是，就是bitstring
M = <<X:N1,Y:N2,Z:N3>> %XYZ都是变量，N1 N2 N3都是各自所占的位数。
<<X:N1,Y:N2,Z:N3>> = M %读取M中的数据到XYZ，跟上面的完全想法的操作。

7.2.2 位语法表达式

<<>>
<<E1,E2,...,En>>

单个Ei元素可以有4种形式：
Ei = Value |
	 Value:Size |
	 Value/TypeSpecifierList | 
	 Value:Size/TypeSpecifierList
	 TypeSpecifierList 类型指定列表 End-Sign-Type-Unit
	 End可以是big| little | native
	 Sign可以是signed|unsigned Type可以是integer|float|binary|bytes|bitstring|bits|utf8|utf16|utf32默认值是integer
	 Unit的写法是unit:1|2|...256

如果表达式的总位数是8的整数倍，就会构建一个二进制型，否则构建一个位串。


位推导:

[ X || <<X:N>> <= B]. %列表
<< <<X>> || <<X:N>> <= B >>. %位串

7.3 位串：处理位级数据
<<Size:4,Data:Size/binary,...>>



第 8 章 Erlang顺序编程补遗

1. apply
apply(Mod, Func, [Arg1, Arg2, ..., ArgN])
等价于
Mod:Func(Arg1, Arg2, ..., ArgN)
区别在于，使用apply，Mod和Func是可以算出来的。
不推荐使用apply，许多分析工具都无法得知发生了什么，编译器优化也可能不管用。


8.3 元数

函数参数的数量叫做元数。
函数名相同，元数不同，算是不同的函数。

8.4 属性

模块属性的语法是-XXX(...).
-module(modname). 模块声明，必须是第一个属性。必须跟文件名一样。 modname必须是一个原子。此属性必须是文件里的第一个属性。按照惯例，
modname的代码应当保存在名为modname.erl的文件里。如果不这么做，自动代码加载就不能正常工作。

-import(Mod,[Name1/Arity1, Name2/Arity2,...]) import声明列举了哪些函数需要导入到模块中。上面这个声明的意思是要从Mod模块导入
参数为Arity1的Name1函数，参数为Arity2的Name2函数，等等。一旦从别的模块里导入了某个函数，调用它的时候就无需指定模块名了。

-export([Name1/Arity1, Name2/Arity2, ...]). 导出了之后，模块外可以使用这些函数了。
-compile(Options). 添加Options到编译器选项列表中。
-vsn(Version). 指定模块版本号



8.4.2 用户定义的模块属性

用户定义属性 -XXX(Vaule). 好像没什么不同啊。
自定义的属性，会表现为{attributes, ...}的下属数据。
通过module_info()函数可以返回一个属性列表，内含所有与编译模块相关的元数据。
module_info(X)可以返回单个属性
beam_lib:chunks("attrs.beam",[attributes]).在不载入模块代码的情况下提取属性



8.5 块表达式

使用 begin ... end 包着，就像C++的{}一样。



8.8 字符集

从Erlang的R16B版开始， Erlang源代码文件都假定采用UTF-8字符集编码。在这之前用的是ISO-8859-1（Latin-1）字符集。这就意味着所有UTF-8可打印字符都能在源代码文件里使用，无需使用任何转义序列。
Erlang内部没有字符数据类型。字符串其实并不存在，而是由整数列表来表示。用整数列表表示Unicode字符串是毫无问题的。

8.9 注释

Erlang里的注释从一个百分号字符（%）开始，一直延伸到行尾。 Erlang没有块注释。

8.10 动态代码载入

每次调用函数的时候，都是最新的程序。
更新后，旧版本的程序还在运行，但是erlang只会运行两个版本的程序。
如果再多一个新版本，最旧的就会被清除。

8.11 Erlang 的预处理器

$erlc -P some_module.erl

8.13 表达式和表达式序列

在Erlang里，任何可以执行并生成一个值的事物都被称为表达式（expression）。
这就意味着catch、 if和try...catch这些都是表达式。
而记录声明和模块属性这些不能被求值，所以它们不是表达式。

8.14 函数引用
fun LocalFunc/Arity
用于引用当前模块里参数为Arity的本地函数LocalFunc.
fun Mod:RemoteFunc/Arity
用于引用Mode模块里参数为Arity的外部函数RemoteFunc.


8.15 包含文件
-include(Filename). 一般是包含.hrl文件。
-include_lib(Name).	一般是包含.hrl文件。

8.16 列表操作： ++和--
++表示列表相加，--表示列表相减
A ++ B使A和B相加（也就是附加）。
A -- B从列表A中移除列表B。移除的意思是B中所有元素都会从A里面去除。请注意：如果符号X在B里只出现了K次，那么A只会移除前K个X。
相减的时候，如果重复出现的元素，只会移除对应的次数，而不一定是全部移除。

8.17 宏
-define(XXX,YYY).把?XXX替换成YYY。记得要使用? 
-undef(Macro). 取消宏的定义,，此后就无法调用这个宏了。
-ifdef(Macro). 仅当有过定义时才执行后面的代码。
-ifndef(Macro). 仅当Macro未定义才执行后面的代码。
-else. 可用于ifdef或ifndef语句之后。如果条件为否， else后面的语句就会被执行
-elseif 标记ifdef或ifndef语句的结尾。
含义跟C++的差不多

8.18 模式的匹配操作符

10.数字
整数:

K进制整数，K#Digits，最高进制数是36。
其实更加高的也可以，只是无法输入和输出显示而已。

 传统写法
在这里，整数的写法和你预料的一样。比如， 12、 12375和-23427都是整数。
 K进制整数
除10以外的数字进制整数使用K#Digits这种写法。因此，可以把一个二进制数写成
2#00101010，或者把一个十六进制数写成16#af6bfa23。对大于10的进制而言， abc...
（或ABC...）这些字符代表了数字10、 11和12，以此类推。最高的进制数是36。
 $ 写法
$C这种写法代表了ASCII字符C的整数代码。因此， $a是97的简写， $1是49的简写，以此
类推

8.19.2 浮点数
一个浮点数由五部分组成：一个可选的正负号，一个整数部分，一个小数点，一个分数部分
和一个可选的指数部分。

8.21 进程字典
每个Erlang进程都有一个被称为进程字典（process dictionary）的私有数据存储区域。
进程字典是一个关联数组（在其他语言里可能被称作map、 hashmap或者散列表），它由若干个键和值组成。每个键只有一个值。
我很少使用进程字典。进程字典可能会给你的程序引入不易察觉的bug，让调试变得困难。
但是有一种用法我是支持的，那就是用进程字典来保存“一次性写入”的变量。
如果某个键一次性获得一个值而且不会改变它，那么将其保存在进程字典里在某些时候还是可以接受的。

8.22 引用
引用（reference）是一种全局唯一的Erlang数据类型。它们由内置函数erlang:make_ref()创建。
引用的用途是创建独一无二的标签，把它存放在数据里并在后面用于比较是否相等。
举个例子， bug跟踪系统可以给每个新的bug报告添加一个引用，从而赋予它一个独一无二的标识。

8.23 短路布尔表达式
短路布尔表达式（short-circuit boolean expression）是一种只在必要时才对参数求值的表达式。
“短路”布尔表达式有两种
expr1 orelse expr2
expr1 andalso expr2

8.24 比较数据类型
>   大于       <  小于
=<  小于等于   >= 大于等于
==  等于，只有比较整数和浮点数的时候才用
/= 不等于
=:= 完全相等，一般情况下应该用这个
=/= 不完全相等

8.26 下划线变量
以_开头的变量，声明了，不使用，编译器也不会发警告。

 命名一个我们不打算使用的变量。例如，相比open(File, _)， open(File, _Mode)这
种写法能让程序的可读性更高。
 用于调试。

第 9 章  类 型
9.1 指定数据和函数类型

在Erlang中我们可以通过type及spec定义数据类型及函数原型。
通过这些信息，我们对函数及调用进行静态检测，从而发现一些代码中问题。
同时，这些信息也便于他人了解函数接口，也可以用来生成文档。

    Type :: any()   %% 最顶层类型，表示任意的Erlang term
     | none()   %% 最底层类型，不包含任何term
     | pid() | port() | ref() | [] | Atom | Binary | float()
     | Fun | Integer | List | Tuple | Union | UserDefined 
    Union :: Type1 | Type2
    Atom :: atom()
     | Erlang_Atom  %% 'foo', 'bar', ...
    Binary :: binary()%% <<_:_ * 8>>
       | <<>>
       | <<_:Erlang_Integer>>%% Base size
       | <<_:_*Erlang_Integer>>  %% Unit size
       | <<_:Erlang_Integer, _:_*Erlang_Integer>>
    Fun :: fun() %% 任意函数
    | fun((...) -> Type) %% 任意arity, 只定义返回类型
    | fun(() -> Type)
    | fun((TList) -> Type)
    Integer :: integer()
    | Erlang_Integer %% ..., -1, 0, 1, ... 42 ...
    | Erlang_Integer..Erlang_Integer %% 定义一个整数区间
    List :: list(Type)   %% 格式规范的list (以[]结尾)
     | improper_list(Type1, Type2)   %% Type1=contents, Type2=termination
     | maybe_improper_list(Type1, Type2) %% Type1 and Type2 as above
    Tuple :: tuple()  %% 表示包含任意元素的tuple
      | {}
      | {TList}
    TList :: Type
      | Type, TList

由于 lists 经常使用，我们可以将 list(T) 简写为 [T] ，而 [T, ...] 表示一个非空的元素类型为T的规范列表。两者的区别是 [T] 可能为空，而 [T, ...] 至少包含一个元素。
'_' 可以用来表示任意类型。
list()表示任意类型的list，其等同于 [_]或[any()], 而 [] ，仅仅 表示一个单独的类型即空列表。
为了方便，下面是一个内建类型列表

    term() any()
    bool() 'false' | 'true'
    byte() 0..255
    char() 0..16#10ffff
    non_neg_integer() 0..
    pos_integer() 1..
    neg_integer() ..-1
    number() integer() | float()
    list() [any()]
    maybe_improper_list() maybe_improper_list(any(), any())
    maybe_improper_list(T) maybe_improper_list(T, any())
    string() [char()]
    nonempty_string() [char(),...]
    iolist()	
    maybe_improper_list(char() | binary() | iolist(), binary() | [])
    module() atom()
    mfa() {atom(),atom(),byte()}
    node() atom()
    timeout() 'infinity' | non_neg_integer()
    no_return()	none()

9.2.1 类型的语法
类型定义可以使用以下的非正式语法：
它的意思是T1被定义为A、 B或C其中之一。

定义新的类型：

	-type NewTypeName(TVar1, TVar2, ... TVarN) :: Type.


9.2.3 指定函数的输入输出类型

函数规范的编写方式
	-spec functionName(T1, T2, ..., Tn) -> Tret when
	    Ti :: Typei,
	Tj :: Typej,
	...

9.2.4 导出类型和本地类型
导出类型：

	-export_type(typeName/0, typeName2/0).

9.2.5 不透明类型

-opaque XXX : YYY.
隐藏XXX的内部细节。理论上是不希望在模块外部使用XXX的内部细节。


9.3 dialyzer 教程
 
检测程序里的类型错误。主要是针对类型错误。
$dialyzer test.erl
dialyzer很容易受到干扰。所以要遵循几条简单规则：
避免使用-compile(export_all)。
为模块导出函数的所有函数提供详细的类型规范。
为记录定义里的所有元素提供默认的参数。
把匿名变量作用函数的参数经常会导致结果类型不如预想的那么精确。

总结：这是一个很有意思的功能，比C++的强制类型更加宽松，比Lua的弱类型又多了一个选择。算是一个亮点。

第 10 章 编译和运行程序
10.1 改变开发环境
10.1.1 设置载入代码的搜索路径
以下是两个最常用来操作载入路径的函数：
 -spec code:add_patha(Dir)=>true|{error,bad_directory}
向载入路径的开头添加一个新目录Dir。
 -spec code:add_pathz(Dir)=>true|{error,bad_directory}
向载入路径的末端添加一个新目录Dir。

如果你怀疑载入了错误的模块，可以调用code:all_loaded()（返回一个已加载模块的总列表）或code:clash()来帮助调查哪里出了错。
通常的惯例是把这些命令放在主目录（home directory）里一个名为.erlang的文件内。
可以用这样的命令启动Erlang:
$erl -pa Dir1 -pa Dir2 .. -pz DirK1 -pz DirK2
-pa Dir标识会把Dir添加到代码搜索路径的开头， -pz Dir则会把此目录添加到代码路径的末端。

10.1.2 在系统启动时执行一组命令

如果 Erlang启动时的当前目录里已经有一个 .erlang文件，它就会优先于主目录里
的.erlang。通过这种方式，可以让Erlang根据不同的启动位置表现出不同的行为。这对特定的
应用程序来说可能很有用。在这种情况下，多半应该把一些打印语句添加到启动文件里，否则你
可能会忘记本地启动文件的存在，从而感到非常困惑。

在某些系统里，主目录的位置并不清晰，或者可能和你认为的不一样。要找出Erlang认定
的主目录位置，可以这么做：
1> init:get_argument(home).
{ok,[["/home/joe"]]}

10.2 运行程序的不同方式

10.2.1 在 Erlang shell 里编译和运行
$ erl
..
1>c(hello)
{ok,hello}
2>hello:start().
Hello world
ok

10.2.2 在命令提示符界面里编译和运行
$erlc hello.erl
$erl -noshell -s hello start -s init stop
Hello world
$

 -noshell以不带交互式shell的方式启动Erlang（因此不会看到Erlang的“徽标”，也就是
通常系统启动时首先显示的那些信息）。
 -s hello start运行hello:start()函数。 注意：使用-s Mod ...选项时， Mod必须是
已编译的。
 -s init stop在之前的命令完成后执行init:stop()函数，从而停止系统。

10.2.3 作为Escript运行
可以用escript来让程序直接作为脚本运行，无需事先编译它们。

10.2.4 带命令行参数的程序

10.3 用 makefile 使编译自动化

    .SUFFIXES: .erl .beam .yrl
    
    .erl.beam:
    	erlc -W $<
    
    MODS = a b abc area_server_final allocator\
       benchmark_assoc benchmark_mk_assoc attrs chat_multi chat_socket\
       chat_cluster chat_file_transfer \
       chat_secure checker clock ctemplate\
       dist_demo edemo1 edemo2 ets_test event_handler extract fac fac1\
       geometry id3_v1 hello m1 upcase\
       id3_tag_lengths \
       lib_find lib_io_widget lib_files_find lib_lin\
       lib_filenames_dets lib_primes \
       lib_auth_cs  lib_md5 lib_misc\
       lib_rsa lib_tcp_server math1 math2 math3 my_fac_server name_server\
       name_server1\
       area_server area_server1 area_server0 motor_controller\
       mp3_manager my_bank  area_server1 area_server2\
       monitor1 monitor2 monitor3 my_alarm_handler\
       new_name_server broadcast convert1 convert2 convert3\
       convert4 convert5 mylists lists1\
       counter1 counter2 counter3 counter4 error1 cookbook_examples\
       misc mp3_sync phofs prime_server processes ptests registrar\
       sellaprime_app sellaprime_supervisor shop \
       scavenge_urls shop1 shop2 shop3 socket_examples shout stimer\
       server1 server2 server3 server4 server5\
       status test_mapreduce test_mnesia tracer_test try_test\
       udp_test update_binary_file update_file user_default vfs wordcount
    
    ERL = erl -boot start_clean 
    
    compile: ${MODS:%=%.beam} subdirs trigramsOS.tab
    	@echo "make clean - clean up"
    
    shoutcast: compile
    	erl -s shout start
    
    subdirs:
    	cd socket_dist; make compile
    	cd escript-4.1; make 
    
    counter1.beam: counter1.erl
    	erlc -W0 counter1.erl
    
    m1.beam: m1.erl
    	erlc -Ddebug m1.erl
    
    all: compile 
    
    
    trigramsOS.tab: 354984si.ngl.gz lib_trigrams.beam
    	@erl -noshell -boot start_clean -s lib_trigrams make_tables\
    -s init stop
    
    timer_tests:
    	@erl -noshell -boot start_clean -s lib_trigrams timer_tests\
    -s init stop	
    clean:	
    	rm -rf *.beam lists.ebeam erl_crash.dump 
    	rm -rf trigramsOS.tab trigramsS.tab trigrams.dict 
    	cd ets_trigrams; make_clean
    	cd socket_dist; make_clean

10.4.2 未定义（缺失）的代码

10.4.4 我的makefile不工作


第 12 章 并发编程


erlang的进程是指虚拟机管理的进程，而不是操作系统的重量级进程。
这些进程，创建和销毁都非常迅速；
进程之间发送消息非常快速；
进程在所有的操作系统上都具有相同的行为方式；
可以拥有大量的进程；
进程不共享任何内存，是完全独立的；
进程唯一的交互方式就是消息传递。

12.1 基本并发函数

Pid = spawn(Mod, Func, Args) 
创建一个新的进程来运行指定模块的指定参数。
创建一个新的并发进程来执行apply(Mod, Func, Args)。这个新进程和调用进程并列运行。 
spawn返回一个Pid（process identifier的简称，即进程标识符）。可以用Pid来给此进程发送消息。
请注意，元数为length(Args)的Func函数必须从Mod模块导出。
当一个新进程被创建后，会使用最新版的代码定义模块。
Pid = spawn(Fun)
创建一个新的进程来执行Fun。这种形式的spawn总是使用被执行fun的当前值，而且这个fun无需从模块里导出。
这两种spawn形式的本质区别与动态代码升级有关。 12.8节会讨论如何从这两种spawn形式中做出选择。

Pid!Message
向标记为Pid的进程发送消息，消息是异步的。
Pid!M返回M。因此可以连续发送消息Pid!Pid2!...!Msg
Pid ! M被定义为M。因此， Pid1 ! Pid2 !...! Msg的意思是把消息Msg发送给Pid1、Pid2等所有进程。

receive ... end
接收发送给某个进程的消息。

receive
  Pattern1 [when Guard1]->
    Expressions1;
  Pattern2 [when Guard2]->
    Expressions2;
  ...
end

12.2 客户端-服务器介绍

self()获得当前进程的标识


rpc(remote procedure call)远程过程调用。封装了发送请求和等待响应的代码。
rpc(Pid, Request)->
    Pid!{self(), Request},
	receive
		{Pid, Response}->
			Response
	end.

要和对应的receive配合
loop()->
	receive
		{From, ...}->
			From!{self(), ...}
			loop();
		... 
	end.

获得系统允许最大的进程数量
erlang:system_info(process_limit).

12.4 带超时的接收
loop()->
	receive
		...
	Pattern1 [when guard1] %设置超时的时间
		Expressions 
	end.

12.4.1 只带超时的接收

sleep(T) ->
    receive
    after T ->
       true
    end.

12.4.2 超时值为 0 的接收

flush_buffer() ->
    receive
	_Any ->
	    flush_buffer()
    after 0 ->
	true
    end.

12.6 注册进程

注册进程（registered process），系统任何进程都能与这个进程通信。
register(AnAtom, Pid) 用一个字符串来注册某个进程。
unregister(AnAtom) 移除与AnAtom关联的所有注册信息，如果进程自身崩溃了，就会自动移除
whereis(AnAtom)->Pid|undefined 检测AnAtom是否已被注册
registered()->[AnAtom::atom()] 返回一个包含系统里所有注册进程的列表。

进程：

普通进程和系统进程，

连接：

进程之间可以相互连接。如果AB两个进程连接，A挂了的时候，会想B发送一个错误信号。

连接组：

进程P的连接组是芝P相连的一组进程。

监视：

监视和连接很相似，但是单向的。

消息和错误信号：

进程协作的方式是交换消息或错误信号。

错误信号的接收：

{'EXIT', Pid, Why} 

当普通进程收到错误消息时，如果退出原因不是normal，该进程就会终止，并向它的连接组广播一个退出信号

显式错误信号

任何执行exit(Why)的进程都会终止

exit(Pid,Why)，发送一个虚假错误信号
不可捕捉的退出信号

系统进程收到摧毁信号（kill signal）时会终止。摧毁信号会绕过常规的错误信号处理机制。


创建进程并建立连接

-spec spawn_link(Fun)->Pid

-spec spawn_link(Mod, Fnc, Args)->Pid

新进程挂掉会波及旧进程


创建进程并监视

-spec spawn_monitor(Fun)->Pid

-spec spawn_monitor(Mod, Fun, Args)->{Pid, Ref}

子进程挂了，会向父进程发送消息{‘DOWN’,  Ref, process, Pid, Why}。但是父进程不会挂掉。


-spec process_flag(trap_exit, true)

把当前进程转变成系统进程，系统进程是一种能够接收和处理错误信号的进程。


-spec link(Pid)->true

创建一个与进程Pid的双向连接


-spec unlink(Pid)->true 

移除连接


-spec erlang:monitor(process, Item)->Ref

设立一个监视，Item可以是进程的Pid，也可以是它的注册名称。


-spec demonitor(Ref)->true

移除监视


-spec exit(Why)-> none()

终止进程


-spec exit(Pid, Why)->true

向进程Pid发送一个伪造退出信号。，自身并不会退出。



12.8 用 MFA 或 Fun 进行分裂

用显式的模块、函数名和参数列表（称为MFA）来分裂一个函数是确保运行进程能够正确升级为新版模块代码（即使用中被再次编译）的恰当方式。动态代码升级机制不适用于fun的分裂，只能用于带有显式名称的MFA上。


13.8.2 让一组进程共同终止
假设要创建若干工作进程来解决某个问题，它们分别执行函数F1, F2...。如果任何一个进程挂了，我们希望它们能全体终止。可以调用start([F1,F2, ...])来实现这一点。



all(Pred, List) -> bool()
List中是否所有的元素都满足Pred条件

any(Pred, List) -> bool()
List中是否有能满足Pred条件的元素

append(ListOfLists) -> List1
合并ListOfLists中的列表。

append(List1, List2) -> List3
合并两个列表

concat(Tings) -> string()
合并原子列表

delete(Elem, List1) -> List2
从列表List1中删除符合Pred条件的元素

duplicate(N, Elem) -> List
创造一个由N个Elem组成的列表

filter(Pred, List1) -> List2
用Pred条件过滤列表List1


flatlength(DeepList) -> int()
获取深层列表DeepList扁平化之后的列表长度

flatmap(Fun, List1) -> List2
对List1列表进行扁平化并通过Fun函数映射声称新列表

flatten(DeepList) -> List
对深层列表DeepList进行扁平化处理

flatten(DeepList, Tail) -> List
对深层列表DeepList进行扁平化处理

floldl(Fun, Acc0, List) -> Acc1
在列表List上以foldl方式执行Fun函数

foldr(Fun, Acc0, List) -> Acc1
在列表List上以foldr方式执行Fun函数

foreach(Fun, List) -> void()
对列表List上的每一个元素执行Fun函数

keydelete(Key, N, TupleList1) -> TupleList2
从元组列表TupleList1中删除第N个字段为key的记录。

keymap(Fun, N, TupleList1) -> TupleList2
对元组列表TupleList1通过Fun函数映射生成新列表。

keymember(Key, N, TupleList) -> bool()
检查元组列表TupleList中是否存在第N个字段为Key的数据。

kermerge(N, TupleList1, TupleList2) -> TupleList3
将两个以第N个字段为键的元组列表TupleList1和TupleList2合并。

keyreplace(Key, N, TupleList1, NewTuple) -> TupleList2
替换元组列表TupleList1当中的元素

keysearch(Key, N, TupleList) -> { value, Tuple} | false
在元组列表TupleList中搜索特定的元素

keysort(N, TupleList1) -> TupleList2
对元组列表TupleList1进行排序

last(List) -> Last
获取列表List的最后一个元素

map(Fun, List1) -> List2
用Fun将列表List1映射为新的列表

mapfoldl(Fun, Acc0, List1) -> {List2, Acc1}
同时进行map和fold的操作

mapfoldr(Fun, Acc0, List1) -> {List2, Acc1}
同时进行map和fold的操作

max(List) -> Max
返回列表List中最大的元素

member(Elem, List) -> bool()
检查Elem是否为列表List中的元素

merge(ListOfLists) -> List3
合并列表ListOfLists中的有序列表

merge(List1, List2) -> List3
合并有序列表List1和List2

merge(List1, List2, List3) -> List4
合并3个有序列表

min(List) -> Min
获取列表List中最小的元素

nth(N, List) -> Elem
获取列表List中第N个元素

nthtail(N, List1) -> Tail
获取列表List第N个元素之后的尾部

partition(Pred, List) -> { Satisfying, NonSatisfying}
用Pred函数将列表List分为两个部分

prefix(List1, List2) -> bool()
判断List1是否是List2的前缀

reverse(List1) -> List2
反转列表List1的顺序

reverse(List1, Tail) -> List2
反转列表List1，然后将Tail加到后面

seq(From, To, Incr) -> Seq
生成由整数序列构成的列表。

sort(List1) -> List2
对List1进行排序

sort(Fun, List1) -> List2
用Fun函数对List1进行排序

split(N, List1) -> {List2, List3}
从第N个元素起，将列表List1分为两段。

splitwith(Pred, List) -> {List1, List2}
按Pred条件将List分为两段

sublist(List1, len) -> List2
获取列表List1长度为Len的部分

sublist(List1, Start, Len) -> List2
获取列表List1从Start起长度为Len的部分

subtract(List1, List2) -> List3
对列表List1和List2做逻辑减

suffix(List1, List2) -> bool()
判断列表List1是否是列表List2的后缀。

sum(List) -> number()
获取列表List中所有元素的和

takewhile(Pred, List1) -> List2
从列表List1中去除满足Pred条件的元素

ukeymerge(N, TupleList1, TupleList2) -> TupleList3
将两个元组列表TupleList1和TupleList2合并，去除重复的元素

ukeysort(N, TupleList1) -> TupleList2
对元组列表TupleList1进行排序，去除重复的元素

umerge(ListOfLists) -> List1
合并列表ListOfLists的有序列表，去除重复的元素

umerge(List1, List2) -> List3
合并有序列表List1和List2，去除重复的元素

umerge(Fun, List1, List2) -> List3
用Fun函数合并有序列表List1和List2，去除重复的元素

umerge3(List1, List2, List3) -> List4
合并3个有序列表，去除重复的元素

unzip(List1) -> {List2, List3}
将由两个元组组成的列表List1分解成为两个列表

unzip3(List1) -> { List2, List3, List4}
将由3个元组组成的列表List1分解成为3个列表

usort(List1) -> List2
对列表List1进行排序，去除重复的元素

usort(Fun, List1) -> List2
用Fun函数对列表List1排序，去除重复的元素

zip(List1, List2) -> List3
将列表List1和List2合并为一个列表

zip3(List1, List2, List3) -> List4
将3个列表合并成一个列表

zipwith(Combine, List1, List2) -> List3
用Combine函数将列表List1和List2合成为一个列表

zipwith3(Combine, List1, List2, List3) -> List4
用Combine函数将3个列表合成为一个列表。



输入和输出功能都被定义在io模块
输出功能非常常用,由于erlang项目没有可断点调试的IDE(或者说根本不需要),所以所有的调试操作都是由io输出 来调试的

io:get_line/1.

​ 参数:输入提示

​ 获取标准输入,回车结束,

io:get_chars/2.

​ 参数:输入提示,跳过字符数量

​ 获取输入字符,获取的字符不包含跳过数量的字符

io:read/1

​ 参数:输入提示

​ 从shell面板读取一个项元,项元必须是一个明确的值,而不是一个表达式

io:write/1

​ 打印输出一个项元

io:format/1

直接输出一段文本

io:format/2

​ 参数:格式化的字符串/二进制,解析列表,列表,列表

​ 格式化输出一段文本

​ 格式化的占位符(控制格式化的序列,简称:控制序列)以“~”开头,后面的称之为填充字符

​ 完美的控制序列型是为~F.P.PadC,其中F为输出宽度(长度和格式,+10表示左对齐10位长度,-10表示右对齐10位长度,内容长度不足时使用Pad填充),P为输出精度,即截取原输出文本的长度,当P大于原文本昌都市,使用Pad填充,Pad是填充字符,只能是一个字符,默认空格,C是控制字符,如:~40p~n

控制序列表:

符号	说明
~c	输出一个字符的ASCII码
~f	输出一个有6位小数点的浮点数
~e	输出一个以科学记数法表示的共6位的浮点数
~w	以标准语法从输出任何项元(也就是Term),常被用于输出Erlang数据类型
~p	类似~w,但是会在适当的地方换行和缩进,并尝试将列表作为字符串输出
~W、~P	类似~w和~p,但是限制结构深度为3
~B	输出一个十进制整数
~n	换行
~s	打印一个字符串,I/O列表或原子,打印时不带引号
~W深度示例

> io:format("~W",[[z,h,c],3]).
[z,h|...]ok

> io:format("~W",[[z,h,c],2]).
[z|...]ok

> io:format("~W",[[z,h,c],1]).
[...]ok

> io:format("~W---~W",[[z,h,c],1,[a,b,c],2]).
[...]---[a|...]ok
> f(List).
ok 

> List = [2,3,math:pi()].
[2,3,3.141592653589793]

> f(Sum).
ok

> Sum = lists:sum(List).
8.141592653589793

> io:format("hello,world!~n",[]).
hello,world!
ok

> io:format("the sum of ~w is ~w.~n",[[2,3,4],demo:sum([2,3,4])]).
the sum of [2,3,4] is 9.
ok

> io:format("the sum of ~W is ~.2f.~n",[List,3,Sum]).
the sum of [2,3|...] is 8.14.
ok

> io:format("~40p~n",[{apply,io,format,["the sum of ~W is ~.2f.~n",[[2,3,math:pi()],3,demo:sum([2,3,math:pi()])]]}]).
{apply,io,format,
       ["the sum of ~W is ~.2f.~n",
        [[2,3,3.141592653589793],
         3,8.141592653589793]]}
ok

> io:format("|~-4s|",[abc]).            % |abc |ok
> io:format("|~-10s|",[abc]).           % |abc       |ok
> io:format("|~-10.0.+s|",[abc]).       % |++++++++++|ok
> io:format("|~-10.1.+s|",[abc]).       % |a+++++++++|ok
> io:format("|~-10.2.+s|",[abc]).       % |ab++++++++|ok
> io:format("|~-10.10.+s|",[abc]).      % |abc+++++++|ok

> io:format("|~4s|",[abc]).             % | abc|ok
> io:format("|~10s|",[abc]).            % |       abc|ok
> io:format("|~10.0.+s|",[abc]).        % |++++++++++|ok
> io:format("|~10.1.+s|",[abc]).        % |+++++++++a|ok
> io:format("|~10.7.+s|",[abc]).        % |+++abc++++|ok
> io:format("|~10.10.+s|",[abc]).       % |+++++++abc|ok
io:format/3

​ 参数:输出文件流(需要输出到的进程标识符,file:open(File,write)的返回值)/格式化的字符串/二进制,解析列表,列表,列表

​ 往输出文件流中输出(写出)数据

FS = file:open(File, read|write...).
io:format(FS, "~P~N", [Message]).
file.close(FS).
%% 
<<"爱我中华"/utf8>>
% 或者
unicode:characters_to_binary("爱我中华").

> io:format("~ts",[<<"爱我中华"/utf8>>]).
爱我中华ok
%%todo


----------

**behaviour 归类：**

# -behaviour(gen_server). #

## 启动服务器 ##

用来启动服务器的有start/3,start/4,start_link/3,start_link/4这四个函数。 
使用这些start函数之后，就会产生一个新的进程，也就是一个gen_server服务器。
这些 start函数的正常情况下返回值是{ok,Pid}，Pid就是这个新进程的进程号。
带link与不带的区别在于是否跟父进程建立链接，换种说法是，新启动的进程死掉后，会不会通知启动他的进程（父进程）。

start函数可以四个参数(ServerName, Module, Args, Options)：

第一个参数ServerName是服务名， 是可以省掉的。具有相同服务名的模块在一个节点中只能启动一次，重复启动会报错，为 {error, {already_started, Pid}}。具有服务名的服务进程可以使用服务名来调用， 没有服务名的只能通过进程号pid来调用了。通常有名字的服务进程会使用模块名做为 服务名，即上面模板中定义的宏-define(SERVER, ?MODULE)，然后在需要使用服务名的 地方填入?SERVER.

第二个参数Module是模块名，一般而言API和回调函数是写在同一个文件里的，所以就用 ?MODULE，表示本模块的模块名。

第三个参数Args是回调函数init/1的参数，会原封不动地传给init/1。

第四个参数Options是一些选项，可以设置debug、超时等东西。
start对应的回调函数是init/1，一般来说是进行服务器启动后的一些初始化的工作， 并生成初始的状态State，正常返回是{ok, State}。这个State是贯穿整个服务器， 并把所有六个回调函数联系起来的纽带。它的值最初由init/1生成， 此后可以由三个handle函数修改，每次修改后又要放回返回值中， 供下一个被调用的handle函数使用。 如果init/1返回ignore或{stop, Reason}，则会中止服务器的启动。
有一点细节要注意的是，API函数和回调函数虽然习惯上是写在同一个文件中，但执行函数 的进程却通常是不一样的。在上面的模板中，start_link/0中使用self()的话，显示的是调用者的进程号，而在init/1中使用self()的话，显示的是服务器的进程号。

## 使用服务器 ##

三个handle开头的回调函数对应着三种不同的使用服务器的方式。如下：

gen_server:call     -------------   handle_call/3
gen_server:cast     -------------   handle_cast/2
用！向服务进程发消息   -------------   handle_info/2
call是有返回值的调用；cast是无返回值的调用，即通知；而直接向服务器进程发的 消息则由handle_info处理。
call是有返回值的调用，也是所谓的同步调用，进程会在调用后一直等待直到回调函数返回为止。 它的函数形式是 gen_server:call(ServerRef, Request, Timeout) -> Reply，
第一个参数ServerRef是被调用的服务器，可以是服务器名，或是服务器的pid。
第二个参数Request会直接传给回调函数handle_call。
最后一个参数Timeout是超时，是可以省略的，默认值是5秒。
call是用来指挥回调函数handle_call/3干活的。具体形式为 handle_call(Request, From, State)。

第一个参数Request是由call传进来的，是写程序时关注和处理的重点。
第二个参数From是gen_server传进来的，是调用的来源，也就是哪个进程执行了call。 From的形式是{Pid, Ref}，Pid是来源进程号，而Ref是调用的标识，每一次调用 都不一样，用以区别。有了Pid，在需要向来源进程发送消息时就可以使用，但由于call 是有返回值的，一般使用返回值传递数据就好。
第三个参数State是服务器的状态，这是由init或是其他的handle函数生成的，可以根据需要进 行修改之后，再放回返回值中。
call
call对应的回调函数handle_call/3在正常情况下的返回值是{reply, Reply, NewState}， Reply会作为call的返回值传递回去，NewState则会作为服务器的状态。 另外还可以使用{stop, Reason, State}中止服务器运行，这比较少用。
使用call要小心的是，两个服务器进程不能互相call，不然会死锁。

cast
cast是没有返回值的调用，一般把它叫做通知。它是一个“异步”的调用，调用后会直接收到 ok，无需等待回调函数执行完毕。

它的形式是gen_server:cast(ServerRef, Request)。参数含义 与call相同。由于不需要等待返回，所以没必要设置超时，没有第三个参数。

在多节点的情况下，可以用abcast，向各节点上的具有指定名字的服务进程发通知。 

cast们对应的回调函数是handle_cast/2，具体为：handle_cast(Msg, State)。 第一个参数是由cast传进去的，第二个是服务器状态，和call类似，不多说。

handel_cast/2的返回值通常是{noreply, NewState}，这可以用来改变服务器状态， 或是{stop, Reason, NewState}，这会停止服务器。通常来说，停止服务器的命令用 cast来实现比较多。

## 原生消息 ##

原生消息是指不通过call或cast，直接发往服务器进程的消息，有些书上译成“带外消息”。 比方说网络套接字socket发来的消息、别的进程用!发过来的消息、跟服务器建立链接的进程死掉了， 发来{'EXIT', Pid, Why}等等。一般写程序要尽量用API，不要直接用!向服务器进程发消息， 但对于socket一类的依赖于消息的应用，就不得不处理原生消息了。

原生消息使用handle_info/2处理，具体为handle_info(Info, State)。其中Info是 发过来的消息的内容。回复和handle_cast是一样的。
 
## 停止服务器 ##
上面介绍的handle函数返回{stop,...}，就会使用回调函数terminate/2进行扫尾工作。 典型的如关闭已打开的资源、文件、网络连接，打log做记录，通知别的进程“我要死啦”， 或是“信春哥，满血复活”：利用传进来的状态State重新启动服务器。

-behaviour(gen_fsm).

-behaviour(application).

-behaviour(supervisor).


string:len("abcdef").



结果为 6



求字符串的长度

string:equal("abc","abc").	结果为 true	判断2字符串是否完全相等
string:concat("abc","def").	结果为 "abcdef"	合并字符串
string:chr("abdcdef",$d).	结果为 3	求某一字符在字符串中第一次出现的位置
string:rchr("abdcdef",$d).	结果为 5
string:str("hehe haha haha","haha").	结果为 6	求某一字符串在字符串中第一次出现的位置
string:rstr("hehe haha haha","haha").	结果为 11
string:substr("Hello World",4).	结果为 "lo World"	截取字符串
string:substr("Hello World",4,5).	结果为 "lo Wo"	截取字符串
string:tokens("asdhfgjjdttfg","df").	结果为 ["as","h","gjj","tt","g"]	分割字符串
string:join(["aaa","bbb","ccc"],"@").	结果为 "aaa@bbb@ccc"	用特定字符连接
string:chars($a,5).	结果为 "aaaaa"
string:copies("as",5).	结果为 "asasasasas"
string:words("aaa bbb ccc").	结果为 3
string:words("abcbchdbjfb"，$b).	结果为 4	用字符b分割，求个数
string:sub_words("abcbchdbjfb",3,$b).	结果为 "chd"	用字符b分割，取第三个
string:strip("    aaa  ").	结果为 "aaa"	去掉字符串两边的空格
string:strip("...aaa..",both,$.).	结果为 "aaa"	去掉字符串两边的.
string:left("hahaha",10).	结果为 "hahaha    "	截取前10个字符串，不足用空格补(string:right类似)(string:centre类似)
string:left("hahaha",10,$!).	结果为 "hahaha!!!!"	截取前10个字符串，不足用!补(string:right类似)(string:centre类似)
string:to_integer("123sa23").	结果为 {123,"sa23"}
srring:to_lower("asFDds").	结果为 "asfdds"	转换小写
srring:to_upper("asFDds").	结果为 "ASFDDS"	转换大写