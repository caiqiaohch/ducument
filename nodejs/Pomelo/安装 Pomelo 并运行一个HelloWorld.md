安装 Pomelo 并运行一个HelloWorld
 2017年08月19日     2735     声明



接下来我们将安装 Pomelo，并运行一个“HelloWorld” 示例，以介绍 Pomelo 创建、运行项目等基本过程。

安装
1.1 环境条件
1.2 安装
HelloWorld
2.1 创建项目
2.2 项目目录结构
2.3 启动项目
2.4 服务器状态查看
2.5 停目项目
1. 安装
Pomelo 基于 Node.js 开发，其可以在 Windows、Linux、Mac等环境中使用。

1.1 环境条件
安装 Pomelo 需要满足以下前置条件：

操作系统己安装 Node.js。如果还未安装，请点击安装
系统已安装Python(2.5 < version < 3.0)及C++编译器。Node.js 使用C++和JavaScript编写，但是项目管理使用gyp工具，而gyp是Python编写的，所以还需要安装 Python。
在非 Windows 环境下，python及C++己经预安装。但在Windows环境下，还需要安装C++编译器，如：Visual Studio。Node会使用 gyp生成Visual Studio项目文件，并使用VC++编译成二进制文件。

Pomelo 使用JavaScript编写，但一些 Pomelo 组件使用 C++编写，所以安装 Pomelo时会使用C++编译器。在Windows环境下请确保满足以下两个条件：
Python (2.5 < 版本 < 3.0).
VC++编译器，如：Visual Studio 2010等


1.2 安装
如果己满足安装条件，就可以使用Node.js包管理工具npm来全局安装Pomelo：

$ npm install pomelo -g
也可下载源码再安装：

$ git clone https://github.com/NetEase/pomelo.git
$ cd pomelo
$ npm install -g
在以上安装中，我们使用了-g参数，该参数会将Pomelo安装为一个全局的npm模块。

安装过程中如果没有出现错误，就会安装成功。可以通过以下命令检查：

$ pomelo -V


2. HelloWorld
接下来，我们通过一个“HelloWorld”示例来介绍 Pomelo 创建项目，及项目管理的一些过程。

安装Pomelo后，会包含一个“命令行工具”。我们可以使用这个工具来进行Pomelo项目管理，如：初始化、运行、停止等。详细参考：

Pomelo command-line tool
2.1 创建项目
使用Pomelo 命令行工具中的pomelo init，可以初始化一个Pomelo项目：

$ pomelo init ./HelloWorld
可以使用以下几条命令来初始化：

$ mkdir HelloWorld
$ cd HelloWorld
$ pomelo init
初始化项目后，进入HelloWorld目录，并执行npm-install.sh文件安装项目依赖模块：

$ sh npm-install.sh
在 Windows 环境下，要使用npm-install.bat文件来安装。



2.2 项目目录结构
我们刚创建的项目，目录结构如下：



在开发项目，我们只需要在对应的目录下写入相关代码即可。下面是一个 Pomelo 项目目录及其子目录的简要分析：

game-server

game-server即游戏服务器目录，该目录包含了游戏逻辑代码，它使用文件app.js作为入口点运行所有的游戏逻辑和功能。所有的游戏逻辑、功能点、配置文件等，都在这个目录下。

app子目录
所有游戏逻辑和功能相关代码都这个子目录下，在这里用户可以实现一个不同类型的服务器，将向其添加Handlers、Remotes、Components等

config子目录
config目录包含了游戏服务器的所有配置信息。所有的配置文件都使用JSON格式编写，包括日志、主服务器及其它服务器配置等。此外，你还可以将数据库连接信息、地图信息、字典表等配置放在该目录下。也就是说，你可以将任何游戏服务器相关的配置放在这个目录下。

logs子目录
这个目录包含了游戏服务器的运行日志。我们可以通过这些日志进行项目分析、查看运行情况等。

shared

shared目录中包括一些服务端和客户端的共享代码。如果你使用HTML5或其它使用JavaScript语言的客户端，那么就可以把一些服务端和客户端公用工具、算法库等放在shared目录下。

web-server

web-server目录是基于Express框架实现的一个Web服务器。如果使用Web客户端，那么可以通过该服务器向客户端提供静态资源等。当然，如果使用Android或iOS平台做为客户端时，该目录就是非必要的。但在本示例中，我们使用Web做为一个简单的客户，web-server是必要的。



2.3 启动项目
在本例中，我们使用Web做为客户端，因此需要将game-server和web-server都启动。

启动game-server：

$ cd game-server
$ pomelo start
启动web-server：

$ cd web-server
$ node app
如果因为端口冲突而导致项目启动失败，可以修改端口配置后，再重新启动。游戏服务器通过game-server/config/servers.json文件修改；Web服务器通过web-server/app.js文件修改。

启动项目后，可以在浏览器中输入http://localhost:3001或http://127.0.0.1:3001，然后点击Test Game Server测试项目。测试成功后，运行效果类似如下：





2.4 服务器状态查看
在 Pomemlo 命令行工具中有一个pomelo list命令，我们可以通过该命令查看已启动服务器的运行状态：



通过这个命令我们可以看到服务器的以下信息：

serverId - 服器Id，可以通过servers.json文件来配置
serverType - 服务器类型，通过servers.json文件来配置
headUsed - 服务器已经使用堆大小(MG)
uptime - 服务器运行时长


2.5 停目项目
可以通过以下两种方式停止已启动的项目：

$ cd game-server
$ pomelo stop
或者：

$ cd game-server
$ pomelo kill
其中，更推荐使用pomelo stop的方式来停止项目。