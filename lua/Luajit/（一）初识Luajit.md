# （一）初识Luajit

本人博客地址：http://www.cppblog.com/pwq1989/

第一篇对Luajit做一个大概的介绍，我目前也正在慢慢的读通源码中，以后发现了新东西就补充在这里。

大家可以从官网下载到源码（http://luajit.org/），也可以从Github（https://github.com/LuaDist/luajit）down下来，顺便还可以看下commit记录。

大家对着luajit的wiki结合源码看的话会更好些，因为。。文档太特么少了！！

目录结构：
-- src
    -- host
    -- jit
    *.c
    *.h
    *.dasc
等等，别的不是很重要

最开始我是从main函数开始看的，然后。。碰了一鼻子灰，后来研究下他的makefile，发现他是这样子的编译的，贴一下关键的msvcbuild.bat的代码（这个更容易看懂）
 1 :X64
 2 minilua %DASM% -LN %DASMFLAGS% -o host\buildvm_arch.h vm_x86.dasc
 3 @if errorlevel 1 goto :BAD
 4 
 5 %LJCOMPILE% /I "." /I %DASMDIR% host\buildvm*.c
 6 @if errorlevel 1 goto :BAD
 7 %LJLINK% /out:buildvm.exe buildvm*.obj
 8 @if errorlevel 1 goto :BAD
 9 if exist buildvm.exe.manifest^
10   %LJMT% -manifest buildvm.exe.manifest -outputresource:buildvm.exe
11 
12 buildvm -m peobj -o lj_vm.obj
13 @if errorlevel 1 goto :BAD
14 buildvm -m bcdef -o lj_bcdef.h %ALL_LIB%
15 @if errorlevel 1 goto :BAD
16 buildvm -m ffdef -o lj_ffdef.h %ALL_LIB%
17 @if errorlevel 1 goto :BAD
18 buildvm -m libdef -o lj_libdef.h %ALL_LIB%
19 @if errorlevel 1 goto :BAD
20 buildvm -m recdef -o lj_recdef.h %ALL_LIB%
21 @if errorlevel 1 goto :BAD
22 buildvm -m vmdef -o jit\vmdef.lua %ALL_LIB%
23 @if errorlevel 1 goto :BAD
24 buildvm -m folddef -o lj_folddef.h lj_opt_fold.c
25 @if errorlevel 1 goto :BAD

先创建了一个buildvm.exe的中间工具，来自动生成代码，分别生成了lj_vm.obj，lj_bcdef.h，lj_ffdef.h ，lj_recdef.h ，jit\vmdef.lua，lj_folddef.h， lj_libdef.h

其中lv_vm.obj是依赖于host\buildvm_arch.h的，这个是用DynASM预处理vm_x86.dasc生成的，这个工具的具体分析会在下一篇博客提及。

先来看下上面自动生成的代码：
lj_bcdef.h:
 1 LJ_DATADEF const uint16_t lj_bc_ofs[] = {
 2 0,
 3 71,
 4 142,
 5 213,
 6 284,
 7 
 8 };
 9 
10 LJ_DATADEF const uint16_t lj_bc_mode[] = {
11 BCDEF(BCMODE)
12 BCMODE_FF,
13 BCMODE_FF,
14 BCMODE_FF,
15 BCMODE_FF,
16 BCMODE_FF,
17 
18 };

lj_bc_ofs[]可能是bc在vm代码段中的偏移量（这个我还没深入进去调试一下），vm的一部分是用DynASM直接撸汇编撸出来的，wiki中也有提到下一步jit化的opcode等等。
lj_bc_mode[]的用来根据压缩后的bytecode构造，分离出操作数，第一行的两个宏的定义是
#define BCMODE(name, ma, mb, mc, mm) \
  (BCM##ma|(BCM##mb<<3)|(BCM##mc<<7)|(MM_##mm<<11)),
#define BCMODE_FF	0

#define BCDEF(_) \
  /* Comparison ops. ORDER OPR. */ \
  _(ISLT,	var,	___,	var,	lt) \
  _(ISGE,	var,	___,	var,	lt) \
  _(ISLE,	var,	___,	var,	le) \
  _(ISGT,	var,	___,	var,	le) \
...
总之就是充斥着各种拼接起来的宏

lj_ffdef.h:
1 FFDEF(assert)
2 FFDEF(type)
3 FFDEF(next)
4 FFDEF(pairs)
5 FFDEF(ipairs_aux)
6 
FFDEF的定义是在
1 /* Fast function ID. */
2 typedef enum {
3   FF_LUA_ = FF_LUA,    /* Lua function (must be 0). */
4   FF_C_ = FF_C,        /* Regular C function (must be 1). */
5 #define FFDEF(name)    FF_##name,
6 #include "lj_ffdef.h"
7   FF__MAX
8 } FastFunc;
差不多就是用FF_##name把上面的名字拼接起来，然后生成在enum里面，这样就能当成是数字，在数组中迅速找到入口了

vmdef.lua:
这个里面内容就不贴了，包括bcname,irname,irfpm,irfield,ircall 的定义，在jit文件夹下面，用于调试等，比如在dump.lua中就有用到
local jit = require("jit")
assert(jit.version_num == 20002, "LuaJIT core/library version mismatch")
local jutil = require("jit.util")
local vmdef = require("jit.vmdef")  // ← ← ← ←

当你用luajit -jdump的时候，就是调用的lua的jit库里面的lua函数

lj_recdef.h:
 1 static const uint16_t recff_idmap[] = {
 2 0,
 3 0x0100,
 4 0x0200,
 5 0x0300,
 6 0,
 7 0,
 8 0x0400,
 9 
10 };
11 
12 static const RecordFunc recff_func[] = {
13 recff_nyi,
14 recff_c,
15 recff_assert,
16 recff_type,
17 recff_ipairs_aux,
18 
19 };
其中recff_func[]是被注册的被traced jit 跟踪的函数，具体可是在lj_ffrecord.c里面看到
recff_idmap[]被用在lj_ffrecord_func这个函数中，有一个关键的数据结构RecordFFData，用来记录在trace过程中被调用函数的参数和返回值个数，和一些辅助数据，opcode，literal等等。通过recff_idmap[]保存的值来区分函数（待仔细研究）


lj_folddef.h:
 1 static const FoldFunc fold_func[] = {
 2   fold_kfold_numarith,
 3   fold_kfold_ldexp,
 4   fold_kfold_fpmath,
 5   fold_kfold_numpow,
 6 
 7 };
 8 
 9 static const uint32_t fold_hash[916] = {
10 0xffffffff,
11 0xffffffff,
12 0x5b4c8016,
13 
14 };
用在FOLD optimization中，见lj_opt_fold.c，主要在
1 if ((fh & 0xffffff) == k || (fh = fold_hash[h+1], (fh & 0xffffff) == k)) {
2       ref = (IRRef)tref_ref(fold_func[fh >> 24](J));
3       if (ref != NEXTFOLD)
4     break;
5     }
是根据数组偏移获取函数，直接执行。
（这个Optimation略复杂，以后的博文中再说）

----------------------------------------分割线-------------------------------------------

以上就是buildvm生成代码，在很多.c的文件中，他加入了一些无意义的MARCO，目的是为了能被buildvm识别出

下面说说src根目录下面的文件：

lauxlib.h：
用户开发扩展和与C交互的时候的头文件

lib_*.h /.c:
顾名思义，就是利用LuaAPI写的内部标准库，会在方法上表明是否会被trace ( LJLIB_REC(.) )。

ljamalg.c:
文件的合并

lj_alloc.h /.c:
定制的Memory Allocator

lj_api.c:
Public Lua/C API.

lj_arch.h:
Target architecture selection

lj_jit.h:
jit编译器里面数据结构的定义

lj_asm.h/ .c  lj_asm_*.c lj_emit_*.h lj_target_*.h/.c :
将IR编译成Machine Code，关键的数据结构ASMState，线性扫描的O(n2)分配算法

lj_bc.h/ .c：
Luajit字节码的定义和内存布局

lj_bcdump.c lj_bcread.c  lj_bcwrite.c:
围绕着字节码的操作

lj_carith.c:
C实现的一些数字运算

lj_ccall.h/ .c  lj_ccallback.h / .c :
FFI C语言函数调用和回调绑定

lj_debug.h/.c :
调试与自省用

lj_def.h:
这个很重要，重要的类型和一些宏定义在这里

lj_c*.h/ .c:
和C语言先关的，比如类型转化，char管理，数据管理

lj_frame.h:
Luajit的栈帧管理

lj_func.h/.c:
Function handle和闭包有关的upvalue数据结构

lj_gc.h/.c:
GC相关，GC可以看下luajit的wiki，里面涉及不少增量式GC的paper和作者的看法

lj_gdbjit.h/.c :
对gdb的支持

lj_ir*.h/.c:
SSA，IR相关（这个和bytecode还是不一样的）操作和优化

lj_lex.h/.c  lj_parse.h/.c:
lexer和parser

lj_mcode.h/.c:
Machine Code管理

lj_opt_*.h:
各种bytecode层面上的优化

lj_snap.h/.c:
快照支持

lj_state.h/.c:
LuaState和Stack的操作

lj_str*.h/.c  lj_tab.h/.c:
原生类型string和table操作

lj_udata.h/.c:
类型user data的操作

lj_vm.h/.c  lj_vmevent.h/.c:
vm的API和事件注册（lj_vmevent_send）

lj_vmmath.h/.c：
对vm支持的math库

lua.h:
luaState等基本的Lua结构

lualib.h:
和Lua一样，标准库的API

luajit.h:
luajit 的public API

vm_*.dasc:
编译期被DynASM预处理的源文件，下一篇讲DynASM时候介绍dasc文件

wmain.c:
windows下面的main入口

和Trace相关的：
lj_crecord.h/.c  ： C操作的trace record
lj_dispatch.h/.c :  指令分发，调用ASMFuction，处理指令前的hook和记录trace用的hot count，有一个重要的数据结构 GG_State
lj_ff*.h/.c: 上面讲lj_ffdef.h的时候提过，trace的时候 记录Fast Function的调用记数
lj_trace.h/.c: trace的具体过程
lj_traceerr.h : trace error