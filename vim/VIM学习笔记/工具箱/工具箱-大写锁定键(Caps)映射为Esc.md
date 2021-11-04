# 工具箱-大写锁定键(Caps)映射为Esc

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

今天要处理一起拆迁事件 — 把地处黄金地段的大写锁定键Caps Lock更换为Esc键。

至于，为什么地处偏僻的Esc被时常造访，而位置绝佳的Caps Lock却长期空置？根据考古发现，很可能是由于远古程序员使用了以下布局的祖传键盘：

![img](https://pic2.zhimg.com/80/v2-65f29be76995e8df4d3a9d479df4ba0d_720w.jpg)

## Windows

下载并安装**[Microsoft PowerToys](https://link.zhihu.com/?target=https%3A//github.com/microsoft/PowerToys)**；在“Keyboard Manager”设置中，点击“Remap a key”，然后将Caps Lock映射为Esc。

![img](https://pic2.zhimg.com/80/v2-2425df284124451fef86569f11d53ad1_720w.jpg)

如果您不需要PowerToys提供的窗口管理、批量重命名和快速应用启动等众多功能，那么可以下载**[Uncap](https://link.zhihu.com/?target=https%3A//github.com/susam/uncap)**；它没有任何图形界面，只需要后台运行单一的“uncap.exe”文件，即可将Caps Lock映射为Esc。

如果需要在系统启动时自动完成键盘映射，那么可以在Windows注册表的以下节点中增加启动项：

```text
Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
```

![img](https://pic1.zhimg.com/80/v2-6f1cbee7701b9b304d2b5d4a9cbd4ad0_720w.jpg)

## Linux

下载并安装**[GNOME Tweak tool](https://link.zhihu.com/?target=https%3A//wiki.gnome.org/Apps/Tweaks)**；在“Keyboard & Mouse”设置中，点击“Additional Layout Options”；在“Caps Lock behavior”列表中选择“Caps Lock an additionnal Esc”。

![img](https://pic2.zhimg.com/80/v2-7cd66dfac96b335be4928859612dc6f1_720w.jpg)

## Mac

打开“[系统偏好设置](https://link.zhihu.com/?target=https%3A//support.apple.com/zh-cn/guide/mac-help/kbdm162/mac)”，进入“键盘”选项，点击“修饰键...”按钮，将大写锁定键的行为更改为Escape。

![img](https://pic4.zhimg.com/80/v2-485c0ca27fbd7d97f83e98f29e076e57_720w.jpg)

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-203-Install-Vim-Win.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-202-Install-Vim-Mac.html)>

发布于 2020-05-27