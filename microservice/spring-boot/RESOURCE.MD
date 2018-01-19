[Spring Boot 揭秘与实战 系列](http://blog.720ui.com/columns/springboot_all/)

[springmvc常用注解标签详解(转载)](http://www.cnblogs.com/zheting/p/6582931.html)
[Spring Boot干货系列：（一）优雅的入门篇](http://www.cnblogs.com/zheting/p/6707032.html)
[Spring Boot干货系列：（二）配置文件解析](http://www.cnblogs.com/zheting/p/6707036.html)
[Spring Boot干货系列：（三）启动原理解析](http://www.cnblogs.com/zheting/p/6707035.html)
[Spring Boot干货系列：（七）默认日志框架配置](http://www.cnblogs.com/zheting/p/6707041.html)
示例
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration scan="true" scanPeriod="60 seconds" debug="false">
    <contextName>logback</contextName>
    <property name="logback.appname" value="main"/>
    <!--输出到控制台 ConsoleAppender-->
    <appender name="consoleLog1" class="ch.qos.logback.core.ConsoleAppender">
        <!--展示格式 layout-->
        <layout class="ch.qos.logback.classic.PatternLayout">
            <pattern>
                <pattern>%d{HH:mm:ss.SSS} %contextName [%thread] %-5level %logger{36} - %msg%n</pattern>
            </pattern>
        </layout>
        <!--
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
             <level>ERROR</level>
        </filter>
         -->
    </appender>
    <appender name="fileInfoLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!--如果只是想要 Error 级别的日志，那么需要过滤一下，默认是 info 级别的，ThresholdFilter-->
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>Info</level>
        </filter>
        <!--日志名称，如果没有File 属性，那么只会使用FileNamePattern的文件路径规则
            如果同时有<File>和<FileNamePattern>，那么当天日志是<File>，明天会自动把今天
            的日志改名为今天的日期。即，<File> 的日志都是当天的。
        -->
        <File>${logback.appname}.log</File>
        <!--滚动策略，按照时间滚动 TimeBasedRollingPolicy-->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!--文件路径,定义了日志的切分方式——把每一天的日志归档到一个文件中,以防止日志填满整个磁盘空间-->
            <FileNamePattern>${logback.appname}.%d{yyyy-MM-dd}.log</FileNamePattern>
            <!--只保留最近90天的日志-->
            <maxHistory>90</maxHistory>
            <!--用来指定日志文件的上限大小，那么到了这个值，就会删除旧的日志-->
            <!--<totalSizeCap>1GB</totalSizeCap>-->
        </rollingPolicy>
        <!--日志输出编码格式化-->
        <encoder>
            <charset>UTF-8</charset>
            <pattern>%d [%thread] %-5level %logger{36} %line - %msg%n</pattern>
        </encoder>
    </appender>
    <logger name="java.sql">
        <level value="info"></level>
    </logger>
    <logger name="java.sql.PreparedStatement">
        <level value="info"></level>
    </logger>
    <logger name="java.sql.Statement">
        <level value="info"></level>
    </logger>
    <logger name="java.sql.Connection">
        <level value="info"></level>
    </logger>
    <logger name="com.ibatis">
        <level value="info"></level>
    </logger>
    <logger name="com.laijia.biz.order.mapper.OrdersMapper.findBookTimeOut">
        <level value="info"></level>
    </logger>
    <logger name="com.laijia">
        <level value="debug"></level>
    </logger>
    <logger name="org.apache.activemq.transport.failover.FailoverTransport">
        <level value="error"></level>
    </logger>
    <!--指定最基础的日志输出级别-->
    <root level="INFO">
        <!--appender将会添加到这个loger-->
        <appender-ref ref="consoleLog1"/>
        <appender-ref ref="fileInfoLog"/>
    </root>
</configuration>
```
## spring-boot项目热部署
```
<dependency>  
    <groupId>org.springframework.boot</groupId>  
    <artifactId>spring-boot-devtools</artifactId>  
    <optional>true</optional>  
</dependency>  
```
在idea编译后，会自动重启启