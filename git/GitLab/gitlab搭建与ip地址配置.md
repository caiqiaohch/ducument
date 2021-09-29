这两天暂时没什么事情做，于是动手搭建gitlab，gitlab也比较好用
1.下载gitlab
由于公司网络原因，导致没有办法直接使用yum安装，只能先下载，再安装
下载https://packages.gitlab.com/gitlab
我的系统是centos7这里下载的是gitlab-ce el/7 https://packages.gitlab.com/app/gitlab/gitlab-ce/search?dist=el%2F7
下载后手动安装：
rpm -ivh gitlab-ce-10.0.0-ce.0.el7.x86_64.rpm
2.配置gitlab
1> 配置ip地址访问gitlab：
修改/etc/gitlab/gitlab.rb

external_url 'http://gitlab.example.com' 
		改为external_url '10.10.10.10'
	然后执行:
		gitlab-ctl reconfigure
	若报错如下：加个“=”如external_url='10.10.10.10'，再次执行gitlab-ctl reconfigure

2>git clone的时候用显示ip地址而不是域名
修改/opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml
/var/opt/gitlab/gitlab-rails/etc/gitlab.yml
将gitlab节点下host改为对应的ip：10.10.10.10
配置好后执行gitlab-ctl reconfigure
3.重启gitlab
执行gitlab-ctl restart

4.找回gitlab登录用户名和密码
自己瞎折腾，结果把用户名和密码都改了，退出来以后怎么也登录不上，只能强制找了：
1>切换到git用户操作下

su - git

2> 进入gitlab控制台

gitlab-rails console production

3>查看gitlab用户信息
id为1表示管理员账号，id为2，id为3等，直到查到是自己想要的账户时。

user = User.where(id:1).first

4> 重置密码

user.password='11111111'

5>保存

user.save!

————————————————
版权声明：本文为CSDN博主「simple__study」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_30021199/article/details/106984335