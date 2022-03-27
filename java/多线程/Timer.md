## Timer和ThreadPoolTaskExecutor配合使用的案例
每隔20秒打印一次线程池的线程使用情况。每隔一段时间使用线程池做一件事，可以参考这里的实现方式。
```xml
<bean id="taskExecutor" class="com.laijia.core.web.MyThreadPoolExecutor">
    <!-- 线程池维护线程的最少数量 -->
    <property name="corePoolSize" value="20"/>
    <!-- 允许的空闲时间 -->
    <property name="keepAliveSeconds" value="200"/>
    <!-- 线程池维护线程的最大数量 -->
    <property name="maxPoolSize" value="80"/>
    <!-- 缓存队列 -->
    <property name="queueCapacity" value="1000"/>
    <!-- 对拒绝task的处理策略 -->
    <property name="rejectedExecutionHandler">
        <bean class="java.util.concurrent.ThreadPoolExecutor$CallerRunsPolicy"/>
    </property>
</bean>

<!--线程监控-->
<bean id="threadPoolMonitor" class="com.laijia.biz.task.ThreadPoolMonitor" destroy-method="destory">
    <constructor-arg name="time" value="20"></constructor-arg>
    <constructor-arg name="taskExecutor" ref="taskExecutor"></constructor-arg>
</bean>
```
```java
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Callable;
import java.util.concurrent.Future;

public class MyThreadPoolExecutor extends ThreadPoolTaskExecutor {

    private static final Logger logger = LoggerFactory.getLogger(MyThreadPoolExecutor.class);

    public MyThreadPoolExecutor() {
        super();
    }

    @Override
    public void execute(Runnable task) {
        StopWatch watch = new StopWatch();
        watch.start();
        super.execute(task);
        watch.stop();
        logger.info("pool task:{}, use_time: {} sec", task.getClass(), watch.getTime()/1000);
    }


    @Override
    public void execute(Runnable task, long startTimeout) {
        StopWatch watch = new StopWatch();
        watch.start();
        super.execute(task, startTimeout);
        watch.stop();
        logger.info("task:{}, use_time: {} sec", task.getClass(), watch.getTime()/1000);
    }

    @Override
    public Future<?> submit(Runnable task) {
        StopWatch watch = new StopWatch();
        watch.start();
        Future<?> ret =  super.submit(task);
        logger.info("task:{}, use_time: {} sec", task.getClass(), watch.getTime()/1000);
        return ret;
    }

    @Override
    public <T> Future<T> submit(Callable<T> task) {
        StopWatch watch = new StopWatch();
        watch.start();
        Future<T> ret =  super.submit(task);
        logger.info("task:{}, use_time: {} sec", task.getClass(), watch.getTime()/1000);
        return ret;
    }
}
```

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.BlockingQueue;

/**
 * Created by wbq on 2018/12/11.
 */
public class ThreadPoolMonitor {
    private ThreadPoolTaskExecutor taskExecutor;
    Timer timer;

    public ThreadPoolMonitor(int time, ThreadPoolTaskExecutor taskExecutor) {
        this.taskExecutor = taskExecutor;
        timer = new Timer();
        timer.schedule(new ThreadTimerTask(taskExecutor), 1000 * 60 * 1, time * 1000);
    }

    public void destory(){
        logger.info("ThreadPoolMonitor is shutdown");
        if(this.timer!=null ) {
            this.timer.cancel();
        }
    }


    static class ThreadTimerTask extends TimerTask {
        private static final Logger logger = LoggerFactory.getLogger(ThreadTimerTask.class);
        private ThreadPoolTaskExecutor taskExecutor;

        public ThreadTimerTask(ThreadPoolTaskExecutor taskExecutor) {
            this.taskExecutor = taskExecutor;
        }

        @Override
        public void run() {
            try {
                if (taskExecutor == null || taskExecutor.getThreadPoolExecutor() == null) {
                    logger.info("taskExecutor or taskExecutor.getThreadPoolExecutor() is null");
                    return;
                }

                if (taskExecutor.getThreadPoolExecutor().isShutdown()
                        || taskExecutor.getThreadPoolExecutor().isTerminated()
                        || taskExecutor.getThreadPoolExecutor().isTerminating()) {
                    logger.info("{} shutdown", taskExecutor.getThreadNamePrefix());
                } else {
                    logger.info("{} , corePoolSize:{}, poolSize:{}, maxPoolSize:{}, largestPoolSize:{}, taskCount:{},  activeTask:{}, completeTask:{} ",
                            taskExecutor.getThreadNamePrefix(),
                            taskExecutor.getThreadPoolExecutor().getCorePoolSize(), taskExecutor.getPoolSize(),
                            taskExecutor.getThreadPoolExecutor().getMaximumPoolSize(),
                            taskExecutor.getThreadPoolExecutor().getLargestPoolSize(),
                            taskExecutor.getThreadPoolExecutor().getTaskCount(),
                            taskExecutor.getActiveCount(),
                            taskExecutor.getThreadPoolExecutor().getCompletedTaskCount()
                    );
                    BlockingQueue<Runnable> queue = taskExecutor.getThreadPoolExecutor().getQueue();
                    if (queue.size() > 0) {
                        int i = 0;
                        for (Runnable runnable : queue) {
                            logger.info("task-{}:{}", i, runnable.toString());
                            i++;
                        }
                    } else {
                        logger.info("task-list:clean");
                    }
                }
            } catch (Exception e) {
                logger.info("thread monitor is error", e);
            }
        }
    }
}
```