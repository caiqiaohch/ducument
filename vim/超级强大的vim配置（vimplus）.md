# vimplus

vimplus是vim的超级配置安装程序 

github地址：https://github.com/chxuan/vimplus.git，欢迎star和fork。

接触vim到现在也有几年了，但是之前用vim都是在网上找别人配置好了的vim，但是别人配置的始终都不能够满足自己的需求（自己需要有强大的C/C++代码提示补全功能、头文件/源文件切换、静态代码分析等功能），所以最近自己有时间，自己归纳了一些vim的插件，然后做成一键安装程序，供有相同需求的vimer们参考。

 

## 一、运行截图

该图是我配置过后vim的真实截图 [![enter image description here](https://raw.githubusercontent.com/chxuan/vimplus/master/screenshot.png)](https://raw.githubusercontent.com/chxuan/vimplus/master/screenshot/screenshot.png)

下面这幅图是借用[Valloric/YouCompleteMe](https://github.com/Valloric/YouCompleteMe)来展示强大的C++补全功能 [![enter image description here](https://camo.githubusercontent.com/1f3f922431d5363224b20e99467ff28b04e810e2/687474703a2f2f692e696d6775722e636f6d2f304f50346f6f642e676966)](https://camo.githubusercontent.com/1f3f922431d5363224b20e99467ff28b04e810e2/687474703a2f2f692e696d6775722e636f6d2f304f50346f6f642e676966)

## 二、安装配置(Ubuntu、Centos)

> - git clone https://github.com/chxuan/vimplus.git
> - cd ./vimplus
> - sudo ./setup.sh

运行setup.sh脚本程序将会自动安装并配置好vim，安装大约需要花费40分钟，主要是下载编译[Valloric/YouCompleteMe](https://github.com/Valloric/YouCompleteMe)比较耗时，请耐心等待直到安装完成^_^

## 三、主要功能快捷键

> - 查看文件目录(F3)
> - 显示函数、全局变量、宏定义(F4)
> - 显示静态代码分析结果(F5)
> - .h .cpp文件快速切换(F2)
> - 转到声明(f + u)
> - 转到定义(f + i)
> - 打开include文件(f + o)
> - 同一窗口buffer切换(Ctrl + P/Ctrl + N)
> - 光标位置切换(Ctrl + O/Ctrl + I)
> - 模糊查找当前目录及其子目录下的文件(Ctrl + f)

## 四、安装完成后

运行setup.sh脚本程序一键安装完成后，HOME目录将会存在[.ycm_extra_conf.py](https://raw.githubusercontent.com/chxuan/vimplus/master/.ycm_extra_conf.py)，该文件就是YCM实现C++等语言语法补全功能的配置文件，一般我会在HOME目录放一个，然后每一个项目拷贝一个[.ycm_extra_conf.py](https://raw.githubusercontent.com/chxuan/vimplus/master/.ycm_extra_conf.py)，更改[.ycm_extra_conf.py](https://raw.githubusercontent.com/chxuan/vimplus/master/.ycm_extra_conf.py)文件里面的flags 变量的值即可实现相关include文件的语法补全功能。

 

## 五、注意事项

1.如果网络条件不好可能安装失败，基本上是Valloric/YouCompleteMe安装失败，安装失败后需要将~/.vim/bundle文件夹下的YouCompleteMe目录删除，然后重新执行setup.sh即可，
重新安装时，程序将自动安装安装失败的插件。

2.在ubuntu16.04LTS下安装可能会失败(Valloric/YouCompleteMe安装失败)，因为vim默认支持python3进行插件编译，安装失败后，手动进入~/.vim/bundle/YouCompleteMe，然后运行python3 ./install.py --clang-completer即可。

兴趣是最好的老师，我的github地址：https://github.com/chxuan