# 使用rot13加密

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

## ROT13算法

ROT13（回转13位，英语：rotate by 13 places，有时也记为ROT-13）是一种简易的替换式密码。ROT13是一种在英文网络论坛用作隐藏八卦（spoiler）、妙句、谜题解答以及某些脏话的工具，目的是逃过版主或管理员的匆匆一瞥。ROT13被描述成“杂志字谜上下颠倒解答的Usenet点对点体”。ROT13 也是过去在古罗马开发的凯撒加密的一种变体。ROT13是它自己本身的逆反；也就是说，要还原ROT13，套用加密同样的算法即可得，故同样的操作可用再加密与解密。该算法并没有提供真正的密码学上的保全，故它不应该被套用在需要保全的用途上。它常常被当作弱加密示例的典型。

![img](https://pic1.zhimg.com/80/v2-dcb651380cf87d279db109dd3a4d0ba4_720w.jpg)Source: zh.wikipedia.org/zh-cn/ROT13

## g?命令

使用 g?{motion} 命令，可以使用Rot13对{motion}跨越的文本进行编码。例如以下命令，将对当前行进行ROT13转换：

```vim
g??
```

使用以下命令，将对从当前行到文件末尾的文本进行ROT13转换：

```vim
:normal VGg?
```

使用以下命令，将对从指定行到文件末尾的文本进行ROT13转换：

```vim
:normal 10GVGg?
```

假设需要针对以下id属性值进行ROT13转换：

```text
<li id="lorem">foo</li>
```

那么可以在g?命令中指定[文本对象](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-10-TextObjects.html)：

```vim
g?i" 
```



```text
<li id="yberz">foo</li>
```

以下英文笑话，精华句为ROT13所隐匿：

```text
How can you tell an extrovert from an
introvert at NSA? Va gur ryringbef,
gur rkgebireg ybbxf ng gur BGURE thl'f fubrf.
```

使用以下命令，透过ROT13表格转换整片文字，该笑话的解答揭露如下：

```vim
ggVGg?
Ubj pna lbh gryy na rkgebireg sebz na
vagebireg ng AFN? In the elevators,
the extrovert looks at the OTHER guy's shoes.
```

再次执行该命令，将重新对文本进行解密。以此类推，可以反复加密和解密整个文件。

定义以下快捷键，也可以对整个文件进行ROT13转换：

```vim
:map <F3> ggg?G
```

**？**使用以下命令，可以查看相关帮助信息：

```vim
:help g?
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-27-crypt.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Shell-Filter.html)>

发布于 01-04