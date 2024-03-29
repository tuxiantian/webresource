---
typora-root-url: ..\..
---


# netstat 的 10 个基本用法

**Netstat 简介**

Netstat 是一款命令行工具，可用于列出系统上所有的网络套接字连接情况，包括 tcp, udp 以及 unix 套接字，另外它还能列出处于监听状态（即等待接入请求）的套接字。如果你想确认系统上的 Web 服务有没有起来，你可以查看80端口有没有打开。以上功能使 netstat 成为网管和系统管理员的必备利器。在这篇教程中，我会列出几个例子，教大家如何使用 netstat 去查找网络连接信息和系统开启的端口号。



以下的简单介绍来自 netstat 的 man 手册：

> netstat – 打印网络连接、路由表、连接的数据统计、伪装连接以及广播域成员。

1. 列出所有连接

第一个要介绍的，是最简单的命令：列出所有当前的连接。使用 -a 选项即可。
![](/images/linux/netstat的10个基本用法/1.jpg)


上述命令列出 tcp, udp 和 unix 协议下所有套接字的所有连接。然而这些信息还不够详细，管理员往往需要查看某个协议或端口的具体连接情况。

2. 只列出 TCP 或 UDP 协议的连接

使用 -t 选项列出 TCP 协议的连接：
![](/images/linux/netstat的10个基本用法/2.jpg)


使用 -u 选项列出 UDP 协议的连接：
![](/images/linux/netstat的10个基本用法/3.jpg)


上面同时显示了 IPv4 和 IPv6 的连接。

3. 禁用反向域名解析，加快查询速度

默认情况下 netstat 会通过反向域名解析技术查找每个 IP 地址对应的主机名。这会降低查找速度。如果你觉得 IP 地址已经足够，而没有必要知道主机名，就使用 -n 选项禁用域名解析功能。
![](/images/linux/netstat的10个基本用法/4.jpg)


上述命令列出所有 TCP 协议的连接，没有使用域名解析技术。So easy ? 非常好。

4. 只列出监听中的连接

任何网络服务的后台进程都会打开一个端口，用于监听接入的请求。这些正在监听的套接字也和连接的套接字一样，也能被 netstat 列出来。使用 -l 选项列出正在监听的套接字。
![](/images/linux/netstat的10个基本用法/5.jpg)


现在我们可以看到处于监听状态的 TCP 端口和连接。如果你查看所有监听端口，去掉 -t 选项。如果你只想查看 UDP 端口，使用 -u 选项，代替 -t 选项。

注意：不要使用 -a 选项，否则 netstat 会列出所有连接，而不仅仅是监听端口。

5. 获取进程名、进程号以及用户 ID

查看端口和连接的信息时，能查看到它们对应的进程名和进程号对系统管理员来说是非常有帮助的。举个栗子，Apache 的 httpd 服务开启80端口，如果你要查看 http 服务是否已经启动，或者 http 服务是由 apache 还是 nginx 启动的，这时候你可以看看进程名。

使用 -p 选项查看进程信息。
![](/images/linux/netstat的10个基本用法/6.jpg)


使用 -p 选项时，netstat 必须运行在 root 权限之下，不然它就不能得到运行在 root 权限下的进程名，而很多服务包括 http 和 ftp 都运行在 root 权限之下。

相比进程名和进程号而言，查看进程的拥有者会更有用。使用 -ep 选项可以同时查看进程名和用户名。
![](/images/linux/netstat的10个基本用法/7.jpg)


上面列出 TCP 协议下的监听套接字，同时显示进程信息和一些额外信息。

这些额外的信息包括用户名和进程的索引节点号。这个命令对网管来说很有用。

注意 – 假如你将 -n 和 -e 选项一起使用，User 列的属性就是用户的 ID 号，而不是用户名。

6. 打印统计数据

netstat 可以打印出网络统计数据，包括某个协议下的收发包数量。

下面列出所有网络包的统计情况：
```
$ netstat -s
Ip:
    32797 total packets received
    0 forwarded
    0 incoming packets discarded
    32795 incoming packets delivered
    29115 requests sent out
    60 outgoing packets dropped
Icmp:
    125 ICMP messages received
    0 input ICMP message failed.
    ICMP input histogram:
        destination unreachable: 125
    125 ICMP messages sent
    0 ICMP messages failed
    ICMP output histogram:
        destination unreachable: 125
... OUTPUT TRUNCATED ...
```
如果想只打印出 TCP 或 UDP 协议的统计数据，只要加上对应的选项（-t 和 -u）即可，so easy。

7. 显示内核路由信息

使用 -r 选项打印内核路由信息。打印出来的信息与 route 命令输出的信息一样。我们也可以使用 -n 选项禁止域名解析。
![](/images/linux/netstat的10个基本用法/8.jpg)


8. 打印网络接口

netstat 也能打印网络接口信息，-i 选项就是为这个功能而生。

![](/images/linux/netstat的10个基本用法/9.jpg)

上面输出的信息比较原始。我们将 -e 选项和 -i 选项搭配使用，可以输出用户友好的信息。

![](/images/linux/netstat的10个基本用法/10.jpg)

上面的输出信息与 ifconfig 输出的信息一样。

9. netstat 持续输出

我们可以使用 netstat 的 -c 选项持续输出信息。

> $ netstat -ct

这个命令可持续输出 TCP 协议信息。

10. 显示多播组信息

选项 -g 会输出 IPv4 和 IPv6 的多播组信息。

![](/images/linux/netstat的10个基本用法/11.jpg)

**更多用法**

目前为止我们列出了 netstat 的基本用法，现在让我们一起来 geek 吧～

**打印 active 状态的连接**

active 状态的套接字连接用 “ESTABLISHED” 字段表示，所以我们可以使用 grep 命令获得 active 状态的连接：

![](/images/linux/netstat的10个基本用法/12.jpg)

配合 watch 命令监视 active 状态的连接：

> $ watch -d -n0 "netstat -atnp | grep ESTA"

**查看服务是否在运行**

如果你想看看 http,smtp 或 ntp 服务是否在运行，使用 grep。

![](/images/linux/netstat的10个基本用法/13.jpg)

从这里可以看到 ntp 服务正在运行。使用 grep 命令你可以查看 http 或 smtp 或其它任何你想查看的服务。

好了，netstat 的大部分功能都介绍过了，如果你想知道 netstat 更高级的功能，阅读它的手册吧（man netstat）。