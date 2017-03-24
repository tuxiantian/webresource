截取日志
sed -n '/2014-06-04 14:00:/,/2014-06-04 15:00:/p' catalina.out > ~/catalina.out.20140604-14

--------------------------------------------------------------------------------------
查看磁盘： df -lh

查看目录占用大小：du -lh
--------------------------------------------------------------------------------------
tar压缩：tar -zcvf file.tar.zip file

解压tar：tar -zxvf file.tar.zip

解压zip：unzip xxx.zip

解压war：jar -xvf xxx.war
--------------------------------------------------------------------------------------
linux快速清空文件内容
> filename
--------------------------------------------------------------------------------------
mkdir -p language/android 连续创建目录以及子目录
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
set  nu ：设置显示文本的行数
set  nonu：取消显示文本的行数
--------------------------------------------------------------------------------------
查找大文件
find . -type f -size +200M -print0 | xargs -0 du -h | sort -nr

linux 文件的三种时间
atime 最后一次访问时间, 如 less, more 等, 但 chmod, chown, ls, stat 等不会修改些时间
ctime 最后一次状态修改时间, 如 chmod, chown 等状态时间改变但修改时间不会改变, 使用 stat file 可以查看
mtime 最后一次内容修改时间, 如 vi 保存后等, 修改时间发生改变的话, atime 和 ctime 也相应跟着发生改变

find /var/log/ -mtime +3 -type f -print  3天前
find /var/log/ -mtime -3 -type f -print  3天内
find /var/log/ -mtime 3 -type f -print   第3天
find /var/log/ -mtime +2 -mtime -4 -type f -print
--------------------------------------------------------------------------------------
linux复制文件到多个目录
 echo /home/aaronkilik/test/ /home/aaronkilik/tmp | xargs -n 1 cp -v /home/aaronkilik/bin/sys_info.sh
-n 1 - 告诉 xargs 命令每个命令行最多使用一个参数，并发送到 cp 命令中。
cp – 用于复制文件。
-v – 启用详细模式来显示更多复制细节
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
sed -n '1p' ab   #显示第一行
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
location ^~ /static/
{
# http://backup/。。。 不带location中的东西
# 只要proxy_pass后面有东西就不带location中的东西
proxy_pass http://www.test.com/;
}
# location中的匹配路径为/static/。加了/之后proxy_pass 不会加上/static/
# curl http://localhost:3000/static/index.html
# proxy_pass 转发为 http://www.test.com/index.html

如果没有/，则会把匹配的路径部分也给代理走。
location ^~ /static/
{
# 带上location中的东西
proxy_pass http://www.test.com;
}
# location中的匹配路径为/static/。不加 / 后proxy_pass会加上 /static/
# curl http://localhost:3000/static/index.html
# proxy_pass 转发为 http://www.test.com/static/index.html

location 中 ~ （区分大小写）与 ~* （不区分大小写）标识均为正则匹配
location ~* /static/(.*)
{
# 此处 location 为正则匹配，proxy_pass 后面不能有 /test

proxy_pass http://www.test.com;
}

server {
    listen 127.0.0.1:8080;  # IPv4地址，8080端口
    # listen [2001:3CA1:10F:1A:121B:0:0:10]:80;   # IPv6地址，80端口
    # listen [::]:80;  # 听本机的所有IPv4与IPv6地址，80端口
    # The rest of server configuration
}

location /wrong/url {
    return 404;
}

location /permanently/moved/url {
    return 301 http://www.example.com/moved/here;
}
--------------------------------------------------------------------------------------
uptime 命令用于查看服务器运行了多长时间以及有多少个用户登录，快速获知服务器的负荷情况
load average: 0.53, 0.31, 0.25
最近1分钟、5分钟、15分钟系统的负载
--------------------------------------------------------------------------------------
iostat命令主要用于查看机器磁盘IO情况
iostat -xz 1
--------------------------------------------------------------------------------------
nginx修改配置后重载
nginx -s reload
--------------------------------------------------------------------------------------
shell
arr=(a b c)
arr=(${arr[@]/b/c}) # a c c
echo ${arr[@]/c/d} # a d d

--------------------------------------------------------------------------------------
指定 Redis 数据库访问密码
redis-cli -a password keys "*" | xargs redis-cli -a password del


访问 Redis 中特定的数据库
//下面的命令指定数据序号为0，即默认数据库
redis-cli -n 0 keys "*" | xargs redis-cli -n 0 del
--------------------------------------------------------------------------------------
查看当前语言环境
echo $LANG

修改环境语言，在命令行下直接输入：LANG=en_US
设置完成，只在本窗口有效，其他窗口无效。
--------------------------------------------------------------------------------------
find . \( -name "*.txt" -o -name "*.pdf" \) -print
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
uname -a               # 查看内核/操作系统/CPU信息
--------------------------------------------------------------------------------------
linux下使用快速删除海量小文件的方法
1、建立一个空的文件夹：
mkdir ~/test
2、用rsync删除目标目录：
rsync --delete-before -a -H -v --progress --stats ~/test/ ~/logs/
这样我们要删除的logs目录就会被清空了，删除的速度会非常快

选项说明：
–delete-before 接收者在传输之前进行删除操作
–progress 在传输时显示传输过程
-a 归档模式，表示以递归方式传输文件，并保持所有文件属性
-H 保持硬连接的文件
-v 详细输出模式
–stats 给出某些文件的传输状态

rsync --help | grep delete
--delete-before    接收者在传输之前进行删除操作  可以用来清空目录或文件

rsync -av --exclude  test1/ --exlclude test2/  ../test/  /home/copydir
--------------------------------------------------------------------------------------
shell脚本对文件进行批量改名
for filename in *eee*; do newname=`echo $filename|sed -n ‘s/eee/EEE/p’`; mv $filename $newname;done
--------------------------------------------------------------------------------------
shell在给变量赋值时不进行文件名替换。所以当你执行x=*时，只是一个星号赋值给了x变量。真正的替换发生在echo $x时
--------------------------------------------------------------------------------------
查找目录下的所有文件中是否含有某个字符串
find .|xargs grep -ri "IBM"
查找目录下的所有文件中是否含有某个字符串,并且只打印出文件名
find .|xargs grep -ri "IBM" -l
--------------------------------------------------------------------------------------
同时修改文件的修改时间和访问时间
touch -d "2010-05-31 08:10:30" test.doc

只修改文件的修改时间
touch -m -d "2010-05-31 08:10:30" test.doc

只修改文件的访问时间
touch -a -d "2010-05-31 08:10:30" test.doc

-d 使用指定的日期时间
--------------------------------------------------------------------------------------
根据端口号，查找对应的进程
netstat -alp | grep  2181
ps -aux | grep 3567
--------------------------------------------------------------------------------------
如何查看Linux的默认网关？
用 route -n 和 netstat -nr 命令

--------------------------------------------------------------------------------------
sed –n '5,10p' /etc/passwd 这样你就可以只查看文件的第 5 行到第 10 行

--------------------------------------------------------------------------------------
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
for i in *.mp3; do

cp -- "$file" "$target"

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
查看最大连接数上限
show variables like 'max_connections';

查看mysql最大使用连接数
show global status like 'Max_used_connections';

max_connections=1500
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
批量删除空文件
find . -name "*" -type f -size 0c | xargs -n 1 rm -f

查询出所有的空文件夹
find -type d -empty
--------------------------------------------------------------------------------------
find . -type f -name "* *" -print |
while read name; do
na=$(echo $name | tr ' ' '_')

if [[ $name != $na ]]; then
mv "$name" $na
fi
done
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
curl -d 'req_json={"beans":[],"busiId":"queryVertifyLogs","params":{}}'  http://10.96.18.213:30001/ol_java/RealnameServlet
注意后面的地址中若是有！，则需要使用\进行转义
--------------------------------------------------------------------------------------
curl多次尝试连接
curl --retry 10 --retry-delay 60 --retry-max-time 60 http://www.baidu.com/ -o baidu_html
注： --retry表示重试次数； --retry-delay表示两次重试之间的时间间隔（秒为单位）；
 --retry-max-time表示在此最大时间内只容许重试一次（一般与--retry-delay相同）

-d/--data <data>   HTTP POST方式传送数据

设置http响应头处理
curl -H "Connection:keep-alive \n User-Agent: Mozilla/5.0" http://www.aiezu.com

分块下载文件 -o保存
curl -r 0-1024000 -o new_divide_1.mp3 http://vfile/55750a8be70.mp3

查看头信息
curl -I http://www.taobao.com/
--------------------------------------------------------------------------------------