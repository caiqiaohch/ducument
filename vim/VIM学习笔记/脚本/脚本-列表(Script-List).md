# 脚本-列表(Script-List)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

7 人赞同了该文章

列表（List），是一组由逗号分隔的项目的有序序列。它与其它编程语言中的数组（Array）概念非常相似。可以使用索引号来访问列表项目。也可以在序列的任何位置上增加或者删除项目。

请注意下文中引号后的文字为命令执行的结果，以演示各个函数的功能。

## 创建列表

可以将一组由逗号分隔的项目放置在方括号之内，以创建一个列表。列表中的项目索引从0开始。可以使用[n]形式，来引用特定的列表项目。

```vim
let data = [1,2,3,4,5,6,"seven"]
echo data[0]                            " 1
let data[1] = 42                        " [1,42,3,4,5,6,"seven"]
let data[2] += 99                       " [1,42,102,4,5,6,"seven"]
let data[6] .= ' samurai'               " [1,42,102,4,5,6,"seven samurai"]
```

使用[m:n]形式，可以引用指定范围的列表项目。

```vim
let data = [-1,0,1,2,3,4,5]
let positive = data[2:6]                 " [1,2,3,4,5]
```

如果忽略索引的起始位置，那么将默认从列表首个项目开始；如果忽略索引的结束位置，那么将默认至列表最后一个项目。

```vim
let middle = len(data)/2                 " middle = 3
let first_half = data[: middle-1]        " data[0 : middle-1]
echo first_half                          " [-1,0,1]
let second_half	= data[middle :]         " data[middle : len(data)-1]
echo first_half                          " [2,3,4,5]
```

使用range()函数，可以生成一个整数值的列表。 range(max)将生成从0到max-1的列表；range(min, max)将生成包含min和max在内的连续值列表；range(min, max, step)将从min到max，按照step指定的步长来生成列表。

```vim
let seq_of_ints = range(5)               " [0,1,2,3,4]
let seq_of_ints = range(1,5)             " [1,2,3,4,5]
let seq_of_ints = range(1,10,2)          " [1,3,5,7,9]
```

## 列表嵌套

除了数值和字符串之外，列表中也可以包含嵌套的列表。

```vim
let pow = [
\   [ 1, 0, 0, 0  ],
\   [ 1, 1, 1, 1  ],
\   [ 1, 3, 9, 27 ]
\]

echo pow[2][3]     " 27

" [2]，指第3个嵌套列表
" [3]，指嵌套列表中的第4个项目
```

## 引用列表

将变量赋值为列表时，实际上是将变量指向列表；如果再次将该变量赋给其它变量，那么这两个变量都将指向同一个列表。也就是说，对于实际列表值的变更，将同时影响所有指向它的变量。

```vim
let old_suffixes = ['.c', '.h', '.py']
let new_suffixes = old_suffixes
let new_suffixes[2] = '.js'
echo old_suffixes      " ['.c', '.h', '.js']
echo new_suffixes      " ['.c', '.h', '.js']
```

## 复制列表

使用copy()函数复制列表，就可以使用不同的变量，来保存不同状态下的列表值。

```vim
let old_suffixes = ['.c', '.h', '.py']
let new_suffixes = copy(old_suffixes)
let new_suffixes[2] = '.js'
echo old_suffixes      " ['.c', '.h', '.py']
echo new_suffixes      " ['.c', '.h', '.js']
```

请注意，copy()函数只会复制最顶层的列表，即列表的浅备份。如果顶层列表包含嵌套列表，那么嵌套的子列表，将仅仅被作为指向实际子列表的指针被复制。也就是说，对于实际子列表的更改，将同时影响所有指向它的变量。

```vim
let pedantic_pow = copy(pow)
echo pow               " [[1, 0, 0, 0], [1, 1, 1, 1], [1, 3, 9, 27]]
echo pedantic_pow      " [[1, 0, 0, 0], [1, 1, 1, 1], [1, 3, 9, 27]]

let pedantic_pow[0][0] = 'vague'
echo pow               " [['vague', 0, 0, 0], [1, 1, 1, 1], [1, 3, 9, 27]]
echo pedantic_pow      " [['vague', 0, 0, 0], [1, 1, 1, 1], [1, 3, 9, 27]]

" also changes pow[0][0] due to shared nested list
```

使用deepcopy()函数，则可以复制顶层列表及其包含的嵌套列表，即列表的完整备份。

```vim
let pedantic_pow = deepcopy(pow)
echo pow               " [[1, 0, 0, 0], [1, 1, 1, 1], [1, 3, 9, 27]]
echo pedantic_pow      " [[1, 0, 0, 0], [1, 1, 1, 1], [1, 3, 9, 27]]

let pedantic_pow[0][0] = 'vague'
echo pow               " [[1, 0, 0, 0], [1, 1, 1, 1], [1, 3, 9, 27]]
echo pedantic_pow      " [['vague', 0, 0, 0], [1, 1, 1, 1], [1, 3, 9, 27]]

" pow[0][0] now unaffected; no nested list is shared
```

## 拆分列表

使用split()函数，可以将字符串拆分为列表：

```vim
let words = split("one two three")          " 以空格为分隔符
echo words                                  " ['one', 'two', 'three']

let words = split("one:two three", ":")     " 以指定字符为分隔符
echo words                                  " ['one', 'two three']
```

## 合并列表

使用join()函数，可以将列表中的项目合并为字符串：

```vim
let list = ['one', 'two', 'three']
let str = join(list)                        " 使用空格连结列表项目
echo str                                    " one two three
let str = join(list, ';')                   " 使用指定字符连结列表项目
echo str                                    " one;two;three
```

## 列表长度和位置

使用以下函数，可以计算列表的长度，以及在列表中所处的位置：

```vim
let list = [1, 2, 3]
let list_length   = len(list)             " 列表的项目总数
echo list_length                          " 3
let greatest_elem = max(list)             " 列表项目的最大值
echo greatest_elem                        " 3
let least_elem    = min(list)             " 列表项目的最小值
echo least_elem                           " 1
let list_is_empty = empty(list)           " 将列表置为空
echo list_is_empty                        " 0

let week = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat','Sun']
let value_found   = index(week, 'Sun')    " 第一次出现指定值的索引位置
echo value_found                          " 0
let value_found   = index(week, 'sun')    " 如果没有找到匹配值(区分大小写)将返回-1
echo value_found                          " -1
let value_count   = count(week, 'Sun')    " 出现指定值的次数
echo value_count                          " 2
```

## 增加列表项目

```vim
call insert(list, newval)          " 在列表开头增加新项目
call insert(list, newval, idx)     " 在列表指定位置之前增加新项目
call    add(list, newval)          " 在列表末尾增加新项目
```

## 删除列表项目

```vim
call remove(list, idx)             " 删除指定位置的项目
call remove(list, from, to)        " 删除指定范围的项目
```

## 排序列表项目

```vim
let list = [3, 2, 1]
call sort(list)                   " 为列表排序
echo list                         " [1, 2, 3]
call reverse(list)                " 反转列表项目的排序
call list                         " [3, 2, 1]
```

## 过滤列表项目

使用filter({expr1}, {expr2})函数，可以对{expr1}指定的列表中的每个项目计算{expr2}表达式，以过滤掉符合指定模式的项目。

```vim
let data = [-1,0,1,2,3,4,5]
let positive = filter(copy(data), 'v:val >= 0')       " 过滤掉负数
echo positive                                         " [0,1,2,3,4,5]

let words = ['Linux', 'Unix', 'Mac']
let nnix = filter(copy(words), 'v:val !~ ".*nix"')    " 过滤包含nix的字符串
echo nnix                                             " ['Linux', 'Mac']

call filter(words, 0)                                 " 过滤掉所有项目
echo words                                            " []
```

## 修改列表项目

使用map({expr1}, {expr2})函数，可以将{expr1}指定的列表中的每个项目替换为{expr2}表达式的的计算结果。

```vim
let data = [-1,0,1,2,3,4,5]
let inc = map(copy(data), 'v:val + 1')                " 为每个成员+1
echo inc                                              " [0,1,2,3,4,5,6]

let words = ['Linux', 'Unix', 'Mac']
let cap = map(copy(words), 'toupper(v:val)')          " 将每个成员转换为大写
echo cap                                              " ['LINUX', 'UNIX', 'MAC']
```

## 连结列表

使用`+`和`+=`操作符，可以连结多个列表。

```vim
let activities = ['sleep', 'eat'] + ['drink']         " ['sleep', 'eat', 'drink']
let activities += ['code']                            " ['sleep', 'eat', 'drink', 'code']
```

请注意，操作符两侧必须均为列表。如果将列表与其它类型的数据连结，将会报错：

```vim
let activities += 'code'                              " E734: Wrong variable type for +=
```

## 常见问题

请注意，所有列表相关的函数都将修改后的列表作为返回结果，同时参数中的列表也将被修改。而通常，我们会希望返回修改后的列表，但保持原始列表不变。因此，建议使用[copy()](file:///E:/Anthony_GitHub/learn-vim/learn-vim-Script-List.html#script-list-copu)函数来复制原始列表作为参数，以避免其被修改。

```vim
let new_values = map(values, 'v:val * v:val')             " values和new_values均被修改
let new_values = map(copy(values), 'v:val * v:val')       " values保持不变

let sorted_list = reverse(sort(unsorted_list))            " unsorted_list和sorted_list均被修改
let sorted_list = reverse(sort(copy(unsorted_list)))      " unsorted_list保持不变
```

## 帮助信息

**？**使用以下命令，可以查看列表相关的帮助信息：

```vim
:help list
:help list-functions 
```

![img](https://pic3.zhimg.com/80/v2-d043a64dd74cc9b08d3c55a509812bd6_720w.jpg)



发布于 01-19