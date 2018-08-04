## checkout 、reset 还是 revert ？

### checkout

版本控制系统背后的思想就是「安全」地储存项目的拷贝，这样你永远不用担心什么时候不可复原地破坏了你的代码库。当你建立了项目历史之后，git checkout 是一种便捷的方式，来将保存的快照「解包」到你的工作目录上去。 `git checkout` 可以检出提交、也可以检出单个文件甚至还可以检出分支(此处省略)。

```
git checkout 5aab391
```

检出v2,当前工作目录和`5aab391`完全一致，你可以查看这个版本的文件编辑、运行、测试都不会被保存到git仓库里面。你可以`git checkout master` 或者 `git checkout -`回到原来的工作状态上来。

```
git checkout 5aab391 v1.js
```

以检出v2版本对于v1.js的改动，只针对v1.js这个文件检出到`5aab391`版本。所以 它会影响你当前的工作状态，它会把当前状态的v1.js文件内容覆盖为`5aab391`版本。所以除非你清楚你在做什么，最好不要轻易的做这个操作。但这个操作对于舍弃我当前的所有改动很有用：比如当前我在v1.js上面做了一些改动，但我又不想要这些改动了，而我又不想一个个去还原，那么我可以`git checkout HEAD v1.js` 或者 `git checkout -- v1.js`

### reset 重置

和 `git checkout` 一样, `git reset` 有很多用法。

```
git reset <file>
```

从暂存区移除特定文件，但不改变工作目录。它会取消这个文件的缓存，而不覆盖任何更改。

```
git reset
```

重置暂存区，匹配最近的一次提交，但工作目录不变。它会取消所有文件的暂存，而不会覆盖任何修改，给你了一个重设暂存快照的机会。

```
git reset --hard
```

加上`--hard`标记后会告诉git要重置缓存区和工作目录的更改，就是说：先将你的暂存区清除掉，然后将你所有未暂存的更改都清除掉，所以在使用前确定你想扔掉所有的本地工作。

```
git reset <commit>
```

将当前分支的指针HEAD移到 ，将缓存区重设到这个提交，但不改变工作目录。所有  之后的更改会保留在工作目录中，这允许你用更干净、原子性的快照重新提交项目历史。

```
git reset --hard <commit>
```

将当前分支的指针HEAD移到 ，将缓存区和工作目录都重设到这个提交。它不仅清除了未提交的更改，同时还清除了  之后的所有提交。

可以看出，`git reset` 通过取消缓存或者取消一系列提交的操作会摒弃一些你当前工作目录上的更改，这样的操作带有一定的危险性。下面我们开始介绍一种相对稳妥的方式 `revert`

### revert 撤销

`git revert`被用来撤销一个已经提交的快照。但实现上和reset是完全不同的。通过搞清楚如何撤销这个提交引入的更改，然后在最后加上一个撤销了更改的 新 提交，而不是从项目历史中移除这个提交。

```
git revert <commit>
```

生成一个撤消了  引入的修改的新提交，然后应用到当前分支。

![img](https://user-gold-cdn.xitu.io/2018/7/27/164da5f083cd9c5b?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

例如：

```
81f734d commit after bug
        |
3a395af bug
        |
3aa5dfb v3  (<- HEAD)
        |
5aab391 v2
        |
ff7b88e v1
        |
95d7816 init commit

复制代码
```

我们在`3a395af` 引入了一个bug，我们明确是由于`3a395af`造成的bug的时候，以其我们通过新的提交来fix这个bug，不如`git revert`, 让他来帮你剔除这个bug。

```
git revert 3a395af
```

得到结果

```
cfb71fc Revert "bug"
        |
81f734d commit after bug
        |
3a395af bug
        |
3aa5dfb v3  (<- HEAD)
        |
5aab391 v2
        |
ff7b88e v1
        |
95d7816 init commit

```

这个时候bug的改动被撤销了，产生了一个新的commit，但是`commit after bug`没有被清初。

所以相较于`reset` ，`revert`不会改变项目历史，对那些已经发布到共享仓库的提交来说这是一个安全的操作。其次`git revert`可以将提交历史中的任何一个提交撤销、而`reset`会把历史上某个提交及之后所有的提交都移除掉，这太野蛮了。

另外`revert`的设计，还有一个考量，那就是撤销一个公共仓库的提交。至于为什么不能用`reset`，你们可以自己思考一下。 下面我们就用一个麻烦事（回滚一个错误的合并），来讲解这个操作。

## 合并操作

相对于常规的`commit`，当使用`git merge <branch>`合并两个分支的时候，你会得到一个新的`merge commit`. 当我们`git show <commit>`的时候会出现类似信息：

```
commit 6dd0e2b9398ca8cd12bfd1faa1531d86dc41021a
Merge: d24d3b4 11a7112
Author: 前端杂货铺 
...............
复制代码
```

`Merge: d24d3b4 11a7112` 这行表明了两个分支在合并时，所处的parent的版本线索。

比如在上述项目中我们开出了一个dev分支并做了一些操作，现在分支的样子变成了这样：

```
init -> v1 -> v2 -> v3  (master)
           \      
            d1 -> d2  (dev)
```

当我们在dev开发的差不多了

```
#git:(dev)
git checkout master 
#git:(master)
git merge dev
```

这个时候形成了一个Merge Commit `faulty merge`

```
init -> v1 -> v2 -> v3 -- faulty merge  (master)
           \            /
            d1  -->  d2  (dev)
```

此时`faulty merge`有两个parent 分别是v3 和 d2。

## 回滚错误的合并

这个merge之后还继续在dev开发，另一波人也在从别的分支往master合并代码。变成这样：

```
init -> v1 -> v2 -> v3 -- faulty merge -> v4 -> vc3 (master)
        \  \            /                     /
         \  d1  -->  d2  --> d3 --> d4  (dev)/
          \                                 / 
           c1  -->  c2 -------------------c3 (other)
```

这个时候你发现， 上次那个merge 好像给共享分支master引入了一个bug。这个bug导致团队其他同学跑不通测试，或者这是一个线上的bug，如果不及时修复老板要骂街了。

这个时候第一想到的肯定是回滚代码，但怎么回滚呢。用`reset`?不现实，会把别人的代码也干掉，所以只能用`revert`。而`revert`它最初被设计出来就是干这个活的。

怎么操作呢？首先想到的是上面所说的 `git revert <commit>` ,但是貌似不太行。

```
git revert faulty merge
error: Commit faulty merge is a merge but no -m option was given.
fatal: revert failed
```

这是因为试图撤销两个分支的合并的时候Git不知道要保留哪一个分支上的修改。所以我们需要告诉git我们保留那个分支`m` 或者`mainline`.

```
git revert -m 1 faulty merge
```

`-m`后面带的参数值 可以是1或者2，对应着parent的顺序.上面列子：1代表`v3`，2代表`d2` 所以该操作会保留master分支的修改，而撤销dev分支合并过来的修改。

提交历史变为

```
init -> v1 -> v2 -> v3 -- faulty merge -> v4 -> vc3 -> rev3 (master)
          \            /                     
           d1  -->  d2  --> d3 --> d4  (dev)
```

此处`rev3`是一个常规commit，其内容包含了之前在`faulty merge`撤销掉的dev合并过来的commit的【反操作】的合集。

到这个时候还没完，我们要记住，因为我们抛弃过之前dev合并过来的commit，下次dev再往master合并，之前抛弃过的其实是不包含在里面的。那怎么办呢？

## 恢复之前的回滚

很简单我们把之前master那个带有【反操作】的commit给撤销掉不就好了？

```
git checkout master
git revert rev3
git merge dev
```

此时提交历史变成了

```
init -> v1 -> v2 -> v3 -- faulty merge -> v4 -> vc3 -> rev3 -> rev3` -> final merge (master)
          \            /                                               /
           d1  -->  d2  --> d3 --> d4  --------------------------------(dev)

```



 

 