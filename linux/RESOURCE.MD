### 文件操作命令
mkdir -p language/android 连续创建目录以及子目录
cd或cd ~ 切换到家目录
cd - 切换到上次操作的命令

linux快速清空文件内容  
\> filename  
echo "" > filename

Linux 删除除了某个文件之外的所有文件  
rm -f !(a|b)

合并文件命令
cat a.txt b.txt > ab.txt

查看文件最后修改时间
stat 文件名

查看文件头10行
head -n 10 example.txt

查看文件尾10行
tail -n 10 example.txt

按照文件大小排序
du –sh * |sort –n

列出文件夹里的所有内容,包括以"."开头的隐藏文件 
ls -a 

只显示文件夹     ls -l | grep ^d
只显示文件       ls -l | grep ^-
文件是以 "-"开头 ， 文件夹是 d

查看统计当前目录下文件的个数，包括子目录里的。
ls -lR| grep "^-" | wc -l[
### find命令汇总
批量删除空文件  
find . -name "*" -type f -size 0c | xargs -n 1 rm -f  

会从 /doc 目录开始往下找，找寻文件名是 ja 开头或者 ma开头的文件。  
find /doc \( -name 'ja*' -o- -name 'ma*' \) –print  

查询出所有的空文件夹  
find -type d -empty  

从根目录开始查找所有扩展名为.log的文本文件,并找出包含"ERROR"的行  
find / -type f -name "*.log" | xargs grep "ERROR"  

查找目录下的所有文件中是否含有某个字符串  
find .|xargs grep -ri "IBM"  

查找目录下的所有文件中是否含有某个字符串,并且只打印出文件名  
find .|xargs grep -ri "IBM" -l  

查找大文件  
find . -type f -size +200M -print0 | xargs -0 du -h | sort -nr  

find /var/log/ -mtime +3 -type f -print  3天前  
find /var/log/ -mtime -3 -type f -print  3天内  
find /var/log/ -mtime 3 -type f -print   第3天  
find /var/log/ -mtime +2 -mtime -4 -type f -print  

find   ./   -type   d   |   wc   -l     (目录个数)
find   ./   -type   f   |   wc   -l     (文件个数)
### curl命令
curl -d 'req_json={"beans":[],"busiId":"queryVertifyLogs","params":{}}'  http://10.96.18.213:30001/ol_java/RealnameServlet  
注意后面的地址中若是有！，则需要使用\进行转义  
用@RequestParam接收多个参数的查询示例  
curl -d sn="250006222" -d startTime=1503367557000 -d endTime=1503367857000 http://localhost:8083/mongodb/devicedata/findCarHistoryTrack  


curl多次尝试连接
curl --retry 10 --retry-delay 60 --retry-max-time 60 http://www.baidu.com/ -o baidu_html
注： --retry表示重试次数； --retry-delay表示两次重试之间的时间间隔（秒为单位）； --retry-max-time表示在此最大时间内只容许重试一次（一般与--retry-delay相同）

-d/--data <data>   HTTP POST方式传送数据

设置http响应头处理
curl -H "Connection:keep-alive \n User-Agent: Mozilla/5.0" http://www.aiezu.com

分块下载文件 -o保存
curl -r 0-1024000 -o new_divide_1.mp3 http://vfile/55750a8be70.mp3

查看头信息
curl -I http://www.taobao.com/
检测web容器是否正常启动
wget http://localhost:8083/mongodb/index.html

### 设置tomcat自动启动
[linux教程：[4]配置Tomcat开机启动](http://jingyan.baidu.com/article/6525d4b1382f0aac7d2e9421.html)  
[Linux下chkconfig命令详解](http://www.cnblogs.com/panjun-Donet/archive/2010/08/10/1796873.html)  
[服务不支持chkconfig的解决](http://blog.chinaunix.net/uid-10697776-id-3187846.html)  

### 查看磁盘、目录占用大小
查看磁盘： df -lh

查看目录占用大小：du -lh

### 压缩命令及解压缩命令
tar压缩：tar -zcvf file.tar.zip file  

解压tar：tar -zxvf file.tar.zip  
解压tar到指定目录：tar -zxvf file.tar.zip -C  directory  

解压zip：unzip xxx.zip  
unzip -o -d /home/sunny myfile.zip 把myfile.zip文件解压到 /home/sunny/  
-o:不提示的情况下覆盖文件；  
-d:-d /home/sunny 指明将文件解压缩到/home/sunny目录下；  

解压war：jar -xvf xxx.war  
### 新解压的tomcat无执行权限问题
>Cannot find ./catalina.sh  
>The file is absent or does not have execute permission  
>This file is needed to run this program  

解决方法：tomcat的bin目录下执行下面的命令  
chmod u+x *.sh
### sed命令
截取一段时间的日志
```shell
sed -n '/2014-06-04 14:00:/,/2014-06-04 15:00:/p' catalina.out > ~/catalina.out.20140604-14 
```
只查看文件的第5行到第10行  
```shell
sed –n '5,10p' /etc/passwd 
```
显示第一行
```shell
sed -n '1p' filename 
```
删除文件中的空行  
```shell
sed '/^$/d' file  
```
替换内容
1. 替换并输出（不修改源文件）： 
```shell
sed  's/dog/cat/g' file 
```
dog被替换的内容，cat替换的内容 

2. 备份后直接替换至源文件：  
```shell
sed -i.bak 's/dog/cat/g' file 
```
进程处理文件中的记录调用省端接口，常有超时的任务，要统计日志文件中超时任务的数量  
```shell
sed -n '起始行号,结束行号p'| grep 'java.util.concurrent.TimeOutException'|wc -l  
```
### linux防火墙
开启： chkconfig iptables on  
关闭： chkconfig iptables off  

查看防火墙状态：  
/etc/init.d/iptables status或service iptables status  

即时生效，重启后失效  
开启： service iptables start  
关闭： service iptables stop  

service iptables save  

iptables -L 查看一下当前的规则  
iptables -X 清除预设表filter中使用者自定链中的规则  

iptables -A INPUT  -p tcp --dport 22 -j ACCEPT  
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT  

### 要封停一个ip
iptables -I INPUT -s ***.***.***.*** -j DROP

### 要解封一个IP，使用下面这条命令：
iptables -D INPUT -s ***.***.***.*** -j DROP
-I是表示Insert（添加），-D表示Delete（删除）DROP表示放弃连接

### 开启9090端口的访问
/sbin/iptables -I INPUT -p tcp --dport 9090 -j ACCEPT
## grep
grep AND 操作
grep -E 'pattern1.*pattern2' filename

grep or
egrep 'pattern1|pattern2' filename
grep -e pattern1 -e pattern2 filename

grep not
grep -v 'pattern1' filename

-o 只输出文件中匹配到的部分
-P 选项是利用PERL的正则语法进行匹配
－n：显示匹配行及 行号

grep accept 92028.txt|grep 16:58:15 |grep -Po '192\.168\.\d{2,}\.\d{2,}'|sort|uniq -c

grep -A 1 除了列出符合行之外，并且列出后NUM行
grep -A1 -n "api.weixin.qq.com/cgi-bin/" *.log | grep -v "api.weixin.qq.com" | awk '$6 > 5'

排除所有空行
grep -v '^$'
## 服务器命令
shutdown -h now 关机  
shutdown -r now 重启  

env 查看当前用户环境变量  

同步服务器时间  
sudo ntpdate -u ntp.api.bz  

uptime 命令用于查看服务器运行了多长时间以及有多少个用户登录，快速获知服务器的负荷情况
load average: 0.53, 0.31, 0.25
最近1分钟、5分钟、15分钟系统的负载

iostat命令主要用于查看机器磁盘IO情况
iostat -xz 1

查看当前语言环境
echo $LANG

修改环境语言，在命令行下直接输入：LANG=en_US
设置完成，只在本窗口有效，其他窗口无效。

### 去除特殊字符
sed -i 's/^M//g’ env.sh  去除文件的特殊字符, 比如^M

启动和停止脚步的编码问题导致服务不能够启动的解决办法

## 将文件的系统编码由dos改为unix

set ff?

设置文件的字符集编码是unix

set ff=unix

## 设置系统编码

export LANG=zh_CN.UTF-8

vim /etc/sysconfig/i18n

LANG=zh_CN.UTF-8

source /etc/sysconfig/i18n

echo $LANG