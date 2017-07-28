<!-- TOC -->

- [1. 如何查看某个端口被谁占用](#1-如何查看某个端口被谁占用)
- [2. 常用的路径](#2-常用的路径)
- [3. 批量修改文件的后缀名](#3-批量修改文件的后缀名)
- [4. Windows系统如何清除DNS缓存？](#4-windows系统如何清除dns缓存)

<!-- /TOC -->
## 1. 如何查看某个端口被谁占用
[如何查看某个端口被谁占用](http://jingyan.baidu.com/article/3c48dd34491d47e10be358b8.html)
查看被占用端口对应的PID，输入命令：netstat -aon|findstr "49157"，回车，记下最后一位数字，即PID,
输入tasklist|findstr "2720"，回车，查看是哪个进程或者程序占用了2720端口，结果是：svchost.exe，
结束端口的占用进程taskkill /f /t /im svchost.exe 。

## 2. 常用的路径
我的桌面路径 C:\Users\Administrator\Desktop
qq文件下载目录 C:\Users\tuxt\Documents\Tencent Files\791978859\FileRecv

## 3. 批量修改文件的后缀名
[批量修改文件的后缀名](http://jingyan.baidu.com/article/e9fb46e196ea187521f7661a.html)  
ren *.txt *.MD

## 4. Windows系统如何清除DNS缓存？
cmd窗口执行下面的命令  
ipconfig /flushdns