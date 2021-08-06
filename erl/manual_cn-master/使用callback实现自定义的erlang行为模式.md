# [使用callback实现自定义的erlang行为模式]

之前erlang中自定义行为模式，需要导出behaviour_info函数，比如：



```
-module(gen_foo).
-export([behaviour_info/1]).

behaviour_info(callbacks) ->
    [{foo, 0}, {bar, 1}, {baz, 2}];
behavior_info(_) ->
    undefined.
```

在需要实现gen_foo行为模式的模块，添加-behaviour(gen_foo)，实现相关的函数就行。



这种方式的缺点是，实现模块在实现函数时，没有类型规范的约束，约束只有函数名和元数。

已经存在的-spec关键字，不能使用在这种场景下，原因是spec用来规范约束函数定义和使用的。

erlang提出了新的关键字：callback，极大的简化了自定义行为模式的编码。代码如下：



```
-module(ranch_transport).

-callback messages() -> {OK::atom(), Closed::atom(), Error::atom()}.
```

编译期间使用 callback约束，自动生成behaviour_info导出函数，进一步检查实现行为模式的模块导出了所有的callback函数。





callback真心让自定义行为模式简化了不少。