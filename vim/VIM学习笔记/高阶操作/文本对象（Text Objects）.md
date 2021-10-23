# 文本对象（Text Objects）

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

13 人赞同了该文章

在Vim中，相比针对单个字符进行操作，对于单词、句子和段落等更大范围的文本对象（**text-objects** ）执行命令则更有效率。Vim的命令结构示例如下：

```text
[number]<command>[text object or motion]
```

其中：**number**是指命令作用在几个文本对象之上。比如3个单词；**command**是指执行的具体命令。比如删除或复制；**text object or motion**是指具体的文本对象。比如单词、句子或段落。

## **文本对象的类型**

- iw …inner word
- aw …a word
- iW …inner WORD
- aW …a WORD
- is …inner sentence
- as …a sentence
- ip …inner paragraph
- ap …a paragraph
- it …inner tag
- at …a tag
- i( or i) …inner block
- a( or a) …a block
- i< or i> …inner block
- a< or a> …a block
- i{ or i} …inner block
- a{ or a} …a block
- i[ or i] …inner block
- a[ or a] …a block
- i" …inner block
- a" …a block
- i` …inner block
- a` …a block

## **文本对象的作用范围**

iw表示**inner word**。如果键入viw命令，那么首先v将进入选择模式，然后iw将选中当前单词。

aw表示**a word**，它不但会选中当前单词，还会包含当前单词之后的空格。

以下实例中的红色 [ ] 表示作用范围：

![img](https://pic3.zhimg.com/80/v2-619cfb99d5a5f8340a95aed5b244212a_720w.png)

## **文本对象的应用实例**

使用ci)命令，可以删除括号内的所有内容，但保留括号本身。而ca)命令，则可以删除括号内的所有内容，以及括号本身。

![img](https://pic2.zhimg.com/80/v2-d887e03144ccb26ec098053eb221edb1_720w.png)

在某个开括号上，点击%键，光标将可以自动移动到相对应的闭括号上。通过与编辑命令组合，c%可以实现与ca)相同的功能。使用%命令，必须将光标放在括号之上；而使用a)命令，则光标可以在括号之上或括号内的任何位置。而且%命令，也是无法实现用i)命令效果的。

![img](https://pic2.zhimg.com/80/v2-eb5810d5fe18c62f3095391259a50785_720w.png)

使用cit命令，你甚至不用将光标移动到Tag之内，就可以快速修改其中的内容。

![img](https://pic1.zhimg.com/80/v2-d2e0ff07fa2306c695a8c693e6446d78_720w.png)

Ver: 1.1<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/02/vim_4321.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/02/vim_27.html)>