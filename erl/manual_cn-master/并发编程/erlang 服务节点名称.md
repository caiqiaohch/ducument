erlang 服务节点名称

erlang程序设计的 kvs 例子中，局域网 远程调用的节点名称。

erl -name gandalf -setcookie abc. 如果机器没有该计算机名称，那么 节点名称会是  gandalf @localhost.localdomain 这个名字需要改一下。

修改方法

1. hostname mike.com

2.vi /etc/sysconfig/network

    修改 HOSTNAME=mike.com

3 vi /etc/hosts

   增加 192.168.74.130  mike.com  mike.com

4 重启网络服务

  service network restartf.


重新

erl -name gandalf -setcookie abc.



节点名称就是gandalf@mike.com了

