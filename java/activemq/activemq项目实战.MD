## 项目需求
共享汽车的TBox数据保存利用，定时任务每分钟调用易微行的接口获取车辆的状态和位置信息
考虑通过使用消息队列解决并发的问题，用mongodb来存储数据，每辆车创建两个集合，一个集合存车辆的状态信息，一个集合存车辆的位置信息。时间采用long值存储。在时间字段上面建立索引，
在做车辆的轨迹时，会从车辆的位置信息集合中查询一段时间的车辆位置信息。

车辆的状态信息
```JSON
{
	"_id" : ObjectId("59e46e3a316bf20fcaae91d2"),
	"id" : null,
	"sn" : "217361300000184",
	"idc" : null,
	"receivedTime" : NumberLong("1508142589000"),
	"electricity" : "11",
	"mileage" : "15",
	"engineStatus" : 0,
	"leftFrontDoor" : 0,
	"rightFrontDoor" : 0,
	"leftRearDoor" : 0,
	"rightRearDoor" : 0,
	"centralLckingStatus" : 1,
	"lightsStatus" : 0,
	"chargeStatus" : 0,
	"totalMileage" : NumberLong(69)
}

```
车辆的位置信息
```json
{
	"_id" : ObjectId("59e2c478316bf20fcaad1fe9"),
	"id" : null,
	"sn" : "217361300000321",
	"idc" : null,
	"gpsTime" : NumberLong("1506997199000"),
	"longitude" : 118.57402722249111,
	"latitude" : 36.46065030448801,
	"speed" : 0,
	"direction" : 0,
	"altitude" : 0
}

```
## 消息队列的消息消费端
使用spring的Jms，项目启动后会自动连接activemq服务器创建队列，根据业务需要创建2个队列，一个用于发送和接受车辆的状态信息，一个用于发送和接受车辆的位置信息。队列的名字是carInfoQueueDestination，gpsInfoQueueDestination。
### activeMq连接的配置  
```
brokerURL=failover:(tcp://127.0.0.1:61616)?jms.prefetchPolicy.all=50
#queue username
mq.username=admin
#queue password
mq.password=admin
```
### spring jms
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
	   xmlns:jms="http://www.springframework.org/schema/jms"
	   xmlns:mvc="http://www.springframework.org/schema/mvc"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/jms http://www.springframework.org/schema/jms/spring-jms.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd
		http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-4.0.xsd">
		
		
		<!-- 配置ConnectionFactory -->
	<bean id="connectionFactory" class="org.apache.activemq.ActiveMQConnectionFactory">
		<property name="brokerURL" value="${brokerURL}" />
		<property name="userName" value="${mq.username}" />
		<property name="password" value="${mq.password}" />
		<property name="prefetchPolicy">
			<bean class="org.apache.activemq.ActiveMQPrefetchPolicy">
				<property name="queuePrefetch" value="10" />
			</bean>
		</property>
	</bean>

	<bean id="carInfoQueueDestination" class="org.apache.activemq.command.ActiveMQQueue">
		<!-- 设置消息队列的名字 -->
		<constructor-arg>
			<value>carInfo</value>
		</constructor-arg>
	</bean>

	<bean id="gpsInfoQueueDestination" class="org.apache.activemq.command.ActiveMQQueue">
		<!-- 设置消息队列的名字 -->
		<constructor-arg>
			<value>gpsInfo</value>
		</constructor-arg>
	</bean>

	<!-- 定义Queue监听器 -->
	<jms:listener-container destination-type="queue" container-type="default" connection-factory="connectionFactory" acknowledge="auto" receive-timeout="10000">
		<jms:listener destination="carInfoQueueDestination" ref="carInfoMessageListener" concurrency="20"/>
		<jms:listener destination="gpsInfoQueueDestination" ref="gpsInfoMessageListener" concurrency="20"/>
	</jms:listener-container>

	<bean id="carInfoMessageListener" class="com.laijia.mq.listener.CarInfoMessageListener"></bean>
	<bean id="gpsInfoMessageListener" class="com.laijia.mq.listener.GpsInfoMessageListener"></bean>
</beans>
```

消息监听器的实现
```java
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

public class CarInfoMessageListener implements MessageListener {
    private final Logger logger = LoggerFactory.getLogger(CarInfoMessageListener.class);
    @Autowired
    private ICarRecordService service;
    @Override
    public void onMessage(Message message) {
        logger.info("method  onMessage", "receive CarInfo message  start");
        //BytesMessage 是最快的，ObjectMessage （序列化对象） 是最慢的。
        if (message instanceof TextMessage) {
            TextMessage textMessage = (TextMessage) message;
            try {
                logger.debug("CarInfo message {}", textMessage.getText());
                service.saveCarInfo(JsonUtil.toObject(textMessage.getText(), ZxtCarStatusResult.Car.class));
                logger.info("method  onMessage", "receive CarInfo message  end");
            } catch (Exception e) {
                logger.error("JmsMessageListener.onMessage", "CarInfo message:" + textMessage.toString(), e);
            }
        }
    }
}
```

依赖的activemq包
```xml
<!-- activemq -->
<dependency>
    <groupId>org.apache.activemq</groupId>
    <artifactId>activemq-client</artifactId>
    <version>5.9.0</version>
</dependency>
<dependency>
    <groupId>org.apache.activemq</groupId>
    <artifactId>activemq-pool</artifactId>
    <version>5.9.0</version>
</dependency>
```

## activemq消息发送端

spring的JmsTemplate发送信息
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- ActiveMQ 连接工厂 -->
    <bean id="amqConnectionFactory" class="org.apache.activemq.ActiveMQConnectionFactory">
        <property name="brokerURL" value="${brokerURL}"/>
        <property name="userName" value="${mq.username}"/>
        <property name="password" value="${mq.password}"/>
    </bean>
    <!-- Spring用于管理真正的ConnectionFactory的ConnectionFactory -->
    <bean id="connectionFactory" class="org.springframework.jms.connection.CachingConnectionFactory">
        <property name="targetConnectionFactory" ref="amqConnectionFactory"/>
        <property name="sessionCacheSize" value="100"/>
    </bean>
    <!-- 定义JmsTemplate的Queue类型 -->
    <bean id="carInfoQueueTemplate" class="org.springframework.jms.core.JmsTemplate">
        <!-- 这个connectionFactory对应的是我们定义的Spring提供的那个ConnectionFactory对象 -->
        <constructor-arg ref="connectionFactory"/>
        <!-- 定义默认的队列名称-->
        <property name="defaultDestinationName" value="carInfoQueueDestination"/>
        <!-- 非pub/sub模型（发布/订阅），即队列模式 -->
        <property name="pubSubDomain" value="false"/>
    </bean>

    <!-- 定义JmsTemplate的Queue类型 -->
    <bean id="gpsInfoQueueTemplate" class="org.springframework.jms.core.JmsTemplate">
        <!-- 这个connectionFactory对应的是我们定义的Spring提供的那个ConnectionFactory对象 -->
        <constructor-arg ref="connectionFactory"/>
        <!-- 定义默认的队列名称-->
        <property name="defaultDestinationName" value="gpsInfoQueueDestination"/>
        <!-- 非pub/sub模型（发布/订阅），即队列模式 -->
        <property name="pubSubDomain" value="false"/>
    </bean>
</beans>

```
发送消息
```java
@Autowired
private JmsTemplate carInfoQueueTemplate;

carInfoQueueTemplate.send(session -> session.createTextMessage(JsonUtil.toJson(event.getCar())));
```

## 延迟消息
延迟队列能做什么？

延迟队列多用于需要延迟工作的场景。最常见的是以下两种场景：

1. 延迟消费。比如：
用户生成订单之后，需要过一段时间校验订单的支付状态，如果订单仍未支付则需要及时地关闭订单。
用户注册成功之后，需要过一段时间比如一周后校验用户的使用情况，如果发现用户活跃度较低，则发送邮件或者短信来提醒用户使用。
2. 延迟重试。比如消费者从队列里消费消息时失败了，但是想要延迟一段时间后自动重试。

如果不使用延迟队列，那么我们只能通过一个轮询扫描程序去完成。这种方案既不优雅，也不方便做成统一的服务便于开发人员使用。但是使用延迟队列的话，我们就可以轻而易举地完成。

[官方使用介绍](http://activemq.apache.org/delay-and-schedule-message-delivery.html)
