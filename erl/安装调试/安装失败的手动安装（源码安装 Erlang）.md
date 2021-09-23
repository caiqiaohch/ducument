# 1 安装失败的手动安装（源码安装 Erlang）

```
1.0 下载
wget http://erlang.org/download/otp_src_20.0.tar.gz
1.1 使用yum安装下必须的配件：
yum install gcc glibc-devel make ncurses-devel openssl-devel autoconf
yum install unixODBC unixODBC-devel
1.2 安装
tar -zxvf otp_src_20.0.tar.gz
cd otp_src_20.0
```



```
# ./configure --with-ssl=/opt/ssl/ --prefix=/opt/erlang 

./configure --with-ssl=/opt/ssl/ --prefix=/usr/lib/erlang --enable-hipe --enable-threads --enable-smp-support --enable-kernel-poll
1.2.1 这步可能会出现提示提示缺少的组件，详情见常见问题 （文章末尾有原作者有链接）
make && make install 
ln -s /usr/lib/erlang/bin/erl /usr/local/bin/


1.3 设置环境变量
vim ~/.bashrc
export PATH=/usr/lib/erlang/bin:$PATH
1.4 验证
```



# 能够输出 erlang erlc 的路径，可以进入 erl
```
whereis erlang
whereis erlc
erl
```

