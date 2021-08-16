# erlang 调试

1.加打印记录



```php
-ifdef(debug).
-define(LOG(X), io:format("pid:~p , {~p,~p}: ~p~n", [self(), ?MODULE, ?LINE, X])).
-else.
-define(LOG(X), true).
-endif.
```

设置LOG的宏定义，调试只要在代码中加入?LOG(Val)，就可以
 2.使用erlang debugger
 加入debug_info来编译.erl文件，没有加debug_info无法使用调试工具，比如



```swift
c(test_mnesia,debug_info). 
```

当输入im()时，会自动打开一个Monitor 窗口



```undefined
im().
```

![img](https:////upload-images.jianshu.io/upload_images/16255509-b2990c4c8dd44a89.png?imageMogr2/auto-orient/strip|imageView2/2/w/883/format/webp)

选择要调试的代码：选择Module--> Interpret



![img](https:////upload-images.jianshu.io/upload_images/16255509-a46944d604ca8c73.png?imageMogr2/auto-orient/strip|imageView2/2/w/784/format/webp)

双击文件进入代码设置断点



![img](https:////upload-images.jianshu.io/upload_images/16255509-e1bc09502bf48f7c.png?imageMogr2/auto-orient/strip|imageView2/2/w/864/format/webp)

![img](https:////upload-images.jianshu.io/upload_images/16255509-e6909ab002b83d37.png?imageMogr2/auto-orient/strip|imageView2/2/w/877/format/webp)

断电只需要再需要调试的那一行双击就好了，他会再那一行标记一个红点



![img](https:////upload-images.jianshu.io/upload_images/16255509-c1858608ad7903ba.png?imageMogr2/auto-orient/strip|imageView2/2/w/844/format/webp)

erlang shell执行操作，Monitor 窗口会出现你设置了断点的进程，点进去可以看到当前执行到了那一步（颜色时绿色的那一行），并且结果是什么，可以连续点击Next按钮直到执行结束，可以查看到整个代码执行步骤和每一步的结果



![img](https:////upload-images.jianshu.io/upload_images/16255509-15c8d95abbc40837.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

执行完毕后erlang shell出现结果  Monitor窗口变空



![img](https:////upload-images.jianshu.io/upload_images/16255509-bd8788a8c3d01905.png?imageMogr2/auto-orient/strip|imageView2/2/w/1065/format/webp)



0人点赞



[erlang]()