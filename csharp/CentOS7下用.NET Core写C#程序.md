# CentOS7下用.NET Core写C#程序

2017 微软一个比较大的动作就是.Net core2.0了，微软出的这个框架野心很大：它可以让用户在几乎所有的PC终端用C#编写自己的应用程序。在win/Linux/mac三大主流操作系统通吃之后，.Net core居然也支持Docker！
本文试着在Centos7运行自己的C#程序，其他操作系统包括Windows，MacOS和docker上的教程见官网：.Net Core
首先需要安装libunwind和libicu以及.Net SDK：

sudo yum install libunwind libicu
curl -sSL -o dotnet.tar.gz https://aka.ms/dotnet-sdk-2.0.0-linux-x64
1
2
然后新建个目录，把刚才下载的dotnet.tar.gz解压：

mkdir dotnet
cp dotnet.tar.gz  dotnet
cd dotnet && tar -xzvf dotnet.tar.gz
1
2
3
接下来把刚才解压dotnet.tar.gz的那个目录加到系统变量，就可以在CentOS7写C#代码了。

vim ~/.bashrc
1
加入以下代码：

export DOTNET_HOME=/home/dotnet #dotnet解压后目录
export PATH=$DOTNET_HOME:$PATH  #系统变量
1
2
然后让系统变量生效：

source ~/.bashrc
1
接下来试下dotnet是否安装成功：

dotnet --help
1
如果打印以下提示，说明安装成功：

.NET Command Line Tools (2.0.0)
Usage: dotnet [runtime-options] [path-to-application]
Usage: dotnet [sdk-options] [command] [arguments] [command-options]

path-to-application:
  The path to an application .dll file to execute.

SDK commands:
  new              Initialize .NET projects.
  restore          Restore dependencies specified in the .NET project.
  run              Compiles and immediately executes a .NET project.
  build            Builds a .NET project.
  publish          Publishes a .NET project for deployment (including the runtime).
  test             Runs unit tests using the test runner specified in the project.
  pack             Creates a NuGet package.
  migrate          Migrates a project.json based project to a msbuild based project.
  clean            Clean build output(s).
  sln              Modify solution (SLN) files.
  add              Add reference to the project.
  remove           Remove reference from the project.
  list             List reference in the project.
  nuget            Provides additional NuGet commands.
  msbuild          Runs Microsoft Build Engine (MSBuild).
  vstest           Runs Microsoft Test Execution Command Line Tool.

Common options:
  -v|--verbosity        Set the verbosity level of the command. Allowed values are q[uiet], m[inimal], n[ormal], d[etailed], and diag[nostic].
  -h|--help             Show help.

Run 'dotnet COMMAND --help' for more information on a command.

sdk-options:
  --version        Display .NET Core SDK version.
  --info           Display .NET Core information.
  -d|--diagnostics Enable diagnostic output.

runtime-options:
  --additionalprobingpath <path>    Path containing probing policy and assemblies to probe for.
  --fx-version <version>            Version of the installed Shared Framework to use to run the application.
  --roll-forward-on-no-candidate-fx Roll forward on no candidate shared framework is enabled.
  --additional-deps <path>          Path to additonal deps.json file.

接下来新建一个类似于windows下的控制台程序hwapp：

dotnet new console -o hwapp

最后执行以下命令，程序就会在终端打印”hello world”：

cd hwapp
dotnet restore  #编译
dotnet run      #执行
————————————————
版权声明：本文为CSDN博主「nudt_qxx」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/xiangxianghehe/article/details/77339508