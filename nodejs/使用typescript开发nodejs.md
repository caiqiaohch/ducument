使用typescript开发node js

一、typescript helloworld
参考
TypeScript（入门）

1.安装node,npm,typescript,vs code等
2.新建一个目录，比如tsHelloworld,使用命令行运行tsc --init，tsc会帮助我们创建一个tsconfig.json文件，tsconfig是tsc每次编译时都会检查的一个配置文件。这里可以参考tsconfig.json官方文档

命令行运行code .,使用vs code打开项目。
image.png

rootDir,outDir默认被 注释掉了，一个是源文件目录，一个是编译后生成的JS目录。在tsHelloworld下新建两个文件夹：bin,src，然后更改相应的配置。
3.在VS CODE任务主菜单下，选择运行生成任务，或者使用CTRL+SHIFT+B
image.png

这里可以参考tsconfig.json官方文档
选择tsc:构建，控制 台会报错，这是因为src目录下找不到ts文件。

> Executing task: tsc -p e:\node\tsHelloworld\tsconfig.json <

error TS18003: No inputs were found in config file 
'e:/node/tsHelloworld/tsconfig.json'. Specified 'include' 
paths were '["**/*"]' and 'exclude' paths were '[]'.
在src目录下，新建一个Hello.ts的文件：

class Hello {
    firstName : string;
    lastName : string;
    constructor(fiestName : string,  lastName : string) {
        this.firstName = fiestName;
        this.lastName = lastName;
    }
    greeter() {
        return "欢迎来到typescript的世界，hello" +
         this.firstName + " " + this.lastName;
    }
}
var user = new Hello("王", "小二");
document.body.innerHTML = user.greeter();
然后再使用tsc:构建，可以发现bin目录下多出一个Hello.js文件。
4.在bin目录下，新建index.html文件：

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hello Word</title>
</head>
<body>
    <script src="Hello.js"></script>
</body>
</html>
现在，可以运行index.html文件看一下页面了。

二、ts开发node.js
typescript 开发node 可行么？ 会存在什么问题
TypeScript在node项目中的实践
【学习笔记】在VSCode上配置typescript + nodejs 开发环境
这里部分参考本文第一部分的helloworld内容
1.新建ts-node-starter文件夹，命令行运行tsc --init,然后使用code .打开vs code。tsc:构建配置一下，打开tasks.json
2.tsconfig.json把sourceMap打开
3.debug配置，打开launch.json。这里可以参考node js调试相关

    "configurations": [
        {
            "type": "node",
            "request": "launch",
            "name": "启动程序",
            "program": "${workspaceRoot}/app.ts"
        }
    ]
4.新建app.ts

import { createServer, Server, IncomingMessage, ServerResponse } from 'http';
// 明确类型麻烦些，却会获得非常详细的语法提示
 
const server: Server = createServer((req: IncomingMessage, res: ServerResponse) => {
    res.statusCode = 200;
    res.setHeader("Content-Type", "text/plain");
    res.end("Hello World\n");
})

const hostname: string = "127.0.0.1";
const port: number = 3000;
server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
})
关于import，还是require，参考 Typescript import/as vs import/require? [duplicate]
参考在nodeJs的Express框架下用TypeScript编写router路由出现import关键字错误的解决方案：

其实这里只是import变成了var而已，但其意义在于在ts代码中采用import载入的模块可以享用强类型检查，以及代码自动补全，预编译检查等。

5.编译成js后，可以断点调试了。
6.代码提示typings
参考代码提示Typings，这里区别有点大，import { createServer, Server, IncomingMessage, ServerResponse } from 'http';都认不出来。不像写JS的时候，直接typings init就行了。

E:\node\ts-node-starter> typings install node --ambient --save
typings ERR! deprecated The "ambient" flag
 is deprecated. Please use "global" instead
E:\node\ts-node-starter> typings install node --global --save
没办法，只能把node安装进来。参考使用TypeScript编写node项目的疑惑。这时可以看到typings.json变成这样：

{
  "dependencies": {},
  "globalDependencies": {
    "node": "registry:dt/node#7.0.0+20170322231424"
  }
}
这时候再写import * as http from 'http';就可以进入代码提示了。
7.@types
参考在 Typescript 2.0 中使用 @types 类型定义
使用Typescript开发node.js项目——简单的环境配置

在 Typescript 2.0 之后，TypeScript 将会默认的查看 ./node_modules/@types 文件夹，自动从这里来获取模块的类型定义，当然了，你需要独立安装这个类型定义。比如，你希望 core.js 的类型定义，那么，你需要安装这个库的定义库。
npm install --save @types/core-js
与我们安装一个普通的库没有区别。当然了，常用的 jquery 也有。Microsoft 在 The Future of Declaration Files 介绍了 TypeScript 的这个新特性。

在项目目录下执行安装:npm install --save-dev @types/node就可以获得有关node.js v6.x的API的类型说明文件。之后，就可以顺利的导入需要的模块了:import * as http from 'http';完成之后，不仅可以正常的使用http模块中的方法，也可以在vscode中获得相应的代码提示。

对于内建模块，安装一个@types/node模块可以整体解决模块的声明文件问题。那么，对于浩如烟海的第三方模块，该怎么办呢？官方和社区中也提供了查找和安装的渠道：

typings
DefinitelyTyped
TypeSearch

作者：合肥黑
链接：https://www.jianshu.com/p/0e37a793ac3a
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。