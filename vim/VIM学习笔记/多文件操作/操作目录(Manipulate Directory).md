# 操作目录(Manipulate Directory)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

2 人赞同了该文章

## **在目录间移动**

使用以下命令，可以显示当前所在的目录：

```
:pwd
```

使用以下命令，在Linux下可以进入HOME目录，而在Windows下则显示当前所在目录：

```
:cd
```

使用以下命令，可以进入指定的目录：

```
:cd D:\tepm
```

使用以下命令，可以返回前一个目录：

```
:cd -
```

使用以下命令，可以返回上一级目录：

```
:cd ..
```

我们还可以使用以下命令，创建新的目录:

```
:!mkdir my_project
```

## **利用wildmenu选择目录**

在vimrc配置文件中，增加以下两条命令，可以在屏幕底部启用wildmenu菜单显示：

```
set wildmenu`
`set wildmode=list:longest,full
```

启用wildmenu菜单之后，在命令行中，第一次点击Tab时， 将列示所有可能与已输入字符相匹配的命令列表；第二次点击Tab时，则将在显示的wildmenu中遍历匹配项；然后点击回车键做出选择。

使用`:help wildmode`和`:help wildmenu`命令，可以查看更多帮助信息。

在命令行中输入`:e`命令，紧接着输入一个空格，然后点击Tab键，将在屏幕底部的wildmenu中，显示当前目录下的子目录和文件列表：

![img](https://pic3.zhimg.com/80/v2-21ce152044464f900fb92b116db8723a_720w.jpg)

再次点击Tab键，可以选择下一个项目，点击Shift + Tab键则可以选择上一个项目 ；使用左右移动键，也可以在文件列表中进行选择；而使用上下移动键，则可以移动至上一层或下一层目录。点击回车键，将打开选中的文件或文件夹。

![img](https://pic2.zhimg.com/80/v2-ff097d246d9c458901da973a2de11371_720w.jpg)

如果在命令行中输入`:e`命令，紧接着输入一个空格以及文件名的开头部分，然后点击Tab键，那么将在屏幕底部的wildmenu中显示与之相匹配的项目；如果只发现一个匹配项，那么将会直接补全文件名：

![img](https://pic2.zhimg.com/80/v2-7840323f88d4c63600ae6a9e229565e1_720w.jpg)



编辑于 2019-04-01