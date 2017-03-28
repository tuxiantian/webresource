## 常用的git命令
> cd e:/webresource              //首先指定到你的项目目录下  
> git init  
> touch README.md  
> git add README.md  
> git commit -m "first commit"  
> git remote add origin https://github.com/tuxiantian/webresource.git   //用你仓库的url  
> git push -u origin master  //提交到你的仓库  
> git diff master origin/master //比较本地仓库与远程仓库的异同,修改或新加的文件要添加到暂存区或提交到本地仓库

> git commit -am "修改文件内容"   //提交的快捷方式，提交所有文件  
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

##  git中文文件名、目录名乱码应该怎么解决？
git config core.quotepath false  
core.quotepath设为false的话，就不会对0x80以上的字符进行quote。中文显示正常
## 查看远程仓库的地址
> git remote -v

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