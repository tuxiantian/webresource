redo log 刷盘策略由 innodb_flush_log_at_trx_commit 参数控制:
0:每秒刷新一次
1：每次commit刷新一次(默认值,MySQL5.6)
2：每次commit都 write os cache，然后根据 innodb_flush_log_at_timeout 参数（默认为1s） flush disk

ib_logfile0 and ib_logfile1两个文件,就是redo log（用于 崩溃时恢复）

二进制日志会记录所有与mysql有关的日志记录(bin log)
--------------------------------------------------------------------------------------
MySQL 为生产环境在线添加字段
create table new_table_name like old_table_name;
alter table new_table_name add column new_column int not null default 0 comment 'your comment';

insert into new_table_name (col1, col2, col3...) select (col1, col2, col3...) from old_table_name where id < xxxx;

begin;
insert into new_table_name (col1, col2, col3...) select (col1, col2, col3...) from old_table_name where id >= xxxx
rename old_table_name to old_table_bak, new_table_name to old_table_name;
commit;

--------------------------------------------------------------------------------------
Mysql关于 字符串 与 整型对比 的查询与索引
查询中 number compare string： 如果有索引，那么就可以利用到索引
查询中 string compare number： 就算有索引，也利用不到   有许多种string可以转换值为1,比如: '1', ' 1', '1a'.

auto_increment 在MyISAM与InnoDB的区别:
对于InnoDB, 自增长列必须是索引. 如果是组合索引, 也必须是组合索引的第一列.
对于MyISAM, 自增长列可以是组合索引的其他列.

timestamp 还有个重要的特点, 就是与时间相关. 当插入日期时，会先转换为本地时区后存放；
而从数据库里面取出时，也同样需要将日期转换为本地时区后显示
两个不同时区的用户看到的同一个日期可能是不一样的

char, varchar
char会删除最后的空格, 而varchar不会.
create table t_char (n char(4), nn varchar(4));
insert into t_char values ('he ', 'he ');
select length(n), length(nn) from t_char; 2,3

ENUM类型是忽略大小写的，在存储“M”、“f”时将它们都转成了大写，
对于插入不在 ENUM 指定范围内的值时，插入了enum(‘M’,’F’)的第一个值“M”

查看表级锁的争夺情况
show global status like 'table_lock%';
Table_locks_waited的值比较高，则说明存在着较严重的表级锁争用情况

MySIAM 在select前, 会自动给所涉及的表加上读锁, 在执行更新操作时(update, delete, insert)前,会自动给涉及的表加写锁.
MyISAM 的锁调度
MyISAM存储引擎的读锁和写锁是互斥的，读写操作是串行的,读锁写锁同时加，写进程先获得锁

InnoDB 的行锁及加锁方法
行锁类型
共享锁（S）：允许一个事务去读一行，阻止其他事务获得相同数据集的排他锁
排他锁（X）：允许获得排他锁的事务更新数据，阻止其他事务取得相同数据集的共享读锁和排他写锁
意向共享锁（IS）：事务打算给数据行加行共享锁，事务在给一个数据行加共享锁前必须先取得该表的IS锁
意向排他锁（IX）：事务打算给数据行加行排他锁，事务在给一个数据行加排他锁前必须先取得该表的IX锁

共享锁（S）：SELECT * FROM table_name WHERE … LOCK IN SHARE MODE
排他锁（X）：SELECT * FROM table_name WHERE … FOR UPDATE

InnoDB行锁竞争情况
show global status like '%innodb_row_lock%';

InnoDB行锁是通过给索引上的索引项加锁来实现的,
如果不通过索引条件检索数据，那么InnoDB将对表中的所有记录加锁，实际效果跟表锁一样
如果使用相等条件请求给一个不存在的记录加锁，InnoDB也会使用Next-Key锁

行锁分三种情况:
Record lock：对索引项加锁
Gap lock：对索引项之间的“间隙”、第一条记录前的“间隙”或最后一条记录后的“间隙”加锁
Next-key lock：前两种的组合，对记录及其前面的间隙加锁

什么时候使用表锁
第一种情况是：事务需要更新大部分或全部数据，表又比较大
第二种情况是：事务涉及多个表，比较复杂，很可能引起死锁，造成大量事务回滚

在用LOCK TABLES对 InnoDB表加锁时要注意，要将AUTOCOMMIT设为 0，否则MySQL不会给表加锁
必须用UNLOCK TABLES释放表锁

锁等待超时参数innodb_lock_wait_timeout来解决 锁等待超时阈值

在REPEATABLE-READ隔离级别下，如果两个线程同时对相同条件记录用SELECT…FOR UPDATE加排他锁，
在没有符合该条件记录情况下，两个线程都会加锁成功程序发现记录尚不存在，就试图插入一条新记录
如果两个线程都这么做，就会出现死锁 将隔离级别改成READ COMMITTED，就可避免问题.

all < index < range < ref < eq_ref < const, system < NULL
从左到右, 性能由最差到最好
1. type=ALL，全表扫描，MySQL遍历全表来找到匹配的行.
2. type=index，索引全扫描，
3. type=range，索引范围扫描，常见于<、<=、>、>=、between等操作符.
4. type=ref，使用非唯一索引扫或唯一索引的前缀扫描，返回匹配某个单独值的记录行. ref还经常出现在join操作中
5. type=eq_ref，类似ref，区别就在使用的索引是唯一索引，对于每个索引键值，表中只有一条记录匹配；
简单来说，就是多表连接中使用 primary key或者 unique index作为关联条件
6. type=const/system，单表中最多有一个匹配行，查询起来非常迅速，所以这个匹配行中的其他列的值可以被优化
7. type=NULL，MySQL不用访问表或者索引，直接就能够得到结果
8. 类型type还有其他值，如ref_or_null（与ref类似，区别在于条件中包含对NULL的查询）、
index_merge（索引合并优化）、
unique_subquery（in 的后面是一个查询主键字段的子查询）、
index_subquery（与 unique_subquery 类似，区别在于 in 的后面是查询非唯一索引字段的子查询）

Using index也就是平常说的覆盖索引扫描
explain partitions: 命令查看SQL所访问的分区

通过 show profile分析SQL
步骤:
查看是否支持: select @@have_profiling;.
会话级开启: set profiling = 1;
执行SQL
执行profile: show profiles;
查看具体某个query的profile: show profile for query N;

用or分割开的条件，如果or前的条件中的列有索引，而后面的列中没有索引，那么涉及的索引都不会被用到

SET UNIQUE_CHECKS=0，关闭唯一性校验

select a.film_id, a.description
from file a
 inner join
(select file_id from file order by title limit 50, 5)
 b on a.film_id = b.film_id

 启用NO_BACKSLASH_ESCAPES: 使反斜线成为普通字符.
 在导入数据时, 如果数据中含有反斜线, 那么启用NO_BACKSLASH_ESCAPES模式可以保证数据的正确性

开启事务: start transaction 或 begin
提交或回滚: commit, rollback
commit and chain: 立即启动一个新的事务, 并且和刚才的那个事务具有相同的隔离级别.
release: 断开和客户端的连接

定点数不同于浮点数，定点数实际上是以字符串形式存放的  decimal(10,2)

--------------------------------------------------------------------------------------
mysql更改字符集
alter table t1 convert to charset utf8mb4;
alter table 改字符集的操作是阻塞写的
--------------------------------------------------------------------------------------
mysql 当sql解释器遇到 start transaction 时候会触发commit
mysql> starttransaction ;
QueryOK, 0 rowsaffected (0.00 sec)

mysql> insertintoceshivalues(3);
QueryOK, 1 rowaffected (0.00 sec)

mysql> commit;
QueryOK, 0 rowsaffected (0.00 sec)

mysql> rollback;
QueryOK, 0 rowsaffected (0.00 sec)
--------------------------------------------------------------------------------------
mysql union 使用IN查询不连续的数
select *
from (
    select 1 as cid union all
    select 5000 union all
    select 50000 union all
    select 500000 union all
    select 955559
) as tmp, t
where tmp.cid = t.cid;
--------------------------------------------------------------------------------------
