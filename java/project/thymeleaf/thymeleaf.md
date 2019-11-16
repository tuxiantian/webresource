日期的格式化

LocalDateTime

```
${#temporals.format(accessTime,'yyyy-MM-dd HH:mm:ss')}
```

Date

```
${#dates.format(accessTime,'yyyy-MM-dd HH:mm:ss')}
```

需要引入的jar

```
<dependency>
	<groupId>org.thymeleaf.extras</groupId>
	<artifactId>thymeleaf-extras-java8time</artifactId>
	<version>3.0.0.RELEASE</version>
</dependency>
```

若使用spring-boot-starter-thymeleaf，就不需要单独再引用上面的jar了。

```
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```



