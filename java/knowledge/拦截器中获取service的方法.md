```java
BeanFactory factory = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext()); 
RedisService<String,String> redisService = (OperatorLogService) factory.getBean("redisService");
```

