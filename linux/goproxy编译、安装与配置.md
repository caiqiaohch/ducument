# goproxy编译、安装与配置

最近刚入门了go语言的基础语法等内容，为了更加深入学习go语言，也由于本人对网络协议方面比较感兴趣，于是，便看起了goproxy这个开源项目。

     项目地址：https://github.com/snail007/goproxy
    
     然而，在使用上边的自动安装/半自动安装脚本进行安装脚本时，由于网络的问题，压缩包总是一直下载 不下来。于是，边打算自己编译安装。
    
    步骤如下：
    
             1. 将项目文件夹copy到$GOPATH/src/github.com/snail007/goproxy目录下。
    
             2. 使用go build github.com/snail007/goproxy进行编译（本人go语言版本1.8，系统为ubuntu14.04）。
    
          3. 使用go install github.com/snail007/goproxy进行安装。安装后可以看到，在$GOPATH/bin目录下就能看到goproxy应用啦。
    
             4. 进入到goproxy的源码根目录，运行以下脚本。

cp $GOPATH/bin/goproxy /usr/bin/
chmod +x /usr/bin/goproxy
if [ ! -e /etc/proxy ]; then
    mkdir /etc/proxy
    cp blocked /etc/proxy
    cp direct  /etc/proxy
fi

if [ ! -e /etc/proxy/proxy.crt ]; then
    cd /etc/proxy/
    goproxy keygen >/dev/null 2>&1
fi
rm -rf /tmp/proxy

          然后goproxy就可以运行啦。
    
          另外，分享一个坑，gopacket貌似要go1.8以上才能编译？哭
    
          再另外，目测接下来会开启一个goproxy源码走读系列（争取吧）
---------------------
作者：zrunningz 
来源：CSDN 
原文：https://blog.csdn.net/zrunningz/article/details/80238330 
版权声明：本文为博主原创文章，转载请附上博文链接！