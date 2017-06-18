[如何查看某个端口被谁占用](http://jingyan.baidu.com/article/3c48dd34491d47e10be358b8.html)
查看被占用端口对应的PID，输入命令：netstat -aon|findstr "49157"，回车，记下最后一位数字，即PID,
输入tasklist|findstr "2720"，回车，查看是哪个进程或者程序占用了2720端口，结果是：svchost.exe，
结束端口的占用进程taskkill /f /t /im svchost.exe 。

我的桌面路径 C:\Users\Administrator\Desktop