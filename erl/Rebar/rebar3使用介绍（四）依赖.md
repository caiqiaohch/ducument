### rebar3使用介绍（四）依赖

- [声明依赖关系](https://blog.csdn.net/eeeggghit/article/details/83994645#_29)
- [源依赖](https://blog.csdn.net/eeeggghit/article/details/83994645#_89)
- [包依赖](https://blog.csdn.net/eeeggghit/article/details/83994645#_147)
- [Checkout 依赖](https://blog.csdn.net/eeeggghit/article/details/83994645#Checkout__170)
- [更新依赖](https://blog.csdn.net/eeeggghit/article/details/83994645#_173)
- [锁文件 Lock File](https://blog.csdn.net/eeeggghit/article/details/83994645#_Lock_File_216)
- [依赖锁管理](https://blog.csdn.net/eeeggghit/article/details/83994645#_225)



> 依赖关系和配置文件
> 将始终使用prod应用于其配置的配置文件编译依赖项。没有其他（default当然，除此之外）用于任何依赖。即使它们是为prod依赖项配置的，仍然会将其提取到其声明的配置文件的配置文件目录中。例如，顶层的依赖deps将存放在_build/default/lib/下，而test模式会存放在_build/test/lib/下，并且两者都将在prod应用其配置文件配置的情况下进行编译。
> 简而言之，deps存放的目录是和当前的执行模式强相关的

> - 解决冲突
>   与先前版本的rebar不同，有一组严格的规则，其中拿到的依赖关系不会根据提取或更新的时间而改变。对此的算法如下所述：

Rebar3认为依赖版本仅供参考。鉴于Erlang社区中现有的开源环境，试图强加[语义版本控制](https://semver.org/lang/zh-CN/)或任何其他类似方案通常都在胎死腹中：

- 人们更新了一些版本但不是全部版本（git标签与分支名称与OTP应用程序版本相比），它们可能相互矛盾;
- 有些人从不更新他们的版本;
- 不是每个人都订阅相同的版本方案;
- 人们在订阅语义版本时会出错;
- 许多应用程序卡在小于的版本中1.0.0，因此被认为永远不稳定;
- 在撰写本文时，大多数情况下使用源依赖关系：因此，找出版本冲突需要从所有依赖项下载所有传递依赖项，以确定它们是否每次都发生冲突。

在rebar3出现之前，依赖关系的任何其他格式都需要对依赖进行全面检查

相反，rebar3将在级别顺序遍历中获取和下载依赖项。这意味着最接近依赖树根的依赖关系是那些将被选择的依赖关系，无论它们是什么版本。

这意味着在项目中声明的rebar.config任何依赖项永远不会被传递依赖项覆盖，并且传递依赖项永远不会被后来遇到的冲突传递依赖项所覆盖。

这也意味着如果你希望使用的版本高于其他所有版本，您只需将其添加到你的rebar.config文件中并选择将保留的内容即可。

> 将冲突视为错误
> 如果你希望rebar3在检测到依赖项冲突时立即中止，而不是像往常一样跳过文件并继续，请将该行添加{deps_error_on_conflict, true}.到您的rebar配置文件中。

# 声明依赖关系

可以在顶级rebar.config文件中声明依赖关系，并使用该`rebar3 tree`命令进行检查。

通常，Rebar3支持两种类型的依赖项：

- 源依赖
- 包依赖

这两种处理方式可能略有不同（在下载之前，包提供的信息比源依赖项更多，并且将在本地缓存~/.cache/rebar3/），但它们通常表现相同。

所有依赖项都是项目本地的通常是一个很好的选择，以避免全局库存在版本冲突的常见问题。它还有助于独立项目的Releases。

依赖关系描述可以是以下任何格式：

```erlang
{deps,[
  %% Packages
  rebar,
  {rebar,"1.0.0"},
  {rebar, {pkg, rebar_fork}}, % rebar app under a different pkg name
  {rebar, "1.0.0", {pkg, rebar_fork}},
  %% Source Dependencies
  {rebar, {git, "git://github.com/erlang/rebar3.git"}},
  {rebar, {git, "http://github.com/erlang/rebar3.git"}},
  {rebar, {git, "https://github.com/erlang/rebar3.git"}},
  {rebar, {git, "git@github.com:erlang/rebar3.git"}},
  {rebar, {hg, "https://othersite.com/erlang/rebar3"}},
  {rebar, {git, "git://github.com/erlang/rebar3.git", {ref, "aef728"}}},
  {rebar, {git, "git://github.com/erlang/rebar3.git", {branch, "master"}}},
  {rebar, {git, "git://github.com/erlang/rebar3.git", {tag, "3.0.0"}}},
  %% Legacy support -- added parts such as [raw] are ignored
  {rebar, "3.*", {git,"git://github.com/erlang/rebar3.git"}},
  {rebar, {git, "git://github.com/erlang/rebar3.git"}, [raw]},
  {rebar, "3.*", {git, "git://github.com/erlang/rebar3.git"}, [raw]}
]}.
1234567891011121314151617181920
```

如上例所示，对于当前版本，仅支持包，git源和mercurial源。可以通过[实现资源行为](http://www.rebar3.org/docs/custom-dep-resources)并将其包含在插件中来添加自定义依赖项源。

Rebar3将获取所需的任何其他内容。

但是，Erlang / OTP对引导和关闭应用程序以及用于构建版本和脚本的工具（甚至是Rebar3的一部分）所做的依赖性处理依赖于更细粒度的依赖性声明，指定项目中每个应用程序的哪个依赖于其他应用程序。

**你应该每个依赖添加到对应的app或app.src文件：**

```erlang
{application, <APPNAME>,
 [{description, ""},
  {vsn, "<APPVSN>"},
  {registered, []},
  {modules, []},
  {applications, [kernel
                 ,stdlib
                 ,cowboy
                 ]},
  {mod, {<APPNAME>_app, []}},
  {env, []}
 ]}.
123456789101112
```

这将允许灵活地编写和生成软件，其中各种不相交的应用程序可以在虚拟机中共存而不会将它们的依赖性完全纠缠在一起。例如，您可能希望Web服务器能够独立于管理和调试工具运行，即使它们应该在生产中可用。

如果需要支持更多格式，可以通过rebar_resource[行为](https://github.com/erlang/rebar3/blob/master/src/rebar_resource.erl)扩展Rebar3 ，并通过[拉取请求](https://github.com/erlang/rebar3/blob/master/CONTRIBUTING.md)发送给维护者。

# 源依赖

源依赖性将以级别顺序遍历的方式下载 - 从依赖树中的根到叶。一旦看到并获取了依赖项，将忽略共享相同名称的其他依赖项，并显示警告。

对于常规依赖关系树，例如：

```
  A
 / \
B   C 
123
```

依赖项A，B和C将被提取。

但是，对于更复杂的树，例如：

```txt
   A
 /   \
B    C1
|
C2
12345
```

依赖项A，B和C1将被提取。当Rebar3遇到要求时C2，它会显示警告：`Skipping C2 (from $SOURCE) as an app of the same name has already been fetched。`

> 比如你在你的项目中使用了cowlib，但是版本和cowboy不同，同时主项目又依赖cowboy，那么编译时会打印

> ===> Skipping cowlib (from {git,
> “git://github.com/ninenines/cowlib.git”,
> “1.0.0”}) as an app of the same name has already been fetched

这样的消息应该让用户知道已经跳过了哪个依赖项。

那两个传递依赖关系具有相同名称并且处于同一级别的情况呢？

```txt
   A
 /   \
B     C
|     |
D1    D2
12345
```

在这种情况下，D1将替代D2，因为按B字典顺序排序C。这是一个完全武断的规则，但它至少是一个确保可重复提取的规则。

如果用户不同意结果，他们可以D2提升到最高水平并确保提前选择：

```txt
   A      D2
 /   \
B     C
|     |
D1    D2
12345
```

这将产生A，B，C，和D2。而不是D1。
Rebar3对包（package）使用相同的算法，并且还将检测循环依赖性和错误输出。但是，Source依赖项始终优先于包。

`_checkouts`目录中的依赖关系将保持不变。

# 包依赖

rebar3使用[hex.pm](https://hex.pm/)来提供一组托管包及其依赖项，可以使用以下命令获取列表：

```shell
$ rebar3 update
===> Updating package index...
$ rebar3 pkgs
123
```

然后可以包含包依赖关系，如前所示：

```erlang
{deps, [
        {cowboy, "1.0.0"}
       ]
}.
1234
```

包管理器将获取一组最小的依赖项，以符合基于其拓扑排序过的依赖关系图的构建规则。
为了支持源依赖关系的正确行为，将合并和处理包依赖关系集以及源依赖关系的级别顺序遍历。在发生冲突时选择获胜者的最终结果将类似于源依赖关系，并显示警告。

要使用非默认的CDN，例如[官方镜像之一](https://hex.pm/docs/mirrors)添加到您的项目rebar.config或~/.config/rebar3/rebar.config：

```erlang
{rebar_packages_cdn, "https://s3-eu-west-1.amazonaws.com/s3-eu.hex.pm"}.
1
```

# Checkout 依赖

为了处理希望使用本地依赖的情况，提供了`_checkouts`目录，通常只需创建一个符号链接或将依赖项复制到_checkouts目录下，在`_checkouts`目录下的app具有最高优先级，他不会被任何的其他的同名app所覆盖

# 更新依赖

每当获取并锁定依赖项时，Rebar3将从源文件中提取引用以及时将其固定到特定版本。依赖在以后的构建中都必须强制符合这个特定版本。

rebar3允许将以前安装的依赖项升级到更新的版本。有两种形式：将分支的引用转发到其最新版本（例如，旧的master直到新master的HEAD源文件，或最新版本的未指定的版本包），或使用配置在rebar.config的新版本来破坏现有的锁定依赖关系。

但是，Rebar3只允许升级顶级依赖项; 尝试升级传递依赖没有多大意义 - 如果需要对这些依赖进行控制，它们应该被提升到顶层。

在以下依赖关系树中：

```text
A  B
|  |
C  D

1234
```

用户可以一次升级依赖项（rebar3 upgrade A和rebar3 upgrade B）或两者（rebar3 upgrade A,B或者rebar3 upgrade升级所有依赖项）。

只升级A意味着A和C可升级。升级B和D将被忽略。

然而，升级源依赖性充满了危险，并且出现了有趣的特殊案例。考虑以下依赖树：

```text
    A       B       C1
   / \     / \     / \
  D   E   F   G   H   I2
  |   |
  J   K
  |
  I1
1234567
```

在获取上面的依赖树之后，I2将在I1之前被选择。不过，从之后升级C1到C2而且新的C2不再需要依赖I2，Rebar3将自动获取I1下A树（即使没有升级A是必需的），以提供正确的新树：

```text
    A       B     C2
   / \     / \    |
  D   E   F   G   H
  |   |
  J   K
  |
  I1
1234567
```

这是I2不存在了，I1还在，**也就是之前一直使用I2因为C2的更新，导致系统不再使用I2而是变成了I1**

# 锁文件 Lock File

锁文件(rebar.lock)是唯一一个由rebar3生成，但是不在_build目录的产物，这个文件应该被包含在你的源代码列表中，锁文件包含有关代码依赖的信息，包括源依赖中的不可变引用（入git和hg中的那些），以及他们的版本和包预期的哈希值。

这么做的目的是为了使用更准确的依赖而不是通过配置文件自己获得的信息，例如，配置从master更新，这会把你更新到的依赖锁定到一个此刻相对稳定的版本，只有unlock和upgrading才能让他真的更新到一个更新的版本，这么做可以保证即使你使用的源被某人修改了，你的每次构建内容也不会受影响，他是稳定的。

当切换分支或获取传递deps时，Rebar3还将使用锁定文件作为依赖关系的真正权限来源（它将从锁定文件中选择数据，如果有的话）而不是rebar.config文件。当在rebar.config文件中使用松散的引用或版本时，这允许更容易地将安全测试状态携带到其他应用程序中。

从版本3.0.0（实际上是beta-4）开始，该格式预计将向前和向后兼容。Rebar3将根据存储的元数据格式注释锁定文件版本，并在旧版本的rebar3用于读取较新版本的锁定文件时发出警告。这可以告诉用户使用该工具的较旧副本将丢失一些在以后被判断为重要的元数据。

# 依赖锁管理

可以使用以下方法检查锁和依赖项的状态rebar3 deps：

```text
→ rebar3 deps
cowboy* (package)
recon* (git source)
erlware_commons (locked git source)
getopt* (locked git source)
providers (locked hg source)
relx (locked git source)

12345678
```

依赖项与锁定文件将进行比较以报告其状态。磁盘上的存在与锁定文件不匹配的那些用星号（*）注释。

如果依赖项已锁定但不再需要，也不在配置文件中，则可以将其取消标记`rebar3 unlock （rebar3 unlock ,,...,`对于许多应用程序）。

调用rebar3 unlock将完全刷新锁定文件。这以为着你下次更新到的某些从master获得的依赖可能和之前的依赖不一致了，这可能会导致其他问题，所以unlock的时候一定要小心,最好是unlock指定app而不是全部

rebar3 tree可用于显示当前依赖关系树：

```text
→ rebar3 tree
...
|- bootstrap-0.0.2 (git repo)
|- dirmon-0.1.0 (project app)
|- file_monitor-0.1 (git repo)
|- peeranha-0.1.0 (git repo)
|  |- gproc-git (git repo)
|  |- interclock-0.1.2 (git repo)
|  |  |- bitcask-1.7.0 (git repo)
|  |  |  |- lager-2.1.1 (hex package)
|  |  |  |  |- goldrush-0.1.6 (hex package)
|  |  |- itc-1.0.0 (git repo)
|  |- merklet-1.0.0 (git repo)
|- recon-2.2.2 (git repo)
|- uuid-1.5.0 (git repo)
|  |- quickrand-1.5.0 (git repo)
```