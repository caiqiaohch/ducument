git终端显示分支名称

在使用git操作的时候，有时候会记错当前自己是在哪个分支上，从而造成一些不必要的麻烦；

比如需要在某个分支上开发某个特性，结果误在master分支上进行了相关的操作，并且还push到了远端仓库，事后自己有可能还并不知晓，从而给自己带来了不必要的困扰和麻烦；

==================================================================================

在终端上显示当前分支

可以在~/.bashrc文件中添加以下几行简单的指令显示当前所处git分支

function git_branch {
  branch="`git branch 2>/dev/null | grep "^\*" | sed -e "s/^\*\ //"`"
  if [ "${branch}" != "" ];then
      if [ "${branch}" = "(no branch)" ];then
          branch="(`git rev-parse --short HEAD`...)"
      fi
      echo " ($branch)"
  fi
}
 
export PS1='\u@\h \[\033[01;36m\]\W\[\033[01;32m\]$(git_branch)\[\033[00m\] \$ '


刚安装centos，命令提示符不显示当前完整目录，如下所示：

[centos@s101 ~]$

 

配置方法：

1.编辑profile文件，添加环境变量PS1

 su root  //切换到root用户

 vim /etc/profile  //打开profile文件

在profile内容最下面添加如下内容：

export PS1='[\u@\h `pwd`]\$'

 

2.保存退出，使profile修改生效

source /etc/profile

 

3.查看命令提示符效果

[root@s101 /home/centos]

 

对于PS1的参数可以参考下面来写：

\H ：完整的主机名称

\h ：仅取主机的第一个名字

\t ：显示时间为24小时格式，如：HH：MM：SS

\T ：显示时间为12小时格式

\A ：显示时间为24小时格式：HH：MM

\u ：当前用户的账号名称

\v ：BASH的版本信息

\w ：完整的工作目录名称。家目录会以 ~代替

\W ：利用basename取得工作目录名称，所以只会列出最后一个目录

# ：下达的第几个命令

$ ：提示字符，如果是root时，提示符为：# ，普通用户则为：$