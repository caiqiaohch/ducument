# 代码片段管理器(Gist.vim)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

16 人赞同了该文章

[Gist](https://link.zhihu.com/?target=https%3A//gist.github.com/)是[GitHub](https://link.zhihu.com/?target=https%3A//github.com/)服务的一部分，用户可以将常用的代码片段存储云端，然后在不同的客户端中进行复用；也可以将代码片段内置到网页内，或者通过网址与他人分享。而[Gist.vim](https://link.zhihu.com/?target=https%3A//github.com/mattn/gist-vim)插件，则可以直接在Vim中管理Gist代码片段。

## **安装配置Git**

对于Windows操作系统，推荐安装[Git for windows](https://link.zhihu.com/?target=https%3A//gitforwindows.org/)，并且将以下目录添加到系统的PATH变量中：

- C:\Program Files\Git\bin
- C:\Program Files\Git\cmd

对于Linux操作系统，在大多数发行版本中都已经预装了Git。

请在操作系统命令行中，使用`git --version`验证Git是否可用：

![img](https://pic2.zhimg.com/80/v2-2b683522d65b74483cd3a0350f75daa9_720w.jpg)

在操作系统命令行中，使用以下命令配置GitHub用户：

- `git config --global user.name "username"`
- `git config --global user.email "email"`

## **安装curl**

对于Windows操作系统，请下载[cURL](https://link.zhihu.com/?target=https%3A//curl.haxx.se/)，并将*curl.exe*复制到以下目录：

- C:\Program Files\Git\bin
- C:\Users\usernam\AppData\Local\Programs\Git\bin(如有)

对于Linux操作系统，在大多数发行版本中都已经预装了curl。

在操作系统命令行中，使用`curl --version`验证curl是否可用：

![img](https://pic2.zhimg.com/80/v2-3f58e26bef4d8eb4d462ea6bb182b015_720w.jpg)

## **安装webapi-vim和Gist.vim**

推荐使用插件管理器[vim-plug](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)或[Vundle](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html)，来安装[webapi-vim](https://link.zhihu.com/?target=https%3A//github.com/mattn/webapi-vim)和[Gist.vim](https://link.zhihu.com/?target=https%3A//github.com/mattn/gist-vim)。

请在[vimrc](https://link.zhihu.com/?target=http%3A//bit.ly/vim-vimrc)配置文件中增加以下命令，来设置GitHub用户名：

```
let github_user = 'username'
```

当首次调用插件时，将询问你的GitHub密码， 输入的密码将会被保存到~/.gist-vim：

![img](https://pic1.zhimg.com/80/v2-8342d353e448393ba5e6aec694e86770_720w.png)

如果在安装配置过程中遇到任何疑问，请咨询`:help gist-vim-setup`命令。

## **发布代码片段**

使用以下命令，可以将当前缓冲区的全部内容发布至Gist：

```
:Gist
```

进入可视化模式选择文本之后，执行Gist命令则会将选中的内容发布至Gist：

```
:'<,'>Gist
```

当代码片段发布成功之后，将在屏幕底部显示生成的Gist网址，同时网址也会被复制到剪贴板之中。

## **列示代码片段**

使用以下命令，可以列出当前用户所有公开的Gist：

```
:Gist -l
```

![img](https://pic4.zhimg.com/80/v2-1f6f173a024d3e0fc480c6e124b9e6a7_720w.jpg)

在显示列表中的任一行内，点击Enter回车键，则会将该Gist读入到新建缓冲区内；你可以对代码片段进行修改，然后使用Gist命令再次将其发布。也就是说，你既不用打开Gist网页，也不用本地保存代码片段，仅仅通过Vim界面，就可以方便地完成Gist的发布和更新。

![img](https://pic2.zhimg.com/80/v2-f797d2a4b3c1bc4d5e2e8bcca3ff133d_720w.jpg)

## **载入代码片段**

使用以下命令，可以将指定ID的Gist载入到新建缓冲区：

```
:Gist id
```

## **删除代码片段**

在Gist载入到新建缓冲区之后，可以使用以下命令将该代码片段从Gist网站中删除：

```
:Gist -d
```

## **克隆代码片段**

除了查看自己创建的代码片段，我们还可以浏览其他用户发布的Gist。使用以下命令，可以列示指定用户公开的代码片段：

```
:Gist -l username
```

![img](https://pic1.zhimg.com/80/v2-515062e9e1e8f3a916b1a06deb1cd690_720w.jpg)

将Gist载入到新建缓冲区之后，使用以下命令，则可以克隆该代码片段至自己的用户名之下：

```
:Gist -f
```

## **在浏览器中查看代码片段**

将Gist载入到新建缓冲区之后，使用以下命令，将会更新代码片段，并在默认浏览器中显示Gist网页：

```
:Gist -b
```

![img](https://pic4.zhimg.com/80/v2-950d9fd24e448eae6106fc2e5991949f_720w.jpg)

![img](https://pic3.zhimg.com/80/v2-15635d6698d981239d26db16a2c5e16a_720w.jpg)

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[ |](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html)[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)>

发布于 2019-02-22