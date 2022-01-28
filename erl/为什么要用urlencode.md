有時候urlencode用在回調地址那裡.
例如一個接口,你傳送過去時,需要帶上你這邊的回調地址,也是個url. 這樣你不能url+url傳送,需要一個urlencode把回調地址編碼,防止發生問題.
例如:微信的一個接口

```pf
https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect
```

REDIRECT_URI 這裡應該填你的服務器回調地址.正常寫法如 http://api.baidu.com/callback.php

那麼生成的接口就是

```awk
https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=http://api.baidu.com/callback.php&response_type=code&scope=SCOPE&state=STATE#wechat_redirect
```

這樣訪問肯定出問題...
那麼`http://api.baidu.com/callback.php` 這個回調地址,就要urlencode后再放到地址中發送.

```perl
https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=http%3A%2F%2Fapi.baidu.com%2Fcallback.php&response_type=code&scope=SCOPE&state=STATE#wechat_redirect
```

這樣傳就沒問題了!

[回复](https://segmentfault.com/q/1010000002991580###)

[**whosesmile**](https://segmentfault.com/u/whosesmile)：

[回复](https://segmentfault.com/q/1010000002991580###)2015-07-16

[**yang123guo**](https://segmentfault.com/u/yang_faith)：

[回复](https://segmentfault.com/q/1010000002991580###)2018-12-10

**1**

[![img](https://avatar-static.segmentfault.com/387/044/3870447111-5673aedad6338_big64)**justjavac**](https://segmentfault.com/u/justjavac)

- **47.5k**

[发布于 2015-07-15](https://segmentfault.com/q/1010000002991580/a-1020000002991598)

因为 url 对字符有限制，比如把一个邮箱放入 url，就需要使用 `urlencode` 函数，因为 url 中不能包含 `@` 字符。

[回复](https://segmentfault.com/q/1010000002991580###)

[**我只是一个菜鸟**](https://segmentfault.com/u/13sd)：

[回复](https://segmentfault.com/q/1010000002991580###)2015-07-15

[**justjavac**](https://segmentfault.com/u/justjavac)：

[回复](https://segmentfault.com/q/1010000002991580###)2015-07-15

**1**

[![img](https://avatar-static.segmentfault.com/318/840/318840155-54cb5939d1e90_big64)**whosesmile**](https://segmentfault.com/u/whosesmile)

- **2k**

[发布于 2015-07-15](https://segmentfault.com/q/1010000002991580/a-1020000002991834)

常用的场景我用过的：

假设你的网站希望采用rest风格的路由来做搜索引擎优化：

```awk
http://www.somesite.com/tag/:name
```

上面的业务是根据某个tag名称，来呈现对应的页面，但是url中是不允许有中文出现的，所以如果我的
name是：

```awk
http://www.somesite.com/tag/美女与野兽
```

那么我需要urlencode一下。

PS：现代浏览器几乎都支持中文直接显示，那是因为浏览器帮你做了encode的事情，但是老版本的IE，例如IE6等不会，例如你可以在chrome中直接输入中文url，但是你不能通过命令执行

```nginx
curl some_url_contain_中文
```

**你可以看看segmentfault的tag系统，你查看源码，看下中文tag的url。**

[回复](https://segmentfault.com/q/1010000002991580###)