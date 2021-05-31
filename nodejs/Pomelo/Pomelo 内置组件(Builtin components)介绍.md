Pomelo 内置组件(Builtin components)介绍
Pomelo 的应用程序执行过程，就是对其相应组件生命周期的管理，而实际上所有的逻辑功能均由 Pomelo 组件提供。Pomelo 框架内建并提供了十多个组件，这些组件用于不同的负载服务器，并提供了各种功能。本篇将以这些组件所提供的功能为主，对这些组件进行介绍。

Master
Monitor
Connector
Session
Connection
Server
PushScheduler
Proxy
Remote
Dictionary
Protobuf
Channel
BackendSession
1. Master
Master组件仅由主服务器加载，其主要功能包括：启动所有应用服务器、管理和监控所有应用服务器、接收管理客户的请求并进行响应。

在Master的start方法中，会根据用户提供的服务器配置信息，启动具体的应用服务器。

当Master的start方法调用完成后，它会在所配置的端口上启动用户连接监听。还会注册、收集应用服务上报的监控信息，向应用服务器发送控制命令，及处理管理客户的请求。管理客户端（如，Pomelo-cli）可能会发一些管理请求，包括查看某个服务器的进程状态、增加或停用服务器等。这时，管理客户端会发送请求命令，而Master会根据请求参数做出处理，并广播通知已启动的服务器。

配置选项：无



2. Monitor
Monitor会被所有服务器加载，包括主服务器。其主要功能是，建立一个与主服务器的连接，并对整个应用服务器集群进行管理和监控。

Master服务器也会加载Monitor，因为它也会收集其自身的监控信息。可以认为Master和Monitor是对等组件，Monitor会接收Master的命令，并收集一些周期性的监控信息。

Pomelo 提供了两种信息收集方式：pull和push。pull方式要求Master定期与Monitor通讯，以拉取对应的监控信息；push方式则是由Monitor主动的定期向Master上报监控信息。

配置选项：无



3. Connector
Connector组件是一个重量级的组件，它依赖于session组件、server组件、pushScheduler组件、和connection。connector组件只会被前端服务器加载，主要用于管理客户端连接。connector组件会创建底层传输连接器，监听前端服务器所配置的clientPort端口，绑定相关事件到客户端请求及与之相关的处理器（Handler）。

当客户端建立连接或发送请求时，connector组件会接收，并需要session组件来创建并维护 session 信息。然后，connector组件还会使用connection组件来统计连接信息。最后，将拿到的 session 及客户端请求一起发送给server组件。

当server组件处理完成请求后，又会通过connector组件将响应信息返回给客户端。在返回响应的时候，connector组件会做一个缓存选择，这个缓存实现依赖于pushScheduler组件，也就是说connector组件并不直接向客户端返回信息，而是将响应交给pushScheduler组件。

pushScheduler组件会根据相应的调度策略处理响应信息。当不使用缓存时，会通过session组件所维护的连接，直接将响应发送给客户；当使用缓存时，pushScheduler组件会缓存响应并按时冲刷（flush）响应信息。

配置选项

connector - 底层使用的通信connector。不配置时，会默认使用sioconnector
useProtobuf - 是否对消息使用protobuf压缩，默认为false。目前，仅当connector为hybridconnector支持protobuf消息压缩
useDict - 是否对路由使用基于字典的路由消息压缩，默认为false。目前，仅当connector为hybridconnector支持。
useCrypto - 是否对通讯启用数字签名，默认为false。目前，仅当connector为hybridconnector支持。
encode/decode - 消息的编码、解码方法。未配置时，将为connector提供相应的方法。
transports - 本选项仅适用于sioconnector。在sockit.io通讯中，通讯方式可能有多种（如：websocket、xhr-polling）。本选项用于配置所使用的方式。
Connector组件的配置方式如下：

app.set('connectorConfig', opts);


4. Session
Session组件与Connector组件相关，仅会被前端服务器加载，它是对sessionService封装。

Session组件加载后，会添加一个sessionService到当前应用，可以通过app.get ('sessionService')来获取它。其主要用于维护客户端连接，及创建和维护 session。与经典的TCP会话相比，session中维护的会话可以认为是“服务端访问后所返回的socket”。

一个session会与一个连接相对应。同时，Session组件还会维护用户与连接的绑定，即用户登录后绑定用户与 session。用户可能会通过多个客户端登录，并对应多个 session，当需要给客户端发送消息或返回响应时，就必须通过 session 组件获取与之对应的客户端连接。

配置选项

singleSession - 是否使用单 session，默认为false。当设置为true时，将不允许一个用户同时绑定到多个，在用户绑定一次后，后面的绑定将会失败。
Session组件的配置方式如下：

app.set('sessionConfig', opts);


5. Connection
Connection组件是一个相对简单的组件，它同样只会被前端服务器加载，它是对connectionService组件的封装，其主要用于连接信息的统计。Connector组件在接收到用于连接，或用户下线时，都会Connection组件汇报。

配置选项：无



6. Server
Server组件也是一个功能较为复杂的组件，它会被除主服务器外的所有服务加载。Server组件加载后，会创建并维护其自身的Handler及Filter。

Server组件有两种请求处理方。对于来自前端服务器的请求，Server组件会从connector组件的回调中获取相应的客户端请求或通知，然后使用自已的beforeFilter对消息进行过滤，再调用自已的Handler对请示进行逻辑处理，再将响应通过回调的方式发送给connector处理，最后调用afterFilter进行一些清理工作。

当请求是发向后端服务器时，请示也会通过前端服务器接收。但前端服务器不会处理，而是通过RPC调用将请求发送到后端服务器。对于后端服务器来说，请求信息并不是直接来自于客户端，而是来自于前端服务器的sys rpc调用。这个RPC调用就是 Pomelo 内建的"msgRemote"，在msgRemote的实现中，会将来自前端服务器的sys rpc分发到后端服务器的server组件，然后后端服务器会使用“请求处理链”进行处理。处理完成后，再通过rpc调用将响应信息返回给前端服务器。

前端服务器向后端服务器分发请求时，一般会有多个同类型的后端服务器，因此会需要一个路由策略router。用户可以能过Application.route配置到后端服务器的router。

配置选项：无



7. PushScheduler
PushScheduler也是一个功能相对简单的组件，它只会被前端服务器加载，它与Connecter组件紧密相关。当connecter组件收到server组件的响应或推送的消息时后，connecter组件并不会直接将消息返回给客户端，而是将其发送给pushScheduler组件。pushScheduler组件再通过session组件获取客户端连接，再将响应发送给客户端。

配置选项

scheduler - 调度策略配置，默认直接将响应发送给客户端。也可以使用缓冲策略
pushScheduler配置方式如下：

app.set('pushSchedulerConfig', opts);
如果要使用缓冲scheduler，可以在app.js中做如下配置：

app.set('pushSchedulerConfig', 
  {
    scheduler: pomelo.pushSchedulers.buffer, 
    flushInterval: 20
  }
);
其中flushInterval是刷新周期，默认为20毫秒。



8. Proxy
Proxy是一个重量级组件，它会被除主服务器外的所有服务器所加载。Proxy组件会扫描服务器的目录，并提取其中的remote部分，由于JavaScript语言的动态性，可以很简单的获取到remote中关于远程调用的元素，然后生成 stub并将这些调用都挂到app.rpc下。当用户发起rpc调用时，proxy组件会检查其扫描到的stub信息，以此判断调用是否合法。

同时，Proxy组件还会创建一个RpcClient，当发起远程调用时，其负责与remote进行通讯，并得到远程调用结果供调用者使用。

当进行远程调用时，由于同类型的远程服务器可能有多个，所以这里同样需要配置相应的router。

配置选项

cacheMsg - 配置为true时，rpc调用时的将开启消息缓存。默认为false
interval - 与cacheMsg配合使用，用于配置flush周期
mailBoxFactory - 用于RPC调用者与被调用者间的通讯。可以将其视为底层网络传输的抽象，开发者可以定义自己在的mailBoxFactory。默认为wsBoxFactory，使用 WebSocket 传输
Proxy组件配置方式如下：

app.set('proxyConfig', opts);
还可以通过以下方式开启rpc调用日志：

app.enable('rpcDebugLog');


9. Remote
Remote组件是Proxy的一个对等组件，它会被除主服务器外的所有服务器所加载，它用于提供RPC远程服务。Remote组件会载入当前服务器中所有的远程handler，并在所配置的端口上启动监听，然后等待RPC客户端的RPC调用。

当收到调用时，会根据调用请求中的描述信息调用remote中相应的方法。调用完成后，将处理结果返回给RPC客户端。

RPC服务端还支持对调用请求的过滤，和server组件处理客户端请求一样，RPC服务端也会使用filter-remote链进行处理。

配置选项

cacheMsg - 与Proxy组件相同
interval - 与Proxy组件相同
acceptorFactory - 其与用于Proxy组件中的mailBoxFactory是对等的，同样用于底层网络通讯
Remote组件配置方式如下：

app.set ('remoteConfig', opts);


10. Dictionary
Dictionary组件是一个可选组件，它默认不会被加载，只有当connetor组件配置并启用了useDict时才会被加载。Dictionary会遍历所有handler的route字符串，还会从config/dictionary.json中读取所有客户端的route字符串，然后对这些字符串编码并分配一个唯一的整数，以实现route的压缩。压缩后，客户端与服务端通讯时，路由将不再是那长字符串，而是所分配的小整数。

配置选项

dict - 客户端的route配置文件位置，默认使用config/dictionary.json
Dictionary组件配置方式如下：

app.set('dictionaryConfig', opts);


11. Protobuf
Protobuf组件也是一个可选组件，默认不会加载，只有当useProtobuf组件配置并启用了useDict时才会被加载。该组件会加载对应的proto文件，并对消息基于protobuf进行编解码。默认的proto文件的配置信息在config/serverProtos.json和config/clientProtos.json中。

配置选项：无



12. Channel
Channel组件用于维护 channel 信息，它会被除主服务器外的所有服务器加载，该组件是对channelService的一个包装，在Channel加载后，可以通过app.get('channelService')来获取channelService。

channel可以认为一个用户的集合，每个用户会对应前端服务器的一个或多个session。可以通过Channel组件向 channel 中的所有用户推送消息。由于前端服务器并不直接与客户端相连，所以后端服务器会发起一个sys rpc调用，接收这个远程调用的是 Pomelo 中的ChannelRemote。

配置选项

broadcastFilter - 广播过滤函数。广播时，它会前端服务器向客户端广播消息前进行过滤。访函数的签名如下：
broadcastFilter(session, msg, filterParam);
其中filterParam参数由channelService在广播调用时传入：

channelService.broadcast(type, route, {filterParam: param}, cb);
Channel组件配置方式如下：

app.set('channelConfig', opts);


13. BackendSession
BackendSession组件会被除主服务器外的所有服务器加载，它是对BackendSessionService组件的封装。该组件加载后，会在应用的上下文中加入backendSessionService，可以通过app.get('backendSessionService')来获取、调用组件。它通常是为后端服务器提供和维护BackendSession信息，并通过前端服务器的PRC调用，完成一些对原始 session 的操作，如绑定uid等。