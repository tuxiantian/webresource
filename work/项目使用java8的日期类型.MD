1. [Jackson与SpringMVC整合的MessageConverter配置](/java/spring/RESOURCE.MD#Jackson与SpringMVC整合的MessageConverter配置)
2. [mybatis中使用Java8的日期LocalDate、LocalDateTime](/java/mybatics/RESOURCE.MD#mybatis中使用Java8的日期LocalDate、LocalDateTime)
3. 重写com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer支持日期字符串"2017-08-14 10:02:01"转为LocalDateTime类型  
默认的java8的LocalDateTime类型的日期字符串是"2017-08-14T10:02:01"，springmvc在接收这种字符串转换为LocalDateTime类型的时候会出问题  
重写的代码片段如下  
```java
static {
        DEFAULT_FORMATTER = DateTimeFormatter.ofPattern(DateUtil.DATE_PATTERN.YYYY_MM_DD_HH_MM_SS);
        INSTANCE = new LocalDateTimeDeserializer();
    }
```