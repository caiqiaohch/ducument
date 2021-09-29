# [

# vim一个快速切换主题的插件（change-colorscheme，原创）](https://www.cnblogs.com/highway-9/p/5503482.html)

## 概述

有时候我们想快速浏览主题并找到一款合适的主题，change-colorscheme将会满足我们的要求.

## 安装

```
git https://github.com/chxuan/change-colorscheme.git
cd ./change-colorscheme/plugin
cp change-colorscheme.vim ~/.vim/plugin
```

或者如果你有 [Vundle](https://github.com/VundleVim/Vundle.vim), 将 `'chxuan/change-colorscheme'` 加入你的 `~/.vimrc` 然后执行 `:PluginInstall`.

## 使用

你可以将下面的代码放入 `~/.vimrc`:

```
map <F12> :NextColorScheme<CR>
imap <F12> <ESC> :NextColorScheme<CR>
map <F11> :PreviousColorScheme<CR>
imap <F11> <ESC> :PreviousColorScheme<CR>
```

按下 `F12` 将加载下一个主题，按下 `F11` 将加载上一个主题。 如果你想知道当前是什么主题你可以执行 `:colorscheme`.

## 注意

该插件将会在 `~/.vim/colors`搜索主题。

## 屏幕截图

![此处输入图片的描述](https://raw.githubusercontent.com/chxuan/vimplus/master/screenshot/screenshot2.gif)

## 版权

This software is licensed under the [MIT license](https://github.com/chxuan/change-colorscheme/blob/master/LICENSE). © 2016 chxuan

兴趣是最好的老师，我的github地址：https://github.com/chxuan