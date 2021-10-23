# 重复命令(Dot Command)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

.（Dot）命令，可以重复上次的修改。而上次的修改，可以是针对单个字符、整行，甚至是整个文件。所以Dot命令，是一个作用范围极广的强大命令。

## **重复单个命令**

假设我们有以下文本：

```text
Line one
Line two
Line three
Line four
```

如下图所示：.命令重复执行了x命令，用于删除当前光标下的字符：



![img](https://pic1.zhimg.com/80/v2-ae1ed3b31455ad6823c8b3f896902948_720w.png)

以下图例则展示了，.命令如何重复作用于整行之上的删除操作：



## ![img](https://pic2.zhimg.com/80/v2-26a6dc54a85e277a94e1678593e0abb5_720w.png)**重复多个命令组合**

假设我们有以下代码：

```text
var foo = 1
var bar = 'a'
var foobar = foo + bar
```

如下图所示：首先，我们使用A命令进入插入模式并在当前行的末尾增加分号；然后，退回到常规模式；之后，移动到一下行并利用.命令重复插入分号的操作。

![img](https://pic4.zhimg.com/80/v2-744e645261febcfc56bfaf14b97adc77_720w.png)

## **重复命令与其他命令的组合**

假设我们有以下代码：

```text
var foo = "method("+argument1+","+argument2+")";
```

在以下实例中：我们希望在每个加号前后分别插入空格，以提高代码的可读性。首先，我们使用f命令查找加号；然后，使用s命令将加号替换为“ + ”；随后，退回到常规模式；之后，就可以利用;.命令查找下一个加号并重复执行替换操作。

![img](https://pic3.zhimg.com/80/v2-b24817322b00d67481fba70739bf652a_720w.png)

编辑于 2017-03-28