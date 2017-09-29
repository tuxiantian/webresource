<!-- TOC -->

- [INSTR](#instr)
- [多列合并成一列](#多列合并成一列)
- [find_in_set](#find_in_set)

<!-- /TOC -->

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