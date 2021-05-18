Git清理删除历史提交文件
既然来到这里，想必你认为你的Git工程已经处于臃肿状态了，一些很久之前引入的大文件，而现在又不用这些大文件的情况下，请不要迟疑进行清理操作。

常见的Git清理方式有两种，一种是使用BFG工具，另外一种是使用git filter-branch手动处理。

注意：无论使用哪种方式，都涉及破坏性操作，使用时应严格谨慎。在开始操作之前，请使用--mirror参数克隆备份你的Git仓库。

使用BFG的方式，简单易操作，使用方法可参考BFG Repo-Cleaner 。

本文主要介绍的是使用 git filter-branch 的方式进行瘦身操作。

为了模拟整个过程，让我们先从一个从0到1的demo开始吧。

1.建立远程仓库
为了模拟团队协作，需要一个远程仓库，可以选择GitHub或码云上建立仓库，这里选择码云 ，仓库名字为 gitthin，地址为 git@gitee.com:coderhony/gitthin.git。

2.克隆到本地
通过Terminal，把刚才新建的代码文件克隆到本地。

$ cd ~/Desktop/
$ mkdir gitthin && cd gitthin
$ git clone git@gitee.com:coderhony/gitthin.git
此时在Desktop的gitthin文件夹下，就有一份Git管理的仓库了。

3.基本操作
$ cd gitthin
$ echo -n "战国是一个群国争雄的时代，今天的故事就从战国开始" > zhanguo.txt
$ git add .
$ git commit -m "创建了zhanguo.txt文件"
$ echo -n "战国的开端是由赵魏韩三家分晋开始，从此战国进入七雄争霸的时代" >> zhanguo.txt
$ git add .
$ git commit -m "战国开端"
$ echo -n "这七个国家分别是：秦、齐、楚、燕、魏、赵、韩" >> zhanguo.txt
$ git add .
$ git commit -m "七个国家的名字"
$ echo -n "秦国地处西陲，楚国位居南方，齐国傲居东海，燕国地处北面，魏国、赵国、韩国三国在中间" >> zhanguo.txt
$ git add .
$ git commit -m "七国的地理位置"

# 切换分支
$ git checkout -b qinguo
$ echo -n "战国开始时，秦国还比较贫弱，一直受东边的魏国欺负，今天魏国夺占五城，明天秦国抢回三城，一直处于这种状态" > qinguo.txt
$ git add .
$ git commit -m "创建了qinguo.txt文件"
$ echo -n "当时的魏国很强大，魏文侯时期，启用李悝变法，使魏国经济富庶，后来有任用吴起训练魏武卒，一直不断蚕食着秦国" >> qinguo.txt
$ git add .
$ git commit -m "秦国受魏国欺负"
$ echo -n "这种情况到秦孝公时开始有所好转，秦孝公启动商鞅，进行变法，奖励农耕，奖励军功，经过了二十年，秦国已不容小觑矣" >> qinguo.txt
$ git add .
$ git commit -m "秦孝公启用商鞅变法"
4.添加大文件
生成一个有 1000000 行随机字符串的大文本文件

# 大文件来袭
$ perl -le 'for (1..1000000) { print map { (0..9, "a".."z")[rand 36] } 1..80 }' > bigqin
$ git add .
$ git commit -m "商鞅变法，秦国战斗力直线上升"
查看大文件情况

$ du -sh .git
55M     .git
可以看到.git的大小为 55M。

在该大文件的内容后面，追加一些内容：

$ perl -le 'print map { (0..9, "a".."z")[rand 36] } 1..80' >> bigqin
$ git add .
$ git commit -m "又过几年，秦国的战斗力又提高了很多"
查看此时.git文件大小

$ du -sh .git
110M    .git
可以看到，此时.git文件夹的大小变成了110M。

5.继续常规提交
一百多年后，秦国所向披靡，横扫六合，一统天下。

$ echo -n "秦国变法后一百年，国力不断增强，其他诸侯为之色变，王霸之业已不能满足，开始横扫六合，一统天下，终于在嬴政时期得以实现" >> qinguo.txt
$ git add .
$ git commit -m "秦国一统天下"
把qinguo分支推送到远程：

$ git push origin qinguo
切换到master分支,并继续提交代码

$ git checkout master

$ echo -n "其他六国不断被秦国攻打，闻之色变，但又没有及时变法，寻求强大之道，之后逐个被秦国所灭" >> zhanguo.txt
$ git add .
$ git commit -m "其他六国逐个被秦国所灭"
合并qinguo的内容：

$ git merge qinguo
新建分支,并进行一些提交

$ git checkout -b chuhan

$ echo -n "秦统一六国之后，苛捐杂税不断加重，大肆修建宫殿，导致百姓痛苦不堪" > chuhan.txt
$ git add .
$ git commit -m "创建了chuhan.txt文件"
$ echo -n "随着陈胜吴广起义后，各国旧部开始起来反抗" >> chuhan.txt
$ git add .
$ git commit -m "各路人马起义反秦"
$ echo -n "先入咸阳者称王，刘邦先入了咸阳" >> chuhan.txt
$ git add .
$ git commit -m "刘邦入咸阳"

$ 推送到远程
$ git push origin chuhan
6.删除大文件
此时，要删除大文件bigqin。

1.垃圾回收
先进行垃圾回收，并压缩一些文件

$ git gc --prune=now
Git最初向磁盘中存储对象使用松散的格式，后续会将多个对象打包为一个二进制的包文件（packfile），以节省磁盘空间

.pack文件存储了对象的内容

.idx文件存储了包文件的偏移信息，用于`索引具体的对象

打包对象时，查找命名和大小相近的文件，保留文件不同版本之间的差异（最新一版保存完整内容，访问频率最高）

2.查找大文件
使用git rev-list --objects —all显示所有commit及其所关联的所有对象：

$ git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -3 | awk '{print$1}')"

e9461c55c3b8807351909cf7bb46eb22a8df5533 README.md
b866711af76e7d7cc87d9828f8ddde8ea865d053 bigqin
8d675f2ad83219ad4ebe34fe4dcac3a7139002ea bigqin
verify-pack -v *.idx：查看压缩包内容

3.删除指定的大文件
$ git filter-branch --force --index-filter "git rm -rf --cached --ignore-unmatch bigqin" --prune-empty --tag-name-filter cat -- --all
Rewrite bf551acd0ca40a5671bcf2d4cad83a999b8baf52 (10/16) (0 seconds passed, remaining 0 predicted)    rm 'bigqin'
Rewrite d1d31551ecb36d362fd1051152f1fc886e4df95c (11/16) (0 seconds passed, remaining 0 predicted)    rm 'bigqin'
Rewrite da902adff9f3f890aa4c3304c5ac6d1e14f589da (12/16) (0 seconds passed, remaining 0 predicted)    rm 'bigqin'
Rewrite c96090316c3600e6e190cb9f99cf14a58f6f09ca (13/16) (0 seconds passed, remaining 0 predicted)    rm 'bigqin'
Rewrite 9d6c9194d76c5e0aa6c9119445681c9fbdf735a3 (14/16) (1 seconds passed, remaining 0 predicted)    rm 'bigqin'
Rewrite b1e2f243a559547e3a0f5eaa18f6a31a35eaa57a (14/16) (1 seconds passed, remaining 0 predicted)    rm 'bigqin'
Rewrite ac49fbb891648b73bbd31b4e82b56bbd71254384 (14/16) (1 seconds passed, remaining 0 predicted)    rm 'bigqin'
.....
filter-branch 命令通过一个filter来重写历史提交，这个filter针对指定的所有分支(rev-list)运行。

--index-filter：过滤Git仓库的index，该过滤命令作用于git rm -rf --cached --ignore-unmatch bigqin。不checkout到working directory，只修改index的文件，速度快。

--cached会删除index中的文件

--ignore-unmatch：如果没匹配到文件，不会报错，会继续执行命令

最后一个参数file/directory是要被删除的文件的名字

--prune-empty：指示git filter-branch 完全删除所有的空commit。

-–tag-name-filter：将每个tag指向重写后的commit。

cat命令会在收到tag时返回tag名称

–-选项用来分割 rev-list 和 filter-branch 选项

--all参数告诉Git我们需要重写所有分支（或引用）。

注意：git rm 这一行命令使用双引号"git rm -rf --cached --ignore-unmatch bigqin"

4.删除缓存
移除本地仓库中指向旧提交的剩余refs，git for-each-ref 会打印仓库中匹配refs/original的所有refs，并使用delete作为前缀，此命令通过管道传送到 git update-ref 命令，该命令会移除所有指向旧commit的引用。

$ git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
以下命令会使reflog到期，因为它依然包含着对旧commit的引用。使用--expire=now 参数，确保它在目前为止到期了。如果没有该参数，只会移除超过90天的reflog。

$ git reflog expire --expire=now --all
现在本地仓库依然包含着所有旧commit的对象，但已经没有引用指向它们了，这些对象需要被删除掉。此时可以使用 git gc 命令，Git的垃圾回收器会删除这些没有引用指向的对象。

$ git gc --prune=now
gc使用--prune 参数来清理特定时期的对象，默认情况下为2周，指定now将删除所有这些对象而没有时期限制。

$ du -sh .git
104K    .git
此时，.git文件的大小只有104k了。

7.提交重写的历史到远程
如果确认所做的删除大文件操作没有问题，就可以提交到远程仓库了，一旦提交，再也没有办法恢复到原来的状态，一定要小心谨慎！一定要小心谨慎！一定要小心谨慎！

先进行备份工作，以免出现问题：

$ cd ~/Desktop/
$ mkdir gitthin_mirror && cd gitthin_mirror
$ git clone --mirror git@gitee.com:coderhony/gitthin.git
再回到刚才做的已经瘦身的Git仓库

$ cd ~/Desktop/gitthin/gitthin
把已瘦身的仓库同步到远程仓库，使用—mirror参数：

$ git push --mirror git@gitee.com:coderhony/gitthin.git
为了确保都已同步，再执行以下命令：

$ git push --all --force
Everything up-to-date
$ git push --tags --force
Everything up-to-date
8.更新其他的clone
在过滤存储库，并重写提交历史后，将更改强制推送到远程服务器之后。现在要更新该存储库的每一份clone，仅靠常用的pull是无法做到这一点的。

第一步是从远程服务器获取存储库，使用git reset 将存储库从 origin/master 切换到旧存储库状态。

$ git fetch origin
$ git reset --hard origin/master
和上面的一样，需要删除旧提交，清理本地仓库

$ git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
$ git reflog expire --expire=now --all
$ git gc --prune=now
参考资料：
Remove files from git history

Git++ - 仓库瘦身

git瘦身

寻找并删除Git记录中的大文件

为什么你的 Git 仓库变得如此臃肿

Maintaining a Git Repository

Removing sensitive data from a repository

如何瘦身 Git 仓库

记一次删除Git记录中的大文件的过程

作者：牧晓逸风
链接：https://www.jianshu.com/p/7ace3767986a
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

