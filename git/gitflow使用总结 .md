[TOC]
[Git工作流指南](http://blog.jobbole.com/76843/)  
[Git工作流指南：集中式工作流](http://blog.jobbole.com/76847/)  
[Git工作流指南：功能分支工作流](http://blog.jobbole.com/76857/)  
[Git工作流指南：Gitflow工作流](http://blog.jobbole.com/76867/)  
[Git工作流指南：Forking工作流](http://blog.jobbole.com/76861/)  
[Git工作流指南：Pull Request工作流](http://blog.jobbole.com/76854/)  
[git merge 和 git rebase 小结](http://blog.csdn.net/wh_19910525/article/details/7554489)  

### gitflow使用总结

#### 为master分支配套一个develop分支

git branch develop master  
git push -u origin develop `git version 1.7.1 : git push --set-upstream origin develop`  

#### 切换到develop分支

git clone ssh://user@host/path/to/repo.git  
git checkout -b develop origin/develop  

#### 创建功能分支

git checkout -b some-feature develop  
添加提交到各自功能分支上：编辑、暂存、提交：  
git status  
git add  
git commit  
git push -u origin marys-feature //-u选项设置本地分支去跟踪远程对应的分支

#### 将功能分支合并到develop，并删除功能分支

git pull origin develop  
git checkout develop  
git merge some-feature  
git push  
git branch -d some-feature  

#### 创建发布分支

git checkout -b release-0.1 develop  
添加提交到发布分支上：编辑、暂存、提交：  
git status  
git add  
git commit  

#### 完成发布，将发布分支的代码合并到master分支和develop分支，删除发布分支

git checkout master  
git merge release-0.1  
git push  
git checkout develop  
git merge release-0.1  
git push  
git branch -d release-0.1  
git push origin :branch-name //冒号前面的空格不能少，原理是把一个空分支push到server上，相当于删除该分支。

#### 打上线的tag

git tag -a 0.1 -m "Initial public release" master  
git push --tags  

git tag -l  //查看所有tag
git tag -d tag_v1.0.0_20170407  //删除本地tag
git push origin :refs/tags/tag_v1.0.0_20170407  //删除远程tag

#### 上线后的bug处理

git checkout -b issue-#001 master  
\# Fix the bug  
git checkout master  
git merge issue-#001  
git push  

git checkout develop  
git merge issue-#001  
git push  
git branch -d issue-#001  

### 冲突解决办法

git pull --rebase origin master //用git pull合并上游的修改到自己的仓库中//--rebase选项告诉Git把小红的提交移到同步了中央仓库修改后的master分支的顶部
Git在合并有冲突的提交处暂停rebase过程
运行git status命令来查看哪里有问题。冲突文件列在Unmerged paths（未合并路径）一节中

> Unmerged paths:  
> (use "git reset HEAD <some-file>..." to unstage)  
> (use "git add/rm <some-file>..." as appropriate to mark resolution)  
> both modified: <some-file>  

编辑这些文件。修改完成后，用老套路暂存这些文件，并让git rebase完成剩下的事：  
git add  
git rebase --continue  
Git会继续一个一个地合并后面的提交，如其它的提交有冲突就重复这个过程。  
如果你碰到了冲突，但发现搞不定，不要惊慌。只要执行下面这条命令，就可以回到你执行git pull --rebase命令前的样子：  
git rebase --abort  
完成和中央仓库的同步后，就能成功发布修改了：  
git push origin master  