Erlang映射 (Map)

映射用于表示键和值的关联关系。这种关联方式是由 “#{” 与 “}” 括起来。创建一个字符串 "key" 到值 42 的映射的方法如下：

1>#{ "key"=>42}.
  #{"key" => 42}
让我们直接通过示例来看一些有意思的特性。

下面的例子展示了使用映射来关联颜色与 alpha 通道，从而计算 alpha 混合（译注：一种让 3D 物件产生透明感的技术）的方法。将下面的代码输入到 color.erl 文件中：

-module(color).

-export([new/4, blend/2]).

-define(is_channel(V), (is_float(V) andalso V >= 0.0 andalso V =< 1.0)).

new(R,G,B,A) when ?is_channel(R), ?is_channel(G),
                  ?is_channel(B), ?is_channel(A) ->
    #{red => R, green => G, blue => B, alpha => A}.

blend(Src,Dst) ->
    blend(Src,Dst,alpha(Src,Dst)).

blend(Src,Dst,Alpha) when Alpha > 0.0 ->
    Dst#{
        red   := red(Src,Dst) / Alpha,
        green := green(Src,Dst) / Alpha,
        blue  := blue(Src,Dst) / Alpha,
        alpha := Alpha
    };
blend(_,Dst,_) ->
    Dst#{
        red   := 0.0,
        green := 0.0,
        blue  := 0.0,
        alpha := 0.0
    }.

alpha(#{alpha := SA}, #{alpha := DA}) ->
    SA + DA*(1.0 - SA).

red(#{red := SV, alpha := SA}, #{red := DV, alpha := DA}) ->
    SV*SA + DV*DA*(1.0 - SA).
green(#{green := SV, alpha := SA}, #{green := DV, alpha := DA}) ->
    SV*SA + DV*DA*(1.0 - SA).
blue(#{blue := SV, alpha := SA}, #{blue := DV, alpha := DA}) ->
    SV*SA + DV*DA*(1.0 - SA).
编译并测试：

1> c(color).
{ok,color}
2> C1 = color:new(0.3,0.4,0.5,1.0).
 #{alpha => 1.0,blue => 0.5,green => 0.4,red => 0.3}
3> C2 = color:new(1.0,0.8,0.1,0.3).
 #{alpha => 0.3,blue => 0.1,green => 0.8,red => 1.0}
4> color:blend(C1,C2).
 #{alpha => 1.0,blue => 0.5,green => 0.4,red => 0.3}
5> color:blend(C2,C1).
 #{alpha => 1.0,blue => 0.38,green => 0.52,red => 0.51}
关于上面的例子的解释如下：

-define(is_channel(V), (is_float(V) andalso V >= 0.0 andalso V =< 1.0)).
首先，上面的例子中定义了一个宏 is_channel，这个宏用的作用主要是方便检查。大多数情况下，使用宏目的都是为了方便使用或者简化语法。更多关于宏的内容可以参考预处理。

new(R,G,B,A) when ?is_channel(R), ?is_channel(G),
                  ?is_channel(B), ?is_channel(A) ->
    #{red => R, green => G, blue => B, alpha => A}.
函数 new/4 创建了一个新的映射，此映射将 red，green，blue 以及 alpha 这些健与初始值关联起来。其中，is_channel 保证了只有 0.0 与 1.0 之间的浮点数是合法数值 （其中包括 0.0 与 1.0 两个端点值）。注意，在创建新映射的时候只能使用 => 运算符。

使用由 new/4 函数生成的任何颜色作为参数调用函数 blend/2，就可以得到该颜色的 alpha 混合结果。显然，这个结果是由两个映射来决定的。

blend/2 函数所做的第一件事就是计算 alpha 通道：

alpha(#{alpha := SA}, #{alpha := DA}) ->
    SA + DA*(1.0 - SA).
使用 := 操作符取得键 alpha 相关联的值作为参数的值。映射中的其它键被直接忽略。因为只需要键 alpha 与其值，所以也只会检查映射中的该键值对。

对于函数 red/2，blue/2 和 green/2 也是一样的：

red(#{red := SV, alpha := SA}, #{red := DV, alpha := DA}) ->
    SV*SA + DV*DA*(1.0 - SA).
唯一不同的是，每个映射参数中都有两个键会被检查，而其它键会被忽略。

最后，让我们回到 blend/3 返回的颜色：

blend(Src,Dst,Alpha) when Alpha > 0.0 ->
    Dst#{
        red   := red(Src,Dst) / Alpha,
        green := green(Src,Dst) / Alpha,
        blue  := blue(Src,Dst) / Alpha,
        alpha := Alpha
    };
Dst 映射会被更新为一个新的通道值。更新已存在的映射键值对可以用 := 操作符。