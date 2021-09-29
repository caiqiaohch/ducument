# [CentOS7通过yum安装gdb8 gcc8 g++8的方法](https://www.cnblogs.com/clwsec/p/12493653.html)

### 前言

想使用CLion进行远程调试，但是发现CLion需求的remote debug用的GDB版本`7.8.x-8.2.x` ，并不能满足（CentOS7默认yum装的是`7.6`），所以需要给CentOS7装个新版本的GDB

### 安装

1.添加上`CentOS SCLo RH`库，装上`gdb8`的依赖`devtoolset-8-build`

```
sudo yum install centos-release-scl-rh
sudo yum install devtoolset-8-build
```

2.安装相应的gdb

```
sudo yum install devtoolset-8-gdb
```

3.同样，也可以安装相应版本的`gcc`个`g++`

```
sudo yum install devtoolset-8-gcc devtoolset-8-gcc-c++
```

4.yum安装完后，原来的`gcc`不覆盖，所以需要执行`enable`脚本更新环境变量

```
sudo source /opt/rh/devtoolset-8/enable
```

5.可以通过加入到profile里面开机自动source, `vim /etc/profile`, 跳到最后一行加入以下内容

```
source /opt/rh/devtoolset-8/enable
```

6.结束

### 参考：

1.https://blog.k-res.net/archives/2449.html
2.https://blog.csdn.net/u012453838/article/details/85286810