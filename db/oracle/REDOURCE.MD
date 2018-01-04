oracle分组取最大
```sql
select *
  from (select *,
               row_number() over(partition by gid order by col2 desc) as cc
          from t2) tt2
 where tt2.cc <= 1
```
oracle DML操作和单行SELECT语句会使用隐式游标
插入操作：INSERT
更新操作：UPDATE
删除操作：DELETE
单行查询操作：SELECT ... INTO ...

游标的属性有四种，如下所示:
sql%found （布尔类型，默认值为null）
sql%notfound（布尔类型,默认值为null）
sql%rowcount(数值类型默认值为0)
sql%isopen(布尔类型)

显式游标
1声明游标
2打开游标
3提取数据
4关闭游标
```
declare
  --定义游标c_job
  cursor c_job is
    select empno, ename, job, sal from emp where job = 'MANAGER';
  --定义游标变量c_row
  c_row c_job%rowtype;
begin
  open c_job;
  loop
    --提取一行数据到c_row
    fetch c_job into c_row;
    --判读是否提取到值，没取到值就退出
    exit when c_job%notfound;
    dbms_output.put_line(c_row.empno || '-' || c_row.ename || '-' ||
                         c_row.job || '-' || c_row.sal);
  end loop;
  --关闭游标
  close c_job;
end;

带参游标
declare
  cursor emp_dept_cur(dno int) is
    select * from ol_reality_account where state = dno; --有参数的游标
begin
  for emprow in emp_dept_cur(&dno) loop
    dbms_output.put_line(emprow.source_code);
  end loop;
end;
```