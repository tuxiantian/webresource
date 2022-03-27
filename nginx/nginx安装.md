[Linux 下安装Nginx，配置自启动]( https://blog.csdn.net/fukai8350/article/details/80634566 )

要使用https在编译的时候这样指定参数

```shell
./configure --with-http_stub_status_module --with-http_ssl_module --with-openssl=/usr/bin/openssl
```

如果一开始使用的是`./configure`,那么编译安装的nginx是不支持https的，在`nginx.conf`的配置https server时会在检查配置的时候报错。需要再次重新编译安装。`make install`这一步是必须的，网上给的不要`make install`的说法是错误。注意提前备份好`nginx.conf`，因为重新安装后会覆盖掉这个配置文件。

[在Nginx/Tengine服务器上安装证书]( https://help.aliyun.com/document_detail/98728.html?spm=a2c4g.11186623.6.574.4b442242jk0ZC1 )

```shell
# 以下属性中以ssl开头的属性代表与证书配置有关，其他属性请根据自己的需要进行配置。
server {
listen 443;
server_name localhost;  # localhost修改为您证书绑定的域名。
    ssl on;   #设置为on启用SSL功能。
    root html;
    index index.html index.htm;
    ssl_certificate cert/www.disontag.com.pem;   #将domain name.pem替换成您证书的文件名。
    ssl_certificate_key cert/www.disontag.com.key;   #将domain name.key替换成您证书的密钥文件名。
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;  #使用此加密套件。
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;   #使用该协议进行配置。
    ssl_prefer_server_ciphers on;   
    location / {
            root html;   #站点目录。
            index index.html index.htm;   
    }
}
```

https服务默认监听的是443端口。在`nginx.conf`中要配置2个server,一个支持http的是80端口，一个支持https的是443端口。

http自动跳转到https

```
 rewrite ^(.*)$ https://$host$1 permanent; 
```

