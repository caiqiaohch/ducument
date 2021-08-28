实验环境： 公司内网的2台机器，一台是我自己的笔记本 （机器名nb11），一台是公司的服务器(机器名ws100），都是win7 的系统

(发觉一个诡异的问题，shell访问的命令，windows 下，只有werl.exe 支持，erl.exe调不出。在命令行启动erl 控制台，不支持)

A.首先起分别在2个机器上启动erl 节点

1.首先在笔记本启动

命令输入

erl -same master -setcookie test

机器启动erl后，出现提示

[master@nb11]1>

 

2.在服务器启动

命令输入

erl -same sa1 -setcookie test

机器启动erl后，出现提示

[sa1@ws100]1>

B 接着如何从我的节点登录到工作站

1.在之前的erl控制台下，按Ctrl+G

出现user switch command

-->

然后输入r  “sa1@ws100“按回车

在按 J

机器显示节点:

1  {shell,start,[init]}
 2* {sa2@shawin7nb381,shell,start,[]}


在 * 的就是默认的可连接节点，其中的1 行，就是你现在的master节点

按 c 就能连接

接着机器回复

Eshell V6.1  (abort with ^G)
(sa1@WS100)1>

这就表示你已经在服务器节点上了

===========扩展说明====================

在真正的集群下，前面显示的节点可能是个很长的节点列表。

很可能是

1  {shell,start,[init]}
 2 {sa2@shawin7nb381,shell,start,[]}

 3 {sa1@WS100,shell,start,[]}

 4  {sa1@WS200,shell,start,[]}

 5 {sa1@WS101,shell,start,[]}

 6* {sa1@WS102,shell,start,[]}

你如果要连接到第三节点的话，直接 输入 c 6 回车就行了。

============================

 

C 如何回到本地节点

先Ctrl +G

安 J

机器显示

1  {shell,start,[init]}
 2* {ｍａｓｔｅｒ@shawin7nb381,shell,start,[]}

直接输入c　就可

 

转载于:https://www.cnblogs.com/codewarelock/p/4194784.html