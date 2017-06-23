### vi文本编辑命令
#### vi光标定位操作
gg 跳到文件头  
0 定位到行首  
$ 定位到当前行行尾  
shift+A 定位到当前行行尾并编辑  
gg 定位到首行首列  
shift+g 定位到文件末尾  
o 在当前行下面插入一行  
O 在当前行上面插入一行  
w 按单词移动光标  
f + 字母 移动到当前行该字母所在位置  

:set nu 显示行号  
:set nonu 去除行号  
:数字 调到指定行  

echo "hello,world!" > out.log        #直接输出到
echo "hello,world!" >> out.log      #以添加的形式输出到
echo "ssss!" >> out.log 2>&1       #指定错误级别输出到
### 文件操作命令
mkdir -p language/android 连续创建目录以及子目录
cd或cd ~ 切换到家目录
cd - 切换到上次操作的命令

linux快速清空文件内容  
\> filename  
echo "" > filename
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
### curl命令
curl -d 'req_json={"beans":[],"busiId":"queryVertifyLogs","params":{}}'  http://10.96.18.213:30001/ol_java/RealnameServlet
注意后面的地址中若是有！，则需要使用\进行转义

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
### 日志操作
tail -f tomcat_ol*/logs/catalina.20160628.out  
tail -500f tomcat_ol*/logs/catalina.20160628.out    查看最后500行日志
查看各个节点最新的日志  
find tomcat_ol*/logs/ -name "catalina.20160628.out" | xargs grep "关键字"

由于测试环境多人看日志，所以会互相干扰，现在总结以下看日志的方法。  
方法一  
可以作为关键字的有时间和线程号。先根据日志关键字查找，然后选择其中一个日志关键字所在时间点，查看前后50行日志。  
find -name "catalina.20170317.out" | xargs grep "call wuzhihua url"  
find -name "catalina.20170317.out" | xargs grep  -A150 -B150 "2010-11-17 09:25:55,622"  
find -name "catalina.20170317.out" | xargs grep  -A150 -B150 "call wuzhihua result"  
方法二  
过滤出时间区间段的日志  
sed -n '/时间戳1/,/时间戳2/p' catalina.out>catalina.txt  
实例操作：  
sed -n '/2014-06-04 14:00:/,/2014-06-04 15:00:/p' catalina.out>catalina.txt  
sed -n '/2014-06-04 14:[0-5][0-5]:/,/2014-06-04 15:[0-5][0-5]:/p' catalina.out>catalina.txt    可以使用正则表达式  

vi 日志文件  
/关键字  
从当前位置向下搜索，n搜索下一个匹配的关键字  
?关键字  
从当前位置向上搜索，n搜索下一个匹配的关键字  
根据日期找最近的日志，根据线程号找上下文日志  
#### 统计日志文件中java.util.concurrent.TimeOutException的数量
进程处理文件中的记录调用省端接口，常有超时的任务，要统计日志文件中超时任务的数量  
sed -n '起始行号,结束行号p'| grep 'java.util.concurrent.TimeOutException'|wc -l  

### 设置tomcat自动启动
[linux教程：[4]配置Tomcat开机启动](http://jingyan.baidu.com/article/6525d4b1382f0aac7d2e9421.html)  
[Linux下chkconfig命令详解](http://www.cnblogs.com/panjun-Donet/archive/2010/08/10/1796873.html)  
[服务不支持chkconfig的解决](http://blog.chinaunix.net/uid-10697776-id-3187846.html)  

### 查看磁盘、目录占用大小
查看磁盘： df -lh

查看目录占用大小：du -lh
### 根据端口号，查找对应的进程  
netstat -alp | grep  2181  
### 根据进程号查看进程信息
ps aux | grep 3567  
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
sed -n '/2014-06-04 14:00:/,/2014-06-04 15:00:/p' catalina.out > ~/catalina.out.20140604-14 截取一段时间的日志

sed –n '5,10p' /etc/passwd 这样你就可以只查看文件的第5行到第10行  
sed -n '1p' filename 显示第一行  
sed '/^$/d' file 删除文件中的空行  
1、替换并输出（不修改源文件）：  
sed  's/dog/cat/g' file dog被替换的内容，cat替换的内容  
2、备份后直接替换至源文件：  
sed -i.bak 's/dog/cat/g' file  
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
### Linux将命令添加到PATH中
简单说PATH就是一组路径的字符串变量，当你输入的命令不带任何路径时，LINUX会在PATH记录的路径中查找该命令。有的话则执行，不存在则提示命令找不到。比如在根目录/下可以输入命令ls,在/usr目录下也可以输入ls,但其实ls命令根本不在这个两个目录下，当你输入ls命令时LINUX会去/bin,/usr/bin,/sbin等目录寻找该命令。而PATH就是定义/bin:/sbin:/usr/bin等这些路劲的变量，其中冒号为目录间的分割符。  
如何自定义路径：  
假设你新编译安装了一个apache在/usr/local/apache下，你希望每次启动的时候不用敲一大串字符（# /usr/local/apache/bin/apachectl start）才能使用它，而是直接像ls一样在任何地方都直接输入类似这样（# apachectl start）的简短命令。这时，你就需要修改环境变量PATH了，准确的说就是给PATH增加一个值/usr/local/apache/bin。将/usr/local/apache/bin添加到PATH中有三种方法：  

1、直接在命令行中设置PATH  
PATH=$PATH:/usr/local/apache/bin  
使用这种方法,只对当前会话有效，也就是说每当登出或注销系统以后，PATH设置就会失效。  

2、在profile中设置PATH  
vi /etc/profile  
找到export行，在下面新增加一行，内容为：export PATH=$PATH:/usr/local/apache/bin。  
注：＝ 等号两边不能有任何空格。这种方法最好,除非手动强制修改PATH的值,否则将不会被改变。  
编辑/etc/profile后PATH的修改不会立马生效，如果需要立即生效的话，可以执行# source profile命令。  

3、在当前用户的profile中设置PATH  
vi ~/.bash_profile  
修改PATH行,把/usr/local/apache/bin添加进去,如：PATH=$PATH:$HOME/bin:/usr/local/apache/bin。  
source ~/.bash_profile  
让这次的修改生效。  
注：这种方法只对当前用户起作用的,其他用户该修改无效。  

去除自定义路径：  
当你发现新增路径/usr/local/apache/bin没用或不需要时，你可以在以前修改的/etc/profile或~/.bash_profile文件中删除你曾今自定义的路径。  
--------------------------------------------------------------------------------------
通过关键字查询日志  
grep -nH "Excetion message" test.text  
 -n, --line-number 行号  
-H, --with-filename 打印每个匹配的文件名  

查找文件中字符串出现次数  
grep -c 'httpSample' kmtest0924.jtl  
--------------------------------------------------------------------------------------
Linux 删除除了某个文件之外的所有文件  
rm -f !(a|b)

find . -type f ! -name "file10"|xargs rm -f
--------------------------------------------------------------------------------------
linux strace常用来跟踪进程执行时的系统调用和所接收的信
strace -T -tt -f -p 92028 -o 92028.txt
-T 显示每一调用所耗的时间
-tt 在输出中的每一行前加上时间信息,微秒级
-f 跟踪由fork调用所产生的子进程
-p pid 跟踪指定的进程pid
-o filename  将strace的输出写入文件filename
-e expr 指定一个表达式,用来控制如何跟踪

--------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------
awk就是把文件逐行的读入，以空格为默认分隔符将每行切片，切开的部分再进行各种分析处理
last -n 5 | awk  '{print $1}'
$0则表示所有域,$1表示第一个域,$n表示第n个域。默认域分隔符是"空白键" 或 "[tab]键
-F指定域分隔符  -F ':'
awk  -F ':'  '{print $1"\t"$7}'

awk  -F ':'  'BEGIN {print "start"}  {print $1","$7} END {print "end"}'

ARGC               命令行参数个数
ARGV               命令行参数排列
ENVIRON            支持队列中系统环境变量的使用
FILENAME           awk浏览的文件名
FNR                浏览文件的记录数
FS                 设置输入域分隔符，等价于命令行 -F选项
NF                 浏览记录的域的个数
NR                 已读的记录数
OFS                输出域分隔符
ORS                输出记录分隔符
RS                 控制记录分隔符

awk  -F ':'  '{print "filename:" FILENAME ",linenumber:" NR ",columns:" NF ",linecontent:"$0}' /etc/passwd

如果以M为单位显示:
ls -l |awk 'BEGIN {size=0;} {size=size+$5;} END{print "[end]size is ", size/1024/1024,"M"}'

awk '{print $1}' log_file|sort|uniq|wc -l

--------------------------------------------------------------------------------------
linux last 列出目前与过去登录系统的用户相关信息
last -n 5 <==仅取出前五行
--------------------------------------------------------------------------------------
Linux禁用开启ping设置
linux禁用ping的设置方法
echo 1 >/proc/sys/net/ipv4/icmp_echo_ignore_all

linux开启ping的设置方法
echo 0 >/proc/sys/net/ipv4/icmp_echo_ignore_all
--------------------------------------------------------------------------------------
uptime 命令用于查看服务器运行了多长时间以及有多少个用户登录，快速获知服务器的负荷情况
load average: 0.53, 0.31, 0.25
最近1分钟、5分钟、15分钟系统的负载
--------------------------------------------------------------------------------------
iostat命令主要用于查看机器磁盘IO情况
iostat -xz 1
--------------------------------------------------------------------------------------
查看当前语言环境
echo $LANG

修改环境语言，在命令行下直接输入：LANG=en_US
设置完成，只在本窗口有效，其他窗口无效。
--------------------------------------------------------------------------------------
查看物理CPU个数
cat /proc/cpuinfo | grep “physical id” | sort -u | wc -l

查看CPU内核数
cat /proc/cpuinfo | grep “cpu cores” | uniq
--------------------------------------------------------------------------------------
使用 ls 命令，只列出你的 home 文件夹中今天的文件。
ls  -al --time-style=+%D | grep 'date +%D'
--time-style=FORMAT  – 显示指定 FORMAT 的时间
+％D  – 以  ％m/％d/％y  （月/日/年）格式显示或使用日期

只找出 2016-12-06 这一天修改的文件：
find . -maxdepth 1 -newermt "2016-12-06"

-newerXY ，用于所寻找的文件的时间戳  X  比参照文件的时间戳  Y  更新一些的文件
m  – 参照文件的修改时间      –  t  – 直接指定一个绝对时间

ls -l --time-style '+%Y/%m/%d %H:%M:%S'

ls --full-time 显示秒

--extension选项来按照扩展名对输出结果排序，
--size扩展选项按照大小排序，
-t扩展选项按照时间排序，
-v扩展选项对版本排序
# ls --sort=extension
# ls --sort=size
# ls --sort=time
# ls --sort=version
# ls --sort=none
--------------------------------------------------------------------------------------
查找`2013-08-08`到`2013-09-01`号之间的文件
find /log/ -name 'production.log-2013*' -newermt '2013-08-08' ! -newermt '2013-09-0

-newer   f1 !f2               #查更改时间比f1新但比f2旧的文件

find -a 连接两个不同的条件（两个条件必须同时满足）
# -o 连接两个不同的条件（两个条件满足其一即可）
# -not 对条件取反的
--------------------------------------------------------------------------------------
pgrep -f program_name 列出进程名为 program_name 的ID，f参数可以匹配command中的关键字
ps aux | grep -w program_name | grep -v grep | awk '{print $2}'

pkill  -x program_name 结束掉 进程名为 program_name 的进程，x参数启用精确匹配

pgrep -ln httpd 列出最新启动的apache进程ID，-l 参数用来显示进程名称
--------------------------------------------------------------------------------------
!n， 重复执行第 n 条命令，n 为正整数。如果该命令很长，就能节省大量输入命令的时间；
!-n， 重复执行倒数第 n 条命令，n 为正整数；
!!， 重复执行上一条命令。该命令等价于 !-1；
!str，重复执行最近一条以字符串 str 开头的命令；
!?str，重复执行最近一条包含字符串 str 的命令

reset，清空终端屏幕 在你的终端控制错乱时非常有用
--------------------------------------------------------------------------------------
shell脚本对文件进行批量改名
for filename in *eee*; do newname=`echo $filename|sed -n ‘s/eee/EEE/p’`; mv $filename $newname;done
--------------------------------------------------------------------------------------
shell在给变量赋值时不进行文件名替换。所以当你执行x=*时，只是一个星号赋值给了x变量。真正的替换发生在echo $x时
--------------------------------------------------------------------------------------
同时修改文件的修改时间和访问时间
touch -d "2010-05-31 08:10:30" test.doc

只修改文件的修改时间
touch -m -d "2010-05-31 08:10:30" test.doc

只修改文件的访问时间
touch -a -d "2010-05-31 08:10:30" test.doc

-d 使用指定的日期时间
--------------------------------------------------------------------------------------
如何查看Linux的默认网关？
用 route -n 和 netstat -nr 命令

ps aux--sort=-%cpu
--------------------------------------------------------------------------------------
ls -lSrh
“r”的作用是将大的文件列在后面，而“h”则是给出易于人们阅读的输出
-l 列出文件的详细信息
-S 以文件的大小进行排序
-r 依相反次序排列
--------------------------------------------------------------------------------------
在Linux命令行模式下，当遇到一对“`” (上分割符)时，将首先执行“`”中间包含的命令，
然后将其输出结果作为参数代入命令行中，这就是命令替换
touch `date +%Y%m%d%k%M%S`.txt
%k    时(0-23)
--------------------------------------------------------------------------------------
cat a b | sort | uniq > c # c is a union b 并集
cat a b | sort | uniq -d > c # c is a intersect b 交集
cat a b b | sort | uniq -u > c # c is set difference a - b 差集

uniq
– d 只显示重复行
– u 只显示文件中不重复的各行
--------------------------------------------------------------------------------------
# 以字节、KB、MB 或 GB 输出：
free -b
free -k
free -m
free -g
--------------------------------------------------------------------------------------
查看文件最后修改时间
stat 文件名
--------------------------------------------------------------------------------------
列出当前目录里最大的10个文件
du -s * | sort -n | tail
s：只显示各档案大小的总合
-m是以MB为单位展示目录的大小

查询指定端口的监听及运行情况
netstat -tlanop | grep :80

显示ASCII码表
man ascii
--------------------------------------------------------------------------------------
-x参数判断$myPath是否存在且是否可执行.
if [ ! -x "$myPath"]; then
   mkdir "$myPath"
fi

-d判断$myPath是否存在.
-f判断$myFile是否存在.
--------------------------------------------------------------------------------------
只显示文件夹     ls -l | grep ^d
只显示文件       ls -l | grep ^-
文件是以 "-"开头 ， 文件夹是 d

查看统计当前目录下文件的个数，包括子目录里的。
ls -lR| grep "^-" | wc -l[
--------------------------------------------------------------------------------------
将sort文件按照第三列升序输出
sort -t , -k 3 sort.txt

去掉重复行降序输出
sort -ur sort.txt

-b 忽略每一行开头的空格，从第一个不是空格的字符开始比较
-f 忽略大小写，将所有的小写字母转换为大写字母进行比较
-h 以人类可读的方式排序，如对k,G进行排序
-n 将数字转换为数值的方式排序
-r 默认是升序排序，加上-r参数是降序排序
-o 将sort命令的结果输出到另一个文件中。
-u 和-c参数一起时，并没有什么用;不与-c参数一起时，将所有的行去重后排序输出
-t 分隔符
-k 根据key去排序，可以是列的位置或者类型
--------------------------------------------------------------------------------------
查询外网IP的办法
curl ifconfig.me

curl ident.me
curl myip.dnsomatic.com
--------------------------------------------------------------------------------------
CURRENT_USERS=$(who)
echo -e "\n $(who)"
-e 标记表示解释所有的转义序列

FILES=`sudo find . -type f -print | wc -l`
echo "当前目录有 $FILES 个文件。"
--------------------------------------------------------------------------------------
${var##*/}
该命令的作用是去掉变量var从左边算起的最后一个'/'字符及其左边的内容，返回从左边算起的最后一个'/'（不含该字符）的右边的内容
/dir1/dir2/file.txt -->file.txt

${var##*.}
/dir1/dir2/file.txt -->txt

${var#*.}
该命令的作用是去掉变量var从左边算起的第一个'.'字符及其左边的内容，返回从左边算起第一个'.'（不含该字符）的右边部分的内容
a.b.c-->b.c

${var%/*}
去掉变量var从右边算起的第一个'/'字符及其右边的内容
/dir1/dir2/file.txt -->/dir1/dir2

${var%%.*}
该命令的使用是去掉变量var从右边算起的最后一个'.'字符及其右边的内容
/dir1/dir2/file.txt -->/dir1/dir2/file

\#：表示从左边算起第一个
%：表示从右边算起第一个
\##：表示从左边算起最后一个
%%：表示从右边算起最后一个
\* 表示要删除的内容 #和## 删除指定字符及其左边的内容 %和%% 删除指定字符及其右边的内容

basename 该命令的作用是从路径中提取出文件名
echo ${basename $val}
/dir1/dir2/file.txt -->file.txt

echo ${basename $val .txt}
/dir1/dir2/file.txt -->file

dirname 该命令的作用是从路径中提取出目录名
dirname $val
/dir1/dir2/file.txt -->/dir1/dir2
--------------------------------------------------------------------------------------
du -sh /tmp/* | sort -nr | head -3
--------------------------------------------------------------------------------------
shutdown -h now 关机  
shutdown -r now 重启  

env 查看当前用户环境变量

同步服务器时间
sudo ntpdate -u ntp.api.bz

# 后台运行,并且有nohup.out输出
nohup xxx &

# 后台运行, 不输出任何日志
nohup xxx > /dev/null &

# 后台运行, 并将错误信息做标准输出到日志中
nohup xxx >out.log 2>&1 &

查看进程所有打开最大fd数
ulimit -n

sar,查看网络吞吐状态 需要安装
# sar命令在这里可以查看网络设备的吞吐率。在排查性能问题时，可以通过网络设备的吞吐量，判断网络设备是否已经饱和
sar -n DEV 1
网络统计(-n) -n后接关键词”DEV”可显示eth0、eth1等网卡的信息 DEV显示网络接口信息
sar [选项] intervar [count]

# TCP连接数可以用来判断性能问题是否由于建立了过多的连接，进一步可以判断是主动发起的连接，还是被动接受的连接。
TCP重传可能是因为网络环境恶劣，或者服务器压力过大导致丢包
sar -n TCP,ETCP 1

# 显示本地打开的所有端口
ss -l

# 显示每个进程具体打开的socket
ss -pl

# 显示所有tcp socket
ss -t -a

# 显示所有的UDP Socekt
ss -u -a

列出当前socket统计信息
ss -s

# 显示所有已建立的SMTP连接
ss -o state established '( dport = :smtp or sport = :smtp )'

# 显示所有已建立的HTTP连接
ss -o state established '( dport = :http or sport = :http )'

# 要封停一个ip
iptables -I INPUT -s ***.***.***.*** -j DROP

# 要解封一个IP，使用下面这条命令：
iptables -D INPUT -s ***.***.***.*** -j DROP
-I是表示Insert（添加），-D表示Delete（删除）DROP表示放弃连接

#开启9090端口的访问
/sbin/iptables -I INPUT -p tcp --dport 9090 -j ACCEPT

# 反向匹配, 查找不包含xxx的内容
grep -v xxx

# 排除所有空行
grep -v '^$'

tee, 重定向的同时输出到屏幕
awk ‘{print $0}’ xxx.log | tee test.log

# 查看特殊字符
cat -v xxx.sh
-v 或 –show-nonprinting

# 去除特殊字符
sed -i 's/^M//g’ env.sh  去除文件的特殊字符, 比如^M

日志输出的字节数,可以用作性能测试
# 如果做性能测试, 可以每执行一次, 往日志里面输出 “.” , 这样日志中的字节数就是实际的性能测试运行的次数, 还可以看见实时速率.
tail -f xxx.log | pv -bt
pv 显示当前在命令行执行的命令的进度信息
-p 来显示百分比，-t 来显示时间 -r 表示传输速率


wc -L filename 文件里最长的那一行是多少个字  
wc -c filename 查看一个文件的字节数  

查看谁正在使用某个文件
lsof /data

列出某个用户打开的文件信息
lsof  -u username

列出某个程序所打开的文件信息
lsof -c MySQL
备注: -c 选项将会列出所有以mysql开头的程序的文件

查询文件和目录使用者
fuser /root  最基本的用法是查询某个文件或目录被哪个进程使用

列出进程的详细信息 -v
-k参数能够杀死所有的正在访问指定文件的进程
-u参数 列出进程所属的用户
--------------------------------------------------------------------------------------
分页查看前N行日志
tail -n 1000 nohup.out | more

查看实时日志并检索关键字：
tail -f nohup.out | grep "关键字"

查看日志,从第1000行开始,显示500行：
cat nohup.out | tail -n +1000| head -n 500

－n：显示匹配行及 行号

查看日志,显示1000行到1500行：
cat nohup.out | head -n 1500| tail -n +1000
--------------------------------------------------------------------------------------
查看文件头10行
head -n 10 example.txt

查看文件尾10行
tail -n 10 example.txt
--------------------------------------------------------------------------------------
按照文件大小排序
du –sh * |sort –n
--------------------------------------------------------------------------------------
解压不显示过程：v表示显示过程,去掉即不显示
tar zxvf file.tar.gz
--------------------------------------------------------------------------------------
查看内存信息
cat /proc/meminfo
--------------------------------------------------------------------------------------
查找关键词并统计行数
cat 2015_7_25_test_access.log | grep "sqlmap" | wc -l

删除含有匹配字符的行
sed -i '/Indy Library/d' 2015_7_25_test_access.log  -i ：直接修改读取的文件内容

查找所有日志中的关键词
find ./ -name "*.log" |xargs grep "sqlmap" |wc -l

正则匹配内容(如提取ip)
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"  -o :只显示被模式匹配的字符串

-H 指显示线程,-p 是指定进程
top -H -p2023

-l 打印关于锁的附加信息 -m	输出JVM启动时传给主类的方法
jstack -l 2023 > tempfile.txt

-F 强制打印堆栈
jstack -F 2023

#输出完全的包名,应用主类名,jar的完全路径
jps -l
jps -v 查看下java进程的参数
--------------------------------------------------------------------------------------
ls -a 命令会列出文件夹里的所有内容,包括以"."开头的隐藏文件
--------------------------------------------------------------------------------------
查看某一端口的占用情况： lsof -i:端口号
--------------------------------------------------------------------------------------
