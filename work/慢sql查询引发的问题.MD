---
typora-root-url: ..
---

财务人员登陆系统使用保证金统计功能，由于这是一个慢sql查询，功能比较复杂，查询一次会耗时12秒左右。

![TIM截图20180804113451](/images/work/慢sql查询引发的问题/TIM截图20180804113451.png)

![TIM截图20180804105829](/images/work/慢sql查询引发的问题/TIM截图20180804105829.png)

多次查询占用了数据库连接，数据库连接耗尽，ads数据库CPU占有率飙升，App和后台系统的操作都得不到响应，看起来像是服务挂了。我当时就是就以为服务挂了，可是去ecs服务器看服务进程还在，后台服务的日志打印正常。所以一时间我也想不到是怎么回事，之前都没有遇到过。

最快的解决方式就是终止当前那些耗时较长的会话，然后CPU的压力就释放下来了。

事后，我们商量的方案是：

1. **前端增加遮罩层，在数据返回前禁止用户操作。**
2. **后端优化慢sql查询语句。**
3. **为查询语句设置超时时间**

所在，在开发的过程中一定要警惕慢sql。在这点上，阿里云服务提供了服务很友好。下面是它的慢日志明细查询：

![TIM截图20180804115416](/images/work/慢sql查询引发的问题/TIM截图20180804115416.png)

具体到这个业务上，优化前的sql是
```sql
SELECT a.date,
​       IFNULL(dp.alipay999Amount, 0) alipay999Amount,
​       IFNULL(dp.wx999Amount, 0) wx999Amount,
​       IFNULL(dp.sum999, 0) sum999,
​       IFNULL(dp.alipay2000Amount, 0) alipay2000Amount,
​       IFNULL(dp.wx2000Amount, 0) wx2000Amount,
​       IFNULL(dp.sum2000, 0) sum2000,
​       IFNULL(dp.alipayAmount, 0) alipayAmount,
​       IFNULL(dp.wxAmount, 0) wxAmount,
​       IFNULL(dp.payAmount, 0) payAmount,
​       IFNULL(db.alipay999DbAmount, 0) alipay999DbAmount,
​       IFNULL(db.wx999DbAmount, 0) wx999DbAmount,
​       IFNULL(db.sumDb999, 0) sumDb999,
​       IFNULL(db.alipay2000DbAmount, 0) alipay2000DbAmount,
​       IFNULL(db.wx2000DbAmount, 0) wx2000DbAmount,
​       IFNULL(db.sumDb2000, 0) sumDb2000,
​       IFNULL(db.alipayDbAmount, 0) alipayDbAmount,
​       IFNULL(db.wxDbAmount, 0) wxDbAmount,
​       IFNULL(db.dBAmount, 0) dBAmount,
​       IFNULL(dp2.alipayNum, 0) alipayNum,
​       IFNULL(dp2.wxNum, 0) wxNum,
​       IFNULL(dp2.changeNum, 0) changeNum,
​       IFNULL(db2.alipayDbNum, 0) alipayDbNum,
​       IFNULL(db2.wxDbNum, 0) wxDbNum,
​       IFNULL(db2.changeDbNum, 0) changeDbNum
FROM(
        SELECT ADDDATE(SUBSTR('2018-07-30 00:00:00', 1, 10), numlist.id) AS 'date'
        FROM (
            SELECT n1.i+ n10.i * 10+ n100.i * 100 AS id
            FROM num n1 CROSS JOIN num AS n10 CROSS JOIN num AS n100) AS numlist
            WHERE ADDDATE('2018-07-30 00:00:00', numlist.id)<= '2018-08-05 23:59:59'
            GROUP BY ADDDATE('2018-07-30 00:00:00', numlist.id)
    ) a
LEFT JOIN(
        SELECT DATE_FORMAT(PAYTIME, '%Y-%m-%d') payTime, 
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 999  AND PAYTYPE= 1 THEN PAYAMOUNT ELSE 0 END), 0) alipay999Amount,
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 999  AND PAYTYPE= 2 THEN PAYAMOUNT ELSE 0 END), 0) wx999Amount, 
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 999 THEN PAYAMOUNT ELSE 0 END), 0) sum999, 
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 2000  AND PAYTYPE= 1 THEN PAYAMOUNT ELSE 0 END), 0) alipay2000Amount, 
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 2000  AND PAYTYPE= 2 THEN PAYAMOUNT ELSE 0 END), 0) wx2000Amount,
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 2000 THEN PAYAMOUNT ELSE 0 END), 0) sum2000, 
        IFNULL(SUM(CASE WHEN PAYTYPE= 1 THEN PAYAMOUNT ELSE 0 END), 0) alipayAmount,
        IFNULL(SUM(CASE WHEN PAYTYPE= 2 THEN PAYAMOUNT ELSE 0 END), 0) wxAmount, 
        IFNULL(SUM(PAYAMOUNT), 0) payAmount
  FROM t_depositpay p
  LEFT JOIN t_account ac ON ac.USERID= p.USERID
 WHERE p.status= 1
   AND PAYTIME= '2018-07-30 00:00:00'
   AND PAYTIME<= '2018-08-05 23:59:59'
   AND NOT EXISTS(
        SELECT 1
        FROM t_depositpay dp
        WHERE dp.status= 3
        AND dp.TRADENO= p.TRADENO)
        GROUP BY DATE_FORMAT(PAYTIME, '%Y-%m-%d')
) dp ON a.date= dp.payTime
LEFT JOIN(
    SELECT DATE_FORMAT(ARRIVETIME, '%Y-%m-%d') arriveTime, 
    IFNULL(SUM(CASE WHEN AMOUNT= 999   AND BACKPAYTYPE= 1 THEN AMOUNT ELSE 0 END), 0) alipay999DbAmount, 
    IFNULL(SUM(CASE WHEN AMOUNT= 999   AND BACKPAYTYPE= 2 THEN AMOUNT ELSE 0 END), 0) wx999DbAmount,
    IFNULL(SUM(CASE WHEN AMOUNT= 999 THEN AMOUNT ELSE 0 END), 0) sumDb999, 
    IFNULL(SUM(CASE WHEN AMOUNT= 2000   AND BACKPAYTYPE= 1 THEN AMOUNT ELSE 0 END), 0) alipay2000DbAmount, 
    IFNULL(SUM(CASE WHEN AMOUNT= 2000   AND BACKPAYTYPE= 2 THEN AMOUNT ELSE 0 END), 0) wx2000DbAmount, 
    IFNULL(SUM(CASE WHEN AMOUNT= 2000 THEN AMOUNT ELSE 0 END), 0) sumDb2000,
    IFNULL(SUM(CASE WHEN BACKPAYTYPE= 1 THEN AMOUNT ELSE 0 END), 0) alipayDbAmount, 
    IFNULL(SUM(CASE WHEN BACKPAYTYPE= 2 THEN AMOUNT ELSE 0 END), 0) wxDbAmount,
    IFNULL(SUM(AMOUNT), 0) dBAmount
  FROM t_depositback b
  LEFT JOIN t_depositpay p ON p.DEPOSITPAYID= b.DEPOSITPAYID
  LEFT JOIN t_account ac ON ac.USERID= b.USERID
 WHERE b.BACKSTATUS= 801
   AND ARRIVETIME= '2018-07-30 00:00:00'
   AND ARRIVETIME<= '2018-08-05 23:59:59'
   AND NOT EXISTS(
        SELECT 1
        FROM t_depositpay dp
        WHERE dp.status= 3
        AND dp.TRADENO= p.TRADENO)
        GROUP BY DATE_FORMAT(ARRIVETIME, '%Y-%m-%d')
) db ON a.date= db.arriveTime
LEFT JOIN(
        SELECT DATE_FORMAT(pp.PAYTIME, '%Y-%m-%d') payTime,
        IFNULL(SUM(CASE WHEN pp.PAYTYPE= 1 THEN 1 ELSE 0 END), 0) alipayNum, 
        IFNULL(SUM(CASE WHEN p.PAYTYPE= 2 THEN 1 ELSE 0 END), 0) wxNum,
        COUNT(1) changeNum
        FROM t_depositpay p
        LEFT JOIN t_depositpay pp ON p.TRADENO= pp.TRADENO  AND pp.status= 1
        LEFT JOIN t_account ac ON ac.USERID= p.USERID
        WHERE p.status= 3
        AND pp.PAYTIME= '2018-07-30 00:00:00'
        AND pp.PAYTIME<= '2018-08-05 23:59:59'
        GROUP BY DATE_FORMAT(pp.PAYTIME, '%Y-%m-%d')
) dp2 ON a.date= dp2.payTime
LEFT JOIN(
    SELECT DATE_FORMAT(ARRIVETIME, '%Y-%m-%d') arriveTime,
    IFNULL(SUM(CASE WHEN AMOUNT= 999  AND BACKPAYTYPE= 1 THEN 1 ELSE 0 END), 0) alipayDbNum, 
    IFNULL(SUM(CASE WHEN AMOUNT= 999  AND BACKPAYTYPE= 2 THEN 1 ELSE 0 END), 0) wxDbNum, 
    IFNULL(SUM(CASE WHEN AMOUNT= 999 THEN 1 ELSE 0 END), 0) changeDbNum
  FROM t_depositback b
  LEFT JOIN t_depositpay p ON p.DEPOSITPAYID= b.DEPOSITPAYID
  LEFT JOIN t_account ac ON ac.USERID= b.USERID
 WHERE b.BACKSTATUS= 801
   AND ARRIVETIME= '2018-07-30 00:00:00'
   AND ARRIVETIME<= '2018-08-05 23:59:59'
   AND EXISTS(
        SELECT 1
        FROM t_depositpay dp
        WHERE dp.status= 3
        AND dp.TRADENO= p.TRADENO)
        GROUP BY DATE_FORMAT(ARRIVETIME, '%Y-%m-%d')
) db2 ON a.date= db2.arriveTime

```
执行成功，当前返回：[7]行，耗时：[2,674]ms.

由于保证金2000转999的统计要和直接缴纳999保证金的统计区分开，所以使用了exists语句处理，这导致执行特别耗时。通过赠加保证金类型字段（t_depositpay中的deposit_type含义是'保证金类型@  1  正常   2   2000转999'），将这两种保证金区分开，大大简化了sql，查询速度提高了2个数量级。这是一个通过增加冗余字段提高sql查询效率的典型示例。

优化后的sql如下：

```sql
SELECT a.date,
​       IFNULL(dp.alipay999Amount, 0) alipay999Amount,
​       IFNULL(dp.wx999Amount, 0) wx999Amount,
​       IFNULL(dp.sum999, 0) sum999,
​       IFNULL(dp.alipay2000Amount, 0) alipay2000Amount,
​       IFNULL(dp.wx2000Amount, 0) wx2000Amount,
​       IFNULL(dp.sum2000, 0) sum2000,
​       IFNULL(dp.alipayAmount, 0) alipayAmount,
​       IFNULL(dp.wxAmount, 0) wxAmount,
​       IFNULL(dp.payAmount, 0) payAmount,
​       IFNULL(db.alipay999DbAmount, 0) alipay999DbAmount,
​       IFNULL(db.wx999DbAmount, 0) wx999DbAmount,
​       IFNULL(db.sumDb999, 0) sumDb999,
​       IFNULL(db.alipay2000DbAmount, 0) alipay2000DbAmount,
​       IFNULL(db.wx2000DbAmount, 0) wx2000DbAmount,
​       IFNULL(db.sumDb2000, 0) sumDb2000,
​       IFNULL(db.alipayDbAmount, 0) alipayDbAmount,
​       IFNULL(db.wxDbAmount, 0) wxDbAmount,
​       IFNULL(db.dBAmount, 0) dBAmount,
​       IFNULL(dp2.alipayNum, 0) alipayNum,
​       IFNULL(dp2.wxNum, 0) wxNum,
​       IFNULL(dp2.changeNum, 0) changeNum,
​       IFNULL(db2.alipayDbNum, 0) alipayDbNum,
​       IFNULL(db2.wxDbNum, 0) wxDbNum,
​       IFNULL(db2.changeDbNum, 0) changeDbNum
  FROM(
SELECT ADDDATE(SUBSTR('2018-07-30 00:00:00', 1, 10), numlist.id) AS 'date'
  FROM(
    SELECT n1.i+ n10.i * 10+ n100.i * 100 AS id
    FROM num n1 CROSS JOIN num AS n10 CROSS JOIN num AS n100) AS numlist
    WHERE ADDDATE('2018-07-30 00:00:00', numlist.id)<= '2018-08-05 23:59:59'
    GROUP BY ADDDATE('2018-07-30 00:00:00', numlist.id)
 ) a
  LEFT JOIN(
    SELECT 
        DATE_FORMAT(PAYTIME, '%Y-%m-%d') payTime, 
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 999   AND PAYTYPE= 1 THEN PAYAMOUNT ELSE 0 END), 0) alipay999Amount,
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 999   AND PAYTYPE= 2 THEN PAYAMOUNT ELSE 0 END), 0) wx999Amount,
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 999 THEN PAYAMOUNT ELSE 0 END), 0) sum999, 
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 2000   AND PAYTYPE= 1 THEN PAYAMOUNT ELSE 0 END), 0) alipay2000Amount, 
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 2000   AND PAYTYPE= 2 THEN PAYAMOUNT ELSE 0 END), 0) wx2000Amount, 
        IFNULL(SUM(CASE WHEN PAYAMOUNT= 2000 THEN PAYAMOUNT ELSE 0 END), 0) sum2000, 
        IFNULL(SUM(CASE WHEN PAYTYPE= 1 THEN PAYAMOUNT ELSE 0 END), 0) alipayAmount,
        IFNULL(SUM(CASE WHEN PAYTYPE= 2 THEN PAYAMOUNT ELSE 0 END), 0) wxAmount, 
        IFNULL(SUM(PAYAMOUNT), 0) payAmount
  FROM t_depositpay p
  LEFT JOIN t_account ac ON ac.USERID= p.USERID
    WHERE p.status= 1
        AND PAYTIME= '2018-07-30 00:00:00'
        AND PAYTIME<= '2018-08-05 23:59:59'
        AND p.deposit_type= 1
 GROUP BY DATE_FORMAT(PAYTIME, '%Y-%m-%d')) dp ON a.date= dp.payTime
  LEFT JOIN(
    SELECT DATE_FORMAT(ARRIVETIME, '%Y-%m-%d') arriveTime, 
    IFNULL(SUM(CASE WHEN AMOUNT= 999   AND BACKPAYTYPE= 1 THEN AMOUNT ELSE 0 END), 0) alipay999DbAmount, 
   IFNULL(SUM(CASE WHEN AMOUNT= 999   AND BACKPAYTYPE= 2 THEN AMOUNT ELSE 0 END), 0) wx999DbAmount, 
   IFNULL(SUM(CASE WHEN AMOUNT= 999 THEN AMOUNT ELSE 0 END), 0) sumDb999,
    IFNULL(SUM(CASE WHEN AMOUNT= 2000   AND BACKPAYTYPE= 1 THEN AMOUNT ELSE 0 END), 0) alipay2000DbAmount,
    IFNULL(SUM(CASE WHEN AMOUNT= 2000   AND BACKPAYTYPE= 2 THEN AMOUNT ELSE 0 END), 0) wx2000DbAmount, 
   IFNULL(SUM(CASE WHEN AMOUNT= 2000 THEN AMOUNT ELSE 0 END), 0) sumDb2000, 
   IFNULL(SUM(CASE WHEN BACKPAYTYPE= 1 THEN AMOUNT ELSE 0 END), 0) alipayDbAmount,
    IFNULL(SUM(CASE WHEN BACKPAYTYPE= 2 THEN AMOUNT ELSE 0 END), 0) wxDbAmount, 
    IFNULL(SUM(AMOUNT), 0) dBAmount
  FROM t_depositback b
  LEFT JOIN t_depositpay p ON p.DEPOSITPAYID= b.DEPOSITPAYID
  LEFT JOIN t_account ac ON ac.USERID= b.USERID
 WHERE b.BACKSTATUS= 801
        AND ARRIVETIME= '2018-07-30 00:00:00'
        AND ARRIVETIME<= '2018-08-05 23:59:59'
        AND p.deposit_type= 1
 GROUP BY DATE_FORMAT(ARRIVETIME, '%Y-%m-%d')) db ON a.date= db.arriveTime
  LEFT JOIN(
        SELECT DATE_FORMAT(pp.PAYTIME, '%Y-%m-%d') payTime, 
            IFNULL(SUM(CASE WHEN pp.PAYTYPE= 1 THEN 1 ELSE 0 END), 0) alipayNum,
            IFNULL(SUM(CASE WHENpp.PAYTYPE= 2 THEN 1 ELSE 0 END), 0) wxNum,
            COUNT(1) changeNum
  FROM t_depositpay pp
  LEFT JOIN t_account ac ON ac.USERID= pp.USERID
 WHERE pp.status= 1
        AND pp.PAYTIME= '2018-07-30 00:00:00'
        AND pp.PAYTIME<= '2018-08-05 23:59:59'
        AND pp.deposit_type= 2
 GROUP BY DATE_FORMAT(pp.PAYTIME, '%Y-%m-%d')) dp2 ON a.date= dp2.payTime
  LEFT JOIN(
    SELECT DATE_FORMAT(ARRIVETIME, '%Y-%m-%d') arriveTime, 
    IFNULL(SUM(CASE WHEN AMOUNT= 999    AND BACKPAYTYPE= 1 THEN 1 ELSE 0 END), 0) alipayDbNum,
     IFNULL(SUM(CASE WHEN AMOUNT= 999    AND BACKPAYTYPE= 2 THEN 1 ELSE 0 END), 0) wxDbNum,
      IFNULL(SUM(CASE WHEN AMOUNT= 999 THEN 1 ELSE 0 END), 0) changeDbNum    
      FROM t_depositback b
    LEFT JOIN t_depositpay p ON p.DEPOSITPAYID= b.DEPOSITPAYID
    LEFT JOIN t_account ac ON ac.USERID= b.USERID
    WHERE b.BACKSTATUS= 801
            AND ARRIVETIME= '2018-07-30 00:00:00'
            AND ARRIVETIME<= '2018-08-05 23:59:59'
            AND p.deposit_type= 2
    GROUP BY DATE_FORMAT(ARRIVETIME, '%Y-%m-%d')
 ) db2 ON a.date= db2.arriveTime
```
执行成功，当前返回：[7]行，耗时：[32]ms.

**Mybatis设置sql超时时间**

java中,如果不指定,默认超时时间是不做限制的,默认值为0.

由于我们的项目采用Mybatis进行数据库操作,经过查看Mybaits相关文档,配置sql超时时间有两种方法

**1 全局配置**
在mybatis配置文件的settings节点中,增加如下配置
```xml
<settings>
  <setting name="defaultStatementTimeout" value="25"/>
</settings>
```
这是以秒为单位的全局sql超时时间设置,当超出了设置的超时时间时,会抛出SQLTimeoutException

**2 Mapper XML配置**
还有一种方法是在mapper xml文件中对具体一个sql进行设置,方法为在select/update/insert节点中配置timeout属性,依然是以秒为单位表示超时时间并只作用于这一个sql.
```xml
<insert
  id="insertAuthor"
  parameterType="domain.blog.Author"
  flushCache="true"
  statementType="PREPARED"
  keyProperty=""
  keyColumn=""
  useGeneratedKeys=""
  timeout="20">
```
**3 实践中的示例**
```xml
<select id="statistics" resultType="com.laijia.biz.report.entity.AllModule" timeout="10">
  ......
</select>

<select id="statisticsCount" resultType="com.laijia.biz.report.entity.AllModule" timeout="10">
  ......
</select>
```

```java
/**
  * 管控运营数据统计
  * 总部使用
  *
  * @param startDate
  * @param endDate
  * @return
  */
public McpResult statistics(String startDate, String endDate,String areaCode) {
    List<AllModule> data = null;
    try {
        CompletableFuture<List<AllModule>> completableFuture1 = CompletableFuture.supplyAsync(() -> 
        this.mapper.statistics(startDate, endDate, areaCode));
        CompletableFuture<AllModule> completableFuture2 = CompletableFuture.supplyAsync(() -> 
        this.mapper.statisticsCount(startDate, endDate, areaCode));
        data = completableFuture1.join();
        AllModule allModule = completableFuture2.join();
        data.add(allModule);
        data.parallelStream().forEach(module -> {
            if (module.getCarNum() != 0) {
                module.setAvgCarOrderCount(new BigDecimal(module.getOrderCount()).divide(new BigDecimal(module.getCarNum()), 2, RoundingMode.HALF_UP).toPlainString());
            }
            if (module.getOrderCount() != 0) {
                module.setAvgOrderAmount(new BigDecimal(module.getOrderAmount().replaceAll(",", "")).
                divide(new BigDecimal(module.getOrderCount()), 2, RoundingMode.HALF_UP).toPlainString());
            }
            if (module.getCarNum() != 0) {
                module.setAvgCarOrderAmount(new BigDecimal(module.getOrderAmount().replaceAll(",", "")).
                divide(new BigDecimal(module.getCarNum()), 2, RoundingMode.HALF_UP).toPlainString());
                module.setAvgOrderMileage(new BigDecimal((float) module.getOrderSumMileage() / module.getCarNum()).setScale(2, BigDecimal.ROUND_HALF_UP).toPlainString());
            }
            if (module.getOrderSumTime() != 0) {
                module.setAvgOrderTime(new BigDecimal((float) module.getOrderSumTime() / module.getOrderCount()).setScale(2, BigDecimal.ROUND_HALF_UP).toPlainString());
            }
        });
    } catch (CompletionException e) {
        logger.error("", e);
        if (e.getMessage().contains("org.springframework.dao.QueryTimeoutException")) {
            return McpResult.fail("查询超时");
        }
    }
    return McpResult.success("查询成功", data);
}
```
