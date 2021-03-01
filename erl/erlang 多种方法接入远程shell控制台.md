erlang shell是用户与 erlang 运行时系统交互的界面程序。事实上，erlang VM的运行不依赖任何shell，只要在启动的时候添加参数detached就可以脱离终端。
-detached
Starts the Erlang runtime system detached from the system console. Useful for running daemons and backgrounds processes. Implies -noinput.
实际上，detached 等效于noshell 加上 noinput。
# erl -detached -emu_args
Executing: /home/erl/lib/erlang/erts-5.10.3/bin/beam /home/erl/lib/erlang/erts-5.10.3/bin/beam -- -root /home/erl/lib/erlang -progname erl -- -home /root -- -noshell -noinput
另外，需要注意的是，windows不直接支持detached，而是以服务的形式在后台运行，见 erlsrv

现在讨论erlang 接入远程shell控制台的几种方式。
作业（JCL ）模式 
在 Erlang shell 中按下^G键，就可以看到作业控制模式（JCL mode）的菜单。在菜单中，有个选项能让我们连接到一个远程 shell。
先以detached运行一个节点1：
# erl -name 1@127.0.0.1 -setcookie 123456 -detached
检查这个erlang进程是否运行
# ps -ef | grep beam
root 20672 1 0 01:32 ? 00:00:00 /home/erl/lib/erlang/erts-5.10.3/bin/beam -- -root /home/erl/lib/erlang -progname erl -- -home /root -- -name 1@127.0.0.1 -setcookie 123456 -noshell -noinput 
启动另外一个节点2，并接入到节点1
# erl -name 2@127.0.0.1 -setcookie 123456 
Erlang R16B02 (erts-5.10.3) [source] [64-bit] [async-threads:10] [hipe] [kernel-poll:false] 
Eshell V5.10.3 (abort with ^G) 
(2@127.0.0.1)1> 
User switch command 
 --> h 
   c  [nn]                       - connect to job 
   i   [nn]                       - interrupt job 
   k  [nn]                       - kill job 
   j                                 - list all jobs 
   s [shell]                    - start local shell 
   r [node [shell]]        - start remote shell 
   q                               - quit erlang 
   ? | h                          - this message 
 --> r '1@127.0.0.1' 
 --> j 
  1 {shell,start,[init]} 
  2* {'1@127.0.0.1',shell,start,[]} 
 --> c 2 
Eshell V5.10.3 (abort with ^G) 
(1@127.0.0.1)1>
注意了，windows下要使用werl

连接到远程 shell 后，所有的终端输入解析操作都由本地 shell 完成，不过求值的工作是在远 程完成的。远程求值的结果输出全部被转发给本地 shell。  
 
要退出 shell， 按^G回到 JCL 模式。 终端输入解析操作是在本地进行的， 因此通过^G q 的方式退出 shell  是安全的。
Eshell V5.10.3 (abort with ^G) 
(1@127.0.0.1)1> 
User switch command 
--> q


Remsh 模式
Remsh和 JCL 模式很类似，但是调用方式不同的机制。使用这种机制，JCL 模式的所有 操作步骤都可以被绕过，只需像下面这样启动 shell，对于长名字：

-remsh Node
Starts Erlang with a remote shell connected to Node.

以下方式启动节点2，将直接接入节点1控制台：
# erl -name 2@127.0.0.1 -setcookie 123456 -remsh 1@127.0.0.1
Erlang R16B02 (erts-5.10.3) [source] [64-bit] [async-threads:10] [hipe] [kernel-poll:false]
Eshell V5.10.3  (abort with ^G)
(1@127.0.0.1)1> node().
'1@127.0.0.1'
这种方式和JCL很相像，本地也会启动一个erlang节点用于接入远程shell


SSH 模式
erlang自带了SSH的功能，我们可以很方便的开启SSH服务，对外提供远程 shell服务。 SSH的使用需要开启crypto，如果erlang显示以下错误，可以参考这篇文章。
1> crypto:start().  
** exception error: undefined function crypto:start/0
要使用该功能，通常需要先准备好具有远程访问 SSH 权限的 key，不过这里为了快速测试，可以这样做：
节点1启动ssh服务：
Eshell V5.10.3  (abort with ^G)
(1@127.0.0.1)1> ssh:start().
ok
(1@127.0.0.1)2> ssh:daemon(8888, [{password, "12345"}]).
{ok,<0.57.0>}
本地不需要启动erlang节点，直接使用ssh连接即可，输入以上设置的密码，就可以接入节点1的shell控制台。
# ssh -p 8888 1@127.0.0.1
The authenticity of host '[127.0.0.1]:8888 ([127.0.0.1]:8888)' can't be established.
RSA key fingerprint is ad:03:b4:6b:df:51:97:23:dc:47:cb:75:85:15:44:89.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[127.0.0.1]:8888' (RSA) to the list of known hosts.
1@127.0.0.1's password:
Eshell V5.10.3  (abort with ^G)
(1@127.0.0.1)1> 
这种方式，erlang shell所有操作都是在远程节点完成的。


管道（pipe）模式
在使用管道（pipe）连接到一个Erlang节点时，和SSH一样不需要启动本地erlang节点。这种方法很少用，每次输出时都调用fsync，如果输出过多时，会有很大的性能损失。

具体做法为：用 run_erl 启动 erlang，相当于把 erlang 进程包在一个管道中：
# mkdir /tmp/erl_log
# cd /home/erl/bin
# ./run_erl -daemon /tmp/erl_pipe /tmp/erl_log "erl -name 1@127.0.0.1 -setcookie 123456"
其中，daemon 表示以后台进程运行，/tmp/erl_pipe是管道文件的名称，/tmp/erl_log指定了日志保存文件夹
然后使用 to_erl 程序来连接节点： 
# ./to_erl /tmp/erl_pipe
Attaching to /tmp/erl_pipe (^D to exit) 
(1@127.0.0.1)1> node(). 
'1@127.0.0.1'

参考：http://blog.csdn.net/mycwq/article/details/43850735
https://s3.amazonaws.com/erlang-in-anger/text.v1.0.3.pdf