# 加密(crypt)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

3 人赞同了该文章

## **算法**

如果**:version**命令的输出信息中包含了*+cryptv* 选项， 那么说明你安装的Vim已经启用了加密功能。7.3之前的版本提供用于向后兼容的PkZip加密算法；自7.3版本开始提供较强的Blowfish加密算法；而从7.4.399版本开始支持更新的Blowfish2加密算法。

![img](https://pic3.zhimg.com/80/v2-b5a8fbb3d2c0706ba155aaaaa43af846_720w.png)

使用以下命令，可以查看当前使用的加密算法：

```vim
:set cm?
```

使用以下命令，可以切换使用的不同加密算法：

```vim
:set cm=zip
:set cm=blowfish
:set cm=blowfish2
```

## **加密**

我们可以使用Vim的-x启动参数，创建加密文件：

```text
vim -x filename
```

Vim会要求你重复输入两次密钥。而当我们完成编辑并退出时，Vim就会对文本进行加密处理。此后，如果使用其它软件查看加密后的文件，那么将只会看到无意义的乱码；而如果使用Vim打开加密文件，则会要求你输入密钥以正确显示内容。

## **解密**

使用以下命令将选项key置空，解除加密:

```vim
:set key=
```

我们也可以通以下命令，重置密钥：

```vim
:set key=secret
```

但以上命令将会以明文显示输入的密码，显然不够安全。而使用以下X（大写）命令，则会以星号*显示输入的密码，所以更加安全。

```vim
:X
```

![img](https://pic1.zhimg.com/80/v2-65313e9e310d2ab1a7d766a9415eb944_720w.png)

## **安全**

在编辑文件时所使用的交换文件(swap file)、撤销文件（undo file）和备份文件(backup file)也会同时被加密。当然我们也可以在命令行中利用-n参数，指定不使用交换文件（注意：不使用交换文件，我们也就不能够通过交换文件来恢复文件了。）：

```vim
vim -x -n filename
```

由于viminfo文件并不会被加密，所以我们可以使用以下命令禁用vimifno文件：

```vim
:set viminfo=
```

编辑于 2017-04-13