<!-- TOC -->

- [快速将本地项目提交到远程git仓库](#快速将本地项目提交到远程git仓库)
- [常用的git命令](#常用的git命令)
- [撤销尚未提交的修改](#撤销尚未提交的修改)
- [使用远程仓库的文件](#使用远程仓库的文件)
    - [用远程的文件覆盖本地的文件](#用远程的文件覆盖本地的文件)
    - [合并另一个分支的指定文件](#合并另一个分支的指定文件)
    - [git如何让单个文件回退到指定的版本](#git如何让单个文件回退到指定的版本)
    - [清除屏幕](#清除屏幕)
- [快速提交](#快速提交)
- [撤销提交](#撤销提交)
    - [反转最近一次提交](#反转最近一次提交)
        - [取消暂存](#取消暂存)
        - [复位head之前的那个版本](#复位head之前的那个版本)
- [解决向github提交代码不用输入帐号密码](#解决向github提交代码不用输入帐号密码)
    - [下面把origin地址换成ssh方式的，这样才能提交代码不必输入用户名和密码。](#下面把origin地址换成ssh方式的这样才能提交代码不必输入用户名和密码)
- [查看远程仓库的地址](#查看远程仓库的地址)
- [更改仓库远程地址](#更改仓库远程地址)
- [查看当前所处分支](#查看当前所处分支)
- [查看所有分支](#查看所有分支)
- [checkout](#checkout)
    - [用已有分支初始化新分支](#用已有分支初始化新分支)
    - [gitflow使用总结](#gitflow使用总结)
        - [为master分支配套一个develop分支](#为master分支配套一个develop分支)
        - [切换到develop分支](#切换到develop分支)
        - [创建功能分支](#创建功能分支)
        - [将功能分支合并到develop，并删除功能分支](#将功能分支合并到develop并删除功能分支)
        - [创建发布分支](#创建发布分支)
        - [完成发布，将发布分支的代码合并到master分支和develop分支，删除发布分支](#完成发布将发布分支的代码合并到master分支和develop分支删除发布分支)
        - [打上线的tag](#打上线的tag)
        - [上线后的bug处理](#上线后的bug处理)
    - [冲突解决办法](#冲突解决办法)
    - [你必须知道的git概念](#你必须知道的git概念)
        - [暂存区](#暂存区)
        - [Git中文件的4种状态](#git中文件的4种状态)

<!-- /TOC -->

## 快速将本地项目提交到远程git仓库
> 首先登陆git管理系统创建git仓库或是git项目，创建完毕后在本地执行以下操作  
> cd e:/webresource              //首先指定到你的项目目录下  
> git init  
> touch README.md  
> git remote add origin https://github.com/tuxiantian/webresource.git   //用你仓库的url  
> git add README.md  
> git commit -m "first commit"  
> git push -u origin master  //提交到你的仓库  
## 常用的git命令
> git diff master origin/master //比较本地仓库与远程仓库的异同,修改或新加的文件要添加到暂存区或提交到本地仓库，差异内容会在终端上显示  
> git diff master origin/master >> e:diff/webResource.log //比较本地仓库与远程仓库的异同,修改或新加的文件要添加到暂存区或提交到本地仓库，差异内容输出到文件便于查看  
> git <command> --help //查看某个命令的帮助文档  
> git commit -am "修改文件内容"   //提交的快捷方式，提交所有文件  
## 撤销尚未提交的修改
> git checkout head readme.txt todo.txt//撤销1、2个文件  
> git checkout head *.txt //撤销所有的txt文件  
> git checkout head . //撤销所有文件  
## 使用远程仓库的文件
### 用远程的文件覆盖本地的文件
```
git checkout -- file
```
### 合并另一个分支的指定文件
```
git checkout <branch> -- <file>
```
### git如何让单个文件回退到指定的版本
```
git log MainActivity.java
git reset a4e215234aa4927c85693dca7b68e9976948a35e MainActivity.java
git commit -a -m "commit description"
git push
```
### 清除屏幕
clear
## 快速提交
git add .  
git commit -m "commit description"  
上面两个命令可以简写为下面的命令：  
git commit -a -m "commit description"
## 撤销提交
### 反转最近一次提交
> git revert --no-commit head
#### 取消暂存
> git reset head或git reset head <file name>
#### 复位head之前的那个版本
> git reset --hard head^^ //不会再版本库中留下痕迹。我使用的这个版本两个"^"相当于一个"^"。

## 解决向github提交代码不用输入帐号密码
> https://segmentfault.com/a/1190000008435592
### 下面把origin地址换成ssh方式的，这样才能提交代码不必输入用户名和密码。
> 1. git remote rm origin
> 2. git remote add origin git@github.com:tuxiantian/webresource.git
> 3. git push -u origin master

## 查看远程仓库的地址
> git remote -v
## 更改仓库远程地址
> git version 1.7.1  
> git remote set-url --delete origin git@github.com:tuxiantian/mongodb.git  
> git remote set-url --add origin  git@192.168.0.254:server/mongodb.git  
> git push --set-upstream origin develop  
## 查看当前所处分支
> git branch
## 查看所有分支
> git branch -a
## checkout
1）创建一个新分支，并切换到该分支上 
       Git checkout –b 新分支名 
2）切换到某个已经建立的本地分支local_branch 
       Git checkout local_branch 
（使用cat .git/HEAD后，显示refs:refs/heads/local_branch） 
3) 切换到服务器上的某个分支remote_branch 
       Git checkout remote_branch 
（远程分支remote_branch可以通过 git branch –r 列出） 
4) 切换到某个commit id 
       Git checkout commit_id 
（使用git log后，显示commit_id） 
5) 切换到某个tag 
       Git checkout tag 
（使用git tag -l后，显示tag）       
### 用已有分支初始化新分支 
执行下面的命令，在切换到某个已经建立的local branch或者某个remote branch或者某个commit id 或者某个tag的同时，创建新分支new_branch，并且挂到这个新分支上。 
1） 切换到某个已经建立的本地分支local_branch，并且使用此分支初始化一个新分支new_branch。 
       git checkout –b new_branch local_branch 
2) 切换到某个远程分支remote_branch，并且用此分支初始化一个新分支new_branch。 
       Git checkout –b new_branch remote_branch 
3) 切换到某个commit id，并建立新分支new_branch 
       Git checkout –b new_branch commit_id 
4) 切换到某个tag，并建立新分支new_branch 
       Git checkout –b new_branch tag 

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
git push origin :branch-name
冒号前面的空格不能少，原理是把一个空分支push到server上，相当于删除该分支。
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
### 你必须知道的git概念
#### 暂存区
暂存区是用来准备一个提交，但可以不用把工作目录中所有的修改内容都包含进来。这样你可以创建一个高度聚焦的提交，尽管你本地修改很多内容。
#### Git中文件的4种状态
> http://www.jianshu.com/p/96beaf505865  
> Untracked Unmodify Modified Staged
