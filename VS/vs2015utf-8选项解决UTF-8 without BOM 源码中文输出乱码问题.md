# vs2015:/utf-8选项解决UTF-8 without BOM 源码中文输出乱码问题

10km 2018-05-05 11:17:36 15094 收藏 4
展开

本来我已经参考网上关于C++中文输出乱码的文章解决了,如下面的代码输出前调用wcout.imbue设置locale,就可以正常输出中文了。

std::wcout.imbue(std::locale(std::locale(), "", LC_CTYPE));
std::wcout << L"江清月近人" << std::endl;

    1
    2

但是同样的方法换在另一个程序中还是输出乱码。反复查找原因，最后发现是两个源码的编码格式不同。虽然都是UTF-8，但是能正确输出中文的源码文件是带BOM头的，另一个是不带BOM的。参考这个篇文章《MSVC中C++ UTF8中文编码处理探究》搞明白了MSVC对于不带BOM的UTF-8文件，默认会根据本地locale的设置来决定文件的编码(对于简体中文系统，就是GBK)。所以会对于UTF-8 without BOM的代码文件输出中文就是乱码。对于UTF-8 with BOM文件，会正确将其按照UTF-8来识别。
/utf-8 编译选项

MSVC对于UTF-8 without BOM格式支持不好，这个问题由来已久，在VS2015之前的版本一直存在。
在VS2015版本(Visual Studio 2015 Update 2)，增加一个编译选项/utf-8，该编译选项的作用就是将源码字符集和执行文件字符集指定为UTF-8。增加该编译选项后，再重新编译运行，程序正确输出中文，问题解决。
————————————————
版权声明：本文为CSDN博主「10km」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/10km/article/details/80203286