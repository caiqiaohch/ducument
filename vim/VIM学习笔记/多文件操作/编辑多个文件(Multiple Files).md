# 编辑多个文件(Multiple Files)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

如果需要同时打开并编辑多个文件，可以使用以下几种方法：

- 在启动vim时，可以指定多个文件做为**[参数(Argument)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-16-MultiArguments.html)**以同时打开多个文件；
- 在Vim中，新建**[窗口(Window)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-14-MultiWindows.html)**用于打开文件；
- 在Vim中，在任一窗口(Window)内，都可以新建多个**[缓冲区(Buffer)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-13-MultiBuffers.html)**用于编辑不同的文件。

以下表格，简单列举了参数、窗口和缓冲区命令的对照关系：

![img](https://pic1.zhimg.com/80/v2-e52b813d144f137913928613187de954_720w.jpg)

![img](https://pic4.zhimg.com/80/v2-449fd009b819bdc1df7285eb49d35fab_720w.jpg)

## **在不同文件之间拷贝文本**

使用[标记](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-53-Mark.html)，在不同文件之间拷贝文本：

1. 编辑第一文件
2. 执行命令`:split second_file`打开另一个窗口并开始编辑第二个文件
3. 使用命令`ctrl+Wp`回到含有原始文件的前一个窗口
4. 将光标移动到要拷贝文本的第一行
5. 用命令`ma`标记这一行
6. 移动到要拷贝文本的最后一行
7. 执行命令`y'a`来复制当前光标位置到所做标记之间的文本
8. 使用命令`ctrl+Wp`回到将要放置文本的文件
9. 将光标移到将要插入文本的地方
10. 使用命令`P`将复制的文本粘贴到文件中

使用可视化模式，在不同文件之间拷贝文本：

1. 编辑第一文件
2. 执行命令`:split second_file`打开另一个窗口并开始编辑第二个文件
3. 使用命令`ctrl+Wp`回到含有原始文件的前一个窗口
4. 将光标移动到要拷贝文本的第一行
5. 执行命令`V`进入可视化模式
6. 移动到将要复制文本的最后一行，被选中的文本将会被高亮显示
7. 执行命令`y`复制选中的文本
8. 使用命令`ctrl+Wp`回到将要放置文本的文件
9. 使用命令`P`将复制的文本粘贴到文件中

使用[寄存器](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-12-Register.html)，在不同文件之间拷贝文本：

1. 编辑第一文件
2. 执行命令`:split second_file`打开另一个窗口并开始编辑第二个文件
3. 使用命令`ctrl+Wp`回到含有原始文件的前一个窗口
4. 将光标移动到要拷贝文本的第一行
5. 执行命令`"a3yy`将需要复制的行放入寄存器
6. 使用命令`ctrl+Wp`回到将要放置文本的文件
7. 使用命令`"ap`将复制的文本粘贴到文件中

## **读入文件**

使用`:read filename`（可简写为`:r`）命令，可读进一个文件并将内容插在当前行的后面。我们也可以在命令中，指明读取内容放置在文件中的特定位置。例如`:0r filename`命令，将读取内容放置在文件开头；而`:$r filename`命令，则会将读取内容放置在文件末尾。

## **写入文件**

命令`:write`（可简写为`:w`）用来写入文件（也就是保存当前文件）。

使用以下命令将保存文本到文件collect.txt中：

```vim
:write collect.txt
```

如果这个文件已经存在，那么就会显示错误信息。如果要强行保存，那么需要使用!选项：

```vim
:write! collect.txt
```

我们也可以向已有文件中追加内容。使用以下命令将正编辑的文件内容追加到collect.txt中:

```vim
:write >> collect.txt
```

使用以下命令，将正编辑的文件的部分内容（第100行到文件末尾）追加到collect.txt中:

```vim
:100,$write >> collect.txt
```

如果这个文件不存在，那么就会显示错误信息。可以使用!选项，强行创建并保存新文件：

```vim
:write! >> collect.txt
```

我们还可以导出文件中的部分内容到其它文件中，以达到分拆文件的目的。以下命令将第10行到文件末尾的内容保存到collect.txt中：

```vim
:10,$write collect.txt
```

以下命令则会将当前行到第100行的内容保存到collect.txt中：

```vim
:.,100write collect.txt
```

在可视化模式下，选择内容，然后使用以下命令也可以写入其它文件：

```vim
:'<,'> write collect.txt
```

使用写入命令不仅可以保存文件，而且还可以将文件重定向到其他程序。在Linux系统中，我们可以使用以下命令将文件发送到打印机：

```vim
:write !lpr
```

注意：命令`:write! lpr`与`:write !lpr`是不同的，前者是强行保存文件，而后者则是将文件发送到打印机。

命令`:wall`可以保存所有已经修改过的文件（包括隐藏缓冲区中的文件）。

## **退出文件**

`:quit`可以退出当前文件。而`:qall`命令，则可以退出所有打开的文件。

如果文件已修改但没有保存，则会在窗口底部显示警告信息并禁止退出。可以使用以下命令，配置Vinm在此类情况下显示确认对话框：

```vim
:set confirm
```



![img](https://pic3.zhimg.com/80/v2-5164437f2065990ba003a8ca5b14dd0e_720w.jpg)



如果想要放弃所做的修改并强行退出，可以使用`:qall!`命令。

使用命令`:wqall`组合，可以保存所有文件并退出。

发布于 2018-07-23