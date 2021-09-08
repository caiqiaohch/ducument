# [git生成文件目录树及日志打印](https://www.cnblogs.com/elian/p/10083317.html)

@

目录

- 如何用git生成一个文件目录树
  - [下载 tree 命令的二进制包，安装 tree 命令工具;](https://www.cnblogs.com/elian/p/10083317.html#下载-tree-命令的二进制包，安装-tree-命令工具)
  - 测试 tree 命令
    - [常用指令](https://www.cnblogs.com/elian/p/10083317.html#常用指令)
    - [目录结构显示](https://www.cnblogs.com/elian/p/10083317.html#目录结构显示)
- Git如何打印出指定格式log
  - [输出指定格式的日志信息](https://www.cnblogs.com/elian/p/10083317.html#输出指定格式的日志信息)
  - [将日志导出到指定目录](https://www.cnblogs.com/elian/p/10083317.html#将日志导出到指定目录)
  - [给命令设置别名](https://www.cnblogs.com/elian/p/10083317.html#给命令设置别名)
  - [Git打印退出命令](https://www.cnblogs.com/elian/p/10083317.html#git打印退出命令)



# 如何用git生成一个文件目录树

因为**Git-Bash**中不支持tree命令，所有需要给Window平台下Git-Bash添加tree命令

> 参考 https://www.jianshu.com/p/32ba82d84680

## 下载 `tree` 命令的二进制包，安装 `tree` 命令工具;

1. 打开进入 [Tree for Windows](http://gnuwin32.sourceforge.net/packages/tree.htm) 页面，选择下载 `Binaries zip` 文件;
2. 解压压缩包，找到压缩包内的 bin 目录，将 bin 目录下的 tree.exe 复制；
3. 找到 `C:\\Program Files\Git\usr\bin` 目录，将 `tree.exe` 粘贴到该目录下，安装即完成；

## 测试 `tree` 命令

1. 进入 `Git-Bash`，输入 `tree -L 1` 命令，如果安装成功，命令可以正常执行。![tree展示](https://img-blog.csdnimg.cn/20181207130036640.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3NhbmR5X3N3ZWV0,size_16,color_FFFFFF,t_70)
2. `tree -L 5 -I "node_modules|dist|dist.zip" >tree.txt` 将目录结构导出

### 常用指令

`tree -d` 只显示文件夹；
`tree -L n` 显示项目的层级。n表示层级数。比如想要显示项目三层结构，可以用tree -l 3；
`tree -I pattern` 用于过滤不想要显示的文件或者文件夹。比如你想要过滤项目中的node_modules文件夹，可以使用`tree -I "node_modules"`，过滤多个用 `|` 隔开 ，比如 `tree -I "node_modules|dist"`
`tree > tree.md` 将项目结构输出到tree.md这个文件。

> 更多命令参考 https://wangchujiang.com/linux-command/c/tree.html

### 目录结构显示

```
├── README.md 项目描述
├── app  业务侧代码
│   ├── controller 与路由关联的api方法
│   └── modal 数据模型
├── app.js 入口文件
├── bin nodemon
│   ├── run  nodemon 的入口文件
│   └── www
├── config 配置文件
│   ├── dbConfig.js 数据库配置
│   ├── logConfig.js 日志配置 
│   └── serverConfig.js 服务配置
├── logs  日志目录
│   ├── error 错误日志
│   └── response 普通响应日志 (还可以继续拆分，系统日志，业务日志)
├── middleware  中间件
│   └── loggers.js  日志中间件
├── public
│   └── stylesheets 公用文件
├── routes  路由
│   ├── allRoute.js 总路由配置
│   ├── files.js 各个模块路由配置
│   ├── index.js
│   └── users.js
├── uploads 上传文件夹
│   └── 2017-8-29
├── utils 公用方法
│   ├── logUtil.js 
│   └── mkdir.js
├── views 页面层
│   ├── error.jade
│   ├── index.jade
│   └── layout.jade
└── package.json


tree 目录生成命令

tree -L 3 -I "node_modules"
```

# Git如何打印出指定格式log

## 输出指定格式的日志信息

`git log --graph --after="1 week ago" --oneline --date=format:'%Y-%m-%d %H:%M:%S' --pretty=format:'%Cred%h%Creset - %Cgreen(%ad) %C(yellow)%d%Creset %s ' --abbrev-commit`
![在这里插入图片描述](https://img-blog.csdnimg.cn/20181207151006315.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3NhbmR5X3N3ZWV0,size_16,color_FFFFFF,t_70)
`--graph` 图像化显示日志操作
`--after="1 week ago"` 显示一周前的日志信息
`--after="2018-12-3" --before="2018-12-7"` 获取该时间段内的日志信息
`--oneline` 日志信息显示在一行
`--author="tom" `筛选出作者提交的日志
`--date=format:'%Y-%m-%d %H:%M:%S'` 设置日期显示格式
`--pretty=format:` 设置日志显示格式
`%h` 提交对象的简短哈希字串
`%ad` 作者修订日期（可以用-date= 选项定制格式）
`%ar` 作者修订日期，按多久以前的方式显示
`%s` 提交说明
`%Cred` 切换到红色
`%Cgreen` 切换到绿色
`%Cblue` 切换到蓝色
`%Creset` 重设颜色
`-- >f:/work/worklog/log.log` 将文件导出到指定文件

> 更多命令参考 https://ruby-china.org/topics/939

## 将日志导出到指定目录

```
git log --graph --after="1 week ago" --oneline --date=format:'%Y-%m-%d %H:%M:%S' --pretty=format:'%Cred%h%Creset - %Cgreen(%ad) %C(yellow)%d%Creset %s ' --abbrev-commit -- >f:/work/worklog/log.log
```

## 给命令设置别名

`git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"`
通过 `git lg` 进行调用

## Git打印退出命令

按 `q` 退出打印