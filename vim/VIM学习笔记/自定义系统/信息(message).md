# 信息(message)

[![YYQ](https://pic4.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

Vim将默认记录近200次的信息显示。

## 查看信息

使用以下命令，可以查看上一个命令的输出信息：

```vim
g< 
```

使用以下命令，在显示信息的同时，也会将其存储在信息历史（message-history）之中：

```vim
:echom "Hello World"
```

使用以下命令，可以查看所有信息：

```vim
:messages
```

![img](https://pic1.zhimg.com/80/v2-5739dd965ade3af7d9a75bbba3ec1154_720w.jpg)

而使用以下命令，则可以查看最近一条报错信息（error-messages）：

```vim
:echo errmsg
E16: Invalid range
```

## 清除信息

从[7.4.1735](https://link.zhihu.com/?target=https%3A//github.com/vim/vim/releases/tag/v7.4.1735)版本开始，可以使用以下命令清除信息历史：

```vim
:messages clear
```

## 信息语言

使用以下命令，可以查看显示信息的语言：

```vim
:language message
```

通过以下变量，也可以查看显示信息的语言：

```vim
:echo LC_MESSAGES
```

在vimrc文件中使用以下命令，可以指定信息使用中文显示：

```vim
:language message zh_CN.UTF-8
```

建议使用英文显示信息，以便在互联网上进行查找相关资源：

```vim
:language message en_US.UTF-8
```

使用以下命令，可以查看更多帮助信息：

```vim
:help :messages
```

## 'shortmess'选项

'shortmess'选项，用于控制信息显示的种类和详细程度。其默认值为：

```vim
:set shormess=filnxtToOS
```

以下为主要标志位的含义（灰色行为默认值中的标志位）：

![img](https://pic2.zhimg.com/80/v2-748c51fee4a5364b9c16f22c53d40d89_720w.jpg)

如果不希望使用信息缩写，那么可以使用以下命令：

```vim
:set shm=
```

如果希望使用缩写，但不截短信息，那么可以使用以下命令：

```vim
:set shm=a
```

如果希望使用缩写，并在必要时截短信息，那么可以使用以下命令：

```vim
:set shm=at
```

从[8.1.1270](https://link.zhihu.com/?target=https%3A//github.com/vim/vim/releases/tag/v8.1.1270)版本开始，在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中增加以下设置，可以在屏幕底部，显示匹配搜索结果的总数，以及当前所处第几个匹配结果：

```vim
set shortmess-=S
```

![img](https://pic3.zhimg.com/80/v2-c7bf32bb1eb5138780d6fbd95003500e_720w.png)

使用以下命令，可以查看更多帮助信息：

```vim
:help 'shortmess'
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-50-SetOption.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-46-01-History.html)>

发布于 2020-07-17