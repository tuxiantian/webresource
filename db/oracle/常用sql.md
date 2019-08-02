日期字符串转日期
```sql
TO_DATE('2016-06-28 21:15:12', 'YYYY-MM-DD HH24:MI:SS')
```

DECODE

```sql
SELECT DECODE(T.STATE,'10I','未派发','10N','正在派单','10D','已下发','10E','异常','10F','已报竣','10W','压单','10C','已撤单','10P','缓装','10H','未生单','10M','生单中','1RC','服开退单') STATE FROM SRV_ORDER T
```

