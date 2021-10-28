# 状态行(Status Line)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

6 人赞同了该文章

Vim默认的状态行，左侧显示当前打开的文件名，右侧显示当前所处的行列位置。当你执行Vim命令时，状态行将消失并显示命令输入及输出。

通常状态行用反色显示。你可以通过修改highlight选项中的s字符来改变。例如，sb设置为粗体字。如果状态行没有启用高亮 (sn)，那么字符^表示当前窗口，字符=表示其它窗口。如果支持鼠标并且已经通过设置mouse选项使之启动，那么你可以用鼠标拖动状态行以改变窗口的大小。

## **定制状态行**

我们可以使用以下命令来定义状态行：

```vim
:set statusline format
```

例如以下命令，将在状行中包含文件名：

```vim
:set statusline=The file is"%f"
```

选项包含printf风格的**%**项目，中间可以间杂普通文本。内容默认为右对齐，如果希望左对齐，那么可以在%后面加上-。数字内容是忽略开头0显示的，如果需要显示前导0，那么可以在%后加上一个"0"。单个百分号可以用"%%"给出。最多可给出80个项目。

如果此选项以**%!**开始，它用作表达式。计算此表达式的结果用作选项值。

![img](https://pic1.zhimg.com/80/v2-22d6fbe2b2c7c46fa5f1269af9d5c858_720w.png)

**显示/隐藏状态行**

即使已经使用以上命令设置选项，状态行还是保持原样，这是因为Vim在默认情况下是不显示状态行的，而仅显示命令缓冲区等极少的信息。我们可以使用以下命令，将状态行显示在窗口底部倒数第二行：

```vim
:set laststatus=2
```

你也可以使用以下命令，移去状态行：

```vim
:set laststatus=0
```

## **状态行实例**

利用以下命令，可以在状态行中显示：当前文件名，文件格式(DOS, Unix)，文件类型 (XHTML)，当前位置和文件总行数。

```text
:set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
```

实际效果如下图所示：



![img](https://pic2.zhimg.com/80/v2-6a9f9dfa2e4fec129f2f88abfb60e78d_720w.png)

除了显示的内容，你还可以使用以下命令定义显示的颜色。



```text
:set statusline=%2*%n%m%r%h%w%*\ %F\ %1*[FORMAT=%2*%{&ff}:%{&fenc!=''?&fenc:&enc}%1*]\ [TYPE=%2*%Y%1*]\ [COL=%2*%03v%1*]\ [ROW=%2*%03l%1*/%3*%L(%p%%)%1*]\
```

需要使用以下命令，自定义高亮显示颜色。

```vim
hi User1 guifg=gray
hi User2 guifg=red
hi User3 guifg=white
```

实际效果如下图所示：

![img](https://pic1.zhimg.com/80/v2-32ed1673ae48d652d1af7d46984d5ab0_720w.png)

你还可以通过在[_vimrc](https://link.zhihu.com/?target=https%3A//yyq123.blogspot.com/2012/01/vim-vimrc.html)文件中包括以下命令，使状态行根据状态的不同，显示不同的颜色。

```vim
function! InsertStatuslineColor(mode)
if a:mode == 'i'
  hi statusline guibg=peru
elseif a:mode == 'r'
  hi statusline guibg=blue
else
  hi statusline guibg=black
endif
endfunction
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=orange guifg=white
hi statusline guibg=black
```

如下图所示，状态行的文件名部分，在插入状态时显示为橘色背景，这样就能很明显地提醒我们所处的状态：

![img](https://pic3.zhimg.com/80/v2-b732e40d4063a77a2ea15953ae1bb97a_720w.png)

编辑于 2017-03-01