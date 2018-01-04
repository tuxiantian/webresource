---
typora-root-url: ..\..\..
---

运维统计报表中增加，已完成任务统计  
查询条件：运维人员、时间范围、任务类型、片区  
输出项：运维人员，片区，任务类型，车牌号，下发时间，接收时间，完成时间，任务说明，评价内容  
数据库如下  
![](/images/db/mysql/sql/UNION-ALL查询分页示例/1.png)  
自主任务表和任务基本信息表都有自己的业务类型，它们的业务类型值有交叉。
根据业务类型查询时增加了虚拟列source。
```sql
<select id="findTaskInfoDetailPage" resultType="mb">
<include refid="sys.begin"/>
select name,taskType,lpn,z.`zone_name` zoneName,send_time sendTime,rece_time recTime,date_format(finish_time,'%Y-%m-%d %H:%i:%s')  finishTime ,m.remark,eval_result evalResult,eval_content evalContent
from(SELECT 1 source,u.`name`,(case t.task_type when 1 then '维修' when 2 then '清洗' when 3 then '调度' when 4 then '充电' else '交通事故' end) taskType,t.lpn,t.zone_id,t.send_time,t.rece_time,
t.finish_time,t.task_remark remark,t.eval_result,t.eval_content
FROM t_task_info t
left join t_main_user u on t.`rece_id` =u.`user_id`
WHERE t.status=9
<if test="startDate!=null and startDate!=''">AND finish_time <![CDATA[>=]]> #{startDate}</if>
<if test="endDate!=null and endDate!=''">AND finish_time <![CDATA[<=]]> #{endDate}</if>
<if test="taskType!=null and taskType==7"> AND task_type=3</if>
<if test="taskType!=null and taskType==8"> AND task_type=4</if>
<if test="taskType!=null and taskType==9"> AND task_type=2</if>
<if test="taskType!=null and taskType==10"> AND task_type=1</if>
<if test="taskType!=null and taskType==11"> AND task_type=5</if>
UNION ALL
SELECT
2 source,u.`name`,(case task_type when 1 then '巡检' when 2 then '清洁' when 3 then '调度' else '充电' end) taskType,lpn,zone_id,'' send_time,'' rece_time,finish_time,remark,eval_result,eval_content
FROM t_auto_task au
left join t_main_user u on au.reporter_id =u.`user_id`
WHERE 1=1
<if test="startDate!=null and startDate!=''">AND finish_time <![CDATA[>=]]> #{startDate}</if>
<if test="endDate!=null and endDate!=''">AND finish_time <![CDATA[<=]]> #{endDate}</if>
<if test="taskType!=null and taskType==1"> AND task_type=2</if>
<if test="taskType!=null and taskType==2"> AND task_type=4</if>
<if test="taskType!=null and taskType==3"> AND task_type=3</if>
<if test="taskType!=null and taskType==4"> AND task_type=1</if>
UNION ALL
SELECT
3 source,u.`name`,(case is_repair when 1 then '维修' else '清洗' end) taskType,lpn,'' zone_id,'' send_time,'' rece_time,report_time finish_time,remark,eval_result,eval_content
FROM t_report_task rt
left join t_main_user u on rt.reporter_id =u.`user_id`
WHERE 1=1
<if test="startDate!=null and startDate!=''">AND report_time <![CDATA[>=]]> #{startDate}</if>
<if test="endDate!=null and endDate!=''">AND report_time <![CDATA[<=]]> #{endDate}</if>
<if test="taskType!=null and taskType==5"> AND is_wash=1</if>
<if test="taskType!=null and taskType==6"> AND is_repair=1</if>
) m
LEFT JOIN t_zone z ON m.zone_id=z.zone_id
WHERE 1=1
<if test="zoneId !=null">
    AND m.zone_id=#{zoneId}
</if>
<if test="keyword !=null and keyword !=''">
    AND m.name LIKE concat('%',#{keyword},'%')
</if>
<if test="taskType!=null and (taskType==7 or taskType==8 or taskType==9 or taskType==10 or taskType==11)"> AND m.source=1</if>
<if test="taskType!=null and (taskType==1 or taskType==2 or taskType==3 or taskType==4)"> AND m.source=2</if>
<if test="taskType!=null and (taskType==5 or taskType==6)"> AND m.source=3</if>
order BY m.finish_time DESC
<include refid="sys.end"/>
</select>
<!--查询条件 任务类型id@ 1  自主清洗  2 自主充电  3  自主移位  4  自主巡检   5 上报清洗  6  上报维修 7 下发调度  8  下发充电  9 下发清洗  10  下发维修  11  下发事故处理
下发任务 任务类型@1维修 2 清洗 3 调度 4 充电 5 交通事故
自主任务 任务类型@ 1巡检 2  清洁  3 调度  4 充电-->
<select id="findTaskInfoDetailPageCount" resultType="long">
select count(1)
from (SELECT 1 source,u.`name`,t.zone_id
FROM t_task_info t
left join t_main_user u on t.`rece_id` =u.`user_id`
WHERE t.status=9
<if test="startDate!=null and startDate!=''">AND finish_time <![CDATA[>=]]> #{startDate}</if>
<if test="endDate!=null and endDate!=''">AND finish_time <![CDATA[<=]]> #{endDate}</if>
<if test="taskType!=null and taskType==7"> AND task_type=3</if>
<if test="taskType!=null and taskType==8"> AND task_type=4</if>
<if test="taskType!=null and taskType==9"> AND task_type=2</if>
<if test="taskType!=null and taskType==10"> AND task_type=1</if>
<if test="taskType!=null and taskType==11"> AND task_type=5</if>
UNION ALL
SELECT
2 source,u.`name`,zone_id
FROM t_auto_task au
left join t_main_user u on au.reporter_id =u.`user_id`
WHERE 1=1
<if test="startDate!=null and startDate!=''">AND finish_time <![CDATA[>=]]> #{startDate}</if>
<if test="endDate!=null and endDate!=''">AND finish_time <![CDATA[<=]]> #{endDate}</if>
<if test="taskType!=null and taskType==1"> AND task_type=2</if>
<if test="taskType!=null and taskType==2"> AND task_type=4</if>
<if test="taskType!=null and taskType==3"> AND task_type=3</if>
<if test="taskType!=null and taskType==4"> AND task_type=1</if>
UNION ALL
SELECT
3 source,u.`name`,'' zone_id
FROM t_report_task rt
left join t_main_user u on rt.reporter_id =u.`user_id`
WHERE 1=1
<if test="startDate!=null and startDate!=''">AND report_time <![CDATA[>=]]> #{startDate}</if>
<if test="endDate!=null and endDate!=''">AND report_time <![CDATA[<=]]> #{endDate}</if>
<if test="taskType!=null and taskType==5"> AND is_wash=1</if>
<if test="taskType!=null and taskType==6"> AND is_repair=1</if>
) m
LEFT JOIN t_zone z ON m.zone_id=z.zone_id
WHERE 1=1
<if test="zoneId !=null">
    AND m.zone_id=#{zoneId}
</if>
<if test="keyword !=null and keyword !=''">
    AND m.name LIKE concat('%',#{keyword},'%')
</if>
<if test="taskType!=null and (taskType==7 or taskType==8 or taskType==9 or taskType==10 or taskType==11)"> AND m.source=1</if>
<if test="taskType!=null and (taskType==1 or taskType==2 or taskType==3 or taskType==4)"> AND m.source=2</if>
<if test="taskType!=null and (taskType==5 or taskType==6)"> AND m.source=3</if>
</select>
```