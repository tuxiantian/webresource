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

### 根据时间范围查询设备在一天的开关机时间

```sql
WITH RankedEvents AS (
    SELECT
        device_id,
        data_time,
        power_on_status,
        ROW_NUMBER() OVER (PARTITION BY device_id, power_on_status, TRUNC(data_time) ORDER BY push_time) AS rn
    FROM
        CXNP.sw_personnel_positioning_recard
    WHERE
        device_id = #{deviceId}
        AND power_on_status IN ('0', '1')
        AND data_time BETWEEN #{startDate} AND #{endDate}
)
SELECT
    device_id,
    data_time,
    CASE power_on_status
        WHEN '1' THEN '开机'
        WHEN '0' THEN '关机'
        ELSE '未知状态'
    END AS event
FROM
    RankedEvents
WHERE
    rn = 1
ORDER BY
    data_time DESC;
```

### 自定义排序顺序

```
import org.junit.jupiter.api.Test;

import java.util.*;

public class SortTest {

    @Test
    public void test1(){
        List<String> list= Arrays.asList("施工一标" ,"施工七标" ,"施工三标" ,"施工九标" ,"施工二标","数字孪生施工标");
        // 定义自定义排序顺序
        final String[] order = {"施工一标", "施工二标", "施工三标", "施工四标", "施工五标", "施工六标", "施工七标", "施工八标", "施工九标"};

        // 使用自定义比较器进行排序
        Collections.sort(list, new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                int index1 = -1;
                int index2 = -1;

                for (int i = 0; i < order.length; i++) {
                    if (o1.equals(order[i])) {
                        index1 = i;
                        break;
                    }
                }
                for (int i = 0; i < order.length; i++) {
                    if (o2.equals(order[i])) {
                        index2 = i;
                        break;
                    }
                }

                // 如果两个字符串都在order数组中，按照数组中的顺序排序
                if (index1 != -1 && index2 != -1) {
                    return Integer.compare(index1, index2);
                }

                // 如果只有一个字符串在order数组中，那么它排在前面
                if (index1 != -1) {
                    return -1;
                }
                if (index2 != -1) {
                    return 1;
                }

                // 如果两个字符串都不在order数组中，那么它们保持原有顺序
                return 0;
            }
        });
        // 打印排序后的集合
        System.out.println(list);
    }
}
```

sql自定义排序顺序

```
select p.id,p.name,n.id sub_project_id,n.node_name
        from sys_portal p
        LEFT JOIN construction_package_wbs_node n ON p.id=n.portal_id
        where p.delete_flag = 0 and p.type='3' AND n.delete_flag = 0 and n.node_type='子工程'  and n.delete_flag=0 AND p.id!=1777649304224141313
        ORDER BY 
  CASE p.name
    WHEN '施工一标' THEN 1
    WHEN '施工二标' THEN 2
    WHEN '施工三标' THEN 3
    WHEN '施工七标' THEN 4
    WHEN '施工九标' THEN 5
    ELSE 6
  END
   ASC
```

