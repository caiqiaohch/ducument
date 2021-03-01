Sublime Text 安装及使用 & Ctags 配置

1.官网下载 Sublime Text 3, 安装

比如安装到 D:\Program Files\Sublime Text 3目录下

2.用 Sublime Text 3 加载工程

Project->Add Folder to project 加载所需要打开的工程，Ctrl + P 输入要打开的文件，支持模糊匹配。

3.安装 Package Control.sublime-package

Ctrl + ` (tab键上面的那个键) 调出 console，复制以下代码到命令行并回车。

import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())

如果失败，也可以在下面的链接手动下载，

https://sublime.wbond.net/Package%20Control.sublime-package

进入Preferences -> Browse Packages 的上层目录，找到 Installed Packages 文件夹，将下载好的 package 拷贝到里面，重启 Sublime Text 3。

4.安装 Ctags

Ctrl + shift +p , 输入 install, 选择 Package Control: Install Package 回车（如有异常，参考步骤7）

在跳出来的窗口中输入 ctags， 安装

下载 ctags 可执行程序，解压，将 ctags.exe 拷贝到 D:\Program Files\Sublime Text 3目录下。

http://prdownloads.sourceforge.net/ctags/ctags58.zip

Preferences -> Package settings -> Ctags -> Setting-User ,将以下代码拷贝到文件中。

{

"command": "D:/Program Files/Sublime Text 3/ctags.exe"

}

5.配置 ctags ,实现 ctrl + 左键 进行函数跳转

Preferences -> Package settings -> Ctags -> mouse bindings – user，将如下代码拷贝到文件里面。

[

    {

        "button": "button1",

        "count": 1,

        "press_command": "drag_select",

        "modifiers": ["ctrl"],

        "command": "navigate_to_definition"

    },

    {

        "button": "button2",

        "count": 1,

        "modifiers": ["ctrl"],

        "command": "jump_prev"

    }

]

6.Find -> CTags → Rebuild Tags  

rebuild完成就可以使用了。

7.遇到的难点

在整个安装过程中遇到的一个难题：Ctrl + shift +p , 输入 install, 选择 Package Control: Install Package 回车，跳出如下界面：

原因是channel_v3.json 下载失败，你用浏览器访问这个网址：https://packagecontrol.io/channel_v3.json

这是一个json，如果你联网了并且可以访问到，那么保存它，你会得到一个名为channel_v3.json的文件。实际上这个网页打不开，我是百度上搜出来下载了一个。

打开这个channel_v3.json的文件，全文查找，找到schema_version，你会发现后面跟着的是3.0.0，修改成2.0，注意，不是2.0.0！

然后把这个文件放在一个安全的地方,如 C:/D/usefullTools/，注意文件路径中不要有非ASCII字符或者空格，可能会有影响。

Preferences->Package Setting -> Package Control -> Settings -Default

会发现以下配置：

但由于这个文件是不能修改的，所以把这个配置配在下面这个文件。重启 Sublime 问题就解决了。

Preferences->Package Setting -> Package Control -> Settings -User



作者：不惧未来
链接：https://www.jianshu.com/p/895370affb36
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。