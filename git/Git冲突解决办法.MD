## Git冲突：commit your changes or stash them before you can merge. 解决办法
用git pull来更新代码的时候，遇到了下面的问题：
```
error: Your local changes to the following files would be overwritten by merge:
    xxx/xxx/xxx.php
Please, commit your changes or stash them before you can merge.
Aborting
```
出现这个问题的原因是其他人修改了xxx.php并提交到版本库中去了，而你本地也修改了xxx.php，这时候你进行git pull操作就好出现冲突了，解决方法，在上面的提示中也说的很明确了。

1、保留本地的修改 的改法

1）直接commit本地的修改

2）通过git stash
```
git stash  
git pull  
git stash pop  
```
通过git stash将工作区恢复到上次提交的内容，同时备份本地所做的修改，之后就可以正常git pull了，git pull完成后，执行git stash pop将之前本地做的修改应用到当前工作区。

git stash: 备份当前的工作区的内容，从最近的一次提交中读取相关内容，让工作区保证和上次提交的内容一致。同时，将当前的工作区内容保存到Git栈中。

git stash pop: 从Git栈中读取最近一次保存的内容，恢复工作区的相关内容。由于可能存在多个Stash的内容，所以用栈来管理，pop会从最近的一个stash中读取内容并恢复。

git stash list: 显示Git栈内的所有备份，可以利用这个列表来决定从那个地方恢复。

git stash clear: 清空Git栈。此时使用gitg等图形化工具会发现，原来stash的哪些节点都消失了。

2、放弃本地修改的改法
```
git reset --hard
git pull
```