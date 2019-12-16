mysql格式化小数保留小数点后两位

```sql
SELECT FORMAT(12562.6655,2);
```
结果：12,562.67
查看文档：Formats the number X to a format like '#,###,###.##', rounded to D decimal places, and returns the result as a string. If D is 0, the result has no decimal point or fractional part.整数部分超过三位的时候以逗号分割，并且返回的结果是string类型的。
代码如下:
```sql
mysql> SELECT FORMAT(12332.123456, 4);
-> '12,332.1235'
mysql> SELECT FORMAT(12332.1,4);
-> '12,332.1000'
mysql> SELECT FORMAT(12332.2,0);
-> '12,332'
```
没有达到预期结果，想要的结果不要以逗号分隔，
代码如下:

```sql
select truncate(4545.1366,2);
```


结果：4545.13，直接截取不四舍五入