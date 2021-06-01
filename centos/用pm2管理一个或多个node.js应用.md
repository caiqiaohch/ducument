用pm2管理一个或多个node.js应用

0.目标
在《http-proxy反向代理以调度服务器各app》 中，我们谈到了域名解析过来后应用调度问题；除此之外，在部署了多个node.js应用后，我们还会面临多个应用管理不方便、需要来回切换命令行的窘境。

为了解决这个问题，我决定使用pm2来管理所有node.js应用。

1.安装
安装pm2很简单，执行下面指令即可：

npm install pm2@latest -g
注意，-g 意味着这是一个全局的，和 supervisor 、 express 一样，在安装完毕后，可以在全局使用该指令。另外，这里的 @latest 可以不写。

2.用pm2启动一个应用
需要明白的是，pm2是一个全局的指令，我们可以在任何目录中使用它。

举个例子，我有三个应用，分别放在C盘的不同文件夹里：

C:\node1
C:\node2
C:\node3
那么，我们就可以分别进入这两个目录，并使用pm2来启动这两个应用。注意到，我们启动一个node应用，一般是

node app.js
// 或
supervisor app.js
那么使用pm2，则分别进入这三个应用中，执行下面命令：

pm2 start app.js

// 在Express中，会这么做
pm2 start bin/www
当然，作为追求高效便捷的程序员，我们一定会想有没有更快捷的方法，能不能写个依赖文件直接自动配置。答案是，当然有！不过，这部分内容已经属于更高级的内容，我不打算在这篇文章中写出。可以参考这里： Process File

3.pm2管理应用
下面给出了一些主要的命令：

# Fork mode
$ pm2 start app.js --name my-api # Name process


# Cluster mode
$ pm2 start app.js -i 0        # Will start maximum processes with LB depending on available CPUs
$ pm2 start app.js -i max      # Same as above, but deprecated yet.


# Listing
$ pm2 list               # Display all processes status
$ pm2 jlist              # Print process list in raw JSON
$ pm2 prettylist         # Print process list in beautified JSON

$ pm2 describe 0         # Display all informations about a specific process

$ pm2 monit              # Monitor all processes


# Logs
$ pm2 logs [--raw]       # Display all processes logs in streaming
$ pm2 flush              # Empty all log file
$ pm2 reloadLogs         # Reload all logs


# Actions
$ pm2 stop all           # Stop all processes
$ pm2 restart all        # Restart all processes

$ pm2 reload all         # Will 0s downtime reload (for NETWORKED apps)
$ pm2 gracefulReload all # Send exit message then reload (for networked apps)

$ pm2 stop 0             # Stop specific process id
$ pm2 restart 0          # Restart specific process id

$ pm2 delete 0           # Will remove process from pm2 list
$ pm2 delete all         # Will remove all processes from pm2 list


# Misc
$ pm2 reset <process>    # Reset meta data (restarted time...)
$ pm2 updatePM2          # Update in memory pm2
$ pm2 ping               # Ensure pm2 daemon has been launched
$ pm2 sendSignal SIGUSR2 my-app # Send system signal to script
$ pm2 start app.js --no-daemon
$ pm2 start app.js --no-vizion
$ pm2 start app.js --no-autorestart
* 资料来源： http://pm2.keymetrics.io/docs/usage/quick-start/

3.1 用 pm2 list 来查看正在运行的应用名称和id
先说说用pm2启动了一个应用后，我们能做什么。

使用 pm2 list，我们可以看到所有已经启动的应用：

启动的应用
可以看到，我一共启动了两个应用，其App name分别是onelib_node和www，其id分别为1和2。

有了这两个参数，我们就可以分别对它们进行进一步的操作了。

3.2 用 pm2 logs 来查看应用的记录
使用这个命令后，我们可以查看所有记录：

记录
我们还可以用 pm2 flush来清空所有的记录。

3.3 用 pm2 describe id 来查看制定应用的状态
指令中的 id 即我们用pm2 list命令看到的应用id，通过id来指定需要查看的应用。

查看应用状态
3.4 关闭、重启应用
要关闭所有的应用，可以：

pm2 stop all
要重启所有的应用，可以：

pm2 restart all
如果我们想要关闭某一个应用，只需要指定其id即可：

pm2 stop id
同样地，如果我们想要重启某一个应用，只需要指定其id即可：

pm2 restart id
3.5 删除应用
我们在关闭一个应用后，使用 pm2 list 仍能查找到它，显示 stopped 状态。有时候，我们要删除某个应用，并且不再希望看到它。这种情况，我们可以使用删除命令：

pm2 delete id
如果要删除所有应用，则：

pm2 delete all
4. 用 watch模式启动应用
在之前的文章中，我介绍了supervisor在开发过程中的作用：我们在修改了代码后，不需要重启服务就能自动更新。

那么，作为更加强大的pm2，是否也能做得呢？答案是当然可以！

这需要我们在启动服务的时候，在后面加上 --watch 来启动监控代码是否变化。通过这种方式启动的应用，在其文件夹内的文件有更改时，会自动更新。

watch模式
从上图可以看到，watching参数已经置为 enabled 了（原来是灰色的disabled ）

需要特别注意的是：一旦使用 watch 模式启动服务，就不能再通过 pm2 stop id 来关闭它了。相应的，我们也要加上 --watch 参数：

pm2 stop --watch id
更多资料，请参考：http://pm2.keymetrics.io/docs/usage/watch-and-restart/

5.监控服务
要查看开启的应用的运行状态，可以使用这个命令：

pm2 monit
由于我实在没法模拟得这么形象，只好从 PM2 盗个图来了：

示例
6.未完待续
pm2的功能远不止这些，从它的官网上看，还有很多的高级功能等我们去使用。在后续的工作中，如果有更好的使用场景和方法，我仍然会在这里作出更新，以分享给大家。

最后，推荐大家多看看pm2的官网，这里有更详细的说明： http://pm2.keymetrics.io/

作者：Mike的读书季
链接：https://www.jianshu.com/p/65ebb4ca70d3
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。