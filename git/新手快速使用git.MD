---
typora-root-url: ..
---

[TOC]

## 新手快速使用git

[git下载地址](https://git-scm.com/downloads)
打开[公司内网的git网址](http://192.168.0.254/users/sign_in)注册一个用户
生成ssh公私钥，参考下面的说明
### github ssh无密钥登陆
 ssh-keygen 不是内部或外部命令
 > http://blog.csdn.net/zy_281870667/article/details/50443403

生成ssh公私钥命令如下  
ssh-keygen -t rsa -C "tuxiantian@163.com"  //Enter passphrase (empty for no passphrase):注意在这一步的时候不要输入密码，后续提交才能不用输入密码  
操作示例图如下  
![](/images/git/nopassword.png)

在github网站上添加C:\Users\tuxiantian\.ssh目录下生成的公钥  
若出现下面的提示，就是尚未给新用户分配仓库的权限
![](/images/git/clone_error.png)  
给新用户分配仓库的权限，操作示例图如下  
![](/images/git/assign_permission.png)  
新用户使用gitbash客户端窗口配置用户名和邮箱，然后就可以克隆仓库，正常提交和更新仓库文件了。  
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

###  git中文文件名、目录名乱码应该怎么解决？
git config core.quotepath false  
core.quotepath设为false的话，就不会对0x80以上的字符进行quote。中文显示正常  

## 设置idea使用rebase提交
rebase提交方式可以让git log显示为一条直线，更加方便提交记录的查看
![](/images/git/git_idea.png)

## 提交本地项目到github仓库的方法
> git init  
> 在.gitigonre文件中编写过滤规则  
> 1. git add .	//添加所有文件到暂存区，对于untracked文件会接受.gitigonre文件的过滤  
> 2. git status//查看暂存区中添加的所有文件  
> 3. git rm --cache *//移除暂存区中的所有文件  
>    重复上面三步确定项目要提交的文件  
>    git remote add origin https://github.com/tuxiantian/webresource.git  
>    git push -u origin master  
>    注意在github网站上面先创建repository,并且创建repository时不要选择初始化README.MD，否则会提交失败  

### 解决每次git pull需要输入用户名密码的问题

[解决每次git pull需要输入用户名密码的问题](https://www.jianshu.com/p/faba73a28a7c)

```
git config --global credential.helper store
```

