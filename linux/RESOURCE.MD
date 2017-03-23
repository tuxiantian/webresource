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