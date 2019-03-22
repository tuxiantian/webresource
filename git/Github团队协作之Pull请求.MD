---
typora-root-url: ..
---


# Github团队协作之Pull请求

Pull请求(Pull request)
## 1 综述
    协作者通过fork一个新的代码库用来独立开发，并通过Github上的Pull Request，将变更贡献回原始代码库。这其中对Github的要求较低，至少免费使用，操作也相对简单，是一种不错的协作方式。以下将图文并茂的展示整个协作过程！

## 2 步骤
### 2.1 Fork拷贝原始代码仓库

    首先在原始代码库的Github网页上Fork其代码仓库，此时会在自己的Github上生成原始代码库的一份拷贝。注意这里有两种用户：原始代码仓库拥有者和Fork代码仓库拥有者。
输入原始代码库网址
点击网页上的Fork按钮，拷贝原始代码仓库，此时会跳转到自己的Github账号页面上。
### 2.2 克隆Fork代码仓库到本地

    接下来使用git clone命令克隆一份Fork代码库到本地计算机。
git clone git@github.com:HengStruggle/GitTest.git
    进入到克隆下来的Git代码库里，可对文件进行修改，最后在提交到本地代码仓库。
cd GitTest //进入到克隆下来的Git代码库里
    打印GitTest.txt文件内容，并在文件尾添加自己的用户名，最后再提交到本地代码仓库。说明：一个较好的习惯是在master上另建一个分支，再进行修改，最后再提交新建的分支；主分支用于存储原始代码仓库的代码
1 cat .\GitTest.txt  
2 "version 0.2 by HengStruggle">>.\GitTest.txt  
3 git commit --all -m "version 0.2"  
### 2.3 Push 本地代码仓库到Github代码仓库

    接下来将本地代码仓库推送到Github上的Fork代码仓库上，注意不是原始代码仓库。
git push -u origin master
### 2.4 最后一步：Pull request

    进入我们fork的代码库的GitHub页面，选择需要提交给原始代码仓库的分支，然后点击Pull Request按钮，再点击new pull request按钮，最后再确认。如图1，图2，图3。至此你作为协作者的任务已经完成，接下来的事就是等待原始仓库拥有者合并你提交的代码。

![](/images/git/Github团队协作之Pull请求/1.png)  
图1

![](/images/git/Github团队协作之Pull请求/2.png)  
图2

![](/images/git/Github团队协作之Pull请求/3.png)  
图3

### 2.5 原始仓库拥有者合并收到的Pull请求

    作为原始仓库拥有者有两种方式合并收到的Pull请求。说明：推荐在本地计算机上进行合并方式，灵活性较强。
#### 2.5.1 在GitHub上合并

Github上合并，首先要找到合并页面。进入合并页面的方式有多种，其中一种可以打开Github上主页面，点击左上角的铃铛图标，可以查看最近收到的Pull请求；另外在主页左边也可以直接查看别人的请求信息。如图4。  
确保没有冲突之后，点击Merge pull request按钮，如图5。  
最后合并成功，如图6。  
注意：在GitHub上进行合并，必须确保没有冲突产生  
#### 2.5.2 在本地计算机上进行合并

合并前先在本地仓库里新建一个分支  
git checkout -b HengStruggle-master master  
拉取协作者远程仓库的Pull请求分支到本地仓库，注意这里的Pull请求分支不一定总是master，要视具体情况而定。注意：这里拉取的是协作者的代码仓库的Pull请求分支！ 
```
git pull https://github.com/HengStruggle/GitTest.git master  
```
常规的合并分支并Push代码  
```
git checkout master  
git merge --no-ff HengStruggle-master  
git push origin master  
```

![](/images/git/Github团队协作之Pull请求/4.png)  
图4

![](/images/git/Github团队协作之Pull请求/5.png)  
图5

![](/images/git/Github团队协作之Pull请求/6.png)  
图6