Erlang记录

记录的定义如下：

-record(name_of_record,{field_name1, field_name2, field_name3, ......}).
例如，

-record(message_to,{to_name, message}).
这等价于：

{message_to, To_Name, Message}
用一个例子来说明怎样创建一个记录：

#message_to{message="hello", to_name=fred)
上面的代码创建了如下的记录：

{message_to, fred, "hello"}
注意，使用这种方式创建记录时，你不需要考虑给每个部分赋值时的顺序问题。这样做的另外一个优势在于你可以把接口一并定义在头文件中，这样修改接口会变得非常容易。例如，如果你想在记录中添加一个新的域，你只需要在使用该新域的地方进行修改就可以了，而不需要在每个使用记录的地方都进行修改。如果你在创建记录时漏掉了其中的某些域，则这些域会得到一个默认的原子值 undefined。

使用记录进行模式匹配与创建记录是一样。例如，在 receive 的 case 中：

#message_to{to_name=ToName, message=Message} ->
这与下面的代码是一样的：

{message_to, ToName, Message}