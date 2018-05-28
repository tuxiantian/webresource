<!-- TOC -->

- [Invalid bound statement (not found)](#invalid-bound-statement-not-found)
- [多条件判断语句choose](#多条件判断语句choose)
- [特殊符号的处理](#特殊符号的处理)
- [对数据库日期字段格式化](#对数据库日期字段格式化)
- [日期比较](#日期比较)
- [日期字段加索引注意事项](#日期字段加索引注意事项)
- [parameterType和resultType](#parametertype和resulttype)
- [批量更新](#批量更新)
    - [示例一](#示例一)
    - [示例二](#示例二)
- [like的使用](#like的使用)
    - [oracle](#oracle)
    - [mysql](#mysql)
- [case when的使用](#case-when的使用)
- [常用的统计sql](#常用的统计sql)
- [#{…}与${…}的区别](#与的区别)
- [mybatis中使用Java8的日期LocalDate、LocalDateTime](#mybatis中使用java8的日期localdatelocaldatetime)

<!-- /TOC -->
### Invalid bound statement (not found)
[mybatis绑定错误-- Invalid bound statement (not found)](https://www.jianshu.com/p/800fe918cc7a)

### 多条件判断语句choose
注意：mybatis中的字符串比较对于单个字符要加toString()  
代码片段
```sql
<choose>
	<when test="MYXJ_SERVICE_PASSWORD_VERIFY_SWITCH=='0'.toString()">
            and SERVICE_PASSWORD_VERIFY in ('0','1','2')
	</when>
	<when test="MYXJ_SERVICE_PASSWORD_VERIFY_SWITCH=='1'.toString()">
            and SERVICE_PASSWORD_VERIFY ='0'
	</when>
	<otherwise></otherwise>
</choose>
```
### 特殊符号的处理
对于>、<、等特殊符号要用<![CDATA[]]>处理
```sql
<if test="endDate != null and endDate != 'null' and endDate != ''">
	<![CDATA[
	and CREATE_DATE < date_add(str_to_date(#{endDate} , '%Y-%m-%d'), interval 1 day)
	]]>
</if>
```
### 对数据库日期字段格式化
年月日时分秒格式：%Y-%m-%d %H:%i:%s  
DATE_FORMAT(CREATE_DATE,'%Y-%m-%d %H:%i:%s')
### 日期比较
```sql
<if test="expertDate != null and expertDate != 'null' and expertDate != ''">
	and DATE_FORMAT(EXPERT_DATE,'%Y-%m-%d') = str_to_date(#{expertDate} , '%Y-%m-%d')
</if>
```
### 日期字段加索引注意事项
```sql
<if test="acceptDate != null and acceptDate != 'null' and acceptDate !='' ">
	and DATE_FORMAT(ACCEPT_DATE,'%Y-%m-%d') &gt;= str_to_date(#{acceptDate} , '%Y-%m-%d')
	and DATE_FORMAT(ACCEPT_DATE,'%Y-%m-%d') &lt;= date_add(str_to_date(#{acceptDate} , '%Y-%m-%d'), interval 1 day)
</if>
```
由于表中ACCEPT_DATE是varchar类型，在进行日期比较时，使用了DATE_FORMAT函数，因此对该字段上面加的索引就不起作用了。  
解决办法就是将字段类型改为datetime,查询的sql片段不再使用DATE_FORMAT函数，这样查询语句就会使用索引了。  
验证sql有没有使用索引：explain+sql
### parameterType和resultType
> map：java.util.Map  
> int: Integer  
> List: java.util.List
### 批量更新
#### 示例一
```sql
<update id="updateSysMarkToNullByPage" parameterType="java.util.Map">
	update ${table}
	set ${column} = null,
	MARK_DATE = null
	where LOGID in
	<foreach item="item" index="index" collection="idList" open="(" separator="," close=")">
		#{item}
	</foreach>
</update>
```
#### 示例二
```sql
<update id="markOrder" parameterType="java.util.List">
	<foreach collection="list" item="item" index="index" open="" close="" separator=";">
		UPDATE
		db_ap_rgsh_vertify_log
		<set>
			PERSONAL_OPCODE = #{item.personalOpCode},
			MARK_DATE = #{item.markDate}
		</set>
		WHERE
		LOGID = #{item.logId}
	</foreach>
</update>
```
### like的使用
#### oracle
```sql
select *   
from user  
where username like '%'||#username#||'%'
```
#### mysql
```sql
select *   
from user  
where username like concat('%', #username#, '%')
```
### case when的使用
```sql
select (case ext2
                   when '200' then
                    '广东'
                   when '210' then
                    '上海'
                   when '230' then
                    '重庆'
                   when '100' then
                    '北京'
                   when '771' then
                    '广西'
                   when '991' then
                    '新疆'
                   when '891' then
                    '西藏'
                   when '931' then
                    '甘肃'
                   when '471' then
                    '内蒙'
                   when '311' then
                    '河北'
                   when '451' then
                    '黑龙江'
                   when '431' then
                    '吉林'
                   when '240' then
                    '辽宁'
                   when '220' then
                    '天津'
                   when '531' then
                    '山东'
                   when '371' then
                    '河南'
                   when '250' then
                    '江苏'
                   when '571' then
                    '浙江'
                   when '591' then
                    '福建'
                   when '898' then
                    '海南'
                   when '871' then
                    '云南'
                   when '280' then
                    '四川'
                   when '851' then
                    '贵州'
                   when '971' then
                    '青海'
                   when '290' then
                    '陕西'
                   when '270' then
                    '湖北'
                   when '731' then
                    '湖南'
                   when '791' then
                    '江西'
                   when '551' then
                    '安徽'
                   when '351' then
                    '山西'
                   when '951' then
                    '宁夏'
                   else
                    '未知'
                 end) proviceName 
        from db_ap_gfms_user
```
### 常用的统计sql
date_sub日期减法操作  
统计在当前一天、当前一个月、过去到现在、过去一周、当前月、过去一个月、过去3个月和过去一年的app注册用户数量  
思路：每次只统计其中一项，其它的填充为0，完成各次统计后用union all合并。将和并的结果作为一个结果集。最后从这个结果集中查询各项。
```sql
<select id="queryAppRegUserInfo" parameterType="java.util.Map"
		resultType="java.util.HashMap">
	   <![CDATA[	 
       select concat(ifnull(sum(tb_total.cur_day_reg_user),0), '') as cur_day_reg_user,
              concat(ifnull(sum(tb_total.cur_month_reg_user),0), '') as  cur_month_reg_user,
              concat(ifnull(sum(tb_total.sum_cur_day_reg_user),0), '') as sum_cur_day_reg_user,
			  concat(ifnull(sum(tb_total.last_7day_reg_user),0), '') as last_7day_reg_user,
       		  concat(ifnull(sum(tb_total.last_1month_reg_user),0), '') as last_1month_reg_user,
              concat(ifnull(sum(tb_total.last_3month_reg_user),0), '') as last_3month_reg_user,
              concat(ifnull(sum(tb_total.last_1year_reg_user),0), '') as last_1year_reg_user
        from (
          select sum((case when  create_time >date_sub(str_to_date(#{queryDate}, '%Y-%m-%d %H:%i:%s'),interval 1 day)
                    then 1 else 0 end)) as cur_day_reg_user,
                 sum((case when create_time >str_to_date(concat(date_format(last_day(str_to_date(#{queryDate},'%Y-%m-%d %H:%i:%s')),'%Y-%m-'),'01'),'%Y-%m-%d %H:%i:%s')
                       then 1 else 0 end)) as cur_month_reg_user,
                  count(*) as sum_cur_day_reg_user,
                  0 as last_7day_reg_user,
                  0 as last_1month_reg_user,
                  0 as last_3month_reg_user,
                  0 as last_1year_reg_user
                  from db_ap_gfms_user
                 where ]]><include refid="addProvinceCdt" />
               <![CDATA[
         create_time <=str_to_date(#{queryDate}, '%Y-%m-%d %H:%i:%s')
        union all
        select 0 as cur_day_reg_user,
               0 as cur_month_reg_user,
               0 as sum_cur_day_reg_user,
               count(*) as last_7day_reg_user,
               0 as last_1month_reg_user,
               0 as last_3month_reg_user,
               0 as last_1year_reg_user
          from db_ap_gfms_user
         where ]]><include refid="addProvinceCdt" />
               <![CDATA[
           create_time <=str_to_date(#{queryDate}, '%Y-%m-%d %H:%i:%s')
           and create_time >date_sub(str_to_date(#{queryDate}, '%Y-%m-%d %H:%i:%s'),
                                      interval 7 day)
        union all
        select 0 as cur_day_reg_user,
               0 as cur_month_reg_user,
               0 as sum_cur_day_reg_user,
               0 as last_7day_reg_user,
               count(*) as last_1month_reg_user,
               0 as last_3month_reg_user,
               0 as last_1year_reg_user
          from db_ap_gfms_user
         where ]]><include refid="addProvinceCdt" />
               <![CDATA[
           create_time <=str_to_date(#{queryDate}, '%Y-%m-%d %H:%i:%s')
           and create_time >
               date_format(str_to_date(#{queryDate}, '%Y-%m-%d %H:%i:%s') - interval 1
                           month,'%Y-%m-%d %H:%i:%s')
        union all
        select 0 as cur_day_reg_user,
               0 as cur_month_reg_user,
               0 as sum_cur_day_reg_user,
               0 as last_7day_reg_user,
               0 as last_1month_reg_user,
               count(*) as last_3month_reg_user,
               0 as last_1year_reg_user
          from db_ap_gfms_user
         where ]]><include refid="addProvinceCdt" />
               <![CDATA[
           create_time <=str_to_date(#{queryDate}, '%Y-%m-%d %H:%i:%s')
           and create_time >
               date_format(str_to_date(#{queryDate}, '%Y-%m-%d %H:%i:%s') - interval 3
                           month,'%Y-%m-%d %H:%i:%s')
        union all
        select 0 as cur_day_reg_user,
               0 as cur_month_reg_user,
               0 as sum_cur_day_reg_user,
               0 as last_7day_reg_user,
               0 as last_1month_reg_user,
               0 as last_3month_reg_user,
               count(*) as last_1year_reg_user
          from db_ap_gfms_user
         where ]]><include refid="addProvinceCdt" />
               <![CDATA[
           create_time <=str_to_date(#{queryDate}, '%Y-%m-%d %H:%i:%s')
           and create_time >date_sub(str_to_date(#{queryDate}, '%Y-%m-%d %H:%i:%s'), interval 1 year)
         ) tb_total
         ]]>
	</select>	
```
### #{…}与${…}的区别
MyBatis将 #{…} 解释为JDBC prepared statement 的一个参数标记。而将 ${…} 解释为字符串替换

###  mybatis中使用Java8的日期LocalDate、LocalDateTime
[mybatis中使用Java8的日期LocalDate、LocalDateTime](http://blog.csdn.net/mn960mn/article/details/53139216)  
引入以下jar包即可解决，在mybatis 3.4.0版本及以上版本中测试有效。
```xml
<dependency>  
    <groupId>org.mybatis</groupId>  
    <artifactId>mybatis-typehandlers-jsr310</artifactId>  
    <version>1.0.1</version>  
</dependency>  
```