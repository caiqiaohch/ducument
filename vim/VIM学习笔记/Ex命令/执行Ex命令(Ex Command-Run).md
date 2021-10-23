# 执行Ex命令(Ex Command-Run)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

2 人赞同了该文章

可以使用以下几种方式来执行Ex命令：

- 在常规模式下，输入冒号“:”以及命令，点击回车键即可执行Ex命令；
- 进入[Ex模式](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-48-ExMode.html)，执行Ex命令；
- 调用[Ex脚本](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-48-05-ExScript.html)，以执行其中的Ex命令；
- 使用竖直线“|”分割符，组合执行多条Ex命令；
- 执行寄存器中存储的Ex命令。

## **组合执行多条Ex命令**

竖直线“|”作为分割符，可以将多个命令组合在一起执行。使用“|”时，如果前一个命令影响到文件中行的顺序，那么下一个命令将使用新的行位置进行工作。

使用以下命令，将首先删除第1行至第3行，然后在当前行（即调用ex命令之前的第4行）进行替换：

```vim
:1,3d | s/thier/their/
```

使用以下命令，将首先把1至5行移动到第10行之后，然后显示所有包含模式pattern的行：

```vim
:1,5m10 | g/pattern/nu
```

## **利用寄存器执行Ex命令**

例如在[Ex脚本文件(Ex Script)](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/samples/ExScript_Sample.vim)中包含以下命令：

```vim
%s/\n//
```

我们移动到此行，然后使用以下命令将该行内容删除到命名[寄存器(Regists)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-12-Register.html)“g”之中：

```vim
"gdd
```

使用以下命令，则可以执行已存储在“g”寄存器之中的命令：

```vim
:@g
```

![img](https://pic1.zhimg.com/80/v2-fb4449c2e669778db57d901af5787bbc_720w.jpg)



发布于 2019-09-02