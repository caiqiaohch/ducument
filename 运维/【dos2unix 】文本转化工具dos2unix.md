# 【dos2unix 】文本转化工具dos2unix

一、实验背景

各个平台使用的文本编码规范不同，导致了同一文本在不同平台中显示不同。

大家知道，windows中的文本文件的换行符是"\r\n"，而linux中是"\n"。由于换行符的不同，造成多行文本显示混乱，有时候会发生一些莫名其妙的状况。

DOS格式的文本文件在Linux下，用较低版本的vi打开时行尾会显示‘^M’，而且很多命令都无法很好的处理这种格式的文件，如果是个shell脚本，而Unix格式的文本文件在Windows下用Notepad打开时会拼在一起显示。

为了解决这个问题，我们可以使用文本转化工具dos2unix，该工具是一个工具集，包括unix2dos、unix2mac、dos2unix、mac2unix四个工具。

这些工具不仅可以解决回车符号不统一的问题，还可以将文本所使用的编码进行转化，支持的编码包括ASCII、ISO-8859-1、UTF-8、UTF-16。
二、工具安装

    # yum -y install dos2unix*

三、工具使用

对单个文件操作：

    # dos2unix  test.txt 

对多个文件操作：

    `# dos2unix  test1.txt  test2.txt` 

对整个目录中的文件做dos2unix操作：

    # find  /path/to/dir   -type f  -exec dos2unix {} \;

如果想把转换的结果保存在别的文件，而源文件不变，则可以使用-n参数

    # dos2unix  -n  oldfile   newfile

如果要保持文件时间戳不变，加上-k参数

    # dos2unix  -k  test1.txt  test2.txt 


在没有flip或者 dos2unix等小工具时，如何把unix文件和dos文件转换?

方法1：使用sed

dos转换unix 
    
    # sed -i 's/\r//' filename.txt

unix转换dos

    # sed -i 's/$/\r/'  filename.txt

方法二：使用vim

:setfileformat=dos 

:setfileformat=unix


unix2dos

unix2dos命令用来将UNIX格式文本文件转成DOS格式文件。 

unix2dos与dos2unix命令操作类似，不再赘述。


四、参考

https://www.jianshu.com/p/8571df3cc6ce

https://blog.csdn.net/leedaning/article/details/53024290