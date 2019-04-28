## 分页

```sql
SELECT *
  FROM (SELECT A.*, ROWNUM AS NUM_
          FROM (
              
              ) A WHERE ROWNUM <= #{end} 
       )
	WHERE NUM_ >= #{first} 
```



## oracle分组取最大

```sql
select *
  from (select *,
               row_number() over(partition by gid order by col2 desc) as cc
          from t2) tt2
 where tt2.cc <= 1
```
## 查看数据库中的空表

```sql
select table_name, num_rows

  from user_tables

  where instr(table_name,'OL_GZT_LOG')>0

  num_rows=‘0’;
```



## 查询过去20分钟的数据

create_date是date类型，1/24表示一小时，1/24/3表示20分钟

```sql
select t.*,t.rowid from OL_WCARD_INFO_REL t where create_date>sysdate-1/24/3;--写卡信息表
```



## 一条insert语句完成批量插入

```sql
insert all into bs_static_data(code_type,code_value,code_name,code_desc,state)values('app_city_code','石家庄市','0311','311','1') 

into bs_static_data(code_type,code_value,code_name,code_desc,state)values('app_city_code','唐山市','0315','311','1') select 1 from dual;
```



## 添加唯一性索引

```sql
alter table ol_campus_sim add constraint 索引名 unique(字段名);
```
## bs_static_data查询表序列值
```sql
select seq_static_data_id.nextval from dual
```

# 经验

统计状态为0的且数量小于预设数量的sim卡号的省份。
```sql
select t.prov_code,count(1) as count from OL_IMSI_INFO t  where t.state=0 group by t.prov_code having count(1)<6
```
当某个省状态为0的数量为0时，此时的sql是统计不到的。要用下面的sql统计会更加严谨。
```sql
select prov_code from 

(select prov_code from OL_IMSI_INFO t where t.prov_code

 not in (select prov_code from OL_IMSI_INFO t where t.state='0' group by prov_code)  group by prov_code 

 union all

select prov_code from OL_IMSI_INFO t where   t.state='0' group by prov_code having count(1)<6);
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
```sql
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

