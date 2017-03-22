nginx负载均衡的5种方式
轮询（默认）：每个请求按时间顺序逐一分配到不同的后端服务器,如果后端服务器down掉,能自动剔除
weight：指定轮询几率,weight和访问比率成正比,用于后端服务器性能不均的情况
ip_hash:每个请求按访问ip的hash结果分配,这样每个访客固定访问一个后端服务器,可以解决session的问题(注意是真实ip,如果前端还有负载,比如squid,用这个地址肯定是错乱的)
fair（第三方）:按后端服务器的响应时间来分配请求,响应时间短的优先分配
url_hash（第三方）
---
nginx添加文件头
add_header backendIP $upstream_addr;
add_header backendCode $upstream_status;
---
Nginx支持以下几种信号控制：

TERM, INT 快速关闭
QUIT 从容关闭
HUP 平滑重启  (修改了配置文件）
USR1 重新打开日志文件,在切割文件时用处大
USR2 平滑升级
WINCH 从容关闭工作进程

ps -ef | grep nginx
#从容停止Nginx
kill -QUIT master进程号
#快速停止Nginx
kill -TERM master进程号
#强制停止Nginx
kill -9 master进程号

判断配置文件是否正确
./nginx -t -c /usr/local/nginx/conf/nginx.conf

cd  /usr/local/nginx/sbin
./nginx -t -t(测试) -c配置文件路径
---