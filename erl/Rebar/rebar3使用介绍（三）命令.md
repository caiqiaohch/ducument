# rebar3使用介绍（三）命令

![img](https://csdnimg.cn/release/blogv2/dist/pc/img/translate.png)

[yida_young](https://blog.csdn.net/eeeggghit) 2018-11-12 16:57:02 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/articleReadEyes.png) 2295 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarCollect.png) 收藏 3

分类专栏： [erlang](https://blog.csdn.net/eeeggghit/category_8265955.html) 文章标签： [rebar3](https://www.csdn.net/tags/MtjaUg3sNTMzNzYtYmxvZwO0O0OO0O0O.html)

[![img](https://img-blog.csdnimg.cn/20201014180756780.png?x-oss-process=image/resize,m_fixed,h_64,w_64)erlang](https://blog.csdn.net/eeeggghit/category_8265955.html)专栏收录该内容

17 篇文章2 订阅

订阅专栏



### rebar3使用介绍（三）

- [as](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#as_3)
- [compile](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#compile_37)
- [clean](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#clean_40)
- [ct](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#ct_49)
- [cover](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#cover_54)
- [deps](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#deps_72)
- [do](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#do_75)
- [dialyzer](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#dialyzer_78)
- [edoc](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#edoc_104)
- [escriptize](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#escriptize_107)
- [eunit](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#eunit_125)
- [get-deps](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#getdeps_136)
- [help](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#help_139)
- [new](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#new_142)
- [path](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#path_147)
- [pkgs](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#pkgs_163)
- [release](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#release_166)
- [relup](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#relup_169)
- [report](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#report_172)
- [shell](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#shell_175)
- [tar](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#tar_189)
- [tree](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#tree_192)
- [lock](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#lock_195)
- [unlock](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#unlock_198)
- [update](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#update_205)
- [upgrade](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#upgrade_208)
- [version](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#version_213)
- [xref](https://blog.csdn.net/eeeggghit/article/details/83826105?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#xref_220)


本篇主要介绍rebar3的命令

# as

它使配置文件名称和任务列表在该配置文件下运行.
举个例子，你可以配置dev模式和relese模式下不同的配置，然后rebar3 as dev release 就可以按照dev模式发布，同样可以用release发布

rebar.config

```erlang
{profiles, [
    {dev, [
        {plugins, [
            {rebar3_gpb_plugin, "2.3.2"}
        ]},
        {provider_hooks, [
            {pre, [
                {compile, {protobuf, compile}},
                {clean, {protobuf, clean}}
            ]}
        ]}
    ]},
    {test, [
        {erl_opts, [nowarn_export_all]},
        {ct_opts, [{create_priv_dir, auto_per_tc},
                   {config, "test/ct.config"}]},
        {plugins, [
            rebar3_proper
        ]},
        {deps, [
            {proper, {git, "git://github.com/proper-testing/proper", {tag, "v1.3"}}}
        ]},
        {extra_src_dirs, ["test/support"]}
    ]}
]}.
12345678910111213141516171819202122232425
```

根据profiles字段的值,可以自定义自己的发布模板

# compile

rebar3的编译命令会自己确保依赖到位，不像rebar需要自己get-deps,除了deps部分其他和rebar一致，编译erl，app.src

# clean

rebar3 clean 默认只会清理主app下的文件，clean也支持as，rebar3 as test clean 将只会清除test模式下的文件
如果想要清除deps的文件，加上 --all即可

| Option      | Type   | Description                       |
| ----------- | ------ | --------------------------------- |
| –all/-a     | none   | 清除所有app，包括依赖项的构建文件 |
| –profile/-p | string | 等价于rebar3 as clean             |

# ct

ct命令将会执行test/目录下的测试用例
ct命令和erlang的是基本一致的，支持的扩展参数可以看[这](http://erlang.org/doc/man/ct_run.html)
注意rebar 加参数用的是 – erlang用的-

# cover

cover 一般配合ct或者eunit来用，`rebar3 do ct, cover`, `rebar3 do eunit, cover` 或者 `rebar3 do eunit, ct, cover`

cover 是否开启配置在rebar.config中的cover_enabled字段，默认是false

```erlang
%% Whether to enable coverage reporting where commands support cover. Default
%% is `false'
{cover_enabled, false}.
123
```

cover 命令支持以下扩展参数：

| Option        | Description              |
| ------------- | ------------------------ |
| –reset/-r     | 重置所有数据             |
| –verbose / -v | 在终端中打印覆盖率分析。 |

通过添加`{cover_excl_mods,[Modules]}`到配置文件，可以从代码覆盖中将特定模块列入黑名单。通过添加`{cover_excl_apps, [AppNames]}`到配置文件，可以将特定应用程序列入黑名单。

# deps

列出依赖项，无论它们是源依赖项还是程序包依赖项，以及它们是否已锁定。锁定但未与锁定文件匹配的那些后跟星号（*）

# do

do 允许你串行执行多个命令，以逗号分隔。例：rebar3 do a, b, c

# dialyzer

构建并保持最新的合适PLT，并使用它来对当前项目进行成功的类型分析。

| Option           | Description                    |
| ---------------- | ------------------------------ |
| –update-PLT / -u | 启用更新PLT。默认值：true      |
| –succ-typings/-s | 启用成功键入分析。默认值：true |

有关抑制告警的说明，请参阅Dialyzer文档中的[Requesting or Suppressing Warnings in Source Files](http://erlang.org/doc/man/dialyzer.html)部分。

PLT文件被命名_<otp_release>_plt; 基础PLT是PLT，包含项目PLT通常需要的核心应用程序。每个OTP版本创建一个基本PLT并存储在其中base_plt_location。然后使用基础PLT来构建项目PLT。

可以将以下（可选）配置添加到rebar.config中的选项dialyzer中：

| Option            | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| warnings          | 透析器警告列表                                               |
| get_warnings      | 更改PLT文件时显示警告（布尔值）                              |
| plt_apps          | 用于确定哪些包含在PLT文件的应用程序的策略，top_level_deps以仅包括直接依赖或all_deps包括所有嵌套的依赖（直接依赖的应用程序中列出applications和included_applications他们的.app文件。） |
| plt_extra_apps    | 要包含在PLT文件中的应用程序base_plt_apps列表（将在列表中的应用程序） |
| plt_location      | PLT文件的位置，local存储在配置文件的基本目录（默认）或自定义目录中。 |
| plt_prefix        | PLT文件的前缀，默认为“rebar3”                                |
| base_plt_apps     | 要包含在基本PLT文件中的应用程序列表                          |
| base_plt_location | 基本PLT文件的位置，global存储在$ HOME / .cache / rebar3（默认）或自定义目录中 |
| base_plt_prefix   | 基本PLT文件的前缀，默认为“rebar3”                            |

# edoc

生成doc文档，具体看[这](http://erlang.org/doc/apps/edoc/chapter.html)

# escriptize

生成包含项目及其依赖项的BEAM文件的escript可执行文件。

| Config Option     | Type          | Description                                                  |
| ----------------- | ------------- | ------------------------------------------------------------ |
| escript_main_app  | atom          | 要转到escript的应用程序的名称。如果只有一个，则默认为顶级应用。使用伞状项目（具有多个顶级应用程序）时，必须指定此值。 |
| escript_name      | string        | 生成的escript的名称，以及boot（Module:main(_)）的默认模块名称。默认值为escript_main_app |
| escript_incl_apps | list of atoms | 除主应用程序及其依赖项（来自应用程序文件）之外，要包含在escript存档中的应用程序列表。默认为[] |
| escript_emu_args  | string        | Escript模拟器参数（%%!在escript声明之后）。该字符串必须%%!以换行符开头并以换行符结束。一个示例字符串"%%! +sbtu +A0\n"。默认值为 “%%! -escript main MainApp\n” |
| escript_shebang   | string        | 要运行的escript文件的位置。默认为"#!/usr/bin/env escript\n"。行结束标记必须包含在字符串中。 |
| escript_comment   | string        | 任意comment放入生成的escript中。必须在末尾包含换行标记。默认为%%\n。 |

要覆盖escript的默认模块名称（预期与之相同escript_name），请添加-escript main Module到escript_emu_args

示例escript配置来自relx：

```erlang
{escript_emu_args, "%%! +sbtu +A0 -noinput\n"}.
{escript_incl_apps, [getopt, erlware_commons, bbmustache, providers, relx]}.
12
```

# eunit

运行项目应用程序的eunit测试。支持参数如下：

| Option      | Type                            | Description                                                  |
| ----------- | ------------------------------- | ------------------------------------------------------------ |
| –cover/-c   | Boolean                         | 生成cover数据                                                |
| –verbose/-v | Boolean                         | 详细输出                                                     |
| –app        | Comma separated list of strings | 运行测试的应用程序列表。相当于EUnit的[{application, App}]。  |
| –suite      | Comma separated list of strings | 要运行的测试套件列表。相当于EUnit的[{module, Suite}]。       |
| –file / -f  | Comma separated list of strings | 要运行的文件列表（例如test/my_tests.beam），相当于Eunit的[{file, File}]。 |

# get-deps

rebar3 已结不需要这个命令，compile会调用get-deps

# help

查看某个命令的帮助， rebar3 help clean

# new

基础用法章节中讲过，这里就不再讲了
rebar3 new
使用 --force/-f 可以强制覆盖已有文件，不过还是推荐删除重新生成

# path

打印在当前配置文件中构建目录的路径。支持选项如下：

| Option        | Type                            | Description                                    |
| ------------- | ------------------------------- | ---------------------------------------------- |
| -app          | Comma separated list of strings | 逗号分隔的应用程序列表，用于返回路径。         |
| –base         | none                            | 返回指定项目当前配置文件的路径                 |
| –bin          | none                            | 返回指定项目当前配置文件的路径                 |
| –ebin         | none                            | 返回指定项目当前配置文件的路径                 |
| –lib          | none                            | 返回指定项目当前配置文件的路径                 |
| –priv         | none                            | 返回指定项目当前配置文件的路径                 |
| –separator/-s | string                          | 在多个返回路径的情况下，用于连接它们的分隔符。 |
| –src          | none                            | 返回指定项目当前配置文件的路径                 |
| –rel          | none                            | 返回指定项目当前配置文件的路径                 |

# pkgs

列出可用的包。

# release

构建项目发布。使用rebar3 help release来查看支持参数列表

# relup

从2个版本创建一个relup， 使用 rebar3 help relup 查看支持参数列表

# report

生成上下文数据以包含在错误报告中,如果你要给rebar3上报自己的异常，使用reprot可以快速采集环境信息

# shell

使用项目应用程序和路径中的deps运行shell。

使用此命令引导的shell具有运行的代理，允许动态运行rebar3命令，例如r3:compile()或r3:upgrade()，并自动重新加载新模块。通过调用可以访问特定的命名空间r3:do(Namespace, Command)。shell不支持传参

| Option       | Type   | Description                                  |
| ------------ | ------ | -------------------------------------------- |
| –config      | string | 支持加载配置文件（如果有）。默认是sys_config |
| –name/–sname | atom   | 使用erl -name/-sname 来启动节点              |
| –setcookie   | string | 指定cookie，同erl -setcookie                 |
| –script      | string | 在应用程序启动之前要执行的escript的路径      |
| –apps        | string | 以逗号分隔的要引导的应用程序名称列表。       |

如果relx做了配置，则默认为relx版本中的应用程序。

# tar

构建由项目构建的发布的压缩tar存档, rebar3 help tar 查看详细内容

# tree

打印项目构件树

# lock

获取要添加到rebar.lock文件中的未构建的依赖项。它们会被下载，但它们的构建脚本都不应该运行。虽然这不一定适用于pre / post hooks和dep plugins。

# unlock

解锁依赖项。如果没有提到依赖项，则该命令将解锁所有依赖项。如果列出任何特定的顶级依赖项（以逗号分隔）作为参数，那么这些依赖项将被解锁。

然后生成新的锁定文件，或者在没有锁定的情况下删除现有的锁定文件。

当从rebar.config中取出一个或多个依赖项时，应使用此命令，但保留在锁定文件中。也就是你要删除依赖项的时候，用来清理rebar.lock文件

# update

更新包索引。

# upgrade

升级依赖项并相应地更新锁定文件。
rebar3 upgrade []
如果没指定，则所有的都会被更新

# version

打印rebar3 和erlang的版本

```shell
$ ../rebar3 version
rebar 3.7.0-rc2+build.4175.ref83d01b5 on Erlang/OTP 19 Erts 8.0
12
```

# xref

执行xref分析