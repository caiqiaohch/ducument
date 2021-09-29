gitlab修改默认端口

部署gitlab的时候，一启动，发现80和8080端口已经被占用，无奈，只得先将监听80端口的nginx和监听8080端口的jenkins停止。这会儿有空，琢磨一下如何修改gitlab的默认端口。

修改主要分为两部分，一部分是gitlab总的控制文件，一部分是子模块真实监听端口的修改。

当前我使用的是官方rpm 813版本。

gitlab.rb修改
FTP::192.168.58.222\//etc/gitlab|gitlab.rb
配置文件在/opt/gitlab/etc/gitlab.rb。这个文件用于gitlab如何调用80和8080的服务等。
## Advanced settings
unicorn['listen'] = '127.0.0.1'
unicorn['port'] = 8082

nginx['listen_addresses'] = ['*']
nginx['listen_port'] = 82 # override only if you use a reverse proxy: https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/settings/nginx.md#setting-the-nginx-listen-port

gitlab-rails修改
配置文件/var/opt/gitlab/gitlab-rails/etc/unicorn.rb
# What ports/sockets to listen on, and what options for them.
#listen "127.0.0.1:8080", :tcp_nopush => true
listen "127.0.0.1:8082", :tcp_nopush => true
listen "/var/opt/gitlab/gitlab-rails/sockets/gitlab.socket", :backlog => 1024

gitlab nginx 修改
配置文件 /var/opt/gitlab/nginx/conf/gitlab-http.conf。这个文件是gitlab内置的nginx的配置文件，里面可以影响到nginx真实监听端口号。
server {
  listen *:82;
 
  server_name gitlab.123.123.cn;
  server_tokens off; ## Don't show the nginx version number, a security best practice

修改完成后，重启下，就可以放82端口的gitlab了。
gitlab-ctl restart
1
1
OS nginx修改
如果还是想从80端口访问gitlab，我们可以用监听在80端口的nginx做一个反向代理。service nginx restart后可以正常访问。
server {
    listen 80;
    server_name gitlab.123.123.cn;
 
    location / {
        #rewrite ^(.*) http://127.0.0.1:8082;
        proxy_pass http://127.0.0.1:8082;
    }
}

giltab-shell修改
后来在提交的时候，出现了错误：



找了关于8080端口的相关信息，最后发现

配置文件：/var/opt/gitlab/gitlab-shell

修改成

# GitLab user. git by default
user: git
 
# Url to gitlab instance. Used for api calls. Should end with a slash.
#gitlab_url: "http://127.0.0.1:8080"
gitlab_url: "http://127.0.0.1:82" ## 关键是这个地方，因为82是gitlab nginx端口，不过上面的端口干嘛是8080来，8080应该是unicorn的监听端口。

