## 我写的第一个Linux脚本。主要功能是备份重启看日志，使用脚本减少发布出错的可能性。
```shell
#!/bin/sh


read -t 60 -p "请输入代码tag:" tag
echo "你输入的版本号是：$tag"
if [ -n "$tag" ]
then
   filename="com.$tag.tar.gz"
else
   filename="com.`date +%Y%m%d%H%M%S`.tar.gz"
fi
echo $filename
tar zcvf $filename /home/tomcat/tomcat_test/webapps/ROOT/WEB-INF/classes/com
mv  $filename /home/tomcat/tomcat_test/webapps/ROOT/WEB-INF/classes
kill -9 $(ps aux | grep tomcat_test | awk '{print $2}')
rm -rf /home/tomcat/tomcat_test/webapps/ROOT/WEB-INF/classes/com
cp -r /home/tomcat/publish/file/com /home/tomcat/tomcat_test/webapps/ROOT/WEB-INF/classes/
sh /home/tomcat/tomcat_test/bin/startup.sh
tail -200f /home/tomcat/tomcat_test/logs/catalina.out

```
## 两台主机切换服务时同步图片的方式
背景介绍
> 在两台主机上分别部署了一个tomcat节点，服务图片存在tomcat安装目录下，为实现服务升级不停服务，采用Nginx切换配置的方式。当一台主机发布完成，就把Nginx的请求配置切换到这台主机上。
> 在次期间需要把两个节点的图片给同步了。
### expect的安装方式
```
yum install -y tcl tclx tcl-devel
cd /usr/local
tar -zxvf expect5.45.3.tar.gz
cd expect5.45.3
./configure --with-tcl=/usr/lib64/
make && make install
ln -sf /usr/lib/expect5.45.3/libexpect5.45.3.so /usr/lib64/libexpect5.45.3.so
```
[expect5.45.3.tar.gz的下载地址](https://sourceforge.net/projects/expect/files/)  
### 使用rsync同步的脚本内容如下  
```shell
#!/usr/bin/expect

set timeout 10
spawn rsync -avzu /home/tomcat/test_rsync root@192.168.0.254:/home/tomcat/test_rsync
expect "root@192.168.0.254's password:"
set timeout 300
send "123456\r"
interact
```
密码中若含有$需要使用\转义  
使用sh expect.sh会报下面的错误
```shell
expect.sh: line 4: spawn: command not found
couldn't read file "root@192.168.0.254's password:": no such file or directory
expect.sh: line 7: send: command not found
expect.sh: line 8: interact: command not found
```
使用./expect.sh能够正确执行

### Rsync命令详解如下  
Rsync（remote synchronize） 是一个远程数据同步工具，可以使用“Rsync算法”同步本地和远程主机之间的文件。

rsync的好处是只同步两个文件不同的部分，相同的部分不在传递。类似于增量备份，

这使的在服务器传递备份文件或者同步文件，比起scp工具要省好多时间。

具体的用法：

1. 在本地机器上对两个目录同步
```
$ rsync -zvr filename1 filename2
```
上述代码是将filename1中的文件与filename2中的文件同步，如果将filename2中的文件同步到filename1中，修改代码为：
```
$ rsync -zvr filename2 filename1
```
参数说明：

-z 开启压缩

-v 详情输出

-r 表示递归

2. 使用rsync –a 同步保留时间按标记
```
$ rsync -azv filename1 filename2
```
使用上述命令，将filename2中新同步的文件的时间与filename1中的创建的时间相同，

它保留符号链接、权限、时间标记、用户名及组名相同。

3. 从本地同步文件到远程服务器
```
$rsync -avz filename1 root@192.168.0.1:/home/redhat/filename2
```
上述命令是将本地的filename1同步到远程192.168.0.1的主机上。

注意：如果远程主机的端口不是默认的22端口，假如是3000端口，上述的命令修改为，
```
$ rsync -avz '-e ssh -p 4000' filename1 root@192.168.0.1:/home/redhat/filename2
```
4. 将远程服务器的文件同步到本地

与步骤3类似，只是将filename1与远程服务器的位置对换一下，
```
$rsync -avz root@192.168.0.1:/home/redhat/filename2 filename1
```
同理如果端口不是22，使用以下命令
```
$ rsync -avz '-e ssh -p 4000' root@192.168.0.1:/home/redhat/filename2 filename1
```
### spawn scp示例

```shell
#!/usr/bin/expect

spawn scp -P62100 /home/tomcat/publish/file/main-1.0-SNAPSHOT.jar root@10.80.80.98:/home/cloud/main/
expect "root@10.80.80.98's password:"
set timeout 300
send "Lai\$2017jia\r"
interact

```
### spawn scp参数示例
transfer.sh的脚本内容如下
```shell    
#!/usr/bin/expect

set APP_NAME [lindex $argv 0]
set APP_VERSION 1.0-SNAPSHOT

spawn scp -P62100 /var/lib/jenkins/workspace/rent_micro/$APP_NAME/target/$APP_NAME-$APP_VERSION.jar  root@10.81.29.189:/home/cloud

expect "root@10.81.29.189's password:"
set timeout 5000
send "Lai\$2017jia\r"
interact

spawn scp -P62100 /var/lib/jenkins/workspace/rent_micro/$APP_NAME/target/$APP_NAME-$APP_VERSION.jar   root@10.80.80.98:/home/cloud

expect "root@10.80.80.98's password:"
set timeout 5000
send "Lai\$2017jia\r"

interact
```
执行脚本示例
```shell
./transfer.sh taskcore
```
注意以上脚本中有2个expect，相对应的就要有两个interact