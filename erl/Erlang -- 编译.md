# Erlang -- 编译

编译
单个文件编译
在Erlang Shell运行c(ModuleName).进行编译。

c(ModuleName, Options)也可以通过Options添加编译选项。

通过定制Emakefile来管理编译

%% Emakefile
{
	%% 源码路径
	[
		'src/**/*'
	],
	%% 编译选项
	[
		debug_info,%% 添加debug_info编译后，可反编译回源码。
		nowarn_export_all,%% 不警告全导出。
		{parse_transform, ModuleName},%% 在代码错误检查之前调用ModuleName:parse_transform/2先把代码解析一遍。
		{i, "include"},%% 头文件目录
		{outdir, "ebin"}%% 输出目录，即beam文件目录
	]
}.

创建脚本如下，运行即可编译所有文件。

## make.bat
erl -noshell -s make all -s init stop

make
通过调用make:all().或者make:all(Options).来编译模块。

其中，Options为noexec | load | netload | {emake, Emake} | <compiler option>。noexec选项指只打印将会编译的模块名而不会进行编译。load和netload选项指编译后对代码进行加载，netload会在所有已知节点加载。{emake,Emake}选项指定Emake配置文件，指定时则使用Emake文件的配置，否则在当前目录下查找文件名为Emakefile的文件，读取其中的配置。默认情况下Options为[]。

通过调用make:files(ModFiles).或者make:files(ModFiles, Options).同样可以编译模块。

上述方法最终都会通过调用compile:file(File, Options).对文件进行编译。

Emakefile格式如下：

Modules.
{Modules,Options}.

Modules指明编译的模块。

Options为编译选项。编译选项见compile模块的说明。

compile
可通过compile:env_compiler_options().获取设置的编译选项。

可通过compile:file(File).或者compile:file(File, Options).对模块进行编译。

常见编译选项如下：

debug_info选项指定在编译后的beam文件的debug_info中包含抽象代码，使其可用于Debugger等工具。

{outdir,Dir}选项指定编译后的beam的目录。

{i,Dir}选项指定头文件所在目录。

{d,Macro}、{d,Macro,Value}选项定义了宏Marco的值，默认为true。

{parse_transform,Module}选项在代码错误检查之前调用ModuleName:parse_transform/2先把代码解析一遍。

nowarn_export_all选项关闭了export_all的警告输出。

'P' 在文件<File>.P中生成经过预处理和解析转换的代码。

'E'在文件<File>.E中生成执行了所有源代码转化之后的代码。

'S'在文件<File>.S中生成汇编程序代码。
————————————————
版权声明：本文为CSDN博主「TriKin」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/Dylan_2018/article/details/114234912