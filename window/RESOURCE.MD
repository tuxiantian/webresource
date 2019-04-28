---
typora-root-url: ..
---

## 1. 如何查看某个端口被谁占用
[如何查看某个端口被谁占用](http://jingyan.baidu.com/article/3c48dd34491d47e10be358b8.html)
查看被占用端口对应的PID，输入命令：netstat -aon|findstr "49157"，回车，记下最后一位数字，即PID,
输入tasklist|findstr "2720"，回车，查看是哪个进程或者程序占用了2720端口，结果是：svchost.exe，
结束端口的占用进程taskkill /f /t /im svchost.exe 。

大多数情况下都是java.exe进程占据了端口导致服务启动不了，所以可以直接尝试使用taskkill /f /t /im java.exe。

## 2. 常用的路径
我的桌面路径 C:\Users\Administrator\Desktop
qq文件下载目录 C:\Users\tuxt\Documents\Tencent Files\791978859\FileRecv

## 3. 批量修改文件的后缀名
[批量修改文件的后缀名](http://jingyan.baidu.com/article/e9fb46e196ea187521f7661a.html)  

```
ren *.txt *.MD
```

## 4. Windows系统如何清除DNS缓存？
cmd窗口执行下面的命令  
ipconfig /flushdns

## 检查网络的常用ping命令
ipconfig/all 查看网络配置详细信息  
ping 127.0.0.1 检验本地网络协议是否装好  
ping 本机ip 检验本地网络适配是否正常  
ping 默认网关 检验本机到最近的路由器连接是否正常  
选择自动获取ip时，本机ip是由dhcp服务器分配的ip  

## 复印身份证攻略
![](/images/window/复印身份证的攻略.png)

## 修改域名

像Linux的/etc/hosts一样，windows也有一个类似的hosts文件，C:/WINDOWS/system32/drivers/etc/hosts
添加如下域名与IP的映射：
```
127.0.0.1       www.mytest.com
```
在这里可以设置本地域名，让域名指向你想要的ip,启动Tomcat，如果是8080默认域名的话，在浏览器输入 http://www.test.com:8080， 就可以访问看到那只猫了。

[Win10笔记本关闭盖子不自动休眠不关屏幕设置](https://jingyan.baidu.com/article/6b182309add5b9ba59e15972.html)