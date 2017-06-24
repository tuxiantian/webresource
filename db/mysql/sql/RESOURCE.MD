### 我的行程详情
![](/images/db/mysql/sql/detail.png)
![](/images/db/mysql/sql/interface_data.png)
![](/images/db/mysql/sql/table1.png)
在做一个复杂的业务时，可以新建一个Physical Diagram，然后把相关的表复制过来，然后把表加上外键关联，这将非常有助于理解业务数据之间的关系。  
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
