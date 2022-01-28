虽然现在有很多的svn客户端来对svn进行可视化的管理，例如windows下的小乌龟等都是非常优秀的。但总感觉使用起来不是特别方便或者说不是非常的便捷。

而在linux或mac下，svn与linux的命令行搭配使用，可以发挥非常强大的作用，高效，快速。

\1. 很多时候我们从网上使用svn checkout一个目录放到我们自己的项目当中，或者将其他项目中的一个目录(该目录已由svn管理)复制到现有的目录中。

在进行(svn add)/(svn ci)的过程中，会提示冲突。其原因是在每个由svn管理的目录中都包含一个.svn的目录来管理该目录中的文件，其中有一个entries文件，

其中包含相应的目录文件信息，版本号以及svn服务器地址信息等。当我们不知道当前目录文件是从哪个svn服务器上check下来的，就可以去查看这个文件。

上面提示冲突，是因为在外层提交更新的过程中，.svn目录指示当前目录中的文件不是当前工程中的，所以必定会冲突。解决办法就是删除该目录中的.svn目录。

rm -rf .svn 即可。如果由多个目录的话，推荐使用 **find . -name .svn | xargs rm -rf** 删除当前目录之下的所有目录中的.svn文件夹。如果由权限问题，

可以使用**sudo** **find . -name .svn | xargs rm -rf** 获取超级用户权限将其删除。然后再次使用svn add 即可正常提交更新。

\2. 添加一个文件或目录到svn版本控制中

```
`mkdir TestSvn``svn add TestSvn``svn ci TestSvn . -m ``"add TestSvn"``　　　　####必须添加-m ``""``注释，否则提交失败(Linux)`
```

　　添加文件/目录，最后必须要commit（svn ci）才真正的提交到服务器上。svn add会让文件置于一个中间状态，在XCode或Qt Creator等工具中可以清晰的看到此时文件前面有个"A"，当svn ci 之后就已经成功添加到svn版本控制中

\3. **svn cleanup**

很多时候，在我们使用svn update 时，可能网速较慢，svn update未执行完成，使用ctrl+c发送信号对其进行强制终止，那么当再次使用svn update时，则提示文件夹被锁定，这种程度的锁定，可以使用svn cleanup来进行解决。然后在svn update就不会有什么问题了。

\4. 查看当前目录的更新log

```
`svn log .  ###查看当前目录的更新log``svn log file ####查看file文件的更新log`
```

　　通过这种方式，可以很清晰的看到某个文件被更新的历史，以及更新的简要说明。从而对文件的变化能够有个大致的了解。

不过当使用**svn ci . -m "this is a test commit"**来提交文件之后，立刻使用svn log 来查看当前目录的log时看不到的，需要使用svn update更新之后才可以看到。

\5. 解决冲突

正常情况下，每天编程之前，都最好使用svn update来保证自己的代码是最新的，每完成一个小功能，经过测试之后，都需要及时的将代码commit到服务器上。以此来减少冲突。不过多人开发的项目中，冲突是不可避免的。在进行提交文件之前，都需要svn update来更新当前的文件，当提示冲突时，可以采用合并的方式或是采用他人的代码或是自己的代码来解决冲突(冲突发生时，终端都会提示接下来该如何操作)。当然针对单个冲突的文件也可以使用svn diff filename >/tmp/1来查看文件与服务器上的不同之处，修改好之后在进行提交。

同时推荐一个 vi -d file1 file2 命令,这条命令可以同时打开两个文件，左右个一个，同时有高亮显示，可以很方便的看到两个文件的不同点。对于检查冲突非常有帮助。

\6. 忽略文件的修改/还原文件到svn上指定的版本

**svn revert filename** ###丢弃当前文件的修改

**svn update -r 500**  ###还原到reversion为500时的状态，后面加文件名的话，即还原某个文件到制定的reversion状态

\7. 删除一个文件或目录

svn rm filename   　　　　　　　 ###后面可以跟多个文件或目录

svn ci . -m "remove filename"　　　###跟svn add一样，删除之后需要进行commit.进行commit时，需要添加注释(-m "***"), 或者linux时不允许提交的　　　　　　　　　　　　　　　　　　　###, 这样的限制也方便保持良好的习惯

 

其他：

关于svn仓库的搭建以及权限的管理不是本文讨论的内容，网上也有很多相关的资料.其中可能涉及到类似apache等的配置，权限管理等

svn的命令非常多，但是常用的并不多，我在网上看到一篇文章，讲的挺清晰，排版也较好，链接为：http://www.php-oa.com/2008/03/12/svnminglingzailinuxxiadeshiyong.html 其中对一些常见的命令以及其使用都有说明。有兴趣的可以去看看。

网上有一个svn的pdf，很容易找到，上面详细的讲述了svn的方方面面，但是很多都是用不到的，需要深入了解的，可以去查阅下。

最后分享一个vim的profile配置，我一直都在使用的这个，挺好用的，不过个人有个人的习惯，也可以自己去定制个适合自己的。

```
`" yytong 编辑                                                                                   ` `set` `nu       "show number``syntax ``on`      `"syntax highlight``set` `cursorline   "have cursorline``set` `cindent     "``set` `smartindent   "``set` `autoindent   "``set` `hlsearch    "highlight search word``set` `shiftwidth=4  "``set` `tabstop=4    "tab = 4``map   :TlistToggle   "use  to open/close Tlist``"let Tlist_Auto_Open=1         "``每次自动打开Tlist``let` `Tlist_Show_One_File = 1       "不同时显示多个文件的tag，只显示当前文件的``let` `Tlist_Exit_OnlyWindow = 1      "如果taglist窗口是最后一个窗口，则退出vim``"let Tlist_Use_Right_Window = 1     "``在右侧窗口中显示taglist窗口``set` `showmatch    "设置自动检测括号是否匹配``set` `incsearch``set` `ruler``set` `laststatus=2  "显示当前文件名``autocmd BufReadPost *``  ``\ ``if` `line(``"'\""``) > 0 && line(``"'\""``) <= line(``"$"``) |``    ``\  exe ``"normal g`\""` `|``      ``\ endif           "自动跳转到上次文件打开的位置``"``set` `fdm=syntax` `"``for` `qt``set` `nocp``filetype plugin ``on``set` `tags+=/home/yytong/work/idong/qt-src/qt-everywhere-opensource-src-4.6.3/include/tags``set` `tags+=/home/yytong/work/idong/qt-src/qt-everywhere-opensource-src-4.6.3/src/tags``"``for` `qt end`
```

　　最后里面几行配置了ctags相关的东西，可以在vi中使用代码的自动补全功能。其中也配置了语法高亮等，非常实用。

只需要编辑~/.vimrc,将上述内容copy过去，或者使用部分代码。由于放在当前用户$HOME工作目录中，

不需要重启，注销即可生效，真是个好东西。随便说一下，vim+ctags可以实现类似IDE的功能，但是mac的ctags不是标准的ctags。

另外可以在vi的命令模式中使用上面的一条或多条语句来进行暂时的控制。例如使用   **:set nu 就是打开行号  :set nonu就是关闭行号**

screen命令也是非常好用的，可以在一个终端窗口打开多个标签页，不过不是这篇文章该讨论的内容，有时间再去整理个实用工具的文档吧！