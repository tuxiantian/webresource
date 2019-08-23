[TOC]

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
这个命令经常配合`git whatchanged commitid`使用。使用`git whatchanged commitid`可以查看某次提交修改的文件列表。经常会遇到这样的需求，就是将B分支的某次提交合并到A分支上面，就可以使用`git whatchanged commitid`得到文件路径，然后使用`git checkout <branch> -- <file>`拉取另一个分支上面的文件。
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
更改仓库远程地址要注意的是使用上面的命令只能将当前分支的代码推到新的远程仓库，如果要将其它分支的代码也推到新的远程仓库，那么需要切回原来的远程仓库地址，再次推送。
另外tag是需要单独推送的。
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


### 你必须知道的git概念
#### 暂存区
暂存区是用来准备一个提交，但可以不用把工作目录中所有的修改内容都包含进来。这样你可以创建一个高度聚焦的提交，尽管你本地修改很多内容。
#### Git中文件的4种状态
> http://www.jianshu.com/p/96beaf505865  
> Untracked Unmodify Modified Staged
