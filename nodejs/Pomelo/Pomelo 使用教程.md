Pomelo 使用教程
继"Hello World"之后，我们参照官方文档，以一个"Chat"为例进一步学习Pomelo的使用。在本文中，将会涵盖筛选器、路由及消息压缩、RPC调用、组件等主要Pomelo特性的使用。

概述
"Chat"源码下载及安装
扩充服务器及Router
添加筛选器（Filter）
路由压缩
Protobuf压缩数据
RPC调用
组件的使用
Admin模块
1. 概述
在使用本教程前，请注意以下几点：

本教程适用于对Pomelo零基础的用户，如果你已有一些相关基础，那么可以跳过本教程，直接查看开发指南。
Pomelo基于Node.js，因此需要对Node.js和JavaScript有一定了解。
教程的示例源码托管在GitHub上，并能过分支管理不同功能模块，所以也需要对Git有一定的了解
本文以一个聊天（Chat）应用为例，并通过对应用进行修改，来介绍Pomelo框架的相关功能


在Pomelo中有一些专用术语，在继续本文之前，请先通过下面链接了解这些术语，以便更好的理解：

Pomelo中的术语


2. "Chat"源码下载及安装
可以从GitHub下载源码并运行，也可以使用pomelo init来初始化一个项目模块，再参考GitHub源码来编写。

2.1 源码结构
可以通过以下方式下载源码：

$ git clone https://github.com/NetEase/chatofpomelo-websocket.git
$ cd chatofpomelo-websocket/
$ git checkout tutorial-starter
代码结构如下：



pomelo init初始化项目模板后，其中会有game-server、web-server两个目录。功能如下：

game-server

game-server目录用于存放游戏服务器的相关代码，并以app.js为入口，运行游戏逻辑及功能。

在上面示例的app/servers子目录中，还包含gate、connector、chat。在Pomelo中，会以路径来区分服务器类型，因此这三个目录分别表示三种不同类型的服务器。在每个目录下，又可以定义Handler和Remote，Handler和Remote就决定了服务器的行为。

三种服务器介绍如下：

gate服务器，其逻辑代码位于gateHandler.js文件中。其主要功能是，接受客户端的查询请求，并向客户端返回一个可用的connector服务器地址（ip、port）
connector服务器，其逻辑代码位于entryHandler.js文件中。其主要功能是，接受客户端请求，并将其路由到chat服务器，以及维护客户端的链接。
chat服务器，在该服务器下，同时定义了remote和handler两种代码。其中，handler用于处理用户的send请求；而remote由connectorRPC远程调用，用于处理在用户加入和退出时的channel相关操作。
在game-server的config子目录，是存放游戏服务器所有配置文件的地方。配置文件使用JSON格式，包含的配置有：主(Master)服务器配置、其它服务器配置、日志配置等，此外，一般也会游戏逻辑所需要的配置放到这个目录下，像数据库配置、地图信息等。

config子目录用于存放游戏服务器所产生的日志信息。

web-server

在本教程中，聊天应用的客户端是一个Web应用，所以会需要一个Web服务器。在这个目录中，包括客户端的JS、CSS和静态资源等。在本示例中，我们主要关注服务端逻辑，所以对客户端几乎不用修改直接使用即可。



2.2 安装及运行
在执行以下安装命令前，请确保已安装Pomelo。

执行npm-install.sh（Windows请使用npm-install.bat）安装项目依赖：

$ sh npm-install.sh
启动游戏服务器：

$ cd game-server
$ pomelo start
启动Web服务器：

$ cd web-server
$ node app.js
如果启动没有问题，就可以在浏览器中输入http://127.0.0.1:3001打开应用。打开后输入一个用户名、及房间名就可以进入聊天了。多打开几个客户实例，就可以测试"Chat"应用是否能正常工作。





2.3 Chat应用结构
我们用Pomelo搭建的Chat的运行架构如下：



在这个运行架构中，前端服务器connector用于承载连接，而后端的聊天服务器则是处理具体逻辑的地方。 这样的运行架构具有如下优势：

负载分离 - 连接逻辑与后端的业务处理逻辑完全分离，这样做是很有必要的，尤其是广播密集型应用（如：游戏、聊天）。密集的广播与网络通讯会占掉大量的资源，经过分离后业务逻辑的处理能力就不再受广播的影响。
切换简便 - 因为有了前、后端两层的架构，用户可以任意切换频道或房间而不需要重连前端的WebSocket。
易于扩展 - 用户数的扩展可以通过增加connector进程的数量来支撑。频道的扩展可以通过哈希分区等算法负载均衡到多台聊天服务器上。理论上这个架构可以实现频道和用户的无限扩展。
客户端

在聊天应用中，主要包括包括以下几个部分的逻辑处理：

用户进入聊天室 - 这时需要把用户信息注册到Session，将用户加入聊天室对应的Channel。
用户发起聊天 - 这时用户会从客户端发起请求，而服务端会接收、处理请求等。
广播用户的聊天 - 这时，需要向聊天室内发送广播，以使同一个聊天室的客户端收到并显示聊天内容。
用户退出 - 用户退出时需要做一些清理工作，包括Session、Channel的清理。
主要处理流程如下：

首先，客户端要向gate服务器查询一个可用的connector服务器；gate会给客户端响应一个connector的IP地址、端口。

以下是部分处理代码，完整代码位于web-server/public/js/client.js中：

fuction queryEntry(uid, callback) {
  var route = 'gate.gateHandler.queryEntry';
  // ...
}

$("#login").click(function() {
  username = $("#loginUser").attr("value");
  rid = $('#channelList').val();

  // ...

  // query entry of connection
  queryEntry(username, function(host, port) {
    pomelo.init({
      host: host,
      port: port,
      log: true
    }, function() {
         // ...
    });
  }) ;
});
查询到connector地址后，会向其发送用户名（username）、及房间ID（rid）以登录到connector服务器：

pomelo.request('connector.entryHandler.enter',
               {username: username, rid: rid}, 
               function() {
    // ...
});
当发超会话时，会请求chat.chatHandler.send服务：

pomelo.request('chat.chatHandler.send',
               {content: msg, from: username, target: msg.target},
               function(data) {
  // ...
});
当有人加入房间、离开房间、及发起会话时，同房间的用户会收到对应的消息推送。在客户端，会以回调的方式收到通知：

pomelo.on('onAdd', function(data) {
  // ...
});

pomelo.on('onLeave', function(data) {
  // ...
});

pomelo.on('onChat', function(data) {
  // ...
});


服务端

在Pomelo中，只要定义了其Handler及remote，就定义了这个服务器的行为，也就决定了这个服务器的类型。在本例中，有gate、connector、chat三种类型的服务器，它们各自要完成的逻辑如下：

gate - 处理客户端对connector的查询请求，这些逻辑在其Handler中实现。在本例中，只有一台connector服务器，因此直接返回即可：
handler.queryEntry = function(msg, session, next) {
    var uid = msg.uid;
    // ...
};
connector - 接受客户端请求、完成用户注册及绑定、维护客户端session信息，处理客户端的断开连接，其逻辑代码位于connector/handler/entryHandler.js中。大致如下：
handler.enter = function(msg, session, next) {
    var self = this;
    var rid = msg.rid;
    var uid = msg.username + '*' + rid
    var sessionService = self.app.get('sessionService');
  // .....
};
chat - 是实现聊天逻辑的地方，它会维护Channel信息，一个房间就相当于一个Channel，每个Channel中可以有多个用户，当有用户发起聊天的时，会向整个channel中广播聊天内容。
chat服务器还会接受connector的远程调用，完成Channel维护中的用户的加入、离开等逻辑。所以chat服务器不仅定义了Handler，还定义了Remote。当有客户端连接到connector后，connector会向chat发起RPC远程调用，chat会将登录用户，加到对应的Channel中。其主要逻辑代码如下：

// chatHandler.js
handler.send = function(msg, session, next) {
    var rid = session.get('rid');
    var username = session.uid.split('*')[0];
    // .....
};

// chatRemote.js
ChatRemote.prototype.add = function(uid, sid, name, flag, cb) {
    var channel = this.channelService.getChannel(name, flag);
};

ChatRemote.prototype.kick = function(uid, sid, name) {
    var channel = this.channelService.getChannel(name, false);
  // ...
};
注意：在具体的Handler中，需要调用next进行请求响应或进入下次处理等。其签名为next(err, resp)，如果没有错误，err留空即可；resp表示向用户返回的响应信息；如果不是request请求，而是notify时，同样需要调用next，这时不需要传入resp参数。

服务器配置位于config目录下，其中servers.json、master.json两个文件用于配置服务器。master.json配置的是主服务器，包括：IP地址、端口号；而servers.json用于配置业务服务器。

在配置文件中，都包含development、development两种配置，分另用于开发和生产环境中。可以pomelo start启动应用时，通过-e参数来指定所要使用的环境。更多命令使用，参见pomelo start --help。



3. 扩充服务器及Router
随着用户量的增加，单台服务器可能无法承受高并发量，这时需要对服务器进行扩充。

多服务器版本的Chat应用在tutorial-multi-server分支上，可以通过以下命令来切换到该分支：

$ git checkout tutorial-multi-server


3.1 配置修改
在Pomelo中，扩充服务器非常简单，只需要修改配置文件即可。

在本例中，在config/servers.json文件中配置如下：

{
 "development":{
    "connector":[
      {"id":"connector-server-1", "host":"127.0.0.1", "port":4050, "clientPort": 3050, "frontend": true},
      {"id":"connector-server-2", "host":"127.0.0.1", "port":4051, "clientPort": 3051, "frontend": true},
      {"id":"connector-server-3", "host":"127.0.0.1", "port":4052, "clientPort": 3052, "frontend": true}
    ],
    "chat":[
      {"id":"chat-server-1", "host":"127.0.0.1", "port":6050},
      {"id":"chat-server-2", "host":"127.0.0.1", "port":6051},
      {"id":"chat-server-3", "host":"127.0.0.1", "port":6052}
    ],
    "gate":[
      {"id": "gate-server-1", "host": "127.0.0.1", "clientPort": 3014, "frontend": true}
    ]
  },
  "production":{
    "connector":[
      {"id":"connector-server-1", "host":"127.0.0.1", "port":4050, "clientPort": 3050, "frontend": true},
      {"id":"connector-server-2", "host":"127.0.0.1", "port":4051, "clientPort": 3051, "frontend": true},
      {"id":"connector-server-3", "host":"127.0.0.1", "port":4052, "clientPort": 3052, "frontend": true}
    ],
    "chat":[
      {"id":"chat-server-1", "host":"127.0.0.1", "port":6050},
      {"id":"chat-server-2", "host":"127.0.0.1", "port":6051},
      {"id":"chat-server-3", "host":"127.0.0.1", "port":6052}
    ],
    "gate":[
      {"id": "gate-server-1", "host": "127.0.0.1", "clientPort": 3014, "frontend": true}
    ]
  }
}


3.2 router配置
与前面相比，我们将connector和chat扩展成了多台服务器，因此就需要考虑用户请求时的服务器分配问题。

gate服务器负责服务器的分配，由于之前只有一台connector服务器，所以就直接返回了这台服务器信息。但现在扩展成了多台，就需要一个服务器选择的过程。

在这里，我们添加一个dispatch工具函数，它使用用户的uid的crc32校验码与connector服务器的个数取余，从而得到一个connector服务器：

// util/dispatcher.js
module.exports.dispatch = function(key, list) {
  var index = Math.abs(crc.crc32(key)) % list.length;
      return list[index];
};

// gateHandler.js
handler.queryEntry = function(msg, session, next) {
  // ...

  // get all connectors
    var connectors = this.app.getServersByType('connector');

  // ...
  
  var res = dispatcher.dispatch(uid, connectors); // select a connector from all the connectors
  // do something with res
};
当收到客户端请求时，因为有多台chat服务器，需要选择由哪台chat后端服务器来处理请求。配置路由通过application的route调用，在这里我们也使用前面dispatch函数，使用同样的服务器分配策略。示例如下：

// app.js

// chat 服务器路由定义
var chatRoute = function(session, msg, app, cb) {
  var chatServers = app.getServersByType('chat');

  if(!chatServers || chatServers.length === 0) {
    cb(new Error('can not find chat servers.'));
    return;
  }

  var res = dispatcher.dispatch(session.get('rid'), chatServers);

  cb(null, res.id);
};

app.configure('production|development', function() {
  app.route('chat', chatRoute);
});
在上面示例中，chatRoute是路由处理函数，它接受4个参数，并返回一个其选择的后端服务器ID。在4个参数中：

第一个参数session用于路由计算，前端服务器发起路由请求时，会使用session做为计算路由的参数（在实际业务中，session参数是非必要的，也可以使用用户自定义的参数）。
第二个参数msg，包含了当前RPC调用中的用户请求信息，包括：调用的服务器类型、服务器名字、具体的调用方法等。
第三个参数是一个上下文变量，一般使用app
第四个参数是一个回调函数，得到后端服务器ID拍，会通过该函数向客户端返回信息。


4. 添加筛选器（Filter）
在实际应用中，往往需要在逻辑服务器处理请求之前对用户请求做一些“前置处理”；而当请求被处理后，又需要做一“后置处理”。Pomelo 对这些常用情形其进行了抽象，也就是Filter。

在Pomelo中，Filter分为Before Filter和After Filter。在一个请求到达Handler处理之前，可以经过多个Before Filter组成的Filter链进行一些前置处理，如：对请求排队、超时处理。当请求被Handler处理完成后，又可以通过一个After Filter链进行一些善后处理，After Filter中一般只做一些清理处理，而不应该再修改到客户端的响应内容，因为这时，对客户端的响应内容已经发给了客户端。

在本例中，我们可以通过Filter来过滤用户发送的聊天内容。具体的代码在tutorial-abuse-filter分支，使用如下命令切换分支：



$ git checkout tutorial-abuse-filter


4.1 Filter结构
Filter是一个对象，结构如下：

var Filter = function () {
  // ....
};

Filter.prototype.before = function(msg, session, next) {
  // ...
}

Filter.prototype.after = function(err, msg, session, resp, next) {
  // ...
}
如果定义了before就会做为一个Before Filter使用；如果定义了after，就可以做为一个After Filter使用。

Before Filter有两个参数：msg和session：

msg是用户请求内容，其可能是请求原始内容，可能是经过前面filter处理后的内容。
session在端服务器上是BackendSession；而在前端服务器中是FrontendSession。当用户修改时，只在其后的处理过程中有效，而不会对前端Session和原始Session有影响。
在After Filter中，msg和session与Before Filter中的参数相同。其还有以下两个参数：

err表示前面请求中出现的错误信息
resp是对客户端的响应内容
定义Filter后，可以通过application的filter将处理器挂载到相应的逻辑服务器上。



4.2 定义Filter
接下来，我们将过滤用户聊天内容，在本例中，只简单的对fuck进行过滤。

如果下所示，定义一个Before Filter，如果用户会话中有fuck关键字，则将其替换为****，并在Session中增加一个标记；再定义一个After Filter，如果用户说了脏话，则将其名字记录下来：

// abuseFilter.js
module.exports = function() {
  return new Filter();
}

var Filter = function() {
};

Filter.prototype.before = function (msg, session, next) {
  if (msg.content.indexOf('fuck') !== -1) {
    session.__abuse__ = true;
    msg.content = msg.content.replace('fuck', '****');
  }
  next();
};

Filter.prototype.after = function (err, msg, session, resp, next) {
  if (session.__abuse__) {
    var user_info = session.uid.split('*');
    console.log('abuse:' + user_info[0] + " at room " + user_info[1]);
  }
  next(err);
};
定义完Filter后，在app.js中将其挂载到chat服务器上：

// app.js
var abuseFilter = require('./app/servers/chat/filter/abuseFilter');
app.configure('production|development', 'chat', function() {
  app.filter(abuseFilter());
});
接下来，就可运行应用并测试Filter是否已生效。

注意：一个Filter里可以只定义before，也可以只定义after，也可以两者都定义。在application中的调用顺序为：before - handler - after。

另外，Pomelo也内置了几个filter，如：toobusy、timeout等。在以后涉及到了再进行介绍。



5. 路由压缩
对于客户端来说，网络资源往往不太充分。因些，需要考虑增加数据包的有效数据率。

在本示例中，当客户端发起聊天时，会向如下路由发送请求：

pomelo.request('chat.chatHandler.send', 
  // ...
);
这个路由的各部分分别指示了服务器、Handler、及send方法。当用户发送消息时，即使消息很短，也需要发送完整的路由信息，这样就会造成网络资源的浪费。

这时可以使用Pomelo基于字典的路由压缩功能：

对于服务端，Pomelo会扫描所有的Handler信息
对于客户端，用户需要在config/dictionary.json中声明所有客户端使用的路由
通过这种方式，Pomelo会得到服务端和客户端的路由信息，并将路由信息映射为一个整数，从1开始，依次累加。启用压缩后，在客户端与服务端建立连接后，服务端会将整个字典发送给客户端；而在之后的通信中，都会使用所映躺的整数，大大增加了数据的有效率。

注意：Pomelo目前仅hybridconnector（WebSocket）支持路由压缩，sioconnector暂不支持。

在Chat中使用

使用了route压缩的示例在tutorial-dict分支中，可以使用以下命令切换：

$ git checkout tutorial-dict
客户端的路由配置位于config/dictionary.json文件中，文件内容如下：

// dictionary.json
[
  'onChat',
  'onAdd',
  'onLeave'
]
配置映射后，还需要在application的connector配置项中，将useDict设置为true：

app.configure('production|development','connector', function() {
  app.set('connectorConfig', {
    connector: pomelo.connectors.hybridconnector,
    heartbeat: 3,
    useDict: true // enable dict
  });
});

app.configure('production|development','gate', function() {
  app.set('connectorConfig', {
    connector: pomelo.connectors.hybridconnector,
    useDict: true // enable dict
  });
});
经过以上配置，就开启了Pomelo的路由压缩功能。对于已经在dictionary配置的路由，将使用一个对应的整数做为路由；而新增的或未添加到其中的路由还会继续使用未压缩的路由。



6. Protobuf压缩数据
除了可以使用dictionary进行路由压缩外，Pomelo还提供了基于Protobuf的通讯数据压缩。

Protobuf是Goolge提出的一种数据交换格式，在原生Protobuf中，首先需要定义一个.proto文件，然后调用protoc进行编译。这种方式较笨，需要静态编译，且proto修改后需要重新编译。

Pomelo重新实现了Protobuf，利用JavaScript语言的动态性使用应用可以在运行时解析proto文件而不再编译。为了更方便的解析，Pomelo使用JSON格式，其语法格式与原生proto一样。定义好客户端与服务端的通讯信息格式后，将服务端所需要的配置放在config/serverProtos.json文件中，而将客户端所需的配置放在config/clientProtos.json。通信过程中，如果已在配置文件中定义，则会使用二进制格式发送数据；未定义时，仍然使用原始的JSON格式。



在Chat中使用

使用了Protobuf压缩的示例在tutorial-protobuf分支中，可以使用以下命令切换：

$ git checkout tutorial-protobuf
首先，定义客户端和服务端所使用的数据格式：

// clientProtos.json
{
  "chat.chatHandler.send": {
    "required string rid": 1,
    "required string content": 2,
    "required string from": 3,
    "required string target": 4
  },

  "connector.entryHandler.enter": {
    "required string username": 1,
    "required string rid": 2
  },

  "gate.gateHandler.queryEntry": {
    "required string uid": 1
  }
}

// serverProtos.json
{
  "onChat": {
    "required string msg": 1,
    "required string from": 2,
    "required string target": 3
  },

  "onLeave": {
    "required string user": 1
  },

  "onAdd": {
    "required string user": 1
  }
}
定义数据格式后，还需要在application的connector配置项中，将useProtobuf设置为true，以启用protobuf：

app.configure('production|development', 'connector',  function() {
  app.set('connectorConfig', {
    connector: pomelo.connectors.hybridconnector,
    heartbeat: 3,
    useDict: true,
    useProtobuf: true //enable useProtobuf
  });
});

app.configure('production|development', 'gate', function(){
    app.set('connectorConfig', {
            connector : pomelo.connectors.hybridconnector,
            useDict: true,
      useProtobuf: true //enable useProtobuf
        });
});
这样就启用了protobuf数据压缩，在本例中，onAdd、onLeave本身数据量就很小，没必要进行压缩。在实现应用中，我们还是应该根据实际情况进行的选择。

Protobuf参考：

官方文档
Protobuf介绍


7. RPC调用
在多进程应用中，进程间通讯是不可或缺的。Pomelo利用JavaScript的语言特性，实现了对开发者来说非常友好的一个rpc框架。

7.1 增加RPC调用
下面，我们在Chat应用中，实践一个rpc调用。为了简单，仅实现一个时间服务器，当gate服务器接受到用户的查询请求时，gate服务器向时间服务器请求当前的时间，并将其打印。

rpc调用位于tutorial-rpc分支下，可以使用下面命令切换：

$ git checkout tutorial-rpc
首先，定义time服务器，并增加一个Remote：

// timeRemote.js
module.exports.getCurrentTime = function (arg1, arg2, cb) {
  console.log("timeRemote - arg1: " + arg1+ "; " + "arg2: " + arg2);
  var d = new Date();
  var hour = d.getHours();
  var min = d.getMinutes();
  var sec = d.getSeconds();
  cb( hour, min, sec);
};
以上位于servers/time/remote/timeRemote.js文件中，其功能非常简单，不再说明。

当有多个time服务器时，还要进行配置请求路由。在这里我们不再使用Session进行配置，而简单的使用一个随机数：

// app.js
var router = function(routeParam, msg, context, cb) {
  var timeServers = app.getServersByType('time');
  var id = timeServers[routeParam % timeServers.length].id;
  cb(null, id);
}

app.route('time', router);
在config/servers.json中增加time服务器配置：

"time":[
  {"id": "time-server-1", "host":"127.0.0.1", "port" : 7000},
  {"id": "time-server-2", "host":"127.0.0.1", "port" : 7001}
]
这样，就为聊天应用增加了一个时间服务器，时间服务器提供一个远程时间，当gate接收到查询请求时，会向time服务器发一个请求，time服务器会为其提供一个时间



7.2 一些说明
我们在time服务中定义timeRemote.js时，与在chat服务器中定义chatRemote.js中不同。在其中，我们使用了module.exports导出，两种方式如下：

// chatRemote.js
module.exports = function(app) {
    return new ChatRemote(app);
};

// timeRemote.js
module.exports.getCurrentTime(arg1, arg2, cb) {
  // ...
};
这两种方式都是可以的，Pomelo在加载remote时，如果发现加载到的不是一个对象而是一个函数，那么会认为其是一个工厂方法，并使用一个全局的上下文（一般是唯一的一个Application实例）作为参数，调用这个函数，再使用其结果。chatRemote使用的是这种方式，最终加载到的实际上是一个ChatRemote对象；而timeRemote，require调用返回的就是一个对象，这个对象有一个方法getCurrentTime，这时就不再需要进行一次函数调用了。

对于以上两种方式，当需要application实例时，可以使用第一种方式；而不需要application实例时，直接使用module.exports导出即可。不仅Remote，handler也一样，也同样可以使用这两种方式中的一种。



8. 组件的使用
Pomelo的核心是由一系列松耦合的组件（component）组成。我们也可以实现自己的组件，以完成一些定制功能。

对于Chat应用，我们尝试给其增加一个组件，其目的是介绍组件的使用及组件生命周期的管理。这个组件会在Master服务器上加载运行，并每隔一段时间在控制台打印一个HelloWorld，具体的时间间隔由opts配置。

组件功能位于tutorial-component分支下，可以使用下面命令切换：

$ git checkout tutorial-component
在app目录下，增加components/HelloWorld.js文件，内容如下：

// components/HelloWorld.js
module.exports = function(app, opts) {
  return new HelloWorld(app, opts);
};

var DEFAULT_INTERVAL = 3000;

var HelloWorld = function(app, opts) {
  this.app = app;
  this.interval = opts.interval || DEFAULT_INTERVAL;
  this.timerId = null;
};

HelloWorld.name = '__HelloWorld__';

HelloWorld.prototype.start = function(cb) {
  console.log('Hello World Start');
  var self = this;
  this.timerId = setInterval(function() {
    console.log(self.app.getServerId() + ": Hello World!");
    }, this.interval);
  process.nextTick(cb);
}

HelloWorld.prototype.afterStart = function (cb) {
  console.log('Hello World afterStart');
  process.nextTick(cb);
}

HelloWorld.prototype.stop = function(force, cb) {
  console.log('Hello World stop');
  clearInterval(this.timerId);
  process.nextTick(cb);
}
如上所示，每个组件都包含start、afterStart、stop这些钩子函数，Pomelo会通过这些函数管理组件生命周期。

Pomelo会能调用组件的start函数来加载组件，然后会调用每一个afterStart，afterStart调用时组件已完成加载，在afterStart中，一些全局性的工作可以在这里完成。stop用于程序结束时对组件进行清理。

接下来，在app.js中加载我们所定义的组件：

// app.js
var helloWorld = require('./app/components/HelloWorld');

app.configure('production|development', 'master', function() {
  app.load(helloWorld, {interval: 5000});
});


组件的一些说明

在本例中，我们使用一个工厂函数进行导出。当应用加载组件时，如果是工厂函数就会将其自身做为上下文参数传入；同样的，组件也可以使用module.exports方式进行导出。具体使用哪种方式，请按自己的需要选择
Pomelo总是先执行start，执行完后才会依次执行所有的afterStart。在定义方法时，应考虑调用顺序。
Pomelo应用的运行过程可以认为是管理其组件生命周期的过程，Pomelo的所有功能都是通过其内建组件来实现的。用户可以轻松地定制自己的组件t，然后将其加载到应用中，这样就可以很轻松地实现了对Pomelo的扩展


9. Admin模块
Pomelo应用一般会由一个服务器集群来支持，所以对集群中服务器的管理就尤为重要，我们可能会需要监控服务器的进程状态、系统状态、关闭某个服务器等。

9.1 关于Admin模块
Pomelo的监控体系由三部分构成：master、monitor、client。其中master组件由master服务器加载，monitor组件由应用服务器加载，这两部分共同完成服务器的管理和监控。其中：

master服务器负责收集所有服务器的信息，下发对服务器的操作指令
monitor负责上报服务器状态，并对master的命令进行响应
client是第三方监控客户端，它会注册到master服务器，并通过向master发送请求获得服务器群信息，或向master发送指令实现对集群的管理。
由于对于具体的应用来说，其需要监控和管理的信息也是各不相同的，因此，Pomelo并没有实现固定的监控模块，而是提供了一个可插拔的监控框架机制，用户只需要定义一个监控模块所需要的回调方法，并完成相应的配置即可。

Admin模块由一组相关的供不同主体调用的回调函数构成。一般包括四个回调方法：monitorHandler、masterHandler、clientHandler、start。其中：

monitorHandler是monitor收到master的请求或者通知时由monitor回调
masterHandler是master收到monitor请求或者通知时的回调
clientHandler是master收到client请求或通知时的回调
startAdmin模块加载完成后，用来执行一些初始化监控时的回调


9.2 在Chat中使用Admin模块
接下来，我们给聊天应用增加一个监控模块，让monitor每隔5秒钟向master上报一下自己的当前时间。上报时间可能没有什么实际意义，仅为示例Admin模块的使用。

Admin模块的使用位于tutorial-admin-module分支下，可以使用下面命令切换：

$ git checkout tutorial-admin-module
在app目录下创建modules/timeReport.js文件，并在其中定义monitorHandler、masterHandler、clientHandler三个方法：

module.exports = function(opts) {
  return new Module(opts);
}

var moduleId = "timeReport";
module.exports.moduleId = moduleId;

var Module = function(opts) {
  this.app = opts.app;
  this.type = opts.type || 'pull';
 this.interval = opts.interval || 5;
}

Module.prototype.monitorHandler = function(agent, msg, cb) {
  console.log(this.app.getServerId() + '  ' + msg);
  var serverId = agent.id;
  var time = new Date().toString();

  agent.notify(moduleId, {serverId: serverId, time: time});
};

Module.prototype.masterHandler = function(agent, msg) {
  if (!msg) {
    var testMsg = 'testMsg';
    agent.notifyAll(moduleId, testMsg);
    return;
  }

  console.log(msg);
  var timeData = agent.get(moduleId);
  if (!timeData) {
    timeData = {};
    agent.set(moduleId, timeData);
  }
  timeData[msg.serverId] = msg.time;
};

Module.prototype.clientHandler = function(agent, msg, cb) {
  cb(null, agent.get(moduleId));
}
在上面示例中，我们并没有定义start回调，因为在这里用不到。

在定义完上面的Admin后，还要要将其注册到应用中，在app.js中增加如下代码：

var timeReport = require('./app/modules/timeReport');
app.registerAdmin(timeReport, {app: app});
其中，app.registerAdmin可以接受两个或三个参数，如果是三个参数，第一个必须是以字符串指定的moduleId；如果是两个参数，会使用工厂函数的moduleId属性做为模块ID。最后一个参数是配置选项，可以通过type参数配置是使用pull的方式还是push的方式来获取监控数据。在本例中，并没有type和interval，默认会使用pull模式且每5秒获取一次数据。



9.3 Admin模块说明
在导出一个模块module时，一般需要指定一个moduleId（在本例中，我们指定的moduleId是timeReport）。如果这里不指定moduleId的话，在调用Application.registerAdmin的时再指定也可以。
在加载模块时，调用参数中type和interval两个参数很重要：
其中type用于指定数据获取的方式，可选值有pull和push。pull表示由master定时向monitor发送请求，再由monitor返回数据；而push表示由monitor定时上报数据。
interval表示信息上报的时间周期
masterHandler一个要注意的地方，在使用pull的方式时，masterHandler会在两种情况下被回调，一是每隔固定时间产生一次的数据拉取事件；一种是monitor向master上报信息时。这两种情况，可以通过msg参数区分：
如果是定时器产生的周期性的拉数据事件导致的回调，此时msg参数是undefined，这时只是简单的调用notifyAll向请求返回数据。
而monitor在收到master通知上报信息时，msg将是一个对象
在实际应用中，也会通过msg来区分两种情况的方式。同样的，在使用push方式时，monitor也会遇到两种情况：一是定时器的周期事件、另一种是monitor给其发了通知或请求。类似的，也可以在monitorHandler中通过msg判断。
在monitorHandler的实现中，当收到收到master通知时，会取出master传来的参数（本例为testMsg）。然后通过对参数进行分析，执行相应的逻辑（本例中为获取自己当前的时间）。
clientHandler是当有第三方监控客户端给master发请求时，由master进行回调的。在本例中未介绍，在以后会有相应的介绍文章。