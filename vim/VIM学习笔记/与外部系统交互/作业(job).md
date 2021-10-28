# 作业(job)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

5 人赞同了该文章

在传统的单线程模式下，运行外部命令时，将中断用户当前的编辑操作，并等待命令完成才可以返回vim。

自8.0版本起，包含+channel和+job特性的Vim将可以支持异步操作。Vim使用作业（job）来启动进程，并利用通道（channel）和其他进程通信。

利用异步支持，可以在后台进行复杂耗时的操作（比如使用外部[grep](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-Regex.html)工具查找文本），不必等待外部命令结束即可返回Vim，而不中断前台的正常编辑。在外部命令结束运行时，可以通过回调函数来处理输出结果。

![img](https://pic2.zhimg.com/80/v2-2171d154ae0be6fb8871c1eb852c9ba9_720w.jpg)

例如使用`:!ls`外部命令，将在屏幕底部列示目录内容，并等待用户按回车键以返回常规模式，此时用户无法进行其它操作：

![img](https://pic3.zhimg.com/80/v2-1081d64dc25d67a031ca2936ab929ef2_720w.jpg)

## 启动作业

使用job_start()函数，可以异步执行命令，其格式为：

```vim
job_start({command} [, {options}])
```

其中：command，用于指定需要运行的外部系统命令；options，是包含多个键值的字典选项，用于配置和控制作业的行为。

使用以下命令，可以启动作业以执行外部命令，并立刻返回常规模式，不影响用户的后续操作：

```vim
:call job_start('ls')
```

## 作业选项

作业采用管道（pipe）将外部命令与vim联接起来，并与标准输入（stdin）、标准输出（stdout）和标准错误（stderr）输出进行交互。

在使用job_start()函数启动作业时，可以注册一个或多个回调函数来处理特定的信息。如果希望静默执行命令，而不关心输出信息，那么也可以不注册任何回调函数。

使用"callback"选项，可以同时捕获标准输出与标准错误输出；也可以分别使用"out_cb"或"err_cb"选项，来单独捕获标准输出或标准错误输出。

首先定义用于捕获输出的回调函数：

```vim
func! MyHandler (channel, msg)
    echomsg a:msg
endfunc
```

通过"callback"选项，指定回调函数来处理stdout和stderr的内容：

```vim
let job = job_start ('ls', {"callback": "MyHandler"})
```

通过"out_cb"选项，指定回调函数来处理stdout的内容：

```vim
let job = job_start ('ls', {"out_cb": "MyHandler"})
```

通过"err_cb"选项，指定回调函数来处理stderr的内容：

```vim
let job = job_start ('ls', {"err_cb": "ErrHandler"})
```

在以上回调函数中使用了`:echomsg`命令，因此随后可以使用`:message`命令来查看[信息历史](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-message.html)，以确认命令执行结果：

![img](https://pic1.zhimg.com/80/v2-7843eac1877b1f4037578bad5b076948_720w.jpg)

使用"in_io"、"out_io"或"err_io"选项，可以将作业管道重定向到文件或缓冲区。

使用以下命令，可以将标准输出重定向至指定缓冲区：

```vim
:let job = job_start('ls', {'out_io': 'buffer', 'out_name': 'mybuffer'})
```

使用以下命令，则可以打开缓冲区查看输出信息：

```vim
:sbuf mybuffer
```

请注意，首行包含了“Reading from channel output...”的说明文字：

![img](https://pic4.zhimg.com/80/v2-83dfe5a745c7b9b9e6a644dfe66fd20f_720w.jpg)

使用以下任一命令，均可以将标准输出重定向至指定文件：

```vim
:let job = job_start('ls -al', {'out_io': 'file', 'out_name': '/tmp/file.txt'})
:call job_start(["/bin/sh", "-c", "ls -al > /tmp/file.txt"])
```

**？**使用以下命令，可以查看作业选项的帮助信息：

```vim
:help job-options
```

## 作业状态

使用job_status()函数，可以返回指定作业的状态：

```vim
:echo job_status(job)
```

| 状态 | 描述                   |
| ---- | ---------------------- |
| run  | 作业运行中             |
| fail | 作业无法启动           |
| dead | 作业启动后结束或被终止 |

使用job_info()函数，则可返回指定作业的详细信息：

```vim
:echo job_info(job)
```

![img](https://pic2.zhimg.com/80/v2-46109f3110cc80cc3e4bd29d30f598b5_720w.jpg)

函数将返回包含详细信息的字典：

![img](https://pic1.zhimg.com/80/v2-63b0d4cf22fda155a5b42971f6185c08_720w.jpg)

## 停止作业

使用job_stop()函数，可以停止指定的作业：

```vim
:call job_stop(job)
```

## 作业实例

实例1：启动[Apache HTTP Server](https://link.zhihu.com/?target=http%3A//httpd.apache.org/)服务

```vim
:let job = job_start('apachectl start')
```

使用以下命令载入首页内容，以确认服务启动成功：

```vim
:silent r ! curl localhost
```

实例2：在位置列表中显示命令输出

```vim
function! s:on_find(chan, msg)
      lgetexpr split(a:msg, '')
endfunction

call job_start('find . -print0', {
      \ 'out_mode': 'raw',
      \ 'callback': function('<SID>on_find')
      \ })
```

使用以下命令，执行包含以上命令的脚本：

```vim
:so %
```

使用以下命令，将在位置列表（location list）中显示外部[find](https://link.zhihu.com/?target=http%3A//man.he.net/%3Ftopic%3Dfind%26section%3Dall)命令输出的文件列表：

```vim
:lopen 
```

![img](https://pic3.zhimg.com/80/v2-d46f4dae4b47309c1e6f5e984e952cb2_720w.jpg)

**？**使用以下命令，可以查看关于作业的帮助信息：

```vim
:help job
```

| job_start()  | 启动作业           |
| ------------ | ------------------ |
| job_status() | 显示作业状态       |
| job_info()   | 显示作业的详细信息 |
| job_stop()   | 停止作业           |

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-silent.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-job.html)>

编辑于 2020-11-23