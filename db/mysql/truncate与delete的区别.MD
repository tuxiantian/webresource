# truncate与delete的区别

truncate table命令将快速删除数据表中的所有记录，但保留数据表结构。这种快速删除与delete from 数据表的删除全部数据表记录不一样，delete命令删除的数据将存储在系统回滚段中，需要的时候，数据可以回滚恢复，而truncate命令删除的数据是不可以恢复的 

可以做一个测试 

建一个带有自增字段的表，加入100万数据 
然后分别用TRUNCATE和DELETE删除全部数据 
然后再向表里插入一条数据 

最直观是： 
1. TRUNCATE TABLE是非常快的 
2. TRUNCATE之后的自增字段从头开始计数了，而DELETE的仍保留原来的最大数值 

注意:这里说的delete是指不带where子句的delete语句 
相同点 
truncate和不带where子句的delete, 以及drop都会删除表内的数据 

不同点: 
1. truncate和 delete只删除数据不删除表的结构(定义) 
    drop语句将删除表的结构被依赖的约束(constrain),触发器(trigger),索引(index); 依赖于该表的存储过程/函数将保留,但是变为invalid状态. 
2. delete语句是dml,这个操作会放到rollback segement中,事务提交之后才生效;如果有相应的trigger,执行的时候将被触发. 
   truncate,drop是ddl, 操作立即生效,原数据不放到rollback segment中,不能回滚. 操作不触发trigger. 
3. delete语句不影响表所占用的extent, 高水线(high watermark)保持原位置不动 
    显然drop语句将表所占用的空间全部释放 
    truncate 语句缺省情况下见空间释放到 minextents个 extent,除非使用reuse storage;   truncate会将高水线复位(回到最开始). 
4. 速度,一般来说: drop>; truncate >; delete 
5. 安全性:小心使用drop 和truncate,尤其没有备份的时候.否则哭都来不及 
使用上,想删除部分数据行用delete,注意带上where子句. 回滚段要足够大. 
想删除表,当然用drop 
想保留表而将所有数据删除. 如果和事务无关,用truncate即可. 如果和事务有关,或者想触发trigger,还是用delete. 
如果是整理表内部的碎片,可以用truncate跟上reuse stroage,再重新导入/插入数据 

语句实例： 

```sql
truncate table wap_cms_cp_user 
```


