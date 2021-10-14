Logs 
使用控制台实时查看logs 
我们可以用gitlab-ctl tail 命令查看实时log。

# 查看所有的logs; 按 Ctrl-C 退出
sudo gitlab-ctl tail
# 拉取/var/log/gitlab下子目录的日志
sudo gitlab-ctl tail gitlab-rails
# 拉取某个指定的日志文件
sudo gitlab-ctl tail nginx/gitlab_error.log
Runit logs 
Runit-managed是一个跨平台的用来取代Linux系统默认的服务控制的一个init系统， 想要了解更多知识，请自行搜索runit及sysvinit的相关信息。

omnibus-gitlab生成logs用的Runit-managed服务是svlogd， 关于svlogd的详细介绍， 请查看svlogd documentation。

修改/etc/gitlab/gitlab.rb文件里面如下参数可以自定义svlogd:

# 下面的参数均为默认值
logging['svlogd_size'] = 200 * 1024 * 1024 # 切割超过200M的日志文件
logging['svlogd_num'] = 30 # 日志文件保留30天
logging['svlogd_timeout'] = 24 * 60 * 60 # 每24 hours生成新一天的日志
logging['svlogd_filter'] = "gzip" # 使用gzip压缩日志
logging['svlogd_udp'] = nil # 使用UDP协议传输日志
logging['svlogd_prefix'] = nil # 自定义日志信息的prefix

# 可以修改prefix,如修改为nginx
nginx['svlogd_prefix'] = "nginx"
Logrotate日志管理 
Omnibus-gitlab从7.4版本开始内置了logrotate服务。 这个服务用来切割、 压缩并最终删除已不受Runit服务(即上节里面的svlogd)控制的日志文件， 如gitlab-rails/production.log、nginx/gitlab_access.log。 你可以根据需求修改/etc/gitlab/gitlab.rb中logrotate的参数。

# 下面的参数均为默认值
logging['logrotate_frequency'] = "daily" # 每天切割一次日志
logging['logrotate_size'] = nil # 不按照默认值的大小切割日志
logging['logrotate_rotate'] = 30 # 日志文件保留30天
logging['logrotate_compress'] = "compress" # 使用'man logrotate'查看详情
logging['logrotate_method'] = "copytruncate" # 使用'man logrotate'查看详情
logging['logrotate_postrotate'] = nil # 默认没有postrotate(切割后执行的)命令
logging['logrotate_dateformat'] = nil # 指定日志文件名格式(默认是数字表示)，比如该值修改为 "-%Y-%m-%d" ，那么切割的日志文件名为 production.log-2016-03-09.gz


# 单个服务的设置会覆盖全局设置，如修改Nginx的logrotate配置
nginx['logrotate_frequency'] = nil
nginx['logrotate_size'] = "200M"

# 当然你也可以任性的禁用内置的logrotate服务
logrotate['enable'] = false
UDP log shipping (GitLab Enterprise Edition only) 
Omnibus-gitlab企业版可以配置使用UDP传输syslog-ish日志信息。

logging['udp_log_shipping_host'] = '1.2.3.4' # syslog服务器地址
logging['udp_log_shipping_port'] = 1514 # 可选，默认端口514 (syslog)
log messages实例:

<code style="font-family:Menlo, 'Liberation Mono', Consolas, 'DejaVu Sans Mono', 'Ubuntu Mono', 'Courier New', 'Andale Mono', 'Lucida Console', monospace;font-size:14px;border-color:transparent;color:inherit;background-color:transparent;" class="hljs"><13>Jun 26 06:33:46 ubuntu1204-test production.log: Started GET "/root/my-project/import" for 127.0.0.1 at 2014-06-26 06:33:46 -0700
<13>Jun 26 06:33:46 ubuntu1204-test production.log: Processing by ProjectsController#import as HTML
<13>Jun 26 06:33:46 ubuntu1204-test production.log: Parameters: {"id"=>"root/my-project"}
<13>Jun 26 06:33:46 ubuntu1204-test production.log: Completed 200 OK in 122ms (Views: 71.9ms | ActiveRecord: 12.2ms)
<13>Jun 26 06:33:46 ubuntu1204-test gitlab_access.log: 172.16.228.1 - - [26/Jun/2014:06:33:46 -0700] "GET /root/my-project/import HTTP/1.1" 200 5775 "https://172.16.228.169/root/my-project/import" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36"
2014-06-26_13:33:46.49866 ubuntu1204-test sidekiq: 2014-06-26T13:33:46Z 18107 TID-7nbj0 Sidekiq::Extensions::DelayedMailer JID-bbfb118dd1db20f6c39f5b50 INFO: start

2014-06-26_13:33:46.52608 ubuntu1204-test sidekiq: 2014-06-26T13:33:46Z 18107 TID-7muoc RepositoryImportWorker JID-57ee926c3655fcfa062338ae INFO: start

</code>
Using a custom NGINX log format 
Nginx的access日志默认使用'combined'格式化日志， 查看nginx日志格式。 如果你想用自定义日志的格式， 修改/etc/gitlab/gitlab.rb 文件如下的参数:

<code style="font-family:Menlo, 'Liberation Mono', Consolas, 'DejaVu Sans Mono', 'Ubuntu Mono', 'Courier New', 'Andale Mono', 'Lucida Console', monospace;font-size:14px;border-color:transparent;color:inherit;background-color:transparent;" class="hljs">nginx['log_format'] = 'my format string $foo $bar'
mattermost_nginx['log_format'] = 'my format string $foo $bar'</code>
相关资源：Gitlab备份和恢复操作记录(个人精华版)_gitlab日志查看,gitlab...
————————————————
版权声明：本文为CSDN博主「douglas8287」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/douglas8287/article/details/84880261