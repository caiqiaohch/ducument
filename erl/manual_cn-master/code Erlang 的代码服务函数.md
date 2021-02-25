code:add_path/1
把目录加载到代码路径的末端

用法：

add_path(Dir) -> `true` | {`error`, `bad_directory`}
内部实现：

-type add_path_ret() :: 'true' | {'error', 'bad_directory'}.
-spec add_path(Dir) -> add_path_ret() when
      Dir :: file:filename().
add_path(Dir) when is_list(Dir) -> call({add_path,last,Dir}).
把目录 Dir 加载到代码路径上。目录 Dir 以最后一个目录添加到新的代码路径上。如果 Dir 已经在代码路径里，则不会添加。

如果添加成功，则返回 true，如果 Dir 不是一个目录名，则返回 {error, bad_directory}。

code:add_path("/app/otp").

----------
code:add_patha/1
把目录加载到代码路径的开头

用法：

add_patha(Dir) -> `true` | {`error`, `bad_directory`}
内部实现：

-type add_path_ret() :: 'true' | {'error', 'bad_directory'}.
-spec add_patha(Dir) -> add_path_ret() when
      Dir :: file:filename().
add_patha(Dir) when is_list(Dir) -> call({add_path,first,Dir}).
把目录 Dir 加载到代码路径的开头。如果 Dir 已经存在，那么会把代码路径上旧的位置先移除。

如果添加成功，则返回 true，如果 Dir 不是一个目录名，则返回 {error, bad_directory}。

code:add_patha("/app/otp").

----------
code:add_paths/1
把目录加载到代码路径的末端

用法：

add_paths(Dirs) -> `ok`
把目录 Dir 加载到代码路径上。目录 Dir 以最后一个目录添加到新的代码路径上。如果 Dir 已经在代码路径里，则不会添加。

这个函数总是返回 ok，不管每个目录 Dir 的有效性。

code:add_paths("/app/otp").

----------
code:add_pathsa/1
把目录加载到代码路径的开头

用法：

add_pathsa(Dirs) -> `ok`
把目录 Dir 加载到代码路径的开头。如果 Dir 已经存在，那么会把代码路径上旧的位置先移除。

这个函数总是返回 ok，不管每个目录 Dir 的有效性。

code:add_pathsa("/app/otp").

----------
code:add_pathsz/1
把目录加载到代码路径的末端

用法：

add_pathsz(Dirs) -> `ok`
把目录 Dir 加载到代码路径上。目录 Dir 以最后一个目录添加到新的代码路径上。如果 Dir 已经在代码路径里，则不会添加。

这个函数总是返回 ok，不管每个目录 Dir 的有效性。

code:add_pathsz("/app/otp").

----------
code:add_pathz/1
把目录加载到代码路径的末端

用法：

add_pathz(Dir) -> `true` | {`error`, `bad_directory`}
内部实现：

-type add_path_ret() :: 'true' | {'error', 'bad_directory'}.
-spec add_path(Dir) -> add_path_ret() when
      Dir :: file:filename().
add_pathz(Dir) when is_list(Dir) -> call({add_path,last,Dir}).
把目录 Dir 加载到代码路径上。目录 Dir 以最后一个目录添加到新的代码路径上。如果 Dir 已经在代码路径里，则不会添加。

如果添加成功，则返回 true，如果 Dir 不是一个目录名，则返回 {error, bad_directory}。

code:add_pathz("/app/otp").

----------
code:all_loaded/0
获取所有已经加载的模块

用法：

all_loaded() -> [{Module, Loaded}]
返回一个以 {Module, Loaded} 元组的形式、包含所有已经加载模块的列表，Loaded 是一个文件的绝对路径。

code:all_loaded().

----------
code:clash/0
查找命名冲突的模块

用法：

clash() -> ok
内部实现：

%% Search the entire path system looking for name clashes

-spec clash() -> 'ok'.

clash() ->
    Path = get_path(),
    Struct = lists:flatten(build(Path)),
    Len = length(search(Struct)),
    io:format("** Found ~w name clashes in code paths ~n", [Len]).
在整个路径系统下查找名字冲突的模块并输出一个检查报告。

code:clash().

----------

code:compiler_dir/0
获取编译器的库文件目录

用法：

compiler_dir() -> file:filename()
获取编译器的库文件目录，其效用跟 code:lib_dir(compiler) 一样。

code:compiler_dir().

----------
code:del_path/1
从代码路径上删除一个目录

用法：

del_path(NameOrDir) -> boolean() | {`error`, What}
从代码路径上删除一个目录。参数可以是一个原子（在这种情况下，目录的名字是一个 Vsn 或 ebin 名）。参数也可以是一个绝对的路径名。

如果删除成功，则返回 true；如果目录不存在，则返回 false；如果参数不合法，则返回 {error, bad_name}。

code:del_path("/app/test").

----------
code:delete/1
删除模块的当前代码

用法：

delete(Module) -> boolean()
删除模块的当前代码（把模块的当前代码标记为旧版本）。这意味着进程可以继续执行模块里的代码，但是没有外部函数可以调用。

如果操作成功，则返回 true；如果模块的旧代码必须先清除，或模块 Module 没有被加载，则返回 false。

code:delete(genfsm).

----------
code:get_object_code/1
获取模块的目标 BEAM 代码

用法：

get_object_code(Module) -> {Module, Binary, Filename} | error
在代码路径下查找模块 Module 的目标代码，如果找到，则返回 {Module, Binary, Filename}，否则返回 error。

Module 是模块名。

Binary 是一个包含着模块 Module 目标代码的二进制数据对象，这些二进制数据可以加载到一个分布系统的远程节点上。

Filename 是模块的文件信息。

{ok, Module} = application:get_application(),
code:get_object_code(Module).
如果找不到，否则返回 error。

code:get_object_code(genfsm).

----------
code:get_path/0
获取代码服务器当前搜索加载代码的路径

用法：

get_path() -> Path
获取代码服务器当前搜索加载代码的路径。

code:get_path().

----------
code:is_loaded/1
检测模块是否已经加载

用法：

is_loaded(Module) -> {file, Loaded} | false
检测模块 Mudule 是否已经加载，如果是，则返回 {file, Loaded}，否则返回 false。

正常情况下，Loaded 是被加载代码的绝对文件名。如果模块是预加载的，则 Loaded 是 preloaded。如果模块是有 Cover 编译的，则 Loaded 是 cover_compiled。

code:is_loaded(genfsm).
code:is_loaded(code).
code:is_loaded(erlang).
mochiglobal:put(test_mochiglobal, "test_mochiglobal"),
code:is_loaded('mochiglobal:test_mochiglobal').
mochiglobal:put(test_mochiglobal, "test_mochiglobal"),
mochiglobal:get(test_mochiglobal),
mochiglobal:delete(test_mochiglobal),
code:is_loaded('mochiglobal:test_mochiglobal').

----------
code:is_module_native/1
检测模块是有有原生代码

用法：

is_module_native(Module) -> boolean() | undefined
如果一个已经加载的模块 Module 里有原生代码加载，那么该函数返回 true，如果模块已经加载，不过没有原生代码，则返回 false。如果模块没有加载，那么函数则返回 undefined。

code:is_module_native(erlang).

----------
code:is_sticky/1
检测模块是否是一个黏附（sticky）模块

用法：

is_sticky(Module) -> boolean()
如果模块 Mudule 是从 sticky 目录里（kernel、stdlib、compiler 这三个文件夹被标记为 sticky 目录）加载的，那么函数返回 true，如果模块没有被加载或是不是从 sticky 目录里加载，则返回 false。

code:is_sticky(genfsm).
code:is_sticky(erlang).
code:is_sticky(file).

----------
code:lib_dir/0
获取 Erlang/OTP 的库文件目录

用法：

lib_dir() -> file:filename()
返回 Erlang/OTP 的库文件目录。

code:lib_dir().

----------
code:lib_dir/1
一个应用的库目录

用法：

lib_dir(Name) -> file:filename() | {`error`, `bad_name`}
这个函数主要用于查找库目录的路径，例如一个名为 Name 且放在 $OTPROOT/lib 目录下的应用的根目录，或是引自于 ERL_LIBS 环境变量下的一个目录。

code:lib_dir(compiler).
如果一个名为 Name 的应用不是放在 $OTPROOT/lib 目录下，或在 ERL_LIBS 环境变量的引用目录里，那么将返回 {error, bad_name}。如果 Name 是一个不合法的名字则会抛出一个错误。

code:lib_dir(not_a_application_name).

----------
code:load_binary/3
加载一个模块的目标代码

用法：

load_binary(Module, Filename, Binary) -> {module, Module} | {error, What}
这个函数可以用来加载远程 Erlang 节点的目标 beam 代码。参数 Binary 必须是模块 Module 的目标 beam 代码。Filename 只能用远程代码服务器上模块 Module 的文件路径。相应地，Filename 是不会被代码服务器打开或读取。

如果加载成功，则返回 {module, Module}；如果代码是放在一个 sticky 的目录里，则返回 {error, sticky_directory} 的错误；如果参数不合法，则返回 {error, badarg}；如果加载失败，则会返回一个元组形式的错误。更多错误值介绍可查看 erlang:load_module/2 的相关描述。

{ok, Module} = application:get_application(),
case code:get_object_code(Module) of
    {_Module, Binary, Filename} ->
        code:load_binary(Module, Filename, Binary);
    _ ->
        ok
end.

----------
code:load_file/1
加载一个模块

用法：

load_file(Module) -> {module, Module} | {error, What}
加载代码路径下的 Erlang 模块 Module。它以 Erlang 虚拟机使用的模块扩展名来查找目标代码文件，例如：Module.beam。如果目标代码里的模块名不名为 Module，则模块加载失败。code:load_binary/3 加载目标代码所必须得模块名跟文件名不一样。

如果加载成功，则返回 {module, Module}；如果找不到目标代码，则返回 {error, nofile}；如果代码是放在一个 sticky 的目录里，则返回 {error, sticky_directory} 的错误；如果加载失败，则会返回一个元组形式的错误。更多错误值介绍可查看 erlang:load_module/2 的相关描述

{ok, Module} = application:get_application(),
code:load_file(Module).

----------
code:priv_dir/1
返回一个应用 priv 目录路径

用法：

priv_dir(Name) -> string() | {error, bad_name}
返回一个应用的 priv 目录路径。其用法跟 code:lib_dir(Name, priv) 一样。

code:priv_dir(webmachine).
如果该应用没用 priv 目录，则返回一个 {error, bad_name} 的错误。

code:priv_dir(genfsm).

----------
code:purge/1
清除一个模块的旧代码

用法：

purge(Module) -> boolean()
清除模块 Module 的代码，即清除标记为旧版本的代码。如果一些旧代码仍然有进程在执行使用，在代码清除之前，这些进程将会被杀掉。

如果操作成功（任何进程将会被清掉）则返回 true，否则返回 false。

{ok, Module} = application:get_application(),
code:purge(Module).

----------
code:rehash/0
创建或重新刷新代码路径缓存

用法：

rehash() -> `ok`
内部实现：

-spec rehash() -> 'ok'.
rehash() -> call(rehash).
创建或重新刷新代码路径缓存。

code:rehash().

----------
code:replace_path/2
替换代码路径里的某一个目录

用法：

replace_path(Name, Dir) -> true | {error, What}
这个函数把在代码路径上出现名为 Name（Name 是一个版本 Vsn 或是一个 ebin 名） 的目录替换为 Dir。如果 Name 不存在，那么将把 Dir 添加到代码目录的末端。新的目录名也必须也命名为 Name。如果一个目录的新版本被添加到运行系统时，这个将被用到。

如果替换成功，则返回 true；如果 Name 找不到，则返回 {error, bad_name}；如果 Dir 不存在，则返回 {error, bad_directory}；如果 Name 或 Dir 不合法，则返回 {error, {badarg, [Name, Dir]}}。

code:replace_path(3, "").
code:replace_path(kernel, "/app/otp").

----------
code:root_dir/0
返回 Erlang/OTP 安装的根目录

用法：

root_dir() -> string()
返回 Erlang/OTP 安装的根目录。

code:root_dir().

----------
code:set_path/1
设置代码服务的搜索路径

用法：

set_path(Path) -> true | {error, What}
把目录 Path 列表设置到代码服务搜索路径。

如果成功则返回 true；如果 Path 里的目录路径不是一个正常目录，则返回 {error, bad_directory}；或者如果 Path 是非法参数，则返回 {error, bad_path}。

code:set_path(["/app/src/", "/app/priv/"]).

----------
code:soft_purge/1
移除一个模块的旧代码

用法：

soft_purge(Module) -> boolean()
如果没有进程使用模块 Module 的旧代码，则清除该模块被标记为旧版本的代码。

如果有进程在使用该模块的旧代码，则模块旧代码清除失败而返回 false，否则返回 true。

{ok, Module} = application:get_application(),
code:soft_purge(Module).
其跟 code:purge/1 差不多，都是清除模块被标记为旧版本的代码。不同的是，如果有进程在使用该模块的旧代码，code:purge/1 会先杀死执行进程，再执行清除操作。

----------
code:where_is_file/1
返回在代码目录上一个文件的完整路径名

用法：

where_is_file(Filename) -> non_existing | Absname
在代码目录上搜索文件名为 Filename 的文件（可以是任意类型的文件）。如果找到，则返回文件的完整路径名，否则返回 non_existing。

code:where_is_file("genfsm.beam").

----------
code:which/1
获取一个模块的目标代码的文件位置

用法：

which(Module) -> Which
如果模块没有被加载，这个函数将在代码路径下搜索包含模块 Mudole 目标代码的第一个文件，并返回文件的觉得路径；

如果模块已经加载，它将返回包含已经加载目标代码的文件的名字；

如果模块是预加载（pre-loaded），则返回 preloaded。

如果模块是 Cover 编译的，则返回 cover_compiled。

如果模块找不到，则返回 non_existing。

{ok, Module} = application:get_application(),
code:which(Module).

----------
