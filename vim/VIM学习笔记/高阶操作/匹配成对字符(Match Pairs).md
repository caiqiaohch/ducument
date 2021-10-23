# 匹配成对字符(Match Pairs)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

12 人赞同了该文章



![img](https://pic4.zhimg.com/80/v2-71838805a8390cdc1e5549bf8acec9c7_720w.jpg)Originally from Practical Vim by Drew Neal

## **'matchpairs'选项**

matchpairs选项，用来控制哪些字符可以通过`%`命令进行匹配。此选项的默认值如下：

```vim
:set matchpairs=(:),{:},[:]
```

也就是说，在开括号“(,{,[”上点击`%`键，将会自动跳转到对应的闭括号“),},]”上；同理，在闭括号上点击`%`键，也会跳转回到对应的开括号上；同时，匹配跳转也能够正确处理括号嵌套的情况。

如果当前光标下并非括号，那么点击`%`键，将自动在本行内向前查找并定位到括号之上。

![img](https://pic2.zhimg.com/v2-849aa828276827c7a5fa8c7d55f089c1_b.jpg)

Source: https://catonmat.net/vim-plugins-matchit-vim


如果需要新增匹配类型，例如增加对于HTML文件中的尖括号的匹配，那么可以使用以下命令：

```vim
:set mps+=<:>
```

利用[自动命令](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-49-01-autocmd.html)（autocmd），可以针对特定文件类型设置匹配字符。例如针对C和Java代码，增加对于“=”和“;”的匹配：

```vim
:au FileType c,cpp,java set mps+==:;
```

## **'showmatch'选项**

如果希望在输入闭括号时，短暂地跳转到与之匹配的开括号，那么可以设置以下选项：

```vim
:set showmatch
```

## **'matchtime'选项**

'matchtime'选项，用于控制显示配对括号的时间，其单位为0.1秒，默认值为5，即0.5秒。

如果希望持续显示配对括号1.5秒，那么可以使用以下命令：

```vim
:set matchtime=15
```

## **matchit插件**

[matchit](https://link.zhihu.com/?target=https%3A//github.com/chrisbra/matchit)插件扩展了`%`命令的功能，支持if/else/endif语法结构；支持HTML标签。使用`:help matchit-languages`命令，可以查看当前支持的所有语言列表。

从Vim 6.0开始，[matchit](https://link.zhihu.com/?target=https%3A//github.com/chrisbra/matchit)插件伴随vim发行，内置于`$VIMRUNTIME\pack\dist\opt\matchit`目录中，并不需要单独安装。

在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中增加以下命令，可以启用matchit插件：

```vim
packadd! matchit
```

在HTML标签中，点击`%`键，将移动到关闭标签上：

![img](https://pic4.zhimg.com/v2-8baa539e29ded2327511565ab32c5bf7_b.jpg)

Source: https://catonmat.net/vim-plugins-matchit-vim

使用以下命令，可以查看更多帮助信息：

```vim
:help matchit 
```



编辑于 2020-09-16