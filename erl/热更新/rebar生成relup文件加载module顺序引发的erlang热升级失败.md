rebar生成relup文件加载module顺序引发的erlang热升级失败

rebar生成relup文件加载module顺序引发的erlang热升级失败
问题描述
12.19号，在对erlang应用做热升级的时候，升级失败，出错信息如下：
<pre><code>
escript: exception error: no match of right hand side value {error, {code_change_failed,<7845.1231.0>,hook_heroes_sup,
225273894003706867532273251651138786370, {'EXIT', {undef,
[{mongo_user_info,init,[],[]}, {hook_heroes_sup,init,1,
[{file,"src/hook_heroes_sup.erl"}, {line,44}]}, {supervisor,code_change,3,
[{file,"supervisor.erl"},{line,607}]}, {gen_server,system_code_change,4,
[{file,"gen_server.erl"},{line,685}]}, {sys,do_change_code,5,
[{file,"sys.erl"},{line,477}]}, {sys,do_cmd,6,[{file,"sys.erl"},{line,405}]}, {sys,handle_system_msg,8,
[{file,"sys.erl"},{line,318}]}, {proc_lib,init_p_do_apply,3,
[{file,"proc_lib.erl"},{line,239}]}]}}}}
</code></pre>

问题分析
出错信息分析
根据出错信息来看，主要是mongo_user_info的init方法没定义，而mongo_user_info的init()方法确实是这次热升级新加入的方法。

relup文件分析
查看relup文件，重点来看看和这次热升级失败有关的三个模块，这里一定要注意他们的出现的顺序。
<pre><code>
{"2.16",
[{"2.15.28",[],
[{load_object_code,{hook_heroes,"2.16",
[...,mongo_index,...,hook_heroes_sup,...,mongo_user_info,...]}},
...
{load,{mongo_index,brutal_purge,brutal_purge}},
...
{suspend,[hook_heroes_sup]},
{load,{hook_heroes_sup,brutal_purge,brutal_purge}},
{code_change,up,[{hook_heroes_sup,[]}]},
{resume,[hook_heroes_sup]},
...
{load,{mongo_user_info,brutal_purge,brutal_purge}},
...
[{"2.15.28",[],[point_of_no_return]}]}.
</code></pre>

2.15.8的hook_heroes_sup和2.16的hook_heroes_sup代码区别在于
增加了init方法中：
<pre><code>
mongo_index:init()
</code></pre>
mongo_index:init()方法实现如下：
<pre><code>
mongo_user_info:init().
</code></pre>
至此，可以从代码级别到relup文件理清楚了：mongo_index、hook_heroes_sup、mongo_user_info三个模块了，其中，hook_heroes_sup的行为模式是super_visor,是应用顶级监控树。

hook_heroes_sup依赖于mongo_index，mongo_index又依赖于mongo_user_info。
relup文件就是执行热升级顺序的文件，按照官方文档说明如下：
<pre>
The release upgrade file describes how a release is upgraded in a running system.
</pre>

分析为什么出错
看relup文件中hook_heroes_sup的操作：
<pre><code>
{suspend,[hook_heroes_sup]},
{load,{hook_heroes_sup,brutal_purge,brutal_purge}},
{code_change,up,[{hook_heroes_sup,[]}]},
{resume,[hook_heroes_sup]},
</code></pre>
首先挂起hook_heroes_sup这个进程，然后把新的hook_heroes_sup代码load进来，随后，执行supervisor的code_change方法。查阅源码
supervisor的code_change方法如下：
<pre><code>
code_change(_, State, _) ->
case (State#state.module):init(State#state.args) of
{ok, {SupFlags, StartSpec}} ->
case catch check_flags(SupFlags) of
ok ->
{Strategy, MaxIntensity, Period} = SupFlags,
update_childspec(State#state{strategy = Strategy,
intensity = MaxIntensity,
period = Period},
StartSpec);
Error ->
{error, Error}
end;
ignore ->
{ok, State};
Error ->
Error
end.
</code></pre>
看出来，当一个supervisor热升级的时候，会重新执行init()方法。那么问题来了，新的init()方法里面有mongo_index:init()代码，实际调用了mongo_user_info的init()方法，但是根据relup文件，
<pre><code>
{load,{mongo_user_info,brutal_purge,brutal_purge}},
</code></pre>
这个mongo_user_info的新代码加载，出现在新hook_heroes_sup加载的后面，自然，执行新的hook_heroes_sup的init()方法，是找不到新mongo_user_info的方法的。所以出错。
这里说明，rebar生成的relup文件，没有对这种类型的模块依赖做检查。

验证
对relup文件的模块顺序手动进行调整
{load,{mongo_user_info,brutal_purge,brutal_purge}}的代码顺序加载到{suspend,[hook_heroes_sup]}之前，再次对系统从2.15.28到2.16进行热升级。
升级结果成功
反向验证
再次把mongo_user_info调整到原来的位置，再次对对系统从2.15.28到2.16进行热升级。仍然出现文章开头的错误
正向验证和反向验证证明之前的分析是正确的。
深层次原因
从上面的分析，我们可以得到稍微抽象一点的描述，rebar生成热更新文件的顺序造成热升级失败问题：
暂且把这种依赖顺序称为"rebar-dead"依赖顺序。

新增module1,方法f1(),
f1()依赖于旧模块的module2的新方法f2()
热更新的时候，会执行module1的f1()。
这样的依赖顺序，rebar生成的relup文件就一定会报错。因为rebar生成的relup文件把新增的模块放在前面，修改的模块放在后面。

至于rebar生成relup文件的过程，和新增模块、删除模块、修改模块的顺序，后面会有详细分析。

如何避免
避免这类问题对热生级错误的方法有很多，分为代码、工具、运维三个层面

代码层面

避免在应用顶级监控supervisor的init()方法中，出现前面描述的模块依赖"rebar-dead"依赖顺序，因为这样一定会出错。
方法1:最粗暴的做法，就是永远不改变supervisor的init()方法，这样热升级永远不会执行init()方法。代码层面，需要有一个类似于sys_init的函数，来封装之后可能新加入的代码；这样上线后，需要手动执行方法。
方法2:新增module1的新方法，不要依赖旧模块的新接口；(不过这点也许绕不过)
工具层面
分为热升级文件修改和热升级运行时修改：

热升级文件修改

方法1:修改rebar源码，自己加入依赖顺序检测；有点儿类似于gc中的应用检测，导致调整.appup文件，是我们想要的顺序
热升级运行修改：

方法3:修改release_handler函数，应该可以做到，暂时还没想出来；
运维层面

每次热升级前面，一定要在内网环境先尝试；
使用release_handler:check_install_release()函数，先检测是否能热升级成功；
如果失败，人肉检测
总结：
需要正反验证问题，来证实猜想。正所谓：“大胆假设，小心求证”
关于热升级
热升级对于使用erlang构建的游戏服务端应用来说，非常重要；每一次的热升级失败，都必须排查原因。后续肯定还有没有遇到的问题，还是要仔细分析。

关于避免rebar生成有问题热更新文件的问题
工具层面代价比很高，需要深入掌握所有热升级的每一个细节；代码层面对于需求来说，也许绕不过；运层最简单，人工成本最高。需要根据项目的大小、进展以及团队的人员、技术深度来取舍。
rebar 3.0也许会解决这样的问题，期待。
这应该算是rebar工具的问题，不算是erlang系统的问题。erlang把生成app_up的文件权利给予了开发者。

作者：randyjia
链接：<a href='https://www.jianshu.com/p/b04549aae337'>https://www.jianshu.com/p/b04549aae337</a>
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。