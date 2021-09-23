# 清空 Git 仓库全部历史记录

1. 切换到 master 分支

   ```
   git checkout master
   ```

2. 创建一个干净的分支

   ```
   git checkout --orphan new_master
   ```

3. 提交全部文件

   ```
   git add -A
   git commit -m "msg"
   ```

4. 删除 master 分支

   ```
   git branch -D master
   ```

5. 将新分支重命名为 master

   ```
   git branch -m master
   ```

6. 强制推动到远程仓库

   ```
   git push -f origin master
   ```

