启用iptables后,连接速度很慢

启用iptables后,连接速度很慢


原来不用iptables做限制.

今天在一台服务器上调iptables,加上规则后,没有出状况(没有被挡在外面 ,还好),但是连接速度变得很慢.ssh上去要等10-20秒.

这中情况很难接受.再想办法,再调.

一不小心,输了一句iptables -F.但是我之前写过一句iptables -P INPUT DROP
结果杯具了.

打电话叫机房重启.

机器起来后,再调,绝不放弃.NND

iptables -A INPUT -s *.*.*.* -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
先把这条加上再说.就不怕被挡在外面了.
-m state 状态检测
一共四种状态:
NVALID 表示该封包的联机编号（Session ID）无法辨识或编号不正确。
ESTABLISHED 表示该封包属于某个已经建立的联机。
NEW 表示该封包想要起始一个联机（重设联机或将联机重导向）。
RELATED 表示该封包是属于某个已经建立的联机，所建立的新联机。例如：FTP-DATA 联机必定是源自某个 FTP 联机。


另外改变思路:
不默认DROP了.
改用
iptables -A INPUT -s 0.0.0.0 -j DROP   (加到最后 )
防止再用iptables -F把自己给挡了.


但是连接速度慢的问题还是没有解决.google之.
原来是dns的问题.唉,居然忽略了他.
iptables -I INPUT -p udp --sport 53 -j ACCEPT
iptables -I INPUT -p tcp --sport 53 -j ACCEPT


测试.OK,连接速度也OK.
