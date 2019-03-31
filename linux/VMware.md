虚拟机设置-网络适配器-NAT模式

/etc/sysconfig/network-scripts/ifcfg-eth0

```
BOOTPROTO="dhcp"
ONBOOT="yes"

```

然后ifconfig会看到ip

这个时候就可以使用xshell去连本机的Linux虚拟机了。这种设置方式既能够让xshell可以连上本机的Linux虚拟机，同时本机的Linux虚拟机也可以访问到外网。

CentOs系统下载地址

<http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-DVD-1810.iso>

**Linux如何查看是32位还是64位的方法**

```
getconf LONG_BIT
```

**查看内核版本**

```
uname -r
```

**使用sz命令向服务器传文件**

```
yum install -y lrzsz
```

sz 文件名 

从服务器向本地计算机发送文件

rz

从本地计算机向服务器传文件  