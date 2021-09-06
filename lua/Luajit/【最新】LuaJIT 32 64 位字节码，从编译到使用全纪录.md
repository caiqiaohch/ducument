# 【最新】LuaJIT 32/64 位字节码，从编译到使用全纪录

网上关于 LuaJIT 的讨论，已经显得有些陈旧。如果你对 LuaJIT 编译 Lua 源文件为具体的 32位或64位字节码，极其具体使用感兴趣的话，不妨快速读一下这篇文章。此文章针对尝试在 iOS 或 Android 上使用 LuaJIT 的小伙伴。限于篇幅，此处假定，你可以成功在 iOS/Android App 中集成了 LuaJIT,并且已经可以执行源码形式的 Lua 文件。

我忍不住在开头插一句： LuaJIT 编译后，只有约 600k,可能也就是一张图片的空间，但却可以让你的你App可以拥有一门完整的脚本语言的能力 -- 真的很酷！为许多问题，提供了许多新的思路，特别是 App 地动态性和可配置型方面。

环境
操作系统： macOS 10.13.4 【Linux 系统上，应该使用；Windows 系统上，仅供参考】

LuaJIT 版本： LuaJIT-2.1.0-beta3【官网最新版】

目录结构预定义
为了便于下文指令的说明，此处简单约定下目录结构。实际使用时，按需设置和整理即可。

tools：存放各种编译脚本和工具。
source：存放编译前的 Lua 源码。以后所有的 Lua 源码，都需要放在且只能放在此文件夹下。
output: 用于存放编译后的 Lua 字节码文件。
编译加密工具
Lua 的加密工具，本质上就是 Lua 的解释器。此处使用的解释器源码是 LuaJIT。LuaJIT 执行效率最高，且编译出来的字节码无法逆向为 Lua 源码，更能保证源码安全性。LuaJIT 支持交叉编译，即可以在电脑上编译出 iOS 或 Android 手机上系统需要的字节码。如此，我们只需要编译一次 32 和 64 位的 LuaJIT 解释器各一个，备份存档，后续可直接使用。

编译 LuaJIT 解释器，直接用官方的推荐指令即可。比较特殊的一点时，如果是想编译出 64 位 LuaJIT，需要加上参数 CFLAGS=-DLUAJIT_ENABLE_GC6。

# cd 到 LuaJIT 源码目录
cd tools/LuaJIT-2.1.0-beta3

# 编译 32 位 LuaJIT 解释器
make clean && make && cp src/luajit ../luajit-32 && make clean

# 编译 64 位 LuaJIT 解释器
make clean && make CFLAGS=-DLUAJIT_ENABLE_GC64 && cp src/luajit ../luajit-64 && make clean
注意：重新解压源码后，可能需要重新启动命令行/终端，来清除可能的系统缓存，才能正确 build 出想要的东西。

加密 Lua 源文件
所谓的加密 Lua 源文件，其实就是把 Lua 源文件，编译为 LuaJIT 字节码。相对于 Luac ，LuaJIT 字节码执行效率更高，而且无法被直接逆向为对应的 Lua 源码。

编译字节码，用的是 -b 命令，需要注意的是，一定要使用对应字节的 LuaJIT 解释器来编译，否则 iOS/Android App 中，可能无法加载。

编译后的字节码文件的后缀，可以根据自己需要自定义。此处我使用的是 “.yan” 和 “.yan64”。

# 编译32位字节码 ，适用于Android全部手机，部分 iOS 手机。
./tools/luajit-32 -b ./source/main.lua ./output/main.yan

# 编译64位字节码，仅用于部分 iOS 手机。
./tools/luajit-64 -b ./source/main.lua ./output/main.yan64
注意： 敏感信息，不要直接以常量字符串的形式使用。

在 iOS 中，根据不同的 CPU， 加载不同的字节码。
在 Android 手机上，一般只需要使用 32 位的 LuaJIT 字节码文件即可。iOS 上，情况比较复杂，从 iOS11 之后，iOS 要求相对的库必须有64位版本。也就意味着，如果 App 想兼容 iPhone5s 以前的 32位CPU的设备的话，就必须在项目中同时放置32位和64位的LuaJIT静态库。关于适用于手机端的 LuaJIT 静态库的编译问题，暂不进一步展开。此处只讨论，如何在 iOS 中，动态根据需要准确加载对应的 32 或 64 位的 LuaJIT 字节码文件。

基于上文的讨论，此处给出一个简单的策略：

Lua 源文件，同时编译生成32位和64位字节码的文件。
编译后的字节码文件，仅文件后缀不同，文件路径的其他部分保证是完全一致的。如 main.yan 和 main.yan64 是由 main.lua编译得到。
在 iOS App 运行时，动态根据当前真正运行的是 32 还是 64 位的 LuaJIT 解释器，来选择对应的字节码文件后缀即可。
分享一个 swift 版的实现：

    private func luaFileSuffix() -> String{
        #if (arch(i386) || arch(arm))
        return ".yan"
        #else
        return ".yan64"
        #endif
    
    }
参考文章
How to determine if compiling for 64-bit iOS in Xcode

Running LuaJIT

Cross-compiling LuaJIT 部分很值得读