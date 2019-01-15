## Git工作流程

先上图: 

![img](https://user-gold-cdn.xitu.io/2018/12/29/167f9d6dcabe764b?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



以上包括一些简单而常用的命令，但是先不关心这些，先来了解下面这4个专有名词。

- Workapace : 工作区
- Index/Stage ：暂存区
- Repository ：仓库区（或本地仓库）
- Remote ：远程仓库

### 工作区（Workapace）

 程序员开发改动的地方，是你当前看到的，也是最新的。

 平时开发就是拷贝远程仓库中的一个分支，并基于该分支进行开发。在开发的过程中就是对工作区的操作。

### 暂存区（Index/Stage）

 .git目录下的index文件，暂存区会记录 `git add` 添加的文件的相关信息（文件名、大小...）,不保存文件实体。可以使用`git status`查看暂存区的状态。暂存区标记了你当前工作区中，哪些内容是被Git管理的。

 当你完成某个功能需要提交到远程仓库中，那么第一步就是要将更改通过`git add`提交到暂存区，被Git管理。

### 本地仓库（Repository）

 保存了对象被提交过的各个版本，比起工作区和暂存区的内容，它更旧一些。

 `git commit`后同步index的目录树到本地仓库，方便从下一步通过`git push`同步本地仓库与远程仓库。

### 远程仓库（Remote）

 远程仓库的内容可能被分布在多个地点的处于协作关系的本地仓库修改，因此它可能与本地仓库同步，也可能不同步。我们在提交之前需要`git pull`使本地仓库拉下代码。

### HEAD

 在掌握具体命令前，先理解下HEAD。

 HEAD，它始终指向当前所处分支的最新的提交点。你所处的分支变化了，或者产生了新的提交点，HEAD就会跟着改变。

无图无真相！ 

![img](https://user-gold-cdn.xitu.io/2018/12/29/167f9d77d630d42e?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



### 小结

1. 任何对象都是在工作区诞生和被修改；
2. 任何修改都是从进入index区才开始被版本控制；
3. 只有把修改提交到本地仓库，该修改才能在仓库留下足迹；
4. 与协作者分享本地的更改，需要将更改push到远程仓库

## 常用的Git命令

继续上图! 

![img](https://user-gold-cdn.xitu.io/2018/12/29/167f9d824eead150?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



### 一、新建代码库

- 在当前新目录新建一个git代码库

> $ git init

- 新建一个目录，将其初始化为First代码库

> $ git init [project-name]

- 下载一个项目和它的整个代码史

>  $ git clone [url]

### 二、配置

Git的设置文件为.gitconfig，它可以在用户主目录下（全局配置），也可以在项目目录下（项目配置）

1. 显示当前的Git配置

> $git config --list

1. 编辑Git配置文件

> $ git config -e [--global]

1. 设置提交代码时的用户信息

> $ git config [--global] [user.name](https://link.juejin.im?target=http%3A%2F%2Fuser.name) "[name]"

> $ git config [--global] user.email "[email address]"

### 三、增加/删除文件

- 添加指定文件到暂存区

>  $ git add [file1] [file2] ...

- 添加指定类型文件（使用通配符方式批量提交）到暂存区

> $ git add *.html

- 添加指定目录到暂存区

> $ git add [dir]

- 添加当前目录下的所有存在更改文件到暂存区
- （包括提交新文件(new)和被修改(modified)文件，不包括被删除(deleted)文件）

>  $ git add .

- 添加已经被add的文件且存在更改的文件（Git根路径以下所有文件）到暂存区
- （提交被修改(modified)和被删除(deleted)文件，不包括新文件(new)）

> $ git add -u

- 添加所有变化（Git根路径以下所有文件）到暂存区
- （包括提交新文件(new)、被修改(modified)文件以及被删除(deleted)文件）

>  $ git add --all

>  $ git add -A // 简写

- 添加每个变化前，都会要求确认，对于同一个文件的多处变化，可以实现分次提交

> $ git add -p

- 删除工作区文件，并且将这次删除放入暂存区

> $ git rm [file1] [file2] ...

- 停止追踪指定文件，但该文件会保留在工作区

> $  git rm -cached [file]

- 改名文件，并且将这个改名放入暂存区

> $ git mv [file-origin] [file-rename]

- 改名文件夹，并将此更改上传

> git mv -f oldfolder newfolder

> git add -u newfolder (-u选项会更新已经追踪的文件和文件夹)

> git commit -m "changed the foldername whaddup"

- 删除文件夹，并将此更改上传

> $ git rm -r --cached [dir]

> $ git commit -m '删除了dir'

> $ git push -u origin master

### 四、代码提交

- 提交暂存区到仓库区

> $ git commit -m [message] 

- 提交暂存区的指定文件到仓库区

> $ git commit [file1] [file2] ... -m [message] 

- 提交工作区自上次commit之后的变化，直接到仓库区

> $ git commit -a

- 提交时显示所有的diff信息

> $ git commit -v

- 使用一次新的commit，替代上一次提交，如果代码没有任何变化，则用来改写上一次commit的提交信息

> $ git commit --amend -m [message]

- 重做上一次commit，并包括指定文件的新变化

> $ git commit -amend [file1] [file2]...

### 五、分支

- 列出所有本地分支

>  $git branch

- 列出所有远程分支

> git branch -r

- 列出所有本地分支和远程分支

>  $ git branch -a

- 新建一个分支，但依然停留在当前分支

>  $ git branch [branch-name] 

- 新建一个分支，并切换到该分支

>  $ git branch -b [branch-name] 

- 新建一个分支，指向指定的commit

> $ git branch [branch] [commit]

- 新建一个分支，与指定远程分支建立追踪关系

> $ git branch --track [branch] [remote-branch]

- 切换到指定分支，并更新工作区

>  $ git checkout [branch-name] 

- 切换到上一分支

>  $ git checkout - 

- 建立追踪关系，在现有分支和指定的远程分支之间

> $ git branch --set-up-tream [branch] [remote-branch]

- 合并指定分支到当前分支

> $ git merge [branch] 

- 选择一个commit，合并进当前分支

> $ git cherry-pick [commit]

- 删除分支

>  $ git branch -d [branch-name] 

- 删除远程分支

> $ git push origin --delete [branch-name]

> $ git branch -dr [remote/branch]

### 六、标签

- 列出所有tag

> $ git tag

- 新建一个tag在当前commit

> $ git tag [tag]

- 新建一个tag在指定commit

> $ git tag [tag] [commit]

- 删除本地tag

> $ git tag -d [tag]

- 删除远程tag

> $ git push origin :refs/tags/[tagName]

- 查看tag信息

> $ git show [tag]

- +提交指定tag

> $ git push [remote] [tag]

- 提交所有tag

> $ git push [remote] --tages

- 新建一个分支，指向某个teg

> $ git checkout -b [branch] [tag]

### 七、查看信息

- 显示有变更的文件

> $ git status

- 显示当前分支的版本历史

> $ git log

- 显示某个commit历史，以及每次commit发生变更的文件

> $ git log [tag] HEAD --grep feature

- 显示某个commit之后的所有变动，其“提交说明”必须符合搜索条件

> $ git log [tag] HEAD --grop feature

- 显示某个文件的版本历史，包括文件改名

> $ git log --follow [file]

> $ git whatchanged [file]

- 显示过去5次的提交

> $ git log -5 --pretty --oneline

- 显示所有提交过的用户，按提交次数排序

> $ git shortlog -sn

- 显示指定文件是什么人在什么时间修改过

> $ git blame [file]

- 显示暂存区和工作区的代码差异

>  $ git diff 

- 显示暂存区和上一个commit的差异

> $ git diff -cached [file]

- 显示工作区与当前分支最新commit之间的差异

> $ git diff HEAD

- 显示两次提交之间的差异

> $ git diff [first-btanch]...[second-branch]

- 显示某次提交的元素数据和内容变化

> $ git show [commit]

- 显示某次提交时，某个文件的内容

> $ git show [commit]:[filename]

- 显示当前分支的最近几次提交

> $ git reflog

- 从本地master拉取代码更新当前分支：branch一般为master

> $ git rebase [branch]

### 八、远程分支

- 更新远程仓储

>  $ git remote update 

- 显示所有远程仓库

> $ git remote -v

- 显示某个远程仓库信息

> $ git remote show [remote]

- 增加一个新的远程仓库，并命名

> $ git remote add [shortname] [url]

- 取回远程仓库的变化，并与本地分支合并

> $ git push [remote] [branch]

- 上传本地分支到远程仓库

> $ git push [remote] [branch]

- 强行推送当前分支到远程仓库

> $ git push [remote] --force

- 推送所有分支到远程仓库

> git push [remote] --all

### 九、撤销

- 恢复暂存区的指定文件到工作区

> $ git checkout [commit] [file]

- 恢复某个commit的指定文件到暂存区和工作区

> $ git chechout .

- 重置暂存区的指定文件，与上一次commit保持一致，但工作区不变

> $ git reset [file]

- 重置暂存区和工作区，与上次commit保持一致

> $ git reset --hard

- 重置当前分支的指针为指定commit，同时是重置暂存区，但工作区不变

> $ git reset [commit]

- 重置当前分支的HEAD为指定commit，同时重置暂存区与工作区，与指定commit保持一致

> $git reset --hard [commit]

- 重置当前HEAD为指定commit，但保持暂存区和工作区不变

> $ git reset --keep [commit]

- 新建一个commit，哦用来撤销指定commit，后者的变化都被前者抵消，并且应用到当前分支

> $ git revert [commit]

- 暂时将未提交的变化移除，稍后再移入

>  $ git stash

>  $ git stash pop

### 十、其他

- 生成一个可供发布的压缩包

> $ git archive

### 版本穿梭

再声明一次：**HEAD指向的版本就是当前版本！**

#### 回到过去

对Git来说，回到过去比把大象装进冰箱还要简单，总共分两步：

1. 倘若需要进行版本切换，首先就是查看有哪些版本咯！

   - 显示从最近到最远的提交日志

   > $ git log 

   - 如果感觉眼花缭乱，可以选择单行显示

   > $ git log --pretty=oneline

2. 看到`commit fcef4ce4280229e2d4a9c914677f6e94e3539ede`了没？这就是我们的commit_id，也就是要去的地址。当然，我们不需要用这么长一段，取前五位就好。

   现在我们启动时光穿梭机!

   > $ git reset --hard commit_id

#### 重返未来

重返未来同样分两步：

1. 倘若需要重返未来，首先就是确定要回到未来的哪个版本

   - 查看命令历史

   > $ git reflog 

2. 看到`989d9ce HEAD@{……}: commit:……`了没？选择你想要的未来，出发吧！

   > $ git reset --hard commit_id

### 使用git在本地创建一个项目的过程

1. `$ makdir ~/hello-world`    //创建一个项目hello-world
2. `$ cd ~/hello-world`       //打开这个项目
3. `$ git init`             //初始化
4. `$ touch README`
5. `$ git add README`        //更新README文件
6. `$ git commit -m 'first commit'`     //提交更新，并注释信息“first commit”
7. `$ git remote add origin git@github.com:dedsf/hello-world.git`     //连接远程github项目
8. `$ git push -u origin master`     //将本地项目更新到github项目上去

## GitHub

### 什么是GitHub

 github是一个基于git的代码托管平台，付费用户可以建私人仓库，我们一般的免费用户只能使用公共仓库，也就是代码要公开。

 Git本身完全可以做到版本控制，但其所有内容以及版本记录只能保存在本机，如果想要将文件内容以及版本记录同时保存在远程，则需要结合GitHub来使用。使用场景：

- 无GitHub：在本地 .git 文件夹内维护历时文件
- 有GitHub：在本地 .git 文件夹内维护历时文件，同时也将历时文件托管在远程仓库

推荐一个文科妹子写的风趣易懂的GitHub介绍，戳这里：[如何使用 GitHub？](https://link.juejin.im?target=https%3A%2F%2Fwww.zhihu.com%2Fquestion%2F20070065%2Fanswer%2F79557687)

### 我们能用GitHub做什么

 我们一直用GitHub作为免费的远程仓库，如果是个人的开源项目，放到GitHub上是完全没有问题的。其实GitHub还是一个开源协作社区，通过GitHub，既可以让别人参与你的开源项目，也可以参与别人的开源项目。

 在GitHub出现以前，开源项目开源容易，但让广大人民群众参与进来比较困难，因为要参与，就要提交代码，而给每个想提交代码的群众都开一个账号那是不现实的，因此，群众也仅限于报个bug，即使能改掉bug，也只能把diff文件用邮件发过去，很不方便。

 但是在GitHub上，利用Git极其强大的克隆和分支功能，广大人民群众真正可以第一次自由参与各种开源项目了。

 如何参与一个开源项目呢？

 比如人气极高的bootstrap项目，这是一个非常强大的CSS框架，你可以访问它的项目主页`https://github.com/twbs/bootstrap`，点“Fork”就在自己的账号下克隆了一个bootstrap仓库，然后，从自己的账号下clone：

> clone [git@github.com](https://link.juejin.im?target=mailto%3Agit%40github.com):michaelliao/bootstrap.git

 一定要从自己的账号下clone仓库，这样你才能推送修改。如果从bootstrap的作者的仓`it@github.com:twbs/bootstrap.git`克隆，因为没有权限，你将不能推送修改。

- 如果你想修复bootstrap的一个bug，或者新增一个功能，立刻就可以开始干活，干完后，往自己的仓库推送。
- 如果你希望bootstrap的官方库能接受你的修改，你就可以在GitHub上发起一个pull request。当然，对方是否接受你的pull request就不一定了。
- 如果你没能力修改bootstrap，但又想要试一把pull request，那就Fork一下廖雪峰老师的仓库`https://github.com/michaelliao/learngit`，创建一个your-github-id.txt的文本文件，写点自己学习Git的心得，然后推送一个pull request给我，我会视心情而定是否接受。

### 小结

- 在GitHub上，可以任意Fork开源仓库；
- 自己拥有Fork后的仓库的读写权限；
- 可以推送pull request给官方仓库来贡献代码。

作者：豆包君

链接：https://juejin.im/post/5c2743f7e51d45673971ce6c

来源：掘金

著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。