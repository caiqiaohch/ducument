# 通道（channel）

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

7 人赞同了该文章

假设使用以下命令，连续开启两个异步[作业](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-job.html)：

```vim
:call job_start('cd ~/.vim/')
:call job_start('ls')
```

这些作业之间，将是相互独立的。也就是说，连续执行这两条命令，并不能进入指定目录并列示文件。第一条命令，开启一个后台作业并使用'cd'命令进入目录；第二条命令，开启另一个独立的后台作业并使用'ls'命令列示当前目录的文件。

## 通道概念

利用Vim内置终端功能，可以改变当前目录并列示文件：

```vim
:terminal
$ cd ~/.vim
$ ls
```

也就是说，terminal命令开启了一个异步作业（即shell进程），它持续等待用户的输入，并解释执行键入的shell命令。vim利用通道（channel）来与后台异步作业进行通讯。借由此机制，vim可以获取外部命令的输出和状态，并执行回调函数进行响应。而随着外部命令的结束，通道也会自动关闭。

## 开启通道

使用ch_open({address} [, {options}])函数，可以开启通道：

```vim
:let channel = ch_open('localhost:8765', {'callback': "MyHandler"}) 
```

在通道选项{options}中，模式"mode"规定了通讯的消息格式（即传输和读写字符串的格式）。共支持四种模式：

- NL，利用换行符（newline）来分隔消息。使用job_start()函数启动的作业，默认使用此模式；
- JSON，[json](https://link.zhihu.com/?target=https%3A//www.json.org/)数据交换格式。使用ch_open()函数开启的通道，默认使用json模式；
- JS，JavaScript风格的信息格式，效率比json更高；
- RAW，原始格式，完全由用户在回调函数中进行处理。

至于应该使用何种模式的通道，则取决于另一端程序所提供的服务。对于简单通讯可以使用 NL 模式，而复杂的服务则推荐 JSON 模式。

模式的选择，也将影响"callback"回调函数的定义。一般形式为：

```vim
func MyHandler(channel, msg)
   echo "from the handler: " . a:msg
endfunc
```

- channel参数，是通道ID，即ch_open()的返回值，代表某个特定的通道；
- msg参数，即消息内容。如果是JSON或JS模式，将会自动解码为VimL数据类型，比如嵌套的字典或列表结构等；如果是NL模式，则将其转换为去除换行符的字符串；如果是RAW模式，则保留原始信息，其中的换行符也需要用户在回调函数中自行处理。

## 通道交互

开启通道并与另一端的程序建立连接之后，vim可以向对方发送请求，并等待回应，以此来协同工作。

针对不同模式的通道，需要使用不同的方式来发送信息：

![img](https://pic4.zhimg.com/80/v2-7ba9b7f8d502015273b6ef720905ddeb_720w.jpg)

- channel参数，即用于识别通道的唯一编号；
- expr参数，指定将要发送的VimL数值或数据结构，并交由vim编码成json或js风格的字符串；
- string参数，必须是字符串，而不能是其他复杂的VimL数据结构。

Vim实际发送的消息，为[{channel},{expr}]组成的一个二元列表；通道彼端接收消息并进行处理之后，也将由通道返回[{channel},{response}]组成的二元列表；在同一请求回应中，通道编号是相同的，据此将返回值分发到对应的回调函数。如果在发送消息时没有指定回调函数，那么将使用在ch_open()中指定的回调函数。

同步发送消息，存在阻塞的风险，但其优点是程序逻辑简单，不必使用回调函数。如果另一端的服务程序运行在本地机器，并且执行的操作耗时较短时，可以考虑使用同步消息方式。根据通道选项"timeout"键的默认设定，阻塞时间超过2000毫秒 (即2秒)时，Vim将自动终止操作。在超时或出错时，ch_evalexpr()函数将返回空字符串。

请注意，JSON和JS模式的通道也可以使用ch_sendraw()和ch_evalraw()函数，但是需要调用json_encode()和json_decode()函数来自行处理编码和解码。

## 通道状态

使用ch_status()函数，可以返回指定通道的状态：

```vim
:echo ch_status(channel)
```

- fail：通道打开失败
- open：通道可用
- buffered：通道已关闭，但还有待读的数据
- closed：通道已关闭

使用ch_info()函数，可以返回指定通道的详细信息：

```vim
:echo ch_info(channel)
```



```text
{'status': 'open', 'id': 1, 'port': 8765, 'hostname': 'localhost', 'sock_io': 'socket', 'sock_mode': 'JSON', 'sock_timeout': 2000, 'sock_status': 'open'}
```

函数将返回包含详细信息的字典：

- status：ch_status()返回值
- id：通道号
- port：地址的端口号
- hostname：地址的机器名
- sock_io："socket"
- sock_mode："NL"、"RAW"、"JSON" 或 "JS"
- sock_timeout：以毫秒为单位的超时
- sock_status："open" 或 "closed"

## 关闭通道

使用ch_close()函数，可以关闭指定的通道：

```vim
:call ch_close(channel)
```

使用套接字（socket）时，将关闭双向的套接字；使用管道 (stdin/stdout/stderr)时，将关闭所有的管道。

## 通道实例

在操作系统的终端中，运行Vim自带的 $VIMRUNTIME/tools/demoserver.py 演示程序，服务开始监听指定端口：

```text
Server loop running in thread:  Thread-1
Listening on port 8765
```

在Vim中开启通道，连接到演示服务器:

```vim
:let channel = ch_open('localhost:8765')
```

此时操作系统终端中，将显示通讯开放：

```text
=== socket opened ===
```

在Vim中使用以下命令，向通道彼端发送消息：

```vim
:call ch_sendexpr(channel, 'hello!')
```

因为没有指定回调函数，所以Vim不会显示任何回显；运行在外部终端的监听服务，将显示以下信息：

```text
received: [1,"hello!"]
sending [1, "got it"]
```

在Vim中使用以下命令，向通道彼端发送消息并指定上文中定义的回调函数：

```vim
:call ch_sendexpr(channel, 'hello!', {'callback': "MyHandler"})
```

Vim将执行指定的回调函数，并显示以下信息：

```vim
from the handler: got it
```

同时运行在外部终端的监听服务，将显示以下信息：

```text
received: [2,"hello!"]
sending [2, "got it"]
```

在操作系统终端中的服务程序内，输入以下命令向另一端的Vim发送消息：

```text
["ex","echo 'hi there'"]
```

在Vim屏幕底部，将显示以下消息：

```text
hi there
```

![img](https://pic4.zhimg.com/80/v2-a843858fd18643954a597e32e65d9153_720w.jpg)

**？**使用以下命令，可以查看关于通道的帮助信息：

```vim
:help channel 
```



编辑于 01-13