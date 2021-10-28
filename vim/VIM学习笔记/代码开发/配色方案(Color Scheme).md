# 配色方案(Color Scheme)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

Vim通过配色方案（Color Scheme）来定义使用不同颜色显示不同的语法元素。

## **识别背景色**

Vim有两种显示模式：一种是背景为浅色，而另一种是背景为深色。在启动时，Vim会检测使用的是哪一种背景颜色，然后再应用语法高亮的配色方案。我们可以使用:set background?命令，查看当前使用的背景颜色。也可以使用:set background=light或:set background=dark命令，来指定背景颜色。注意：必须在启用语法高亮之前，设置背景色彩。

## **安装配色方案**

你可以先在[Vim Colors](https://link.zhihu.com/?target=http%3A//vimcolors.com/)网站中，预览各种配色方案的效果，然后再选择下载安装。

你也可以在[Vim.org](https://link.zhihu.com/?target=http%3A//www.vim.org/)中，[查找](https://link.zhihu.com/?target=http%3A//www.vim.org/scripts/script_search_results.php%3Fkeywords%3D%26script_type%3Dcolor%2Bscheme%26order_by%3Drating%26direction%3Ddescending%26search%3Dsearch)并下载喜欢的配色方案。你甚至可以下载[Color Sampler Pack](https://link.zhihu.com/?target=http%3A//www.vim.org/scripts/script.php%3Fscript_id%3D625)，然后从其中包含的100个最受欢迎配色方案里慢慢挑选。

请将下载的配色方案文件*name.vim*，放入*$VIMRUNTIME/colors*目录中。

## **使用配色方案**

输入:colorscheme命令，紧接着一个空格后，然后点击Tab键，将可以遍历所有已安装的配色方案，按下Enter键可以应用选中的配色方案。

![img](https://pic3.zhimg.com/80/v2-58649ff8505eff005ee64b3b067ee41a_720w.png)

如果你希望在Vim启动时启用指定的配色方案，那么可以在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2012/01/vim-vimrc.html)文件中使用以下命令：

```text
:colorscheme name
```

命令小结

:set background 设置背景颜色
:colorscheme 设置配色方案

编辑于 2017-02-15