#  Go语言之讲解GOROOT、GOPATH、GOBIN

Go是一门全新的静态类型开发语言，具有自动垃圾回收，丰富的内置类型,函数多返回值，错误处理，匿名函数,并发编程，反射等特性．

go命令依赖一个重要的环境变量：$GOPATH 
GOPATH允许多个目录，当有多个目录时，请注意分隔符，多个目录的时候Windows是分号;

当有多个GOPATH时默认将go get获取的包存放在第一个目录下 
$GOPATH目录约定有三个子目录

    src存放源代码(比如：.go .c .h .s等)   按照golang默认约定，go run，go install等命令的当前工作路径（即在此路径下执行上述命令）。
    pkg编译时生成的中间文件（比如：.a）　　golang编译包时
    bin编译后生成的可执行文件（为了方便，可以把此目录加入到 $PATH 变量中，如果有多个gopath，那么使用${GOPATH//://bin:}/bin添加所有的bin目录）

代码目录结构规划

GOPATH下的src目录就是接下来开发程序的主要目录，所有的源码都是放在这个目录下面，那么一般我们的做法就是一个目录一个项目，

例如: $GOPATH/src/mymath 表示mymath这个应用包或者可执行应用，这个根据package是main还是其他来决定，main的话就是可执行应用，其他的话就是应用包，这个会在后续详细介绍package。


首先看下我的go环境：go env
复制代码

C:\Users\Administrator>go env
set GOARCH=amd64
set GOBIN=
set GOEXE=.exe
set GOHOSTARCH=amd64
set GOHOSTOS=windows
set GOOS=windows
set GOPATH=D:\project
set GORACE=
set GOROOT=D:\BaiduNetdiskDownload\go
set GOTOOLDIR=D:\BaiduNetdiskDownload\go\pkg\tool\windows_amd64
set GCCGO=gccgo
set CC=gcc
set GOGCCFLAGS=-m64 -mthreads -fmessage-length=0
set CXX=g++
set CGO_ENABLED=1
set CGO_CFLAGS=-g -O2
set CGO_CPPFLAGS=
set CGO_CXXFLAGS=-g -O2
set CGO_FFLAGS=-g -O2
set CGO_LDFLAGS=-g -O2
set PKG_CONFIG=pkg-config

复制代码
GOROOT

其实就是golang 的安装路径
当你安装好golang之后其实这个就已经有了
GOBIN

首先看一下结构：

我们通常是在project目录下执行go build,例如:

D:\project\src\go_dev\day1\package_example\main>go run main.go
400 100

现在需要编译main.go，golang 会自动去src下找hello目录，因为我的main.go中代码的开通导入了packag main包，所以可以编译成可执行文件，但是这样默认在当前目录下生成可执行文件,虽然可以指定目录，但是还是感觉不是非常方便

d:\project>go build go_dev/day1/package_example\main

 

所以还有两个非常好用的命令：go get 和go install
go get

go get会做两件事：
1. 从远程下载需要用到的包
2. 执行go install
go install

go install 会生成可执行文件直接放到bin目录下，当然这是有前提的
你编译的是可执行文件，如果是一个普通的包，会被编译生成到pkg目录下该文件是.a结尾


关于go的整体一个开发目录
复制代码

go_project     // go_project为GOPATH目录
  -- bin
     -- myApp1  // 编译生成
     -- myApp2  // 编译生成
     -- myApp3  // 编译生成
  -- pkg
  -- src
     -- myApp1     // project1
        -- models
        -- controllers
        -- others
        -- main.go 
     -- myApp2     // project2
        -- models
        -- controllers
        -- others
        -- main.go 
     -- myApp3     // project3
        -- models
        -- controllers
        -- others
        -- main.go 

复制代码
Linux下配置go环境
复制代码

1、首先下载linux下的go包：https://studygolang.com/dl/golang/go1.9.2.linux-amd64.tar.gz
2、下载之后 

tar -zxvf go1.9.2.linux-amd64.tar.gz 解压源码包

3、移动到 /usr/local/go 也就是GOROOT

4、设置GOPATH，还有PATH环境变量

export GOROOT=/usr/local/go #设置为go安装的路径
export GOPATH=$HOME/gocode #默认安装包的路径
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

复制代码
查看Linux go env
复制代码

GOARCH="amd64"
GOBIN=""
GOEXE=""
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOOS="linux"
GOPATH="/root/gocode"
GORACE=""
GOROOT="/usr/local/go"
GOTOOLDIR="/usr/local/go/pkg/tool/linux_amd64"
GCCGO="gccgo"
CC="gcc"
GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build057487015=/tmp/go-build -gno-record-gcc-switches"
CXX="g++"
CGO_ENABLED="1"
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"