make Erlang 的代码编译函数库
make:all/0
编译一组 erlang 模块

用法：

all() -> up_to_date | error
编译一组 Erlang 模块，其效用跟 make:all([]) 一样，详细信息请看 make:all/1。

make:all().

----------
make:all/1
编译一组 erlang 模块

用法：

all(Options) -> up_to_date | error
这个函数首先会在当前工作目录下查找一个名为 Emakefile 的编译配置文件，来指定编译的一些配置设定。如果找不到这个文件，则编译当前目录下的所有模块。

编译模块时，会把每个模块的名称打印到终端上。如果一个模块在编译时发生了错误，编译会终端并返回错误信息。

参数 Options 是一个列表类型的参数，选项值有如下：

noexec：不执行模式，只打印需要编译的模块的名字，不做任何其他操作
load：加载模式，加载所有编译过的模块
netload：把编译好的模块加载到所有已知的节点上
参数 Options 的默认值是 []。

make:all([noexec]).

----------
make:files/1
编译一系列模块文件

用法：

files(ModFiles) -> up_to_date | error
编译一系列指定的 Erlang 模块，参数 ModFiles 是一个模块或模块文件名（省略 erl 后缀名）的列表。

开始编译前，会在当前目录下寻找一个名为 Emakefile 的编译配置文件，来获取一些编译配置选项，如果找不到，编译还会以默认的选项值继续进行。

例如在当前木有有 2 个文件，一个文件 test1.erl 在当前目录下，另外一个文件 test2.erl 在目录 test 里，那么该函数的调用如下：

make:files(["test1", "test/test2"]).

----------
make:files/2
编译一系列模块文件

用法：

files(ModFiles, Options) -> up_to_date | erro
编译一系列指定的 Erlang 模块，参数 ModFiles 是一个模块或模块文件名（省略 erl 后缀名）的列表。参数 Options 是一些编译配置选项，例如是否显示 debug 信息，模块的包含目录，和编译的 beam 文件存放的位置目录等等。

开始编译前，会在当前目录下寻找一个名为 Emakefile 的编译配置文件，来获取一些编译配置选项，如果找不到，编译还会以默认的选项值继续进行。

例如在当前木有有 2 个文件，一个文件 test1.erl 在当前目录下，另外一个文件 test2.erl 在目录 test 里，并指定 include 为文件头文件的目录，ebin 是模块编译后的 beam 文件的存放位置目录等配置选项，那么该函数的调用如下：

make:files(["test1", "test/test2"], [debug_info, {i, "include"}, {outdir, "ebin"}]).

----------
