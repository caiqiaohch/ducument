# 脚本-语句 (Script-Statements)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

使用脚本语言，可以更灵活地定制编辑器以完成复杂的任务。

## **:echo命令**

:echo可以显示命令中的参数。

```vim
:echo "Hello world"
Hello world
```

:echo还可以显示变量的值。

```vim
:let flag=1
:echo flag
1
```

使用|可以分隔同一行中的两个命令。

```vim
:echo "aa" | echo "bb"
aa
bb
```

:echon也只显示命令中的参数，但不会输出新行。

```vim
:echon "aa" | echon "bb"
aabb
```

可以通过:echohl命令，使用指定高亮颜色组输出信息。

```text
:echohl ErrorMsg
:echo "A mistake has been make"
A mistake has been make
```

为了不影响后续:echo命令的显示效果，建议使用以下命令重设高亮显示为None：

```vim
:echohl None
```

使用以下命令，可以查看[高亮显示组](https://link.zhihu.com/?target=http%3A//bit.ly/vim-syntaxHL)的颜色定义：

```vim
:highlight
```

在:echo命令中，可以使用以下转义符：

- \n Newline
- \r Carriage return
- \t Tab
- \123 八进制数字
- \x123 十六进制数字
- \u01fc34 Unicode
- \f Form feed
- \e Esc
- \b Backspace
- \\ 反斜线

## **判断**

if语句的一般形式如下：



```vim
if condition
	code_to_execute_if_condition_is_met
endif
```

只有条件(condition)为真时，if语句块内的语句才会被执行。

if语句还可以包含else子句：


[https://gist.github.com/yyq123/4745a7c937e2f50ea3cdf7a97b43d5dc/raw/021b00a8cf02a9e48e16839e610296b8c4db0691/ifelse.vim](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/4745a7c937e2f50ea3cdf7a97b43d5dc/raw/021b00a8cf02a9e48e16839e610296b8c4db0691/ifelse.vim)满足条件(condition)时，if语句块内的语句将会被执行；而不满足条件(condition)时，则else语句块内的语句将会被执行。

```vim
if condition1
	code_to_execute_if_condition1_is_true
else
	if condition2
		code_to_execute_if_condition2_is_true
	endif
endif
```

## **循环**

while命令开始一个循环，并由endwhile命令结束。在条件为真是，循环中的代码将被重复执行。


[https://gist.github.com/yyq123/f87f86115272d5a9a0ab24682d03d1cc/raw/728d5911eb53c7dff39df95cd72fdab126bfa6b2/while.vim](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/f87f86115272d5a9a0ab24682d03d1cc/raw/728d5911eb53c7dff39df95cd72fdab126bfa6b2/while.vim)

continue命令回到程序的顶部开始执行下一次循环；而break命令则立刻退出循环。



```vim
while conter < 30
	if skip_flag
		continue
	endif
	if exit_flag
		break
	endif
endwhile
```

**:execute命令**

:execute将执行参数中指定的命令：

```vim
:let command = " echo 'Hello world!'"
:execute command
Hello world
```

编辑于 2017-06-06