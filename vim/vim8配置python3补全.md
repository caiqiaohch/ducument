## [vim8配置python3补全](https://www.cnblogs.com/tmdhhl/p/10712799.html)

## 安装Python3

### 卸载编译安装的python3

```
rm -rf /usr/local/lib/python3.7/
rm -rf /usr/local/bin/2to3*
rm -rf /usr/local/bin/pyvenv*
rm -rf /usr/local/bin/pydoc3
rm -rf /usr/local/bin/pydoc3*
rm -rf /usr/local/bin/idle3*
rm -rf /usr/local/bin/python3*
rm -rf /usr/local/bin/pip3*
rm -rf /usr/local/bin/easy_install-3.7
```

### 获取Python3源码

wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz

### 编译安装Python3

1. ./configure --enable-shared
2. make && make install

## 安装依赖

- Ubuntu 16.04 and later:
  sudo apt install build-essential cmake python3-dev
- Centos7
  yum -y install cmake3 build-essential python3-dev gcc-c++

## 编译安装vim8

./configure --with-features=huge --enable-multibyte --enable-rubyinterp=ysses --enable-pythoninterp=yes --enable-python3interp=yes



./configure --with-features=huge --enable-multibyte --enable-rubyinterp=ysses --enable-pythoninterp=yes --enable-python3interp=yes --with-python-config-dir=with-python3-config-dir=/usr/local/python3/lib/python3.6/config-3.6m

```
# 支持最大特征
--with-features=huge
# 打开对ruby编写的插件的支持
--enable-rubyinterp
# 打开对python编写的插件的支持
--enable-pythoninterp
# 打开对python3编写的插件的支持
--enable-python3interp
# 打开对lua编写的插件的支持
--enable-luainterp
# 打开对perl编写的插件的支持
--enable-perlinterp
# 打开多字节支持，可以在Vim中输入中文
--enable-multibyte
# 打开对cscope的支持
--enable-cscope
```

### 卸载已有的vim

yum -y remove vim

### 卸载源码安装的vim8

1. 进入源码包
2. make uninstall

### 获取vim8源码

git clone https://github.com/vim/vim.git

### 编译安装vim8

1. ./configure --with-features=huge --enable-rubyinterp=yes -enable-python3interp=yes --enable-multibyte --with-python-config-dir=/usr/local/bin/python3 --enable-cscope
2. make && make install

### 注: 如果出现下列错误，对照解决

- 错误一：/usr/local/python3.6.5/bin/python3: error while loading shared libraries: libpython3.6m.so.1.0: cannot open shared object file: No such file or directory
  在源码包里
  cp libpython3.6m.so.1.0 /usr/local/lib64/
  cp libpython3.6m.so.1.0 /usr/lib/
  cp libpython3.6m.so.1.0 /usr/lib64/





