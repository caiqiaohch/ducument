Pomelo 应用程序配置
创建Pomelo应用后，可以在game-server/app.js文件中对应用做一些配置。包括配置每个组件选项配置、加载配置文件、启用／禁用Pomelo特性等框架配置。

app.js文件
app.configure() - 配置服务器
访问上下文变量
禁用／启用特性
加载配置文件
加载组件
配置路由
配置过滤器
配置模块
服务器配置文件
1. app.js文件
app.js文件是Pomelo应用的入口点。在这个文件中，首先需要使用pomelo.createApp()方法来创建一个应用类（Application）的实列，然后就可以通过这个app配置和使用框架。开发人员可以设置全局变量、加载一些配置等，并应用到上下文中，还可以对应用做一些其它初始化和配置操作。配置完成后，可以调用app.start()来启动应用。

app.js中的主要内容如下：

var pomelo = require('pomelo');
var app = pomelo.createApp();

// some configurating operation for app.

app.configure(<env>, <serverType>, function() {
   // ... 
});

app.configure(....);
app.set(...);
app.route(...);

// ...

// start app
app.start();


2. app.configure() - 配置服务器
配置服务器总是通过调用app.configure()方法，其签名如下：

app.configure([env], [serverType], [function]);
其中env和serverType参数是可选的。各参数说明如下：

env - 运行时环境。可以设置为development、production或development|production
serverType - 目标服务器类型。如果将其设置为T，那么仅会为类型为T的服务器应用配置逻辑；如果忽略本参数，则对所有服务器生效
function - 必须，用于设置服务器的配置逻辑
以下是一些配置示例：

示例 1

app.configure(function() {
  // Do some configuration
});
这类配置将对服务的所有运行环境生效（development和production），这相当于直接在app.js写配置代码。如：

app.configure(function () {
  doSomeConfiguration ();
});

// 另一种配置方式
doSomeConfiguration(); // 等价于上面的 `app.configure`
示例 2

app.configure('development', function() {
  // Do some configuration just for development env only.
});
以上配置仅会对开发环境生效

示例 3

app.configure('development', 'chat', function () {
  // Do some configuration just for development env and chat server only.
});
以上配置仅会在开发环境下对chat类型的服务器生效

配置逻辑

开发人员可以为不同服务器设置不同的配置，以满足服务器的需求。例如，为所有服务器加载MySQL配置：

app.configure('development|production', function() {
  app.loadConfig('mysql', app.getBase() + '/config/mysql.json');
});
还可以针对不同类型的服务器单独进行一些配置。如，对区域服务器进行一些初始化：

var initArea = function () {
  // area server initialization
};

app.configure('development|production', 'area', function() {
  initArea ();
});
在app.js中，可以对任何环境中的任何服务器进行任何配置。这些配置包括设置一个可以框架任何地方使用的变量的、启用/禁用Pomelo的一些特性、设置内置组件、对于一个特定的服务器配置过滤器等。如：

app.configure('development|production', 'chat', function() {
  app.route('chat', routeUtil.chat); // configure route
});

app.enable('systemMonitor'); // enable feature

app.configure('development|production', 'gate', function() {
  app.set('connectorConfig', {
    connector: pomelo.connectors.hybridconnector,
    heartbeat: 3
  }); // configure opts for connector component
}); // configure connector for gate server


3. 访问上下文变量
在应用实例中有针对上下文的getter/setter：

app.set(name, value, [isAttach]);
app.get(name);
对于setter，其有3个参数：name - 变量名、value - 变量值、isAttach-（可选）是否做为应用实例属性附加到应用实例上，默认为false。
对于getter，其用于通过变量名获取对应的值
示例如下：

app.set('server', server);
var server = app.get('server');

app.set('service', service, true);
var service = app.service;
在Pomelo框架中，开发者可以通过app.set对Pomelo内置组件进行一些设置。同时，一些内置服务，如backendSessionService、channelService也通过app.get提供了一体化通道。示例如下：

app.set('connectorConfig', {
  // ...
}); // set options for connector component

var backendSessionService = app.get('backendSessionService'); // get backendSessionService instance
此外，开发者还可以自定义一些设置，并可以在应用的任何位置通过app.get来访问。



4. 禁用／启用特性
开发者可以通过enable()/disable()来启用／禁用Pomelo框架的一些特性，并可通过enabled()/disable()方法来检查特性的可用状态。

如，禁用及启用rpc调试日志及检查相应状态：

app.enable('rpcDebugLog');
app.enabled('rpcDebugLog'); // return true
app.disable('rpcDebugLog');
app.disabled('rpcDebugLog'); // return true
在 Pomelo 框架中，当需要做更详细的监测和管理时，可以启用systemMonitor特性，以加载额外的模块。如：

app.enable('systemMonitor'); // enable system monitor


5. 加载配置文件
我们还可以在app.js中通过app.loadConfig()方法来加载配置文件，而配置信息会被直接挂载到app对象上。

如，加载配置目录game-server/config下的mysql.json文件：

// mysql.json
{
  "development":
  {
    "host": "127.0.0.1",
    "port": "3306",
    "database": "pomelo"
  }
}

// app.js
app.loadConfig('mysql.json');
var host = app.mysql.host; // return 127.0.0.1
实际上，可以通过app.loadConfig()加载game-server/config下的任何JSON格式的文件。



6. 加载组件
Pomelo 的功能由它的组件提供，Pomelo 会根据不同的服务器类型加载不同的内置组件，开发者还可以自己实现，并将其手动加载到 Pomelo中。

加载组件使用app.load()方法，如：

app.load(HelloWorldComponent, [opts]); // opts is optional


7. 使用插件
Pomelo 还可以使用自定义插件，插件由多个组件和事件处理程序组成，事件处理程序用于响应应用程序发出的事件。

使用插件通过app.use()方法引入，如：

// app.use (<plugin>, <plugin options>);

var statusPlugin = require('pomelo-status-plugin');

app.use(statusPlugin, {
  status: {
    host: '127 .0.0.1 ',
    port: 6379
  }
});


8. 配置路由
路由器用于计算客户端请求的目标服务器。开发人员可以为不同的服务器定制不同的路由策略，然后在服务器上进行配置。如：

// routeUtil.js
app.route('chat', routeUtil.chat);
路由策略还可以定义为一个routerUtil文件，如：

routeUtil.chat = function(session, msg, app, callback) {
  var chatServers = app.getServersByType('chat');
  if (!chatServers) {
    callback (new Error ('can not find chat servers.'));
    return;
  }
  var server = dispatcher.dispatch (session.rid, chatServers);
  callback (null, server.id);
};
在以上路由函数中，通过调用回调函数作为并通过其参数来返回了目标服务器id。



9. 配置过滤器
过滤器（filter）用于过滤用户请求。

当客户机的请求到达服务器时，它将由过滤器链和处理程序进行处理。Handler（处理器）是处理业务逻辑的地方，它会对过滤器中的业务逻辑进行一些前置或后置处理。为了方便开发者，Pomelo提供了大量的内置过滤器，如：serialFilter、timeFilter、timeOutFilter。开发者还可可以根据自己的需要，定制自己的过滤器。

配置过滤使用app.filter()方法，如：

app.filter(pomelo.filters.serial()); // configure builtin filter: serialFilter

app.filter(FooFilter); // configure FooFilter as a before & after filter

app.before(beforeFilter); // configure beforeFilter only as a before filter

app.after(afterFilter); // configure afterFilter only as an after filter
如果仅有前置过滤器（beforeFilter），那么可以使用app.before()方法引入；如果仅有后置过滤器（afterFilter），那么可以使用app.after()方法引入；如果两者都有，则可以使用app.filter()方法引入。



10. 配置模块
Pomelo 提供了框架监控和管理功能，可以为不同的目的注册不同的模块。注册模块使用app.registerAdmin()方法，如：

app.registerAdmin(require ('../modules/watchdog'), {app: app, master: true});


11. 服务器配置文件
在 Pomelo 项目的game-server/config目录中有很多配置文件，其中两个用于服务器的配置，分别是：servers.json、 master.json。

两个配置文件中都包含了development和production两种配置。

{
  "development": {
    "id": "master-server-1", "host": "127.0.0.1", "port": 3005
  },
  "production": {
    "id": "master-server-1", "host": "127.0.0.1", "port": 3005
  }
}
以上是一个master.json文件示例，其中各字段说明如下：

id - 字符串，主服务器Id
host - 主服务器的主机名，可以是域名或IP
port - 主服务器的监听端口，默认是3005
args - 可选，用于node/v8配置，如配置为"args": "--debug=5858 "这样就可以启用项目调试
{
  "development": {
    "connector": [
      {"id": "connector-server-1", "host": "127.0.0.1", "port": 3150, "clientPort": 3010, "frontend": true}
    ],
    "auth": [
      {"id": "auth-server-1", "host": "127.0.0.1", "port": 3650}
    ],
    "gate": [
      {"id": "gate-server-1", "host": "127.0.0.1", "clientPort": 3014, "frontend": true}
    ]
  },
  "production": {
    "connector": [
      {"id": "connector-server-1", "host": "127.0.0.1", "port": 3150, "clientPort": 3010, "frontend": true}
    ],
    "auth": [
      {"id": "auth-server-1", "host": "127.0.0.1", "port": 3650}
    ],
    "gate": [
      {"id": "gate-server-1", "host": "127.0.0.1", "clientPort": 3014, "frontend": true}
    ]
  }
}
以上是一个server.json文件示例，其中各字段说明如下：

id - 字符串，应用服务器Id
host - 应用服务器的主机名，可以是域名或IP
port - RPC请求的监听端口
frontend - 布尔值，是否是前端服务器。默认为false
clientPort - 前端服务器配置项，用于配置前端服务器的客户端请求的监听端口
max-connections - 可选，前端服务器配置项，用于前端服务器所保持的最大客户连接数;
args - 可选，同主服务器
cpu - 设置服务器进程的CPU类型，依赖于taskset且仅对 unix 类平台有效