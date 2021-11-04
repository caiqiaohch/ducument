# 正则表达式-进阶（Regular Expression Advanced）

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

## **范围（Character Ranges）**

**[]**通配符，表示只可以匹配方括号内列表的字符。例如**t[aeiou]n**将匹配一个小写元音字符，可以找到tan,ten,tin,ton,tun。

在方括号内，可以通过短横线来指明包括字符或数字的范围。例如**[0-9]**可以匹配0到9中的任一数字。我们还可以组合其他字符，例如**[0-9aeiou]**可以匹配任意一个数字或是小写的元音字符。

如果需要匹配"-"本身，那么需要使用反斜杠进行转义。例如表达式**one[\-]way**可以匹配one-way，但不会匹配one way。

![img](https://pic3.zhimg.com/80/v2-5717041bd05934743b4f60dee7ed831a_720w.png)



## **排除（Excluding）**

**^**通配符，可以排除指定的字符。

**acme[^0-9]**匹配所有包含acme，后跟一个非数字字符的行。但不会匹配以acme结尾的行，因为模式中的acme之后必须有一个字符。

**^[^a-zA-Z]**匹配以非字母开头的行，但不会匹配空行，因为行中必须有一个非字母字符存在。

如果需要匹配"^"本身，那么需要使用反斜杠进行转义。例如表达式**2[\^\*]4**可以匹配2^4和2*4。

## **重复次数（Repeat Modifiers）**

**{minimum,maximum}**表达式指出一个字符重复的次数。例如表达式**a\{3,5}**可以匹配3到5个a（aaa，aaaa，aaaaa）。Vim默认是会尽可能多地进行匹配（Matching as much as possible）。在表达式中，最小次数是可以省略的，即默认最小次数为0，所以表达式**a\{,5}**可以匹配0到5个a。最大次数也是可以省略的，即默认匹配无穷大，所以表达式**a\{3,}**最少可以匹配3个a，最多个数没有限制。

**{number}**表达式只指定一个数字，Vim就会精确的匹配相应的次数。例如**a\{5}**只会精确的匹配5次。

**{-minimum,maximum}**在数字前增加一个负号(-)，那么Vim在查找时就会尽可能少地进行匹配（Matching as little as possible）。例如**ab\{-1,3}**将只匹配 "abbb"中的"ab"。表达式**a\{-3,}**可以匹配三个或是更多个a，但尽可能少地进行匹配。而表达式**a\{-,5}**可以匹配0到5个字符。

![img](https://pic2.zhimg.com/80/v2-bbc93c4aafeb95e40b4ffefef2aafe25_720w.png)

表达式**a\{-5}**将会精确的匹配5个字符。

![img](https://pic1.zhimg.com/80/v2-63fea3e184ee2c5602d100a7e52bfefc_720w.png)



## **捕获组（Groups）**

()用于保证需要组合出现的字符。表达式**a\(XY\)\*b**将会匹配ab, aXYb, aXYXYb, aXYXYXYb。

## **或操作（Alternation Operator）**

|用于查找两个或是多个可能的匹配。例如表达式**foo\|bar**可以找到foo或是bar。我们可以连接使用多个或运算符，例如表达式**Larry\|Moe\|Curly**将找到Larry、Moe和Curly。而表达式**end\(if\|while\|for\)**则可以匹配"endif", "endwhile" 和 "endfor"几个不同的元素组合。

如果希望匹配多次，那么可以组合使用加号和括号运算符。例如表达式**/\(foo\|bar\)\+**可以匹配 "foo", "foobar", "foofoo", "barfoobar"等等。

## **特殊字符元素（Special Character Atoms）**

![img](https://pic3.zhimg.com/80/v2-220a079d462a4c7da5044644f13788f6_720w.png)

表达式**\a**匹配任意字符，而表达式**\a\a\a**则可以匹配任意三个字符。而**\a\a\a_**则可以匹配任意后带一个下划线的三个字符。

![img](https://pic2.zhimg.com/80/v2-21480d99ff4989396e8d5f10b01b3149_720w.png)

操作符**\d**可以匹配任意数字；**\d\d\d\d**则可以匹配任意四个数字（即使其为更长数字串中的一部分）。

![img](https://pic3.zhimg.com/80/v2-5672f4ec8ef5d9dec4d8fe8cea623566_720w.png)

如果希望精确匹配四位数字，那么可以使用以下任一命令：

```vim
/\<\d\d\d\d\>
/\<\d\{4}\>
```

![img](https://pic2.zhimg.com/80/v2-c9a2f87ae76d434894bf85caf3984e3d_720w.png)

**\u**可以匹配任意大写字符；**\U**则可以匹配任意非大写字符。使用以下命令，可以将整篇文本替换为大写字母：

```vim
:%s/.*/\U&/
```

如果需要找出包含空格的空行，那么可以使用**^\s.\*$**表达式；如果需要找到没有空格的空行，则可以使用**\S**

**\s\+$**可以匹配尾部的空格； **\+\ze\t**则可以匹配Tab制表符之前的空格。（请注意，此表达式开头为空格）

请注意，以上预定义字符是不能内嵌在[]中使用的。例如，表达式[\d\l]是错误的，应使用**\(\d\|\l\)**表达式匹配数字或小写字符。

## **预定义字符类（Character Classes）**

如果我们想要查找所有大写字符，可以使用表达式**[A-Z]**，或者使用预定义的字符类[:upper:]。使用**/[[:upper:]]**命令可以匹配所有大写字母；而使用**/[[:upper:][:lower:]]**命令则可以匹配包括大写和小写字母在内的所有字母。

![img](https://pic4.zhimg.com/80/v2-19e8fba1611f264b656058615e84632b_720w.png)



## **转义符（Escaped Characters ）**

如果需要查找某些特殊符号（比如美元符号），那么可以使用反斜杠backslash（\）进行转义。例如：表达式**\$**可以匹配美元符号（$），而表达式**\^**则可以匹配脱字符（^）。需要注意的是，反斜杠backslash（\）本身也是特殊符号，所以需要用两个反斜杠\\来匹配。

## **帮助信息（Help）**

可以使用以下命令，查看关于查找模式的更多帮助信息：

```vim
:help pattern
```

编辑于 2017-05-04