# Unity lua脚本调试

原生的lua代码调试支持的工具很多， 这里主要说的是能Attach到Unity进程交互调试的工具。 大多游戏都在使用lua脚本来热更新游戏逻辑，下面介绍两个工具如何调试lua，

jetbrains旗下软件（IntelliJ IDEA 和 Pycharm）
vscode（LuaPanda）




两款ide都是跨平台的， 在windows和macos上都有很好的支持, 而且都支持以下lua的特性：

自动补全（auto completion）
代码片段（snippet completion）
定义跳转（definition）
生成注释（comment generation）
类型推断（limited type inference）
代码格式化（formatting）: vscode依赖 lua-fmt
代码诊断（linting）：vscode依赖 luacheck
调试器（debugger）

## Jet brains 工具链

下载安装IntelliJ IDEA 或者pycharm, 这两款软件都是Jet Brains旗下的软件。 现在更多的人使用它们来开发python或者java， 我们这里主要使用的是其一款插件，叫做EmmyLua。

以Pycharm为例：

安装好之后，选择File->Settings, 再打开的设置窗口选中Plugins来安装插件， 搜到EmmyLua, 点击Install按钮，进行安装：



选择Unity工程lua脚本所在的文件夹打开（注意lua require时搜索路径，所以这里一定对应起来）。

增加识别文件扩展名，将*.lua 和*.txt统统识别为lua脚本，（*.lua.txt能识别为lua，但影响debug, 可能是emmylua的一个bug）



在上图选项Ignore files and folders 可以设置忽略在侧边栏显示的文件匹配符。很多非代码相关的东西都可以通过此方式屏蔽掉。

菜单栏选中Run->Attach to Process, 在本机所有的进程中选择Unity进程即可调试了。



运行效果如下， 既可以看到调用堆栈， 又可以查看过程变量，非常的方便。



如果你不习惯pycharm自带的快捷键, 你还可以在setting的Keymap中改成vs的快捷键。除了vs的快捷键， pycharm还提供了很多其他编辑器的快捷键， 比如说Sublime, Eclipse等。

如果你之前是一名python开发者， 第一次打开一个lua的工程的时候， pycharm会加载很多python本地安装的packages, 如果这影响了编辑器的性能，你可以在Settings里面清掉Project interpreter：



如果你是一位原生的lua开发者， 而非使用引擎调试lua， 你需要配置编译好的lua.exe的文件位置和lua的search path, 配置好之后也能很方便的调试。



## VSCode

这里推荐一款vscode的plugin, 腾讯开发的插件叫LuaPanda, 因为LuaPanda是基于luasocket的， 所以你必须确保你的lua环境已经安装了luasocket, 又鉴于此特性，所以这款插件还可以远程调试， 比如说手机连着编辑器调试。



LuaPanda的vscode adapter是使用typescript(javascript的超集) 语言编写的， 大约1000行，核心代码: luaDebug.ts

文件配置
文件：LuaPanda.lua

下载位置：github 的 Debugger 目录下

把以上两个文件放在lua代码可以引用到的位置，并在用户代码中引用:

require(“LuaPanda”).start(“127.0.0.1”,8818);
*8818是默认端口号，如果需要修改，请同时修改launch.json的端口设置。

调试配置
切换到VSCode的调试选项卡，点击齿轮，在弹出框中选择 LuaPanda (若无此选项说明以前用别的插件调试过lua , 要把先前用过的调试插件禁用)。会自动生成launch.json文件。

launch.json 配置项中要修改的主要是luaFileExtension, 改成lua文件使用的后缀就行。（比如xlua改为lua.txt, slua是txt）。各配置项鼠标悬停会有提示，可根据需要更改。



先运行VSCode端，再运行Lua代码: 点击调试选项卡左上角的绿色箭头，再运行unity/ue4工程。如果有stopOnEntry或是执行到断点处，就会自动停住。



LuaPanda 在PC上调试会默认使用 c hook，它是用c重写了debugger的核心hook部分，从而提高调试器的执行效率。 c hook会默认启用，无需单独接入。

验证方式：停在断点处后，在调试控制台输入LuaPanda.getInfo()， 返回信息的BaseInfo会给出提示，如果c库已加载，还会给出版本号。

LuaPanda调试器功能依赖LuaSocket, 可运行于slua，slua-unreal ，xlua 等已集成 LuaSocket 的 lua 环境，也可以在console中调试。lua 版本支持 5.1- 5.3。

其他依赖项目（插件中已包含，无需用户手动安装):

```
luaparse
luacheck
lua-fmt
path-reader
```


更多关于LuaPanda的介绍， 参考这里

更多关于LuaPanda的介绍， 参考这里

写在最后
由于作者经常使用pycharm写python脚本， 已经很熟悉Jetbrains的那一套环境了，所以我更倾向于使用第一种方式来调试lua。 然而vscode显然更轻量级一些， 读者喜欢使用哪一款，萝卜青菜 各有所爱吧。
————————————————
版权声明：本文为CSDN博主「huailiang2010」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/yunman2012/article/details/103305222