# 脚本-自定义函数 (Script-User Defined Function)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

2 人赞同了该文章

使用脚本语言，可以更灵活地定制编辑器以完成复杂的任务。

## **定义函数**

Vim编辑器允许用户自定义函数，语法如下：



```vim
function Name(arg1, arg2,...argN) keyword
  code_to_execute_when_function_is_called
endfunction
```

[view raw](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/8ccf228e869fb644f395e1756095de3d/raw/0b1292c25fa9a6a5ab2ad25b986446b71f055d3a/FunctionDef.vim)[FunctionDef.vim](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/8ccf228e869fb644f395e1756095de3d%23file-functiondef-vim)hosted with ❤ by[GitHub](https://link.zhihu.com/?target=https%3A//github.com/)

*Name*，函数名称必须以大写字母开始，并且只可以包含字母、数字和下划线。

*arg1-argN*，调用函数时需要为命名参数（Named Parameters）赋值。如果不需要任何参数，那么可以将括号()部分置空。最多可以定义20个参数。

*keyword*，range关键字定义一个范围函数（:function Count_words() range）会针对范围内的每一行重复执行操作；abort关键字指示函数（:function Do_It() abort）会在第一个错误时退出。

下面我们来定义一个函数，用来返回两个数中较小的一个：


[https://gist.github.com/yyq123/4c18997ffac9a857d6d0f0b452923df4/raw/af83a90aee964b976e56da7e4b94d5ed21198065/FunctionSmaller.vim](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/4c18997ffac9a857d6d0f0b452923df4/raw/af83a90aee964b976e56da7e4b94d5ed21198065/FunctionSmaller.vim)[view raw](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/4c18997ffac9a857d6d0f0b452923df4/raw/af83a90aee964b976e56da7e4b94d5ed21198065/FunctionSmaller.vim) 

return 语句用于返回结果并结束函数。return语句之后的所有代码都不会被执行。

如果尝试定义一个已经存在的函数，那么将会收到报错信息。可以使用!来强制重定义同名函数。

```vim
:function! Max(num1, num2, num3)
```

Vim允许在函数中使用“...”来标识个数不定的可变参数（Variadic Parameters）。例如以下代码定义函数至少有2个参数，最多有20个参数：



```vim
function PrintSum(num1, num2,...)
  let sum = a:num1 + a:num2
  let argnum = 1
  while argnum <= a:0
    let sum += a:{argnum}
    let argnum+=1
  endwhile
  echo "the sum is " sum
  return sum
endfunction
```

[view raw](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/ff3e8bc64a9bcf9f3745602da5a9aba9/raw/991bca1cdc2dad205657450f72f95c1b4c445c61/FunctionPrintSum.vim)[FunctionPrintSum.vim](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/ff3e8bc64a9bcf9f3745602da5a9aba9%23file-functionprintsum-vim)hosted with ❤ by[GitHub](https://link.zhihu.com/?target=https%3A//github.com/)

*argnum* 计数器，用于记录num1和num2之后的参数个数；

*a:num1* 变量，用于访问指定的参数；

*a:0* 变量，用于记录参数总个数；

*a:{argnum}* 变量，用于访问每一个参数的值，例如a:1或a:2；

以下范围函数实例，将在指定范围行内执行替换操作：


[https://gist.github.com/yyq123/e1abcf60f06f92a74995b4c481530f27/raw/69095eade65c61226fd256f54ab123279d3347ce/DeAmperfyAll.vim](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/e1abcf60f06f92a74995b4c481530f27/raw/69095eade65c61226fd256f54ab123279d3347ce/DeAmperfyAll.vim)[view raw](https://link.zhihu.com/?target=https%3A//gist.github.com/yyq123/e1abcf60f06f92a74995b4c481530f27/raw/69095eade65c61226fd256f54ab123279d3347ce/DeAmperfyAll.vim) 

```vim
:1,$call DeAmperfyAll()
```

## **调用函数**

可以在表达式中调用函数：

```vim
:let tiny = Min(10,20)
```

还可以使用:call命令来调用函数：

```vim
:[range]call {function}([parameters])
```

## **列示函数**

使用以下命令，可以列出所有用户定义的函数：

```vim
:function
```

使用以下命令，可以查看指定函数的代码：

```vim
:function {name}
```

使用以下命令，可以查看Vim内置函数的使用说明：

```vim
:help functions
```

## **删除函数**

使用以下命令，可以删除指定的函数：

```text
:delfunction {name}
```

编辑于 2017-06-12