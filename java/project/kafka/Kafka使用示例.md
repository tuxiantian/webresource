引入kafka

```xml
<!-- kafka -->
<dependency>
    <groupId>org.springframework.kafka</groupId>
    <artifactId>spring-kafka</artifactId>
</dependency>
```

配置

```yml
spring:
  kafka:
    # 主机ip
    bootstrap-servers: 192.168.130.133:9092,192.168.130.133:9093,192.168.130.133:9094,192.168.130.133:9095,192.168.130.133:9096
    consumer:
      #用来唯一标识consumer进程所在组的字符串，如果设置同样的group  id，表示这些processes都是属于同一个consumer  group
      group-id: sms-service
      #如果为真，consumer所fetch的消息的offset将会自动的同步到zookeeper。这项提交的offset将在进程挂掉时，由新的consumer使用
      enable-auto-commit: true
      #consumer向zookeeper提交offset的频率，单位是m
      auto-commit-interval: 1000
      #密钥的反序列化器类，实现类实现了接口org.apache.kafka.common.serialization.Deserializer
      key-deserializer: org.apache.kafka.common.serialization.StringDeserializer
      #值的反序列化器类，实现类实现了接口org.apache.kafka.common.serialization.Deserializer
      value-deserializer: org.apache.kafka.common.serialization.StringDeserializer
      #当Kafka中没有初始偏移量或者服务器上不再存在当前偏移量时该怎么办，默认值为latest，表示自动将偏移重置为最新的偏移量  可选的值为latest, earliest, none
      auto-offset-reset: latest
      #一次调用poll()操作时返回的最大记录数，默认值为500
      max-poll-records: 500
    producer:
      key-serializer: org.apache.kafka.common.serialization.StringSerializer
      value-serializer: org.apache.kafka.common.serialization.StringSerializer
      linger: 0
      retries: 30
      batch-size: 4096
      buffer-memory: 400000000
```

生产者

```java
@Autowired
private KafkaTemplate kafkaTemplate;

kafkaTemplate.send("aliyunsms_verification_code",JSONObject.toJSONString(data));
```

消费者

```java
@KafkaListener(topics = {"aliyunsms_verification_code"}, groupId = "sms-service")
public void sendAliyunSms(String message) {}
```

