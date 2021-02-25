将Sublime Text打造为轻量级的C++ IDE

本文较为详细地介绍了在Windows和Ubuntu系统下，如何配置Sublime Text的C++编译运行环境。目前实现了了可以在Sublime Text按下快捷键后，调出CMD或者终端来运行C/C++程序，从而解决了Sublime Text无法接收输入的问题。
另外本文也介绍了一些Sublime Text的使用和用户配置备份的方法，具有一定的参考作用。
1. 使用背景

现在搞ACM-ICPC的比赛，经常写算法程序。说一说使用过的IDE吧：

    Visual Studio 2013
    配合Visual Assist插件真的非常好用，没有之一！无论是写程序或者调试代码都能非常优雅地完成！当然我只用到了这个它的一小部分，不过我感觉这种企业级别的IDE绝对是写工程的不二选择。可惜在比赛时并不会提供这么优秀的IDE，而且像Visual Studio这种IDE比较吃机器配置。以前没有加固态硬盘时，打开工程的速度简直是要令人发狂的。

    CodeBlock
    比赛举办方通常提供的IDE，一个开源的轻量级的IDE。体积不大，功能也比较齐全，调试程序没有Visual Studio优雅，能满足写小型程序的要求。应对写比赛程序，上学时写的作业程序也是绰绰有余了。至于缺点，个人觉得是：界面不美观，虽然可以自己调字体，颜色等等，但是整个IDE给我的感觉就是不好看。另外在官网下载的速度非常非常慢，挂上ss下载也还是经常失败，我都是用网盘离线下载之后再从网盘上下载下来的。

    Sublime
    这个说不上是一款IDE，Sublime只是一个文本编辑器。但正如其官网所说的：

        Sublime Text is a sophisticated text editor for code, markup and prose.
        You’ll love the slick user interface, extraordinary features and amazing performance.

    作为一个颜控，我一下子就被它的外观吸引到啦。其实Sublime本身的功能就挺强大的，加上丰富的插件，足以配置出一款适合自己的轻量级IDE。本文中使用的Sublime版本是Sublime Text Build 3103，现在开始我们的搭建之旅。

2. 下载安装

官网下载。Sublime Text是需要激活的，当然你不激活也可以正常使用，只是它会时不时提醒你而已。有能力的话，还是可以支持一下这么优秀的一款软件~
2.1 插件安装

    安装Package Control:
    在Sublime Text中使用快捷键ctrl+`调出console或者点击：View->Show Console.然后把以下代码(适用于Sublime Text 3)复制进去:

     import urllib.request,os,hashlib; h = '6f4c264a24d933ce70df5dedcf1dcaee' + 'ebe013ee18cced0ef93d5f746d80ef60'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)

    重启Sublime Text

    在Perferences->package settings中看到package control这一项，则安装成功。

    Ctrl+Shift+p调出命令面板，选择Install Package并回车，在弹出的界面输入你想要安装的插件名字，回车安装即可。

    这里给出一些我用到的插件：
        ConvertToUTF8: 解决中文在sublime中乱码的问题
        SyncedSideBarBg: 解决sidebar颜色和sublime背景不统一的问题
        SideBarEnhancements: 侧边栏增强
        SublimeAStyleFormatter：c/c++/c#/java代码格式化工具

    备注
        打开sidebar的方法：快捷键Ctrl+k,Ctrl+b或者View->SideBar->Show SideBar
        要使用SideBarEnhancements需要在File->Open Folder中打开一个文件夹，才能在sidebar中进行新建，删除等操作。
        插件的设置可以在：Perferences->package settings进行如用户配置，快捷键配置等设置

3. 配置C++编译环境

    下载编译器（已有的可以跳过此步)：MinGW或者tdm gcc二选一即可。推荐用tdm gcc。
    安装地址：minGW、tdm-gcc。鉴于外国网站网速感人，下面丢两个我离线下载到百度网盘的版本,如失效可留言：minGW 网盘地址、tdm gcc网盘地址。最新版本请以第1,2条下载地址的为准。

    tdm gcc的安装过程非常简单，下载下来直接next,next,next就可以了。MinGW的安装过程稍稍麻烦一些。把之前的minGW安装器安装完之后打开，如图勾选勾选，然后在Installation->Apply Changes。

    设置环境变量（win10环境）：此电脑->属性->高级系统设置->环境变量->系统变量中的path->添加你的编译器路径下的bin目录。比如我的minGW安装路径是：C:\MinGW,则添加C:\MinGW\bin。我的tdm gcc安装路径是: C:\TDM-GCC-64，则添加C:\TDM-GCC-64\bin。按你安装的编译器是什么来选择，这里注意查看这个bin目录下是否有g++.exe,gcc.exe等，有则是正常的路径。

    测试g++/gcc环境：在cmd中输入g++ -v
    g++/gcc环境

    在Sublime Text中编写cpp程序测试：
    在Sublime Text新建文件test.cpp并按ctrl+b编译输出。测试成功如图所示cpp测试。（注：你可以在tool->build-system中选择编译系统。）

3.1 Sublime build System配置

很快你会发现，按上面的方法写出来的程序只能输出，不能输入。不像我们在IDE上面编写的程序那样，执行的时候会弹出CMD来接受输入，那么这时候我们需要自定义一个Sublime build System

    首先花一点点时间来了解一些基础知识：

        sublime build system目录:

         {
             "folders":
             [
                 {
                     "follow_symlinks": true,
                     "path": "."
                 }
             ],
             "build_systems":
             [
                 {
                     // 在选定 Tools | Build System | Automatic 时使用。Sublime Text使用这个 选择器自动为活动试图选择构建系统
                     "selector": "source.python",
                     // 在运行``cmd``前会切换到该目录。运行结束后会切换到原来的目录。
                     "working_dir":"D:/Developer/pyenv/python27",
                     // 输出``cmd``的编码。必须是合法的Python编码，缺省为``UTF-8``
                     "encoding":"UTF-8",
                     // 在环境变量被传递给``cmd``前，将他们封装成词典。
                     "env": {"PYTHONPATH":"."},
                     // 如果该选项为``true`` ，``cmd``则可以通过shell运行
                     "shell":false,
                     // 该选项可以在调用``cmd``前替换当前进程的’ PATH 。原来的’ PATH 将在运行后恢复。使用这个选项可以在不修改系统设置的前提下将目录添加到’ PATH 中
                     "path":"./Scripts;%PATH%",
                     // For Mac OS X and Linux and Unix
                     //"path":"/Users/user/work/myvirtualenv/bin:$PATH",
                     "name": "Run virtualenv python",
                     // 包括命令及其参数数组。如果不指定绝对路径，外部程序会在你系统的:const:PATH 环境变量中搜索。
                     "cmd": ["python.exe", "-u", "$file"],
                     // ``file_regex``选项用Perl的正则表达式来捕获构建系统的错误输出，主要包括四部分内容，分别是 file name*, line number, column number and error message. Sublime Text 在匹配模式中使用分组的方式捕获信息。file name 和 *line number*域是必须的
                     "file_regex": "^[ ]*File \"(...*?)\", line ([0-9]*)"
                     // variants 用来替代主构建系统的备选。如果构建系统的选择器与激活的文件匹配，变量的``名称``则 会出现在 Command Palette 中。
                     // line_regex: 当``file_regex``与该行不匹配，如果``line_regex``存在，并且确实与当前行匹配， 则遍历整个缓冲区，直到与``file regex``匹配的行出现，并用这两个匹配决定最终要跳转的文件 或行

                     // $file_path    当前文件所在路径, 比如 C:\Files.
                     // $file   当前文件的完整路径, 比如 C:\Files\Chapter1.txt.
                     // $file_name  当前文件的文件名, 比如 Chapter1.txt.
                     // $file_extension 当前文件的扩展名, 比如 txt.
                     // $file_base_name 当前文件仅包含文件名的部分, 比如 Document.
                     // $packages   Packages 文件夹的完整路径.
                     // $project    当前项目文件的完整路径.
                     // $project_path   当前项目文件的路径.
                     // $project_name   当前项目文件的名称.
                     // $project_extension  当前项目文件的扩展部分.
                     // $project_base_name  当前项目仅包括名的部分.
                 }
             ]
         }

        g++编译命令：
        以Test.cpp为例，命令: g++ Test.cpp。生成默认为a.exe的文件，这个过程包含了编译和链接。再说下-o命令，-o命令表示输出的意思，gcc/g++命令是非常灵活的，你不指定输出的文件名的时候默认生成的是.exe文件。你要输出Test.exe的话可以用：g++ -o Test.exe Test.cpp。-o命令是输出的意思，这样就输出了Test.exe。命令:-Wall：输出所有警告信息

        cmd命令
        /c:当执行完相应的命令(在命令提示符中)后自动退出命令提示符;pause:暂停命令,执行时会在命令行窗口显示“请按任意键继续. . .”并等待你按键。;当路径中的文件名/文件夹名字含有空格时，需要用""将这个文件名/文件夹名字括起来。

    开始配置：
    Sublime Text 3->Tools->Build System->New Build System,输入以下内容：

      {
          "encoding": "utf-8",
          "working_dir": "$file_path",
          "shell_cmd": "g++ -Wall \"${file}\" -o \"${file_path}/${file_base_name}\"",
          "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
          "selector": "source.c++",

          "variants":
          [
              {   
              "name": "Run",
                  "shell_cmd": "g++ -Wall \"${file}\" -o \"${file_base_name}\" && start cmd /c \"\"${file_path}/${file_base_name}\" & pause\""
              }
          ]
      }

    解释一下

      "shell_cmd": "g++ -Wall "{file}\" -o \"{file_base_name}" && start cmd /c ""{file_path}/{file_base_name}" & pause"

    以d:test.cpp为例，这里相当于在cmd中执行了g++ -Wall "D:\blank and blank\test and test.cpp" -o "D:\blank and blank/test and test"，这句话的意思就是：用g++编译器编译D:\blank and blank\test and test.cpp文件，并在译D:\blank and blank\目录下生成test and test文件。之前都是直接从网上复制下来别人写的，结果都没有解决文件名和文件路径中包含空格的问题。我这里使用了转义字符\和”来把文件名和文件路径用双引号括起来，解决了空格的问题。

      start cmd /c \"\"${file_path}/${file_base_name}\" & pause\"

    类似地，这句话的意思就是：启动cmd并输入命令”D:\blank and blank/test and test” & pause,运行结果如图：
    运行结果
    你可以在Sublime Text中的console中看到你在ctrl+b编译之后的执行的命令
    st console

    保存配置文件：
    按ctrl+s保存配置文件，文件名xx.sublime-bulid,这里后缀名一定要是sublime-bulid,然后你就可以在Preference->Browse Package->user文件夹中找到你保存的xx.sublime-bulid文件了。接下来在tool->build-system中选择xx（你刚刚保存的文件的文件名）。然后你就可以直接在Sublime Text中按ctrl+b或者ctrl+shift+b来编译运行了，程序都是以cmd的形式运行的。

4. 开启C++11

开启c++11只需要在刚刚的配置文件中加入-std = c++11，完整的配置如下:

  {
    "encoding": "utf-8",
    "working_dir": "$file_path",
    "shell_cmd": "g++ -Wall -std=c++11 \"${file}\" -o \"${file_path}/${file_base_name}\"",
    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
    "selector": "source.c++",

    "variants":
    [
        {   
        "name": "Run",
            "shell_cmd": "g++ -Wall -std=c++11 \"${file}\" -o \"${file_base_name}\" && start cmd /c \"\"${file_path}/${file_base_name}\" & pause\""
        }
    ]
}

5. Ubuntu版本

{
    "shell_cmd": "g++ -Wall -std=c++11 '${file}' -o '${file_path}/${file_base_name}'",
    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
    "working_dir": "${file_path}",
    "selector": "source.c, source.c++",

    "variants":
    [
        {
            "name": "Build & Run",
            "shell_cmd": "gnome-terminal -e \"bash -c 'g++ -Wall -std=c++11 '${file}' -o '${file_path}/${file_base_name}' ; '${file_path}/${file_base_name}' ; echo ;echo Press any key to continue; read -sn 1;exit;exec bash;'\""
        }
    ]
    //未解决路径和文件名带空格的问题。Linux里启动终端并且执行完程序后暂停有点难搞，各种引号的匹配非常得蛋疼。暂时先用着-来链接吧！
}

6. Snippets

通过上面的设置，我们就可以愉快地用Sublime Text来写代码啦！这里只是介绍一点很方便的东西。当我们在平时在程序的时候可以会输入很多头文件，而每次都手动输入显示是不明智的做法，而每次都手动复制粘贴显示也很麻烦，Sublime Text就为我们提拱了一个很方便的工具–Snaippets。
先来看看效果
input
这样我们就可以很方便地需要我们要用到的头文件了：

设置：
Tools-New Snippet

<snippet>
    <content><![CDATA[
Hello, ${1:this} is a ${2:snippet}.
]]>//在这里输入内容,${1:}表示按完快键键后按光标所在位置
${2:}表示，按完快捷键后，按第一下tab光标转移到的位置。
</content>
    <!-- Optional: Set a tabTrigger to define how to trigger the snippet -->
    <!-- <tabTrigger>hello</tabTrigger> -->//快捷键开关，你要把注释取消掉，像
    <tabTrigger>hello</tabTrigger>//我的图中就是把hello改成了'#init'
    <!-- Optional: Set a scope to limit where the snippet will trigger -->
    <!-- <scope>source.python</scope> -->
</snippet>

我图中的配置是：

<snippet>
    <content><![CDATA[
#include <cstdio>
#include <cstdlib>
#include <string.h>
#include <string>
#include <math.h>
#include <algorithm>
#include <iostream>
#include <queue>
#include <stack>
#include <map>
#include <set>
typedef long long ll;
using namespace std;

int main()
{
    ${1}
}
]]></content>
    <!-- Optional: Set a tabTrigger to define how to trigger the snippet -->
    <tabTrigger>#init</tabTrigger>
    <!-- Optional: Set a scope to limit where the snippet will trigger -->
    <!-- <scope>source.python</scope> -->
</snippet>

同样保存配置，文件名格式：xx.init.sublime-snippet。保存后也是可以在Preference->Browse Package->user文件夹中找到。

Sublime Text自带的snippet可以在sublime text安装目录->Packages中找到。
以C++为例：
C:\Program Files\Sublime Text 3\Packages\c++.sublime-package。
把后缀名改成：c++.zip即可用压缩文件打开。里面就有Sublime自带的snippet，用sublime text打开修改即可。修改完毕之后记得把.zip改回.sublime-package。

待完善的地方

    不能像IDE那样提示如stl中的自带函数。Sublime Text 2中可以通过安装一个SublimeClang的插件来完成，但是原作业已经停止更新了，所以在Sublime Text 3的Package control中并不能直接找到这个插件。有兴趣的可以自行搜索一下ST3中怎么安装这个插件，我之前折腾过可是还是有BUG，于是还没有完成。不过也还好，靠自己记住那么函数方法。
    调试过程略蛋疼。由于不能像IDE那样逐行调试，所以现在都是在代码中的不同地方插入tag手动调试。我也不知道这对提升代码力是好还是坏了。看来有必要学一波gdb调试？

7. 后记

由于真的而很喜欢sublime text的节目所以一直都放不下这个哈哈哈。前前后后看了不少的博客，百度google了很多次。尝试过照搬别人的配置，结果各种BUG，还是要看自身的情况来定制。这次学到了关于g++编译器编译命令已经cmd命令，还有一点点的正则表达式。仅以此博文与大家分享。