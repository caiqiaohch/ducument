# 在vim中显示目录树

虽然用vim也有很长一段时间了，但是很少在vim中浏览文件目录。链接中的几篇文章介绍了几种方法，摘要如下：



netrw

 - https://shapeshed.com/vim-netrw/

 - vim自带的文件浏览器

 - 使用方法 :Explore, :Sexplore, :Vexplore, or :Sex, :Vex

 - 通过按键i来得到文件目录的不同视图

 - 设置默认视图：let g:netrw_liststyle = 3

 - 不显示横幅（说明文字）按键I, let g:netrw_banner = 0

 - 文件打开方式 let g:netrw_browse_split = 1

 - 用netrw来实现NERDtree



NERDtree

 - https://medium.com/@victormours/a-better-nerdtree-setup-3d3921abc0b9

 - https://medium.com/usevim/nerd-tree-guide-bb22c803dcd2

 - 在vim中创建或移动文件

 - 在vim启动时默认打开NERDtree

 - 与Git集成：用于显示哪个文件被修改了

 - 在打开一个文件时自动关闭NERDtree

 - 如果NERDtree是仅存的窗口，自动关闭标签页

 - 一些按键指令：

 - t 在一个tab中打开选定的文件

 - i 水平分割窗口

 - s 垂直分割窗口

 - I 隐藏或显示文件

 - m 显示NERD tree菜单

 - R 刷新

 - ？
————————————————
版权声明：本文为CSDN博主「gaojijun_bit」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/gaojijun_bit/article/details/79349107