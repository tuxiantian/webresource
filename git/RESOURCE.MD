# 新手快速使用git
打开公司内网的git网址注册一个用户http://192.168.0.254/users/sign_in
生成ssh公私钥，参考下面的说明
## github ssh无密钥登陆
 ssh-keygen 不是内部或外部命令
 > http://blog.csdn.net/zy_281870667/article/details/50443403

生成ssh公私钥命令如下  
ssh-keygen -t rsa -C "tuxiantian@163.com"  //Enter passphrase (empty for no passphrase):注意在这一步的时候不要输入密码，后续提交才能不用输入密码  
操作示例图如下  
![](/images/git/nopassword.png)  
在github网站上添加C:\Users\tuxt\.ssh\目录下生成的公钥  
若出现下面的提示，就是尚未给新用户分配仓库的权限
![](/images/git/clone_error.png)  
给新用户分配仓库的权限，操作示例图如下  
![](/images/git/assign_permission.png)  
新用户使用gitbash客户端窗口配置用户名和邮箱，然后就可以克隆仓库，正常提交和更新仓库文件了。  
##  git中文文件名、目录名乱码应该怎么解决？
git config core.quotepath false  
core.quotepath设为false的话，就不会对0x80以上的字符进行quote。中文显示正常  

## 常用的git命令
> cd e:/webresource              //首先指定到你的项目目录下  
> git init  
> touch README.md  
> git add README.md  
> git commit -m "first commit"  
> git remote add origin https://github.com/tuxiantian/webresource.git   //用你仓库的url  
> git push -u origin master  //提交到你的仓库  
> git diff master origin/master //比较本地仓库与远程仓库的异同,修改或新加的文件要添加到暂存区或提交到本地仓库，差异内容会在终端上显示
> git diff master origin/master >> e:diff/webResource.log //比较本地仓库与远程仓库的异同,修改或新加的文件要添加到暂存区或提交到本地仓库，差异内容输出到文件便于查看  
> git <command> --help //查看某个命令的帮助文档
> git commit -am "修改文件内容"   //提交的快捷方式，提交所有文件  
## 撤销尚未提交的修改
> git checkout head readme.txt todo.txt//撤销1、2个文件  
> git checkout head *.txt //撤销所有的txt文件  
> git checkout head . //撤销所有文件  
## 撤销提交
### 反转最近一次提交
> git revert --no-commit head
#### 取消暂存
> git reset head或git reset head <file name>
#### 复位head之前的那个版本
> git reset --hard head^^ //不会再版本库中留下痕迹。我使用的这个版本两个"^"相当于一个"^"。
 
## 提交本地项目到github仓库的方法
> git init
> 在.gitigonre文件中编写过滤规则
> 1. git add .	//添加所有文件到暂存区，对于untracked文件会接受.gitigonre文件的过滤
> 2. git status	//查看暂存区中添加的所有文件
> 3. git rm --cache *	//移除暂存区中的所有文件
> 重复上面三步确定项目要提交的文件
> git remote add origin https://github.com/tuxiantian/webresource.git
> git push -u origin master
> 注意在github网站上面先创建repository,否则会提交失败

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
## 合并另一个分支的指定文件
> git checkout <branch> -- <file>
## 查看当前所处分支
> git branch
## 查看所有分支
> git branch -a

### Git工作流指南
> http://blog.jobbole.com/76843/
### Git工作流指南：集中式工作流
> http://blog.jobbole.com/76847/
### Git工作流指南：功能分支工作流
> http://blog.jobbole.com/76857/
### Git工作流指南：Gitflow工作流
> http://blog.jobbole.com/76867/
### Git工作流指南：Forking工作流
> http://blog.jobbole.com/76861/
### Git工作流指南：Pull Request工作流
> http://blog.jobbole.com/76854/

### gitflow使用总结
#### 为master分支配套一个develop分支
git branch develop master  
git push -u origin develop  
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
