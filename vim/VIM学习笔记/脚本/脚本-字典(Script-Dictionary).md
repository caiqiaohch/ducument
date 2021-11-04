# 脚本-字典(Script-Dictionary)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

7 人赞同了该文章

可以将字典（Dictionary)，理解为存储了关于键-值的成对的二元数组。如果你知道了键，就能快速地查找它对应的值。

## 创建字典

使用以花括号包含逗号分隔的键-值列表，来创建字典。每个项目包含以冒号分隔的键和值。

```vim
let flavor = {
\ '01': 'guava',
\ '02': 'mangosteen',
\ '03': 'mango',
\ '04': 'banana',
\ '05': 'coconut',
\ '06': 'passionfruit',
\ '07': 'watermelon',
\ '08': 'papya'
}

"创建空字典
let emptydict = {}
```

## 访问字典

可以使用以方括号包围的索引编号，来访问字典的值；而更直观的方式，是使用键的名称：

```vim
let Dx = flavor['09']
```

如果键只包含字母、数字和下划线，那么可以使用以点标记的形式进行访问。这种类似“表名.列名”的书写形式，非常类似于数据库的记录格式，显得更简洁也更易读：

```vim
let user = {}
let user.name = 'Bram'
let user.acct = 123007
```

如果键不存在，那么将显示以下报错信息：

```
E716: Key not present in Dictionary: 09
```

使用get()函数来访问字典的值，第一个参数指定字典，第二个参数指定需要查找的键。如果该键存在，将返回对应的值，如果指定的键不存在，则返回0。如果指定了第三个参数，那么在指定的键不存在时，则返回此参数值。

```vim
echo get(flavor, '08')          "papya
echo get(flavor, '09')          "0
echo get(flavor, '09', 'None')  "None
```

## 新增项目

使用以下命令为新的键赋值，即可为字典新增项目：

```vim
let diagnosis = {'1':'item1'}
```

使用extend()函数，可以为字典新增多个项目：

```vim
call extend(diagnosis, {'2':'item2', '3':'item3'})
" '1': 'item1', '2': 'item2', '3': 'item3'
```

使用extend()函数，也可以合并两个字典：

```vim
let new_diagnosis = {'0':'new'}
call extend(diagnosis, new_diagnosis)
" '0': 'new', '1': 'item1', '2': 'item2', '3': 'item3'
```

## 删除项目

使用remove()函数，可以删除字典中的项目：

```vim
let removed_value = remove(flavor, '09')
```

当需要删除多个项目时，使用filter()函数将更加高效。 与[过滤](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Script-List.html%23script-list-filter)列表项目类似，您可以使用v:val和v:key进行操作：

```vim
" 删除所有以0开头键值的项目
call filter(flavor, 'v:key[0] != "0"') 
" 删除所有不包含指定内容的项目
call filter(flavor, 'v:val =~ "mango"') 
" 删除所有键与值相同的项目
call filter(diagnosis, 'v:key != v:val')
```

## 字典和列表

使用以下命令，可以获取字典中的键列表，值列表，和键-值列表：

```vim
let dict = {'key1':'value1', 'key2':'value2', 'key3':'value3'}
let keylist = keys(dict)
" ['key1', 'key2', 'key3']
let valuelist =	values(dict)
" ['value1', 'value2', 'value3']
let pairlist = items(dict)
" [['key1':'value1'], ['key2':'value2'], ['key3':'value3']]
```

大多数关于列表的函数，同样也适用于字典：

```vim
let is_empty =	empty(dict)           " 测试字典是否为空
let entry_count = len(dict)           " 返回字典中包含项目的总数量	
let occurrences = count(dict, str)    " 返回字典中值为str的项目的数量
let greatest = max(dict)              " 返回最大值
let least = min(dict)                 " 返回最小值
```

使用map()函数操作数据，可以将其中的字符串格式化为首字母大写：

```vim
let names = {'u1': 'TOM', 'u2': 'jerry', 'u3': 'alEX'}
call map( names, 'toupper(v:val[0]) . tolower(v:val[1:])' )
" {'u1': 'Tom', 'u2': 'Jerry', 'u3': 'ALex'}
```

关于相关函数的使用说明，请参阅[列表(List)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Script-List.html)章节。

## 帮助信息

**？**使用以下命令，可以查看字典相关的帮助信息：

```
:help Dictionary`
`:help Dictionary-function
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Script-List.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-93-ScriptUDF.html)>

编辑于 09-09