redis整个从库重做流程是这样的：
主库bgsave自身数据到磁盘
主库发送rdb文件到从库
从库开始加载
加载完毕开始续传，同时开始提供服务

内存越大，触发持久化的操作阻塞主线程的时间越长
--------------------------------------------------------------------------------------
redis默认端口 6379

(注)redis命令版本不同可能有些不支持

没有设置过期时间 不会删除key,直到到达设置的内存最大值
expire cache_page 30  # 设置过期时间为 30 秒
ttl cache_page    # 查看剩余生存时间

scan 2.8版本后
scan 0 返回所有
scan 4 返回4个
scan 0 match t*
scan 0 match m* count 7 扫描7个
sscan s_myset 0 match f*

all String values are limited to 512 MiB
list set 最大长度 2^32 - 1

redis缓存命中率 info stats
keyspace_hits:14414110
keyspace_misses:3228654
缓存的命中率：14414110 / (14414110 + 3228654) = 81%

redis安全
redis命令重命名
rename-command config b840fc02d524045429941cc15f59e41cb7be6c52

rename-command flushall ""
rename-command config   ""
rename-command eval     ""

stop-writes-on-bgsave-error  yes

禁止外网访问redis
bind 192.168.1.100

添加密码验证
requirepass mypassword

修改端口
port 6379

关闭config
rename-command CONFIG “”

# 限定最多使用1.5GB内存
maxmemory 1536mb
设置策略为清理最少使用的key对应的数据
maxmemory-policy
volatile-lru：回收最近最少使用(LRU)的键,但是只回收有设置过期的键,为新数据腾出空间
allkeys-lru：回收最近最少使用(LRU)的键,为新数据腾出空间

redis 的并发模型是单进程单线程

info memory
info stats

redis-cli --raw

https://github.com/junegunn/redis-stat  A real-time Redis monitoring tool

redis 缓存清除策略 LRU 设置maxmemory-policy
volatile-lru -> 利用LRU算法移除设置过期时间的key

redis数据类型 字符串（Strings) 列表（Lists）最多可以包含2^32-1个元素 集合（Sets） 哈希（Hashes）有序集合（Sorted sets）

type bar 查看键bar的数据类型
exists bar 检查bar键是否存在

monitor 监控redis所有命令执行状况

slowlog get
config get slowlog-log-slower-than (默认10000us） 10ms
set slowlog-log-slower-than 5000

slowlog get 10

slowlog-max-len ,它决定 slow log 最多能保存多少条日志
set maxclients 3
memory fragement ratio=use memory rss/use memory

auth admin
config get *
config get databases
select 0
flushdb
flushall

命令处理总数：total_commands_processed (info stats)

列出当前连接的客户端
client list

数据库相关的统计信息
info keyspace

查看命令状态
info commandstats

查看RDB和AOF 的相关信息
info persistence

config get timeout 超时时间

看门狗 诊断Redis的延迟问题 不推荐开启 0关闭watchdog
config get watchdog

config set watchdog-period 500 运行时间超过500毫秒的操作将会被记录下来

使用key值前缀来作命名空间
设置过期时间
expire s_key 10 秒
pexpire 毫秒

取消过期时间
persist key_name

set,getset命令也能清除键的过期时间 只对键进行操作的命令（比如incr,lpush等等）不会清除键的过期时间
incr +
decr -

工具 redisstudio

lrange mimvp 0 -1

延时 latency latest
     latency history command
     latency reset command

debug sleep 1

sort today_cost desc
sort today_cost alpha 字母
sort rank limit 1 3 desc 跳过1返回3

set mimvp_12 mimvp_12
sort mimvp by mimvp_*  alpha
sort mimvp by mimvp_* get mimvp_* alpha desc

redis的内存模型

redis场景
1.流量控制
2.防暴力破解
3.系统缓存

redis备份策略
RDB 持久化可以在指定的时间间隔内生成数据集的时间点快照（point-in-time snapshot） 灾难恢复 恢复速度快 默认是dump.rdb
AOF 持久化记录服务器执行的所有写操作命令,并在服务器启动时,通过重新执行这些命令来还原数据集

appendonly 开启aof特性,这个控制是否启用aof
appendfilename 写入文件的文件名
appendfsync 写入策略,默认值everysec,每秒写一次(调用flush)

http://esmooov.github.io/rdbhs/ rdb格式

save 命令用于创建当前数据库的备份
bgsave：将数据异步保存到磁盘
lastsave：返回上次成功将数据保存到磁盘的Unix时戳

获取 redis 目录
config get dir

bgsave:该命令在后台执行备份

重启后恢复rdb文件
redis-server --service-stop 停止
redis-server --service-start 开始

pkill命令可以按照进程名杀死进程
pkill redis-server
kill -15 redis-pid停止某一个Redis服务

signterm（15） 的效果是正常退出进程,退出前可以被阻塞或回调处理

timeout 超时时间
loglevel 日志记录等级,有4个可选值,debug,verbose,notice,warning
databases 可用数据库数,默认值为16,默认数据库为0

save <seconds> <changes> 指出在多长时间内,有多少次更新操作,就将数据同步到数据文件
maxmemory <bytes> 设置最大内存,达到最大内存设置后

randomkey 随机返回key空间的一个key
rename test_a test_b 重命名一个key

ttl key：查看还可以存活多少秒,-2表示key不存在,-1表示永久存储
如果一个redis作为slave,且将slave-read-only设置为off,并写入了一个带有ttl的key时,当key过期后,该key是不会被redis删除的,且ttl在过期后永远为0

1. redis的清除过期key的策略
- 被动方式：在事件循环中,每秒执行约10次,尽力删除过期的key,会有漏掉的情况
- 从expire set中随机检查20个key
- 删除到过期的key
- 如果超过25%的key都是过期了,就重复第一步（超过25%说明过期的key占比很多）

- 主动方式：
- 如果该key在被动方式中漏过,在其再次被访问时检查并清除

ping  #测试连接是否存活
echo #在命令行打印一些内容
select #选择数据库 Redis数据库编号从0-15,我们可以选择任意一个数据库来进行数据的存取
dbsize #返回当前数据库中key的数目
info  #获取服务器的信息和统计
config get #实时转储收到的请求
flushdb #删除当前选择数据库的所有的key
flushall  #删除所有数据库的所有的key

llen keylist :获取keylist的长度大小
lpop keylist:取出并移除keylist第一个元素,左边的元素
rpop keylist:取出并移除keylist最后一个元素,右边的元素
lindex key index:获取该索引下的元素
rpush keyList value:向keyList添加元素,向后加,r表示右边
lpush keyList value:向keyList左边添加元素,LPUSH puts the new value at the start of the list.
lrange keyList beginIndex endIndex:获取keyList的元素,用两端的索引取出子集,endIndex=-1则表示全部取出

sadd key value : 向set添加元素
srem key value ：从set中移除元素
smembers key : 取出key值
scard key : 获取set中元素的个数

hgetall myfilter  获取hash所有key
hget myfilter a  获取单个key
hkeys key：获取对象的所有属性
hvals key：获取对象的所有属性值
hdel key field：删除对象的改属性
hexists key field:查看对象是否存在该属性
hlen key: 属性个数

keys    sit[ey]  --模糊查询,匹配前面是sit并且第四位是 e或y的键
keys    sit?e    --模糊查询,查询sit开头,第四位未知,第5位是e的key

move age 1  --移动到1号库
select  1    --切换到1号数据库

pttl  age  --查看key的生命周期,以毫秒方式返回

config get databases 数据库数量

dbsize 数据库key大小

info keyspace 查看数据库key大小


debug object s_key_1  查看保存rdb时候序列化长度

不存在插入过期时间30秒
set s_key s_value nx px 30000

slaveof 127.0.0.1 8000
--------------------------------------------------------------------------------------
指定 Redis 数据库访问密码
redis-cli -a password keys "*" | xargs redis-cli -a password del


访问 Redis 中特定的数据库
//下面的命令指定数据序号为0，即默认数据库
redis-cli -n 0 keys "*" | xargs redis-cli -n 0 del
--------------------------------------------------------------------------------------