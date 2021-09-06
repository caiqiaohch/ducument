# Visual Studio Code创建C#项目

https://www.cnblogs.com/zhuanghamiao/p/vscode-csharp.html
Visual Studio Code是一个支持跨平台的文本编辑器，同其他文本文本编辑器一样，不但占用磁盘空间小，性能也比较快；近几年由于不断的升级和许多开发者提供大量的插件，它已经成为了一个非常强大的代码编辑器。所以当我们创建一些中小型项目或者需要修改项目中的某个文件，直接使用vscode是非常方便的。

安装vscode
vscode下载地址https://code.visualstudio.com/

安装C#语言的运行环境，当然安装过Visual Studio编辑器的话是不需要再安装了

下载地址.NET Corehttps://dotnet.microsoft.com/download

然后在vscode中安装C#语言的插件


相关的文档：https://code.visualstudio.com/docs/languages/csharp
视频介绍:https://channel9.msdn.com/Blogs/dotnet/Get-started-VSCode-Csharp-NET-Core-Windows

创建C#项目
打开vscode，然后添加一个工作空间


添加工作空间之后，通过vscode菜单新建一个终端(快捷键Ctrl+Shift+`)

dotnet --help  //查看dotnet相关的帮助命令
创建解决方案
PS D:\Projects\CSharp> dotnet new sln -o MyApp
已成功创建模板“Solution File”。
创建项目类库
首相进入项目目录，然后再创建对应的主程序和类库

PS D:\Projects\CSharp> cd .\MyApp\
PS D:\Projects\CSharp\MyApp> dotnet new classlib -o  MyApp.Model
已成功创建模板“Class library”。

正在处理创建后操作...
正在 MyApp.Model\MyApp.Model.csproj 上运行 "dotnet restore"...
  正在还原 D:\Projects\CSharp\MyApp\MyApp.Model\MyApp.Model.csproj 的包...
  正在生成 MSBuild 文件 D:\Projects\CSharp\MyApp\MyApp.Model\obj\MyApp.Model.csproj.nuget.g.props。
  正在生成 MSBuild 文件 D:\Projects\CSharp\MyApp\MyApp.Model\obj\MyApp.Model.csproj.nuget.g.targets。
  D:\Projects\CSharp\MyApp\MyApp.Model\MyApp.Model.csproj 的还原在 210.35 ms 内完成。

还原成功。

PS D:\Projects\CSharp\MyApp> dotnet new console -o  MyApp.HelloWorld
已成功创建模板“Console Application”。

正在处理创建后操作...
正在 MyApp.HelloWorld\MyApp.HelloWorld.csproj 上运行 "dotnet restore"...
  正在还原 D:\Projects\CSharp\MyApp\MyApp.HelloWorld\MyApp.HelloWorld.csproj 的包...
  正在生成 MSBuild 文件 D:\Projects\CSharp\MyApp\MyApp.HelloWorld\obj\MyApp.HelloWorld.csproj.nuget.g.props。
  正在生成 MSBuild 文件 D:\Projects\CSharp\MyApp\MyApp.HelloWorld\obj\MyApp.HelloWorld.csproj.nuget.g.targets。
  D:\Projects\CSharp\MyApp\MyApp.HelloWorld\MyApp.HelloWorld.csproj 的还原在 201.45 ms 内完成。

还原成功。
将类库添加到项目中
PS D:\Projects\CSharp\MyApp> dotnet sln add  .\MyApp.HelloWorld\MyApp.HelloWorld.csproj
已将项目“MyApp.HelloWorld\MyApp.HelloWorld.csproj”添加到解决方案中。
PS D:\Projects\CSharp\MyApp> dotnet sln add  .\MyApp.Model\MyApp.Model.csproj
已将项目“MyApp.Model\MyApp.Model.csproj”添加到解决方案中。
项目中类库间的引用
首先需要进入到要添加引用的程序集目录中，然后执行引用命令

PS D:\Projects\CSharp\MyApp> cd .\MyApp.HelloWorld\
PS D:\Projects\CSharp\MyApp\MyApp.HelloWorld> dotnet add reference ../MyApp.Model/MyApp.Model.csproj
已将引用“..\MyApp.Model\MyApp.Model.csproj”添加到项目。
编译和运行代码
PS D:\Projects\CSharp\MyApp> dotnet build
PS D:\Projects\CSharp\MyApp> dotnet run --project MyApp.HelloWorld
代码调试
vscode同时支持友好的界面代码调试，通过F5启动调试;启动调试时还需要我们添加调试的一些配置，可以通过vscode自动创建配置模板(launch.json和task.json)，然后我们再对应进行修改

{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": ".NET Core Launch (console)",
            "type": "coreclr",
            "request": "launch",
            "preLaunchTask": "build",
            "program": "${workspaceFolder}\\MyApp\\MyApp.HelloWorld\\bin\\Debug\\netcoreapp2.2\\MyApp.Apps.dll",
            "args": [],
            "cwd": "${workspaceFolder}",
            "stopAtEntry": false,
            "console": "internalConsole"
        }

    ]
}

{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build",
            "command": "dotnet",
            "type": "shell",
            "args": [
                "build",
                // Ask dotnet build to generate full paths for file names.
                "${workspaceRoot}\\MyApp",
                "/property:GenerateFullPaths=true",
                // Do not generate summary otherwise it leads to duplicate errors in Problems panel
                "/consoleloggerparameters:NoSummary"
            ],
            "group": "build",
            "presentation": {
                "reveal": "silent"
            },
            "problemMatcher": "$msCompile"
        }
    ]
}
