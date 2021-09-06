# Centos 使用alias设置别名，永久生效

alias 是一个设置别名的命令

例如：
 alias cls= 'clear'

设置完成之后，就可以用 cls 完成clear命令的清屏操作
但美中不足的·是，当系统重启之后就会失效，所以要实现永久有效，则需要 修改用户目录下的一个文件 .bashrc
目录为 ~/.bashrc


vim ~/.bashrc

使用VIM编辑 ~/.bashrc这个文件
2.代开后如下

#.bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
# User specific aliases and functions

3.加上我们的
alias cls=’clear’这行，并且加一个注释# User specific aliases and functions
修改后如下

#.bashrc
# User specific aliases and functions
alias cls='clear'


# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
# User specific aliases and functions

4,保存并退出VIM；
使用命令生效更改

source ~/.bashrc
就完成了

重启后，试下应该可以
也可以输入命令

alias
可以看到所有的别名
————————————————
版权声明：本文为CSDN博主「漫步_云端」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/u013521296/article/details/77898908