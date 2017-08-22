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
Jul 17, 2017 11:12:47 AM org.apache.catalina.core.ContainerBase addChildInternal
SEVERE: ContainerBase.addChild: start:
org.apache.catalina.LifecycleException: Failed to start component [StandardEngine[Catalina].StandardHost[localhost].StandardContext[/mongodb]]
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:154)
        at org.apache.catalina.core.ContainerBase.addChildInternal(ContainerBase.java:901)
        at org.apache.catalina.core.ContainerBase.addChild(ContainerBase.java:877)
        at org.apache.catalina.core.StandardHost.addChild(StandardHost.java:649)
        at org.apache.catalina.startup.HostConfig.deployWAR(HostConfig.java:1081)
        at org.apache.catalina.startup.HostConfig$DeployWar.run(HostConfig.java:1877)
        at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
        at java.util.concurrent.FutureTask.run(FutureTask.java:266)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
        at java.lang.Thread.run(Thread.java:745)
Caused by: org.apache.catalina.LifecycleException: Error in resourceStart()
        at org.apache.catalina.core.StandardContext.startInternal(StandardContext.java:5327)
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:150)
        ... 10 more

```
wget http://localhost:8083/mongodb/index.html
服务器无响应输出
本地启动正常，项目发到服务器上面就出现了上面陈述的问题。
最后检查发现是spring-dubbo.xml文件中的zookeeper连接地址配置错误。地址改正后，服务正常启动了，上面两个问题就都不存在了。这真是一个诡异的问题。
