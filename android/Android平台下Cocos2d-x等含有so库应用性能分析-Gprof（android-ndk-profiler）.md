Android平台下Cocos2d-x等含有so库应用性能分析-Gprof（android-ndk-profiler）

前几天在工作中，解决了一个cpu占用率高的问题，尝试过各种方法，因为刚接手项目代码不熟，所以准备依赖于工具解决，虽然最终android-ndk-profiler依然没有解决我的问题，但是我觉得这仍旧是一个比较好的工具，所以准备分享给大家，网上的使用方法不是很全面，在使用过程中依旧遇到了些问题，我在这里做些总结。



    Android 本来就是基于 Linux 的，所以这里用 gprof 来做性能测试是没什么问题的。不过需要注意的是，这里所说的性能测试是针对 NDK 编译的 C++ 代码的。就想 Cocos2d-x 这样的 C++ 实现的游戏引擎就可以通过 gprof 来分析。分析我们app中native层的C/C++代码性能，能够方便我们找出其中的性能瓶颈，并在稍后做有针对性的优化。


1. 下载android-ndk-profiler
android-ndk-profiler 模块的源代码在 GitHub 上面，首先要把模块代码 clone 下来


    下载解压后如下图，我们重点使用jni下面的东西



    

3.项目中集成

1、来到我们自己的 Cocos2d-x 项目目录中，新建一个叫做 android-ndk-profiler 的文件夹，将刚刚克隆的 android-ndk-profile 模块的 jni 目录中的所有文件拷贝到我们刚刚建立的文件夹中。

比如我这里 


如果你使用的ndk版本是r9系列的，那么你还要在android-ndk-profile中添加一个ucontext.h的头文件，并在prof.c文件中包含，ucontext.h的内容如下：


/*  Android NDK doesn't have its own ucontext.h */
#ifndef ucontext_h_seen
#define ucontext_h_seen
 
#include <asm/sigcontext.h>       /* for sigcontext */
#include <asm/signal.h>           /* for stack_t */
 
typedef struct ucontext {
	unsigned long uc_flags;
	struct ucontext *uc_link;
	stack_t uc_stack;
	struct sigcontext uc_mcontext;
	unsigned long uc_sigmask;
} ucontext_t;
 
#endif
2.Android.mk
打开 proj.android/jin/Android.mk 文件




LOCAL_PATH := $(call my-dir)
 
include $(CLEAR_VARS)
 
$(call import-add-path,$(LOCAL_PATH)/../../../cocos2d-x/external/android-ndk-profiler)
LOCAL_MODULE := cocos2dlua_shared
 
LOCAL_CFLAGS := -pg
LOCAL_MODULE_FILENAME := libcocos2dlua
 
LOCAL_SRC_FILES := \
../../Classes/AppDelegate.cpp \
../../Classes/ide-support/SimpleConfigParser.cpp \
hellolua/main.cpp
 
LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/../../../cocos2d-x/external/android-ndk-profiler \
$(LOCAL_PATH)/../../Classes/protobuf-lite \
$(LOCAL_PATH)/../../Classes/runtime \
$(LOCAL_PATH)/../../Classes \
$(LOCAL_PATH)/../../../cocos2d-x/external \
$(LOCAL_PATH)/../../../cocos2d-x/tools/simulator/libsimulator/lib
 
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes
 
# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END
 
LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += cocos2d_simulator_static
LOCAL_STATIC_LIBRARIES += android-ndk-profiler
 
# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END
 
include $(BUILD_SHARED_LIBRARY)
 
$(call import-module, android-ndk-profiler)
$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,tools/simulator/libsimulator/proj.android)
 
# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END

3.修改AppDelegate.cpp 文件
只需要引入一个头文件，添加两个函数调用即可

 


// 引入头文件
#if (COCOS2D_DEBUG>0 && CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "android-ndk-profiler/prof.h"
#endif

bool AppDelegate::applicationDidFinishLaunching()
{
#if (COCOS2D_DEBUG>0 && CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
  monstartup("libcocos2dlua.so");
#endif
  // 其他已有逻辑代码......
}

void AppDelegate::applicationDidEnterBackground()
{
  // 其他已有逻辑代码......
#if (COCOS2D_DEBUG>0 && CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    moncleanup();
#endif
}

 

这里只需要注意两点。

WRITE_EXTERNAL_STORAGE 写的权限

AndroidManifest.xml 因为要生成性能分析报告，所以要赋予你的 Android 程序 WRITE_EXTERNAL_STORAGE 权限，即

1
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
libcocos2dlua.so 这个 so 文件会根据你的 Cocos2d-x 项目的类型不同名字上会有所不同，比如我们是 Lua 项目，所以 NDK 编译生成的 so 文件就叫 libcocos2dlua.so ，具体的文件名请自行到 proj.android/libs/armeabi 目录下查看。



4.编译打debug包
 

编译失败：

1.找不到 prof.h

可以在 proj.android/jin/Android.mk 上面添加

 

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/../../../cocos2d-x/external/android-ndk-profiler \
 

2.
ucontext_t 不识别。 ucontext_t这个是在 ndk里面

由于我的 android-ndk-r9d没有，所以 换成了 android-ndk-r10e


打包成功之后运行会生成gmon.out

 

引用别人的原文，解释下原理：

生成 gmon.out 性能分析报告
项目编译完成后生成 apk 文件，将 apk 文件安装到 Android 设备上。通过上一小节我们对 AppDelegate.cpp 文件的修改不难看出，当程序在 Android 设备上运行的时候，调用了 monstartup 函数开始性能分析，当程序退到后台时调用了 moncleanup 函数生成性能分析报告。性能分析报告文件默认存储到 Android 设备的 /sdcard/gmon.out 位置，我们用 adb 工具可以把文件拉到电脑上面。

adb pull /sdcard/gmon.out .
当然官方文档里面也提了，如果想要自定义性能分析报告存放的位置，可以在调用 moncleanup 函数前指定要保存的位置。

setenv("CPUPROFILE", "/data/data/com.example.application/files/gmon.out", 1);
moncleanup();
解读性能分析报告 gmon.out
生成的性能分析告报 gmon.out 是不能直接通过文本编辑器打开来读的，它是个二进制文件，需要专门的工具来生成可读的文本文件。这个工具在 NDK 中已经提供了，以我使用的 android-ndk-r10d 为例：


cd android-ndk-r10d/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin/
./arm-linux-androideabi-gprof \
你的项目路径/proj.android/obj/local/armeabi/libcocos2dlua.so\
你的gmon.out存放路径/gmon.out > gmon.txt
这里只解释一点。

libcocos2dlua.so 细心的读者发现这里使用的 so 文件并不是之前的那个放在 proj.android/libs/armeabi/libcocos2dlua.so 下面的那个 so 文件。这是因为最终随 apk 一起打包的那个 libcocos2dlua.so 文件（也就是 proj.android/libs/armeabi 目录下的）是不包含符号表的，而存放在 proj.android/obj/local/armeabi 目录下的是带符号表的版本。而什么是符号表，这是一个编译链接中的概念，请自行 Google 一下，或者读一读《程序员的自我修养》这本书，再次强烈推荐这本书。

 

咱们自己的代码
对于生成 的gmon.out分析，命令行：

分析 gmon.out
$ cd /Users/hanyundi/Documents/ZFT_SDK/android/android-ndk-r10e/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin 

$ ./arm-linux-androideabi-gprof libcocos2dlua.so的位置 gmon.out的位置 > mygmon.txt
 mygmon.txt输出到了 arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin下，你可以放到你想放的地方

 android-ndk-r10e（这个其他版本也可以。我试了几个）

遇到的问题
一开始使用的魅族手机，生成了gmon.out，但是解读的时候报错，换了一台华为的手机就可以了。

 

具体的gmon.out分析，可以自行百度。。。共勉之。。。

 

啰里啰嗦了半天。。。
————————————————
版权声明：本文为CSDN博主「面包大师」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/czh3642210/article/details/76168643