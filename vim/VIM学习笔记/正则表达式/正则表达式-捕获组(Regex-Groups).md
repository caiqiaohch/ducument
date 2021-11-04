# 正则表达式-捕获组(Regex-Groups)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

6 人赞同了该文章

`()`用于保证需要作为整体而组合出现的字符。例如表达式`a\(XY\)*b`将会匹配ab, aXYb, aXYXYb, aXYXYXYb。

逆向引用（Back Reference）表达式`\n`，用于引用之前定义的第n个捕获组。其中n为数字1–9。

例如对于文本“he fly fly flies”，表达式`\(fly\) \1`将匹配“fly fly”。因为`\1`再次引用了第一个捕获组“fly”，所以将匹配2个“fly”。

## 捕获组匹配

![img](https://pic2.zhimg.com/80/v2-ac093c29ff9cec91690036f0bdfe1a71_720w.jpg)

假设需要查找以上多种格式的电话号码，其中：

- 可能包含区号，也可能没有区号；
- 区号由3位数字组成；
- 区号可能被括号包围，也可能没有括号；
- 区号和号码之间，可能有横线或者空格相连，也可能没有任何连接符；
- 号码由3位数字，横线连接符，和4位数字组成。

使用以下命令，可以满足以上格式需求：

![img](https://pic4.zhimg.com/80/v2-2a229df815be2abf67960287676264c7_720w.jpg)

由此可见，将区号及其后的连接符作为一个整体捕获为组，这样就可以通过后续的 \? 表达式来匹配0个或1个捕获组，以实现匹配包含区号和不包含区号的多种情况。

## 捕获组嵌套

以下文本中包含FIRSTNAME LASTNAME格式的姓名信息：

```text
Prepared by Tommas Young
Prepared by Tommy Young
```

使用以下命令，可以将其转换为LASTNAME, FIRSTNAME格式：

```vim
:%s/\(Tom\%(mas\|my\)\) \(Young\)/\2, \1/g
Prepared by Young, Tommas
Prepared by Young, Tommy
```

从以上命令可以看到，捕获组是可以嵌套的；\%(\) 指定的组将不会被计数，这可以允许我们使用更多的组，并且查找速度也更快。

## 捕获组替换

假设需要将以下文本中的单引号替换为双引号：

```text
The string contains a 'quoted' word.
The string contains 'two' quoted 'words'.
The 'string doesn't make things easy'.
The string doesn't contain any quotes, isn't it.
```

通过以下命令中的嵌套捕获组来完成替换操作：

```vim
:%s/\s'\(\('\w\|[^']\)\+\)'/ "\1"/g
The string contains a "quoted" word.
The string contains "two" quoted "words".
The "string doesn't make things easy".
The string doesn't contain any quotes, isn't it.
```

其中，\s' 用于匹配紧跟在空格之后即单词开头的单引号；\('\w\|[^']\) 则将非开头的单引号视为单词的一部分，以防止其被替换位双引号。

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-81-RegularExpressionBasic.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Regex-Metacharacters.html)>