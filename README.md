# webresource
useful website collections

## 常用的git命令
> cd e:/webresource              //首先指定到你的项目目录下  
> git init  
> touch README.md  
> git add README.md  
> git commit -m "first commit"  
> git remote add origin https://github.com/tuxiantian/webresource.git   //用你仓库的url  
> git push -u origin master  //提交到你的仓库  

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

