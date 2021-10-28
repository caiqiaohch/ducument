# 行号(Line Number)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

## **绝对行号**

可以用以下命令显示绝对行号（Absolute Line Number）：

```text
:set number
```

![img](https://pic2.zhimg.com/80/v2-37a3e9a8df16ca6755d2937eaea45f71_720w.png)

可以用以下命令隐藏绝对行号：

```text
:set nonumber
```

## **相对行号**

可以用以下命令显示相对行号（Relative Line Number）：

```text
:set relativenumber
```

![img](https://pic2.zhimg.com/80/v2-185a8a9529e8c0b66fc72e4de39551bd_720w.png)

可以用以下命令隐藏相对行号：

```text
:set norelativenumber
```

如果我们使用以下命令，同时显示绝对行号和相对行号，那么Vim将显示当前行的绝对行号，而其他行则显示相对行号：

```text
:set number
:set relativenumber
```

![img](https://pic4.zhimg.com/80/v2-51101d46413f4ea7390cf5491c65fd5b_720w.png)

在Vim中，很多命令都可以使用数字前缀。例如，命令10j既是向下移动10行；命令>2j则可以缩进当前行以及其下2行。通过显示相对行号，你就可以清楚地看到命令所覆盖的范围。如果仅仅显示绝对行号，那么久需要你手动计算行之间的距离。

## **行号显示效果**

行号默认右对齐显示在每行的左侧，占据4个空格的空间：其中3个空间用于显示行号，另1个空格作为于文本的间隔。当行数超过999时，行号显示区域将自动进行扩展。可以通过以下命令，改变行号所占用的空间（其中n为空间大小）：

```text
:set numberwidth=n
```

使用以下命令，可以定制行号（LineNr）的显示效果：

```text
:highlight LineNr guibg=#1874cd ctermbg=#1874cd
```

使用以下命令，则可以定制当前行号（CursorLineNr）的显示效果：

```text
:highlight CursorLineNr guifg=#050505
```

![img](https://pic4.zhimg.com/80/v2-a55316a18d6ca5873b46afb6987a6207_720w.png)

发布于 2017-01-18