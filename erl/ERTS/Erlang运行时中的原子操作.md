# [Erlang运行时中的原子操作](https://www.cnblogs.com/zhengsyao/archive/2012/11/02/Erlang_atomics_op_and_memory_barrier.html)

# Erlang运行时提供的原子操作API

尽管Erlang给开发人员提供的语义是基于消息传递式的同步，对于应用开发者来说，使用这种语义可以避免使用锁；但是在Erlang运行时（ERTS）中，为了充分利用多核处理器中多个处理器核心，Erlang运行时采用了多线程的结构，例如一个调度器就运行在一个线程中，因此Erlang运行时本身也是一个多线程应用程序。目前大部分多核处理器都采用共享内存的架构共享数据，因此这些线程之间通信的最高效方式就是通过共享内存进行通信。多个线程对共享内存的访问必须进行同步，否则就可能会造成数据损坏。和其他大多数多线程应用程序一样，ERTS也采用锁机制（自旋锁、互斥锁、读写锁和条件变量）进行同步。

当一个需要对共享数据进行修改之前首先获得锁，此时其他线程必须等待获得锁，当线程修改完数据之后再释放锁。修改共享数据的部分称为临界区。临界区的复杂程度决定了这个锁的粒度。锁的粒度越小说明其他线程等待的时间也越少。在所有同步机制中，粒度最小的就是原子操作了。原子操作通常是对一个变量（计数器）进行简单的操作，例如读取、设置以及简单的加减运算等。原子操作是所有同步机制的根本，因为同步机制本质上都是基于多个线程对于同一个变量的读取和操作，如果“读取和操作”这两个步骤会被其他线程打断，那么就无法保证这个变量的完整性。

原子操作是如此的重要，因此现代的计算机体系一般都直接通过硬件支持原子操作。例如x86平台提供的lock指令前缀，lock前缀可以用于一些“读取并修改写入”的指令。这一类指令涉及到读取-计算-写入一个序列的操作。当指令前面加上了lock前缀时，CPU会在执行指令的时候通过某种方法禁止其他指令对涉及到的内存地址进行访问（例如锁住总线），从而实现了指令能够原子地完成这个操作序列。

ERTS的基础库提供了非常全面的原子操作，在x86平台上这些原子操作都直接映射到底层的硬件实现。在R15中，根据操作数的长度，ERTS提供的原子操作API以以下形式表示：

- 32位和机器字长：ethr_atomic[32]_<OP>[_<BARRIER>]，带有32表示32位的原子操作。
- 双字长：ethr_dw_atomic_<OP>[_<BARRIER>]

ethr的前缀表示这是ERTS中属于ethread线程库的API。<OP>表示具体操作的名称。32位变量和机器字长的变量自持以下原子操作：

- cmpxchg：接受一个新的值val和一个老的值old_val，如果原始值等于old_val，则将原始值更新为新值val并返回老的值；如果不等于，则返回原始值。
- xchg：接受一个新的值val，将原始值更新为val，然后返回原始值的老值。
- set：接受一个新的值val，将原始值更新为val，不返回值。
- init：初始化，同set。
- add_read：接受一个值val，将原始值更新为原始值加上val的值，返回得到的结果。
- read：返回原始值。
- inc_read：原始值自增1，返回新的值。
- dec_read：原始值自减1，返回新的值。
- add：接受一个值val，将原始值更新为原始值加上val的值，不返回结果。
- inc：原始值自增1，不返回结果。
- dec：原始值自减1，不返回结果。
- read_band：接受一个值val，将原始值更新为原始值和val按位与的结果，返回原始值的老值。
- read_bor：接受一个值val，将原始值更新为原始值和val按位或的结果，返回原始值的老值。

例如ethr_atomic_cmpxchg(ethr_atomic_t *var, ethr_sint_t val, ethr_sint_t old_val)这个api表示操作数宽度为机器字长，在一个原子操作内：将var指向的原子变量的值和old_val的值进行比较，如果相等，则将var指向的原子值替换为val，并返回old_val的值。如果不相等，则返回var指向的原子变量的原始值。因此，在使用这个api的时候，可以将返回值和old_var进行比较，如果等于的话则说明替换操作成功了，否则说明替换操作失败了。cmpxchg是“compare-and-set(CAS)”类的操作，在同步机制的实现中经常会使用到这条指令。

那么这些原子操作后面的[_<BARRIER>]是什么？在Erlang虚拟机的源代码中，有很多调用原子操作api的代码，但是每一个调用后面都会带一个像_nob或_mb这样的尾巴，这是什么意思呢？下一节解释这个尾巴的意思。

# 为什么要使用内存屏障

ERTS原子API后面的[_<BARRIER>]尾巴表示这个原子操作API附带的内存屏障（memory barrier）语义。多线程编程的困难在于不仅要非常小心多线程之间数据的同步，还要关注一些编译器和硬件的细节。为了提升代码的执行性能，编译器和处理器有可能会对指令的执行顺序进行调整，例如为了提升性能将一些写入操作合并在一起执行。对于单个线程来说，编译器和处理器的乱序处理可以保证单个线程看到的是和原始代码一致的结果。但是在多线程程序中，某一个线程可能需要观察另一个线程操作的值，所以编译器和处理器的乱序处理可能会导致线程读到的值是旧的值。例如下面这个例子：

| 线程1                  | 线程2                  |
| ---------------------- | ---------------------- |
| Store(c1,0)r1=Load(c2) | store(c2,0)r2=Load(c1) |

 

 

 

 

c1和c2的初始值为1，线程1和线程2分别在c1和c2写入0，然后分别读取c2和c1。

假定这个程序如果完全按照所示的顺序执行，而且Load操作和Store操作是原子操作，那么执行结束之后r1和r2的值会出现以下几种情况：

| r1   | r2   |
| ---- | ---- |
| 0    | 0    |
| 0    | 1    |
| 1    | 0    |

 

 

 

 

也就是说不可能出现r1和r2同时为1的情况。但是在真实硬件上，两个线程的两条指令都可能会颠倒执行，因此导致最终得到的r1和r2同时为1。但是对于单个的线程来说，这两条指令完全是可以颠倒的，因为对于单个线程来说，c1和c2是独立的，所以两条指令交换顺序执行在单个线程看来是没有区别的。在多线程编程中，如果多个线程通过一个变量进行同步，那么这种乱序会导致失败的同步。例如下面这个例子，线程1执行的代码如下：

```
1 while (f == 0);
2 print x;
```

 

线程2执行的代码如下：

```
1 x = 42;
2 f = 1;
```

 

两个线程通过变量f进行同步，变量f的初始值为0。当线程2将f设置为1之后，线程1退出while循环，应该打印出x的值为42。但是由于线程2的两个写入指令可能会颠倒执行，导致在设置x之前就设置了f，所以线程1可能会打印出x的旧值。此外，在线程1中，while循环要先读取f的值再检查f的值，因此也有可能会因为乱序执行而导致循环提前退出。为了让程序能够按照代码的意思执行，需要一种机制能够强制处理器按照程序所需要的顺序执行代码。这种机制就是内存屏障。根据上面的描述，在编译器层次和处理器层次都需要内存屏障。要注意，编译器层次的内存屏障不能保证在处理器上的执行顺序，因为编译器的内存屏障只是对编译器优化技术的约束，处理器依然有可能会乱序执行。

从写入数据和读取数据的顺序角度，内存屏障可以总结为以下4类：

**LoadLoad屏障**

这一类屏障处理 Load1; LoadLoad; Load2; 的指令顺序。在Load1和Load2之间插入LoadLoad屏障可以保证Load2加载数据之前Load1的数据已经加载完成。

**StoreStore屏障**

这一类屏障处理 Store1; StoreStore; Store2; 的指令顺序。在Store1和Store2之间插入StoreStore屏障可以保证Store2以及后续指令在执行的时候所有的处理器都可以看到Store1写入的数据。

**LoadStore屏障**

这一类屏障处理 Load1; LoadStore; Store2; 的指令顺序。在Load1和Store2之间插入LoadStore屏障可以保证Store2以及后续指令在执行的时候Load1加载的数据已经加载完成。

**StoreLoad屏障**

这一类屏障处理 Store1; StoreLoad; Load2; 的指令顺序。在Store1和Load2之间插入StoreLoad屏障可以保证Load2以及后续指令加载数据之前Store1写入的数据已经可以被所有的处理器看到。

由于内存屏障干扰了处理器优化的执行顺序，所以必然会对执行的性能带来一定的开销，而不同的屏障的开销也是不同的。一般来说，越强的屏障开销越大。除了上述4种屏障之外，还有一种比LoadLoad屏障更弱的屏障，那就是"数据依赖屏障"，这种屏障只有在Load2需要Load1的结果的时候才会强制顺序。

这4类屏障有意思指出在于，可以自由组合形成不同语义的屏障。这里提到的这些内存屏障都只是从语义的角度说的，具体的硬件平台不一定需要或提供了每一种屏障。内存模型越严格（strict）的平台所需的屏障越少，越松弛（relaxed）平台所需要的屏障也越多。

下面对ERTS中支持的屏障类型进行解释，也就是[_<BARRIER>]可以取的值。为了支持尽可能多的硬件平台，ERTS支持的内存屏障语义很全面。为了简洁，ERTS将原子操作和内存屏障整合在一套API中，所以ERTS中的原子操作API也兼具了内存屏障的功能。下面是ERTS支持的6种类型的内存屏障：

- mb：完整内存屏障。以原子操作为界，之前的所有加载和写入操作，以及之后的所有加载和写入操作，都不能跨越原子操作的界线。完整的内存屏障可以由LoadLoad、LoadStore、StoreStore和StoreLoad四个屏障的组合实现。
- relb：释放屏障（release barrier）。以原子操作为界，*之前*的所有加载和写入操作都不能跨越原子操作的界线。释放屏障名字来源于锁释放操作。也就是说，锁在释放的时候，临界区内的操作都要完成，不能跨越释放屏障，否则其他线程获得锁之后就会破坏临界区的数据了。根据原子操作的不同，这个屏障的实现方式也不同。如果原子操作是写入操作（写入释放屏障比较符合释放屏障名字的来源，因为锁释放操作通常是占有锁的线程写入一个变量表示锁已经释放了），那么可以在写入的原子操作前面放置一个LoadStore和StoreStore的组合。如果原子操作是加载操作，那么可以在加载的原子操作之前放置一个LoadLoad和StoreLoad的组合。
- acqb：获得屏障（acquire barrier）。以原子操作为界，*之后*的所有加载和写入操作都不能跨越原子操作的界线。获得屏障的名字来源于获得锁的操作。也就是说，在获得锁之后的操作不能超越到获得锁之前，否则就会在还没有获得锁的时候操作临界区，导致数据被破坏。如果原子操作是加载操作（加载获得屏障比较符合这个名字的来源，因为获得锁的时候通常都是读取一个表示是否锁定的共享变量），那么可以在加载的原子操作之后放置一个LoadStore和LoadLoad的组合。如果原子操作是写操作，那么可以在写入的原子操作之后放置一个StoreLoad和StoreStore的组合。
- wb：写屏障。以原子操作为界，之前的所有写入操作，以及之后的所有写入操作，都不能跨越原子操作的界线。仅针对写操作。这个屏障刚好是StoreStore屏障。
- rb：读屏障。以原子操作为界，之前的所有加载操作，以及之后的所有加载操作，都不能跨越原子操作的界线。仅针对加载操作。这个屏障刚好是LoadLoad屏障。
- ddrb：数据依赖读屏障。表示只要确保有依赖关系的加载操作。这个屏障的实现取决于具体的编译器和硬件平台。

结合上一节描述的原子操作，ERTS中支持所有原子操作和所有类型屏障的组合，当然有一些组合是没有意义的。

此外，ERTS也单独提供了内存屏障的操作，可以实现LoadLoad、LoadStore、StoreStore和StoreLoad四种屏障及其任意组合。

# X86处理器的乱序执行规则

虽然上面提到了好几种内存屏障，但是在X86/X86_64平台上， 内存屏障其实要简单得多，因为X86平台是一个内存排序模型严格的平台，所以要求内存屏障的地方并不多。粗略地说，基本上可以认为在大部分情况下在X86平台上只需要StoreLoad屏障。Intel 64 and IA-32 Architectures Software Developer's Manual第三卷第一册8.2.2列出了Intel平台上的内存重排规则，下面总结一下。对于单个处理器（也就是多核处理器中的一个核心，也就是超线程技术中的一个硬件线程），重排规则如下：

- 读不和读重排；
- 写不和之前的读重排；
- 写不重排，除了CLFLUSH执行的写、非临时的mov类指令（MOVNTI、MOVNTQ、MOVNTDQ、MOVNTPS和MOVNTPD）的写以及string操作；
- 读有可能和之前的写重排，但是如果对同一个地址操作则不重排；
- 读写操作不和I/O指令、lock前缀的指令和串行指令重排；
- LFENCE和MFENCE指令之后的读操作不能跨越到指令之前；
- LFENCE、SFENCE和MFENCE指令之后的写操作不能跨越到指令之前；
- LFENCE之前的读操作不能跨越到指令之后；
- SFENCE之前的写操作不能跨越到指令之后；
- MFENCE之前的读写操作都不能跨越到指令之后。

上面这些规则是抄手册的。简单地说：X86提供了LFENCE、SFENCE和MFENCE指令，分别起到LoadLoad、StoreStore和完整屏障的作用。读不会重排，写也只有在使用一些SSE2指令的时候会重排。只会发生StoreLoad重排的情况。因此在写入操作和读取操作之间要加上一个MFENCE指令。如果使用了会发生写重排的SSE2指令，那么在需要保证顺序的时候要插入SFENCE指令。

此外，lock指令也能起到内存屏障的作用。由于LFENCE、SFENCE和MFENCE指令都是SSE2指令，所以在不支持SSE2的平台上，可以随便拿一条支持lock前缀的指令来当屏障使用。

# RTFC

下面简单分析一下ERTS中原子操作API相关的代码。erts目录的大致结构如下所示：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
erts/
|-- emulator
|   |-- beam
|   |-- drivers
|   |-- hipe
|   |-- internal_doc
|   |-- pcre
|   |-- sys
|   |-- utils
|   |-- valgrind
|   `-- zlib
|-- epmd
|-- etc
|-- include
|   |-- erl_fixed_size_int_types.h
|   |-- erl_int_sizes_config.h.in
|   |-- erl_memory_trace_parser.h
|   `-- internal
|       |-- erl_errno.h
|       |-- erl_memory_trace_protocol.h
|       |-- erl_misc_utils.h
|       |-- erl_printf.h
|       |-- erl_printf_format.h
|       |-- erts_internal.mk.in
|       |-- ethr_atomics.h
|       |-- ethr_internal.h
|       |-- ethr_mutex.h
|       |-- ethr_optimized_fallbacks.h
|       |-- ethread.h
|       |-- ethread.mk.in
|       |-- ethread_header_config.h.in
|       |-- gcc
|       |-- i386
|       |   |-- atomic.h
|       |   |-- ethr_dw_atomic.h
|       |   |-- ethr_membar.h
|       |   |-- ethread.h
|       |   |-- rwlock.h
|       |   `-- spinlock.h
|       |-- libatomic_ops
|       |-- ppc32
|       |-- pthread
|       |   `-- ethr_event.h
|       |-- sparc32
|       |-- sparc64
|       |-- tile
|       |-- win
|       `-- x86_64
|           `-- ethread.h
|-- lib_src
|   |-- common
|   |   |-- erl_memory_trace_parser.c
|   |   |-- erl_misc_utils.c
|   |   |-- erl_printf.c
|   |   |-- erl_printf_format.c
|   |   |-- ethr_atomics.c
|   |   |-- ethr_aux.c
|   |   |-- ethr_cbf.c
|   |   `-- ethr_mutex.c
|   |-- pthread
|   |   |-- ethr_event.c
|   |   |-- ethr_x86_sse2_asm.c
|   |   `-- ethread.c
|   |-- utils
|   |   `-- make_atomics_api
|   `-- win
|-- man
|-- preloaded
|-- start_scripts
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

ERTS包括虚拟机和支撑库。erts/emulator/beam目录是beam虚拟机的代码，erts/emulator/下的其他目录是支撑虚拟机所需的其他组件代码。erts目录下面的include目录和lib_src目录包含了支撑库的头文件和源代码。erts/includeinternel/中包含了支持的不同架构的特定代码的目录，例如i386和x86_64。以erts/include/internel/i386目录为例，这下面包含的文件：

- atomic.h：原生的原子操作
- ethr_dw_atomic.h：原生的双字节原子操作
- ethr_membar.h：原生内存屏障相关的原语
- ethread.h：包含其他头文件
- rwlock.h：简单的读写锁
- spinlock.h：简单的自旋锁

erts/include/internel/i386/atomic.h头文件中包含的是i386/x86_64平台能支持的所有原生的原子操作，如果支持某个原生的原子操作，则#define相关的宏，并且定义执行原生操作的内联函数。例如下面这段代码：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 #if ETHR_INCLUDE_ATOMIC_IMPL__ == 4
 2 #  define ETHR_HAVE_ETHR_NATIVE_ATOMIC32_CMPXCHG_MB 1
 3 #else
 4 #  define ETHR_HAVE_ETHR_NATIVE_ATOMIC64_CMPXCHG_MB 1
 5 #endif
 6 
 7 static ETHR_INLINE ETHR_AINT_T__
 8 ETHR_NATMC_FUNC__(cmpxchg_mb)(ETHR_ATMC_T__ *var,
 9                   ETHR_AINT_T__ new,
10                   ETHR_AINT_T__ old)
11 {
12     __asm__ __volatile__(
13       "lock; cmpxchg" ETHR_AINT_SUFFIX__ " %2, %3"
14       : "=a"(old), "=m"(var->counter)
15       : "r"(new), "m"(var->counter), "0"(old)
16       : "cc", "memory"); /* full memory clobber to make this a compiler barrier */
17     return old;
18 }
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

在这里，如果是x86_64平台，则ETHR_INCLUDE_ATOMIC_IMPL__定义为8，所以这段代码定义了ETHR_HAVE_ETHR_NATIVE_ATOMIC64_CMPXCHG_MB，说明在这个硬件平台上提供了原生的64位原子的CMPXCHG操作，而且这个原子操作支持原生的完全内存屏障MB。这个函数定义为内联函数并且内嵌汇编。第13行可以看到使用了带有lock前缀的cmpxchg指令。第16行的“cc”约束表示cmpxchg指令会影响标志寄存器。这里重要的是“memory”约束，这个约束实际上告诉编译器这里要有一个编译器屏障。要求硬件屏障之前必须要求编译器屏障，否则连程序顺序都不对了还谈什么执行顺序。

erts/include/internel/i386/atomic.h头文件中的其他定义也类似，总结下来，在x86_64平台下定义了以下原生原子操作：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_ADDR
 2 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_CMPXCHG_MB
 3 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_XCHG_MB
 4 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_SET
 5 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_SET_RELB
 6 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_SET_MB
 7 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_READ
 8 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_ADD_MB
 9 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_INC_MB
10 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_DEC_MB
11 ETHR_HAVE_ETHR_NATIVE_ATOMIC64_ADD_RETURN_MB
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

 可以看出，这些原生的原子操作已经可以支持ERTS所需要的所有原子操作了。为什么这些原子操作基本上都是带有MB(即完全内存屏障)的？因为这些操作的指令前面都加了lock前缀，而在x86平台上加了lock前缀的指令自动成了完全内存屏障。也就是说，在x86平台上，这些带MB的原生操作只能是最强的内存屏障了：完全屏障。不过好消息是，读操作READ和写操作SET都有不带任何屏障的版本，所以可以帮助实现“获得屏障”和“释放屏障”。

erts/include/internel/i386/ethr_membar.h头文件定义了原生的内存屏障操作。这个文件包含了x86平台的mfence、lfence和sfence指令，并且将LoadLoad、LoadStore、StoreLoad和StoreStore屏障映射到这些指令。这个头文件假定在ERTS中只会涉及到StoreLoad的情况，所以定义了以下宏：

```
1 #define ETHR_MEMBAR(B) \
2   ETHR_CHOOSE_EXPR((B) & ETHR_StoreLoad, ethr_mfence__(), ethr_cfence__())
```

 

B可以是ETHR_LoadLoad、ETHR_LoadStore、ETHR_StoreLoad和ETHR_StoreStore，分别表示4种屏障。但是在这个宏中，只有ETHR_StoreLoad才会起作用，在x86平台中用mfence表示这个屏障，其他屏障都只是转换为简单的编译器屏障即可。顺便提一下ethr_cfence__()是一个静态内联函数，代码如下：

```
1 static __inline__ void
2 ethr_cfence__(void)
3 {
4     __asm__ __volatile__ ("" : : : "memory");
5 }
```

 

这个函数内嵌了一条空汇编代码，但是告诉编译器“memory”约束，告诉编译器说这段代码会修改内存，所以编译器必然要将这段代码之前的内存访问提交，也就达到了编译器屏障的效果。这种写法是GCC编译器屏障的惯用写法。

从i386目录向上，来到erts/include/internel目录。erts/include/internel/ethr_atomics.h文件包含了更高层一般性的定义，将所有原子操作和内存屏障语义的组合映射到了每一个平台的原生原子操作。拿机器字长的cmpxchg带wb内存屏障的操作举例：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 static ETHR_INLINE ethr_sint_t ETHR_ATMC_FUNC__(cmpxchg_wb)(ethr_atomic_t *var, ethr_sint_t val, ethr_sint_t old_val)
 2 {
 3     ethr_sint_t res;
 4 #if defined(ETHR_HAVE_NATMC_CMPXCHG_WB)
 5     res = (ethr_sint_t) ETHR_NATMC_FUNC__(cmpxchg_wb)(var, (ETHR_NAINT_T__) val, (ETHR_NAINT_T__) old_val);
 6 #elif defined(ETHR_HAVE_NATMC_CMPXCHG)
 7     ETHR_MEMBAR(ETHR_StoreStore);
 8     res = (ethr_sint_t) ETHR_NATMC_FUNC__(cmpxchg)(var, (ETHR_NAINT_T__) val, (ETHR_NAINT_T__) old_val);
 9 #elif defined(ETHR_HAVE_NATMC_CMPXCHG_MB)
10     res = (ethr_sint_t) ETHR_NATMC_FUNC__(cmpxchg_mb)(var, (ETHR_NAINT_T__) val, (ETHR_NAINT_T__) old_val);
11 #elif defined(ETHR_HAVE_NATMC_CMPXCHG_RB)
12     ETHR_MEMBAR(ETHR_StoreStore);
13     res = (ethr_sint_t) ETHR_NATMC_FUNC__(cmpxchg_rb)(var, (ETHR_NAINT_T__) val, (ETHR_NAINT_T__) old_val);
14 #elif defined(ETHR_HAVE_NATMC_CMPXCHG_ACQB)
15     ETHR_MEMBAR(ETHR_StoreStore);
16     res = (ethr_sint_t) ETHR_NATMC_FUNC__(cmpxchg_acqb)(var, (ETHR_NAINT_T__) val, (ETHR_NAINT_T__) old_val);
17 #elif defined(ETHR_HAVE_NATMC_CMPXCHG_RELB)
18     ETHR_MEMBAR(ETHR_StoreStore);
19     res = (ethr_sint_t) ETHR_NATMC_FUNC__(cmpxchg_relb)(var, (ETHR_NAINT_T__) val, (ETHR_NAINT_T__) old_val);
20 #else
21 #error "Missing implementation of ethr_atomic_cmpxchg_wb()!"
22 #endif
23     return res;
24 }
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

这段代码由一组#if指令组成。ETHR_ATMC_FUNC__(cmpxchg_wb)会展开为这个原子操作的名字，不过是内部使用的名字，erts/lib_src/ethr_atomics.c中的包装函数会调用这个名字。这段函数处理了各种原生实现缺胳膊少腿的情况。例如如果原生平台只提供了不带内存屏障的原子操作，也就是ETHR_HAVE_NATMC_CMPXCHG条件为真，那么这个函数会添加一个内存屏障。由于我们的x86平台的原生操作提供了原生的完全内存屏障，所以功能比写屏障要强，所以直接调用带_mb的版本即可。这个文件中的其他原子操作函数也就是类似定义的。

下面进入erts/lib_src/ethr_atomics.c这个C语言文件，这里面都是对上一个文件的包装。这个文件还提供了各种fallback，也就是在硬件平台没有提供原生实现时的操作。现在估计也没什么平台不会提供原生的原子操作了，所以这些fallback实际上意义不大。

erts/include/internel/ethr_atomics.h文件和erts/lib_src/ethr_atomics.c文件实际上是各个层次操作的映射，里面最终定义了我们所需要的所有原子操作和屏障语义的组合，这样光是机器字长的原子操作就78个，32位的也有78个，还有一些双字节的原子操作。如果每一个都手工定义，那Rickard Green大牛会累死的，作为geek，基本素质就是不做重复的劳动，所以他在erts/lib_src/utils目录下放了一个程序，这个程序负责生成这两个文件。然后在这两个文件的头部用详细的注释表示每一个硬件平台需要提供那些原生的API即可，聪明的erts/include/internel/ethr_atomics.h和erts/lib_src/ethr_atomics.c能够根据可用的原生操作生成所有的原子API。

小结和参考资料

 

本文介绍了ERTS中提供的原子操作，并且介绍了由于处理器乱序执行给多线程程序同步带来的问题和解决方法。Paul McKenney的文章“Memory Barriers: a Hardware View for Software Hackers”从cache一致性协议和store buffer的根源解释了发生乱序的原因，这篇文章还介绍了不同硬件平台的内存屏障。Preshing的博客“[preshing on programming](http://preshing.com/)”介绍了很多和内存屏障相关的内容，例如[内存重排现象的重现](http://preshing.com/20120515/memory-reordering-caught-in-the-act)，通过版本控制系统为metaphor介绍各种类型[内存屏障](http://preshing.com/20120710/memory-barriers-are-like-source-control-operations)以及[强弱内存模型](http://preshing.com/20120930/weak-vs-strong-memory-models)等；另外这个博客还有一些关于多线程编程的内容和一些编程相关的心得，值得推荐。此外就是各个平台处理器的文档了。