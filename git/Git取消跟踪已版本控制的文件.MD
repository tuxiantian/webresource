# Git 取消跟踪已版本控制的文件

Git 是一个很好的版本控制工具，当然驾驭起来相比 SVN 要稍微复杂一些。初入 Git，难免有一些问题。比如我们不小心将某个文件加入了版本控制，但是突然又不想继续跟踪控制这个文件了，怎么办呢？

其实方法也是很简单的。使用git update-index 即可。

不想继续追踪某个文件
```
git update-index --assume-unchanged your_file_path
```
如果想再次继续跟踪某个文件
```
git update-index --no-assume-unchanged your_file_path
```