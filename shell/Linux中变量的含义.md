Linux中变量#,@,0,1,2,*,$$,$?的含义

$# 是传给脚本的参数个数
$0 是脚本本身的名字
$1 是传递给该shell脚本的第一个参数
$2 是传递给该shell脚本的第二个参数
$@ 是传给脚本的所有参数的列表
$* 是以一个单字符串显示所有向脚本传递的参数，与位置变量不同，参数可超过9个
$$ 是脚本运行的当前进程ID号
$? 是显示最后命令的退出状态，0表示没有错误，其他表示有错误
区别：@*

相同点：都是引用所有参数
不同点：只有在双引号中体现出来。假设在脚本运行时写了三个参数（分别存储在12 3）则"*" 等价于 “12 3"（传递了一个参数）；而“@" 等价于 "1""2" "$3"（传递了三个参数）
例子一

复制代码
##dels.sh
echo "number:$#"
echo "scname:$0"
echo "first :$1"
echo "second:$2"
echo "argume:$@"
echo "show parm list:$*"
echo "show process id:$$"
echo "show precomm stat: $?"
复制代码
执行结果

[@jihite]$ sh del.sh1 2 3
number:3
scname:del.sh
first:1
second:2
argume:1 2 3
show parm list:1 2 3
show process id:21057
show precomm stat:0
例子二

复制代码
#!/bin/sh
num=$#
name=$0
echo "number:$num"
echo "scname:$name"
echo $0
echo $1
echo $2

for ((i=0; i<$num; i++))
do
    echo "$i"
done

echo "argume:$@"
for key in $@
do
    echo $key
done
echo "-----------------"
for key in "$@"
do
    echo $key
done
echo "-----------------------------"
for key2 in $*
do 
    echo $key2
done
echo "-----------------"
for key2 in "$*"
do 
    echo $key2
done

echo "show process id:$$"
cho
echo "show precomm stat: $?"
复制代码
执行结果

[@jihite]$ sh del.sh a b                                                      
number:2
scname:del.sh
del.sh
a
b
0
1
argume:a b
a
b
-----------------
a
b
-----------------------------
a
b
-----------------
a b
show process id:23582
del.sh: line37: cho: command not found
show precomm stat:127
问题：

echo #0 #1 能不能用 $i 表示呢？