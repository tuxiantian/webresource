[log4j.properties to logback.xml Translator](https://logback.qos.ch/translator/)
```
java.lang.NoClassDefFoundError: org/codehaus/janino/ScriptEvaluator。
```
需要引入下面的jar
```xml
<dependency>
    <groupId>org.codehaus.janino</groupId>
    <artifactId>janino</artifactId>
    <version>3.0.7</version>
</dependency>
```
logback的filter使用示例
示例1
```xml
<filter class="ch.qos.logback.core.filter.EvaluatorFilter">
    <evaluator> <!-- 默认为 ch.qos.logback.classic.boolex.JaninoEventEvaluator -->
        <expression>return message.contains("RocketmqClient");</expression>
    </evaluator>
    <OnMatch>DENY</OnMatch>
    <OnMismatch>ACCEPT</OnMismatch>
</filter>
```
示例2
```xml
<filter class="ch.qos.logback.core.filter.EvaluatorFilter">   
    <evaluator>           
    <matcher>   
        <Name>odd</Name>   
        <!-- filter out odd numbered statements -->   
        <regex>statement [13579]</regex>   
    </matcher>   
        
    <expression>odd.matches(formattedMessage)</expression>   
    </evaluator>   
    <OnMismatch>NEUTRAL</OnMismatch>   
    <OnMatch>DENY</OnMatch>   
</filter>   
```
Logback支持格式化日志
```java
logger.error("one two three: {} {} {}", "a", "b", "c", new Exception("something went wrong"));
```