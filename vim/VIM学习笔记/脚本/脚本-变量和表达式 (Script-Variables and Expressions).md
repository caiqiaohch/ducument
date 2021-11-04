# 脚本-变量和表达式 (Script-Variables and Expressions)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

使用脚本语言，可以更灵活地定制编辑器以完成复杂的任务。

## **定义变量**

使用以下命令，可以为变量赋值：

```vim
:let {variable}={expression}
```

Vim中的变量名可以包含字符、数字和下划线，但必须以字符或是下划线开头。

例如使用以下命令，定义变量line_size：

```vim
:let line_size=30
```

使用:echo命令，可以查看变量的内容：

```vim
:echo "line_size is"line_size
```

命令执行以后，Vim将会在屏幕底部显示如下内容：

```text
line_size is 30
```

## **变量类型**

Vim使用特殊的前缀来指明不同的变量类型：

![img](https://pic3.zhimg.com/80/v2-a51007572723f11b2333d423b3afc5b6_720w.png)

使用以下命令，可以定义环境变量$PAGER，用于指明查看的命令：

```vim
:let $PAGER="/usr/local/bin/less"
```

使用以下命令，可以显示上一次查找的模式：

```vim
:echo "Last search was"@/
```

使用以下任一命令，都可以设置缩进选项：

```vim
:let &autoindent=1
:set autoindent
```

使用以下命令，可以指定当前缓冲区的语法高亮显示：

```vim
:let b:current_syntax=c
```

Vim使用以下内部变量(v:name)存储相关信息：

![img](https://pic1.zhimg.com/80/v2-a77a6ae8bd8ae2a2ccd7030b7d18092c_720w.png)

以下为不同类型变量的实例：



```vim
let g:sum=0
function SumNumbers(num1,num2)
	let l:sum = a:num1+a:num2
	"check if previous sum was lower than this
	if g:sum < l:sum
		let g:sum=l:sum
	endif
endfunction
" test code
call SumNumbers(3,4)
" this should return 7
echo g:sum
```

[view raw](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/3c1db548929b59aa00f87917f5de6d8c/raw/a7ffb81e1d4f876d7e80a4ddcd1a46ed2763a665/VarScope.vim)[VarScope.vim](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/3c1db548929b59aa00f87917f5de6d8c%23file-varscope-vim)hosted with ❤ by[GitHub](https://link.zhihu.com/?target=https%3A//github.com/)

## **删除变量**

如果要删除一个变量，那么可以使用以下命令：

```vim
:unlet[!] {name}
```

如果试图删除一个不存在的变量，那么Vim就会报错；而如果使用!标记，则不会显示错误信息。

## **定义常量**

数字常量有以下三种：

- 八进制（Octal Integer）：0123
- 十进制（Simple Integer）：123
- 十六进制（Hexadecimal）：0xAC

Vim可以处理多种格式数字的计算：

```vim
:echo 10 + 0x0A + 012
```

字符常量有以下两种：

- 简单字符串（Simple String）："string"
- 精确字符串（Literal String）：'string'

在双引号包围的字符串内，可以使用反斜线进行转义；而被单引号包围的字符串，则会被原样输出:

命令：echo "\100"
输出：@

命令：echo '\100'
输出：\100

## **算术运算**

Vim可以使用以下算术运算符，进行表达式计算：

int+int 加
int-int 减int*int 乘int/int 除int%int 取余-int 取负

逻辑运算符可以作用于字符串和整数，Vim将自动在这两种数据类型之间进行转换。如果比较成功则返回1，否则返回0。

var == var 等于
var != var 不等var < var 小于var > var 大于var < var 小于等于var >= var 大于等于

```vim
"word"=~"\w*"
```

字符串的特殊比较包括：

string =~ regexp 匹配的正则表达式
string !~ regexp 不匹配的正则表达式string ==? string 字符串相等,忽略大小写string ==# string 字符串相等,大小写敏感string !=? string 字符串不相等,忽略大小写string !=# string 字符串不相等,大小写敏感string <? string 小于,忽略大小写string <# string 小于,大小写必须敏感string <=? string 小于等于,忽略大小写string <=# string 小于等于,大小写敏感string >? string 大于,忽略大小写string ># string 大于,大小写敏感string >=? string 大于等于,忽略大小写string >=# string 大于等于,大小写敏感

## **文件名**

当我们输入文件名时，可以使用以下特殊符号：

![img](https://pic2.zhimg.com/80/v2-1de363137d94734fcdd675b006e04159_720w.png)

我们可以使用以下修饰符来扩展以上特殊符号的意义。例如*:p*可以将文件名转换为包括路径的全名。例如光标下的文件名为*test.c*，*>*是*test.c*，那么**就是*/home/oualline/examples/test.c*

修饰符主要包括：

![img](https://pic3.zhimg.com/80/v2-c9b2a1bcf2482e8971dd8621d64cff8a_720w.png)

使用以下命令，可以利用:p修饰符显示完整的当前文件名。你可以将命令中的:p换成其他需要测试的修饰符。

```vim
:echo expand("%:p")
```

Ver: 1.0<[上一篇](https://link.zhihu.com/?target=http%3A//bit.ly/vim-regex-basic) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-List.html)| [下一篇](https://link.zhihu.com/?target=http%3A//bit.ly/vim-regex-adv)>

编辑于 2017-05-24