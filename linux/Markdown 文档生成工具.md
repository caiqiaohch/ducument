Markdown 文档生成工具

之前用了很多Markdown 文档生成工具，发现有几个挺好用的，现在整理出来，方便大家快速学习。

loppo: 非常简单的静态站点生成器
idoc：简单的文档生成工具
gitbook：大名鼎鼎的文档协作工具
docsify：一个神奇的文档站点生成器，简单轻巧，无需静态构建html
教程版：
http://me.52fhy.com/learn-markdown-generate-tool/#/

loppo
官网： https://github.com/ruanyf/loppo

依赖 node.js 环境。

特点：
1、简单小巧，支持自动生成目录。
2、不支持插件。
3、原理是将 Markdown 文件编译生成 html 文件。
4、生成的页面很美观、大方，支持响应式。

安装
全局安装：

Copy
$ npm install loppo -g
如何使用
创建项目：

Copy
$ mkdir test-loppo
$ cd test-loppo
项目目录格式示例：

Copy
|- test-loppo
   |- README.md
   |- docs
      |- page1.md
      |- page2.md
      |- ...
然后运行项目：

Copy
$ loppo 
会生成：

Copy
dist/
chapters.yml
loppo.yml
其中 dist是编译输出目录；chapters.yml是自动生成的文档目录，根据当前目录生成，如果增删了源文件，需要删除该文件使得下次重新生成；loppo.yml是配置文件，第一次生成后不会再变更。

loppo.yml
该文件是配置文件：

Copy
dir: docs
output: dist
site: Documents
theme: oceandeep
customization: false
themeDir: loppo-theme
direction: ltr
id: test-loppo
我们可以手动进行修改。

dir： 源文件所在目录。默认是当前目录下的 docs目录。
output：编译输出文件目录。
site：项目文档名称。可以自定义，显示在页面 title 里。
theme：主题。默认oceandeep。暂时不知道有没有其他主题。
示例项目
ruanyf/survivor: 博客文集《未来世界的幸存者》
https://github.com/ruanyf/survivor
预览地址：http://survivor.ruanyifeng.com/

ruanyf/road: 博客文集《前方的路》
https://github.com/ruanyf/road
预览地址：http://road.ruanyifeng.com/

飞鸿影~的博客文集
http://wen.52fhy.com/

安卓学习笔记
http://android.52fhy.com/

idoc
官网： https://github.com/jaywcjlove/idoc

依赖 node.js 环境。

特点：
1、简单小巧，支持自动生成目录。有几个主题可以选择。
2、不支持插件。
3、原理是将 Markdown 文件编译生成 html 文件。

安装
全局安装：

Copy
$ sudo npm install idoc -g
如何使用
创建并初始化项目：

Copy
$ mkdir test-idoc
$ cd test-idoc

# 初始化
$ idoc init 
填入必要的项目信息，初始化完成。会在项目目录下生成：

Copy
md/
 |-- index.md
package.json
运行 idoc server 预览生成的静态页面。默认预览地址为 http://localhost:1987/

预览的时候改动md文件，浏览器刷新可以看到改动后的内容。

其中 初始化 步骤也可以手动执行，把目录和配置文件建好就行了。

目录结构
idoc对目录结构没有要求，只要你把md文件放在md/目录下面，idoc会自动识别。支持子目录。例如：

Copy
md/
 |-- 首页.md
 |-- 关于.md
 |-- 使用方法/
    |-- 命令文档.md
    |-- 命令文档2.md
如果有子目录，生成的文档导航栏也会有子菜单。效果：


配置文件
package.json文件。

Copy
{
    "name": "idoc",
    "version": "0.0.1",
    "description": "",
    "keywords": [
        ""
    ],
    "homepage": "http://JSLite.io",
    "author": "jaywcjlove <wowohoo@qq.com>",
    "repository": {
        "type": "git",
        "url": "https://github.com/jaywcjlove/idoc"
    },
    "licenses": "MIT",
    "idoc": {
        "theme": "default",
        "logo": "idoc-logo.svg",
        "md": [
            "首页.md",
            {
                "使用方法": [
                    "主题文件.md",
                    "初始化.md",
                    "配置说明.md"
                ]
            },
            "关于.md"
        ]
    }
}
其中 idoc.md块无需手动配置，idoc build 自动生成。其它配置无需多说明，也能看的懂。

主题
支持：

handbook
default
resume


参考：https://wangchujiang.com/idoc/html/%E4%B8%BB%E9%A2%98.html

常用命令
build
生成静态 HTML 页面到指定目录中。

Copy
$ idoc build
watch
监控 md 文件发生变化自动 build。

Copy
$ idoc watch
server
打开本地静态 html 服务器，预览你生成的页面。

Copy
$ idoc server
clean
清除生成的静态文件。

Copy
$ idoc clean
theme
$ idoc theme 与 $ idoc -t 相同
选择默认主题或者第三方主题，默认两个主题 handbook 或者 default。

Copy
# 选择主题
# 第三方主题，克隆到当前跟目录就可以使用命令选择了
$ idoc theme
# theme 简写 －t
$ idoc -t

# 制作主题 需要指定制作的主题目录
$ idoc -t ~/git/idoc-theme-slate/
deploy
将文档部署到 git 仓库的 gh-pages 分支中。
目前需要手动添加分支。

Copy
$ idoc deploy
示例项目
这些文档是都是使用idoc生成的页面：

JSLite.io - 这个是现代浏览器类似jQuery的库，体积小。
idoc - 通过markdown生成静态页面的工具
store.js - js本地存储操作
cookie.js - js本地cookie操作
iNotify - 浏览器各种方法通知
Nodejs教程
java代码片段
gitbook
官网： https://www.gitbook.com/

依赖 node.js 环境。

特点：
1、扩展性非常好，有社区支持。支持插件。
2、目录需要手动配置。
3、支持生成html、pdf、epub文件。

因为 gitbook 扩展性很强，下面仅给出简要教程，详细教程请阅读：https://github.com/52fhy/gitbook-use

安装
1、安装 gitbook 编辑器：
https://legacy.gitbook.com/editor/

2、运行下面的命令进行安装 gitbook-cli：

Copy
npm install gitbook-cli -g
其中 gitbook-cli 是 gitbook 的一个命令行工具, 通过它可以在电脑上安装和管理 gitbook 的多个版本。

注意：

gitbook-cli 和 gitbook 是两个软件
gitbook-cli 会将下载的 gitbook 的不同版本放到 ~/.gitbook 中, 可以通过设置GITBOOK_DIR环境变量来指定另外的文件夹
如何使用
新建一个项目：

Copy
$ mdkir test_gitbook && cd test_gitbook
初始化目录结构：

Copy
$ gitbook init
Copy
├── README.md
├── SUMMARY.md
使用下列命令会运行一个服务器, 通过http://localhost:4000/可以预览书籍：

Copy
gitbook serve
运行该命令后会在书籍的文件夹中生成一个 _book 文件夹, 里面的内容即为生成的 html 文件。
我们可以使用下面命令来生成网页而不开启服务器。

Copy
gitbook build
目录结构
GitBook 基本的目录结构如下所示

Copy
├── book.json
├── README.md
├── SUMMARY.md
├── chapter-1/
|   ├── README.md
|   └── something.md
└── chapter-2/
    ├── README.md
    └── something.md
book.json 为配置文件
README.md 主页
SUMMARY.md 目录文件
目录文件
SUMMARY.md 示例：

Copy
# Summary
## 基本使用
* [前言](introduction.md)
* [安装](installation.md)
* [命令](commands.md)
* [目录结构](structure.md)
* [配置](settings.md)

## 扩展
* [插件](plugins.md)
* [主题](themes.md)
* [bookjson](bookjson.md)


配置文件
book.json 示例：

Copy
{
    "title": "Go Web编程",
    "description": "build-web-application-with-golang",
    "author": "谢孟军",
    "output.name": "build-web-application-with-golang-zh",
    "pdf":{
        "fontFamily":"微软雅黑"
    }
}
命令
列出gitbook所有的命令

Copy
gitbook help
输出gitbook-cli的帮助信息

Copy
gitbook --help
下载所需的第三方插件依赖

Copy
gitbook install
生成静态网页并运行服务器

Copy
gitbook serve
生成静态网页

Copy
gitbook build
生成pdf

Copy
gitbook pdf
生成epub

Copy
gitbook epub
生成时指定gitbook的版本, 本地没有会先下载

Copy
gitbook build --gitbook=2.0.1
列出本地所有的gitbook版本

Copy
gitbook ls
列出远程可用的gitbook版本

Copy
gitbook ls-remote
安装对应的gitbook版本

Copy
gitbook fetch 标签/版本号
更新到gitbook的最新版本

Copy
gitbook update
卸载对应的gitbook版本

Copy
gitbook uninstall 2.0.1
指定log的级别

Copy
gitbook build --log=debug
输出错误信息

Copy
gitbook builid --debug
注：生成pdf、epub需要安装calibre插件，下载链接：https://calibre-ebook.com/download 。Mac 环境需要一个命令 sudo ln -s /Applications/calibre.app/Contents/MacOS/ebook-convert /usr/local/bin。

常见问题
1、gitbook生成pdf时缺少ebook.css
找到 C:\Users\YJC\.gitbook\versions\3.2.3\lib\output\website，将copyPluginAssets.js文件中67行和112行的“confirm: true” 改为：“confirm: false”。

示例项目
1、52fhy/gitbook-use: 记录GitBook的一些配置及插件信息
https://github.com/52fhy/gitbook-use
2、Introduction · Go Web编程
http://doc.52fhy.com/build-web-application-with-golang/zh/index.html

docsify
官网： https://docsify.js.org/#/
代码块：https://github.com/docsifyjs/docsify

依赖 node.js 环境。

特点：
1、扩展性非常好，有社区支持。支持插件。
2、目录需要手动配置。
3、发布无需编译生成 html，动态解析 md 文件。

安装
全局安装：

Copy
npm i docsify-cli -g
如何使用
创建并初始化项目：

Copy
$ mkdir test-docsify
$ cd test-docsify

# init project
$ docsify init ./docs
执行完毕，生成 docs 目录。里面有3个文件：

.nojekyll：让gitHub不忽略掉以 _ 打头的文件
index.html：整个网站的核心文件
README.md：默认页面
接下来预览一下效果：

Copy
$ docsify serve docs
会在本地运行server服务，我们打开浏览器，输入：http://localhost:3000 即可看到 demo 页面。

项目的目录结构示例：

Copy
.
└── docs
    ├── README.md
    ├── guide.md
    └── zh-cn
        ├── README.md
        └── guide.md
实际路由对应关系是：

Copy
docs/README.md        => http://domain.com
docs/guide.md         => http://domain.com/guide
docs/zh-cn/README.md  => http://domain.com/zh-cn/
docs/zh-cn/guide.md   => http://domain.com/zh-cn/guide
增加一个页面
我们新增 guide.md 文件作为示例：

Copy

## docsify

官网： https://docsify.js.org/#/  
代码块：https://github.com/docsifyjs/docsify  

> 依赖 node.js 环境。

### 安装

全局安装：

npm i docsify-cli -g


### 如何使用

创建并初始化项目：
我们启动 server 预览效果：

Copy
$ docsify serve docs
浏览：http://localhost:3000/#/guide

效果截图：


server 启动后，我们修改文件保存后，浏览器会实时刷新。

Sidebar
我们可以给文档增加左侧菜单。菜单文件名是_sidebar.md。格式要求示例：

Copy

<!-- docs/_sidebar.md -->

* [Home](/)
* [Guide](guide.md)
* [About](about.md "关于我，这是title tag")
括号里可以增加 title tag，通常用于SEO。

保存后需要修改 index.html 添加loadSidebar: true以启用左侧菜单：

Copy
window.$docsify = {
  loadSidebar: true,
  subMaxLevel: 3,
  name: '',
  repo: '',
  auto2top: true,
  search: 'auto'
}
其中：

loadSidebar：是否显示左侧菜单
subMaxLevel：配置菜单层级，默认仅显示一级
name：配置项目名
repo：配置代码库地址
auto2top：更改路由时自动滚动到屏幕顶部
search：配置启用搜索功能。需要加载对应js文件。后面有说明。
效果：


也可以增加分组菜单，必须用tag键留空格，否则层级是相同的。示例：

Copy
* [首页](/)
* 开始学习
    * [loppo](loppo.md "非常简单的静态站点生成器")
    * [idoc](idoc.md)
    * [gitbook](gitbook.md)
    * [docsify](docsify.md)
* 参考


配置高亮
docsify使用 Prism 突出显示页面中的代码块。默认情况下，它仅支持CSS，JavaScript和HTML。你可以使用 Prism 加载其他语言：

Copy
<script src="//unpkg.com/docsify/lib/docsify.min.js"></script>
<script src="//unpkg.com/prismjs/components/prism-bash.min.js"></script>
<script src="//unpkg.com/prismjs/components/prism-php.min.js"></script>
<script src="//unpkg.com/prismjs/components/prism-java.min.js"></script>
<script src="//unpkg.com/prismjs/components/prism-go.min.js"></script>
<script src="//unpkg.com/prismjs/components/prism-c.js"></script>
<script src="//unpkg.com/prismjs/components/prism-asm6502.js"></script>
<script src="//unpkg.com/prismjs/components/prism-makefile.js"></script>
从这个库里获取更多选项支持：https://github.com/PrismJS/prism/tree/gh-pages/components。

搜索
修改 index.html ，头部引入：

Copy
<script src="//unpkg.com/docsify/lib/plugins/search.js"></script>
然后配置里开启搜索：

Copy
search: 'auto'
copy-code
如果需要支持代码后面显示复制按钮，可以引入该插件：

Copy
<script src="//unpkg.com/docsify-copy-code"></script>
无需额外配置。

自定义导航栏
参考：https://docsify.js.org/#/custom-navbar

主题修改
仅需替换 index.html 里的vue：

Copy
<link rel="stylesheet" href="//unpkg.com/docsify/lib/themes/vue.css">
可用的主题：

Copy
<link rel="stylesheet" href="//unpkg.com/docsify/lib/themes/vue.css">
<link rel="stylesheet" href="//unpkg.com/docsify/lib/themes/buble.css">
<link rel="stylesheet" href="//unpkg.com/docsify/lib/themes/dark.css">
<link rel="stylesheet" href="//unpkg.com/docsify/lib/themes/pure.css">
其它主题：
docsify-themeable ：A delightfully simple theme system for docsify.

参考：https://docsify.js.org/#/themes

配置参考
参考：https://docsify.js.org/#/configuration

插件参考
参考：https://docsify.js.org/#/plugins

发布到GitHub Pages
参考：https://docsify.js.org/#/deploy

示例项目
快速入门 - docsify
https://docsify.js.org/#/quickstart

介绍 — Vue.js
https://cn.vuejs.org/v2/guide/

Linux C 编程一站式学习
http://me.52fhy.com/linux-c/#/

参考资料
1、ruanyf/loppo: an extremely easy static site generator of markdown documents
https://github.com/ruanyf/loppo
2、docsify
https://docsify.js.org/
3、idoc
https://wangchujiang.com/idoc/index.html
4、52fhy/gitbook-use: 记录GitBook的一些配置及插件信息
https://github.com/52fhy/gitbook-use
5、Mac环境安装Gitbook，并导出PDF教程 - 简书
https://www.jianshu.com/p/4824d216ad10

(本文完) 

本文优先在公众号"飞鸿影的博客(fhyblog)"发布，欢迎关注公众号及时获取最新文章推送！