简介
IDEA可是说是目前对erlang语言支持最好的IDE了，包括文件跳转，代码提示等已经相当成熟。但是因为缺少官方维护，erlang的debug功能还是相对简陋的，包括当前最新版本的erlang插件，对debug功能的支持也不能算完整。

erlang官方也提供了debug功能，虽然易用性上还是偏弱，但是功能还是相对比较完整。每次重启的时候必须重新载入环境，断点之类的配置都是在环境中。如果调试需要重启节点，就会很麻烦。

下文的所有使用都是在扩展后的插件基础上，现在官方的IDEA的erlang插件debug功能还需要完善，我自己补全了一部分，包括多进程调试，debug验算窗的代码提示。支持条件断点等。
github地址

https://pan.baidu.com/s/1jdBZZK23XglWbZkOh7xkcQ?_at_=1628143711067#list/path=%2F编译好的插件（提取码: 533e）
插件是在IDEA2019.3上编译的，应该是需要2019.3以上的版本才能使用
2020-11-16更新
重新编译了一次，拉高了插件版本，避免和原作者的冲突，最好是直接回合给原作者，但是改动太多了，回合估计会需要很久，目前是直接把发布版本拉高到2000来暂时解决

链接 提取码: 5f42
2021-1-14更新

新增了debug阶段的变量提示，鼠标移动到变量上，或者按住Alt点击变量可以直接验算变量值
最佳实践修改，具体参看 实践修改部分
链接 提取码: 33hi
Erlang的debug基础
erlang的debug对外接口基本都由int模块提供，和其他语言最大的不同在于，erlang调试的最小单位是模块，如果要在某个模块中进行断点调试，则首先必须调用int:i 或者int:ni将模块进行标记，没有标记的模块，即使标记了断点，也是不会生效。断点的跳转也依赖于标记，如果在A模块中触发断点，断点处执行B模块的函数，但是B模块没有被标记的情况下，下一步是不能跳转到B模块的。

还有一个重要的不同是，erlang是典型的多进程语言，意味着断点可能被多个进程同时触发，erlang的设计是触发断点的进程会阻塞在执行处，直到手动将断点继续，而无论继续，下一步，都是以单个进程为单位。意味着如果有10个进程触发了断点，则必须继续10次才行。

IDEA提供的基础debug
IDEA的erlang插件提供的debug大体上可以分为两种：

本地debug，就是Erlang Application提供的debug和eunit

缺点的话比较明显的就是没有提供命令行输入，如果要在erlang shell执行命令，只能remsh目标节点进行输入，当然前提是debug的节点本身加了-name参数 现在可以直接输入命令
debug重新执行的时候，原始节点也会顺带重启

RmoteDebug，debug逻辑运行在单独的节点，停止debug逻辑不会影响目标节点

如标题所说，remote的debug逻辑是运行在一个单独的节点上，debug节点会调用net_kernet和目标节点相连，之后调用int:ni标记需要debug的模块，ni会在所有已经相连的节点上进行debug标记。

需要注意的是node name要填完整的包括@后的ip，cookie是连接目标节点使用的cookie，和node args的-setcookie不冲突，至于interpret scope，是我单独加的，因为远程调试之前默认是interpret所有已知module，远程调试的时候会比较慢，而且没有必要，这里添加了选项，默认是只interpret有断点的模块。但是要注意的是，如果断点逻辑在不同文件之间跳转，则要跳转的文件必须被interpret了才能跳转到目标文件

断点，调用栈基础使用

断点触发时的界面如上，Debug栏会显示当前调试的进程，和进程的调用栈，右侧显示当前栈层的变量
左侧点击不同的调用栈层级，可以进行切换，下拉进程列表可以切换当前调试的进程。
可以在A进程进行N次下一步之后，切换到B进程进行下一步，之后再切换回A进程。但是要注意debug的逻辑可能会改变程序正常执行的标准顺序，调试的时候还是需要注意。

变量演算
和传统调试一样，erlang的debug也支持变量的验算，并且当执行层级是堆栈顶层时，调用是在debug的目标进程进行响应的，比如调用self，返回的就是我们正在调试的进程的pid。

这个逻辑会非常的有用，可能以前我们会在一个gen_server里编写一个handle_info处理入参是一个MFA，之后调试的时候通过发送消息让目标进程执行指定逻辑。这种算是后台接口，放到生产环境中会比较危险，有了debug就可以直接在运行进程中执行逻辑调用，不需要提前编写后台接口。

但是，如上面所说，当选择的执行层级不是调用栈栈顶时，erlang本身是不允许进行变量演算的，只提供当前层级的变量查看，这也可以理解，逻辑已经走到一个未来状态了，再进行一个过去状态的验算也是没有意义的。但是有时可能会有调用一些无状态的函数来格式化当前变量的需求，因此，额外提供了本地验算功能，验算逻辑是通过rpc:call目标节点完成，不能保证执行逻辑的主体是debug的进程，当时可以确保执行点是目标node，返回的结果也会做额外的标记。


带条件的断点
erlang对外只提供的了一个死板的带条件断点，int:test_at_break(Module, Line, Function), Function的定义如下

Optionally an associated condition. A condition is a tuple {Module,Name}. When the breakpoint is reached, Module:Name(Bindings) is called. If it evaluates to true, execution stops. If it evaluates to false, the breakpoint is ignored. Bindings contains the current variable bindings. To retrieve the value for a specified variable, use get_binding.

也就是必须提供一个单参函数，通过函数返回值判断是否要进入断点，入参只有当时的Bindings。因此只能在添加条件的时候动态生成代码：

会生成代码：

表达式的名字转换成atom作为函数名，然后进行逻辑验算，生成代码的路径可以在shell的启动参数里找到

最佳实践
推荐的是使用ErlangConsole来运行服务器实例，然后再使用remoteDebug来debug实例节点，IDEA的Console比起werl的功能更为强大，包括全模块提示，record提示，自动加入代码路径等。
remote即使停止了debug也不会影响原有node，而且如果测试环境和本机在同一内网，还可以实现远程debug测试节点。
现在ErlangApplication的debug也可以支持输入命令，除非调试远程节点，否则可以直接使用本地调试模式，如果是服务器运行模式，那么必须关闭

否则将在命令执行结束后直接结束调试

其他
fork的分支不光改动了debug部分， 还对case分支下的变量提示，rebar项目的导入都进行了修复，对rebar3的支持更友善。

2020-7-3更新

application run 也添加了interpret范围的选择选项，同时修复了在run结束后不停止的选项无法保存的问题。
为application run 和remote debug的远程节点都添加了命令行输入界面
新增了一个类似java的给表达式添加变量的方式，右键Context Action 触发，需要光标在一段表达式的最后
原子支持查找调用点，但是使用的时候要注意不要对类似，ok这种使用点很多的进行查找
新增了一种跳转逻辑，例如项目中有配置文件是test.config，那么代码中的data_test,和test的函数都不会告警，而且会自动跳转到配置文件（需要将配置文件所在目录标记成代码源）。但是具体的配置文件到module实现需要自己去做。
配置get的时候，如果键值是atom，那么会额外检查配置文件中是否存在，如果没有会告警。
修复了使用rebar构建的项目引入错误的问题。rebar3和rebar项目都会将除了deps库的以外其他内容都集合到一个module中，在进行application run的时候，会自动加入-pa的参数，无需手动添加，即时是rebar3的apps下有多个子项目，也都会分别加入
新增了atom提示，在单个文件内的atom在输入的时候会直接出现在提示列表里
新增了一种特殊的maps代码提示，可以在hrl中提前定义一些结构体，类似以前的record，在使用maps:get 和 #{k:=V}匹配的时候会触发提示，逻辑分为两部分
在任意hrl文件中定义一个结构体

-define(test_t, #{ ?t => test
    , k1 => 0 % 注释1
    , k2 => 0 % 注释2
    , k3 => [] % 注释3
}).

宏名必须是_t结尾，名字是t宏的值，也就是类型名，这样将来重复结构体定义的时候会有重复宏告警, 这样规定也是为了给跳转的时候，一个寻址方式。t宏是一个类似type的atom的字段值，注意尽量加上前后缀，避免其他人使用的时候重复，逻辑里的类型名就是t宏对应的字段。

类型名在缓存的时候只会保留字母并转换成小写，数字也会被抹掉，例如test_INFO_2_first会变成testinfofirst

提示逻辑的作用范围是整个project，没有做erl关联的hrl筛选（而且maps的结构也只是个假结构，不不需要关联），所以结构体类型必须全局唯一

maps:get(k1, TestInfo),
#{k1:=K} = Test

这时候类似上面的代码就会有提示，也可以直接在k1处直接跳转，也可以在选中k1的时候查看文档,这里是依赖变量名识别类型的，变量名的转换规则为截取_之前的内容，按照上面缓存类型名的时候的规则进行转换然后查找，也就是Test1, Test_X,Test1_X, T1E2sT这种都会被转换成test类型进行查找
————————————————
版权声明：本文为CSDN博主「yida_young」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/eeeggghit/article/details/106021723