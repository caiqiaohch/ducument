# Rebar3使用介绍（一）基础用法

![img](https://csdnimg.cn/release/blogv2/dist/pc/img/translate.png)

[yida_young](https://blog.csdn.net/eeeggghit) 2018-11-12 16:55:56 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/articleReadEyes.png) 5759 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarCollect.png) 收藏 7

分类专栏： [erlang](https://blog.csdn.net/eeeggghit/category_8265955.html) 文章标签： [rebar3](https://www.csdn.net/tags/MtjaUg3sNTMzNzYtYmxvZwO0O0OO0O0O.html)

版权

[![img](https://img-blog.csdnimg.cn/20201014180756780.png?x-oss-process=image/resize,m_fixed,h_64,w_64)erlang](https://blog.csdn.net/eeeggghit/category_8265955.html)专栏收录该内容

17 篇文章2 订阅

订阅专栏



### Rebar3使用介绍（一）

- [安装](https://blog.csdn.net/eeeggghit/article/details/83754063?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#_3)
- [基础用法](https://blog.csdn.net/eeeggghit/article/details/83754063?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#_36)
- - [创建一个新的app或者release](https://blog.csdn.net/eeeggghit/article/details/83754063?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#apprelease_45)
  - [加入deps依赖](https://blog.csdn.net/eeeggghit/article/details/83754063?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#deps_60)
  - [编译](https://blog.csdn.net/eeeggghit/article/details/83754063?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#_77)
  - [输出配置](https://blog.csdn.net/eeeggghit/article/details/83754063?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#_80)
  - [测试](https://blog.csdn.net/eeeggghit/article/details/83754063?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#_88)
  - [发布](https://blog.csdn.net/eeeggghit/article/details/83754063?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-1.control#_102)


本文基本都是按照[rebar3官方文档](http://www.rebar3.org/docs/getting-started)



# 安装

------

- 使用源码安装

```shell
$ git clone https://github.com/erlang/rebar3.git
$ cd rebar3
$ ./bootstrap
123
```

- 直接下载编译好的二进制文件

```shell
$ wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3
1
```

如果要在windows下使用的话，需要额外制作一个rebar3.bat rebar3.cmd用来调用

```shell
@echo off
setlocal
set rebarscript=%~f0
escript.exe "%rebarscript:.cmd=%" %*
1234
```

当然要求erlang环境，escript必须在path中，如果用过rebar，和以前的rebar.bat rebar.cmd作用是一样的，不过现在IDEA的erlang插件已经支持了，如果使用IDEA就不用通过脚本调用

------

加入到环境变量中

```shell
./rebar3 local install
1
```

后续更新，可以通过命令直接更新到最新稳定版本

```shell
rebar3 local upgrade
1
```

# 基础用法

------

- 创建一个新的app或者release
- 加入deps依赖
- 编译
- 输出配置
- 测试
- 发布

## 创建一个新的app或者release

rebar3推荐两种主流方式管理项目：单个app结构的管理或者伞状管理

单个app方式是根目录中只有一个app，源代码存放在src目录，这种格式主要用来做库，处于共享的目的，例如recon，虽然一般把这种目录方式认为成一个库项目，但是这种结构还是可以发布

伞状项目的特点是包含了多个独立的OTP app，通常位于apps/ 或者 lib/目录中，这些app都可以有自己的rebar.config这种格式一般用于项目开发，项目可以拥有一个或多个主app，不一定只能有一个

rebar3提供了命令用来新建任意类型的模板，可通过`rebar3 new 命令调用。该`值可以是下面的任意值：

- app: 具有监督树和state维护的一个OTP application，作为一个单独的app
- lib: 没有监督树的OTP application，一般用来将多个模块组合起来作为一个单独的项目
- release: 准备发布的伞状项目，比app项目多了config目录下的sys.config，和vm.args，用来描述运行环境
- escript: 一种基于app的项目，将来可以构建成escript脚本
- plugin: 用于支持rebar3脚本

## 加入deps依赖

```Erlang
{deps, [
        {cowboy, "1.0.1"}, % package
        {cowboy, {git, "git://github.com/ninenines/cowboy.git", {tag, "1.0.1"}}} % alternatively, source
        ]
}.
12345
```

上面两种方式都可以获取依赖，对于第二种，使用过rebar的同学应该很熟悉，变化并不大
对于第一种，是用hex管理的erlang库完成的归类，例如上面的cowboy，最后就是通过`https://repo.hex.pm/tarballs/cowboy-1.0.1.tar` 这种地址从已经归类的服务端进行下载后管理的，至于hex的用法，比较复杂。如果想了解可以[点这里](https://github.com/hexpm/specifications/blob/master/apiary.apib)。

总的来说，一般比较常用的库hex都会有归档，不需要提供git仓库地址，但是如果不配置就没法完成的话，就得按照第二种格式配置上vsn地址了。当然也可以通过更新hex的归档目录实现，不过吧，我只是猜可以，没实践过。。

> rebar的老配置格式，例如`{cowboy, ".*", {git, "git://github.com/ninenines/cowboy.git", {tag, "1.0.1"}}}`这种在rebar3也是兼容的，但是第二个字段".*",会被忽略

添加完deps目录后，记得将新加的application加入到你的主app的.app.src文件中，这样就不用手动额外进行application调用了

## 编译

和rebar一样，在项目的根目录下执行`rebar compile`就可以完成编译，不过和rebar不同的是，使用rebar我们得先执行`rebar get-deps`先主动获取依赖才行，rebar3不需要直接执行compile即可，而且可以保证deps目录是最新的，即使deps库有了变更。

## 输出配置

默认的输入目录为_build目录，和rebar不同

- _build
  - default
    - lib
      - cowboy
      - cowlib
      - ranch

## 测试

测试用例默认是存放在test/目录下，eunit允许按照模块组织打包目录存放
如果测试用例需要额外的依赖，可以做单独配置，只有在运行测试用例的时候才getdeps指定依赖

```erlang
{profiles, [
   {test, [
       {deps, [
           {meck, {git, "git://github.com/eproxus/meck.git", {tag, "0.8.2"}}}
       ]}
   ]}
]}.
1234567
```

现在第一次调用`rebar3 ct` 会更新meck到_build/test/lib/.下，但是不会被加到rebar.lock文件中

## 发布

rebar3使用[relx](https://github.com/erlware/relx)进行构建
可以使用`rebar3 new release myrel` 直接新建一个发布目标，该项目的rebar.config就会有一个推荐的relx配置如下

```erlang
{relx, [{release, {myrel, "0.0.1"},
         [myrel]},

        {dev_mode, true},
        {include_erts, false},

        {extended_start_script, true}
       ]
}.

{profiles, [
    {prod, [{relx, [{dev_mode, false},
                    {include_erts, true}]}
     ]}
]}.
123456789101112131415
```

你可以将上面的内容复制到你的rebar.config中，当然记得将myrel该成你自己的项目，就可以调用`rebar3 release` 进行发布

> 由于默认配置dev_mode为true，那么_build/rel/myrel/lib是符号连接_build/lib和apps/myrel。因此，在开发和重新编译应用程序时，您无需重新创建发行版，只需重新启动节点或重新加载模块即可。

使用命令`rebar3 as prod tar` 可以将发布的文件打包成tar包方便拷贝