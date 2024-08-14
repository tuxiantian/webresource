---
typora-root-url: ..
---

使用spring cloud架构后，定时任务需要分离出来，做集群。
taskcore工程只管执行计划和作业，作业的内容放在业务工程实现。

[taskcore工程](https://github.com/tuxiantian/taskcore)

定时任务工程taskcore
```java
@FeignClient(name = "MAIN", fallback = TaskFeignClientFallback.class)
public interface TaskFeignClient {
    @RequestMapping(value = "/task/orderBookTimeOut", method = RequestMethod.POST)
    void orderBookTimeOut();
}

@Component
public class TaskFeignClientFallback implements TaskFeignClient,Serializable{

    @Override
    public void orderBookTimeOut() {
        
    }
}

@Service
public class OrderBookTimeOutJob implements IJob {

    @Override
    public void executeInternal() {
        TaskFeignClient taskFeignClient = SpringContextHolder.getBean(TaskFeignClient.class);
        taskFeignClient.orderBookTimeOut();
    }
}
```
这里若使用下面的方式会报taskFeignClient无法序列化的错误。
```java
@Service
public class OrderBookTimeOutJob implements IJob {
    @Autowire
    private TaskFeignClient taskFeignClient
    
    @Override
    public void executeInternal() {
        taskFeignClient.orderBookTimeOut();
    }
}
```
触发器配置如下
```xml
<bean id="schedulerFactoryBean"
    class="org.springframework.scheduling.quartz.SchedulerFactoryBean">
    <property name="dataSource" ref="dataSource" />
    <property name="configLocation" value="classpath:config/quartz.properties" />
    <property name="triggers">
        <list>
            <ref bean="orderBookTimeOutTrigger" />
        </list>
    </property>
    <property name="startupDelay" value="3" />
    <!--可选，QuartzScheduler 启动时更新己存在的Job，这样就不用每次修改targetObject后删除qrtz_job_details表对应记录了 -->
    <property name="overwriteExistingJobs" value="true" />
    <property name="applicationContextSchedulerContextKey" value="applicationContext" />
    <property name="schedulerName" value="ds_scheduler" />
</bean>
<bean id="orderBookTimeOutTrigger" class="org.springframework.scheduling.quartz.CronTriggerBean">
    <property name="name" value="orderBookTimeOutTrigger" />
    <property name="group" value="ds_trigger" />
    <property name="jobDetail">
        <ref bean="orderBookTimeOutJobDetail" />
    </property>
    <property name="cronExpression">
        <value>0/10 * * * * ?</value>
    </property>
</bean>
<bean id="orderBookTimeOutJobDetail"
        class="com.laijia.taskcore.quartz.impl.MethodInvokingJobDetailFactoryBean">
    <!--false表示等上一个任务执行完后再开启新的任务 -->
    <property name="concurrent" value="false" />
    <!-- true表示将此JOB持久化到数据库 -->
    <property name="durable" value="true" />
    <property name="targetObject" ref="orderBookTimeOutJob" />
    <property name="targetMethod" value="executeInternal" />
    <property name="group" value="ds_jobs" />
    <property name="description" value="orderBookTimeOutJobDetail" />
</bean>
```
业务工程main
```java
@RequestMapping("/task")
@RestController
public class TaskApi{
    @Autowired
    private OrderBookTimeOutJob orderBookTimeOutJob;
    
    @RequestMapping(value = "orderBookTimeOut", method = RequestMethod.POST)
    public void orderBookTimeOut(){
        orderBookTimeOutJob.execute();
    }
}

@Service
@Lazy(false)
public class OrderBookTimeOutJob {

    @Autowired
    private OrdersService ordersService;

    public void execute() {
        ordersService.updateBookTimeOut();
    }
}
```

非在租车辆每2分钟刷新一次车辆位置和gps位置信息，但是刷新一次需要240秒，这时定时任务会阻塞，并且定时任务阻塞后不能够恢复正常。
这时的解决办法就是把定时任务的执行计划改为5分钟执行一次。为了更合理的制定执行计划需要统计定时任务的执行时间。示例如下：
```java
@RequestMapping(value = "orderBookTimeOut", method = RequestMethod.POST)
public void orderBookTimeOut(){
    long startTime=System.currentTimeMillis();
    orderBookTimeOutJob.execute();
    long endTime=System.currentTimeMillis();
    float excTime=(float)(endTime-startTime)/1000;
    logger.info("orderBookTimeOut执行时间：{}秒",excTime);
}
```
常见的问题
![](/images/microservice/issue1.png)
![](/images/microservice/answer1.png)
由于在加新的定时任务配置时，复制了其它的定时任务配置，忘记修改了触发器的名字就导致上面的问题了。

来驾http://task.ilaijia.com/映射到39.107.15.174节点服务，下次升级请先升级这个节点。