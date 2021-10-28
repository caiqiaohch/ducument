# 定时器(timer)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

7 人赞同了该文章

自8.0版本起，包含+timers特性的Vim提供了定时器功能。利用定时器，可以在指定延时之后触发指定操作，也可以按照固定的时间间隔来重复执行任务。

## 启动定时器

使用timer_start()函数，可以启动定时器并返回定时器ID：

```vim
timer_start({time}, {callback} [, {options}])
```

其中：

- time，指定时间间隔，单位为毫秒（milliseconds）；
- callback，指定需要触发的回调函数；
- options，是包含多个键值的字典选项，用于配置和控制定时器的行为

## 定时器选项

使用"repeat"选项，可以控制执行回调函数的次数。缺省为执行"1"次。如果希望无限循环执行，那么可以将此值设置为"-1"。

使用以下命令，设置在[状态行](https://link.zhihu.com/?target=http%3A//yyq123.blogspot.com/2009/10/vim-statusline.html)中显示时间：

```vim
set laststatus=2
if has("win32")
    set statusline=%{strftime(\"%I:%M:%S\ \%p,\ %a\ %b\ %d,\ %Y\")}
else
    set statusline=%{strftime(\"%l:%M:%S\ \%p,\ %a\ %b\ %d,\ %Y\")}
endif
```

自定义以下函数，用于更新状态行：

```vim
function! UpdateStatusBar(timer)
    execute 'let &ro = &ro'
endfunction
```

使用以下命令启动定时器，回调函数将持续更新状态行的时间显示：

```vim
:let timer = timer_start(3000, 'UpdateStatusBar',{'repeat':-1})
```

## 定时器信息

使用不带参数的timer_info()函数，可以获取所有定时器的信息：

```vim
:echo timer_info()
```

![img](https://pic3.zhimg.com/80/v2-19b4beb2715d88098f2a4a25680c6afe_720w.jpg)

使用带有ID参数的timer_info()函数，可以获取指定定时器的信息：

```vim
:echo timer_info(timer)
```

函数返回包含详细信息的字典：

![img](https://pic2.zhimg.com/80/v2-234c1e0ac8e60ecc86a76fefa8168c65_720w.jpg)

## 暂停定时器

使用timer_pause()函数，并指定第二个参数为非0数值或非空字符串，可以暂停定时器：

```vim
:call timer_pause(timer,1)
```

使用timer_pause()函数，并指定第二个参数为数值0或空字符串，可以对定时器取消暂停：

```vim
:call timer_pause(timer,0)
```

## 取消定时器

假设启动以下定时器，将在指定延时之后强制退出Vim：

```vim
:let timer_id = timer_start(10000, {id -> execute('quit!')})
```

使用timer_stop()函数，可以取消指定定时器：

```vim
:call timer_stop(timer_id)
```

使用timer_stopall()函数，可以取消所有定时器：

```vim
:call timer_stopall()
```

## 定时器实例

假设当前脚本文件中包含以下代码：

```vim
let s:timeouts = [5000, 10000, 30000, 1000, 1000, 3200, 500, 700]

function! s:noop(timer_id)
    let s:timeouts = insert(s:timeouts, remove(s:timeouts, len(s:timeouts) - 1))
    normal dd
   call timer_start(s:timeouts[0], function('<SID>noop'))
endfunction

call s:noop(0)
```

使用以下命令执行当前脚本，将从当前行开始，按照设定的时间间隔逐行删除文本：

```vim
:so %
```

**？**使用以下命令，可以查看关于定时器的帮助信息：

```vim
:help timer
```

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-job.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-channel.html)>

编辑于 2020-11-30