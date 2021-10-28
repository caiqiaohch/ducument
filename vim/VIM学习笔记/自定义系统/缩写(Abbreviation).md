# 缩写(Abbreviation)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

利用:ab[breviate]缩写命令，我们可以用一个缩写来代替一组字符，此后只要输入缩写，就可以自动插入其代表的字符串以提高输入效率。

## **设置缩写**

使用以下命令，将定义ad来代替advertisement：

```text
:abbreviate ad advertisement
```

当想要输入advertisement时，只要输入ad，然后：

- 如果按下Ctrl-]键，可以输入advertisement并停留在插入模式；
- 如果按下Esc键，将插入扩展字符并返回命令模式；
- 如果按下Space或Enter键，那么将在插入扩展字符后，自动增加空格或回车，并停留在插入模式。

## **不同模式下的缩写**

使用下表中不同形式的abbreviate命令，可以针对特定的模式设置缩写：

所有模式:abbreviate
插入模式:iabbrev
命令行模式:cabbrev

## **缩写实例**

我们可以为多个单词设置缩写。例如以下命令，将设置Jack Berry的缩写为JB。

```text
:abbreviate JB Jack Berry
```

如果你编写程序，那么利用以下设置，可以加快添加注释的速度：

```text
:abbreviate #b /**********************
:abbreviate #e **********************/
```

如果你设计网页，那么利用以下缩写可以快速增加标签。其中<CR><LF>将在标签间自动插入换行，以方便你继续输入内容。

```text
:iabbrev p <p><CR><LF></p>
```

利用以下命令，我们甚至还可以定位光标所处的位置：

```text
:iabbrev icode <code class="inset">!cursor!</code><Esc>:call search('!cursor!','b')<CR>cf!
```

我们还可定义命令缩写。例如以下命令，将在新的标签页中显示帮助信息：

```text
:cabbrev h tab h
```

我们可以将常用的缩写命令定义在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2012/01/vim-vimrc.html)配置文件之中，它们将在Vim启动时自动装载，而不需要再逐一重新定义。

## **查看缩写**

使用:abbreviate命令，将列出所有缩写定义，其中第一列显示缩写的类型：

![img](https://pic4.zhimg.com/80/v2-ebaa48307572e3500ec3475527c6fd17_720w.png)

标记模式!插入模式，命令行模式i插入模式c命令模式

## **取消缩写**

可以使用以下命令，移除某个缩写：

```text
:unabbreviate ad
```

针对不同模式下的缩写，需要使用与其相对应的unabbreviate命令。例如：使用:iunabbreviate命令，取消插入模式下的缩写，而:iabclear命令则会清除所有插入模式的缩写定义；依此类推，取消和清除命令行模式下的缩写，则需要使用:cunabbreviate和:cabclear命令。

如果想要清除所有缩写，可以使用以下命令：

```text
:abclear
```

![img](https://pic1.zhimg.com/80/v2-98892f9b398e8d587683adbb05921334_720w.png)

编辑于 2017-01-19