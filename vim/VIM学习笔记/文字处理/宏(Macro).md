# 宏(Macro)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

8 人赞同了该文章

利用键盘宏（Macro），可以录制一组命令，然后重复执行。

- tansen is the singer
- daswant is the painter
- birbal is the wazir

例如，我们需要对以上文字，进行下列处理：

1. 将每行的首字符大写；
2. 将"is"改为"was"；
3. 在每行结尾增加 "in Akbar's court."

显然，手工重复完成这些操作是相当繁琐和费时的，而使用宏则会非常高效。

## **录制宏**

1. 进入常规模式；
2. 将光标移动到第一行的第一个字母上；
3. 执行qa命令，开始录制宏a；
4. 执行gUl命令，将首字母转换为大写；
5. 执行w命令，移动到下一单词；
6. 执行cw命令，修改单词；
7. 输入“was”；
8. 点击Esc键，返回常规模式；
9. 执行A命令，在行尾添加文字；
10. 输入“in Akbar's court”；
11. 点击Esc键，返回常规模式；
12. 执行q命令，完成录制宏；

## **执行宏**

在完成一行的修改并录制宏后，就可以使用宏快速完成其它行的处理了：

1. 执行j命令，移动到下一行；
2. 执行0命令，移动到首字母；
3. 执行@a命令，执行宏a；

我们还可以在执行命令前加上数字，比如3@a，来告诉vi执行几次宏。

发布于 2017-04-17