《Ogre一步一步学开发》 一、Ogre源码编译与安装，从源代码开始构建Ogre图文教程(Ogre 1.12.1 Source + VS2019 + Windows10)

一、电脑需要已经安装下列软件环境：

Visual Studio 2019
下载地址：https://visualstudio.microsoft.com/zh-hans/downloads/
CMake 3.14.5
下载文件 cmake-3.14.5-win64-x64.msi 后安装
下载地址： https://cmake.org/download/
DirectX SDK
① 下载文件 DXSDK_Jun10.exe 后安装即可。
DXSDK_Jun10.exe下载地址：https://www.microsoft.com/en-us/download/details.aspx?id=6812
② 如果系统已经安装过
Microsoft Visual C++ 2010 x86 Redistributable - 1010.0.40219
Microsoft Visual C++ 2010 x64 Redistributable - 1010.0.40219
则会出现【错误Error Code:s1023】提示，卸载更高版本的
Microsoft Visual C++ 2010 x86 Redistributable - 1010.0.40219
Microsoft Visual C++ 2010 x64 Redistributable - 1010.0.40219
再重新安装DXSDK_Jun10.exe 即可，安装完后，下载1010.0.40219版升级回来即可。
Visual C++ 2010 Redistributable下载地址：http://www.microsoft.com/en-us/download/details.aspx?id=26999
二、Ogre源码编译与安装
4. 配置过程
① 下载Ogre编译所需要的依赖项：ogredeps ；https://bitbucket.org/cabalistic/ogredeps/downloads/
② 下载Ogre源码1.12.1（OGRE 1.12.1 source） https://www.ogre3d.org/download/sdk
此源码非常难下载，需要在早晨7点以前下载，否则速度太慢就中间断掉了。
③ 下载SDL库，为了修复一个CMake config过程中遇到的问题； https://www.libsdl.org/hg.php
④ 解压下载下来的ogre-1.12.1，将其更名为OgreSDK，将它放到（例如）：D:\Ogre\OgreSDK
⑤ 右键单击 这台电脑->属性->高级系统设置->高级->环境变量，在“用户变量”中增加变量 OGRE_HOME，值为 D:\OGRE\OgreSDK。

CMake对Orge依赖项进行编译
① 解压下载下来的ogredeps，将cabalistic-ogredeps-xxxxxx，放至：D:\Ogre\OgreSDK
② 解压下载下来的SDL-2.0.xxxxx，将文件夹更名为SDL2，将SDL2复制到（例如）D:\Ogre\OgreSDK\cabalistic-ogredeps-dbf4f822eb78\src中
③ 打开 CMake(cmake-gui)，进入 D:\OGRE\OgreSDK\cabalistic-ogredeps-dbf4f822eb78 目录，把 CMakeLists.txt 拖到CMake空白处，点击 Configure，选择Visual Studio 16 2019， X64，点击 Finish。第一次 Configure 结束后，会出现很多红色提示，这时再点一次 Configure，红色提示消失。Configuring done 之后，点击 Generate 就可以了

在 D:\OGRE\OgreSDK\cabalistic-ogredeps-dbf4f822eb78 目录下生成了 OGREDEPS.sln 文件
① 打开OGREDEPS.sln之后，右键单击 ALL_BUILD，点击生成。

这时提示有一项生成失败了。
根据提示打开 D:\OGRE\OgreSDK\cabalistic-ogredeps-dbf4f822eb78\src\SDL2-prefix\src\SDL2-stamp 目录下的 SDL2-MoveInstallFiles-err.log，报错信息：

这个意思是在 bin 文件夹下缺少 SDL2.dll 这个文件。但具体是哪个 bin 文件夹呢？

由于我们的输出目录为 D:\OGRE\OgreSDK\cabalistic-ogredeps-dbf4f822eb78\ogredeps，所以是 ogredeps\bin 下缺少 SDL2.dll。进入这个目录，打开 bin 文件夹，可以看到只有 SDL2d.dll 文件，那么去哪找到 SDL2.dll 文件呢？

其实，SDL2d.dll 说明是 Debug 模式下生成的。所以如果需要 SDL2.dll 文件，我们可以切换成 Release 模式进行生成。

生成成功！

查看一下文件夹：

里面没有 SDL2.dll。只需打开眼前的 Debug 或者 Release 文件夹，把里面的 SDL2.dll 拷贝出来到 bin 文件夹即可：

切换回 Debug 模式，重新生成一下即可：

ALL_BUILD 生成成功：

② 生成一下INSTALL项目（Debug 和 Release 模式都要）：



生成成功之后，关闭VS。

③ 在 D:\OGRE\OgreSDK\cabalistic-ogredeps-dbf4f822eb78\ 目录下会出现 ogredeps 文件夹，将它拷贝到 D:\OGRE\OgreSDK\ 目录下，并重命名为 Dependencies，然后再拷贝出一次。注意检查 Dependencies 文件夹中这4个子文件夹是否都在：


到 D:\OGRE\OgreSDK\ 目录下，把 CMakeLists.txt 拖到CMake空白处，
source code：D:/OGRE/OgreSDK
Where to build the binaries：D:/OGRE/OgreSDK/ogredeps
按照第5步③小步的方式，选好VS版本，然后两次 Configure，一次 Generate 即可。
① 不过在第二次 Configure 时可能会出现警告。这是由于没有安装boost库导致的，对boost没有需求的话可以不用安装。
boost库 下载地址：http://www.boost.org/users/download/
windows下编译和安装boost库：https://www.cnblogs.com/cmranger/p/4759223.html
② Error in configuration process, project files may be invalid 错误：
Where to build the binaries：设置为 D:/OGRE/OgreSDK/ 时会出现下列错误


Where to build the binaries：必须设置成 D:/OGRE/OgreSDK/ogredeps 才行。
CMake如果中间卡住不动，则关闭，重启计算机后，再次编译即可。

双击打开 D:\OGRE\OgreSDK\ogredeps 目录下生成的 OGRE.sln 文件，在 Debug 和 Release 模式下分别生成一次 ALL_BUILD 和 INSTALL。这要花费很长时间。

现在运行一下样例库，看看精彩纷呈的Ogre原生例子吧！D:\OGRE\OgreSDK\ogredeps\bin\Release\SampleBrowser.exe，点击运行。

参考文献：

https://www.jianshu.com/p/ce27903a6784
https://blog.csdn.net/joyzhouyj/article/details/94025344
https://blog.csdn.net/ddogyuan/article/details/79559667
————————————————
版权声明：本文为CSDN博主「超级任性」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/StudyOgre/article/details/89058218