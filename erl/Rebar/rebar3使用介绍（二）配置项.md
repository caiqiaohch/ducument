# rebar3使用介绍（二）配置项

![img](https://csdnimg.cn/release/blogv2/dist/pc/img/translate.png)

[yida_young](https://blog.csdn.net/eeeggghit) 2018-11-12 16:56:33 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/articleReadEyes.png) 2777 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarCollect.png) 收藏 4

分类专栏： [erlang](https://blog.csdn.net/eeeggghit/category_8265955.html) 文章标签： [rebar3](https://www.csdn.net/tags/MtjaUg3sNTMzNzYtYmxvZwO0O0OO0O0O.html)

[![img](https://img-blog.csdnimg.cn/20201014180756780.png?x-oss-process=image/resize,m_fixed,h_64,w_64)erlang](https://blog.csdn.net/eeeggghit/category_8265955.html)专栏收录该内容

17 篇文章2 订阅

订阅专栏



### rebar3使用介绍（二）

- [全局配置](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#_3)
- [Alias 别名](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#Alias__17)
- [Artifacts](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#Artifacts_24)
- [Compilation](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#Compilation_53)
- [测试选项](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#_99)
- [Cover](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#Cover_107)
- [Dialyzer](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#Dialyzer_110)
- [Distribution](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#Distribution_116)
- [Directories 目录](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#Directories__125)
- [EDoc](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#EDoc_150)
- [Escript](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#Escript_153)
- [EUnit](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#EUnit_156)
- [最小OTP版本检查](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#OTP_164)
- [Overrides](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#Overrides_169)
- [Hook 钩子](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#Hook__184)
- - [shell钩子](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#shell_186)
  - [功能钩子](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#_201)
  - [自写功能中可以hook的点](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#hook_211)
- [RELX](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#RELX_238)
- [SHELL](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#SHELL_241)
- [XRef](https://blog.csdn.net/eeeggghit/article/details/83781530?utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#XRef_251)


本篇主要介绍rebar3的配置部分

# 全局配置

rebar3支持全局配置，这也配置生效于环境中的所有rebar3，配置在操作系统的环境变量中，有以下内容：

> REBAR_PROFILE=“term” # force a base profile
> HEX_CDN=“https://…” # change the Hex endpoint for a private one
> REBAR_CONFIG=“rebar3.config” # changes the name of rebar.config files
> QUIET=1 # only display errors
> DEBUG=1 # show debug output
> \# “QUIET=1 DEBUG=1” displays both errors and warnings
> REBAR_COLOR=“low” # reduces amount of color in output if supported
> REBAR_CACHE_DIR # override where rebar3 stores config and cache data
> http_proxy # standard proxy ENV variable is respected
> https_proxy # standard proxy ENV variable is respected

# Alias 别名

别名允许你根据现有命令，创造一个新的命令出来，当然他们必须有固定的执行顺序才行，比如

```erlang
{alias, [{check, [eunit, {ct, "--sys_config=config/app.config"}]}]}.
1
```

配置中的元素可以是check这种单个atom代表一个动作，也可以是 {ct, “–sys_config=config/app.config”} 这种代表一个带参的动作，执行顺序永远是从左到右串行执行。

# Artifacts

Artifacts可以理解成一个项目编译完成后的资源的集合体，这在你的项目中有非erlang的模块时会非常实用，比如你用C编写了共享库，将它的产出文件配置进去，就可以判断编译是否成功。
如果发现已经构建了一个依赖项（意味着它的.app文件的模块列表与其.beam文件匹配）那么在随后的rebar3调用中就都不会编译这部分，也就不会触发这部分的hook。

相对路径于取决于它是否在伞状项目的顶层定义。例如，假设我们有一个项目my_project包含应用程序my_app在apps/my_app/下，my_app会创建一个escript。在rebar3不要在意配置在my_project/rebar.config中，因为它是整个项目的顶级rebar.config。该artifact会相对profile_dir，默认情况下是_build/default/：

```erlang
{artifacts, ["bin/rebar3"]}.
1
```

像上面我们检查的就是 _build/default/bin/rebar3
如果不是在顶层，比如my_app有自己的rebar.config,那么定义在这个rebar.config中的相对目录就是_build/default/lib/my_app/ 而不是 _build/default，因为rebar的伞状构建特性，必须要确保子项目能自己完成自己的检查，这样的设定也是合理的

相反的如果项目不是伞状项目，即使my_app是在顶层，rebar.config在根目录下，Artifacts项的相对目录也是_build/default/lib/my_app/

rebar3提供了几个宏来扩展相对目录如下：

| Key         | 描述                                                         |
| ----------- | ------------------------------------------------------------ |
| profile_dir | The base output directory with the profile string appended, default: `_build/default/`. |
| base_dir    | The base output directory, default: `_build`.                |
| out_dir     | The application’s output directory, default:`_build/default/lib//`. |

再举一个实例，eleveldb

```erlang
{overrides,
 [{override, eleveldb, [{artifacts, ["priv/eleveldb.so"]},
                        ...
                       ]
  }]}.
12345
```

因为这个是eleveldb自己的rebar.config，所以`"priv/eleveldb.so"` 就相当于`"{{out_dir}}priv/eleveldb.so"`

# Compilation

编译选项定义在erl_opts字段下，具体可使用的字段和值参照[erlang的编译选项](http://erlang.org/doc/man/compile.html)

```erlang
{erl_opts, [
  debug_info,
  {parse_transform, lager_transform},
  warn_export_all,
  warn_unused_import,
  {i, "include"},
  {src_dirs, ["src"]}]}.
1234567
```

除此之外，还可以设置特定于平台的选项。

```erlang
 {erl_opts, [{platform_define,
               "(linux|solaris|freebsd|darwin)",
               'HAVE_SENDFILE'},
              {platform_define, "(linux|freebsd)",
                'BACKLOG', 128},
              {platform_define, "R13",
                'old_inets'}]
}.
12345678
```

这里支持匹配例如

```erlang
{platform_define, "^((?!R1[456]).)*$", 'maps_support'}
1
```

一个单独的编译选项是声明模块在所有其他模块之前编译的选项：

```erlang
{erl_first_files, ["src/lager_util.erl"]}.
1
```

还有一些额外的单独编译选项

```erlang
{validate_app_modules, true}. % Make sure modules in .app match those found in code
{app_vars_file, undefined | Path}. % file containing elements to put in all generated app files
%% Paths the compiler outputs when reporting warnings or errors
%% relative (default), build (all paths are in _build, default prior
%% to 3.2.0, and absolute are valid options
{compiler_source_format, relative}.
123456
```

其他与Erlang相关的编译器支持自己的配置选项：

- Leex编译器与{xrl_opts, […]}
- SNMP MIB编译器与{mib_opts, […]}
- Yecc编译器与{yrl_opts, […]}

# 测试选项

```erlang
{ct_first_files, [...]}. % {erl_first_files, ...} but for CT
{ct_opts, [...]}. % same as options for ct:run_test(...)
{ct_readable, true | false}. % disable rebar3 modifying CT output in the shell
123
```

ct_opts支持的字段可以在[这里](http://www.erlang.org/doc/man/ct.html#run_test-1)找到

# Cover

具体看[这](http://www.rebar3.org/docs/running-tests)

# Dialyzer

```erlang
{dialyzer, [Opts]}
1
```

支持选项看[这](http://erlang.org/doc/man/dialyzer.html)

# Distribution

多个功能和插件可能需要支持分布式Erlang。通常，所有此类命令（例如ct和shell）的配置都遵循以下配置值：

```erlang
{dist_node, [
    {setcookie, 'atom-cookie'},
    {name | sname, 'nodename'},
]}.
1234
```

# Directories 目录

可支持选项和默认值如下:

```erlang
%% directory for artifacts produced by rebar3
{base_dir, "_build"}.
%% directory in '<base_dir>/<profile>/' where deps go
{deps_dir, "lib"}.
%% where rebar3 operates from; defaults to the current working directory
{root_dir, "."}.
%% where checkout dependencies are to be located
{checkouts_dir, "_checkouts"}.
%% directory in '<base_dir>/<profile>/' where plugins go
{plugins_dir, "plugins"}.
%% directories where OTP applications for the project can be located
{project_app_dirs, ["apps/*", "lib/*", "."]}.
%% Directories where source files for an OTP application can be found
{src_dirs, ["src"]}.
%% Paths to miscellaneous Erlang files to compile for an app
%% without including them in its modules list
{extra_src_dirs, []}. 
%% Paths the compiler outputs when reporting warnings or errors
%% relative (default), build (all paths are in _build, default prior
%% to 3.2.0, and absolute are valid options
{compiler_source_format, relative}.
123456789101112131415161718192021
```

# EDoc

配置项看[这里](http://www.erlang.org/doc/man/edoc.html#run-3)

# Escript

[参看](http://www.rebar3.org/v3/docs/commands#escriptizehttps://note.youdao.com/)

# EUnit

```erlang
{eunit_first_files, [...]}. % {erl_first_files, ...} but for CT
{eunit_opts, [...]}. % same as options for eunit:test(Tests, ...)
{eunit_tests, [...]}. % same as Tests argument in eunit:test(Tests, ...)
123
```

[opts选项参看这里](http://www.erlang.org/doc/man/eunit.html#test-2)

# 最小OTP版本检查

```erlang
{minimum_otp_vsn, "17.4"}.
1
```

# Overrides

覆盖是出于自己的项目需要对依赖项目作出改动，但是这个改动又不想套用到库上，所以选作上层覆盖，Overrides支持add, override, del操作

```erlang
{overrides, [{add, app_name(), [{atom(), any()}]},
             {del, app_name(), [{atom(), any()}]},
             {override, app_name(), [{atom(), any()}]},
             {add, [{atom(), any()}]},
             {del, [{atom(), any()}]},
             {override, [{atom(), any()}]}]}.
123456
```

app_name有的时候只会对指定app进行操作，如果没有指定，则会对所有app进行指定

这个特性允许你在不修改库的前提下，强制同意一些编译配置之类，或者针对自己的项目或者平台进行扩展

# Hook 钩子

有两种类型的钩子：shell钩子和功能钩子

## shell钩子

```erlang
{pre_hooks, [{clean, "./prepare_package_files.sh"},
             {"linux", compile, "c_src/build_linux.sh"},
             {compile, "escript generate_headers"},
             {compile, "escript check_headers"}]}.

{post_hooks, [{clean, "touch file1.out"},
              {"freebsd", compile, "c_src/freebsd_tweaks.sh"},
              {eunit, "touch file2.out"},
              {compile, "touch postcompile.out"}]}.
123456789
```

如果命令内容比较复杂，最好还是用脚本包装起来后调用脚本，而不是在配置里写一大推
post_hooks 在调用失败的情况下是不会调用的，比如clean操作本身失败了，那么post_hooks指定的动作也就不会执行

## 功能钩子

功能钩子，一般指的是通过用插件扩展的功能，不止局限于rebar本身提供的功能
以下钩子在运行clean之前compile运行。

```erlang
{provider_hooks, [{pre, [{compile, clean}]}
                  {post, [{compile, {erlydtl, compile}}]}]}
12
```

不需要参数就只需要填写命令的atom，如果需要用tuple带入
功能钩子都是在shell钩子之前执行的

## 自写功能中可以hook的点

只有部分功能支持附着钩子，

| Hook         | before and after                                          |
| ------------ | --------------------------------------------------------- |
| clean        | 每个应用程序和依赖项，和/或编译所有顶级应用程序之前和之后 |
| compile      | 每个应用程序和依赖项，和/或编译所有顶级应用程序之前和之后 |
| erlc_compile | 编译应用程序的梁文件                                      |
| app_compile  | 从.app.src为应用程序构建.app文件                          |
| ct           | 整个运行前后                                              |
| edoc         | 整个运行前后                                              |
| escriptize   | 整个运行前后                                              |
| eunit        | 整个运行前后                                              |
| release      | 整个运行前后                                              |
| tar          | 整个运行前后                                              |

*默认情况下，这些钩子为每个应用程序运行，因为依赖项可以在它们自己的上下文中指定它们自己的钩子。区别在于，在某些情况下（伞形应用程序），钩子可以在许多级别上定义（省略覆盖）：

- 应用程序根目录下的rebar.config文件
- 每个顶级应用程序（在apps/或中libs/）rebar.config
- 每个依赖项的rebar.config

默认情况下，当没有伞形应用程序时，顶级rebar.config中定义的钩子将被归为顶级应用程序的一部分。这允许钩子在以后发布库时继续为依赖项工作。

但是，如果钩子是在具有伞形应用程序的项目的根目录下的rebar.config中定义的，则钩子将在任务运行之前/之后为所有顶级应用程序运行。

要保留伞状项目中的每个应用程序行为，必须在每个应用程序的rebar.config中定义钩子。

# RELX

[看这里](http://www.rebar3.org/docs/releases)

# SHELL

rebar3 shell如果relx找到条目，REPL将自动启动应用程序，但可以使用显式指定由shell启动的应用程序{shell, [{apps, [App]}]}。

以下为扩展配置：

| Option      | Value                    | Description                         |
| ----------- | ------------------------ | ----------------------------------- |
| apps        | [app1, app2, …]          | 要启动的app列表，追加在relx的配置后 |
| config      | “path/to/a/file.config”  | 加载指定配置                        |
| script_file | “path/to/a/file.escript” | 执行自定义脚本                      |

# XRef

```erlang
{xref_warnings,false}.
{xref_extra_paths,[]}.
{xref_checks,[undefined_function_calls,undefined_functions,locals_not_used,
              exports_not_used,deprecated_function_calls,
              deprecated_functions]}.
{xref_queries,[{"(xc - uc) || (xu - x - b - (\"mod\":\".*foo\"/\"4\"))", []}]}.
{xref_ignores, [{M, F}, {M, F, A}]}.
1234567
```


 