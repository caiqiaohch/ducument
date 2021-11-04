# 环绕字符编辑(surround)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

12 人赞同了该文章

**[surround](https://link.zhihu.com/?target=https%3A//github.com/tpope/vim-surround)** 插件可以快速编辑围绕在内容两端的字符（pairs of things surrounding things），比如成对出现的括号、引号，甚至HTML/XML标签等。

## **安装配置**

推荐您使用[vim-plug](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)或[Vundle](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html)等插件管理器，来安装GitHub上的[surround](https://link.zhihu.com/?target=https%3A//github.com/tpope/vim-surround)插件。

以下将利用实例来介绍surround插件的主要功能，请注意：

- 在“原始文本”列中，高亮文字表示光标所在位置；
- 在“命令”列中，为顺序执行的命令序列。
- 在“更改效果”列中，为命令执行之后的结果。请参考[实例文件](https://link.zhihu.com/?target=https%3A//github.com/yyq123/learn-vim/blob/master/samples/surroundings.txt)并自行测试。

## **新增环绕字符**

在常规模式、插入模式和可视化模式下，可以分别使用`ys`和`S`命令来新增环绕字符：

![img](https://pic3.zhimg.com/80/v2-89bed05b8170e2e50cf6826f23764fba_720w.jpg)

请注意：

- 插入模式下的操作：

- - 首先同时按下**CTRL-g**键；
  - 然后松开**CTRL**键；
  - 最后点击**s**或**S**键，并输入环绕字符或标签。

- 可视化模式下的操作：

- - 首先使用快捷键进入不同类型的可视化模式。
    比如在Windows下，使用**CTRL-Q**键进入块视化模式；
  - 然后使用**j**等移动命令来选中文本；
  - 最后点击**S**键，并输入环绕字符或标签。

## **修改环绕字符**

使用`cs`命令可以修改环绕字符：

![img](https://pic4.zhimg.com/80/v2-1d42044bf3ad5ca7a35199e785105b1f_720w.jpg)

## **删除环绕字符**

使用`ds`命令可以删除环绕字符：

![img](https://pic4.zhimg.com/80/v2-74f266a08e85a6aad25e66254e666373_720w.jpg)

surround插件主要提供以下命令：

- `ys`添加环绕字符
- `yS`添加环绕字符并拆分新行
- `yss`为整行添加环绕字符
- `ySS`为整行添加环绕字符并拆分新行
- `cs`修改环绕字符
- `cS`修改环绕字符并拆分新行
- `ds`删除环绕字符

surround插件可以识别并处理以下目标实体：

- `( )`
- `{ }`
- `[ ]`
- `< >`
- \```
- `"`
- `'`
- `t`（标签）
- `w`（单词）

## **自定义快捷键**

如果查看surround插件的源码，将会发现快捷键逐一定义在[surround.vim](https://link.zhihu.com/?target=https%3A//github.com/tpope/vim-surround/blob/master/plugin/surround.vim%23L599)文件中：

![img](https://pic3.zhimg.com/80/v2-c65a728c1e6144212124582100dd9172_720w.jpg)

也就是说，我们可以直接在vimrc配置文件中，重置或取消插件预定义的快捷键：

```text
" 不定义任何快捷键
let g:surround_no_mappings = 1
" 从plugin/surround.vim复制快捷键定义
” 并按需要进行修改
nmap ds <Plug>Dsurround
nmap cs <Plug>Csurround
nmap cS <Plug>CSurround
nmap ys <Plug>Ysurround
nmap yS <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
" 取消不需要的快捷键
"xmap S   <Plug>VSurround
"xmap gS  <Plug>VgSurround
"imap   <C-S> <Plug>Isurround
imap    <C-G>s <Plug>Isurround
imap    <C-G>S <Plug>ISurround
```

假设需要输入以下包含多个环绕字符的文本：

```text
{{ nginx_root }}
```

由于surround插件并不支持`.`重复命令，如果想要新增多个成对字符，那么需要安装额外的[repeat.vim](https://link.zhihu.com/?target=https%3A//github.com/tpope/vim-repeat)插件。而死板繁琐的替代方案是，自定义快捷键来重复执行命令：

```vim
nmap <C-J> ysiw}lysiw{
```

使用以下命令，可以查看插件的帮助文件：

```vim
:help surround
```

## **使用感受**

一，舍本逐末。为了输入环绕字符的小需求，而发明碾压一切的大轮子。颇有些杀鸡用牛刀的意味。而且平白多出来的快捷键和命令，不但冗长而且别扭，操作起来总有种有苦难言的感觉。

二，盛名之下，其实难副。对于一个被不断被提及的知名插件，从功能和体验上都差强人意，着实让人失望。也许，这就是见面不如闻名吧。

以上，皆为一家之言，还请自行斟酌。

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)>

发布于 2020-07-10