# 所谓的启动erlang run-time system



支持多种args....



erl <arguments>



+cmd 一般解析为 emulator flag

-cmd 一般为普通flag 可以从init;get_arguments获取到。当然也有特殊用途的。。。

--cmd...叫plain args，不会解析为erl所用，但是你可以通过init:get_plain_arguments 获取到。。。

当然--cmd...  你也可以写成为 -extra ...



命令没啥好说的，知道他们的作用即可，接下来做做erts的source研读笔记，也会提及到。

-Application par val

设置app的参数的值

-arg_file FileName

从文件读取参数

-async_shell_start

异步启动shell

-boot file

指定启动文件xxx.boot

-boot_var Var Dir

动态定制boot脚本的目录

-code_path_cache

启动code cache

-compile Mod1 Mod2...

编译模块...

-config config

指定app的config文件

-connect_all false

取消分布式

-cookie cookie

现在使用 -setcookie替代

-detached

启动一个与shell分离的erts，即是daemons,使用了-noinput来实现的。

-emu_args

打印emu args，主要用于调试

-env Var Val

设置erts的os环境

-eval expr

动态解析，动态执行语句

-extra

已经提过

-heart

启动心跳

-hidden

作为隐藏节点启动

-host Host

指定节点的ip addr

-id Id

指定节点ID

-init_debug 

print一些boot脚本的启动信息

-loader Loader

指定erl_prim_loader的类型，主要有efile和inet，一个本地一个网络，有机会分析erts的driver时，可以解析解析。

-instr（emu flag）

运行一个定制erts，和自己+P...没什么分别

-make 

erl下的make，支持erl的make策略

-man 

unix/linux下查看帮助手册

-mode interactive | embedded

code的加载顺序，前者支持动态加载，后者则必须加载完毕。

-name && sname

节点名字

-noshell

unix下支持

-noinput && nostick

不支持输入以及指定某些模块为sticky，可以防止破坏内置的kernel&&stdlib模块。

-oldshell

支持使用旧版本的shell

-pa && -pz dir....

用于加载code，指定code目录，记住是beam文件之类。

-remsh Node

连接远程node，相信对于已经运行的节点来说，这东东很实用。

-rsh Program

启动一个远程Node

-run Mod Func ....

执行模块、函数等等，若是不指定func的话，会默认调用start

-s Mod...

同上,主要用于你写一个bat或者sh脚本来动态启动你的app，好些服务器就是这样来干的。

-setcookie

参考前面

-smp [enable | auto | disable]

指定erts是否支持smp

-version +V

打印出erts的版本



至于其他的emu flag，迟点和erl的init 流程一起整理下。