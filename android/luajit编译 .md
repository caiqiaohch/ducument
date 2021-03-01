Android 嵌入 LuaJIT 的曲折道路


相关链接：Windows 下编译 LuaJIT
懒人与伸手党可以直接看最底部。

为什么使用 LuaJIT
Lua 官方版的编译嵌入相对简单，但是为什么要用 LuaJIT 呢？我所了解到的优势有：

更高的运行效率。
支持运行 Lua 编译后的机器码。
虽然 Lua 也支持编译脚本，但是编译出来的机器码文件并不是跨平台的，也就是说在
PC 上编译的脚本在 Android 中无法使用。至于如何编译 Android 上使用的脚本，至今没有找到方案。

脚本的编译不仅可以提高载入速度，更可以一定程度上保护源码，避免被篡改。这也是我使用 LuaJIT 的主要原因。

LuaJIT NDK 编译
系统环境：Ubuntu 17 x64
Windows 下使用 Cygwin 应该也是可以的。

由于我们系统是64位，编译的目标很可能是32位的，所以先确认安装了32位所需的编译环境：
sudo apt-get install libc6-dev-i386

NDK 配置
已经配置好 NDK 的可以略过本章节。

去 NDK 官网下载适合自己的版本并解压。这里使用的是 android-ndk-r14b-linux-x86_64.

wget https://dl.google.com/android/repository/android-ndk-r14b-linux-x86_64.zip
解压放在 /opt/android/ndk.

然后配置环境变量。这里直接配置全局的环境变量。修改 /etc/proile 在最后加上
export PATH=/opt/android/ndk:$PATH
注销重新登录一下使之生效。测试下命令 ndk-build，能运行则是配置完毕。

编译
首先去 LuaJIT 官网下载源码并解压。

wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz
tar -zxvf LuaJIT-2.0.5.tar.gz
按照官方指南，新建一个 build.sh 放在解压目录下，根据实际需求输入指令：
注意根据实际环境配置，有几个地方需要修改一下。

NDK=/opt/android/ndk #注意匹配实际ndk目录
NDKABI=14
NDKVER=$NDK/toolchains/arm-linux-androideabi-4.9 #注意匹配实际版本号
NDKP=$NDKVER/prebuilt/linux-x86_64/bin/arm-linux-androideabi- #注意匹配实际路径
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-arm"
NDKARCH="-march=armv7-a -mfloat-abi=softfp -Wl,--fix-cortex-a8"
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_FLAGS="$NDKF $NDKARCH"
然后执行 sh build.sh 就应该可以编译了。

但是实际情况总是没有那么顺利。



折腾了3天，最后发现原来是变量引用问题。我不是很熟悉 shell，所以也就不再深究了，直接把 make 的所有参数写在一行里，就这么神奇地成功了。

make HOST_CC="gcc -m32" CROSS=/opt/android/ndk/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi- TARGET_FLAGS="--sysroot=/opt/android/ndk/platforms/android-14/arch-arm -march=armv7-a -mfloat-abi=softfp -Wl,--fix-cortex-a8"
如果之前编译（失败）过，记得先 make clean 清理下文件。编译成功后可看到如下提示：

编译成功

之后可以在 src 目录里找到编译出的 .a 静态库文件。通过改变编译脚本，可以编译出 armeabi-v7a x86 等不同 ABI 下的文件。

整合 Android
得到了静态库，下面就要整合进 Android 工程。由于 Lua 只提供的 C API，所以在 Android 中需要通过 JNI 来实现调用。还好有个 luajava 的开源库帮我们实现了这个繁琐的过程。而 androlua 又把 luajava 整合进了 Android. 我们这里是借用这个库来整合 LuaJIT.

导入 luajava 源码
将 luajava 的 JAVA 源码 拷贝到自己工程目录。
创建 jni/luajava/ 目录，将 luajava.c 复制到创建的目录。
在 jni/ 下创建 Android.mk，输入 include $(call all-subdir-makefiles).

导入 LuaJIT 静态库
在 jni/luajava/ 下根据 ABI 创建子目录，例如 armeabi-v7a x86，将之前编译出的 .a 文件放进对应的目录中。
在 jni/luajava/ 下创建 Android.mk，输入：
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := luajit # 预编译模块名称，任意。
# 指定静态库的位置。$(TARGET_ARCH_ABI)表示当前编译的ABI名称。
LOCAL_SRC_FILES := $(LOCAL_PATH)/$(TARGET_ARCH_ABI)/libluajit.a
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE     := luajava
LOCAL_SRC_FILES  := luajava.c
LOCAL_STATIC_LIBRARIES := luajit # 指定依赖的预编译模块名称。
include $(BUILD_SHARED_LIBRARY)
将需要的头文件复制到 jni/luajava/ 目录。
包括：lauxlib.h lua.h lua.hpp luaconf.h luajava.h luajit.h lualib.h
这些文件可以在 LuaJIT 的源码目录找到。

最后在模块的 build.gradle 文件的 android->defaultConfig 节点内添加下面代码：
ndk {
    abiFilters 'armeabi-v7a', 'x86' # 根据实际情况选择ABI（静态库对应文件夹必须存在）
}
编译完成后就可以愉快地使用 LuaJIT 了。

源码与懒人必备
源码已经在 github 了。
并且传到了 JCenter，无需自己编译，直接添加依赖就可以使用：

compile 'cc.chenhe:android-luajit:1.0.0' //注意自行替换最新版本