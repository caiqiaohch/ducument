# 插件列表(Plugin)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

18 人赞同了该文章

由于zhihu的垃圾编辑器不支持表格，请查看以下完整格式：

**[http://yyq123.github.io/learn-vim/learn-vim-plugin.html](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-plugin.html)**

## 说明：

- 本列表完全基于作者的主观体验，既不客观也不完整；
- 建议使用[vim-plug](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)或[Vundle](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html)等插件管理器，来安装和管理插件；
- 在“插件”列中的 ★，表示推荐的插件；
- 在“描述”列中的【[详细介绍](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-00-00-TOC.html)】，链接到插件配置与使用的详细介绍。

## 工具

- junegunn/vim-plug ★ 插件管理器【详细介绍】
- VundleVim/Vundle.vim 插件管理器【详细介绍】
- machakann/vim-highlightedyank 高亮显示yanked内容
- svermeulen/vim-yoink yank历史纪录
- DavidFishburn/YankRing.vim yank历史纪录【详细介绍】
- Shougo/context_filetype.vim 文件类型侦测
- vim-scripts/fencview.vim ★ 多编码（Multi-Encodings）格式识别【详细介绍】
- mhinz/vim-startify 自定义启动页（包含最近使用的文件、书签和保持的会话）
- dstein64/vim-startuptime 启动时间分析
- MTDL9/vim-verbosity 将verbose信息输出至日志文件
- Shougo/vinarise.vim 十六进制（Hex）编辑器

## 色彩

- rafi/awesome-colorschemes Awesome配色方案合辑
- romainl/vim-cool 完成搜索后自动禁用高亮显示，再次查询时重新高亮显示
- guns/xterm-color-table.vim xterm 256色及RGB值列表
- lilydjwg/colorizer ★ 颜色代码的背景色显示相应的色彩【详细介绍】

## 界面

- vim-airline/vim-airline 自定义状态栏
- powerline/powerline 自定义状态栏
- liuchengxu/vim-which-key 在pop-up窗口中显示快捷键定义
- mbbill/undotree 视觉化的undo历史
- sjl/gundo.vim 视觉化的undo历史
- kshenoy/vim-signature 在屏幕最左侧显示标记【详细介绍】
- nathanaelkane/vim-indent-guides 可视化显示缩进级别
- ryanoasis/vim-devicons 根据文件类型显示图标
- bagrat/vim-buffet 自定义Tabline显示缓冲区列表
- t9md/vim-choosewin 类似TMUX的display-pane快速选择窗口

## 数据

- chrisbra/csv.vim 处理按列存储的数据文件
- mechatroner/rainbow_csv 以多种色彩显示CSV文件，并支持类似SQL的查询语言
- vim-scripts/VisIncr 增加数值和日期等

## 语法

- hail2u/vim-css3-syntax CSS3 syntax support to vim's built-in syntax/css.vim
- cakebaker/scss-syntax.vim Syntax file for scss (Sassy CSS)
- othree/html5.vim HTML5 omnicomplete and syntax
- plasticboy/vim-markdown Markdown syntax highlighting
- rhysd/vim-gfm-syntax GitHub Flavored Markdown syntax highlight extension
- pangloss/vim-javascript Enhanced Javascript syntax
- heavenshell/vim-jsdoc Generate JSDoc to your JavaScript code
- elzr/vim-json Better JSON support
- vim-python/python-syntax Enhanced version of the original Python syntax
- Vimjas/vim-python-pep8-indent A nicer Python indentation style
- vim-jp/syntax-vim-ex Improved Vim syntax highlighting
- ekalinin/Dockerfile.vim Syntax and snippets for Dockerfile
- tmux-plugins/vim-tmux Plugin for tmux.conf
- MTDL9/vim-log-highlighting Syntax highlighting for generic log files
- mboughaba/i3config.vim i3 window manager config syntax
- jstrater/mpvim Macports portfile configuration files
- chr4/nginx.vim Improved nginx syntax and indent
- vim-syntastic/syntastic 语法检查
- dense-analysis/ale 支持LSP的异步语法检查

## Git

- jreybert/vimagit 简化Git工作流程
- lambdalisue/gina.vim 异部控制Git
- airblade/vim-gitgutter 显示和控制Git变更
- tpope/vim-fugitive Git plugin for Vim
- mattn/vim-gist ★ 管理存储在Gist的代码片段【详细介绍】

## 写作

- junegunn/goyo 无干扰（Distraction-free）写作
- junegunn/limelight 无干扰（Hyperfocus）写作
- reedes/vim-wordy 识别经常被误用的英文单词和短语
- mzlogin/vim-markdown-toc 自动生成Markdown目录（TOC）标签
- iamcco/markdown-preview.nvim 使用浏览器预览Markdown文件
- chrisbra/unicode.vim 输入和查询unicode字符和Digraphs

## 快速移动

- haya14busa/vim-asterisk 增强的*命令
- haya14busa/vim-edgemotion 跳转到代码块的边界
- easymotion/vim-easymotion 快速移动
- terryma/vim-multiple-cursors 多重光标选择

## 自动完成

- othree/csscomplete.vim 增强的CSS自动完成
- prabirshrestha/asyncomplete.vim 异步自动完成
- prabirshrestha/vim-lsp 异步语言服务器协议插件
- mattn/vim-lsp-settings vim-lsp自动配置
- ycm-core/YouCompleteMe 代码自动完成

## HTML

- yyq123/HTML-Editor HTML代码输入和网页预览【详细介绍】
- alvan/vim-closetag 自动关闭(X)HTML标签
- mattn/emmet-vim 类似emmet的HTML代码快速输入

## 文本对象

- wellle/targets.vim 扩展文本对象
- kana/vim-operator-user 自定义操作符（operators）
- kana/vim-operator-replace 使用寄存器内容进行替换操作
- jiangmiao/auto-pairs 自动输入和删除成对出现的括号和引号等
- tpope/vim-surround 环绕字符编辑【详细介绍】
- machakann/vim-sandwich ★ 环绕字符编辑【详细介绍】
- kana/vim-textobj-user 自定义文本对象
- terryma/vim-expand-region 渐进可视化区域选择文本
- chrisbra/matchit %命令功能扩展【详细介绍】
- andymass/vim-matchup %命令功能扩展
- AndrewRadev/sideways.vim 匹配函数参数
- osyo-manga/vim-textobj-multiblock 处理成对括号
- kana/vim-textobj-function 函数相关文本对象

## **编程辅助**

- AndrewRadev/splitjoin.vim 拆分/合并行
- AndrewRadev/linediff.vim 代码块比较
- SirVer/ultisnips 代码片段管理
- garbas/vim-snipmate 代码片段管理
- honza/vim-snippets 代码片段管理
- tyru/caw.vim 注释工具
- ludovicchabant/vim-gutentags 管理tag文件
- luochen1990/rainbow 多重色彩括号【详细介绍】
- Rainbow-Parenthsis-Bundle 多重色彩括号【详细介绍】
- rhysd/devdocs.vim 查询[http://devdocs.io](https://link.zhihu.com/?target=http%3A//devdocs.io)离线文档
- rizzatti/dash.vim 查询Dash.app离线文档
- KabbAmine/zeavim.vim 查询Zeal离线文档【详细介绍】

## **其它**

- junegunn/fzf.vim 集成Fzf模糊查询工具
- skywind3000/asyncrun.vim 后台异步执行外部命令

编辑于 2020-10-22