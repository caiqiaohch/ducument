Step By Step(Lua字符串库)

  1. 基础字符串函数：
  
    字符串库中有一些函数非常简单，如：
    1). string.len(s) 返回字符串s的长度；
    2). string.rep(s,n) 返回字符串s重复n次的结果；
    3). string.lower(s) 返回s的副本，其中所有的大写都被转换为了小写形式，其他字符不变；
    4). string.upper(s) 和lower相反，将小写转换为大写；
    5). string.sub(s,i,j) 提取字符串s的第i个到第j个字符。Lua中，第一个字符的索引值为1，最后一个为-1，以此类推，如：
    print(string.sub("[hello world]",2,-2))      --输出hello world
    6). string.format(s,...) 返回格式化后的字符串，其格式化规则等同于C语言中printf函数，如：
    print(string.format("pi = %.4f",math.pi)) --输出pi = 3.1416
    7). string.char(...) 参数为0到多个整数，并将每个整数转换为对应的字符。然后返回一个由这些字符连接而成的字符串，如：
    print(string.char(97,98,99)) --输出abc
    8). string.byte(s,i) 返回字符串s的第i个字符的Ascii值，如果没有第二个参数，缺省返回第一个字符的Ascii值。
    print(string.byte("abc"))      --输出97
    print(string.byte("abc",-1))  --输出99
    由于字符串类型的变量都是不可变类型的变量，因此在所有和string相关的函数中，都无法改变参数中的字符串值，而是生成一个新值返回。

    2. 模式匹配函数：
   
    Lua的字符串库提供了一组强大的模式匹配函数，如find、match、gsub和gmatch。
    1). string.find函数：
    在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。如：


1 s = "hello world"
2 i, j = string.find(s,"hello")  
3 print(i, j)        --输出1  5
4 i, j = string.find(s,"l")
5 print(i, j)        --输出3  3
6 print(string.find(s,"lll"))  --输出nil

    string.find函数还有一个可选参数，它是一个索引，用于告诉函数从目标字符串的哪个位置开始搜索。主要用于搜索目标字符串中所有匹配的子字符串，且每次搜索都从上一次找到的位置开始。如：

复制代码
1 local t = {}
2 local i = 0
3 while true do
4     i = string.find(s,"\n",i+1)
5     if i == nil then
6         break
7     end
8     t[#t + 1] = i
9 end
复制代码

    2). string.match函数：
    该函数返回目标字符串中和模式字符串匹配的部分。如：

1 date = "Today is 2012-01-01"
2 d = string.match(date,"%d+\-%d+\-%d+")
3 print(d)  --输出2012-01-01

    3). string.gsub函数：
    该函数有3个参数，目标字符串、模式和替换字符串。基本用法是将目标字符串中所有出现模式的地方替换为替换字符串。如：
    print(string.gsub("Lua is cute","cute","great"))  --输出Lua is great
    该函数还有可选的第4个参数，即实际替换的次数。
    print(string.gsub("all lii","l","x",1))  --输出axl lii
    print(string.gsub("all lii","l","x",2))  --输出axx lii
    函数string.gsub还有另一个结果，即实际替换的次数。
    count = select(2, string.gsub(str," "," "))  --输出str中空格的数量

    4). string.gmatch函数：
    返回一个函数，通过这个返回的函数可以遍历到一个字符串中所有出现指定模式的地方。如：

复制代码
1 words = {}
2 s = "hello world"
3 for w in string.gmatch(s,"%a+") do
4     print(w)
5     words[#words + 1] = w
6 end
7 --输出结果为：
8 --hello
9 --world
复制代码
    3. 模式：
    下面的列表给出了Lua目前支持的模式元字符；

模式元字符	描述
.	所有字符
%a	字母
%c	控制字符
%d	数字
%l	小写字母
%p	标点符号
%s	空白字符
%u	大写字母
%w	字母和数字字符
%x	十六进制数字
%z	内部表示为0的字符
    这些元字符的大写形式表示它们的补集，如%A，表示所有非字母字符。
    print(string.gsub("hello, up-down!","%S","."))   --输出hello..up.down. 4
    上例中的4表示替换的次数。
    除了上述元字符之外，Lua还提供了另外几个关键字符。如：( ) . % + - * ? [ ] ^ $
    其中%表示转义字符，如%.表示点(.)，%%表示百分号(%)。
    方括号[]表示将不同的字符分类，即可创建出属于自己的字符分类，如[%w_]表示匹配字符、数字和下划线。
    横线(-)表示连接一个范围，比如[0-9A-Z]
    如果^字符在方括号内，如[^\n]，表示除\n之外的所有字符，即表示方括号中的分类的补集。如果^不在方括号内，则表示以后面的字符开头，$和它正好相反，表示以前面的字符结束。如：^Hello%d$，匹配的字符串可能为Hello1、Hello2等。
    在Lua中还提供了4种用来修饰模式中的重复部分，如：+(重复1次或多次)、*(重复0次或多次)、-(重复0次或多次)和?(出现0或1次)。如：
    print(string.gsub("one, and two; and three","%a+","word")) --输出word, word word; word word
    print(string.match("the number 1298 is even","%d+")) --输出1298
    星号(*)和横线(-)的主要差别是，星号总是试图匹配更多的字符，而横线则总是试图匹配最少的字符。

    4. 捕获(capture)：
    捕获功能可根据一个模式从目标字符串中抽出匹配于该模式的内容。在指定捕获是，应将模式中需要捕获的部分写到一对圆括号内。对于具有捕获的模式，函数string.match会将所有捕获到的值作为单独的结果返回。即它会将目标字符串切成多个捕获到的部分。如：

复制代码
1 pair = "name = Anna"
2 key,value = string.match(pair,"(%a+)%s*=%s*(%a+)")
3 print(key,value)  --输出name anna
4 
5 date = "Today is 2012-01-02"
6 y,m,d = string.match(date,"(%d+)\-(%d+)\-(%d+)")
7 print(y,m,d)      --输出2012    01      02
复制代码
    还可以对模式本身使用捕获。即%1表示第一个捕获，以此类推，%0表示整个匹配，如：

1 print(string.gsub("hello Lua","(.)(.)","%2%1"))  --将相邻的两个字符对调，输出为ehll ouLa
2 print(string.gsub("hello Lua!","%a","%0-%0"))    --输出为h-he-el-ll-lo-o L-Lu-ua-a!

    5. 替换：
    string.gsub函数的第三个参数不仅可以是字符串，也可以是函数或table，如果是函数，string.gsub会在每次找到匹配时调用该函数，调用时的参数就是捕获到的内容，而该函数的返回值则作为要替换的字符串。当用一个table来调用时，string.gsub会用每次捕获到的内容作为key，在table中查找，并将对应的value作为要替换的字符串。如果table中不包含这个key，那么string.gsub不改变这个匹配。如：

复制代码
 1 function expand(s)
 2     return (string.gsub(s,"$(%w+)",_G))
 3 end
 4 
 5 name = "Lua"; status = "great"
 6 print(expand("$name is $status, isn't it?"))  --输出 Lua is great, isn't it?
 7 print(expand("$othername is $status, isn't it?"))  --输出 $othername is great, isn't it?
 8 
 9 function expand2(s)
10     return (string.gsub(s,"$(%w+)",function(n) return tostring(_G[n]) end))
11 end
12 
13 print(expand2("print = $print; a = $a")) --输出 print = function: 002B77C0; a = nil
复制代码