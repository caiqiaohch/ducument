math:acos/1
返回一个数的反余弦值

用法：

acos(X)
返回一个数的反余弦值，参数 X 必须是 -1.0 ~ 1.0 之间的数，返回的值是 0 到 PI 之间的弧度值。

Acos = math:acos(0.5),
io:format("Acos is ~p~n", [Acos]).
Acos = math:acos(-1),
io:format("Acos is ~p~n", [Acos]).
如果参数 X 超过了 -1.0 ~ 1.0 的范围，则会抛出一个异常错误。

Acos = math:acos(20),
io:format("Acos is ~p~n", [Acos]).

----------
math:acosh/1
返回一个数的反双曲线余弦值

用法：

acosh(X)
返回参数 X 的反双曲线余弦值

Acosh = math:acosh(3.14),
io:format("Acosh is ~p~n", [Acosh]).

----------
math:asin/1
返回一个数的反正弦值

用法：

asin(X)
返回一个数的反正弦值

Asin = math:asin(0.5),
io:format("Asin is ~p~n", [Asin]).
如果参数 X 超过了 -1.0 ~ 1.0 的范围，则会抛出一个异常错误

Asin = math:asin(2),
io:format("Asin is ~p~n", [Asin]).

----------
math:asinh/1
返回一个数的反双曲线正弦值

用法：

asinh(X)
返回参数 X 的反双曲线正弦值

Asinh = math:asinh(45),
io:format("Asinh is ~p~n", [Asinh]).

----------
math:atan/1
返回数字的反正切值

用法：

atan(X)
返回数字的反正切值，返回的值是 -PI/2 到 PI/2 之间的弧度值

Atan = math:atan(10),
io:format("Atan is ~p~n", [Atan]).

----------
math:atan2/2
返回从 x 轴到点 (x,y) 之间的角度

用法：

atan2(Y, X)
返回从 x 轴到点 (x,y) 之间的角度，

Atan = math:atan2(10, 20),
io:format("Atan ~p~n", [Atan]).

----------
math:atanh/1
返回一个角度的反双曲线正切值

用法：

atanh(X)
返回一个角度的反双曲线正切值

Atanh = math:atanh(0.5),
io:format("Atanh is ~p~n", [Atanh]).

----------
math:cos/1
返回一个数字的余弦值

用法：

cos(X)
返回一个数字的余弦值

Cos = math:cos(90),
io:format("Cos is ~p~n", [Cos]).
Pi = math:pi(),
Cos = math:cos(2 * Pi),
io:format("Cos is ~p~n", [Cos]).

----------
math:cosh/1
返回一个数的双曲线余弦值

用法：

cosh(X)
返回参数 X 的双曲线余弦值

Cosh = math:cosh(10),
io:format("Cosh is ~p~n", [Cosh]).

----------
math:erf/1
返回一个数的误差函数

用法：

erf(X) -> float()
返回参数 X 的误差函数

Erf = math:erf(0.5),
io:format("Erf is ~p~n", [Erf]).

----------
math:exp/1
计算 e 的指数

用法：

exp(X)
计算 e 的指数，e 的自然对数底是 2.718281828459045

Exp = math:exp(1),
io:format("Exp is ~p~n", [Exp]).
Exp = math:exp(3.14),
io:format("Exp is ~p~n", [Exp]).

----------
math:log/1
计算一个数字的自然对数

用法：

log(X)
计算参数 X 的自然对数

Log = math:log(2.718281828459045),
io:format("Log is ~p~n", [Log]).

----------
math:log10/1
计算以10为基数的对数

用法：

log10(X)
计算以10为基数的对数

Log10 = math:log10(100),
io:format("Log10 is ~p~n", [Log10]).

----------
math:pi/0
返回一个圆周率值

用法：

pi() -> float()
内部实现：

-spec pi() -> float().

pi() -> 3.1415926535897932.
返回一个圆周率值

math:pi().

----------
math:pow/2
返回 X 的 Y 次方

用法：

pow(X, Y)
返回 X 的 Y 次方

Pow = math:pow(2, 3),
io:format("Pow is ~p~n", [Pow]).
Pow = math:pow(27, 1/3),
io:format("Pow is ~p~n", [Pow]).

----------
math:sin/1
求正弦值

用法：

sin(X)
返回一个数字的正弦值

Sin = math:sin(45),
io:format("Sin is ~p~n", [Sin]).
Pi = math:pi(),
Sin = math:sin(Pi / 2),
io:format("Sin is ~p~n", [Sin]).

----------
math:sinh/1
返回一个数的双曲线正弦值

用法：

sinh(X)
返回参数 X 的双曲线正弦值

Sinh = math:sinh(10),
io:format("Sinh is ~p~n", [Sinh]).

----------
math:sqrt/1
返回一个数的平方根

用法：

sqrt(X)
返回参数 X 的平方根

Sqrt = math:sqrt(2),
io:format("Sqrt is ~p~n", [Sqrt]).

----------
math:tan/1
返回一个表示某个角的正切值

用法：

tan(X)
返回一个表示某个角的正切值

Tan = math:tan(10),
io:format("Tan is ~p~n", [Tan]).

----------
math:tanh/1
返回一个数的双曲线正切值

用法：

tanh(X)
返回参数 X 的双曲线正切值

Tanh = math:tanh(90),
io:format("Tanh is ~p~n", [Tanh]).

----------
