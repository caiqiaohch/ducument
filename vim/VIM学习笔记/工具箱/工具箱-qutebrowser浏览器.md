# 工具箱-qutebrowser浏览器

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

7 人赞同了该文章

如果您正在寻找一款使用Vim风格的键盘操作的浏览器，那么开源的**[Qutebrowser](https://link.zhihu.com/?target=https%3A//qutebrowser.org/)**将会是个不错的选择。

Qutebrowser使用[QtWebEngine](https://link.zhihu.com/?target=https%3A//wiki.qt.io/QtWebEngine)展现引擎，而QtWebEngine则是基于Google's Chromium的。使用`:version`命令，可以查看Qutebrowser的版本信息，以及其依赖的相关组件。

![img](https://pic1.zhimg.com/80/v2-0dc20848a3d38e5ae50806ec1671b494_720w.jpg)

## 浏览操作

对于Qutebrowser的第一印象，必然是其极简风格的图形界面。除了顶部的标签页和底部的状态栏，甚至没有菜单栏、工具栏和地址栏。所以，您将拥有最大化的屏幕空间以聚焦于网页内容本身。

![img](https://pic2.zhimg.com/80/v2-e7f63cc0ec4e0b371afb09e1a10769c9_720w.jpg)

您可以使用键盘来完成通常的浏览操作。比如使用 **f** 键，将在链接上显示快捷键，点击相应快捷键即可打开链接：如果点击 **Ctrl+r** 键再点击快捷键，则会在后台新建标签页并打开链接。假设您正在通过搜索引擎查找信息，那么则可以在后台打开多个搜索结果，而在当前页面不受打扰地继续搜索。

![img](https://pic3.zhimg.com/80/v2-8d1e6595c5207b0a15e71d70755ddbba_720w.jpg)

你将会发现大部分快捷键，都是与Vim像类似的。比如使用j和k键，上下滚动屏幕；使用H和L键，返回前一页或后一页；使用/键，查找文本；使用`**:bind**`命令，可以查看快捷键列表。

![img](https://pic2.zhimg.com/80/v2-a30159e9c442bf9d87daf8be5187ad69_720w.jpg)

## 命令行模式

像Vim一样，点击:键将进入命令行模式，可以使用命令来下载文件（`:download`）、查看历史纪录（`:history`）、管理收藏夹（`:bookmark-add`）和缩放屏幕（`:zoom`）等。

收藏夹纪录存放在config文件目录下的urls文件中（例如“C:\Users\username\AppData\Roaming\qutebrowser\config\bookmarks\urls”）。您可以针对此纯文本文件执行同步操作，以保持多台电脑间收藏夹的一致性。

![img](https://pic1.zhimg.com/80/v2-61711acee28431b5fe8048fc55c8e700_720w.jpg)

您可以在[命令列表](https://link.zhihu.com/?target=https%3A//qutebrowser.org/doc/help/commands.html)中，查看各种命令的使用方法。

## 系统配置

使用`:set`命令，可以修改Qutebrowser的配置选项。

![img](https://pic3.zhimg.com/80/v2-939aec01ca5a684a994a673fe237fae2_720w.jpg)

例如可以将[速查表](https://link.zhihu.com/?target=https%3A//raw.githubusercontent.com/qutebrowser/qutebrowser/master/doc/img/cheatsheet-big.png)设置为首页，然后使用`:save`命令来保存设置。

![img](https://pic1.zhimg.com/80/v2-7b8581e946dc22123f366be376c7ab90_720w.jpg)

## 帮助信息

使用`:help`命令，可以查看帮助信息。

![img](https://pic2.zhimg.com/80/v2-9e6f0d524f307b8d57b0915e1afe0f59_720w.jpg)

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-801-Toolkit-Screen.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-605-WebDesign-Firefox.html)>

编辑于 2020-01-08