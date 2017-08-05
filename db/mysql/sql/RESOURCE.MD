<!-- TOC -->

- [我的行程详情](#我的行程详情)
    - [效果图](#效果图)
    - [接口数据](#接口数据)
    - [表结构](#表结构)
    - [sql语句](#sql语句)
    - [服务类代码编写](#服务类代码编写)
- [营收统计](#营收统计)
    - [效果图如下](#效果图如下)
    - [接口](#接口)
    - [表结构如下](#表结构如下)
    - [sql语句如下](#sql语句如下)
- [EXISTS](#exists)
- [使用优化的分页查询语句](#使用优化的分页查询语句)
- [find_in_set](#find_in_set)
- [mysql查表中有多少字段的sql语句](#mysql查表中有多少字段的sql语句)
- [EXISTS关键字的一个使用示例](#exists关键字的一个使用示例)
- [左关联的使用误区](#左关联的使用误区)
- [mysql 如何用一条SQL将一张表里的数据插入到另一张表的3个例子](#mysql-如何用一条sql将一张表里的数据插入到另一张表的3个例子)
- [if函数](#if函数)
- [NOW()和CURDATE()](#now和curdate)

<!-- /TOC -->

### 我的行程详情
#### 效果图
![](/images/db/mysql/sql/detail.png)
#### 接口数据
![](/images/db/mysql/sql/interface_data.png)
#### 表结构
![](/images/db/mysql/sql/table1.png)
在做一个复杂的业务时，可以新建一个Physical Diagram，然后把相关的表复制过来，然后把表加上外键关联，这将非常有助于理解业务数据之间的关系。  
#### sql语句
```sql
<select id="myTripDetail" resultType="mb">
         SELECT
              o.order_id orderId,o.bus_type busType,ticket_amount ticketAmount,discount_amount discountAmount,breakfast_fee breakfastFee,ticket_num ticketNum,pay_type payType,
              o.create_time createTime,
              o.status,
              CASE
                o.status
                WHEN 0
                THEN '未完成'
                WHEN 1
                THEN '已完成'
                WHEN 2
                THEN '已取消'
              END statusDesc,
              c.busName busName,
              c.startStationName,
              c.endStationName,
              c.startTime,
               bt.up_station_time upStationTime,
                   bt.down_station_time downStationTime,
                   bt.pkg_start_date pkgStartDate,bt.pkg_end_date pkgEndDate,bt.pkg_num pkgNum,bt.ticket_type ticketType,bt.pkg_type pkgType,bt.seat_num seatNum,bt.ticket_date ticketDate,
                   bt.upStationName,bt.downStationName
            FROM
              t_bus_order o
              LEFT OUTER JOIN
                (SELECT
                  t.order_id,
                  t.bus_id,
                  t.bus_type,
                   up_station_time,
                   down_station_time,
                   pkg_start_date,pkg_end_date,pkg_num ,ticket_type,pkg_type,seat_num,ticket_date,ts4.station_name upStationName,ts5.station_name downStationName
                FROM
                  t_bus_ticket t
                  LEFT OUTER JOIN t_station ts4 ON ts4.station_id=t.up_station_id
                  LEFT OUTER JOIN t_station ts5 ON ts5.station_id=t.down_station_id
                GROUP BY t.order_id,
                  t.bus_id,
                  t.bus_type) bt
                ON o.order_id = bt.order_id
              LEFT OUTER JOIN
                (SELECT
                  1 bus_type,
                  rb.bus_id,
                  rb.busnum_name busName,
                  rb.start_time startTime,
                  ts.station_name startStationName,
                  ts1.station_name endStationName
                FROM
                  t_regular_bus rb
                  LEFT OUTER JOIN t_station ts
                    ON rb.start_station_id = ts.station_id
                  LEFT OUTER JOIN t_station ts1
                    ON rb.end_station_id = ts1.station_id
                UNION
                SELECT
                  2 bus_type,
                  b.bus_id,
                  b.bus_name busName,
                  b.express_run_start_time startTime,
                  ts2.station_name startStationName,
                  ts3.station_name endStationName
                FROM
                  t_bus b
                  LEFT OUTER JOIN t_station ts2
                    ON b.start_station_id = ts2.station_id
                  LEFT OUTER JOIN t_station ts3
                    ON b.end_station_id = ts3.station_name) c
                ON bt.bus_id = c.bus_id
                AND bt.bus_type = c.bus_type
            WHERE o.order_id = #{orderId}
    </select>

```
班车车票表中的班车类型有班车、巴士。班车信息、巴士信息分别存在不同的表中，需要根据不同的类型去不同的表中取数据。这里的处理方式值得借鉴。  
#### 服务类代码编写
```java
public Result myTripDetail(Long orderId){
	MapBean data = this.mapper.myTripDetail(orderId);
	//多张日票的情况
	if (data.getInt("ticketType")==TicketType.day.getVal()&&data.getInt("ticketNum")>1){
		List<MapBean> ticketList = busTicketService.myTripDetail(orderId);
		for (MapBean mapBean:ticketList) {
			mapBean.put("ticketDate",DateUtil.date2String(mapBean.get("ticketDate"),DateUtil.DATE_PATTERN.MM_YUE_DD_RI));
		}
		data.put("ticketList",ticketList);
	}
	//单张日票的情况
	if(data.getInt("ticketType")==TicketType.day.getVal()&&data.getInt("ticketNum")==1){
		List<MapBean> ticketList =new ArrayList<>();
		MapBean temp=new MapBean();
		temp.put("seatNum",data.getString("seatNum"));
		temp.put("ticketDate",data.getString("ticketDate"));
		ticketList.add(temp);
		data.put("ticketList",ticketList);
	}

	if (data.getInt("ticketType")==TicketType.day.getVal()){//日票
		data.put("pkgType",0);
	}else {//套票
		List<MapBean> ticketList =new ArrayList<>();
		MapBean temp=new MapBean();
		String pkgStartDate=DateUtil.date2String(data.get("pkgStartDate"),DateUtil.DATE_PATTERN.YYYY_MM_DD);
		String pkgEndDate=DateUtil.date2String(data.get("pkgEndDate"),DateUtil.DATE_PATTERN.YYYY_MM_DD);
		temp.put("ticketDate",String.format("%s-%s",pkgStartDate,pkgEndDate));
		temp.put("seatNum",data.getString("seatNum"));
		ticketList.add(temp);
		data.put("ticketList",ticketList);
	}
	return Result.success("查询成功",data);
}
```

### 营收统计

#### 效果图如下
![](/images/db/mysql/sql/income.png)  
#### 接口
![](/images/db/mysql/sql/income_interface.png)  
#### 表结构如下
![](/images/db/mysql/sql/bus_order.png)  
#### sql语句如下
```sql
<select id="incomeStatistics" resultType="mb">
    SELECT SUM(CASE  WHEN bt.bus_type=1 AND o.pay_type=1 THEN o.pay_fee ELSE 0 END) rbAliFee,
    SUM(CASE  WHEN bt.bus_type=1 AND o.pay_type=2 THEN o.pay_fee ELSE 0 END) rbWxFee,
    SUM(CASE  WHEN bt.bus_type=1 AND (o.pay_type=1 OR o.pay_type=2)  THEN o.pay_fee ELSE 0 END) rbSumFee,
    SUM(CASE  WHEN bt.bus_type=2 AND o.pay_type=1 THEN o.pay_fee ELSE 0 END) bAliFee,
    SUM(CASE  WHEN bt.bus_type=2 AND o.pay_type=2 THEN o.pay_fee ELSE 0 END) bWxFee,
    SUM(CASE  WHEN bt.bus_type=2 AND (o.pay_type=1 OR o.pay_type=2) THEN o.pay_fee ELSE 0 END) bSumFee,
    SUM(CASE o.pay_type WHEN 1 THEN o.pay_fee WHEN 2 THEN o.pay_fee ELSE 0 END) sumFee FROM t_bus_order o
    INNER JOIN (SELECT order_id,bus_type FROM  t_bus_ticket GROUP BY  order_id,bus_type) bt ON o.order_id=bt.order_id
    WHERE o.center_id=#{centerId} AND o.pay_status=1
    <if test="startDate !=null and startDate !=''">
        AND o.pay_time <![CDATA[ >= ]]> #{startDate}
    </if>
    <if test="endDate !=null and endDate !=''">
        AND o.pay_time <![CDATA[ <= ]]> #{endDate}
    </if>

</select>
```

### EXISTS
ORGNO表示组织结构代码，总部是10，大区、市级服务商、县级服务商、商户每级是四位数字代码。  
AND T.ORGNO LIKE CONCAT(#{parentOrgNo},'____') 表示只看直属下级的信息，"'____'"是四位下划线  
根据输入参数的不同使用不同的关联查询条件，使用EXISTS

```sql
<sql id="selectHead">
    SELECT
      T.ORGNO,
      T.ORGNAME
    FROM T_ORGANIZATION T
    WHERE 1=1
</sql>
<sql id="condition">

    <if test="parentOrgNo != null">
        AND T.ORGNO LIKE CONCAT(#{parentOrgNo},'____')
    </if>
    <if test="areaCode != null">
        AND EXISTS (SELECT 1 FROM t_org_product OP WHERE OP.`ORGNO`=T.`ORGNO` AND OP.`AREACODE`=#{areaCode})
    </if>
    <if test="productId != null">
        AND EXISTS (SELECT 1 FROM t_org_product OP WHERE OP.`ORGNO`=T.`ORGNO` AND OP.`PRODUCTID`=#{productId})
    </if>

</sql>
```

### 使用优化的分页查询语句
会员的封号记录单独存放在一张表中，会员信息与封号记录是一对多的关系，这样便于追踪会员的封号历史记录。高效分页的原理是
先根据查询条件查出分页数据的主键集合，然后与其它表进行关联查询要展示的字段。

```sql
CREATE TABLE `t_member` (
  `user_id` char(32) NOT NULL COMMENT '会员ID',
  `mobile` varchar(15) DEFAULT NULL COMMENT '手机号码',
  `nick_name` varchar(30) DEFAULT '小马用户' COMMENT '昵称@4~15位的中英文、数字',
  `portrait` varchar(200) DEFAULT NULL COMMENT '头像',
  `user_pass` varchar(32) DEFAULT NULL COMMENT '会员密码@6~16位的中英文、数字（不可为纯数字）',
  `email` varchar(50) DEFAULT NULL COMMENT '电子邮箱',
  `job` int(10) unsigned DEFAULT NULL COMMENT '职业ID',
  `business` int(10) unsigned DEFAULT NULL COMMENT '行业ID',
  `xgtoken` varchar(100) DEFAULT NULL COMMENT '信鸽TOKEN',
  `reg_lat` decimal(10,6) DEFAULT NULL COMMENT '注册纬度',
  `reg_lon` decimal(10,6) DEFAULT NULL COMMENT '注册经度',
  `reg_city` varchar(30) DEFAULT NULL COMMENT '注册城市代码',
  `app_type` tinyint(3) unsigned DEFAULT NULL COMMENT 'APP类型@1：苹果 2：安卓 3：window mobile',
  `mobile_model` varchar(50) DEFAULT NULL COMMENT '手机型号',
  `reg_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `status` tinyint(4) DEFAULT NULL COMMENT '状态@ 0 封号 1 正常',
  `froz_sn` bigint(20) DEFAULT NULL COMMENT '封号流水号',
  `name` varchar(20) DEFAULT NULL COMMENT '姓名',
  `driving_type` char(2) DEFAULT NULL COMMENT '准驾车型',
  `license_valid_start_date` date DEFAULT NULL COMMENT '有效开始日期',
  `license_valid_end_date` date DEFAULT NULL COMMENT '有效结束日期',
  `id_number` char(18) DEFAULT NULL COMMENT '身份证号',
  `sex` char(2) DEFAULT NULL COMMENT '性别',
  `nation` varchar(50) DEFAULT NULL COMMENT '民族',
  `birthday` date DEFAULT NULL COMMENT '出生年月',
  `home_address` varchar(200) DEFAULT NULL COMMENT '家庭住址',
  `curr_address` varchar(200) DEFAULT NULL COMMENT '当前住址',
  `sign_org` varchar(100) DEFAULT NULL COMMENT '签发机关',
  `id_valid_start_date` date DEFAULT NULL COMMENT '有效开始日期',
  `id_valid_end_date` date DEFAULT NULL COMMENT '有效结束日期',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `idx_account_mobile` (`mobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员表'

CREATE TABLE `t_member_frozenseq` (
  `sn` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '封号明细流水号',
  `user_id` char(32) NOT NULL COMMENT '会员ID',
  `buss_type` tinyint(4) DEFAULT NULL COMMENT '业务类型@0 封号 1 解封',
  `frozen_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '封号类型@1永久 2 一年 3 三个月  4 三天',
  `frozen_end_date` date DEFAULT NULL COMMENT '封号截止日期',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `create_user` varchar(30) NOT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`sn`),
  KEY `idx_membstopseq_memberid_time` (`user_id`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='会员封号解封明细'
```

```sql
<!--会员封号列表-->
<select id="frozenPage" resultType="mb">
    SELECT
            t.user_id userId,
            t.mobile,
            t.nick_name nickName,
            t.status,
            t.froz_sn frozSn,
            t.name,
            t.sex,
            f.frozen_type frozenType,
            f.create_time frozenTime,
            f.frozen_end_date frozenEndDate,
            f.remark
    FROM t_member t,t_member_frozenseq f,
    (
    <include refid="sys.begin"/>
    SELECT t.user_id FROM t_member t WHERE t.status=0
    <include refid="condition"/>
    ORDER BY t.froz_sn DESC
    <include refid="sys.end"/>
    ) B
    WHERE t.user_id=B.user_id AND t.froz_sn=f.sn
    ORDER BY t.froz_sn DESC
</select>

<select id="frozenPageCount" resultType="long">
    SELECT count(1) FROM t_member t
    INNER JOIN t_member_frozenseq f ON f.user_id=t.user_id AND t.froz_sn=f.sn
    WHERE 1=1 AND t.status=0 AND f.buss_type=0
    <include refid="condition"/>
</select>
```

### find_in_set
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

### mysql查表中有多少字段的sql语句
SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='数据库名' AND table_name='表名'

### EXISTS关键字的一个使用示例
1需求：为某些省份的重复的渠道做标记
```sql
--1查询需要做标记的总记录数
SELECT   SUM(  aa.cou)  FROM (
SELECT channel_id,  prov_code, COUNT(1) cou
FROM db_ap_rgsh_channel
GROUP BY channel_id , prov_code  HAVING COUNT(1) >1 ) aa ;
--查询结果7120

--2标记重复的渠道，渠道ID增加了REPEAT_前缀。
UPDATE db_ap_rgsh_channel t SET t.`CHANNEL_ID` =  CONCAT('REPEAT_' ,t.`CHANNEL_ID`)  
WHERE   EXISTS (
SELECT * FROM (
SELECT a.channel_id,  a.prov_code, COUNT(1) cou
FROM db_ap_rgsh_channel a
GROUP BY a.channel_id,a.prov_code  HAVING COUNT(1) >1 
) aa  WHERE  aa.channel_id = t.`CHANNEL_ID` AND aa.prov_code =t.`PROV_CODE`
 )
--更新影响行数7120
```
### 左关联的使用误区
查询所有的套餐信息，若用户购买了某个套餐，isBuy的值为1，否则值为0.下面的sql是有问题的，若用户没有购买套餐，则查不出任何套餐信息。
最外层的where条件是对left join起过滤作用的。
```sql
<select id="findAll" resultType="mb">
    SELECT
    T.PKGID pkgId,
    T.areacode areaCode,
    (SELECT a.areaName FROM t_area a WHERE a.AREACODE = t.AREACODE) AS areaName,
    T.PKGNAME pkgName,
    T.PKGAMOUNT pkgAmount,
    T.PKGTIMELONG pkgTimeLong,
    T.DAYFREETIMES dayFreeTimes,
    T.ONCETIMELONG onceTimeLong,
    T.REMARK remark,
    p.pkg_end_date pkgEndDate,
    if(isnull(p.userId),0,1) isBuy
    FROM T_ACCOUNTPKG_CONFIG T
    LEFT JOIN t_account_pkg p ON T.PKGID=p.PKGID
    WHERE 1=1
    <if test="userId !=null">
        AND p.userId=#{userId}
    </if>
    <if test="areaCode !=null and areaCode !=''">
        AND T.areacode=#{areaCode}
    </if>
    ORDER BY T.PKGID DESC
</select>
```
正确的sql是下面这样写的：
```sql
<select id="findAll" resultType="mb">
    SELECT
    T.PKGID pkgId,
    T.areacode areaCode,
    (SELECT a.areaName FROM t_area a WHERE a.AREACODE = t.AREACODE) AS areaName,
    T.PKGNAME pkgName,
    T.PKGAMOUNT pkgAmount,
    T.PKGTIMELONG pkgTimeLong,
    T.DAYFREETIMES dayFreeTimes,
    T.ONCETIMELONG onceTimeLong,
    T.REMARK remark,
    p.pkg_end_date pkgEndDate,
    if(isnull(p.userId),0,1) isBuy
    FROM T_ACCOUNTPKG_CONFIG T
    LEFT JOIN (SELECT pkg_end_date,PKGID,userId FROM t_account_pkg WHERE
    <if test="userId !=null">
        userId=#{userId}
    </if>
    ) p ON T.PKGID=p.PKGID
    WHERE 1=1
    <if test="areaCode !=null and areaCode !=''">
        AND T.areacode=#{areaCode}
    </if>
    ORDER BY T.PKGID DESC
</select>
```
### mysql 如何用一条SQL将一张表里的数据插入到另一张表的3个例子

1. 表结构完全一样  
 	insert into 表1  select * from 表2
2. 表结构不一样（这种情况下得指定列名）  
   insert into 表1 (列名1,列  名2,列名3)  select  列1,列2,列3 from 表2
3. 只从另外一个表取部分值  
	insert into 表1 (列名1,列名2,列名3) values(列1,列2,(select 列3 from 表2));

### if函数

mysql的if函数，例如：IF(expr1,expr2,expr3) 
如果 expr1是TRUE，则IF()的返回值为expr2; 否则返回值则为expr3
实例（如果video_id为null，则直接返回空字符，避免不必要的查询影响效率）：
(SELECT if(isnull(video_id),'',(SELECT cover from topic_video tv where tv.id = video_id))) 别称,

### NOW()和CURDATE()
```sql
SELECT NOW();
//2017-08-04 17:57:59
SELECT CURDATE();
//2017-08-04
```