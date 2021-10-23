# 在文本对象间移动(motion-object)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

13 人赞同了该文章



![img](https://pic4.zhimg.com/80/v2-71838805a8390cdc1e5549bf8acec9c7_720w.jpg)Originally from Practical Vim by Drew Neal

使用以下命令，可以按照[文本对象](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-10-TextObjects.html)（Text Objects）为单位来快速移动；同时，对于浏览C、Java代码和HTML、Markdown等标签语言文档，也更加友好和高效。当然，以下命令也接受[count]参数，以跳转多个对象。

## **按文本对象移动**

![img](https://pic1.zhimg.com/80/v2-f068c5ddf914159f5649f37c90ea8bdc_720w.jpg)

句子（sentence），是以 '.'、'!' 或者 '?' 结尾并紧随着一个换行符、空格或者制表符。结束标点和空白字符之间可以出现任何数量的闭括号和引号: ')'、']'、'"' 和 '''。段落和小节的边界也视为句子的边界。

段落（paragraph），是以每个空行或段落宏命令开始，段落宏由 'paragraphs' 选项里成对出现的字符所定义。它的缺省值为 "IPLPPPQPP TPHPLIPpLpItpplpipbp"，也就是宏 ".IP"、".LP"等 (这些是 nroff 宏，所以句号一定要出现在第一列)。小节边界也被视为段落边界。注意，空白行不是段落边界。

小节（section），是以每个首列出现的换页符（<C-L>，<FF>）或小节宏命令开始。小节宏由 'sections' 选项里成对出现的字符所定义。它的缺省值是 "SHNHH HUnhsh"，也就是宏 ".SH"、".NH"、".H"、".HU"、".nh" 和 ".sh"。

## **按其他对象移动**

![img](https://pic4.zhimg.com/80/v2-e8d6119a6e4c954c01848c8f181b3557_720w.jpg)

## **操作实例**

如果感觉以上介绍云山雾罩，那么不妨对照以下操作实例，请注意：

- 绿色，标志光标初始位置；
- 红色，标志光标移动到的目的位置；
- 橙色，标志光标移动的轨迹；
- 图片来源于[of-vim-and-vigor.blogspot.com](https://link.zhihu.com/?target=https%3A//of-vim-and-vigor.blogspot.com/2012/11/vim-motions.html)

![img](https://pic2.zhimg.com/80/v2-33ab7e788ec62c83bc035b7cffa52c95_720w.jpg)

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-02-Move.html.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-10-TextObjects.html.html)>