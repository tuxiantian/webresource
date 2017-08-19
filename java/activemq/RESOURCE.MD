### 本机ActiveMQ信息
http://localhost:8161/admin/  
D:\activemq\apache-activemq-5.12.1\conf\users.properties文件中配置用户名和密码。  
默认用户名和密码：admin=admin  
###  ActiveMQ简述  
> http://blog.csdn.net/u013256816/article/details/51161548  
#### 消息队列之异步消息的基本概念以及ActiveMQ整合Spring的常用用法介绍 | 掘金技术征文
> https://juejin.im/post/585652828e450a006c9e99ea
#### activemq从入门到精通
http://www.jianshu.com/p/ecdc6eab554c  
activemq基础  

http://www.jianshu.com/p/f7a7105b3c27  
消息的顺序消费、JMS Selectors、消息的同步 AND 异步 接受、P2P or Pub/Sub、持久化订阅、与Spring整合  

http://www.jianshu.com/p/79f8a0457069  
利用Zookeeper实现ActiveMQ的高可用  

Prefetch Limit  
http://www.cnblogs.com/kaka/archive/2012/07/28/2612870.html
> 如果客户端处理很慢的话，Broker会在之前发送消息的反馈之前，继续发送新的消息到客户端。如果客户端依旧很慢的话，没有得到确认反馈的消息会持续增长。在这种情况下，Broker有可能会停止发送消息给消费者。当未被反馈的消息达到了prefetch limit设置的数字时，Broker将会停止给消费者发送新的消息。除非消费者开始给予反馈，否则得不到任何消息。
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
插入防火墙规则  
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 8161 -j ACCEPT  
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 61616 -j ACCEPT  
保存防火墙规则  
/etc/rc.d/init.d/iptables save  
查看保存的防火墙规则  
vi /etc/sysconfig/iptables  
重启防火墙  
service iptables restart  
在启动前先配置activemq。在bin目录下执行  
./activemq  setup  /root/.activemqrc  
提高activemq的权限  
chmod 600 /root/.activemqrc  
启动activeMQ  
./bin/activemq start  
验证是否安装成功
```
[root@localhost activemq]# ./bin/activemq status
INFO: Loading '/opt/activemq//bin/env'
INFO: Using java '/opt/jdk1.7.0_79/bin/java'
ActiveMQ is running (pid '3535')
```
关闭/重启activeMQ
```
[root@localhost activemq]# ./bin/activemq stop
[root@localhost activemq]# ./bin/activemq restart
```