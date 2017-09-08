## 非自增主键的保存更新问题
![](/images/work/question/question1.png)  
表结构信息如下
```sql
CREATE TABLE `t_busline_map_data` (
  `line_id` int(10) unsigned NOT NULL COMMENT '线路id',
  `map_data` varchar(20000) DEFAULT NULL COMMENT '地图数据',
  PRIMARY KEY (`line_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='线路地图数据'
```
重写服务类的保存更新方法，根据主键值查询，非空即更新  
![](/images/work/solution11.png)  
删除insert元素的useGeneratedKeys和keyProperty属性，将主键改为手动插入  
![](/images/work/solution12.png)  

## HttpMessageNotReadableException: Could not read JSON: java.lang.NumberFormatException: empty String;

> 2017-07-19 09:04:48,498 [http-bio-8080-exec-2] WARN  [org.springframework.web.servlet.mvc.support.DefaultHandlerExceptionResolver] - Failed to read HTTP message: org.springframework.http.converter.HttpMessageNotReadableException: Could not read JSON: java.lang.NumberFormatException: empty String; nested exception is com.google.gson.JsonSyntaxException: java.lang.NumberFormatException: empty String

![](/images/work/question/question1.png)

解决方法：前端传值为数值型，若没有值，则传null或不传。

## postman使用

![](/images/work/question/question2.png)  

## Zookeeper连接不上导致web服务无法正常启动
catalina.out日志中出现
```
08-24 17:46:39.055 [localhost-startStop-1-SendThread(192.168.0.254:2181)] org.apache.zookeeper.ClientCnxnSocketNIO org.apache.zookeeper.ClientCnxnSocketNIO.cleanup(ClientCnxnSocketNIO.java:203) DEBUG - Ignoring exception during shutdown input
java.net.SocketException: Socket is not connected
	at sun.nio.ch.Net.translateToSocketException(Net.java:123)
	at sun.nio.ch.Net.translateException(Net.java:157)
	at sun.nio.ch.Net.translateException(Net.java:163)
	at sun.nio.ch.SocketAdaptor.shutdownInput(SocketAdaptor.java:401)
	at org.apache.zookeeper.ClientCnxnSocketNIO.cleanup(ClientCnxnSocketNIO.java:200)
	at org.apache.zookeeper.ClientCnxn$SendThread.cleanup(ClientCnxn.java:1185)
	at org.apache.zookeeper.ClientCnxn$SendThread.run(ClientCnxn.java:1110)
Caused by: java.nio.channels.NotYetConnectedException
	at sun.nio.ch.SocketChannelImpl.shutdownInput(SocketChannelImpl.java:782)
	at sun.nio.ch.SocketAdaptor.shutdownInput(SocketAdaptor.java:399)
	... 3 more
```
wget http://localhost:8083/mongodb/index.html
服务器无响应输出
本地启动正常，项目发到服务器上面就出现了上面陈述的问题。
最后检查发现是spring-dubbo.xml文件中的zookeeper连接地址配置错误。地址改正后，服务正常启动了，上面两个问题就都不存在了。这真是一个诡异的问题。
## MySQL两个无符号的数字想减出现问题
次卡的打包次数-剩余次数=次卡使用次数。但是次卡参加活动后，剩余次数大于打包次数，想减之后会报错。
```sql
 SELECT a.`NICKNAME` nickName,a.`MOBILE` mobile,c.`card_name` cardName,ar.`AREANAME` areaName,pc.`pay_time` payTime,
ac.`card_end_date` cardEndDate,ac.card_num cardNum,ac.`surplus_times` surplusTimes,(ac.`card_num`-ac.`surplus_times`) usedTimes
	from `t_account_paycard` pc
	inner join `t_card` c on pc.`card_id`=c.`card_id`
	inner join t_account a on a.`USERID`=pc.`userid`
	inner join `t_account_card` ac on ac.`card_id`=pc.`card_id` and pc.`userid`=ac.`userid`
	left join t_area ar on ar.`AREACODE`=c.`areacode`
	where 1=1
```
![](/images/work/question/question3.png)  
表结构如下：
![](/images/work/question/question4.png)  
