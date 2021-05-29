Pomelo 前端服务器与客户端的通讯
 2017年12月02日     1508     声明



处理和响应客户端请求是 Pomelo 核心任务之一，客户端请求处理过程中会涉及很多组件，包括session组件、server组件、connection组件、connector组件、proxy组件、remote组件等。本篇将介绍 Pomelo 是怎样和客户端通讯的，及前端服务器（Frontend server）怎样处理用户请求的。

处理流程
1.1 初始化
1.2 客户端连接
1.3 客户端请求
1.4 绑定、解绑用户
1.5 客户端断开连接
Pomelo 请求处理链
2.1 beforeFilter
2.2 Handler
2.3 afterFilter
2.4 ErrorHandler
Pomelo 内置Filter
1. 处理流程
在与客户端通讯及请求处理过程中会涉及很多组件，对于前端服务器来说，各组件作用如下：

Session组件是以sessionService组件的包装，其用于维护用户的session信息
Connection是对connectionService组件的包装，其会做一些连接统计
Connector组件会监听和维持客户端连接
Server组件会维护Handler及HandlerFilter
当一个请求到达前端服务器时，前端服务器会检查请求是否有效。如果请求有效，且前端服务器已定义了与之对应的Handler，这说明前端服务器可以处理请求。这时，前端服务器会使用“请求处理链”来处理该请求，然后返回处理结果。

通过路由检查，如果发现是发往后端服务器的请求，那么前端服务器会根据用户配置的router或使用默认router将请求定向到后端服务器，然后发起RPC调用。

后端服务器收到RPC调用后，会从其中获取请求路由及请求参数，并使用“请求处理链”对其进行处理。

流程如下：

Pomelo 请求处理流程

以下类图粗略地展示了这些类之间的关系：

Pomelo 服务器类调用关系

在下面类时序图中，通过一些典型行为，展示了处理客户端请求的过程：

Pomelo 客户端请求处理过程

注意：在 Pomelo 命名规范中，组件都是以Co开头的。如，上面中的CoConnector表示Connector组件类。

1.1 初始化
在connector组件（CoConnector）的afterStart回调中，会使用服务器配置中的clientPort开启 socket 监听。然后就可以接收用户连接了，并会绑定connector的connection事件到当前事件处理器。

在server组件（CoServer）的start回调中，会扫描当前服务器应该加载的Handler和HandlerFilter并会完成Handler和Filter的加载。这时，服务器已经做好了接收客户端请求和连接的准备。



1.2 客户端连接
当一个客户端连接到前端服务器，会触发connector的connection事件。

在事件处理，connection组件（CoConnection）会增加连接数，以统计连接信息。然后对接收到的 socket 绑定'close'、'error'、'disconnect'等事件。

然后session组件（CoSession）为每个连接创建并维护一个与之关连的 session 信息。

此时，客户端已经完成了与服务器端的连接。



1.3 客户端请求
客户端连接建立后，就可以发送请求了。客户端请求会触发 Socket 的'message'事件，在处理这个事件时，connector首先会对消息进行解包（包括请求路由、请求 ID、请求体），然后将请求分发给server组件（CoServer）。

server组件会检查请求是否有效，如：路由是否存在。如果请求是由前端服务器的Handler进行处理的，则服务器会使用doHandle方法来调用“请求处理链”来处理该请求。

如果请求不是发送给前端服务器的，那么server组件会使用系统命名空间RPC调用后端服务器的doFoward方法。当发起sys rpc调用时，由于同类型的后端服务器一般会有很多，因些会有一个路由选择的过程。

路由选择策略可以是用户配置，并通过app.route调用。如果用户未配置，Pomelo 会使用一个默认的路由配置。

后端服务器接受到请求后，会执行server组件的doHandle，和前端服务器一样同样会使用“请求处理链”来处理用户请求。处理完成后，将处理结果发送给前端服务器，再由前端服务器将响应发送给客户端。

前端服务器会调用connector的send方法，将响应或推送的消息发送给客户端。响应可以由前端服务器自已的 Handler 或由后端服务器RPC返回。send方法调用后并不会通过 Socket 将消息直接发送给客户端，而是将发送任务调度给pushScheduler 组件（CoPushScheduler）。

Pomelo 提供了两咱调度协议，direct协议会立刻将消息发送给客户端，buffered协议则会缓冲发送任务，并按时冲刷（flush）。

默认情况下会使用direct协议，如果要使用buffered协议，则可以通过以下方式启动：

app.set ('pushSchedulerConfig', 
  {
    scheduler: pomelo.pushSchedulers.buffer, 
    flushInterval: 20
  });
以上flushInterval表示定时冲刷的周期。

当服务器的请求处理逻辑需要给客户端推送消息时，会通过用户的uid或者sid（session id）从SessionService里获得到对应的session，session中会维护与客户端通信的 socket，然后将要推送的数据通过这个 socket 连接发送到客户端。


1.4 绑定、解绑用户
一般来说，建立connection及session后，用户会发起登录请求，从而完成session与用户的绑定。

这个过程一般会在server组件中处理，绑定时会调用server组件的包装对象SessionService中的bind方法，完成用户绑定操作。此外，connection组件还会调用addLoginedUser方法增加用户，完成统计信息的维护。

处理用户的注销请求时，会将session与uid解绑。这时会调用server组件的unbind方法完成用户的解绑操作。此外，connection组件还会调用removeLoginedUser方法减少用户，完成统计信息的维护。



1.5 客户端断开连接
当客户端与前端服务器断开连接时，connector监听的 socket 会触发disconnect事件。而在该事件的处理器（回调函数）中，会从SessionService中删除对应的session，并释放掉session维护的连接，还会调用connectionService上的decreaseConnectionCount，以完成统计信息的维护。



2. Pomelo 请求处理链
Pomelo 中，有4种Filter，分别是用于正常流程的：beforeFilter、HandlerFilter、afterFilter，和用于错误处理的ErrorHandler。

Pomelo 完整的请求处理链流程大致如下：

Pomelo 请求处理流程

2.1 beforeFilter
对于beforeFilter来说，其方法签名如下：

before(msg, session, next);
其中：

msg是请求体
session表示当前请求的 session。它是前端服务器中的FrontendSession，或它是后端服务器中的BackendSession
next是一个回“请求处理链”继续向下进行。如果在一个 filter 中没有发生错误，那么直接调用next()，而不传入任何参数，“请求处理链”会继续向下；其它情况，调用call(err, resp)，这样会立即停止“请求处理链”进入错误处理，也可以同传入一个resp参数，做为对客户端的响应。


2.2 Handler
Handler的方法签名如下：

<handler_Name>(msg, session, next);
msg是经过beforeFilter处理后的请求体
session是经过beforeFilter处理后的，当前请求的 session。
next同样是一个进入下一步的回调。如果没有发生错误，那么直接调用next(null, resp)；其它情况，调用call(err, resp)进入错误处理。一般来说，会在 handler 中完成用户响应逻辑。


2.3 afterFilter
对于afterFilter来说，其方法签名为：

after(err, msg, session, resp, next);

afterFilter会做一些清理操作，在执行到afterFilter的时候，具体的响应已经发送给了客户端。也就是说，在afterFilter中修改resp，不会对客户端响应造成影响。

同样的，next是进入下一步的回调，其签名为：next(err)。不同于beforeFilter和Handler，afterFilter通常会做一些清理操作，这时对err不再敏感，无论是否有错误，整个afterFilter链都会执行完。



2.4 ErrorHandler
ErrorHandler

除了前面介绍三个用于处理正常流程的处理链外，Pomelo 中还有一个ErrorHandler，它用于在请求中发生错误时进行异常时处理。其签名为：

<errorHandler_Name>(err, msg, resp, session, cb);
beforeFilter或Handler处理过程中如果发生错误，都会被转到ErrorHandler中进行处理。

ErrorHandler中的参数意义和前面几个处理器的参数是一样的，其中resp是由前面的next(err, resp)调用传递过来的。cb的签名为：cb(err, resp)，它会将resp发送给客户端。ErrorHandler需要显式的调用cb(err, resp)，否则客户端将得不到服务器的响应。ErrorHandler可以根据传入的resp和err，重新生成要发送给客户端的resp。

如果设置了全局的ErrorHandler，则由所设置的ErrorHandler向客户端返回响应信息。如果没有设置，系统默信的ErrorHandler会向客户端返回由beforeFilter或Handler中产生的resp。

设置全局ErrorHandler的方式如下：

var errorHandler = require('<path>');
app.set('errorHandler', errorHandler);


3. Pomelo 内置Filter
Pomelo 提供了一些常用的内置Filter，用户可以通过以下方式启用：

app.filter(pomelo.filters.<filterName>(<args>));
内置Filter如下：

serial
这个 filter 用于串行化用户请求，使用户请求只有在第一个请求处理完成后，才会处理第二个。serial中使用了一个taskManager，当用户请求到达后，在beforeFilter中会将用户请求放到taskManager中，taskManager会维护一个task队列。在对应的afterFilter中，如果taskManager还有未处理的请求，将会处理这个请示，即在afterFilter里启动taskManager中处理下一个请求，这样就实现了请求的序列化

timeout
这个 filter 用于对服务端的处理超时发出警告，它会在beforeFilter中启动一个定时器，并在afterFilter中清除。如果在定时器指定时间内处理完成，那么在afterFilter被调用后，定时器被清除，也就不会出现超时警告。如果定时器超时，而afterFilter还没有被调用，那么就会发出超时警告信息，并记录日志。默认的超时处理时间是3秒，可以在加载timeout通过参数设置时间。

time
time用于记录服务器的处理时间，它会在beforeFilter中记录一个当前时间戳，并在afterFilter中获取这个时间戳，然后与当前时间对比，得到处理时间后进行日志记录。

toobusy
toobusy用于检测Node.js的事件循环是否等待时间过长。它会定义一个阀值，一旦超过这个阀值就会触发。toobusy触发后，将会拒绝请求，并调用next(err, resp)将err传递到错误处理，以标示当前服务器太忙。