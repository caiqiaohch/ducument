

os:cmd/1
在目标操作系统的 shell 里执行一条命令

用法：

cmd(Command) -> string()
在目标操作系统的 shell 里执行一条命令 Command，并捕捉命令执行的输出结果，最后把捕捉到的结果以字符串的形式返回

os:cmd("ls").
os:cmd("free -m").

----------
os:find_executable/1
返回一个可执行程序的绝对路径

用法：

find_executable(Name) -> Filename | false
在操作系统的环境变量 Path （可通过 os:getenv("PATH") 获取查看）的所有目录下，对给出的可执行程序名 Name 进行查找并搜索其目录路径，如果找到并且可执行，则返回其绝对目录路径。

os:find_executable(erl).
os:find_executable(Python).
程序名也可以是一个文件路径。

os:find_executable("/app/rebar").
如果给出的程序名不存在，则返回 false。

os:find_executable("/app/rebar1").
如果给出的程序名不可执行，则返回 false。

os:find_executable("/app/README").

----------
os:find_executable/2
返回一个可执行程序的绝对路径

用法：

find_executable(Name, Path) -> Filename | false
跟 os:find_executable/1 一样，都是在操作系统的环境变量 Path （可通过 os:getenv("PATH") 获取查看）的所有目录下，对给出的可执行程序名 Name 进行查找并搜索其目录路径，如果找到并且可执行，则返回其绝对目录路径。只不过 os:find_executable/2 多了一个参数 Path，作额外作为环境变量的搜索范围目录。

os:find_executable(rebar, "/app").

----------
os:getenv/0
返回一个包含所有环境变量的列表

用法：

getenv() -> [string()]
返回一个包含所有环境变量的列表。每个环境变量以 "VarName=Value" 的形式返回，VarName 是环境变量名，Value 是环境变量值。

os:getenv().

----------
os:getenv/1
获取一个环境变量的值

用法：

getenv(VarName) -> Value | false
获取环境变量 VarName 的值，如果该环境变量没有定义，则返回 false。

os:getenv("PATH").
os:getenv("PORT").
os:getenv("BUILDPACK_URL").
os:getenv("TEST").

----------
os:getpid/0
获取 erlang 虚拟机的进程标识

用法：

getpid() -> Value
返回 erlang 虚拟机的进程标识。

os:getpid().

----------
os:putenv/1
给一个环境变量设置一个新的值

用法：

putenv(VarName, Value) -> true
给一个环境变量 VarName 设置一个新的值 Value。

os:putenv("DHQME", "Http://dhq.me/").

----------
os:timestamp/0
返回一个系统的时间戳

用法：

timestamp() -> Timestamp
跟 erlang:now/0 一样，都是返回这样的 {MegaSecs, Secs, MicroSecs} 元组。 不同的是，erlang:now/0 是默认系统时间，是可靠的，启动之后不会被修改。os:timestamp/0 在系统时间改变之后，也会随之改变，就是修改服务时间对 os:timestamp/0 有效，对 erlang:now/0 无效。 而且服务器在运行的过程中，同一时间 os:timestamp/0 可能出现多次，erlang:now/0 只会出现一次。

os:timestamp().

----------
os:type/0
返回当前操作系统的家族和名称

用法：

type() -> vxworks | {Osfamily, Osname}
内部实现：

-spec type() -> {Osfamily, Osname} when
      Osfamily :: unix | win32,
      Osname :: atom().

type() ->
    erlang:system_info(os_type).
返回当前操作系统的系统家族（Osfamily）和系统名称（Osname）.

os:type().

----------
os:unsetenv/1
删除一个环境变量

用法：

unsetenv(VarName) -> true
删除一个名为 VarName 的环境变量。

os:unsetenv("TEST").
os:putenv("TEMP_ENV", "123456"),
os:unsetenv("TEMP_ENV").

----------
os:version/0
获取当前操作系统的版本号

用法：

version() -> VersionString | {Major, Minor, Release}
内部实现：

-spec version() -> VersionString | {Major, Minor, Release} when
      VersionString :: string(),
      Major :: non_neg_integer(),
      Minor :: non_neg_integer(),
      Release :: non_neg_integer().
version() ->
    erlang:system_info(os_version).
获取当前操作系统的版本号。由其实现可知道，其是调用 erlang:system_info/1 的 os_version 参数。

os:version().

----------
