### 本机ActiveMQ信息
http://localhost:8161/admin/  
D:\activemq\apache-activemq-5.12.1\conf\users.properties文件中配置用户名和密码。  
默认用户名和密码：admin=admin  
###  ActiveMQ简述  
> http://blog.csdn.net/u013256816/article/details/51161548  
#### 消息队列之异步消息的基本概念以及ActiveMQ整合Spring的常用用法介绍 | 掘金技术征文
> https://juejin.im/post/585652828e450a006c9e99ea
### linux下安装activemq
tar -zxvf apache-activemq-5.14.4-bin.tar.gz -C /usr/local/  
将压缩包解压到另外一个目录别忘了加参数-C  
ln -s apache-activemq-5.14.4/ activemq  
ln -s /usr/local/apache-activemq-5.14.4/bin/activemq /etc/init.d/  
启动activemq  
/etc/init.d/activemq start  
添加activemq自启动  
chkconfig activemq on  
也可通过下面的方式启动activemq  
service activemq start  