# 替换模式(Replace Mode)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

**进入替换模式**

使用大写`R`命令，将进入替换模式（屏幕底部显示“--REPLACE--”）。此时新输入的文本将直接替代/覆盖已经存在的内容，直至点击ESC键返回常规模式。

![img](https://pic4.zhimg.com/v2-5f7e4b5fd99244f6e61faa27ad1c2b47_b.jpg)

Source: medium.com/vim-drops

使用小写`r`命令，将进入单字符替换模式，此时新输入的字符将替代光标之下的当前字符，然后自动返回到常规模式。

通过在r命令中增加数字前缀，可以一次性替换多个字符。例如，将光标定位到“||”字符处，然后执行`2r&`命令，可以将其替换为“&&”。

使用`gR`命令，将进入虚拟替换模式（virtual replace mode）（屏幕底部显示“--VREPLACE--”），其与替换模式最主要的区别在于，对<Tab>键和换行符的不同处理方式。

**区别1**：对于<Tab>键的处理方式

在替换模式（REPLACE）下，在原有<Tab>键处输入字母'a'，将直接替代<Tab>键所占用的所有空格的位置，文本格式遭到破坏：

![img](https://pic2.zhimg.com/v2-ecdbd6903e53640aa3375ecd30287665_b.jpg)

Source: medium.com/vim-drops

在虚拟替换模式（VREPLACE）下，在原有<Tab>键处输入字母'a'，将仅仅替代单个空格，文本格式保持不变：

![img](https://pic3.zhimg.com/v2-b56eefbb4621e514947c3d6d3468a8e6_b.jpg)

Source: medium.com/vim-drops

从以上实例可以发现：替换模式（REPLACE）将<Tab>键作为一个整体来处理（不管其真实占用多少个空格位置）；而虚拟替换模式（VREPLACE）则将<Tab>键拆分为多个独立的空格来分别处理。如果文本以<Tab>分隔排布，在编辑过程中希望保持原有的文本缩进和排版格式，那么建议使用虚拟替换模式。

**区别2**：对于<NL>换行的处理方式

在替换模式（REPLACE）下，输入<Enter>回车键将增加新行：

![img](https://pic1.zhimg.com/v2-367c4040a882967123dc8313fa71b07c_b.jpg)

在虚拟替换模式（VREPLACE）下，输入<Enter>回车键将用新行替代当前行内容（即清空当前行）：

![img](https://pic2.zhimg.com/v2-a35b4ddd13e27f83ad49853992b375f5_b.jpg)

使用`gr`命令，可以进入单字符虚拟替换模式。在替换光标下的当前字符之后，将自动返回到常规模式。

请注意，只有包含+vreplace特性的Vim版本才支持虚拟替换模式。请使用`:version`命令，查看特性列表中是否已包括此项。

请使用以下命令，查看关于虚拟替换模式的更多帮助信息：

```vim
:help vreplace-mode
```

**退出替换模式**

按下ESC键即可离开替换模式，返回到常规模式。

![img](https://pic3.zhimg.com/80/v2-ce05ca5c8c492f96fec92ede9c33d5b2_720w.jpg)



编辑于 2019-07-07