---
typora-root-url: ..\..\..
---

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
    - [你真的会用EXISTS吗](#你真的会用exists吗)
        - [查询不限制购买次数的次卡或购买次数小于限定次数的次卡](#查询不限制购买次数的次卡或购买次数小于限定次数的次卡)
        - [查询当前时段的热区](#查询当前时段的热区)
- [使用优化的分页查询语句](#使用优化的分页查询语句)
- [EXISTS关键字的一个使用示例](#exists关键字的一个使用示例)
- [左关联的使用误区](#左关联的使用误区)
    - [示例1](#示例1)
    - [示例2](#示例2)
- [查找满足所有规则的活动](#查找满足所有规则的活动)
- [同步消息推送配置步骤](#同步消息推送配置步骤)
- [行变列例子](#行变列例子)
    - [解决方法一](#解决方法一)
    - [解决方法二](#解决方法二)
- [查询不在热区的车辆](#查询不在热区的车辆)
- [待下发任务统计](#待下发任务统计)
- [班次任务统计](#班次任务统计)
- [历史任务统计](#历史任务统计)

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
#### 你真的会用EXISTS吗
##### 查询不限制购买次数的次卡或购买次数小于限定次数的次卡
```sql
SELECT t.card_id,
       t.areacode,
       (SELECT a.areaName  FROM t_area a WHERE a.AREACODE= t.AREACODE) AS areaName,
       t.card_name,
       t.price,
       t.use_time,
       t.card_num,
       t.card_amount,
       t.valid_unit,
       t.valid_num,
       t.create_time,
       t.remark,
       t.limit_buy_num,
       t.buy_start_time,
       t.buy_end_time,
       t.status
  FROM t_card t
 WHERE 1= 1
   AND t.areacode= '370724'
   AND t.status= 1
   AND ( EXISTS (
                SELECT COUNT(1) buyCount
                FROM t_account_paycard ap
                WHERE ap.card_id= t.card_id
                AND ap.status= 1
                AND ap.`userid`= '746b2506d64adfcce8ee9ffc510bb529'
                GROUP BY ap.userid, ap.card_id
                HAVING buyCount<= t.limit_buy_num
                )
            OR t.limit_buy_num= 0
        )
 ORDER BY t.card_id ASC;

```
上面的查询语句，若用户尚未购买次卡，则查询不到可以购买的次卡。下面的sql则可以满足需求。
```sql
SELECT t.card_id,
       t.areacode,
       (
       SELECT a.areaName  FROM t_area a WHERE a.AREACODE= t.AREACODE) AS areaName,
       t.card_name,
       t.price,
       t.use_time,
       t.card_num,
       t.card_amount,
       t.valid_unit,
       t.valid_num,
       t.create_time,
       t.remark,
       t.limit_buy_num,
       t.buy_start_time,
       t.buy_end_time,
       t.status
  FROM t_card t
 WHERE 1= 1
   AND t.areacode= '370724'
   AND t.status= 1
   AND (NOT EXISTS (
       SELECT COUNT(1) buyCount FROM t_account_paycard ap 
       WHERE ap.card_id=t.card_id AND ap.status=1 AND ap.`userid`='0c496a01770e2c9b71c781f990c66894'
            GROUP BY ap.card_id HAVING  buyCount >= t.limit_buy_num)
            OR t.limit_buy_num=0)
 ORDER BY t.card_id ASC;
```
或者也可以使用下面的写法
```sql
SELECT t.card_id,
       t.areacode,
       (
SELECT a.areaName
  FROM t_area a
 WHERE a.AREACODE= t.AREACODE) AS areaName,
       t.card_name,
       t.price,
       t.use_time,
       t.card_num,
       t.card_amount,
       t.valid_unit,
       t.valid_num,
       t.create_time,
       t.remark,
       t.limit_buy_num,
       t.buy_start_time,
       t.buy_end_time,
       t.status
  FROM t_card t
left outer join (SELECT ap.card_id,COUNT(1) buyCount
  FROM t_account_paycard ap
 WHERE  ap.status= 1
   AND ap.`userid`= '746b2506d64adfcce8ee9ffc510bb529'
 GROUP BY  ap.card_id) b on t.`card_id` =b.card_id
 WHERE 1= 1
   AND t.areacode= '370724'
   AND t.status= 1
   AND (ifnull(b.buyCount,0) < t.`limit_buy_num` 
    OR t.limit_buy_num= 0)
 ORDER BY t.card_id ASC;

```
##### 查询当前时段的热区
错误的查询语句如下
```sql
SELECT
t.hot_area_id hotAreaId,
t.area_code areaCode,
t.hot_area_name hotAreaName,
t.remark,
date_format(t.create_time, '%Y-%m-%d %H:%i:%s') createTime,
t.create_user createUser,
b.hot_area_border hotAreaBorder,
(SELECT count(1) from t_car_ext e WHERE e.hot_area_id=t.hot_area_id) currCarCount,
ifnull(i.car_count,0) carCount
FROM t_hot_area t
LEFT join t_hot_border b on b.hot_area_id=t.hot_area_id
left JOIN t_hot_area_inte i ON i.hot_area_id=t.hot_area_id
WHERE 1=1
<if test="areaCode != null">
    AND t.area_code=#{areaCode}
</if>
<if test="currHaid != null and currHaid">
    AND EXISTS (SELECT 1 FROM t_hot_area_inte i WHERE i.hot_area_id=t.hot_area_id 
    AND i.start_time <![CDATA[<=]]> DATE_FORMAT(now(),'%H:%i') 
    AND i.end_time <![CDATA[>=]]> DATE_FORMAT(now(),'%H:%i')
    )
</if>
```
当currHaid为true时并未过滤出当前时段的热区，而是查询出多条相同的热区。
```sql
SELECT
t.hot_area_id hotAreaId,
t.area_code areaCode,
t.hot_area_name hotAreaName,
t.remark,
date_format(t.create_time, '%Y-%m-%d %H:%i:%s') createTime,
t.create_user createUser,
b.hot_area_border hotAreaBorder,
(SELECT count(1) from t_car_ext e WHERE e.hot_area_id=t.hot_area_id) currCarCount,
ifnull(i.car_count,0) carCount
FROM t_hot_area t
LEFT join t_hot_border b on b.hot_area_id=t.hot_area_id
INNER JOIN (SELECT hot_area_id,car_count FROM t_hot_area_inte WHERE start_time <![CDATA[<=]]> DATE_FORMAT(now(),'%H:%i') AND end_time <![CDATA[>=]]> DATE_FORMAT(now(),'%H:%i')) i ON i.hot_area_id=t.hot_area_id
WHERE 1=1
<if test="areaCode != null">
    AND t.area_code=#{areaCode}
</if>
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
#### 示例1
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
#### 示例2
查询已用车的会员,一个会员会多次用车，会查出多条记录
```
<select id="findHaveUsedCarAccount" resultType="mb">
    SELECT T.USERID userId,T.MOBILE mobile FROM T_ACCOUNT T
    LEFT JOIN t_orders O ON T.USERID=O.USERID
    WHERE O.STATUS=699
    <if test="areaCode != null and areaCode != ''">
        AND T.REGCITY=#{areaCode}
    </if>
</select>
```
正确的写法
```
SELECT T.USERID userId,T.MOBILE mobile FROM T_ACCOUNT T
LEFT JOIN (SELECT USERID FROM t_orders WHERE STATUS=699 GROUP BY userId)O ON T.USERID=O.USERID;
或者下面这样，推荐下面的写法         
SELECT * FROM t_account t WHERE EXISTS (SELECT 1 FROM t_orders o WHERE o.`USERID`=t.`USERID` AND o.`STATUS`=699);
```

### 查找满足所有规则的活动

```sql
<select id="find" resultMap="entityMap">
    SELECT * from FROM t_activity t
        WHERE 1=1
    <if test="activityId != null">
        AND t.activity_id=#{activityId}
    </if>
    <if test="isUse">
        AND t.status != 3 and t.begin_time <![CDATA[ <= ]]> now() and t.end_time <![CDATA[ >= ]]> now()
    </if>
    <if test="rules!=null">
        <foreach item="item" index="index" collection="rules" open="" separator="" close="">
            AND EXISTS
            (SELECT
            activity_id
            FROM
            t_activity_rule r
            WHERE 1=1
            AND r.rule_code =#{item} AND r.`activity_id`=t.`activity_id`
            )
        </foreach>
    </if>
</select>
```
### 同步消息推送配置步骤
1. 将测试环境t_messageconfig表结构和数据导出
2. 将开发环境t_messageconfig表结构和数据导出
3. 重命名开发环境导出数据的表名为t_messageconfig1
4. 分别将两份数据导入到本地环境
5. 更新本地的t_messageconfig
```sql
UPDATE t_messageconfig o  SET `CONTENTTEMP`=(SELECT CONTENTTEMP FROM t_messageconfig1 n WHERE n.`BUSSTYPE`=o.BUSSTYPE)
```
6. 将新增的消息配置插入到t_messageconfig
```sql
insert into t_messageconfig
select 
  * 
from
  t_messageconfig1 t 
where t.`BUSSTYPE` not in 
  (select 
    n.BUSSTYPE 
  from
    t_messageconfig o
   left join t_messageconfig1 n  on 
   o.`BUSSTYPE` = n.`BUSSTYPE`) ;
```
### 行变列例子
```sql
USE csdn;  
DROP TABLE IF EXISTS csdn.tb;  
CREATE TABLE tb(`cname` VARCHAR(10),cource VARCHAR(10),score INT) ENGINE=INNODB;  
  
INSERT INTO tb VALUES('张三','语文',74);  
INSERT INTO tb VALUES('张三','数学',83);  
INSERT INTO tb VALUES('张三','物理',93);  
INSERT INTO tb VALUES('李四','语文',74);  
INSERT INTO tb VALUES('李四','数学',84);  
INSERT INTO tb VALUES('李四','物理',94);  
  
SELECT * FROM tb;  
```
需要得到的结果是：
| 姓名     | 语文    | 数学    | 物理    | 总成绩    | 平均成绩  |
| ------ | ----- | ----- | ----- | ------ | ----- |
| 张三     | 74.00 | 83.00 | 93.00 | 250.00 | 83.33 |
| 李四     | 74.00 | 84.00 | 94.00 | 252.00 | 84.00 |
| 总成绩平均数 | 74.00 | 83.50 | 93.50 | 251.00 | 83.67 |
#### 解决方法一
```sql
SELECT cname AS "姓名",  
    SUM(IF(cource="语文",score,0)) AS "语文",  
    SUM(IF(cource="数学",score,0)) AS "数学",  
    SUM(IF(cource="物理",score,0)) AS "物理",  
    SUM(score) AS "总成绩",  
    ROUND(AVG(score),2) AS "平均成绩"  
FROM tb   
GROUP BY cname  
UNION ALL  
SELECT  
    "总成绩平均数",  
    ROUND(AVG(`语文`),2) , ROUND(AVG(`数学`),2), ROUND(AVG(`物理`),2), ROUND(AVG(`总成绩`),2), ROUND(AVG(`平均成绩`),2)  
FROM(  
    SELECT "all",cname AS "姓名",  
        SUM(IF(cource="语文",score,0)) AS "语文",  
        SUM(IF(cource="数学",score,0)) AS "数学",  
        SUM(IF(cource="物理",score,0)) AS "物理",  
        SUM(score) AS "总成绩",  
        AVG(score) AS "平均成绩"  
    FROM tb   
    GROUP BY cname  
)tb2   
GROUP BY tb2.all;  
```
#### 解决方法二
```sql
SELECT   
    cname AS "姓名",  
    MAX(CASE cource WHEN "语文" THEN score ELSE 0 END) AS "语文",   
    MAX(CASE cource WHEN "数学" THEN score ELSE 0 END) AS "数学",   
    MAX(CASE cource WHEN "物理" THEN score ELSE 0 END) AS "物理",   
    SUM(score) AS "总成绩",  
    ROUND(AVG(score) ,2) AS "平均成绩"  
FROM tb   
GROUP BY `cname`  
UNION ALL  
SELECT  
    "总成绩平均数",  
    ROUND(AVG(`语文`),2) , ROUND(AVG(`数学`),2), ROUND(AVG(`物理`),2), ROUND(AVG(`总成绩`),2), ROUND(AVG(`平均成绩`),2)  
FROM(   SELECT 'all' ,    
        cname AS "姓名",  
        MAX(CASE cource WHEN "语文" THEN score ELSE 0 END) AS "语文",   
        MAX(CASE cource WHEN "数学" THEN score ELSE 0 END) AS "数学",   
        MAX(CASE cource WHEN "物理" THEN score ELSE 0 END) AS "物理",   
        SUM(score) AS "总成绩",  
        ROUND(AVG(score) ,2) AS "平均成绩"  
    FROM tb   
    GROUP BY `cname`   
)tb2 GROUP BY tb2.all  

```
### 查询不在热区的车辆
查询当前不在热区的车辆信息保存到日报表中
```sql
SELECT 
  c.AREACODE areaCode,
  c.CARID carId,
  c.LPN lpn,
  e.last_location lastCarLocation,
  e.last_charge_time lastStartChargeTime,
  CURDATE() rbDate,
  ti.create_time taskCreateTime,
  ti.send_time taskSendTime,
  ti.sender sendUser,
  (SELECT 
    z.`zone_name` 
  FROM
    t_zone z 
  WHERE z.`zone_id` = e.zone_id) zoneName,
  (SELECT 
    o.ENDTIME 
  FROM
    t_orders o 
  WHERE o.`CARID` = c.carid 
  ORDER BY o.ENDTIME DESC 
  LIMIT 1) lastBackTime 
FROM
  t_cars c 
  INNER JOIN t_car_ext e 
    ON c.carid = e.carid 
    AND e.hot_area_id = 0 
  LEFT JOIN 
    (SELECT 
      t.car_id,
      create_time,
      send_time,
      sender 
    FROM
      t_task_info t 
    WHERE t.`task_type` = 3 
    ORDER BY t.create_time DESC 
    LIMIT 1) ti 
    ON ti.car_id = c.carid 

```
通过减少关联查询t_task_info表记录的数量和使用分组取最大值的方式避免排序，提高查询性能，优化后的sql如下
```sql
<select id="findNoInHotArea" resultType="com.laijia.biz.operation.entity.RbNoHotArea">
    SELECT 
  c.AREACODE areaCode,
  c.CARID carId,
  c.LPN lpn,
  e.last_location lastCarLocation,
  e.last_charge_time lastStartChargeTime,
  CURDATE() rbDate,
  tti.create_time taskCreateTime,
  tti.send_time taskSendTime,
  tti.sender sendUser,
  (SELECT 
    z.`zone_name` 
  FROM
    t_zone z 
  WHERE z.`zone_id` = e.zone_id) zoneName,
  (SELECT 
    o.ENDTIME 
  FROM
    t_orders o 
  WHERE o.`CARID` = c.carid 
  ORDER BY o.ENDTIME DESC 
  LIMIT 1) lastBackTime 
FROM
  t_cars c 
  INNER JOIN t_car_ext e 
    ON c.carid = e.carid 
    AND e.hot_area_id = 0 
  LEFT OUTER JOIN 
    (SELECT 
      t.car_id,
      MAX(t.task_id) task_id 
    FROM
      t_task_info t 
    WHERE t.create_time > DATE_SUB(NOW(), INTERVAL 3 DAY) 
      AND t.`task_type` = 3 
    GROUP BY t.car_id) ti 
    ON ti.car_id = c.carid 
  LEFT OUTER JOIN t_task_info tti 
    ON ti.task_id = tti.task_id 
</select>
```

### 待下发任务统计
![](/images/db/mysql/sql/to_process.png)
```sql
<select id="toProcessTaskCount" resultType="com.laijia.biz.operation.entity.TaskCount">
select ifnull(MAX((case u.task_type when 1 then u.num else 0 end)),0) 'maintain',
IFNULL(MAX((case u.task_type when 2 then u.num else 0 end)),0) 'wash',
IFNULL(MAX((case u.task_type when 3 then u.num else 0 end)),0) 'dispatch',
IFNULL(MAX((case u.task_type when 4 then u.num else 0 end)),0) 'charge',
IFNULL(MAX((case u.task_type when 5 then u.num else 0 end)),0) 'accident'
    from
    (SELECT t.task_type,COUNT(1) num FROM `t_task_info` t WHERE t.area_code=#{areaCode}  AND t.status=1 group by t.task_type) u
</select>
```
### 班次任务统计
![](/images/db/mysql/sql/shift_statics.png)
```sql
<select id="findShiftStatistics" resultType="mb">
SELECT z.zone_name zoneName,mu.name,
ifnull(bat.autoViewCount,0) autoViewCount,
ifnull(bat.autoDispatchCount,0) autoDispatchCount,
ifnull(ti.disFinishCount,0) disFinishCount,
ifnull(ti.disSendCount,0) disSendCount,
ifnull(bat.autoChargeCount,0) autoChargeCount,
ifnull(ti.chargeFinishCount,0) chargeFinishCount,
ifnull(ti.chargeSendCount,0) chargeSendCount,
ifnull(ti.mainFinishCount,0) mainFinishCount,
ifnull(ti.mainFinishingCount,0) mainFinishingCount,
ifnull(ti.mainSendCount,0) mainSendCount,
ifnull(ti.accFinishCount,0) accFinishCount,
ifnull(ti.accFinishingCount,0) accFinishingCount,
ifnull(ti.accSendCount,0) accSendCount
FROM t_arrange a
INNER JOIN t_zone z ON a.zone_id=z.zone_id
INNER JOIN t_main_user mu ON a.user_id=mu.user_id
LEFT OUTER JOIN(SELECT tat.reporter_id,
        SUM(case tat.task_type WHEN 1 THEN 1 ELSE 0 END) autoViewCount,
        SUM(case tat.task_type WHEN 3 THEN 1 ELSE 0 END) autoDispatchCount,
        SUM(case tat.task_type WHEN 4 THEN 1 ELSE 0 END) autoChargeCount
FROM t_auto_task tat  WHERE  tat.finish_time <![CDATA[>=]]> #{startDate} AND tat.finish_time <![CDATA[<]]>  #{endDate} GROUP BY tat.reporter_id) bat ON a.user_id=bat.reporter_id
LEFT OUTER JOIN(SELECT tti.rece_id,
    SUM(case tti.task_type WHEN 3 THEN 1 ELSE 0 end) disSendCount,
    SUM(case  WHEN tti.task_type=3 AND tti.status=9 THEN 1 ELSE 0 end) disFinishCount,
    SUM(case tti.task_type WHEN 4 THEN 1 ELSE 0 end) chargeSendCount,
    SUM(case  WHEN tti.task_type=4 AND tti.status=9 THEN 1 ELSE 0 end) chargeFinishCount,
    SUM(case  WHEN tti.task_type=1 AND tti.status=9 THEN 1 ELSE 0 end) mainFinishCount,
    SUM(case  WHEN tti.task_type=1 AND tti.status=3 THEN 1 ELSE 0 end) mainFinishingCount,
    SUM(case  WHEN tti.task_type=1 THEN 1 ELSE 0 end) mainSendCount,
    SUM(case  WHEN tti.task_type=5 AND tti.status=9 THEN 1 ELSE 0 end) accFinishCount,
    SUM(case  WHEN tti.task_type=5 AND tti.status=3 THEN 1 ELSE 0 end) accFinishingCount,
    SUM(case  WHEN tti.task_type=5 THEN 1 ELSE 0 end) accSendCount
FROM t_task_info tti   WHERE tti.status>1 and tti.send_time <![CDATA[>=]]> #{startDate} AND tti.send_time <![CDATA[<]]> #{endDate} GROUP BY tti.rece_id) ti ON a.user_id=ti.rece_id
WHERE a.status=1  AND a.area_code=#{areaCode}
<if test="shiftId !=null">
    and a.shift_id=#{shiftId}
</if>
</select>
```
### 历史任务统计
![](/images/db/mysql/sql/history_task_statics.png)
```sql
<select id="findHistoryStatistics" resultType="mb">
    select userId ,zone_name zoneName,name,ifnull(sum(autoViewCount),0) autoViewCount,ifnull(sum(autoDispatchCount),0) autoDispatchCount
    ,ifnull(sum(disFinishCount),0) disFinishCount,ifnull(sum(disSendCount),0) disSendCount,
    ifnull(sum(autoChargeCount),0) autoChargeCount,
    ifnull(sum(chargeFinishCount),0) chargeFinishCount,ifnull(sum(chargeSendCount),0) chargeSendCount,
    ifnull(sum(mainFinishCount),0) mainFinishCount,ifnull(sum(mainFinishingCount),0) mainFinishingCount,
    ifnull(sum(mainSendCount),0) mainSendCount,ifnull(sum(accFinishCount),0) accFinishCount,
    ifnull(sum(accFinishingCount),0) accFinishingCount,ifnull(sum(accSendCount),0) accSendCount
    from (
        select tat.reporter_id userId,z.zone_name,mu.name,
        (case tat.task_type WHEN 1 THEN 1 ELSE 0 END) autoViewCount,
        (case tat.task_type WHEN 3 THEN 1 ELSE 0 END) autoDispatchCount,
        0 disFinishCount,
        0 disSendCount,
        (case tat.task_type WHEN 4 THEN 1 ELSE 0 END) autoChargeCount ,
        0 chargeFinishCount,
        0 chargeSendCount,
        0 mainFinishCount,
        0 mainFinishingCount,
        0 mainSendCount,
        0 accFinishCount,
        0 accFinishingCount,
        0 accSendCount
        FROM t_auto_task tat
        INNER JOIN t_zone z ON tat.zone_id=z.zone_id
        INNER JOIN t_main_user mu ON tat.reporter_id=mu.user_id
        WHERE  1=1
        <if test="startDate !=null and startDate !=''">AND tat.finish_time <![CDATA[>=]]> #{startDate}</if>
        <if test="endDate !=null and endDate !=''">AND tat.finish_time <![CDATA[<]]> #{endDate} </if>
        AND tat.area_code=#{areaCode}
    union all
        SELECT tti.rece_id userId,z.zone_name,mu.name,
        0 autoViewCount,
        0 autoDispatchCount,
        (case  WHEN tti.task_type=3 AND tti.status=9 THEN 1 ELSE 0 end) disFinishCount,
        (CASE tti.task_type WHEN 3 THEN 1 ELSE 0 END) disSendCount,
        0 autoChargeCount ,
        (CASE  WHEN tti.task_type=4 AND tti.status=9 THEN 1 ELSE 0 END) chargeFinishCount,
        (case tti.task_type WHEN 4 THEN 1 ELSE 0 end) chargeSendCount,
        (case  WHEN tti.task_type=1 AND tti.status=9 THEN 1 ELSE 0 end) mainFinishCount,
        (case  WHEN tti.task_type=1 AND tti.status=3 THEN 1 ELSE 0 end) mainFinishingCount,
        (case  WHEN tti.task_type=1 THEN 1 ELSE 0 end) mainSendCount,
        (CASE  WHEN tti.task_type=5 AND tti.status=9 THEN 1 ELSE 0 END) accFinishCount,
        (case  WHEN tti.task_type=5 AND tti.status=3 THEN 1 ELSE 0 end) accFinishingCount,
        (case  WHEN tti.task_type=5 THEN 1 ELSE 0 end) accSendCount
        FROM t_task_info tti
        INNER JOIN t_zone z ON tti.zone_id=z.zone_id
        INNER JOIN t_main_user mu ON tti.rece_id=mu.user_id
        WHERE tti.status>1
        <if test="startDate !=null and startDate !=''">
            AND tti.send_time <![CDATA[>=]]> #{startDate}
        </if>
        <if test="endDate !=null and endDate !=''">
            AND tti.send_time <![CDATA[<]]> #{endDate}
        </if>
        AND tti.area_code=#{areaCode}
    ) t
    group by zone_name,userId
</select>
```