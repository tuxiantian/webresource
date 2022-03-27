在线Cron表达式生成器    http://cron.qqe2.com/
--------------------------------------------------------------------------------------
quarz表达式 秒 分 小时 天 月 星期  0 0 8 * * ? 每天8点 0 0/5 * * * ? 每5分钟
quartz里面都有什么组件
调度器：负责调度作业和触发器； SchedulerFactoryBean
触发器：设置作业执行的时间、参数、条件等；batchTrigger
作业：定时任务内容,被执行的程序 JobDetai
```
<task:scheduled-tasks>
    <task:scheduled ref="mcdsGathrService" method="execute" cron="0/10 * * * * ?" />
</task:scheduled-tasks>

<!-- 启动定时器 -->
<task:annotation-driven/>
@Scheduled(cron="0 33/3 * * * ?") web.xml中加载task.xml
```
spring自带的task
1.不支持集群,无法规避单点故障
2.执行计划不能变更,需停机重新打包发布才能修改
3.不支持单任务起停,要起全起要停全停
4.没有数据库配置功能,只能在代码中写死
5.无法不停机打补丁
