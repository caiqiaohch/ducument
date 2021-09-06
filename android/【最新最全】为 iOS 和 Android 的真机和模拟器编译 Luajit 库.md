# 【最新最全】为 iOS 和 Android 的真机和模拟器编译 Luajit 库

编译 Luajit 库，的确是一个挑战。因为官网的教程，在当前版本的 Xcode 和 NDK 环境中，已经不适用了。以前只是编译了适用于真机的 Luajit 库。最近在尝试编译模拟器 Luajit 库，就顺便梳理了下 Luajit 库的编译经验，供以后查阅。网上的讨论也是有一些，但是相当一部分都已经过时。或许等你看到这篇文章的时候，可能也只是能获得一些可能的经验来解决自己的编译问题。所以说，了解一些基本的编译知识，能勉强看懂 Luajit 的 make 文件，还是很有必要的。本篇是关于 Luajit 静态库的，如果你想找的是如何编译适用于移动端的 Luajit 字节码，可以直接看 【最新】LuaJIT 32/64 位字节码，从编译到使用全纪录。

编译环境
等你试着自己交叉编译 Luajit 库时，就会明白环境的影响到底有多大。

macOS 10.13.4

Xcode 9.4.1

Android Studio 3.1.3

先约定下基本的路径信息,供下文使用

├── LuaJIT-2.1.0-beta3
├── build-android.sh
├── build-ios.sh
├── lib
│   ├── android
│   │   ├── arm64-v8a
│   │   ├── armeabi
│   │   ├── armeabi-v7a
│   │   └── x86
│   └── ios
│       └── libluajit2.1.0-beta.3.a
编译适用于 iOS 的 Luajit 库，可能会遇到的问题
编译前的准备
需要先把 Luajit 源码的 lj_arch.h 547 行，从

#if LJ_TARGET_CONSOLE || (LJ_TARGET_IOS && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0)
#define LJ_NO_SYSTEM        1
#endif
改为：

 #define LJ_NO_SYSTEM        1
否则会触发错误:

./lib_os.c:52:14: error: 'system' is unavailable: not available on iOS
问题的原因大致是，此处的判断，已经在最新的 Xcode 极其编译环境中，无法争取工作。对此问题的根源感兴趣的童鞋，请自行阅读 Luajit 的 make 文件。

注意：编译 Android 或其他平台库时，不需要修改此处源码。

完整的 iOS 编译命令： build-ios.sh
建议最好以 sh 文件的方式，直接执行，在命令行输入，可能会触发诡异的未知问题。其中一个很关键的原因是： 在复制粘贴指令时，部分文本编辑器（比如 mac 上的备忘录）会混入特殊字符，导致编译指令运行失败。

#!/bin/bash
# LuaJIT 的源码路径
LUAJIT=./LuaJIT-2.1.0-beta3
XCODEPATH=`xcode-select -print-path`
DEVDIR=$XCODEPATH/Platforms
IOSVER=iPhoneOS.sdk
SIMVER=iPhoneSimulator.sdk
# 库的最总名称
LIBNAME=libluajit2.1.0-beta.3.a
# iOS 最低兼容版本,最好与需要嵌入 LuaJIT 的 App 的最低兼容设置保持一致.
MINVERSION=9.0
IOSDIR=$DEVDIR/iPhoneOS.platform/Developer
SIMDIR=$DEVDIR/iPhoneSimulator.platform/Developer
# xctoolchain 可以使用 xcode-select --install 命令安装.
# xctoolchain 和模拟器中, 目前已不包含 gcc 等命令,可以从系统其它位置复制到 $IOSBIN 目录.
# 命令的具体路径,可以执行 xcodebuild -find gcc 获得.
IOSBIN=$XCODEPATH/Toolchains/XcodeDefault.xctoolchain/usr/bin/
SIMBIN=$SIMDIR/usr/bin/
BUILD_DIR=$LUAJIT/build
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
rm *.a 1>/dev/null 2>/dev/null
echo =================================================
echo ARMV7 Architecture
ISDKF="-arch armv7 -isysroot $IOSDIR/SDKs/$IOSVER -miphoneos-version-min=$MINVERSION"
make -j -C $LUAJIT HOST_CC="gcc -m32 " CROSS=$IOSBIN TARGET_FLAGS="$ISDKF" TARGET=armv7 TARGET_SYS=iOS clean
make -j -C $LUAJIT HOST_CC="gcc -m32 " CROSS=$IOSBIN TARGET_FLAGS="$ISDKF" TARGET=armv7 TARGET_SYS=iOS
mv $LUAJIT/src/libluajit.a $BUILD_DIR/libluajitA7.a
echo =================================================
echo ARM64 Architecture
ISDKF="-arch arm64 -isysroot $IOSDIR/SDKs/$IOSVER -miphoneos-version-min=$MINVERSION"
make -j -C $LUAJIT HOST_CC="gcc " CROSS=$IOSBIN TARGET_FLAGS="$ISDKF" TARGET=arm64 TARGET_SYS=iOS clean
make -j -C $LUAJIT HOST_CC="gcc " CROSS=$IOSBIN TARGET_FLAGS="$ISDKF" TARGET=arm64 TARGET_SYS=iOS
mv $LUAJIT/src/libluajit.a $BUILD_DIR/libluajit64bit.a
echo =================================================
echo IOS Simulator Architecture
ISDKF="-arch x86_64 -isysroot $SIMDIR/SDKs/$SIMVER -miphoneos-version-min=$MINVERSION"
make -j -C $LUAJIT HOST_CFLAGS="-arch x86_64" HOST_LDFLAGS="-arch x86_64" TARGET_SYS=iOS TARGET=x86_64 clean
make -j -C $LUAJIT HOST_CFLAGS="-arch x86_64" HOST_LDFLAGS="-arch x86_64" TARGET_SYS=iOS TARGET=x86_64 amalg CROSS=$SIMBIN TARGET_FLAGS="$ISDKF"
mv $LUAJIT/src/libluajit.a $BUILD_DIR/libluajitx86_64.a
libtool -o $BUILD_DIR/$LIBNAME $BUILD_DIR/*.a 2> /dev/null
mkdir -p $BUILD_DIR/Headers
cp $LUAJIT/src/lua.h $BUILD_DIR/Headers
cp $LUAJIT/src/lauxlib.h $BUILD_DIR/Headers
cp $LUAJIT/src/lualib.h $BUILD_DIR/Headers
cp $LUAJIT/src/luajit.h $BUILD_DIR/Headers
cp $LUAJIT/src/lua.hpp $BUILD_DIR/Headers
cp $LUAJIT/src/luaconf.h $BUILD_DIR/Headers
mv $BUILD_DIR/$LIBNAME ./lib/ios
rm -rf $BUILD_DIR
cd $LUAJIT
make clean
cd ..
编译脚本运行方法：
chmod a+x build-ios.sh
./build-ios.sh
其他可能遇到的问题
/Applications/Xcode.app/Contents/Developer/Platforms/Toolchains/XcodeDefault.xctoolchain/usr/bin/gcc command not found
1> 先安装 toolchains:

xcode-select --install
2> 找下缺失本机上对应命令的真实路径：

xcodebuild -find gcc
3> 如果能找到，就把命令复制到缺失命令的位置；如果本机找不到，就从网上搜下安装教程。

针对模拟器的额外设置
由于iphone5s以上虚拟机需要x86_64支持，luajit为了支持此模式需要在other linker flags中增加参数(注意，只需要对模拟器添加参数，针对ios不能添加，否则apple不会通过审核)：
-pagezero_size 10000 -image_base 100000000
网上类似的描述很多，也很准确，我想补充的是：最好只在 Debug 模式下的配置中增加上述特殊参数。

另外，如果你已经在使用 Luajit 的字节码，请注意模拟器 Luajit 库，需要加载的是 32 位字节码。

编译适用于 Android 的 Luajit 库，可能会遇到的问题
完整的 Android 编译命令： build-android.sh
#!/bin/bash
# LuaJIT 的源码路径
LUAJIT=./LuaJIT-2.1.0-beta3
cd $LUAJIT
#编译 android-x86
make clean
NDK=~/library/android/sdk/ndk-bundle
NDKABI=17
NDKTRIPLE=x86
NDKVER=$NDK/toolchains/$NDKTRIPLE-4.9
NDKP=$NDKVER/prebuilt/darwin-x86_64/bin/i686-linux-android-
NDKF="-isystem $NDK/sysroot/usr/include/i686-linux-android -D__ANDROID_API__=$NDKABI -D_FILE_OFFSET_BITS=32"
NDK_SYSROOT_BUILD=$NDK/sysroot
NDK_SYSROOT_LINK=$NDK/platforms/android-$NDKABI/arch-x86
make HOST_CC="gcc-4.9 -m32" CROSS=$NDKP TARGET_FLAGS="$NDKF" TARGET_SYS=Linux TARGET_SHLDFLAGS="--sysroot $NDK_SYSROOT_LINK"  TARGET_LDFLAGS="--sysroot $NDK_SYSROOT_LINK" TARGET_CFLAGS="--sysroot $NDK_SYSROOT_BUILD"
mv ./src/libluajit.a "../lib/android/x86/libluajit.a"
#编译 android-armeabi
make clean
NDK=~/Library/Android/sdk/ndk-bundle
NDKABI=17
NDKTRIPLE=arm-linux-androideabi
NDKVER=$NDK/toolchains/$NDKTRIPLE-4.9
NDKP=$NDKVER/prebuilt/darwin-x86_64/bin/$NDKTRIPLE-
NDKF="-isystem $NDK/sysroot/usr/include/$NDKTRIPLE -D__ANDROID_API__=$NDKABI -D_FILE_OFFSET_BITS=32"
NDK_SYSROOT_BUILD=$NDK/sysroot
NDK_SYSROOT_LINK=$NDK/platforms/android-$NDKABI/arch-arm
make HOST_CC="gcc-4.9 -m32" CROSS=$NDKP TARGET_FLAGS="$NDKF" TARGET_SYS=Linux TARGET_SHLDFLAGS="--sysroot $NDK_SYSROOT_LINK"  TARGET_LDFLAGS="--sysroot $NDK_SYSROOT_LINK" TARGET_CFLAGS="--sysroot $NDK_SYSROOT_BUILD"
mv ./src/libluajit.a ../lib/android/armeabi/libluajit.a
#编译 android-armeabi-v7a
make clean
NDK=~/Library/Android/sdk/ndk-bundle
NDKABI=17
NDKTRIPLE=arm-linux-androideabi
NDKVER=$NDK/toolchains/$NDKTRIPLE-4.9
NDKP=$NDKVER/prebuilt/darwin-x86_64/bin/$NDKTRIPLE-
NDKF="-isystem $NDK/sysroot/usr/include/$NDKTRIPLE -D__ANDROID_API__=$NDKABI -D_FILE_OFFSET_BITS=32"
NDK_SYSROOT_BUILD=$NDK/sysroot
NDK_SYSROOT_LINK=$NDK/platforms/android-$NDKABI/arch-arm
NDKARCH="-march=armv7-a -mfloat-abi=softfp -Wl,--fix-cortex-a8"
make HOST_CC="gcc-4.9 -m32" CROSS=$NDKP TARGET_FLAGS="$NDKF $NDKARCH" TARGET_SYS=Linux TARGET_SHLDFLAGS="--sysroot $NDK_SYSROOT_LINK"  TARGET_LDFLAGS="--sysroot $NDK_SYSROOT_LINK" TARGET_CFLAGS="--sysroot $NDK_SYSROOT_BUILD"
mv ./src/libluajit.a ../lib/android/armeabi-v7a/libluajit.a
#编译 android-arm64-v8a
make clean
NDK=~/Library/Android/sdk/ndk-bundle
NDKABI=21
NDKTRIPLE=aarch64-linux-android
NDKVER=$NDK/toolchains/$NDKTRIPLE-4.9
NDKP=$NDKVER/prebuilt/darwin-x86_64/bin/$NDKTRIPLE-
NDKF="-isystem $NDK/sysroot/usr/include/$NDKTRIPLE -D__ANDROID_API__=$NDKABI"
NDK_SYSROOT_BUILD=$NDK/sysroot
NDK_SYSROOT_LINK=$NDK/platforms/android-$NDKABI/arch-arm64
make HOST_CC="gcc-4.9" CROSS=$NDKP TARGET_FLAGS="$NDKF" TARGET_SYS=Linux TARGET_SHLDFLAGS="--sysroot $NDK_SYSROOT_LINK"  TARGET_LDFLAGS="--sysroot $NDK_SYSROOT_LINK" TARGET_CFLAGS="--sysroot $NDK_SYSROOT_BUILD"
mv ./src/libluajit.a ../lib/android/arm64-v8a/libluajit.a
make clean
注意：此处共编译了 arm64-v8a，armeabi-v7a，armeabi，x86 四种CPU架构的库。其中 arm64-v8a 并没有使用，因为它会引起诡异的兼容适配问题。初步怀疑和不同厂商魔改 ROM 实现有关。期待看到小伙伴们的进一步深入解读~

参考文章：
https://github.com/rampantpixels/lua_lib/blob/master/lua/luajit/build-ios.sh

https://github.com/cailei/luajit/blob/master/build-luajit-ios.sh

https://blog.csdn.net/dragoncheng/article/details/43482109

https://www.cnblogs.com/HemJohn/p/5429041.html

https://www.jianshu.com/p/308d7be8b8df

https://stackoverflow.com/a/12228575

http://www.codexiu.cn/android/blog/14563/

https://github.com/twilio/twilio-boost-build/issues/1