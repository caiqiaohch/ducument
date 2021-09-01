# Erlang Rebar 使用指南之一：入门篇



全文目录:

本章原文:

https://github.com/rebar/rebar/wiki/Getting-started



Rebar 是功能丰富的 Erlang 构建工具。用于Erlang/OTP项目的编译，测试，依赖管理，打包发布等。

Rebar 是自包含的脚本，可以方便地嵌入到项目中。

## 1 编译 rebar

```crystal
    $ git clone git://github.com/rebar/rebar.git
    $ cd rebar
    $ ./bootstrap
```

 查看命令说明：



### 2.1 创建一个程序目录

```ruby
    $ mkdir myapp
    $ cd myapp
```


 把 “1 编译 rebar” 得到的 rebar 复制到myapp目录中

```ruby
    $ cp ../rebar/rebar .
```



### 2.2 创建第一个rebar项目

```html
    $ ./rebar create-app appid=myapp    $ touch rebar.config
```


 上面命令执行后，在myapp/src生成了3个文件： myapp.app.src - OTP应用资源 myapp_app.erl - 一个实现 OTP application behaviour myapp_sup.erl - 最顶层的 OTP Supervisor behaviour 

### 2.3 编译项目

```ruby
    $ ./rebar compile
```


 上面命令执行后，生成ebin目录，包含与src/erl文件对应的.beam文件. src/myapp.app.src 生成 ebin/myapp.app


 Rebar 支持 EUnit和Common Test测试框架。给项目增加 EUint 单元测试, 增加下面的代码到 src/myapp_app.erl:



```erlang
    %% eunit testing
    -ifdef(TEST).
    -include_lib("eunit/include/eunit.hrl").
    -endif.
```





 在文件末尾添加：





 

### 2.5 测试代码覆盖率统计

 在myapp/rebar.config中加入下面的行: