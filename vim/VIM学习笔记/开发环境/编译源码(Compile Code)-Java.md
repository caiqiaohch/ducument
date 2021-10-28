# 编译源码(Compile Code)-Java

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

秉承Java语言“一次编写，处处运行（write once, run anywhere）”的宗旨。Java程序需要虚拟机JVM（Java Virtual Machine）来负责解释执行，而并非操作系统。也就是说，需要针对不同的操作系统安装不同版本的运行环境JRE（Java Runtime Environment）来运行Java程序。

如果需要开发Java程序，那么则需要安装JDK (Java Development Kit)，以完成下图所示的编译和执行过程。

![img](https://pic3.zhimg.com/80/v2-5e26b3092e02e26b7211141a43ad06b2_720w.jpg)

以下操作在[Fedora](https://link.zhihu.com/?target=https%3A//getfedora.org/)31下验证成功。在不同的操作系统中，以下命令和参数也可能略有不同，请根据实际情况进行调整。

## 安装Java

使用以下命令安装JDK（具体步骤可以参考[Installing Java](https://link.zhihu.com/?target=https%3A//docs.fedoraproject.org/en-US/quick-docs/installing-java/)）；

```bash
$ sudo dnf install java-1.8.0-openjdk-devel.x86_64
```

如果需要使用JWS（Java Web Start）以运行JNPL文件，那么还需要安装[IcedTea-Web](https://link.zhihu.com/?target=http%3A//icedtea.classpath.org/wiki/IcedTea-Web)：

```bash
$ sudo dnf install icedtea-web
```

## 配置Java

如果安装了多个版本的JDK、JRE、和JWS，那么可以使用以下命令进行切换：

```bash
$ alternatives --config java
```

![img](https://pic2.zhimg.com/80/v2-d3728d2ac5f12cb2b7f2c64df82403f5_720w.jpg)

```
$ alternatives --config javac
$ alternatives --config javaws
```

## 测试Java

使用以下命令，查看当前Java版本：

```bash
$ java -version
```

![img](https://pic4.zhimg.com/80/v2-ecadeb895fc3fe6a97dd196eac07fb8b_720w.jpg)

使用以下命令，查看当前Javac版本：

```bash
$ javac -version 
```

![img](https://pic1.zhimg.com/80/v2-fbd980775811025f4f583bf1818e9228_720w.jpg)

使用以下命令，查看当前Javaws版本：

```bash
$ javaws http://nextmidas.techma.com/nxm343/htdocs/localshell.jnlp
```

您可以尝试打开本地的JNPL文件，或者使用[IcedTea-Web-Tests](https://link.zhihu.com/?target=https%3A//icedtea.classpath.org/wiki/IcedTea-Web-Tests)提供的测试网址。

![img](https://pic1.zhimg.com/80/v2-7632f6ce91adc041bd8132c6c435ef28_720w.jpg)

## 设置编译器

使用以下命令，设置'makeprg'选项为javac命令：

```vim
:set makeprg=javac\ %
```

通过在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)文件中增加以下[自动命令](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-49-01-autocmd.html)，可以为Java语言文件设置编译快捷键：

```vim
augroup make_java
	au!
	au FileType java  set makeprg=set makeprg=javac\ %
	au FileType java  map <buffer> <leader><space> :w<cr>:make<cr>
augroup end
```

## 编译Java

使用以下命令，将根据'makeprg'选项进行编译，并生成与.java文件同名的.class字节码文件：

```vim
:make
```

如果编译出现错误，将在[QuickFix](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html)中显示错误列表，并自动跳转到第一个错误处：

![img](https://pic4.zhimg.com/80/v2-f77f5a77f6c9338323ea0c78cc2c514b_720w.jpg)

如果希望在编译时保持当前光标位置不变，那么可以使用以下命令：

```vim
:make!
```

使用`:cw`命令，将打开quickfix窗口。使用`:cp`命令，跳转到上一个错误；使用`:cn`命令，跳转到下一个错误。关于QuickFix操作的更多信息，请参阅[QuickFix](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html)章节。

在修复错误并成功编译之后，将显示命令输出：

![img](https://pic1.zhimg.com/80/v2-6780b30c98df84c23098dd2f5bd11808_720w.jpg)

使用以下命令，首先Java虚拟机将编译好的.class文件加载到内存，然后针对其中的Java类进行解释执行：

```vim
:!java %:r
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim--QuickFix-opt.html)>

编辑于 2020-03-28