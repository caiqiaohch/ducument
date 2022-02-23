# [jenkins(3): jenkins执行shell命令](https://www.cnblogs.com/yitianyouyitian/p/9255098.html)

讨论QQ群：135202158



**目录**

- [1. 执行 本地 shell命令或者脚本](https://www.cnblogs.com/yitianyouyitian/p/9255098.html#_label0)
- [ ](https://www.cnblogs.com/yitianyouyitian/p/9255098.html#_label1)
- [2. 执行远程机器的命令或者脚本。](https://www.cnblogs.com/yitianyouyitian/p/9255098.html#_label2)

 

**正文**

参考: https://www.cnblogs.com/reblue520/p/7146693.html

[回到顶部](https://www.cnblogs.com/yitianyouyitian/p/9255098.html#_labelTop)

## 1. 执行 本地 shell命令或者脚本

[回到顶部](https://www.cnblogs.com/yitianyouyitian/p/9255098.html#_labelTop)

##  

是在一个构建中的  bulid 选项卡。

 

执行本地中的一个脚本

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702171709098-1210835012.png)

 

执行一个命令

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180702171916112-831431682.png)

 

[回到顶部](https://www.cnblogs.com/yitianyouyitian/p/9255098.html#_labelTop)

## 2. 执行远程机器的命令或者脚本。

 

**2.1  ssh 插件要安装好**

 

**2.2  添加一个 用于远程的证书**

**在jenkins首页 点击 [Credentials](http://172.10.30.245:8080/credentials) 进入如下页面**

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180703100303881-1334918456.png)

 

点击System 进入页面进行 credentials的添加：

可以添加用户名密码凭证，也可添加 用户名 密钥作为凭证。当然还有其它的请根据情况自行选择.

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180703100827699-882583433.png)

 

最后出现了 名字为 root(remote_exec) 的凭证。

 

**2.3  配置远程主机和证书的对应**

[Manage Jenkins](http://172.10.30.245:8080/manage)--> configure system--->SSH remote hosts即行配置

也可以省略上面的 第二步， 直接在 这个页面添加credentials.

 

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180703101128458-756035097.png) 

 

**2.4 构建item 选择执行远程脚本一项。**

shell-exec 是构建的项目的名称.  只有进行了上面第3 步的配置，在 SSH site下面才会有选择项目(主机选择).

![img](https://images2018.cnblogs.com/blog/1041301/201807/1041301-20180703101750195-840279154.png)

 

最后在 项目中  点击  build now  构建项目后，执行远程命令。

一搭搭 二搭搭 三搭搭