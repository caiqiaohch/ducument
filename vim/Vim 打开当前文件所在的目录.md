# Vim 打开当前文件所在的目录

写 Laravel Backpack 组件最痛苦的地方在于路径藏的太深，每次想查看同目录下另外一个文件时，需要重新输入一遍文件目录。

例如：

resources/views/vendor/backpack/crud/fields/

输入一次这样的路径真是太锻炼大脑的记忆能力了！

于是我查了一下是否有这样的 Vim 命令，能否打开当前文件所在的目录。果然有

:Explore

缩写为

:Ex

但是，我更喜欢使用 Split 的方式打开特定目录

Vim Vexplore

:Vexplore

缩写为

:Ve