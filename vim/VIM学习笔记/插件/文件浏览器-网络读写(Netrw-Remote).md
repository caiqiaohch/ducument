# 文件浏览器-网络读写(Netrw-Remote)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

6 人赞同了该文章

使用[Netrw](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-105-plugin-Netrw.html)插件，不但可以浏览本地文档，还可以通过SCP、SFTP和HTTP等网络协议，来编辑远程服务器上的文件。

## SCP

请首先下载并安装[PuTTY](https://link.zhihu.com/?target=http%3A//www.chiark.greenend.org.uk/~sgtatham/putty/download.html)，然后在Windows操作系统的环境变量PATH中，增加PuTTY目录：

```bash
C:\Program Files (x86)\PuTTY
```

在操作系统的命令行中，使用以下命令确认能够执行PSCP：

```bash
$ pscp --version 
```

![img](https://pic3.zhimg.com/80/v2-9572ad72aaf8cdd769073e3ab574db4e_720w.jpg)

在vimrc文件中，增加以下命令设置使用PSCP：

```vim
let g:netrw_scp_cmd="pscp.exe -q
```

在Vim中使用以下命令，可以使用SCP协议直接编辑远程服务器上的文件：

```vim
:e scp://user@hostname/path/file.txt
```

Vim将调用PSCP命令，请根据提示输入密码，然后点击任意键返回Vim编辑文件：

![img](https://pic4.zhimg.com/80/v2-ad5fbe5a297875e05adb742ab56361d7_720w.jpg)

在保存文件时，将会调用PSCP命令将文件写回服务器：

![img](https://pic3.zhimg.com/80/v2-58bc5db070c0cdfe1432c50c52609922_720w.png)

## SFTP

在Vim中使用以下命令，可以使用SFTP协议直接编辑远程服务器上的文件：

```vim
:e sftp://user@hostname/path/file.txt
```

Vim将调用SFTP命令，请根据提示输入密码，然后点击任意键返回Vim编辑文件：

![img](https://pic1.zhimg.com/80/v2-248f81f8beca41b78950af752947fa18_720w.png)

在保存文件时，将会调用SFTP命令将文件写回服务器：

![img](https://pic4.zhimg.com/80/v2-e4a79366a4798d293803330565e6844b_720w.png)

## URL

在以上命令中的连接信息中，主要包括以下几项内容:

- **网络协议**，除了SCP和SFTP协议之外，Netrw还支持HTTP、DAV和RCP等协议；
- **主机信息**，格式为 [user@]hostname[:port]，如果省略用户名，则使用本机上的当前用户名；如果省略端口号，则使用默认的标准端口号（例如SFTP:22）；
- **目标文件名**，可以使用以“//”开头的绝对路径，也可以使用以“/”开头的以用户主目录为起始的相对目录。

## HELP

使用以下命令，可以查看Netrw网络读写的帮助信息：

```vim
:help netrw-xfer 
```

从以上操作可见，在调用远程文件传输时，需要用户输入密码以获取读写权限，这也使得整个过程过于繁琐。也许使用[SSH](https://link.zhihu.com/?target=https%3A//alternativeto.net/tag/ssh-client/)客户端，然后将Vim设置为编辑器，才是更好的主意吧？

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//tiny.cc/netrw-local) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-107-plugin-YankRing.html)>

发布于 2020-02-28