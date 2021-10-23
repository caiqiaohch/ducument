# 拼写检查(Spell Check)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

2 人赞同了该文章

从版本7开始，Vim内置了拼写检查功能，但是在默认情况下并没有打开。

## **启用**

首先，你需要使用:echo &spelllang命令确认当前使用哪种语言。比如：“en”代表英语。如果想要改语言，可以使用:set spelllang=en_GB.UTF-8命令。也可以用逗号分隔制定检查set spelllang=en_us,nl,medical多种语言。

然后，你可以通过菜单：*工具 -> 拼写检查 -> 打开拼写检查*，来启用拼写检查功能。GVim将用红色的波浪线标识出错误的拼写。你也可以使用:set spell命令打开拼写检查，使用:set nospell命令关闭拼写检查。

## **检查**

如果在文件中有很多拼写错误，可以用]s命令移动到下一个拼写错误处，用[s命令移动到上一个拼写错误处。

![img](https://pic1.zhimg.com/80/v2-da94e45d8fcda9ad9a5f79bb078d2f74_720w.png)



## **纠正**

如果想要纠正错误的拼写：首先将光标移至错误的单词上，然后执行z=命令列出一组相近的单词，你可以在其中选择正确的拼写。

![img](https://pic4.zhimg.com/80/v2-17f0056da64559a55fc7ca02a0f51f2b_720w.png)

有些特殊单词（比如图中的"Gvim"）也会被标识为错误拼写，如果你希望Vim能够承认它们为正确的拼写，可以使用zg命令。还可以用zw命令取消用户做的拼写识别。

![img](https://pic1.zhimg.com/80/v2-a389b8c001b49896caed680fbebd8048_720w.png)

编辑于 2017-01-22