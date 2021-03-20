使用gitlab发起merge request，审查代码/markdown方案
1. 添加变更到暂存区，并提交到本地仓库
# cd /path/to/repository

# git add . 

# git commit -m "imageclean solution"

2. 代码库命令行，手动创建分支，并push
查看本repository所有的branch，包括本地与远程，以及它们的上游分支和最后一次commit信息
# git branch -a --help

List both remote-tracking branches and local branches.


# git branch -v --help

show hash and subject, give twice for upstream branch


查看本地分支与远程追踪分支
# git branch -a -vv

* master 9ed5c7c [origin/master: ahead 1] imageclean solution
 remotes/origin/3-docker      ebea172 python package 依赖
 remotes/origin/HEAD                    -> origin/master
 remotes/origin/front-end-dev         d17bfaf 提交前端修改
 remotes/origin/master        ebea172 python package 依赖

创建分支image-clean-cron，并设置其为远程跟踪分支
创建本地分支image-clean-cron
# git branch image-clean-cron


切换本地分支image-clean-cron
# git checkout image-clean-cron


查看本地分支与远程追踪分支
# git branch -a -vv

* image-clean-cron        9ed5c7c [origin/image-clean-cron] imageclean-solution
  master       9ed5c7c [origin/master: ahead 1] solution
  remotes/origin/3-docker     ebea172 python package 依赖
  remotes/origin/HEAD                   -> origin/master
  remotes/origin/front-end-dev        d17bfaf 提交前端修改
  remotes/origin/master       ebea172 python package 依赖
  

提交本地分支代码到远程分支
# git push origin image-clean-cron -u

git: 'credential-gnome-keyring' is not a git command. See 'git --help'.
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 1.45 KiB | 1.45 MiB/s, done.
Total 4 (delta 1), reused 0 (delta 0)
remote:
remote: To create a merge request for image-clean-cron, visit:
remote:   http://202.38.69.240:10070/LeiNao/pai-maintain/merge_requests/new?merge_request%5Bsource_branch%5D=image-clean-cron
remote:
To http://202.38.69.240:10070/LeiNao/pai-maintain.git
 * [new branch]      image-clean-cron -> image-clean-cron
Branch 'image-clean-cron' set up to track remote branch 'image-clean-cron' from 'origin'.


查看推送后的本地分支与远程分支
# git branch -a -vv

* image-clean-cron    9ed5c7c [origin/image-clean-cron] imageclean solution
  master     9ed5c7c [origin/master: ahead 1]   solution
  remotes/origin/3-docker     ebea172 python package 依赖
  remotes/origin/HEAD                   -> origin/master
  remotes/origin/front-end-dev        d17bfaf 提交前端修改
  remotes/origin/image-clean-cron 9ed5c7c imageclean solution
  remotes/origin/master       ebea172 python package 依赖
