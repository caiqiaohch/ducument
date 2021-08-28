# [Erlang 虚拟机 BEAM 指令集之内存管理相关的指令](https://www.cnblogs.com/zhengsyao/p/beam_allocation_instructions.html)

翻看 BEAM 虚拟机指令集的时候（在编译器源码目录下：lib/compiler/src/genop.tab），会发现有一些和内存分配/解除分配相关的指令，如下所示： 

- **allocate** StackNeed Live
- **allocate_heap** StackNeed HeapNeed Live
- **allocate_zero** StackNeed Live
- **allocate_heap_zero** StackNeed HeapNeed Live
- **test_heap** HeapNeed Live
- **init** N
- **deallocate** N

上述列表中粗体是指令本身，后面跟着的是参数。粗看上去又是 allocate 又是 heap，好像 beam 在虚拟机指令就要处理内存管理。其实不是的。仔细看一下，每一条带 allocate 的指令后面都有一个 StackNeed 参数，原来 BEAM 虚拟机中所谓的内存分配都跟栈有关。我们先看一下Erlang进程里面堆和栈的关系：

![img](https://images0.cnblogs.com/i/414649/201403/262010455613031.png)

堆和栈其实都在统一管理的堆里面，堆从低地址开始向上增长，栈从高地址开始向下增长。栈顶和堆顶碰到了就说明堆的空间不够用了。堆用于保存 Erlang 对象。和 C 语言一样，BEAM 的函数调用也会在栈里面设置栈帧，其中包括函数返回地址以及函数在求值过程中使用的临时数据。栈里面保存的只能是 Eterm，即要么是简单对象，要么是引用对象。对立面保存的是 Eterm 或对象本身。

下面以 **allocate** StackNeed Live 为例阐述。这条指令说明要在栈上分配 StackNeed 字的空间。那么这条指令后面的 Live 是什么意思呢？在 http://erlangonxen.org/more/beam#model 有一句解释

> 'Live' refers to the current number of registers that hold values still needed by the process.

表示当前进程所需的寄存器数？看了下面这个图就明白了：

![img](https://images0.cnblogs.com/i/414649/201403/262315382963437.png)

除了堆栈之外，还有寄存器区域。堆栈是进程私有的数据结构，而寄存器组则是虚拟机（调度器）里面的共享数据。当虚拟机调度运行某个进程的时候，这个进程具有对寄存器组的完全访问权。但是当进程被调出的时候，寄存器组就归别人使用了（和 x86 机器不同，保存进程上下文的时候不保存寄存器信息，所以 Erlang 进程切换效率很高）。

上面的 Live 就是图中显示的 live 区域，也就是说，当前这个进程正在使用 live 个寄存器。那为什么分配栈内存的时候需要传入 live 参数呢？而且为什么前面几条分配指令都需要 live 参数呢？这是因为前面几条指令涉及到栈分配（前4条）和堆检查，这些操作都有可能会涉及到垃圾回收（假设分配了栈内存之后栈顶会碰到堆顶），而 Erlang 的垃圾回收需要扫描引用树，所以需要一个扫描的起点，即 rootset。那么根据上面图中对象之间的引用关系，栈中所有的项式和 live 个寄存器的项式都需要加入到 rootset 中。这就是这些和栈分配相关的指令都需要 live 参数的原因。

有了以上基础之后就好理解这些指令了。这些指令的意义总结如下：

- **allocate** StackNeed Live：将栈底指针向下挪 StackNeed+1 个字，多出的那个字保存CP（continuation pointer，即函数的返回地址）
- **allocate_heap** StackNeed HeapNeed Live：向栈底指针向下挪 StackNeed+1 个字（+1原因同上），还要保证堆中剩余 HeapNeed 个字的空闲空间
- **allocate_zero** StackNeed Live：同 allocate，但是新分配的栈空间填零（NIL）
- **allocate_heap_zero** StackNeed HeapNeed Live：allocate_heap和allocate_zero的合体
- **test_heap** HeapNeed Live：检查对空闲空间是否有 HeapNeed 个字，如不满足要垃圾回收。以上指令都有可能垃圾回收
- **init** N：栈中第 N 个字清零（NIL）
- **deallocate** N：将栈底指针向上挪 N+1 个字（释放栈）