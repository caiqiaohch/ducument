简单介绍
pomelo是网易12年底出品的一个基于node.js的游戏服务器框架，其设计初衷是游戏服务器， 不过在设计、开发完成后发现pomelo是个通用的分布式实时应用开发框架。

1.1. 一些资源地址
github：https://github.com/NetEase/pomelo
官网：http://pomelo.netease.com/
api：http://pomelo.netease.com/api.html
中文wiki主页：https://github.com/NetEase/pomelo/wiki/Home-in-Chinese
官方论坛（Pomelo Club）：http://nodejs.netease.com/
IDE调试：使用 WebStorm IDE 调试 Pomelo 应用程序

1.2. 关于socket.io和websocket
websocket是HTML5提供的一种新协议，PC上兼容性还好，安卓上要求4.4以上：
socket.io则是为了解决websocket兼容性诞生的，它在不支持websocket的浏览器上通过使用xhr-polling, jsonp-polling, flashsocket，htmlfile等形式来替代，当然这种替代会有各种各样的缺点。

socket.io有自己的协议，前后端都必须使用socket.io自己提供的方法。

1.3. web通信的几种实现方式
这里再简单介绍一下web通信的几种实现方式，按照浏览器的发展历程或者兼容性从前到后介绍。

1.3.1. 短轮询
这几乎是所有人最容易想到的实现服务器推送的方法，就是浏览器定时主动ajax请求服务器，服务器如果有新消息就拿过来。这种方法缺点显而易见，既大量占用前后端资源，消息的推送又不及时，优点是实现简单，几乎没有兼容性可担心的。

1.3.2. 长轮询
长轮询与短轮询的区别在于，如果服务器没有新消息需要推送，那么并不立即响应，而是来一个循环一直在等待，等到有新消息了再response，浏览器接收到消息后作出相应处理，然后再次发出相同请求，如此反复。相比短轮询，这种方式跟服务器的连接大大减少了，但是也还是需要频繁的连接。

1.3.3. 长连接
一个ajax请求发出去，一直不断开，服务器在不间断的response，浏览器也在不停的接收，优点是实时、连接次数少，但是占用服务器资源，有一定的兼容性风险，但是目前移动设备上一般都支持，也就是安卓webview支持的方式。

1.3.4. websocket
全新的全双工通讯协议，完全没有http的请求响应概念，连接一旦建立就一直保持，浏览器与服务器完全平等可以互相发送数据，服务端也不需要长时间hold住那个连接，所以对服务器的资源占用也很小。

1.4. pomelo支持的底层协议
官网介绍说，基本上每种平台都提供了基于socket.io和使用socket/websocket的开发库版本，为了更好的兼容性，我们统一使用基于socket.io版本的。

所以需要在app.js中指定connector为pomelo.connectors.sioconnector，如果要使用websocket，则使用pomelo.connectors.hybridconnector。

另外顺道介绍一下transports，指的是通过何种方式实现前后端通信，默认不指定的话会根据浏览器的兼容性自动选择，比如支持websocket就用websocket，不支持再尝试用xhr轮询，再不支持的话再尝试其它。一般不需要指定，如果需要特别测试某种方式则可以特别指定。

    app.set('connectorConfig',
    {
        /* socket.io 连接模式 */
        connector: pomelo.connectors.sioconnector,
        /* websocket 连接模式 */
        // connector: pomelo.connectors.hybridconnector,
        // websocket, htmlfile, xhr-polling, jsonp-polling, flashsocket
        // transports : ['xhr-polling'],
        heartbeat : 3,
        useDict : true,
        useProtobuf : true
    });
pomelo安装
2.1. 写在安装之前
无论是Windows还是Linux，安装都需要C++和Python环境，Windows下可能需要安装Visual Studio，如果准备工作不做充分的话，安装失败的几率还是蛮高的，如果偷懒不愿意安装，可以直接拿我这边准备好的windows和Linux的node_modules：



安装完后可以直接丢到npm的全局node_modules下，也可以放在项目的node_modules下。

这里以Linux系统为例介绍一下安装过程，这里安装的是v1.2.2版。

2.2. 准备工作
node
python(2.5 < version < 3.0)
c++编译器（如gcc）
以上3个条件，除了node之外，Linux系统上一般都会预装。

先来检查各个软件的版本：

# node -v （4.2.4）
# python （2.6.6）
# gcc -v （4.4.7）
2.3. 开始安装
安装执行命令（我这里懒得全局安装）：

npm install pomelo
发现报错如下：

#error This version of node/NAN/v8 requires a C++11 compiler
搜索一下发现：由于node4.0升级了v8引擎，编译时需要gcc4.8以上版本，Centos6自带的gcc为gcc-4.4.7, 不支持编译所需的c++11标准，所以只好升级gcc。

2.4. centos6.5 安装 gcc4.8
2.4.1. 安装devtoolset
自己安装编译很麻烦，直接使用yum安装更简单。这里使用devtoolset来安装gcc，相关版本对应如下：

devtoolset-1是gcc 4.7
devtoolset-2是gcc 4.8
devtoolset-3是gcc 4.9
命令：

# cd /etc/yum.repos.d（定位到yum目录）
# wget http://people.centos.org/tru/devtools-2/devtools-2.repo（下载repository）
# yum --enablerepo=testing-devtools-2-centos-6 install devtoolset-2-gcc devtoolset-2-gcc-c++（安装gcc）
img

如果执行完报错，提示找不到相关的 GPG key，只要根据提示安装相应的 GPG key 即可（这里注意，网上找的key有的可能已经失效了，可能等到你看到我这篇文章的时候下面这个key也失效了，到时候自己再去找一个可用的即可）：

rpm --import http://ftp.mirrorservice.org/sites/ftp.scientificlinux.org/linux/scientific/51/i386/RPM-GPG-KEYs/RPM-GPG-KEY-cern
img

如果没报错，再重复上面的yum --enablerepo...命令再次安装即可，一般到这里就没啥问题了：

img

中间会提示你是否下载，输入y即可：

img

下载成功后bin目录在/opt/rh/devtoolset-2/root/usr/bin：

img

2.4.2. 配置环境变量：
#set gcc environment by lxa 20160215
export GCC_HOME=/opt/rh/devtoolset-2/root/usr/bin
export CC=$GCC_HOME/gcc
export CPP=$GCC_HOME/cpp
export CXX=$GCC_HOME/c++
PATH=$PATH:$GCC_HOME
这时运行gcc -v仍旧显示 4.4.7，应该是旧的path优先级更高，但这样也不影响node-gyp编译，所以没理会它。

2.4.3. 补充：yum的临时目录
临时目录放在/var/cache/yum/下，如果磁盘紧张，安装成功后即可把整个文件夹都删掉。

2.5. 回头再次安装
安装完gcc后再执行npm install pomelo一般就没问题了（如果需要全局安装的话加上-g参数），测试是否安装成功可以下载官方的聊天例子来试试。

另外最好再为pomelo配置环境变量，方便后续以后可以随意使用pomelo命令行工具：

假设pomelo放在：/home/node/node-v4.2.4/lib/node_modules/pomelo

PATH=$PATH:/home/node/node-v4.2.4/lib/node_modules/pomelo/bin
后台介绍
3.1. 目录结构
一个完整的后台项目目录结构如下：



其中app.js是入口，app/server下的gate、connector、chat分别代表3中类型的服务器，这些服务器都必须和config/servers.js里面的配置一一对应

3.2. 术语解释
有一些专门的术语，官方的wiki已经介绍的很详细，这里不赘述，请戳这里：

术语解释

3.3. 最重要的2个配置文件
这些文件全都位于config目录下。

3.3.1. servers.js
每一种类型的服务器至少要有一个。development和production分别表示开发环境下和现网环境下使用的配置。

{
    "development":
    {
        "connector":
        [
            {"id":"connector-server-1", "host":"172.16.4.97", "port":4050, "clientPort": 3050, "frontend": true},
            {"id":"connector-server-2", "host":"172.16.4.97", "port":4051, "clientPort": 3051, "frontend": true},
            {"id":"connector-server-3", "host":"172.16.4.97", "port":4052, "clientPort": 3052, "frontend": true}
        ],
        "chat":
        [
            {"id":"chat-server-1", "host":"172.16.4.97", "port":6050},
            {"id":"chat-server-2", "host":"172.16.4.97", "port":6051},
            {"id":"chat-server-3", "host":"172.16.4.97", "port":6052}
        ],
        "gate":
        [
            {"id": "gate-server-1", "host": "172.16.4.97", "clientPort": 3014, "frontend": true}
        ]
    },
    "production":
    {
        "connector":
        [
            {"id":"connector-server-1", "host":"11.liuxianan.cn", "port":4050, "clientPort": 3050, "frontend": true},
            {"id":"connector-server-2", "host":"61.liuxianan.cn", "port":4051, "clientPort": 3051, "frontend": true}
        ],
        "chat":
        [
            {"id":"chat-server-1", "host":"11.liuxianan.cn", "port":6050},
            {"id":"chat-server-2", "host":"61.liuxianan.cn", "port":6051}
        ],
        "gate":
        [
            {"id": "gate-server-1", "host": "11.liuxianan.cn", "clientPort": 3014, "frontend": true}
        ]
    }
}
3.3.2. master.js
master指的是你要在哪台服务器来启动所有其他集群服务器，也就是主服务器。

{
    "development":
    {
        "id": "master-server-1",
        "host": "172.16.4.97",
        "port": 3005
    },
    "production":
    {
        "id": "master-server-1",
        "host": "11.liuxianan.cn",
        "port": 3005
    }
}
3.4. 启动与停止
最简单的，开发的时候直接node app.js就可以启动测试了，一般开发时不会配置很多个服务器，顶多就是在localhost多配置几个端口来模拟server，分布式部署时需要使用pomelo start来启动。

完整语法如下：

pomelo start [-e development | -e production] [--daemon]
默认启动的是development模式，如果要启动正式环境，需要额外加一个production参数，--daemon指的是后台运行，如果没有这个参数，断开SSH连接时项目也会自动停止，如果想要它持久的在后台运行，必须加这个参数，正式环境下一般启动命令如下：

pomelo start -e production --daemon
停止使用pomelo stop命令，如果是使用node app.js来启动的，直接Ctrl+C或者关闭窗口即可。

3.5. 简单介绍几个东西
3.5.1. 大致流程
后台只提供gate的host和port给前端，前端通过gate.gateHandler.queryEntry来从所有的connectors中获取合适的connector（比如说根据权重，或者随机），然后再主动断开gate去连接connector，后面所有通信都是和connector打交道，connector收到数据后再发给chat服务器来处理。

3.5.2. 自己定义的几个变量解释
uuid 每一个连接都会随机产生一个唯一的uuid，以此保证连接的唯一性，pomelo中是叫uid，由于uid我这里是把它当成userid，所以要注意区分。
uid 就是userid，这个由客户端主动传给后台，类似QQ号和微信号，正常情况下一个uid对应一个uuid，当然如果你的业务逻辑允许同一个账号多地登录，那么一个uid可能对应多个uuid
rid 就是房间号，类似QQ的群号
rname 房间名称
sid 就是serverID，表示当前用户连接的是哪个connector服务器，私聊时必须知道用户的sid
3.5.3. channel
一个channel就是类似一个房间的概念，channel通过如下获取：

var channel = app.get('channelService').getChannel('channelName', true);
channelName可以当成是房间号（类似QQ的群号），全局唯一，后面的true表示不存在时创建这个房间。

3.5.4. 推送消息
channel.pushMessage(route, message); // 向某个群广播消息
app.channelService.pushMessageByUids(route, message, [{uid: uuid, sid: sid}]); // 私聊
3.5.5. 监听消息
客户端所有消息发送到chat.chatHandler.request（route），代码如下：

handler.request = function(request, session, next)
{
    Main.getInstance().handleRequest(request, session, next);
};
handleRequest代码如下，所以要监听某个消息，比如客户端emit过来的sendMessage，只需要定义main.onSendMessage(data, session, next)即可：

/**
 * 所有的客户端请求都会发送到这里
 * @param request {cmd, data}
 * @param session
 * @param next
 */
main.handleRequest = function(request, session, next)
{
    console.log('enter main.handleRequest method!');
    // 把类似“sendMessage”转换成“onSendMessage”
    var cmd = (request.cmd || '').replace(/^(\w)/g, function(m, $1)
    {
        return 'on' + $1.toUpperCase();
    });
    var fn = this[cmd];
    if(fn) fn.call(this, request.data, session, next);
    else console.error('未定义方法：'+cmd);
};
有了这些基本上就满足所有情况了，以后有什么新的需求只需要在这个基础上增加监听方法即可。

3.6. 常见错误处理
3.6.1. 端口绑定失败
在线网上面，一般习惯先普通启动，因为这样可以直接查看日志，感觉没问题了，再直接Ctrl+C停止，再来加上--daemon参数来后台启动，但是发现启动不了，查看日志提示如下Error: listen EADDRINUSE错误，这是因为Ctrl+C只是杀死了主进程，其它还有好几个进程没有结束，这才导致启动时端口冲突，此时先pomelo stop正常停止，然后pkill node来杀死所有node进程（需要确保服务器上node没有开启其它服务），再然后后台启动应该就没问题了。

前端
这里只介绍socket.io版的。

4.1. 从最简单聊天例子开始
所有引用的JS如下：



引用顺序如下：

<script src="js/jquery.min.js"></script>
<script src="js/socket.io-v0.9.6.js"></script>
<script src="js/pomelo-client.js"></script>
<script src="connector-pomelo.js"></script>
其中：

jquery.min.js 就不说了
socket.io最好就用这个版本，因为pomelo的socket.io客户端项目已经2年没有更新了，用最新版的socket.io.js会有一大堆报错，既然作者懒得更新，我们也懒得去管其中细节了
pomelo-client.js 是pomelo在socket.io基础上简单封装的一些方法
connector-pomelo.js 是我这边在pomelo-client.js基础上再次简单封装，封装的目的是统一pomelo和socket.io，规避二者的差异性，所以如果后台用socket.io的话，还有另外一个js：connector-socketio.js
使用封装之后的代码最简单的连接服务器代码示例如下：

var connector = new Connector('localhost', 3014);
connector.on('connect', function()
{
    connector.login('你的userid', function()
    {
        console.log('登录成功！');
    });
});
一些事件监听：

connector.on('disconnect', function(data){});
connector.on('onUserSendMessage', function(data)
{
    if(data.from === connector.uid) return; // 屏蔽自己发来的消息
    console.log('收到消息：', data.message);
});
connector.on('onUserLogin', function(data){}); // 用户登录时触发
connector.on('onUserLogout', function(data){}); // 用户退出时触发
connector.on('onUserJoinRoom', function(data){}); // 用户进入房间时触发
connector.on('onUserLeaveRoom', function(data){}); // 用户离开房间时触发
其它一些封装好可以直接调用的方法：

connector.login(uid, callback); // 登录
connector.sendMessage(target, type, content, callback); // 发送消息
connector.createRoom(rname, callback); // 创建房间
connector.joinRoom(rid, callback); // 加入房间
connector.leaveRoom(rid, callback); // 退出房间
以上所有方法都是建立在connector-pomelo.js基础上，一般情况下都可以直接使用这些，当然也非强制，下面就来简单介绍一下封装的部分。

4.2. 客户端细节简单介绍
4.2.1. pomelo提供的一些方法
无论是socket.io的还是websocket的，都提供了统一的API。

4.2.1.1. pomelo.init(params, cb)

这是往往是客户端的第一次调用，params中应该指出要连接的服务器的ip和端口号，cb会在连接成功后进行回调;

4.2.1.2. pomelo.request(route, msg, cb)

请求服务，route为服务端的路由，类似connector.connectorHandler.enter, msg为请求的内容，cb会响应回来后的回调;

4.2.1.3. pomelo.notify(route, msg)

发送notify，不需要服务器回响应的，因此没有对响应的回调，其他参数含义同request;

4.2.1.4. pomelo.on(route, cb)

这个是从EventEmmiter继承过来的方法，用来对服务端的推送作出响应的。route会用户自定义的，格式一般为”onXXX”;

4.2.1.5. pomelo.disconnect()

这个是pomelo主动断开连接的方法。

4.2.2. 连接服务器
大致代码如下：

queryEntry(uuid, function(host, port)
{
    pomelo.init({host: host, port: port}, function()
    {
        console.log('第二次初始化pomelo成功！');
        pomelo.request('connector.connectorHandler.enter', {uuid: uuid}, function()
        {
            console.log('enter success', arguments);
        });
    });
});
function getRandomUuid()
{
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c)
    {
        var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
        return v.toString(16);
    });
}
function queryEntry(uuid, callback)
{
    pomelo.init({host: data.host, port: data.port}, function()
    {
        console.log('第一次初始化pomelo成功！');
        // 查询连接实例
        pomelo.request('gate.gateHandler.queryEntry', {uuid: uuid}, function(resp)
        {
            console.log('获取连接实例：'+resp.host+':'+resp.port);
            pomelo.disconnect(); // 主动断开连接
            if(resp.error)
            {
                console.log(resp.text);
                return;
            }
            callback(resp.host, resp.port);
        });
    });
}
4.2.3. 2个最重要的方法
所有的发送消息都是通过connector.emit()，所有的监听消息都是通过connector.on()，内部实现如下：

/**
 * 发送数据，所有客户端发送数据都是使用本方法
 * @param event 事件名称
 * @param data 数据内容
 * @param callback 回调函数
 */
connector.emit = function(event, data, callback)
{
    pomelo.request('chat.chatHandler.request', {cmd: event, data: data}, function(data)
    {
        console.log(event+'Response', data);
        if(callback) callback(data);
    });
};
 
/**
 * 绑定事件
 * @param event 事件名称
 * @param fn 事件方法
 */
connector.on = function(event, fn)
{
    // pomelo的connector事件比较特殊，需要特殊处理
    if(event === 'connect')
    {
        connector.onPomeloConnect = fn;
        return;
    }
    pomelo.on(event, function(data)
    {
        console.log(event, data);
        if(fn) fn(data);
    });
};
有了这2个方法，基本上什么都能做了。

chat例子中标准定义
这只是一个内部规范，早早的定义好避免后期前后台频繁改动，这只是我这边暂时用到的，可以随意扩展和修改。

5.1. 全局错误
{error: true, code: 500(或者其它，一般不定义), text: '错误描述'}
5.2. user对象
{uid,uuid,sid,nickname,avatar,sex,等等}
5.3. room对象
{rid,rname,creator,creatTime,等}
所有的群发消息理论上本人不应该收到，但是pomelo不好处理，所以如果收到了，只好前端自己做处理排除掉

5.4. 所有emit
login:
    request: {uid, pwd, avatar}, callback: {uid, onlineUsers}，登录失败返回error信息
sendMessage:
    request: {target, message:{type, content}}, callback: {error, code, text}，如果没错就code=200, target=*表示所有用户，@uid表示私聊，否则表示rid
createRoom:
    request:{rname}, callback: {uid, room: room}
joinRoom:
    request:{rid, source:'比如扫描二维码还是直接输入ID查找等'}, callback: {uid, room}，如果错误返回error信息
leaveRoom:
    request:{rid}， callback:{uid, room: room}
5.5. 所有事件
onConnect({})
onDisconnect({})
onUserLogin({uid, onlineUsers})
onUserLogout({uid, onlineUsers})
onUserSendMessage({from: uid, message: message, time: time, rid: rid})，如果rid未定义表示私聊，否则就是群聊
onSystemMessage{type, message, time}
onUserJoinRoom({uid, room})
onUserLeaveRoom({uid, room})
其它一些补充
6.1. 查看版本
查看当前pomolo版本：

#pomelo -V
1.2.2
6.2. 还没完成或者有问题的
性能测试
日志
简单的后台，能够实时监控当前用户和各种消息
部分消息推送时携带数据过多，需要精简
pomelo分布式部署
参考：https://github.com/NetEase/pomelo/wiki/Pomelo的分布式部署方法

分布式部署的关键主要就是master服务器到其它服务器的密码验证干掉，另外就是master.json和servers.json里面服务器的配置。

7.1. 准备条件：
必须为同类操作系统（建议版本也相同，我用的是centos6.3）
用户名必须完全相同（我用的是root）
node安装路径和版本必须完全相同（我的是v4.2.4，安装在/home/node/node-v4.2.4）
项目目录必须完全相同（我的放在/home/pomelo/pomelo-server）
在所有参与分布式部署的机器上配置ssh登录选项. 方法为: 在”~/.ssh”目录（也就是当前登录用户名下的那个.ssh目录）下创建一个名为”config”的文件(本文所示例的目录为”/root/.ssh”)，目的是使得各个机器之间可以进行顺畅的ssh登录，文件内容如下:

  Host *
  HashKnownHosts no
  CheckHostIP no
  StrictHostKeyChecking no
另外还要记得配置主服务器到其它服务器之间能够ssh免登录，当然你不配置也行，不配置的后果就是每次启动时都要一个个的输入其它服务器的密码，关于ssh免登录的配置后面单独介绍。

本例中只简单的用了2个服务器做测试，172.16.4.247做主，172.16.1.116做从。

首先，修改master.json，将其中的host的地址修改为master所在机器的IP地址（即将要在哪台机器上使用pomelo start来启动服务器集群）， 注意不要填写”127.0.0.1”或者”localhost”， 具体的配置如下所示：

  {
      "development":{
          "id":"master-server-1",
          "host":"172.16.4.247",
          "port":3005
      },
      "production":{
          "id":"master-server-1",
          "host":"172.16.4.247",
          "port":3005
      }
  }
然后修改servers.json，我这里由于服务器不够就只好用多个端口来模拟了：

{
    "development":{
        "connector":[
             {"id":"connector-server-1", "host":"172.16.4.247", "port":4050, "clientPort": 3050, "frontend": true},
             {"id":"connector-server-2", "host":"172.16.1.116", "port":4051, "clientPort": 3051, "frontend": true}
         ],
        "chat":[
             {"id":"chat-server-1", "host":"172.16.4.247", "port":6050},
             {"id":"chat-server-2", "host":"172.16.1.116", "port":6051}
        ],
        "gate":[
           {"id": "gate-server-1", "host": "172.16.4.247", "clientPort": 3014, "frontend": true}
        ]
    },
    "production":{
           "connector":[
             {"id":"connector-server-1", "host":"172.16.4.247", "port":4050, "clientPort": 3050, "frontend": true},
             {"id":"connector-server-2", "host":"172.16.1.116", "port":4051, "clientPort": 3051, "frontend": true}
         ],
        "chat":[
             {"id":"chat-server-1", "host":"172.16.4.247", "port":6050},
             {"id":"chat-server-2", "host":"172.16.1.116", "port":6051}
        ],
        "gate":[
           {"id": "gate-server-1", "host": "172.16.4.247", "clientPort": 3014, "frontend": true}
        ]
  }
}
以上文件的修改最好在本地修改好后再全部同步到所有服务器，注意无论是哪个服务器都把完整的servers配置复制上去，启动时只需要在master所在服务器的/home/pomelo/pomelo-server执行pomelo start即可（前提是你已经为pomelo配置了环境变量），无需单独到没一个服务器去单独启动，如果你的ssh免登录没有正确配置，那么启动的过程中会一次次的要求你输入其它服务器的密码。

另外，我在部署的时候，pomelo没有全局安装，然后又嫌把这个放项目下太大，所以最后又把它复制到/home/node/node-v4.2.4/lib/node_modules下，单机启动时没问题，分布式部署时就提示Cannot find module "pomelo"，所以此时的解决办法就是，要么全局安装pomelo，要么把它复制到项目下的node_modules文件夹下。

今天部署时还碰到一个问题，启动成功后还是一直访问不了，后来发现是防火墙的问题，把用到的端口加入白名单即可，或者偷懒直接临时关闭防火墙做测试。

另外，停止时不能要单机那样直接Ctrl+C取消了，必须pomelo stop来停止。

7.2. ssh 免登录配置
假设现有2台linux服务器A(172.16.4.247)和B(172.16.1.116)，要求能够在A上登录到B（也就是pomelo的主服务器登录其他集群服务器）.

服务器A上面执行如下命令：

[root@localhost ~]# ssh-keygen -t rsa -P ''（-P表示密码，-P '' 就表示空密码，不用-P参数需要三次回车，用-P只需一次回车）
[root@localhost ~]# scp .ssh/id_rsa.pub root@172.16.1.116:/root/id_rsa.pub（使用scp复制）
第一个命令会在/root下生成一个.ssh文件夹（注意当前登录用户名是什么就生成在哪里），.ssh下有id_rsa（私钥）和id_rsa.pub（公钥） 这2个文件，中间需要回车一次，第二个命令是使用scp复制公钥到服务器B上面，中间会要求输入B的密码。

img

然后登录B服务器执行如下命令：

[root@localhost ~]# mkdir .ssh（在用户目录下新建.ssh文件夹）
[root@localhost ~]# cat id_rsa.pub >> .ssh/authorized_keys（将公钥文件内容写入authorized_keys中）
[root@localhost ~]# chmod 755 /root（修改用户目录权限，这个很重要）
[root@localhost ~]# chmod 700 .ssh（修改.ssh文件夹权限，这个很重要）
[root@localhost ~]# chmod 600 .ssh/authorized_keys（修改key文件权限，这个很重要）
[root@localhost ~]# rm -rf id_rsa.pub（删除没用的临时文件）
然后再次切换到服务器A执行：

[root@localhost ~]# ssh 172.16.1.116
Last login: Wed Feb 17 09:42:18 2016 from 172.16.4.97
不出意外的话就设置成功了。

几个关键点：

几个目录和文件的权限不能太高，太高反而失败
用户目录权限一定要记得改成755（也就是rwxr-xr-x），之前默认是777导致一直不成功（本例中是/root文件夹）
.ssh文件夹权限必须是700（也就是rwx———）
.ssh/authorized_keys权限必须是600（也就是rw———-）
补充：

若有多个主机要访问，都是使用>>添加到authorized_keys同一个文件中
本例中使用的是root账户，如果是其它账户，请根据实际用户目录做相应变动
A将公钥发给B，不是说让B来访问A，而是A就可以随意访问B了
如果ssh登录不需要输入密码就表示配置成功了，否则就是配置失败
以后如果发现哪天突然登录需要密码了，可能是目录权限被修改了，再次修改回去即可
如果还不成功，确认本机sshd的配置文件：

[root@localhost ~]# vi /etc/ssh/sshd_config
（找到以下内容，并去掉注释符”#“）
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile    .ssh/authorized_keys
[root@localhost ~]# service sshd restart（重启sshd服务）
img

完了之后再次尝试登录看成功否。

转自 http://blog.haoji.me/pomelo.html?from=xa