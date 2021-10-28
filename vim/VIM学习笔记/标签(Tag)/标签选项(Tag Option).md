# 标签选项(Tag Option)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

1 人赞同了该文章

## 标签选项

通过'tags'选项，可以指定查找标签文件的位置。根据以下默认设置，Vim将在当前目录查找标签文件：

```vim
set tags=tags=./tags,tags
```

对于大量的代码文件，也可以设置更精细的查找路径：[[S\]](https://www.zhihu.com/question/47691414/answer/373700711)

```vim
set tags=./.tags;,.tags
```

其中，以逗号分隔的参数为：

- ./.tags;，代表在文件的所在目录下，查找名字为“.tags”的标签文件。使用以点开头的文件名，以便与常规的项目文件相区别。结尾的分号代表查找不到时继续向上递归到父目录。这样对于分布在不同子目录中的源代码文件，只需要在项目顶层目录放置一个.tags文件即可。
- .tags，是指同时在 Vim 的当前目录（即:pwd命令返回的目录）下查找 .tags 文件。

假设我们针对rails源码库（*~/src/rails*）生成tags文件，并在'tags'选项中包含此文件，那么就可以在编写代码时，方便地跳转至标签的定义处，获得相关地使用说明。

```vim
set tags+=~/tags/rails.tags
```

默认设置下，Vim使用二分法（binary search）来查找指定的标签名。如果您生成的[标签文件(Tags File)](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-79-01-Tag-File.html)没有经过排序，那么可以切换至线性查找（linear search）方式：

```vim
:set notagbsearch
```

## 标签函数

通过调用Vim内置的taglist函数，可以实现自定义的标签匹配功能。taglist函数将根据输入的正则表达式，将所有匹配的标签以列表形式返回。使用`:help taglist`命令，可以查看该函数的帮助信息。

例如以下代码，利用taglist函数实现了查找指定函数的功能：

```vim
command! -nargs=1 TagFunction call s:TagFunction(<f-args>) 
function! s:TagFunction(name)
   " Retrieve tags of the 'f' kind 
   let tags = taglist('^'.a:name)
   let tags = filter(tags, 'v:val["kind"] == "f"')
   " Prepare them for inserting in the quickfix window
   let qf_taglist = []   
   for entry in tags
       call add(qf_taglist, {
            \ 'pattern':  entry['cmd'],
            \ 'filename': entry['filename'],
            \ })
   endfor
   " Place the tags in the quickfix window, if possible
   if len(qf_taglist) > 0 
      call setqflist(qf_taglist)
      copen
   else
      echo "No tags found for ".a:name
   endif
endfunction 
```

使用`:TagFunction HTML`命令调用自定义函数，将查找所有以“HTML”开头的函数，并显示在[Quickfix](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-70-01-QuickFix.html)中。

![img](https://pic1.zhimg.com/80/v2-eb26afcde9caa4cf923d812c80ca78c4_720w.jpg)

## 标签相关插件

[unimpaired.vim](https://link.zhihu.com/?target=http%3A//www.vim.org/scripts/script.php%3Fscript_id%3D1590)插件，映射了一系列方括号开头的快捷键，以方便在标签之间进行跳转。比如]t代表`:tnext`；[t代表`:tprev`等等。

[vim-gutentags](https://link.zhihu.com/?target=https%3A//github.com/ludovicchabant/vim-gutentags)插件，可以检测文件变动并自动增量更新[标签文件](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-79-01-Tag-File.html)（Tags File）。它可以异步更新标签，并且对于标签文件进行排序，以便于Vim使用二分法快速搜索关键字。

Ver: 2.0 | [YYQ](mailto:yyq123@gmail.com)<[上一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-79-02-Tag-SingleMatch.html) |[ 目录 ](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)| [下一篇](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-79-03-Tag-MultipleTags.html)>

发布于 2020-02-22