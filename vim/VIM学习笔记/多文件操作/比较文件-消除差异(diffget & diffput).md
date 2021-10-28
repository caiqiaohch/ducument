# 比较文件-消除差异(diffget & diffput)

[![YYQ](https://pica.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

4 人赞同了该文章

在操作系统的命令行中使用以下命令，可以利用Vim比较多个文件：

```vim
$ vimdiff file1 file2
```

如下图所示，红色高亮区域显示了两个文件中第三行的差异，左侧文件包含文字“ACTUAL”，而右侧文件则包含文字“BUDGET”：

![img](https://pic2.zhimg.com/80/v2-6eaba2b266495d3c145bfbe4909721cd_720w.jpg)

在比较文件并发现不同之处以后，可以通过命令消除这些差异点。

## **获取差异**

使用`]c`命令，可以移动到差异处。

使用`:diffget`或`do`命令，将从另一文件中获得差异文字并复制到当前文件中，以消除差异。

例如，在左侧文件中执行:diffget命令，会将右侧文件中的文字“BUDGET”，复制到左侧文件，并替代掉差异文字“ACTUAL”：

![img](https://pic4.zhimg.com/80/v2-6bc55639f97f9bfd9e32dff1c5a1cfe7_720w.jpg)

如果希望一次性获取整个文件的差异，那么可以使用以下命令：

```
:%diffget
```

## **推送差异**

使用`:diffput`或`dp`命令，将以当前文件为基准，消除另一文件中的差异。

例如，在左侧文件中执行:diffput命令，会将左侧文件中的文字“ACTUAL”推送到右侧文件，并替代掉差异文字“BUDGET”：

![img](https://pic4.zhimg.com/80/v2-42ca332da1b9ae544b913c81f0c0a9e7_720w.jpg)

如果希望一次性推送整个文件的差异，那么可以使用以下命令：

```
:%diffput
```

使用:diffget和:diffput命令消除差异之后，vim会自动刷新差异的高亮显示；如果您采用手动修改文字来消除差异，那么需要执行`:diffupdate`命令来刷新差异的高亮显示。

## **消除多个文件间的差异**

我们可以同时比较多个文件之间的差异。例如以下命令，将比较三个文件：

```vim
$ vimdiff file1 file2 file3
```

如下图所示，红色高亮区域显示了三个文件中第三行的差异：

![img](https://pic2.zhimg.com/80/v2-cc595ad6661d702d094c1aef289e3665_720w.jpg)

因为此时打开了多个[缓冲区 (Buffer)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-13-MultiBuffers.html)，所以需要执行:diffget [bufspec]和:diffput [bufspec]命令以指明缓冲区。例如`:diffput 3`命令，将推送差异到第三缓冲区：

![img](https://pic4.zhimg.com/80/v2-b4bb699173dc61b89e3dc475e4ba9f33_720w.jpg)

其中，[bufspec]参数可以是缓冲区编号，缓冲区名称，或者缓冲区名称的一部分。可以使用`:buffers`命令，来查看包含缓冲区编号和名称的列表。

**帮助信息**

使用`:help copy-diffs`命令，可以查看合并/消除差异的更多帮助信息。

发布于 2019-06-10