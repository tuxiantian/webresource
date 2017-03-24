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
mysql数据库的逻辑架构图
客户端层(链接处理,授权认证,安全)、中间层(查询解析、分析、优化、缓存以及所有的内置函数)、存储引擎层(查询优化和执行 并发控制 事务处理)
表锁是MySQL中最基本的策略锁 行级锁可以最大程度的支持并发处理

mysql有md5 sha1函数
mysql5.5 password采用2次SHA-1算法DigestUtils.sha(DigestUtils.sha(utf8))
select aes_encrypt('1234','12345678'),aes_decrypt(aes_encrypt('1234','12345678'),'12345678')

mysql5.6 select  to_base64('1234'), from_base64(to_base64('1234'))

select  to_base64(aes_encrypt('1234','12345678')),
        aes_decrypt(from_base64(to_base64(aes_encrypt('1234','12345678'))),'12345678')

select  to_base64(des_encrypt('1234','12345678')),
        des_decrypt(from_base64(to_base64(des_encrypt('1234','12345678'))),'12345678')

select hex('1234ABCD'),unhex(hex('1234ABCD'))


MySQL 能够支持的最大连接数量受限于操作系统 max_connections

整数保存ip
select inet_aton('192.168.222.255');  输出：3232292607
select inet_ntoa(3232292607);        输出：192.168.222.255


整数保存时间
select from_unixtime(1156219870);
select unix_timestamp('2006-11-04 12:23:00'); 秒

查看mysql数据库的时区
select timediff(now(), utc_timestamp);
转换时区
select timediff(now(),convert_tz(now(),@@session.time_zone,'+00:00'));


查看语法
? create table

查看表优化
select * from db_ap_rgsg_mb_work_order procedure analyse();

复制字段结构 丢失主键、自动增长和索引信息
create table test_copy_a_2
select * from test_copy_a where 1 != 1

复制完整的字段结构和索引 表状态与原表等同
create table test_copy_a_3 like test_copy_a

均不会复制权限对表的设置

explain type
ref 非唯一性索引扫描或者,返回匹配某个单独值的所有行
all 全表遍历
index 索引全扫描
range 索引范围扫描
eq_ref 主键扫描或者索引唯一扫描
const、system 配的行的其他列值可以转换为一个常量
NULL不用访问表或者索引就可以直接得到结果

B-Tree索引,所有的值都是按照顺序存储 的,并且每一个叶子页到根的距离都相等
B-Tree对索引列是顺序存储的,所以很适合查找范围数据
缺点是必须按照索引从最左列开始查找,否则无法使用索引

R-Tree（空间数据索引）,MyISAM表支持空间索引,可以用作地理数据存储

避免使用NULL
delete大数据的时候使用limit,避免大语句锁住过多数据
关联查询拆成简单查询然后在应用层聚合数据
mysql客户端和服务器之间的通信协议是半双工
热点数据分离出来

哈希索引只支持等值比较,查询包括 = ,in(),不支持范围查询,如 where age>50
可以新加一列 url_path_hash_code 用CRC32 做哈希, full_url_hash int unsigned
crc32是32 bit的CRC校验,无符号. 返回的最大数为2^32,(10位以内).
select crc32('mysql'),crc32('Mysql');
select crc32(''),crc32(null);  0--null

mysql数据库SUM(A+B)不一定等于SUM(A)+SUM(B),当A或B为NULL时,SUM(A+B)=NULL
不同字段,将or改为union  同一字段 or改为in

无需排序：order by null

数字型更高效、查询更快、占用空间更小

 Count(distinct field)查询效率极低,数据量大时甚至会爆出内存不足
优化技巧：使用临时表概念,先把distinct的field 经过group by过滤后,再对其进行count计算

单表去重并保留id最小的一条
DELETE FROM table_test WHERE id NOT IN
(SELECT id FROM (SELECT MIN(id) AS id FROM table_test AS t GROUP BY uid) t1);

刷新Host缓存
flush hosts

只使用IP地址来匹配连接
skip-name-resolve

表级锁：开销小,加锁快;不会出现死锁;锁定粒度大,发生锁冲突的概率最高,并发度最低
行级锁：开销大,加锁慢;会出现死锁;锁定粒度最小,发生锁冲突的概率最低,并发度也最高

行级锁并不是直接锁记录,而是锁索引 在UPDATE、DELETE操作时  会锁定相邻的键值,即所谓的next-key locking

强制索引 force index
select * from db_ap_rgsh_vertify_log force index (index_ap_rgsh_vertify_log_001)
忽略索引 ignore index
select * from db_ap_rgsh_vertify_log ignore index (index_ap_rgsh_vertify_log_001)


查出符合条件的主键值,再按照主键更新记录
分区表 没有合适的索引时,对其中几个分区表进行全表扫描.或者只有一个分区表和索引是热点,而且这个分区和索引能够全部存储在内存中
.限制单表分区数不要超过150个
分区表分为RANGE,LIST,HASH,KEY四种类型,并且分区表的索引是可以局部针对分区表建立的

---必须为主键 NULL值使分区过滤无效
create table tmysql_test_partition_range (
    id int auto_increment,
    amount double not null,
    order_day datetime not null,
    primary key(id, order_day)
) engine=innodb partition by range(year(order_day)) (
    partition p_2010 values less than (2010),
    partition p_2011 values less than (2011),
    partition p_2012 values less than (2012),
    partition p_catchall values less than maxvalue);


添加分区 只能添加大于分区键的分区
alter table tmysql_test_partition_range add partition (partition p2013 values less than(2013));

删除分区 数据也删除了
alter table tmysql_test_partition_range drop partition p_catchall; //可以删除任意分区

删除分区数据
alter table tmysql_test_partition_range  truncate partition p_2011;
alter table tmysql_test_partition_range  truncate partition all;

rebuild重建分区 解决磁盘碎片
alter  table tmysql_test_partition_range rebuild partition all;

查看正在锁的事务
select * from information_schema.innodb_locks;

查看等待锁的事务
select * from information_schema.innodb_lock_waits;

show full processlist;

事务表
select * from information_schema.innodb_trx;

避免对带有多个唯一关键字的表使用on duplicate key子句
存在更新
insert into tmysql_test_replaceinfo_t (k, v)
values(1,'update_1')
on duplicate key update v='update_1 ';

replace将delete和insert合二为一,形成一个原子操作
表中必须有唯一索引,而且这个索引所在的字段不能允许空值
replace into tmysql_test_replaceinfo_t (k, v) values (1, '1-1');

on duplicate key replace主键都会自增 replace旧值消失

show variables like '%dir%';

5.6
explain update mysql_test_rangecount_2 set yb=2  where id=1
timestamp(3) datetime(3) 保存毫秒  0-6
select microsecond('2015-12-10 14:12:09.019473');  19473


mysql 5.7特性
密码过期策略(天)
alter user 'root'@'localhost' password expire never
default_password_lifetime=0 --不过期

alter user 'test'@'%' password expire interval 90 day;
flush privileges;

select
   user,
   host,
   password_last_changed,
   password_lifetime,
   password_expired
 from mysql.user
where user = 'root'

创建用户
create user 'jeffrey'@'localhost'
  identified with sha256_password by 'new-password'
  password expire interval 180 day;

mysqld --initialize --user=mysql \
         --basedir=/opt/mysql/mysql \
         --datadir=/opt/mysql/mysql/data

对JSON的某个属性建立索引 虚拟列功能,通过传统的B+树索引即可实现对JSON格式部分属性的快速查询
create table `tmysql_test_virtual_column` (
  `id` int(11) not null auto_increment,
  `data` json not null,
  `name` varchar(64) generated always as (json_unquote(json_extract(data, '$.name'))) virtual,
  primary key (`id`),
  key `name` (`name`)
) engine=innodb

explain select * from tmysql_test_virtual_column where name = 'longlong';

多线程复制

"UNION ALL" 不再创建临时表,减少磁盘空间和磁盘IO的操作

sys数据库
获取未使用的索引
select * from sys.schema_unused_indexes;

5.6.3以后新增的系统选项 default_tmp_storage_engine 是控制 create temporary table 创建的临时表的引擎类型
show variables like 'default_tmp%';

create temporary table tmp1(id int not null);

临时表相关配置
tmp_table_size：指定系统创建的内存临时表最大大小
max_heap_table_size: 指定用户创建的内存表的最大大小

从5.7.5开始,新增一个系统选项 internal_tmp_disk_storage_engine 可定义磁盘临时表的引擎类型为 InnoDB
show variables like 'internal_tmp_disk_storage_engine%';

--------------------------------------------------------------------------------------
索引内部是怎么排序的 b+树
B树了解过吗,内部是怎么排序的

key_len 等于索引列类型字节长度,例如int类型为4-bytes,bigint为8-bytes；
字符串类型,CHAR(30) UTF8则key_len至少是90-bytes；
若该列类型定义时允许NULL,其key_len还需要再加 1-bytes；
VARCHAR其key_len还需要再加 2-bytes

--------------------------------------------------------------------------------------
mysql 默认隔离级别 可重复读（Read-Repeatable,RR)  RC不可重复读,而Binlog要求SQL串行化
  SELECT @@global.tx_isolation;
  SELECT @@session.tx_isolation;
  SELECT @@tx_isolation;

transaction-isolation = REPEATABLE-READ

oracle 默认隔离级别 读提交（Read-Comitted,RC）
--------------------------------------------------------------------------------------
mysql存储过程
call proc_sp_table_exists('test','t1',@result);
select @result;

MySQL4.1 提供了information_schema 数据字典从此可以很简单的用SQL语句来检索需要的系统元数据了
MySQL5.5 提供了performance_schema 性能字典 但是这个字典比较专业,一般人可能也就看看就不了了之了
MySQL5.7 提供了 sys系统数据库 sys数据库里面包含了一系列的存储过程、自定义函数以及视图来帮助我们快速的了解系统的元数据信息
sys系统数据库结合了information_schema和performance_schema的相关数据

未使用的索引
select * from sys.schema_unused_indexes;

检索指定数据库下面的表扫描信息,过滤出执行次数大于10的查询
select * from sys.statement_analysis
where db='test'
and full_scan = '*'
and exec_count >5

过滤出有临时表的查询
select * from sys.statement_analysis
where db='test'
and tmp_tables > 0
order by tmp_tables desc

检索执行次数排名前五的语句
select statement,total
from sys.user_summary_by_statement_type
where `user`='root'
order by total desc limit 5

metadata lock即 元数据锁 元数据即数据字典信息包括db,table,function,procedure,trigger,event等
metadata lock主要为了保证元数据的一致性,用于处理不同线程操作同一数据对象的同步与互斥问题
主要解决
事务隔离问题 可重复隔离级别下,会话A在2次查询期间,会话B对表结构做了修改
数据复制问题 如会话A执行了多条更新语句期间,另外一个会话B做了表结构变更并且先提交

查看临时文件存储目录
show variables like '%tmp%';
tmpdir=path

find_in_set(3,'1,2,3')
--------------------------------------------------------------------------------------
