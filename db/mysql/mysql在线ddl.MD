# mysql在线ddl

mysql在线ddl(加字段、加索引等修改表结构之类的操作）过程如下：

A.对表加锁(表此时只读)
B.复制原表物理结构
C.修改表的物理结构
D.把原表数据导入中间表中，数据同步完后，锁定中间表，并删除原表
E.rename中间表为原表
F.刷新数据字典，并释放锁
项目会因为不断的引入新的业务而必须增加和修改字段。最近的业务要加13个字段。
实名制的人工审核数据库有8个G的数据，有31*5*13（省份数*月份数*添加字段个数）
不要使用下面的增加字段的语句
	alter table 表名 add column 字段1 字段1的类型 comment '字段1的注记信息';
	alter table 表名 add column 字段2 字段2的类型 comment '字段2的注记信息';
较快的语句
	alter table 表名 add column 字段1 字段1的类型 comment '字段1的注记信息',add column 字段2 字段2的类型 comment '字段2的注记信息';
原理就是一次将表结构修改完成。

## MySQL 为生产环境在线添加字段  
```sql
#使用like关键字创建表，不用再为新表单独创建索引
create table new_table_name like old_table_name;  
alter table new_table_name add column new_column int not null default 0 comment 'your comment';  
alter table t_user_2 add name2 varchar(15),add name3 varchar(4);  
alter table t_user_2 drop name2, drop name3;  

insert into new_table_name (col1, col2, col3...) select (col1, col2, col3...) from old_table_name where id < xxxx;  

begin;  
insert into new_table_name (col1, col2, col3...) select (col1, col2, col3...) from old_table_name where id >= xxxx  
rename old_table_name to old_table_bak, new_table_name to old_table_name;  
commit;  
```