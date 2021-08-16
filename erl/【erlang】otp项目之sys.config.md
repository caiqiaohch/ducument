# 【erlang】otp项目之sys.config

## 前言

当你使用 rebar3 创建一个 otp 应用，在源码目录下会生成 apps 和 config 两个文件夹。在 config 文件夹下面有一个 sys.config 文件。这个文件存在的意义在于，当程序运行，需要修改一些参数的时候，可以直接找到服务器上的 sys.config ，修改需要修改的部分，然后直接重新运行那个打包的程序，从而省去了重新编译的时间和精力。

## **设置**

打开 sys.config 文件， 以项目名为 bridge 为例，默认打开是这样的，空列表表示当前没有任何设置。

![img](https:////upload-images.jianshu.io/upload_images/12967502-6ee52c81a29345b1.png?imageMogr2/auto-orient/strip|imageView2/2/w/143/format/webp)

默认的sys.config

参数设置的格式是一个二元元祖 { key, value }, key 的格式必须为 atom 基元，value 的格式则可以是任何格式，包括列表元组等等，下图是一个可用的示例，多个元组之间用逗号隔开，换行是为了清晰一些。

![img](https:////upload-images.jianshu.io/upload_images/12967502-e2dc888cd73d1bdf.png?imageMogr2/auto-orient/strip|imageView2/2/w/213/format/webp)

举个栗子

设置的时候还有一个需要注意的地方，就是**我们不能修改 bridge 为其他名字**，这个位置的基元必须是可用的应用的名字（如果你后续用到了 mongo 数据库或者 mysql 数据库，可以用数据库的代号代替），而我们当前项目内的应用只有一个，就是我们整个项目。

## **读取**

读取的语法是固定的，以上图的例子为例，需要注意的是返回的不是一个值而是二元组，需要匹配：

![img](https:////upload-images.jianshu.io/upload_images/12967502-3fd09ae36db11c11.png?imageMogr2/auto-orient/strip|imageView2/2/w/419/format/webp)

config 读取的固定语法

至于融会贯通，举一反三，本篇的内容还是相当简单的，就留待读者去做了。

