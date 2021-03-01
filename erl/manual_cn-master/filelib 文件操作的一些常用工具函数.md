filelib 文件操作的一些常用工具函数

filelib:ensure_dir/1
确定文件或目录的所有父目录都已经存在

用法：

ensure_dir(Name) -> ok | {error, Reason}
内部实现：

%%----------------------------------------------------------------------
%% +type ensure_dir(X) -> ok | {error, Reason}.
%% +type X = filename() | dirname()
%% ensures that the directory name required to create D exists

-spec ensure_dir(Name) -> 'ok' | {'error', Reason} when
      Name :: filename() | dirname(),
      Reason :: file:posix().
ensure_dir("/") ->
    ok;
ensure_dir(F) ->
    Dir = filename:dirname(F),
    case do_is_dir(Dir, file) of
	true ->
	    ok;
	false when Dir =:= F ->
	    %% Protect against infinite loop
	    {error,einval};
	false ->
	    ensure_dir(Dir),
	    case file:make_dir(Dir) of
		{error,eexist}=EExist ->
		    case do_is_dir(Dir, file) of
			true ->
			    ok;
			false ->
			    EExist
		    end;
		Err ->
		    Err
	    end
    end.
判定确保对给出的文件名或文件夹名 Name 的上层所有父目录是否存在。如果有必要, 该函数会尝试创建缺失的父目录路径。当所有的父目录都存在或者可以被创建时，则返回 ok；如果部分父目录不存在并且创建不成功时，则返回 {error, Reason}。

filelib:ensure_dir("./test_dir/").

----------
filelib:file_size/1
获取文件的大小

用法：

file_size(Filename) -> integer() >= 0
获取给定文件 Filename 的大小。

filelib:file_size("./rebar").

----------
filelib:fold_files/5
对目录下的文件按正则表达式进行匹配

用法：

fold_files(Dir, RegExp, Recursive, Fun, AccIn) -> AccOut
对目录 Dir 下的文件按正则表达式 RegExp 进行匹配查找，对符合要求的文件执行函数 Fun。参数 Recursive 表示是否对目录 Dir 进行递归匹配查找，如果为 ture 则是，false 则否。

下面是列出 src 目录下的所有 erl 文件：

filelib:fold_files("./src/", ".*.erl", true, fun(F, AccIn) -> [F | AccIn] end, []).
列出 src 目录下的所有 erl 文件大小的总和：

filelib:fold_files("./src", ".*.erl", true, fun(F, AccIn) -> filelib:file_size(F) + AccIn end, 0).

----------
filelib:is_dir/1
判断是否是目录

用法：

is_dir(Name) -> boolean()
判断 Name 是否是一个目录，如果是则返回 true，否则返回 false。

filelib:is_dir("./src").
filelib:is_dir("./rebar").

----------
filelib:is_file/1
判断是否是一个文件或目录

用法：

is_file(Name) -> boolean()
判断 Name 是否是一个文件或目录，如果是则返回 true，否则返回 false。

filelib:is_file("./src").
filelib:is_file("./rebar").

----------
