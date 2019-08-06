总有一天你会遇到下面的问题.

(1)改完代码匆忙提交,上线发现有问题,怎么办? 赶紧回滚.

(2)改完代码测试也没有问题,但是上线发现你的修改影响了之前运行正常的代码报错,必须回滚.

这是开发中很常见的问题,所以git的取消提交,回退甚至返回上一版本都是特别重要的.

大致分为下面2种情况:



## 1没有push

这种情况发生在你的本地代码仓库,可能你add ,commit 以后发现代码有点问题,准备取消提交,用到下面命令
```
reset
git reset [--soft | --mixed | --hard]
```

上面常见三种类型



--mixed

会保留源码,只是将git commit和index 信息回退到了某个版本.
```
git reset 默认是 --mixed 模式 
git reset --mixed  等价于  git reset
```

--soft

保留源码,只回退到commit 信息到某个版本.不涉及index的回退,如果还需要提交,直接commit即可.



--hard

源码也会回退到某个版本,commit和index 都回回退到某个版本.(注意,这种方式是改变本地代码仓库源码)

当然有人在push代码以后,也使用 reset --hard <commit...> 回退代码到某个版本之前,但是这样会有一个问题,你线上的代码没有变,线上commit,index都没有变,当你把本地代码修改完提交的时候你会发现全是冲突.....

所以,这种情况你要使用下面的方式





## 2已经push

对于已经把代码push到线上仓库,你回退本地代码其实也想同时回退线上代码,回滚到某个指定的版本,线上,线下代码保持一致.你要用到下面的命令

> revert

git revert用于反转提交,执行revert命令时要求工作树必须是干净的.

git revert用一个新提交来消除一个历史提交所做的任何修改.

revert 之后你的本地代码会回滚到指定的历史版本,这时你再 git push 既可以把线上的代码更新.(这里不会出现像使用reset造成冲突的问题)

### revert commit

revert 使用,需要先找到你想回滚版本唯一的commit标识代码,可以用 git log 或者在adgit搭建的web环境历史提交记录里查看.

git revert c011eb3c20ba6fb38cc94fe5a8dda366a3990c61  
通常,前几位即可

git revert c011eb3

revert过程有可能遇到冲突，要么git revert --abort终止此次revert操作，代码还原至revert命令前。要么手动消除冲突(同普通的冲突解决)，然后add commit

### revert merge
适用于merge操作的commit

假设当前状态：
```
commit 94ce4b8dcb898f730e6eecd73c00491f8020b67e
Merge: a2471f3 6a17d85
本次属于merge commit,注意Merge 标注
Author: 罗** <luo**@youku.com>
Date:   Fri May 20 11:03:53 2016 +0800

    merge

commit a2471f331c36a21d25aa158668cdc05987eef114
Author: 罗** <luo**@youku.com>
Date:   Fri May 20 11:03:01 2016 +0800

    verison 9

commit 6a17d85b04e52eddeb2ecb2a311804e10dada1e6
Author: 罗** <luo**@youku.com>
Date:   Fri May 20 11:02:10 2016 +0800

    version 8

commit 9441871ec2ff071e1a5be41646a32b2aea0b5502
Author: 罗** <luo**@youku.com>
Date:   Fri May 20 10:56:08 2016 +0800

    version 7
```
可以看到94ce4b8是一次merge commit,Merge 标注为Merge: a2471f3 6a17d85，意思是说当前分支commit a2471f3（version 9）,加上来自其他分支的commit 6a17d85（version 8）.此时要撤销94ce4b8所表示的merge.

如果不指定-m参数
```
git revert 94ce4b8dcb898f730e6eecd73c00491f8020b67e
error: 提交 94ce4b8dcb898f730e6eecd73c00491f8020b67e 是一个合并提交但未提供 -m 选项。
fatal: 还原失败
```
指定-m参数
```
 git revert 94ce4b8dcb898f730e6eecd73c00491f8020b67e -m 2
# 位于分支 develop
无文件要提交，干净的工作区
```
-m参数含义：Merge 标注为Merge: a2471f3 6a17d85，传1表示撤销到a2471f3所代表的commit，传2表示撤销到6a17d85所代表的commit。数字1,2表示的是标注冒号后的位置编号

上面例子中传参-m 2,所以撤销到6a17d85,最终文件状态与6a17d85 commit后一致(注意与上文差异)，本例子中结果状态是“version 8”，不是version 7, git log确认结果如下：
```
commit 290c2f72d8d56d6be1008807450d4635095a549b
Author: 罗** <luo**@youku.com>
Date:   Fri May 20 11:32:34 2016 +0800

    Revert "merge"

    This reverts commit 94ce4b8dcb898f730e6eecd73c00491f8020b67e, reversing
    changes made to 6a17d85b04e52eddeb2ecb2a311804e10dada1e6.
```

git revert是用一次新的commit来回滚之前的commit，git reset是直接删除指定的commit，看似达到的效果是一样的,其实完全不同.


* 上面我们说的如果你已经push到线上代码库, reset 删除指定commit以后,你git push可能导致一大堆冲突.但是revert 并不会.

* 如果在日后现有分支和历史分支需要合并的时候,reset 恢复部分的代码依然会出现在历史分支里.但是revert 方向提交的commit 并不会出现在历史分支里.

* reset 是在正常的commit历史中,删除了指定的commit,这时 HEAD 是向后移动了,而 revert 是在正常的commit历史中再commit一次,只不过是反向提交,他的 HEAD 是一直向前的.