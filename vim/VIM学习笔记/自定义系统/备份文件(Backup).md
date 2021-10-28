# 备份文件(Backup)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

Vim利用writebackup和backup两个选项，在编辑文件的过程中，自动生成备份文件，以防止异常情况下的数据丢失。

## **启用文件备份**

在默认情况下，Vim已经设置了writebackup选项。我们可以使用以下命令，启用backup选项。vim将首先删除旧的备份文件，然后再为正在编辑的文件生成新的备份文件：

```vim
:set backup
```

## **备份文件名称**

默认情况下，备份文件的名称是在原始文件名最后加上“~”后缀。例如，正在编辑一个名为“data.txt”的文件，那么Vim将产生名为“data.txt~”的备份文件。我们也可以使用以下命令，来自定义备份文件扩展名，新的备份文件名将命名为“data.txt.bu”。

```vim
:set backupext=.bu
```

## **备份文件位置**

默认情况下，备份文件将存储于原文件相同的目录下。使用以下命令，可以设置备份文件存放到指定位置：

```vim
:set backupdir=C:/Temp
```

需要注意的是，如果在不同目录下编辑相同名称的文件，在保存退出时，Vim会将备份文件放置到同一指定的目录中，名字冲突会使已存在的备份文件被覆盖。

## **备份文件过滤**

如果你并不需要对所有文件都进行备份，那么可以利用以下命令取消对指定目录下文件的备份：

```vim
set backupskip=D:/Temp/*
```

需要注意的是，Windows文件路径中斜线（/）的用法。

## **禁止文件备份**

在保持默认writebackup选项的情况下，我们可以使用以下命令，取消备份文件的生成：

```vim
:set nobackup
```

需要注意的是，如果同时设置了nobackup和nowritebackup选项，那么在磁盘已满而更新文件时会造成数据的丢失，所以我们最好不要改变默认的writebackup选项。



![img](https://pic1.zhimg.com/80/v2-97b16530546f691e03e17dbf788a9578_720w.png)



编辑于 2017-05-10