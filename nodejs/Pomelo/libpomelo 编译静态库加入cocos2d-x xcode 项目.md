从 https://github.com/NetEase/libpomelo 下载最新版，解压，进入目录编译静态库

./pomelo_gyp -DTO=ios
./build_ios
./build_iossim
分别生成了ios设备(arm)和ios虚拟机(i386)的静态库，用lipo把两个打包在一起：

lipo -create ./build/Default-iphoneos/libpomelo.a  ./build/Default-iphonesimulator/libpomelo.a  -output libpomelo.a
lipo -create ./deps/jansson/build/Default-iphoneos/libjansson.a ./deps/jansson/build/Default-iphonesimulator/libjansson.a  -output libjansson.a
lipo -create ./deps/uv/build/Default-iphoneos/libuv.a ./deps/uv/build/Default-iphonesimulator/libuv.a  -output libuv.a
在xcode中打开cocos2d-x 项目，在项目target “Build Phases"将生成的3个 .a 静态库文件加入到 "Link Binary With Libraries" 里；
在"Build Settings" 的 “Header Search Paths” 里加入三个目录：

libpomelo/include

libpomelo/deps/jansson/src

libpomelo/deps/uv/include

注意目录的绝对和相对位置

这样就可以同时在真机和模拟器里调用libpomelo静态库了。

（为方便项目共享可以把 .a 静态库文件和 .h 头文件都拷贝到项目 libs/libpomelo 里）
————————————————
版权声明：本文为CSDN博主「iwangdy」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/Aryang/article/details/8875603