 OpenGL学习----程序库编译-glew
2.2 glew

2.2.1 简介
OpenGL扩展Wrangler库(GLEW)是一个跨平台的开源C/C++扩展加载库。GLEW提供了高效的运行时机制来确定目标平台上支持哪些OpenGL扩展。OpenGL核心和扩展功能在单个头文件中公开。
特征：

    支持核心OpenGL 4.6和超过399个扩展
    在Windows，Linux，Mac OS X，FreeBSD，Irix和Solaris上进行了测试
    根据OpenGL扩展规范自动生成代码
    对多个渲染上下文的线程安全支持
    扩展支持验证实用程序

2.2.2 库文件和编译工具准备
从http://glew.sourceforge.net/index.html下载glew。
从https://cmake.org/download/下载CMake编译工具。
2.1.3 编译glew库
将下载的glew库文件glew-2.1.0.zip解压。然后打开cmake工具，选择CMakeLists.txt文件所在的文件夹(glew-2.1.0\build\cmake)以及编译文件夹路径，如下图：


点 Configure 选择编译器和编译的版本类型(x64 或 win32)：


点Finish后，开始进行默认配置：


配置完成如下：


下面需要根据你自己的需求配置编译选项。设置如下：
（1）默认字符集为使用多字节字符集、默认运行时库为MTd，想要修改为字符集使用Unicode，修改运行时库使用MDd,需要打开CMakeLists.txt，在文件中增加下面这行内容：
add_definitions(-MDd -DUNICODE -D_UNICODE)


（2）若想将编译之后的 lib 和头文件输出到指定文件夹下，则需要设置CMARK_INSTALL_PREFIX 后的路径：


接下来重新点击下 Configure，则 CMake 会根据修改后的参数重新配置项目:


然后点generate开始生成解决方案：


然后打开解决方案，准备编译：


对ALL_BUILD进行生成：


对INSTALL进行生成：


生成成功后，我们能看到在cmake中设置的生成文件路径：


以及库文件：


至此glew库编译完成。
