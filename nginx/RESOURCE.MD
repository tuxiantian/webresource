nginx+tomcat 配置负载均衡集群  
https://juejin.im/entry/58df246d61ff4b006162bd4a
--------------------------------------------------------------------------------------
nginx负载均衡的5种方式
轮询（默认）：每个请求按时间顺序逐一分配到不同的后端服务器,如果后端服务器down掉,能自动剔除
weight：指定轮询几率,weight和访问比率成正比,用于后端服务器性能不均的情况
ip_hash:每个请求按访问ip的hash结果分配,这样每个访客固定访问一个后端服务器,可以解决session的问题(注意是真实ip,如果前端还有负载,比如squid,用这个地址肯定是错乱的)
fair（第三方）:按后端服务器的响应时间来分配请求,响应时间短的优先分配
url_hash（第三方）
--------------------------------------------------------------------------------------
nginx添加文件头
add_header backendIP $upstream_addr;
add_header backendCode $upstream_status;
--------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------
nginx修改配置后重载
nginx -s reload
--------------------------------------------------------------------------------------
nginx
将所有HTTP请求重写为HTTPS
server {
​    return 301 https://$host$request_uri;
}

重写HTTP 某些URL 为 HTTPS URL
location = /res/static/index.html {
​    #方式一
​    #return 301 https://$http_host$request_uri$is_args$query_string;

    #方式二
    return 301 https://$host$request_uri;
    
    #方式三
    #rewrite ^/(.+) https://$host/$1 permanent;
}
--------------------------------------------------------------------------------------
nginx
proxy_set_header X-Forwarded-Proto $scheme;

在反向代理那里设置一个头X-Forwarded-Proto，值设置成https。
在tomcat的server.xml里添加这段配置：
```
<Valve className="org.apache.catalina.valves.RemoteIpValve" protocolHeader="X-Forwarded-Proto" />
```
如此一来sendRedirect的时候就能够正确的使用协议了
--------------------------------------------------------------------------------------
nginx
设置临时目录
proxy_temp_path /tmp/temp_dir;

设置http状态码为200,302缓存时间，24h为24小时
proxy_cache_valid 200 302 24h;
设置失期时间，90d为90天
expires 90d;
不进行缓存直接转到后端服务器
proxy_pass http://127.0.0.1:9000;

proxy_cache_bypass $cookie_nocache $arg_nocache; 哪种类型的请求需要向服务器请求而不是尝试首先在缓存中查找
http://www.example.com/?nocache=true

proxy_cache_path用来设置缓存的路径和配置，proxy_cache用来启用缓存
proxy_cache_path /path/to/cache levels=1:2 keys_zone=my_cache:10m max_size=10g inactive=60m
​                 use_temp_path=off;

location / {
​      proxy_cache my_cache;
​      proxy_pass http://my_upstream;
}

levels在/path/to/cache/设置了一个两级层次结构的目录
keys_zone设置一个共享内存区，该内存区用于存储缓存键和元数据 10MB内存空间
max_size设置了缓存的上限
inactive指定了项目在不被访问的情况下能够在内存中保持的时间
use_temp_path=off命令指示NGINX将在缓存这些文件时将它们写入同一个目录下 避免在文件系统中不必要的数据拷贝

proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
当NGINX收到服务器返回的error，timeout或者其他指定的5xx错误，并且在其缓存中有请求文件的陈旧版本，
则会将这些陈旧版本的文件而不是错误信息发送给客户端
```
location /images/ {
    proxy_cache my_cache;
    proxy_ignore_headers Cache-Control;
    proxy_cache_valid any 30m;
    ...
}
```
会忽略所有/images/下的Cache-Control头
proxy_cache_valid命令强制规定缓存数据的过期时间

缓存POST请求
proxy_cache_methods GET HEAD POST;

#所有静态文件由nginx直接读取不经过tomcat或resin
location ~ .*.(htm|html|gif|jpg|jpeg|png|bmp|swf|ioc|rar|zip|txt|flv|mid|doc|ppt|pdf|xls|mp3|wma)$
{ expires 15d; }
location ~ .*.(js|css)?$
{ expires 1h; }
}
}
#所有jsp的页面均交由tomcat或resin处理
location ~ .(jsp|jspx|do)?$ {
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
#后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_pass http://127.0.0.1:8080;
}
--------------------------------------------------------------------------------------
