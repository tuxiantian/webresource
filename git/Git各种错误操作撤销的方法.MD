---
typora-root-url: ..
---

# Git各种错误操作撤销的方法
## 概述
在平时工作中使用git难免会提交一些错误的文件到git库里，这时候，撤销吧，怕把正确的文件删除了，不撤销重新改又很麻烦，下面，我就从提交的三个阶段，来讲解如何撤销错误的操作。
## Git Add了一个错误文件
### 解决方法
这种情况一般发生在新创建的项目，执行命令：

git add .

命令执行完后发现增加了错误的文件，比如Pycham自动生成的.idea文件夹。比如下图：
![](/images/git/Git各种错误操作撤销的方法/1.png)


这时候，我想撤销add .idea这个操作，可以这么做：
```
git reset <file> #撤销指定的文件
git reset #撤销所有的文件
```
执行完这个命令后，效果如下：  
![](/images/git/Git各种错误操作撤销的方法/2.png)


可以看到.idea这个目录变成了Untracked了。完美解决。 如果你在执行的时候遇到如下的错误：

```
fatal: Failed to resolve 'HEAD' as a valid ref.

```
如果遇到这个错误，就说明你的本地git仓库从来没有执行过git commit操作，导致HEAD指针不存在。这时候你可以通过如下的命令撤销操作：

```
git rm --cached .   #删除文件
git rm -r --cached . #删除文件和目录

```
### 如何避免
* .gitignore: 把不需要提交的文件增加到这个文件
* git add : 增加指定的文件，少用点号
## Git Commit了一个错误文件
### 举例
我现在有个文件的状态如下：  
![](/images/git/Git各种错误操作撤销的方法/3.png)


执行git diff blog-test.py后结果如下：  
![](/images/git/Git各种错误操作撤销的方法/4.png)


可以看到我增加了一行，现在把文件提交到本地仓库：  
![](/images/git/Git各种错误操作撤销的方法/5.png)


可以看到，本地以及没有需要提交的文件了。这时候，我发现，这个修改是错误的，我需要撤销这次commit，我该怎么做了？

### 只撤销commit操作，保留文件
执行命令如下：

git reset HEAD~1
执行完效果如下：  
![](/images/git/Git各种错误操作撤销的方法/6.png)


可以看到，commit被撤销了，但是修改的部分还保留着。完美解决。不信看git log  
![](/images/git/Git各种错误操作撤销的方法/7.png)


### 撤销commit操作，删除变化
执行命令如下：

git reset --hard HEAD~1
执行完后效果如下：  
![](/images/git/Git各种错误操作撤销的方法/7_5.png)


可以看到，我增加的那一行已经没有了，git log中也没有了那次的提交记录：  
![](/images/git/Git各种错误操作撤销的方法/8.png)


完美

### 如何避免
* git status: 查看是否有不需要的文件被add进来
* git diff: 查看文件的变化部分，是否是想提交的
  查看更多
  Git如何取消最新一次的commit

## 如何删除分支
好，现在有个很严重的问题，我的分支里代码不用了，现在要删除，怎么整。

### 分支没有push到远程
删除本地的分支很简单：

git branch -d branch_name
举例截图如下：  
![](/images/git/Git各种错误操作撤销的方法/9.png)


### 分支已经push到远程
我现在本地和远程都有一个test分支，如下图：  
![](/images/git/Git各种错误操作撤销的方法/10.png)


执行如下的命令删除本地和远程的test分支：

```
git push origin --delete test
git checkout master
git branch -d test
#git branch -D test 如果有未提交的文件，用它

```
执行完效果如下：  
![](/images/git/Git各种错误操作撤销的方法/11.png)


可以看到都删掉了。