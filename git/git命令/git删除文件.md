git删除指定文件夹
1、在本地仓库删除指定文件
git rm 文件名名称

2、在本地仓库删除指定文件夹
git rm -r 文件夹/

3、提交修改
git commit -m"删除文件夹"

4、推送到远程仓库
git push origin 远程仓库连接

5、git  rm命令
git rm -h
用法：git rm [<选项>] [--] <文件>...
 
    -n, --dry-run         演习
    -q, --quiet           不列出删除的文件
    --cached              只从索引区删除
    -f, --force           忽略文件更新状态检查
    -r                    允许递归删除
    --ignore-unmatch      即使没有匹配，也以零状态退出