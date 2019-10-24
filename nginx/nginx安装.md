[Linux 下安装Nginx，配置自启动]( https://blog.csdn.net/fukai8350/article/details/80634566 )

要使用https在编译的时候这样指定参数

```shell
./configure --with-http_stub_status_module --with-http_ssl_module --with-openssl=/usr/bin/openssl
```

如果一开始使用的是`./configure`,那么编译安装的nginx是不支持https的，在`nginx.conf`的配置https server时会在检查配置的时候报错。需要再次重新编译安装。`make install`这一步是必须的，网上给的不要`make install`的说法是错误。注意提前备份好`nginx.conf`，因为重新安装后会覆盖掉这个配置文件。

[在Nginx/Tengine服务器上安装证书]( https://help.aliyun.com/document_detail/98728.html?spm=a2c4g.11186623.6.574.4b442242jk0ZC1 )

https服务默认监听的是443端口。在`nginx.conf`中要配置2个server,一个支持http的是80端口，一个支持https的是443端口。

