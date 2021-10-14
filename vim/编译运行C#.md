""  增加编译C 和C++文件的函数，使用微软的CL.EXE文件

""  需要在系统环境变量中配置cl编译的路径及lib、include目录路径
func! CompileCCpp()
    exec "w"
    let compilecmd="!cl "
    let compileflag=" &%< "
    exec compilecmd." % "compileflag
endfunc
""  增加编译c#文件的函数，使用系统的csc.exe文件
""  需要在系统环境变量中里面增加csc.exe文件所在文件路径
func! CompileCs()
    exec "w"
    let compilecmd="!csc "
    let compileflag=" &%< "
    exec compilecmd." % "compileflag
endfunc
func! CompileCode()
        exec "w"
          if &filetype == "cs"
                exec "call CompileCs()"
          elseif &filetype == ("cpp"||"c")
                exec "call CompileCCpp()"
        endif
endfunc
""绑定F6 编译C&C++&C#文件
map <F6> :call CompileCode()<CR>
imap <F6> <ESC>:call CompileCode()<CR>
vmap <F6> <ESC>:call CompileCode()<CR>
————————————————
版权声明：本文为CSDN博主「白天要觉觉」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/xiangqianwei/article/details/80320812