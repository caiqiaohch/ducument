# C++：无法解析的外部符号问题 与 头文件包含注意要点

前要

由于种种原因，很长时间没有完整地编写一个C++程序。近期编写的程序都是简单地算法实现程序和简略的模拟程序，对于C++的许多特性都变得模糊不清。为了完成暑假的操作系统大作业——文件系统的模拟实现，从0开始写一个完成的程序。开始都进行得十分顺利，但编写完主要的头文件与cpp文件后，准备开始测试函数，进行Debug时，VS却提示大量错误信息，其中大都是：无法解析的外部符号。几天（暑假时间，不是没天都有大量时间认真编程，见笑了）时间过去后，尝试了多种解决方法终于找到了问题所在。于是有了写下搜寻过程的想法，要是有人能看这篇文章快速解决自己的问题，那就更好了。
结论：真正引起的错误的原因在于头文件的包含是否得当！
无法解析的外部符号

当我进行调试时，就会出现如下的错误信息：

    1>UserOpenedFile.obj : error LNK2019: 无法解析的外部符号 “public: __thiscall
    OpenedFile::OpenedFile(void)” (??0OpenedFile@@QAE@XZ)，该符号在函数 “public:
    __thiscall UserOpenedFile::UserOpenedFile(void)” (??0UserOpenedFile@@QAE@XZ) 中被引用 1>UserOpenedFile.obj : error LNK2019:
    无法解析的外部符号 “public: __thiscall OpenedFile::~OpenedFile(void)”
    (??1OpenedFile@@QAE@XZ)，该符号在函数 “public: void * __thiscall
    OpenedFile::`scalar deleting destructor’(unsigned int)”
    (??_GOpenedFile@@QAEPAXI@Z) 中被引用 1>UserOpenedFile.obj : error LNK2019:
    无法解析的外部符号 “public: class SFile * __thiscall OpenedFile::GetFile(void)”
    (?GetFile@OpenedFile@@QAEPAVSFile@@XZ)，该符号在函数 “public: void __thiscall
    UserOpenedFile::ShowOpenedFile(void)”
    (?ShowOpenedFile@UserOpenedFile@@QAEXXZ) 中被引用 1>UserOpenedFile.obj :
    error LNK2019: 无法解析的外部符号 “public: int __thiscall
    OpenedFile::GetOperatingType(void)”
    (?GetOperatingType@OpenedFile@@QAEHXZ)，该符号在函数 “public: void __thiscall
    UserOpenedFile::ShowOpenedFile(void)”
    (?ShowOpenedFile@UserOpenedFile@@QAEXXZ) 中被引用 1>UserOpenedFile.obj :
    error LNK2019: 无法解析的外部符号 “public: int __thiscall
    OpenedFile::GetReadPointer(void)”
    (?GetReadPointer@OpenedFile@@QAEHXZ)，该符号在函数 “public: void __thiscall
    UserOpenedFile::ShowOpenedFile(void)”
    (?ShowOpenedFile@UserOpenedFile@@QAEXXZ) 中被引用 1>UserOpenedFile.obj :
    error LNK2019: 无法解析的外部符号 “public: int __thiscall
    OpenedFile::GetWritePointer(void)”
    (?GetWritePointer@OpenedFile@@QAEHXZ)，该符号在函数 “public: void __thiscall
    UserOpenedFile::ShowOpenedFile(void)”
    (?ShowOpenedFile@UserOpenedFile@@QAEXXZ) 中被引用
    1>C:\Users\Administrator\Desktop\操作系统大作业\OsTask\Debug\OsTask.exe :
    fatal error LNK1120: 6 个无法解析的外部命令

经过简单的搜索后，可以得到出现这个错误的错因大多数在于：

    [0]出现无法解析可能是因为lib文件不正确,比如64位的编译配置,结果使用的是32位的lib包.
    [1]只写了类声明，但还没有写实现类,造成调用时无法解析 [2]声明和定义没有统一，造成链接不一致，无法解析
    [3]没有在项目属性页的链接器的命令行选项加入相应的类包。 [4]没有在c++包含目录和库目录加入相应的类包路径
    [5]在测试工程中被测文件目录可能需要包含被测类的cpp定义文件
    [6]ICE接口测试时，无法解析可能因为被测文件没有包含进相关的cpp文件，另外，在TestSuite_ProjectRun.h文件中需要包含IProjectRun.h头文件，及相关的头文件(举例)。
    [7]import相关的无法解析内容，解决办法是在链接器的依赖项中加入相应的动态库 [8]出现如下错误的原因一般是动态库没有包进来。
    [9]error LNK2001: 无法解析的外部符号 __imp___CrtDbgReportW
    工程属性，C/C++,代码生成，运行时库选择MDd,


# 引用于http://blog.csdn.net/enotswn/article/details/5934938 CSDN中enotswn博主的原创


于是我分析得到，无法解析的外部符号这个错误出现的问题可以归结为：编译器在使用某个函数或类时无法得到该函数或类的具体实现。而我的程序中调用库的函数仅有一两个，且系统的错误提示中是我编写的类中的函数无法解析。最初进行调试时，因为还有部分类的实现我还未编写（先保证已编写的代码正确性，防止编写了大量代码后出现Bug却无从下手）。

我有些抓不到头脑，无法解释的外部符号是编译器无法找到具体的实现所导致的，这个观点我坚信是没有问题的，基于对代码的编写确信没问题的观点，我的第二个猜测：会不会是我的笔记本环境变量或是哪个配置出现问题而导致的？ （个人认为：出现这种情况的概率十分之小）于是我将文件发送到我的台式电脑，再次尝试编译，果不其然，依旧出现相同的错误提示！

问题究竟出在哪？我想着问题范围应该就在于头文件了。于是，抱着尝试的心态搜索了C++头文件包含的要点。这一搜，我就找到问题所在了！


    实际中编码设计过程中，最基本的一个原则就是在类的头文件中最好不要包含其他头文件，因为这样会使类之间的文件包含关系变得复杂化。要最大限度的遵守这个原则，实际编码设计过程可以采用以下两种方法：
    
    方法一是在设计一个类的时候尽量保持类的独立性，即使该类尽可能不要依赖其他类库或者函数库，或者退一步来说，尽量不要在类的声明中依赖其他类。这样，在 该类的声明头文件中就可以没有其他头文件。如果实现中用到了其他的类，那么可以只在该类的实现文件中包含用到的类库或者函数库的头文件就行。
    
    方法二是当类的声明中必须得用到其他类库或者函数库时，方法一便不再适用，当一个类声明中引用的是其他类或结构的指针引用或者是函数引用时，也可以保持上
    述原则，做法是采用前向引用，及在该类的声明前面先声明一下该类所用到的类名或者函数名就行。当类声明中引用的是其他类的实例时，上述原则变不能保持，只
    有在该类的声明头文件中引用所引用的类库或者函数库的头文件。


#引用于 http://blog.csdn.net/u014108137/article/details/26337405 CSDN博主Acepoint的转发


我想我找到了错误的原因所在：由于在编写代码时，我根据所画的UML图，将头文件都写好了，于是在自定义类对象中，使用自定义类对象作为类成员的时候，我自然而然地直接使用了自定义类对象这个类型，而非使用自定义类对象的指针！为了使编码时编译器不出现错误，我自然需要 * 将所使用到的类的声明头文件包含在另一个头文件中！* 这个就是导致错误的真正原因！


    //A.h
    #progma once
    #include“B.h”
    class A{
    int userFile;
    B   b;
    }


若是只有一两个头文件，这样的包含关系或许不会导致错误（这也是我到大二快结束才发现这个错误的原因：以前我的习惯是将所有类的声明放在一个头文件当中。这个做法不可取），但是一旦头文件较多，复杂的包含关系就会导致编译器没编译部分头文件或无法找到与头文件相关的cpp文件（这一点我并非十分确定）。在这样的情况下，就会出现：无法解析的外部符号 这样的错误。
正确的做法

为了避免这样的错误，正确的做法（我采取的做法）是什么呢？
将上述这样的声明改为：

//A.h
#progma once
class B();

class A{
int userFile;
B*   b;
}

①不包含其他的头文件。若要使用自定义类对象，使用前置声明 的方法。
②使用自定义类的指针，而非直接使用该类型。
注意要点

最后稍微列一下C++包含头文件的顺序，同样来源于上一个引用链接。

    要注意的是一些头文件也有依赖关 系，这些文件的包含顺序也小心，否则就会出错。ps,头文件的包含顺序应该是从最特殊到一般，比如：我们应该以这样的方式来#include头文件：
    从最特殊到最一般，也就是

#include "本类头文件"
#include "本目录头文件"
#include "自己写的工具头文件"
#include "第三方头文件"
#include "平台相关头文件"
#include "C++库头文件"
#include "C库头文件"


小记：这篇博文是我的第一篇博文，谈的不是什么深刻的东西，只是我自己在解决遇到的问题的一些小小心得。作为一个不及格的程序员，行文过程中保不准出现哪些错误，若是有读者能看到并给出一些宝贵的评价，我将无限感激。
————————————————
版权声明：本文为CSDN博主「P3ray」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/P3ray/article/details/76040740