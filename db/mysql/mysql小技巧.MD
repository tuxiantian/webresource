### 数字类型生成json后转字符串，入参时间字符串转Date类型
```
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
@JsonSerialize(using = ToStringSerializer.class)

import org.springframework.format.annotation.DateTimeFormat;
@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") Date startDate
```
### 取分组排序数据的第一条

```
    @Select("<script>" +
            "SELECT equipment_no FROM (" +
            "    SELECT equipment_no, ROW_NUMBER() OVER (PARTITION BY equipmentNo ORDER BY createTime DESC) as rn " +
            "    FROM special_equipment_warn_record " +
            "    WHERE state = 1 " +
            ") t WHERE t.rn = 1" +
            "</script>")
    List<String> findEquipmentNo();
```

```java
if (warnState!=null){
    List<String> warnRecordList = specialEquipmentWarnRecordMapper.findEquipmentNo();
    if (warnState==1){
    queryWrapper.in(SpecialEquipment::getEquipmentNo,warnRecordList);
    }else {
    queryWrapper.notIn(SpecialEquipment::getEquipmentNo,warnRecordList);
    }
 }
```



## INSTR

```sql
SELECT INSTR('foobarbar', 'bar');
```
返回结果>0则存在

## 多列合并成一列

以id分组，把name字段的值打印在一行，逗号分隔
```sql
select id,group_concat(name) from aa group by id;
```
以id分组，把name字段的值打印在一行，分号分隔
```sql
select id,group_concat(name separator ';') from aa group by id;
```
以id分组，把去冗余的name字段的值打印在一行，逗号分隔
```sql
select id,group_concat(distinct name) from aa group by id;
```
以id分组，把name字段的值打印在一行，逗号分隔，以name排倒序
```sql
select id,group_concat(name order by name desc) from aa group by id;
```
## find_in_set
```sql
<!-- 获取 db_ap_rgsh_standard_order_page_element表所有字段 -->
<sql id="getPageElementValue">
	ID id,
	REQUEST_SOURCE requestSource,
	ELEMENT_NAME `name`,
	DESCRIPTION `desc`,
	TYPE type,
	EDIT_FLAG editFlag,
	POSITION position,
	STATE state,
	FIELD_SORT fieldSort,
	DECRYPT decrypt
</sql>
<select id="queryPageElementByRequestSource" parameterType="java.util.Map" resultType="java.util.Map">
		SELECT
			<include refid="getPageElementValue"/>
		FROM
			db_ap_rgsh_standard_order_page_element t
		WHERE
		t.state = '0'
		<if test="requestSource != null and requestSource != 'null' and requestSource !='' ">
			and find_in_set(#{requestSource},t.REQUEST_SOURCE) 
		</if>
		<if test="busiType != null and busiType != 'null' and busiType !='' ">and t.BUSI_TYPE=#{busiType}</if>	
		ORDER BY FIELD_SORT ASC
</select>
```
一种业务有多个请求源接入，如果这些请求源都要进行页面元素显示配置，那将会产生很多重复数据。在REQUEST_SOURCE中配置多个以逗号分隔的请求源。查询时使用find_in_set函数。这样减少了重复数据的配置。
## if函数

mysql的if函数，例如：IF(expr1,expr2,expr3)  
如果 expr1是TRUE，则IF()的返回值为expr2; 否则返回值则为expr3  
实例（如果video_id为null，则直接返回空字符，避免不必要的查询影响效率）：  
(SELECT if(isnull(video_id),'',(SELECT cover from topic_video tv where tv.id = video_id))) 别称,  
## mysql日期函数
### DATE_ADD和DATE_SUB
DATE_ADD(date,INTERVAL expr type)  
DATE_SUB(date,INTERVAL expr type)  
ADDDATE(date,INTERVAL expr type)  
SUBDATE(date,INTERVAL expr type)  
　对日期时间进行加减法运算  
　(ADDDATE()和SUBDATE()是DATE_ADD()和DATE_SUB()的同义词,也可以用运算符+ 和-而不是函数  
　date是一个DATETIME或DATE值,expr对date进行加减法的一个表达式字符串，type指明表达式，expr应该如何被解释  
　[type值 含义 期望的expr格式]:  
 * SECOND 秒  
 * MINUTE 分钟  
 * HOUR 时间  
 * DAY 天  
 * MONTH 月  
 * YEAR 年  

```
SELECT OrderId,DATE_SUB(OrderDate,INTERVAL 2 DAY) AS OrderPayDate
FROM Orders
```
### NOW()和CURDATE()
```sql
SELECT NOW(); //2017-08-04 17:57:59
SELECT CURDATE(); //2017-08-04
```
### 查询当前时刻的排班
```sql
......
AND (
	(
		s.stat_time <![CDATA[<=]]> date_format(now(),'%H:%i') AND s.end_time <![CDATA[>]]> date_format(now(),'%H:%i')
	)
	or (
		s.end_time <![CDATA[<]]> s.stat_time and s.stat_time <![CDATA[<=]]> date_format(now(),'%H:%i')
	) OR (
		s.end_time <![CDATA[<]]> s.stat_time and date_format(now(),'%H:%i') <![CDATA[<]]> s.end_time
	)
)
```

### mysql查表中有多少字段的sql语句
```sql
SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='数据库名' AND table_name='表名'
```
### 大小写严格匹配的模糊查询
需要使用`binary`关键字

```sql
SELECT * FROM `t_car_insurance` WHERE `insurance_pic` like binary '%upload/insurance/2018/09/j%';
```
### 删除多个字段
```sql
alter table T_54  drop ( name2,name3);
```
### 更新
```sql
update a set 员工=(select 员工 from (select 员工 from a where id=1) as b) where id>2
update a inner join b on a.员工=b.代码 set a.员工=b.姓名
```
### 如何用一条SQL将一张表里的数据插入到另一张表的3个例子
1. 表结构完全一样
    insert into 表1  select * from 表2
2. 表结构不一样（这种情况下得指定列名）
   insert into 表1 (列名1,列名2,列名3)  select  列1,列2,列3 from 表2
3. 只从另外一个表取部分值
  insert into 表1 (列名1,列名2,列名3) values(列1,列2,(select 列3 from 表2));


### NOW()和CURDATE()
```sql
SELECT NOW(); //2017-08-04 17:57:59
SELECT CURDATE(); //2017-08-04
```
### 查询当前时刻的排班
```sql
......
AND (
	(
		s.stat_time <![CDATA[<=]]> date_format(now(),'%H:%i') AND s.end_time <![CDATA[>]]> date_format(now(),'%H:%i')
	)
	or (
		s.end_time <![CDATA[<]]> s.stat_time and s.stat_time <![CDATA[<=]]> date_format(now(),'%H:%i')
	) OR (
		s.end_time <![CDATA[<]]> s.stat_time and date_format(now(),'%H:%i') <![CDATA[<]]> s.end_time
	)
)
```
### 年龄的计算
```sql
select  
    id,  
    DATE_FORMAT(birthday,"%Y-%m-%d") birthday,  
    CURDATE() ,  
    (year(now())-year(birthday)-1) + (DATE_FORMAT(birthday, '%m%d') <= DATE_FORMAT(NOW(), '%m%d')) as age  
from  t_user
```
### 收益T+N可提现
```sql
TIMESTAMPDIFF(DAY,DATE_FORMAT(T.createTime,'%Y-%m-%d'),CURDATE())>=#{intervalDay}
```
### 计算时间差-TIMESTAMPDIFF
大于指定间隔时间方可以提现
```sql
<select id="queryIncomeDraw" resultMap="entityMap">
    <include refid="selectHead"/>
    AND  TIMESTAMPDIFF(DAY,createTime,NOW())>=#{intervalDay}
</select>
```
语法：

TIMESTAMPDIFF(interval,datetime_expr1,datetime_expr2)。

说明：

返回日期或日期时间表达式datetime_expr1 和datetime_expr2the 之间的整数差。其结果的单位由interval 参数给出。该参数必须是以下值的其中一个：

1. FRAC_SECOND 。表示间隔是毫秒
2. SECOND 。秒
3. MINUTE 。分钟
4. HOUR 。小时
5. DAY 。天
6. WEEK 。星期
7. MONTH 。月
8. QUARTER 。季度
9. YEAR 。年

### mysql查表中有多少字段的sql语句
```sql
SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='数据库名' AND table_name='表名'
```
