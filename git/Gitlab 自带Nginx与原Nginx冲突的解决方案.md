Gitlab 自带Nginx与原Nginx冲突的解决方案

默认情况下，gitlab使用自带的Nginx，占用80端口，这样就与系统原本安装的Nginx冲突。有完美的解决方案吗？当然！

CentOS7安装请参考

方案一：通过修改GitLab端口解决冲突
vim /var/opt/gitlab/nginx/conf/gitlab-http.conf
upstream gitlab-workhorse {
  server unix:/var/opt/gitlab/gitlab-workhorse/socket;
}

server {
  listen *:80;  --修改端口


  server_name localhost;
  server_tokens off; ## Don't show the nginx version number, a security best practice
  ......
  ......
  只列举了其中一部分
}
将其中的80改为其它端口即可，如我的是886，执行gitlab-ctl restart 重启gitlab等待网关恢复，重新访问：http://ip:886 即可

方案二：禁用gitlab自带Nginx 并把 UNIX套接字 更改为 TCP端口
禁用捆绑的Nginx
vim /etc/gitlab/gitlab.rb

将
nginx['enable'] = true
修改为
nginx['enable'] = false
并去掉注释 (前边的#)
允许gitlab-workhorse监听TCP（默认端口8181），编辑/etc/gitlab/gitlab.rb:

gitlab_workhorse['listen_network'] = "tcp"
gitlab_workhorse['listen_addr'] = "127.0.0.1:8181"
运行 sudo gitlab-ctl reconfigure 使更改生效。

通过系统原本安装的Nginx反代以便提供访问
$ vim /etc/nginx/conf.d/gitlab.conf 
server {
    listen       80;
    server_name  gitlab.edevops.top;

    location / {
        root  html;
        index index.html index.htm;
        proxy_pass http://127.0.0.1:8181;
    }
}

systemctl restart nginx
访问：http://gitlab.edevops.top 即可

参考

方案三：通过Docker安装Gitlab实现环境完全隔离
docker安装gitlab官方文档

原文链接

作者：Evan_Vivian
链接：https://www.jianshu.com/p/123778a515ca
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。