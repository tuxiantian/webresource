---
typora-root-url: ..
---

![](/images/linux/写代码怎能不会这些Linux命令.png)

### 更改目录的所有者权限
[每天一个linux命令（30）: chown命令](http://www.cnblogs.com/peida/archive/2012/12/04/2800684.html)

chown -R tomcat:tomcat com/  
chmod 777 fileDir
### 拷贝覆盖
cp -rf sourcefile targetdir或cp -r -f sourcefile targetdir  
-r的意思是递归复制，也就是复制文件夹及其下所有文件  
-f的意思是遇到同名的文件，不提示，直接覆盖  
### rsync
rsync -avzu --progress -e "ssh -p 62100" /home/tomcat/tomcat7/webapps/ROOT/upload   root@10.80.80.98:/home/tomcat/tomcat8/webapps/ROOT
输入目的主机的密码  

u选项，指定不覆盖原目录内容

rsync同步两台主机上面的目录，与scp的差别就是已存在的文件不会被覆盖，注意目的主机不要指定要同步的目录，而是指定要同步的目录的父级目录。  
yum install rsync -y  
若报rsync : command not found，则是因为没有安装rsync，执行上面的命令安装即可。  
### scp使用示例
scp local_file remote_username@remote_ip:remote_file  
scp -P62100 -r /home/tomcat/publish root@39.107.32.220:/home/tomcat/  
### Linux快速清屏
Ctrl+l 清屏
### 查看当前目录的各个子目录大小
du -h --max-depth=1  有当前目录的总大小  
du -sh *  显示当前目录的各子目录大小，不包含当前目录的总大小  
du -sh *|sort -rh  显示当前目录的各子目录大小并排序  
### 查看当前主机对应的外网ip
curl ipinfo.io  
curl ifconfig.me  

### 监控tomcat并且执行重启操作
```shell
#!/bin/sh

TomcatMonitorLog=/home/tomcat/publish/bin/monitor.log
tomcatId=$(ps aux | grep tomcat8 |grep tomcat8/conf|grep -v grep | awk '{print $2}')
switch=1
Monitor(){
    if [ $switch == 1 ] ;then
	echo "[info]开始监控tomcat...[$(date +'%F %H:%M:%S')]"  
	if [[ $tomcatId ]]
	then  
                echo "tomca启动正常,当前tomcat进程ID为:$tomcatId" 
	else  
            echo "tomcat没有启动"  
	    sh /home/tomcat/tomcat8/bin/startup.sh
        fi  
    fi
}

Monitor>>$TomcatMonitorLog 

```
crontab -e
```
* * * * * sh /home/tomcat/publish/bin/monitor.sh
```

使用crontab命令监控，crontab用法参考
[每天一个linux命令（50）：crontab命令](https://www.cnblogs.com/peida/archive/2013/01/08/2850483.html)