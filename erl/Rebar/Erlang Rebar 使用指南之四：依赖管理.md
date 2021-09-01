# Erlang Rebar 使用指南之四：依赖管理

全文目录：

  https://github.com/rebar/rebar/wiki

本章链接：

  https://github.com/rebar/rebar/wiki/Dependency-management

## 1 rebar依赖定义

Rebar取得和构建符合OTP/Rebar规范的项目。如果项目包含子项目，Rebar会自动递归地构建它们。

项目的依赖在project_dir/rebar.config中定义，形式如下：



```r
{deps, [Dependency1, Dependency2, ...]}.
```


其中每一项(Dependency?)都按照{`App, VsnRegex, Source, [raw]`





- 'App' 指定OTP应用名称，可以是atom或字符串
- 'VsnRegex' 用于匹配版本号的正则表达式
- 'Source' 按照下面的格式指定OTP应用的地址:





```puppet
    {hg, Url, Rev} Fetch from mercury repository
    {git, Url} Fetch from git repository
    {git, Url, {branch, Branch}} Fetch from git repository
    {git, Url, ""} == {git, Url, {branch, "HEAD"}} Fetch from git repository
    {git, Url, {tag, Tag}} Fetch from git repository
    {git, Url, Rev} Fetch from git repository
    {bzr, Url, Rev} Fetch from a bazaar repository
```



`[raw]`是可选的。包含[raw]的依赖项不要求安装Erlang/OTP的项目结构。项目编译时，该依赖项不会自动被编译，但是下面的命令对其有作用：



```sql
get-deps
update-deps
check-deps
list-deps
delete-deps
```





## 2 rebar.config的例子



```clojure
{deps, [
    {em, ".*", {git, "https://github.com/sheyll/erlymock.git"}},
    {nano_trace, ".*", {git, "https://github.com/sheyll/nano_trace.git", {branch, "feature/rebar-migration"}}},
    {mochiweb, "2.3.2", {git, "https://github.com/mochi/mochiweb.git", {tag, "v2.3.2"}}},
    % Or specify a revision to refer a particular commit, useful if the project has only the master branch
    % {mochiweb, "2.3.2", {git, "https://github.com/mochi/mochiweb.git", "15bc558d8222b011e2588efbd86c01d68ad73e60"},

    % An example of a "raw" dependency:
    {rebar, ".*", {git, "git://github.com/rebar/rebar.git", {branch, "master"}}, [raw]}
   ]}.
```

