安装

可以从官网下载安装（官网同时可以找到sublime test2），如果觉得网速慢可以复制这个链接用迅雷下载，或者点这个备用链接build 3126。

打开exe文件，然后一路点击下一步，安装完成。
激活

第一次打开sublime后，顶部会提示未激活，并且使用中也会有弹出框提示未激活。

那么点击菜单最右的Help>enter License ，将下面这段激活码粘贴在弹出的窗口中，点击use License ，激活完成。

随着版本的更新，激活码可能会失效，此激活码适用3103以后的版本，后期更新版本失效后，善用Google或baidu：）
—– BEGIN LICENSE —–
Michael Barnes
Single User License
EA7E-821385
8A353C41 872A0D5C DF9B2950 AFF6F667
C458EA6D 8EA3C286 98D1D650 131A97AB
AA919AEC EF20E143 B361B1E7 4C8B7F04
B085E65E 2F5F5360 8489D422 FB8FC1AA
93F6323C FD7F7544 3F39C318 D95E6480
FCCC7561 8A4A1741 68FA4223 ADCEDE07
200C25BE DBBC4855 C4CFB774 C5EC138C
0FEC1CEF D9DCECEC D3A5DAD1 01316C36
—— END LICENSE ——
安装package control

这里是官方教程。

最简单的方法是通过Sublime Text控制台安装。通过快捷方式ctrl+` 或 view >Show Console 菜单访问控制台。打开后，将适用于你的Sublime Text版本的Python代码粘贴到控制台中。
sublime text 3:

    import urllib.request,os,hashlib; h = 'df21e130d211cfc94d9b0905775a7c0f' + '1e3d39e33b79698005270310898eea76'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)

sublime text 2:

    import urllib2,os,hashlib; h = 'df21e130d211cfc94d9b0905775a7c0f' + '1e3d39e33b79698005270310898eea76'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler()) ); by = urllib2.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); open( os.path.join( ipp, pf), 'wb' ).write(by) if dh == h else None; print('Error validating download (got %s instead of %s), please try manual install' % (dh, h) if dh != h else 'Please restart Sublime Text to finish installation')

官方警告：
请不要通过其他网站重新分发安装代码。它将随着每个版本而改变。请链接到此页面。
如果使用代码安装失败

我就是使用代码安装失败了。。这是官方给出的另一种方法。

    单击Preferences > Browse Packages…
    进入上一层目录，也就是Sublime Text 3目录下（电脑中的目录一般是C:\Users\username\AppData\Roaming\Sublime Text 3），然后进入Installed Packages 文件夹
    下载Package Control.sublime-package 备用链接 并将其复制到Installed Packages 目录中
    重新启动sublime。

安装成功时，Installed Packages 目录中会出现这样一个文件0_package_control_loader.sublime-package。再次进入Preferences菜单后，就可以看到package setting和package control 两个选项了。
安装插件

    按下Ctrl+Shift+P 调出命令面板
    输入install 调出 Install Package 选项并回车，然后在列表中选中要安装的插件。

推荐插件

AutoFileName：自动补全文件名

Emmet：花10分钟学学语法，让你提升10倍编码速度：国内教程 国外官方教程

Go-To-Css-Declaration：跳转到css的定义处

JsFormat：格式化js代码

Tag：可以补全和格式化html标签

Themr：主题选择

Autoprefixer：自动添加浏览器兼容前缀

CodeFormatter：代码格式化

ConvertToUTF8：解决中文编码问题

SublimeLinter：代码提示高亮

Terminal：唤起终端控制台

SideBarEnhancements：右键菜单增强插件

MarkdownPreview：快速调用浏览器预览markdown文本

MarkdownEditing：markdown编辑器，支持常用代码补全

OmniMarkupPreviewer：markdown文本即时预览

本版本为Sublime Text Build 3211

传送门1

https://www.sublimetext.com/3

或

https://www.jb51.net/softs/58828.html

Package Control是一个Sublime Text包管理器，通过命令面板，可以非常容易的去安装Sublime Text插件。

Package Control安装

由于packagecontrol.io容易被墙，访问不稳定，所以需要将Sublime Text安装插件的地址改为中文镜像的地址：

第一步：通过控制台安装插件代码，通过 ctrl+` 或 View > Show Console打开控制台，将Python代码粘贴到控制台，回车。

    import urllib.request,os,hashlib; h = '6f4c264a24d933ce70df5dedcf1dcaee' + 'ebe013ee18cced0ef93d5f746d80ef60'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.cn/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)

如何汉化？

Sublime Text 通过Chinese​Localizations插件来实现汉化。安装完成之后，即可在Help菜单中切换语言。

方法一

初始化之后，在插件仓库中搜索自己想要安装的插件，比如：Chinese​Localizations

使用快捷键 Ctrl+P , 输入：install 选中 Package Control:Install Package回车，然后输入Chinese​Localizations回车，搞定。

方法二

一、找到 Tools->Install Package Control 选项，调出 Package Control；
二、去找“Tools->Command Palette…”选项；
三、输入 ipc ,点击 Install Package Control，即可调出 Package Control；
四、找到 Preferences->Package Control；
五、选项弹出命令行输入框，输入ip，点击“install Package”；
六、弹出命令行输入框，输入clz，点击“ChineseLocalizations”；
七、中文设置成功，若想切换语言请在“帮助->Language ”切换即可。

禁用更新

一、设置成中文字体后，打开“首选项(英文为Preferences)>Package Settings>Package Control>Settings-User”;
二、在花括号里面的最后一行添加"update_check": false 即可（注意如果有多条配置信息，你必须在前面"]"的后面多加一个英文逗号。如下图所示，即可禁用更新成功。
 

激活教程

一、修改hosts文件，需要有系统管理员权限才可以修改。windows的hosts在C:\Windows\System32\drivers\etc目录下，其他系统请自行百度hosts所在目录。
二、用文本编辑器打开（记事本即可），在最后添加上如下信息。

    127.0.0.1 www.sublimetext.com
    127.0.0.1 license.sublimehq.com
     

三、从网上搜索最新的注册码出来，必须是最新的才可以，sublime text 已经更新到了3.1 3176 ，更改了验证方法，之前可用注册码已全部失效，请使用最新的注册码。我在此提供一个供大家使用，直接复制，打开“帮助>输入注册码”，粘贴进去即可。
 

—– BEGIN LICENSE —–
Die Socialisten GmbH
10 User License
EA7E-800613
51311422 E45F49ED 3F0ADE0C E5B8A508
2F4D9B65 64E1E244 EDA11F0E F9D06110
B7B2E826 E6FDAA72 2C653693 5D80582F
09DCFFB5 113A940C 5045C0CD 5F8332F8
34356CC6 D96F6FDB 4DEC20EA 0A24D83A
2C82C329 E3290B29 A16109A7 EC198EB9
F28EBB17 9C07403F D44BA75A C23C6874
EBF11238 5546C3DD 737DC616 445C2941
—— END LICENSE ——

现在教程已结束，截止到目前这个激活教程还是可行的，以后会不会失效不好说，成功了的欢迎留言评论。