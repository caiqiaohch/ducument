nginx与php-fpm 连接数


Apache连接请求机制

![](https://shadowdragons.github.io/assets/img/posts/2018-08-11-php-nginx-connect/1.png)

Apache的处理机制是每有一个请求就会去fork一个子进程来处理请求。
这样带来的缺点很明显： 当请求量大的时候，需要开启一样数量的进程，这样一来系统内存的消耗，二来cpu执行切换带来的上下文切换消耗非常大。

Nginx是如何解决这些问题的呢？答案是使用I/O复用技术。 下面只是简单讲解什么是I/O复用，有兴趣的同学可以参考I/O模型

Nginx使用的I/O复用技术
初级I/O复用
采用非阻塞的模式，当一个连接过来时，我们不阻塞住，这样一个进程可以同时处理多个连接了。 比如一个进程接受了10000个连接，这个进程每次从头到尾的问一遍这10000个连接：“有I/O事件没？有的话就交给我处理，没有的话我一会再来问一遍。” 然后进程就一直从头到尾问这10000个连接，如果这1000个连接都没有I/O事件，就会造成CPU的空转，并且效率也很低，不好不好。

升级I/O复用（select、poll）
我们能不能引入一个代理，这个代理可以同时观察许多I/O流事件呢？
当没有I/O事件的时候，这个进程处于阻塞状态。当连接有I/O流事件产生的时候，就会去唤醒进程去处理。

但是唤醒之后，因为不知道是哪个连接产生的I/O流事件，于是进程就挨个去问：“请问是你有事要处理吗？”。

ps: select与poll原理是一样的，只不过select只能观察1024个连接，poll可以观察无限个连接。

超级升级I/O复用（epoll）
有了epoll，可以知道是哪个连接产生的I/O流事件。理论上1个进程就可以无限数量的连接，而且无需轮询，真正解决了c10k的问题。

nginx就是采用基于epoll的异步非阻塞服务器程序。

nginx与php-fprm的连接处理


![](https://shadowdragons.github.io/assets/img/posts/2018-08-11-php-nginx-connect/2.png)



nginx
worker为epoll异步处理请求。

worker_processes	worker数量
worker_connections	每个worker能处理的最大并发连接请求
php-fpm
worker为poll异步处理请求。众多的 worker 进程组成了进程池，等待 master 进程分配任务，而且每个 worker 进程只能同时处理单个任务，前一个处理结束，才能为下一个服务。

pm	分为静态(static)和动态(dynamic)
pm.max_children	static模式下创建的子进程数(固定)
pm.start_servers	动态方式下的起始worker进程数量
pm.min_spare_servers	动态方式下服务器空闲时最小worker进程数量
pm.max_spare_servers	动态方式下服务器空闲时最大worker进程数量
超时设置
nginx
fastcgi_connect_timeout	后端链接时间
fastcgi_send_timeout	数据发送时间，两次成功发送时间差，不是整个发送时间
fastcgi_read_timeout	数据接收时间，两次成功接收时间差，不是整个接收时间
php-fpm
request_terminate_timeout	PHP脚本的最大执行时间
php
max_execution_time	PHP脚本的最大执行时间
ps:一些版本中php-fpm的配置会覆盖php.ini的配置，使php.ini的配置不起作用

常见错误
1.502 Connection reset by peer

php-fpm的worker进程执行php程序脚本时，超过了配置的最长执行时间，master进程将worker进程杀掉，直接返回502。

2.502 Connection refused

连接请求数(accpet之前)超出了端口所能监听的tcp连接的最大值(backlog的值)，进不了fpm等待accept的链接队列，直接返回502，这里可能会产生tcp重传。

backlog的值是半连接和全连接的总和，他的存在也有短时间缓冲解耦nginx请求与fpm处理的作用，半连接指收到了syn请求，3次握手尚未建立，全连接指的是3次握手已经成功，不过尚未被accpet的请求，fpm里面有调节的参数，如果fpm的参数设置为-1，则默认走的是系统内核参数net.core.somaxconn的设置值，如果不设置可以在/proc/sys/net/core/somaxconn里查看，默认值是128，所以在连接请求较高的业务里要增大这个值。

3.504 Connection timed out

php的worker进程池处理慢，无法尽快处理等待accept的链接队列，导致3次握手后的链接队列长时间没有被accept，nginx链接等待超时;
后端php-fpm执行脚本的时间太长，超过了nginx配置的超时机制，这个时候也是会报出504错误的。
参考
nginx、swoole高并发原理初探
WebService之nginx+(php-fpm)结构模型剖析及优化