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