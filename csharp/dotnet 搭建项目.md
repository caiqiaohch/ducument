dotnet 搭建项目

直接进入正题，通过运行工具打开终端命令，进入到将要创建项目的目录


创建解决方案
通过 dotnet new sln [解决方案名称] 命令可以创建解决方案。首先先创建一个项目文件夹，将项目放再这个文件夹下面，这里我创建一个名为Shopping的项目文件夹，并再里面创建一个名为Shopping的解决方案


创建项目
通过 doetnet new [console|classlib] -o [项目名称] 命令可以创建项目。按一般项目的结构，分别创建一个UI层，服务层，业务层；这里将他们分别命名为：Shopping.UI(Console主程序)，Shopping.Model(类库)，Shopping.Service(类库)


将项目添加到解决方案
通过 doetnet sln [解决方案文件名] add [项目路径名] 命令将项目添加到解决方案中可以选择单个单个的添加。或者多个批量添加;在Linux/Unix系统中可以使用 **/*.csproj 匹配所有项目。



项目类库引用
通过 dotnet add reference [项目路径名] 可以向当前目录项目添加引用；或者通过doetnet add [项目路径名] reference [项目路径名]

可以在项目文件中看到该项目引用了哪些项目

<ItemGroup>
    <ProjectReference Include="..\Shopping.Service\Shopping.Service.csproj" />
    <ProjectReference Include="..\Shopping.Model\Shopping.Model.csproj" />
</ItemGroup>
这种命令就没必要每次都自己敲了，毕竟3秒男不加奖金，瞎搞了个批处理文件，基本满足一件生成凑合用

start cmd /c 
d:
cd D:\Projects\CSharp\
set slnname=ShellTest
mkdir %slnname%
cd D:\Projects\CSharp\%slnname%
dotnet new sln -n %slnname%
dotnet new console -o %slnname%.UI
dotnet new classlib -o %slnname%.Service
dotnet new classlib -o %slnname%.Model
dotnet new classlib -o %slnname%.Repository
dotnet new classlib -o %slnname%.Infrastructure
dotnet sln %slnname%.sln add %slnname%.UI\%slnname%.UI.csproj
dotnet sln %slnname%.sln add %slnname%.Service\%slnname%.Service.csproj
dotnet sln %slnname%.sln add %slnname%.Model\%slnname%.Model.csproj
dotnet sln %slnname%.sln add %slnname%.Repository\%slnname%.Repository.csproj
dotnet sln %slnname%.sln add %slnname%.Infrastructure\%slnname%.Infrastructure.csproj
cd %slnname%.UI
dotnet add reference ../%slnname%.Service/%slnname%.Service.csproj ../%slnname%.Model/%slnname%.Model.csproj ../%slnname%.Repository/%slnname%.Repository.csproj ../%slnname%.Infrastructure/%slnname%.Infrastructure.csproj
cd ..
cd %slnname%.Service
dotnet add reference ../%slnname%.Model/%slnname%.Model.csproj ../%slnname%.Repository/%slnname%.Repository.csproj ../%slnname%.Infrastructure/%slnname%.Infrastructure.csproj
cd ..
cd %slnname%.Model
dotnet add reference ../%slnname%.Repository/%slnname%.Repository.csproj ../%slnname%.Infrastructure/%slnname%.Infrastructure.csproj
cd ..
cd %slnname%.Repository
dotnet add reference ../%slnname%.Infrastructure/%slnname%.Infrastructure.csproj
cd ..
code .


dotnet相关资料：https://docs.microsoft.com/zh-cn/dotnet/core/tools/dotnet

开启VSCode
通过上面的一顿操作，一个基本项目已经搭建完成。现在你可以通过 Code . 命令即可打开VSCode工具(关于如何安装VSCode及安装C#扩展这里就不赘述了)，VSCode会将当前目录下的项目加载到VSCode的资源管理器中。现在你可以开始正式的编码了...


在项目上右键，通过右键菜单可以快捷的添加一个类文件；或者在资源管理器的菜单中新建一个文件，创建一个类文件。

这里就随便瞎搞了一个产品类，作为测试类


运行C#项目
编写完代码后可以通过快捷键Shift+F5直接运行项目，当然也可以通过菜单栏里的【运行】找到项目的运行方式。或者可以通过 dotnet build生成项目和 dotnet run 命令运行你的程序。

之前忘了一点，在加载C#项目时，VSCode会提示你是否加载项目启动配置，在右下脚的通知消息中可以看到它。点击Yes生成后，会自动生成launch.json和tasks.json两个运行调试配置文件。如果你的项目中没有的话，按下快捷键F5，VSCode会询问你项目的运行环境，选择响应的环境后，会自动生成这两配置文件。关于配置文件的详细说明：https://code.visualstudio.com/Docs/editor/debugging

调试项目
VSCode中调试代码也很简单，类似好多开发工具，在需要调试的代码行上打上断点，直接启动调试(F5快捷键)后VSCode直接运行到断点处，同时可以在右侧的Debug工具监视变量的情况


添加框架
通过dotnet add package [框架名] 命令可以将框架添加到你的项目中，进入到需要被添加的项目，然后执行命令。



如果想要程序中的多个项目都引用这个框架，只需要将相关的引用代码复制到项目文件中，保存后VSCode会提示重新生成相关依赖


当然，VSCode也提供了NuGet扩展插件;安装完插件后，通过VSCode快捷键Shift+Ctrl+P打开命令工具，输入要安装的框架名





其他也没啥好吹的了，毕竟官方文档都写的那么全，就这吧

vscode官方文档：https://code.visualstudio.com/docs#vscode
C#相关部分：https://code.visualstudio.com/docs/languages/csharp
官方连视频教程都安排上了：https://channel9.msdn.com/Blogs/dotnet/Get-started-VSCode-Csharp-NET-Core-Windows