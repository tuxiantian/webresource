## Spring Aop
Spring 切面可以应用五种类型的通知：  

* before ：前置通知，在一个方法执行前被调用  
*  after:  在方法执行之后调用的通知，无论方法执行是否成功  
*  after-returning:  仅当方法成功完成后执行的通知  
*  after-throwing:  在方法抛出异常退出时执行的通知  
* around:  在方法执行之前和之后调用的通知  

## 使用示例
### 打印方法的执行时间
使用注解作为切入点
```java
@Target({java.lang.annotation.ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface LogExecuteTime {
}
```
定义切面
```java
@Aspect
@Component
public class LogTimeAspect {

    private static Logger logger = LoggerFactory.getLogger(LogTimeAspect.class);

    @Pointcut("@annotation(com.laijia.config.LogExecuteTime)")
    public void logTimeMethodPointcut() {

    }

    @Around("logTimeMethodPointcut()")
    public Object interceptor(ProceedingJoinPoint pjp) {
        long startTime = System.currentTimeMillis();
        Object result = null;
        try {
            result = pjp.proceed();
        } catch (Throwable e) {
            logger.error(e.getMessage(), e);
            throw new RuntimeException(e);
        }
        logger.info(pjp.getSignature().getDeclaringTypeName() + "." + pjp.getSignature().getName() + " spend " + (System.currentTimeMillis() - startTime) + " ms");
        return result;
    }
}
```
```java
@LogExecuteTime
@ResponseBody
@RequestMapping(value = "loadInfo", produces = MediaType.APPLICATION_JSON_VALUE)
public Result loadInfo() {
    tBoxRefreshJob.refreshUnRentCars();
    return Result.success("无返回内容", null);
}
```