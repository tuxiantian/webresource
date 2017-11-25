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