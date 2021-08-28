CentOS6下编译Erlang R15B with wxWidgets

如果不需要安装 wxWidgets 的话，很简单， ./configure & make & make install 。但是装起来后，发现 Erlang 的 debugger 无法启动，显示“ ERROR: Could not find 'wxe_driver.so' in: /usr/local/lib/erlang/lib/wx-0.99.1/priv ”，虽说不使用 debugger 也问题不大，不过有时候调个小程序什么的还是不方便，随决定把 wxWidgets 安装一下。

 

         在没有安装 wxWidgets 以前， config 这一步会显示： “ wx: wxWidgets not found, wx will NOT be usable ” 。

OK ，那先下载了 wxWidgets 2.8.12 ，再默认编译，安装，没问题。

再来一次 config ，还是一样的提示： “ wx: wxWidgets not found, wx will NOT be usable ” ，头大，为什么呢？折腾了好久，什么使用 LD_LIBRARY_PATH 了等等，问题还是一样。

最后在 erlang-question 一个 thread 上看到，可以查看 OPT_ROOT/lib/wx 下的 config 日志，看看到底是什么问题（其实这才是正道，前面的折腾都是瞎搞，没抓住重点）。

查看日志后，发现， config 在调用 wxWidgets 的 wx-config 验证当前 wxWidgets 的版本时，发现版本不匹配。立马检查： wx-config –version ，输出 2.8.12 ，没问题啊。那再检查下 config 使用的什么命令： wx-config –unicode –debug … 等，拷贝到命令行， enter ，一堆提示，总体一句话：需要的特性未安装。

再回到 wxWidgets 的配置程序， configure –help 后发现，跟 unicode, debug 相关的两个选项： --enable-debug --enable-unicode 。好， wxWidgets 再编译一次，然后再配置Erlang，这次不提示“ wx: wxWidgets not found, wx will NOT be usable ”了，提示：“ wx: Can not link the wx driver, wx will NOT be useable ”。再检查日志，发现 wxWidgets 的 GL 相关库找不到。

再编译 wxWidgets ，使用选项： ./configure --with-opengl --enable-debug --enable-unicode 。然后 wxWidgets 配置程序提示 OpenGL 相关库找不到，呃，再安装 Linux 的 OpenGL 相关库（ mesa ），然后再编译 wxWidgets ，没问题。

再重新编译配置 Erlang ， OK ， wxWidgets 没问题了。

启动 erl ，再 debugger:start() ， OK 。