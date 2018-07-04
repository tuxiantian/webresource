![TIM截图20180703160508](D:\webresource\images\microservice\spring-cloud\TIM截图20180703160508.png)

将每日的可提现收益标记为可提现的任务执行了较长时间导致了

> Caused by: feign.RetryableException: Read timed out executing POST http://MAIN/task/incomeDrawChange

处理方式

```java
@Autowired
private TaskExecutor taskExecutor;

public void incomeDrawChange(){
    taskExecutor.execute(()->{
        //处理业务
        ......
    });
}
```