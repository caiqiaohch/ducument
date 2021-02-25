Luajit-2.1.0-beta1的发布和生成arm64用bytecode的解脱

前情提要：由于苹果要求2015年2月1日上架的新app必须支持64位的arm64，旧的app也得在6月1日支持64位，来源。于是unity3d弄出了il2cpp这种花式的玩法来进行64位支持，而对于当时的大多数采用luajit的cocos2d-x用户而言，就只能选择换成lua本身(32位和64位的字节码还是不同)或者不编译成二进制的字节码，只是混淆一下源代码来保持64位兼容，但是这样对于代码的保护就不到位了（虽然大家都很忙，也不会有人太闲着来看这些代码）不过能够用上luajit的字节码还是会让人踏实很多。

很快在luajit的maillist出现了相关arm64的询问，作者也给出了详细的方案，详情可见这里；接着这位叫哎呀的热心人就在他的博客上给出了可以生成arm64下的字节码的方案，第一篇，第二篇。是对maillist的总结和实践最后给出的方案，至此luajit的2.1.0alpha版可以生成arm64的字节码了，cocos2dx的app更新的时候只需根据__arm64__的预编译宏定义修改一下lualoader，带上32位和64位的字节码就可以欢快的跑在arm64cpu的iphone5s及以上手机了。

至此为止，看上去一切已经圆满了，只是app的体积会增大出一份64位字节码的代码大小，但是可以换来更加放心的代码保护和加快加载的速度也是值得的，不过正如luajit的作者在maillist里面的回答以及哎呀在第二篇博客上给出的方案所留下的尾巴，想要生成64位的字节码并不是一件容易的事情，必须在字节码的目标平台上生成，也就是要在iphone5s以上的手机上才能生成，生成完了还要通过ftp的形式发回到做包的机器上，简直是自动化流程的究极噩梦，一旦更新了代码就得在手机上去生成一下然后传回到pc或者mac上，想着就觉得头疼。虽然后来爱折腾的同学实现了iphone6p一键编译完成后自动上传到更新pc上的功能，却时常在更新时忘了去点那么一下……

于是最后luajit作者在maillist上那句话就成了我一直念念不忘的[Eventually there'll be a native x64 interpreter with LJ_GC64 and LJ_FR2, then you could use that one.]

……回响……

昨天发现luajit在8月25号更新，赶紧下下来看了看更新日志（官网的更新日志并没有更新到最新版本），发现了两条

Add LJ_GC64 mode: 64 bit GC object references (really: 47 bit). Interpreter-only for now.
Add LJ_FR2 mode: Two-slot frame info. Required by LJ_GC64 mode.
顿时觉得有戏了，虽然作者并没有给出生成的方案，但查看了一下代码，最后在lj_arch.h里面发现了LUAJIT_ENABLE_GC64的宏定义，正是开启LJ_GC64的关键，开启宏定义之后在linux下编译生成的luajit执行文件就可以生成出和在arm64的iphone下一模一样的字节码了，从此解放了iphone，感谢luajit的作者Mike Pall ,本来我还一直担心luajit不再继续维护的。

ps:  作者在此提到了这个宏定义

patch:

最近我又发现在windows下面没法正确的通过msvcbuild编译出luajit的x64可执行文件，如果定义了LUAJIT_ENABLE_GC64这个宏，编译会出错:buildvm_arch.h(1281): error C2039: 'J': is not a member of 'GG_State'.

这样的话就只能在linux的gcc64下面编译，十分不甘心。继续深挖之后发现还是有办法的，

首先当然要在vs2015 x64 native command prompt下面运行luajit/src/msvcbuild.bat，在lj_arch.h的开始#define LUAJIT_ENABLE_GC64。然后修改msvcbuild.bat文件，去掉第一个-D JIT，也就是关闭jit，变成这样：@set DASMFLAGS=-D WIN -D FFI -D P64；

然后将vm_x86.dasc修改为vm_x64.dasc，否则虽然可以编译出来可执行文件，但是运行就出错退出。经过这两处修改之后就可以在windows下的vs里编译出可以生成兼容arm64的bytecode的luajit可执行文件了。

