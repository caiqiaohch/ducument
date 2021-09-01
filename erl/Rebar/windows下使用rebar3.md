# windows下使用rebar3

rebar3在windows下不能使用的原因是因为无法下载deps的依赖包，只能下载内置的hex库里面的包，我们可以这样解决

首先下载[Git ](https://link.jianshu.com/?t=https://git-scm.com/download/win),如果下载不下来的同学可以复制链接用迅雷下载。

安装完成后，右键快捷键打开git bash，按照以下命令操作，或者去github下载一个rebar3

git clone https://github.com/erlang/rebar3.git

cd rebar3

./bootstrap

编译完成后，把rebar3的目录加入Path环境变量

进入自己的工作目录

rebar3 new app test_app

修改rebar.config中的deps

{deps, [{cowboy, {git, "https://github.com/ninenines/cowboy.git", {branch, "master"}}}]}.

rebar3 get-deps

然后就可以看到依赖文件都下载下来了