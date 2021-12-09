# 解决vim E492: Not an editor command: ^M

问题描述
今天修改了一下实验室服务器的vim配置文件，直接将windows下的vim配置文件_vimrc拷贝到了服务器上，重命令为.vimrc，本指望实现共用配置文件。但在启动vim时却报了Not an editor command: ^M的错误。

vim E492: Not an editor command: ^M
1
问题解析
而*nix的文件换行符为\n，但windows却非要把\r\n作为换行符，所以，vim在解析从windows拷贝到mac的的vimrc时，因为遇到无法解析的\r，所以报错。
这个简单，用vim的神替换功能处理一下就好：

:%s/^M//gc
1
g选项表示全局替换，c选项表示每次替换都需要确认。
但要注意：这里的^M是特殊字符，并不是使用^和M两个字符输入的，而是通过两个组合键C-V C-M输入的（C代指Ctrl），当然，^M也可以使用\r表示。
但奇怪的是，我在替换之后，打开vim时还是报这个错误。在vim中仔细一看，.vimrc的文件格式还是dos格式，于是，使用以下命令将文件彻底转换为unix格式：

:set fileformat=unix
1
好了，保存，再启动vim时就没有错误了。

————————————————
版权声明：本文为CSDN博主「CHENG Jian」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/gatieme/article/details/50541642