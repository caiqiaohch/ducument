# [Erlang]数据粘包及packet详解

我们知道，erlang实现的网络服务器性能非常高。erlang的高效不在于短短几行代码就能写出一个服务端程序，而在于不用太多代码，也能够写出一个高效的服务端程序。而这一切的背后就是erlang对很多网络操作实现了近乎完美的封装，使得我们受益其中。文章将讨论erlang gen_tcp 数据连包问题及erlang的解决方案。

数据连包问题，这个在client/server的通讯中很常见。就是，当client在极短的时间内发送多个包给server，这时server在接收数据的时候可能发生连包问题，就一次性接收这几个包的数据，导致数据都粘连在一起。

这里先讨论{packet, raw}或者{packet,0}的情况，分别看下{active, Boolean}的两种方式：

gen_tcp对socket数据封包的获取有以下2种方式，

1、{active, false} 方式通过 gen_tcp:recv(Socket, Length)  -> {ok, Data} | {error, Reason} 来接收。
2、{active, true} 方式以消息形式{tcp, Socket, Data} | {tcp_closed, Socket} 主动投递给线程。

对于第一种方式 gen_tcp:recv/2,3，如果封包的类型是{packet, raw}或者{packet,0}，就需要显式的指定长度，否则封包的长度是对端决定的，长度只能设置为0。如果长度Length设置为0，gen_tcp:recv/2,3会取出Socket接收缓冲区所有的数据

对于第二种方式，缓存区有多少数据，都会全部以消息{tcp, Socket, Data} 投递给线程。

以上就会导致数据连包问题，那么如何解决呢？

 {packet, PacketType}

现在再来看下 {packet, PacketType}，erlang的解释如下：

{packet, PacketType}(TCP/IP sockets)
Defines the type of packets to use for a socket. The following values are valid:

raw | 0
No packaging is done.

1 | 2 | 4
Packets consist of a header specifying the number of bytes in the packet, followed by that number of bytes. The length of header can be one, two, or four bytes; containing an unsigned integer in big-endian byte order. Each send operation will generate the header, and the header will be stripped off on each receive operation.
In current implementation the 4-byte header is limited to 2Gb.

asn1 | cdr | sunrm | fcgi |tpkt |line
These packet types only have effect on receiving. When sending a packet, it is the responsibility of the application to supply a correct header. On receiving, however, there will be one message sent to the controlling process for each complete packet received, and, similarly, each call to gen_tcp:recv/2,3 returns one complete packet. The header is not stripped off.

The meanings of the packet types are as follows: 
asn1 - ASN.1 BER, 
sunrm - Sun's RPC encoding, 
cdr - CORBA (GIOP 1.1), 
fcgi - Fast CGI, 
tpkt - TPKT format [RFC1006], 
line - Line mode, a packet is a line terminated with newline, lines longer than the receive buffer are truncated.

http | http_bin
The Hypertext Transfer Protocol. The packets are returned with the format according to HttpPacket described in erlang:decode_packet/3. A socket in passive mode will return {ok, HttpPacket} from gen_tcp:recv while an active socket will send messages like {http, Socket, HttpPacket}.

httph | httph_bin
These two types are often not needed as the socket will automatically switch from http/http_bin to httph/httph_bin internally after the first line has been read. There might be occasions however when they are useful, such as parsing trailers from chunked encoding.

packet大致意义如下：
raw | 0
没有封包，即不管数据包头，而是根据Length参数接收数据。

1 | 2 | 4
表示包头的长度，分别是1,2,4个字节（2,4以大端字节序，无符号表示），当设置了此参数时，接收到数据后将自动剥离对应长度的头部，只保留Body。

asn1 | cdr | sunrm | fcgi |tpkt|line
设置以上参数时，应用程序将保证数据包头部的正确性，但是在gen_tcp:recv/2,3接收到的数据包中并不剥离头部。

http | http_bin
设置以上参数，收到的数据将被erlang:decode_packet/3格式化，在被动模式下将收到{ok, HttpPacket},主动模式下将收到{http, Socket, HttpPacket}.   

 {packet,  N}

也就是说，如果packet属性为1,2,4，可以保证server端一次接收的数据包大小。

下面我们以 {packet, 2} 做讨论。

gen_tcp 通信传输的数据将包含两部分：包头+数据。gen_tcp:send/2发送数据时，erlang会计算要发送数据的大小，把大小信息存放到包头中，然后封包发送出去。

所以在接收数据时，要根据包头信息，判断接收数据大小。使用gen_tcp:recv/2,3接收数据时，erlang会自动处理包头，获取封包数据。

下面写了个例子来说明，保存为 tcp_test.erl

[plain] view plaincopy在CODE上查看代码片派生到我的代码片

-module(tcp_test).  
-export([  
    start_server/0,  
    start_client_unpack/0, start_client_packed/0  
    ]).  

-define(PORT, 8888).  
-define(PORT2, 8889).  

start_server()->  
    {ok, ListenSocket} = gen_tcp:listen(?PORT, [binary,{active,false}]),  
    {ok, ListenSocket2} = gen_tcp:listen(?PORT2, [binary,{active,false},{packet,2}]),  
    spawn(fun() -> accept(ListenSocket) end),  
    spawn(fun() -> accept(ListenSocket2) end),  
    receive  
        _ -> ok  
    end.  

accept(ListenSocket)->  
    case gen_tcp:accept(ListenSocket) of  
        {ok, Socket} ->  
            spawn(fun() -> accept(ListenSocket) end),  
            loop(Socket);  
        _ ->  
            ok  
    end.  

loop(Socket)->  
    case gen_tcp:recv(Socket,0) of  
        {ok, Data}->  
            io:format("received message ~p~n", [Data]),  
            gen_tcp:send(Socket, "receive successful"),  
            loop(Socket);  
        {error, Reason}->  
            io:format("socket error: ~p~n", [Reason])  
    end.  

start_client_unpack()->  
    {ok,Socket} = gen_tcp:connect({127,0,0,1},?PORT,[binary,{active,false}]),  
    gen_tcp:send(Socket, "1"),  
    gen_tcp:send(Socket, "2"),  
    gen_tcp:send(Socket, "3"),  
    gen_tcp:send(Socket, "4"),  
    gen_tcp:send(Socket, "5"),  
    sleep(1000).  

start_client_packed()->  
    {ok,Socket} = gen_tcp:connect({127,0,0,1},?PORT2,[binary,{active,false},{packet,2}]),  
    gen_tcp:send(Socket, "1"),  
    gen_tcp:send(Socket, "2"),  
    gen_tcp:send(Socket, "3"),  
    gen_tcp:send(Socket, "4"),  
    gen_tcp:send(Socket, "5"),  
    sleep(1000).  

sleep(Count) ->  
    receive  
    after Count ->  
        ok  
    end.  
运行如下：
[plain] view plaincopy在CODE上查看代码片派生到我的代码片

C:\>erlc tcp_test.erl  
C:\>erl -s tcp_test start_server  
Eshell V5.10.2  (abort with ^G)  

1> tcp_test:start_client_packed().  
received message <<"1">>  
received message <<"2">>  
received message <<"3">>  
received message <<"4">>  
received message <<"5">>  
ok  

2> tcp_test:start_client_unpack().  
received message <<"12345">>  
ok  
字节序

字节序分为两类：Big-Endian和Little-Endian，定义如下：
a) Little-Endian就是低位字节排放在内存的低地址端，高位字节排放在内存的高地址端。
b) Big-Endian就是高位字节排放在内存的低地址端，低位字节排放在内存的高地址端。
其实还有一种网络字节序，为TCP/IP各层协议定义的字节序，为Big-Endian。

packet包头是以大端字节序（big-endian）表示。如果erlang与其他语言，比如C++，就要注意字节序问题了。如果机器的字节序是小端字节序（little-endian），就要做转换。

{packet, 2} ：[L1,L0 | Data]

{packet, 4} ：[L3,L2,L1,L0 | Data]

如何判断机器的字节序，以C++为例

[cpp] view plaincopy在CODE上查看代码片派生到我的代码片

BOOL IsBigEndian()    
{    
    int a = 0x1234;    
    char b =  *(char *)&a;  //通过将int强制类型转换成char单字节，通过判断起始存储位置    
    if( b == 0x12)    
    {    
        return TRUE;    
    }    
    return FALSE;    
}  
如何转换字节序，以C++为例
[cpp] view plaincopy在CODE上查看代码片派生到我的代码片

// 32位字数据  
#define LittletoBig32(A)   ((( (UINT)(A) & 0xff000000) >> 24) | \  
    (( (UINT)(A) & 0x00ff0000) >> 8)   | \  
    (( (UINT)(A) & 0x0000ff00) << 8)   | \  
    (( (UINT)(A) & 0x000000ff) << 24))  

// 16位字数据  
#define LittletoBig16(A)   (( ((USHORT)(A) & 0xff00) >> 8)    | \  
    (( (USHORT)(A) & 0x00ff) << 8))  


参考

http://blog.csdn.net/mycwq/article/details/18359007

http://www.erlang.org/doc/man/inet.html#setopts-2