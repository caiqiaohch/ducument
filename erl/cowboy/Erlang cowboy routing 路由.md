# Erlang cowboy routing 路由

# 

本文译自：

http://ninenines.eu/docs/en/cowboy/1.0/guide/routing/

## Routing

默认情况下，Cowboy 什么都不做。

所谓路由(routing)，就是把URL请求映射到Erlang处理模块。一旦Cowboy收到一个请求，它会按指定的规则匹配请求的host和path，如果匹配成功，关联的模块代码就被执行。路由规则按每个host指定，Cowboy首先匹配host，然后匹配path，...

路由表在使用前需要先编译。

## Structure

路由表的结构如下：



```ini
Routes = [Host1, Host2, ... HostN].
```



表中的每一项是一个host，host包含路径列表(pathlist)，host的结构如下：



```ini
Host1 = {HostMatch, PathsList}.
Host2 = {HostMatch, Constraints, PathsList}.
```

类似的，pathlist的结构如下：





```ini
PathsList = [Path1, Path2, ... PathN].
```

每个path包含可选的匹配条件，处理器，和选项，定义如下：





```ini
Path1 = {PathMatch, Handler, Opts}.
Path2 = {PathMatch, Constraints, Handler, Opts}.
```

下面看看可选的匹配条件的语法match syntax。



## Match syntax

匹配语法用于关联路径到各自的处理模块handler。

匹配语法同样适用于host和path，差别不大。实际上，段的分隔符不同，host从最后一个段向第一个段匹配。下面在遇到的时候会详细说明host和path的匹配不同之处。

除了本节最后我会说明的一些特殊情况，最简单的匹配值就是host和path，通过`string()` 或 `binary()指定。`

```ini
PathMatch1 = "/".
PathMatch2 = "/path/to/resource".

HostMatch1 = "cowboy.example.org".
```

可见，所有的路径都是以斜杠"/"开头。下面2种写法是等效的：



```ini
PathMatch2 = "/path/to/resource".
PathMatch3 = "/path/to/resource/".
```



Host结尾和开头有没有一个点"."都可以，下面3个都是等价的：



```ini
HostMatch1 = "cowboy.example.org".
HostMatch2 = "cowboy.example.org.".
HostMatch3 = ".cowboy.example.org".
```

从host和path中提取的段值会保存在Req对象里以待后用。我们称其为绑定(从URL提取段值存储于指定变量的过程)。

绑定的语法很简单。以冒号":"开头的名称都是绑定变量名，值就是段：

```ini
PathMatch = "/hats/:name/prices".
HostMatch = ":subdomain.example.org".
```

对于上面的例子，URL` http://test.example.org/hats/wild_cowboy_legendary/prices` 绑定之后得到的变量是：

```
subdomain`=`test
name=wild_cowboy_legendary
```

变量`subdomain和name随后用``cowboy_req:binding/{2,3}`函数取得，绑定的变量名必须是atom类型。


一种特殊的绑定变量名是冒号加下划线":_"。匹配的段值会忽略。这种方式在匹配多域名时很有用。



```html
HostMatch = "ninenines.:_".
```

还可以匹配可选的段。方括号内的都是可选的匹配。



```ini
PathMatch = "/hats/[page/:number]".
HostMatch = "[www.]ninenines.eu".
```

还可以嵌套：



```ini
PathMatch = "/hats/[page/[:number]]".
```



还可以用[...]匹配host和path其余的部分。在host中匹配前面的部分，在path中匹配后面的部分。匹配的结果可以有0,1或多个段。用`cowboy_req:host_info/1`和`cowboy_req:path_info/1`分布取得这些段值，以列表形式返回。



```ini
PathMatch = "/hats/[...]".
HostMatch = "[...]ninenines.eu".
```



如果同一个绑定变量名出现2次，只有当它们的值一致时，匹配才算成功。这源自于Erlang模式匹配的方式。



```html
PathMatch = "/hats/:name/:name".
```





当相同变量出现在可选段的匹配中，只有当可选的段存在，并且2个值一致时：

This is also true when an optional segment is present. In this case the two values must be identical only if the segment is available.



```ini
PathMatch = "/hats/:name/[:name]".
```

如果一个绑定变量在host和path中都存在，那么他们的值必须一致才算成功：





```ini
PathMatch = "/:user/[...]".
HostMatch = ":user.github.com".
```

最后是2个特殊匹配。原子'_'用于匹配任何host和path。





```ini
PathMatch = '_'.
HostMatch = '_'.
```


host的匹配"*"匹配通配符path，通常与OPTIONS方法一起使用。



```ini
HostMatch = "*".
```



## Constraints

当匹配结束，绑定的结果就要经过一组条件测试。条件测试仅当绑定被定义。运行的次序就是你定义他们的次序。匹配最终成功仅当满足所有条件。

条件是2个或3个元素的元组形式，第一个元素是绑定的变量名称，第二个元素是条件名称，第三个元素是可选的参数，存放条件的参数。下面条件的定义：



- {Name, int}
- {Name, function, fun ((Value) -> true | {true, NewValue} | false)}

int 条件会检查绑定变量Name存放的值是一个整数字串(Name="123")，如果是，转换值到整数(Name=123)。

`function条件传递绑定的值到一个用户定义的函数，` 它会取得这个绑定的变量的值作为它的唯一参数，并且必须返回是否满足条件。也可以在函数中修改这个值，因此这个值可以返回任何类型。

注意，条件函数应该是简单不能出错：**Note that constraint functions SHOULD be pure and MUST NOT crash.**

## Compilation

本章定义的结构在传递给Cowboy使用前需要编译。这样会提高速度。编译使用：

`cowboy_router:compile/1`.



```groovy
Dispatch = cowboy_router:compile([
    %% {HostMatch, list({PathMatch, Handler, Opts})}
    {'_', [{'_', my_handler, []}]}
]),
%% Name, NbAcceptors, TransOpts, ProtoOpts
cowboy:start_http(my_http_listener, 100,
    [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}]
).
```

如果给定的结构不正确，函数会返回 `{error, badarg}`



## 动态替换

使用 `cowboy:set_env/3` 函数更新路由策略。所有新的连接在新策略上打开：



```properties
cowboy:set_env(my_http_listener, dispatch,
    cowboy_router:compile(Dispatch)).
```

注意到，我们在调用set_env更新路由之前先编译了路由：cowboy_router:compile(Dispatch)。