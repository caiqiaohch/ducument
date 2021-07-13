Redis重启数据丢失问题

在Linux系统中，Redis本来是有数据的，但在Linux系统重启后，Redis中的数据全部丢失。经过几次测试都一样，只有在Linux系统重启才会丢失，Redis重启应该是没有问题的。

这个问题只在Linux系统才存在，在Windows系统是没有问题的。

二、解决方案
在Linux系统设置一个参数（vm.overcommit_memory）即可解决。
步骤如下：
1、编辑 sysctl.conf 配置文件

vi /etc/sysctl.conf
1
2、检查sysctl.conf配置文件中的vm.overcommit_memory参数是否为0，若为0系统不允许回写，可将参数vm.overcommit_memory = 1。（如果没有这个参数，则另起一行增加参数 vm.overcommit_memory 配置，如下）：

vm.overcommit_memory = 1
1
3、使配置文件生效

sysctl -p

