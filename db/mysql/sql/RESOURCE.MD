### 我的行程详情
#### 效果图
![](/images/db/mysql/sql/detail.png)
#### 接口数据
![](/images/db/mysql/sql/interface_data.png)
#### 表结构
![](/images/db/mysql/sql/table1.png)
在做一个复杂的业务时，可以新建一个Physical Diagram，然后把相关的表复制过来，然后把表加上外键关联，这将非常有助于理解业务数据之间的关系。  
#### sql语句
```
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
```
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
效果图如下
![](/images/db/mysql/sql/income.png)
接口
![](/images/db/mysql/sql/income_interface.png)
表结构如下
![](/images/db/mysql/sql/bus_order.png)
sql语句如下
``
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