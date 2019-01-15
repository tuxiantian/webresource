---
typora-root-url: ..
---

我 fork 了别人的代码，然后做了适合自己的修改。现在他的版本有更新，和我的修改不冲突，我想直接 pull 到自己的 fork 版本中，该怎样做？

## github方式

![1](/images/git/Github怎样把新commits使用在自己的fork上/1.jpg)

![2](/images/git/Github怎样把新commits使用在自己的fork上/2.jpg)

![3](/images/git/Github怎样把新commits使用在自己的fork上/3.jpg)

![4](/images/git/Github怎样把新commits使用在自己的fork上/4.jpg)

这一页往下面拉:

![5](/images/git/Github怎样把新commits使用在自己的fork上/5.jpg)

## 命令行方式

步骤：

1、配置上游项目地址

。即将你 fork 的项目的地址给配置到自己的项目上。比如我 fork 了一个项目，原项目是 wabish/fork-demo.git，我的项目就是 cobish/fork-demo.git。使用以下命令来配置。

```text
➜ git remote add upstream https://github.com/wabish/fork-demo.git
```

然后可以查看一下配置状况，很好，上游项目的地址已经被加进来了。

```bash
➜ git remote -v
origin  git@github.com:cobish/fork-demo.git (fetch)
origin  git@github.com:cobish/fork-demo.git (push)
upstream    https://github.com/wabish/fork-demo.git (fetch)
upstream    https://github.com/wabish/fork-demo.git (push)
```

2、获取上游项目更新

。使用 fetch 命令更新，fetch 后会被存储在一个本地分支 upstream/master 上。

```text
➜ git fetch upstream
```

3、合并到本地分支

。切换到 master 分支，合并 upstream/master 分支。

```text
➜ git merge upstream/master
```

4、提交推送

。根据自己情况提交推送自己项目的代码。

```text
➜ git push origin master
```

由于项目已经配置了上游项目的地址，所以如果 fork 的项目再次更新，重复步骤 2、3、4即可。