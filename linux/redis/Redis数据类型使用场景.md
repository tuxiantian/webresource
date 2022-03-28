## redis的数据类型

redis主要支持五种数据类型：string、list、hash、set、zset

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/9f3942897f2343dc9edd5a7ad6871731.png)

redis有很多命令，我们可以查看文档，也可以通过help查看命令：

help @string
help @list
help @hash
help @set
help @sorted_set

例如执行：help @string

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/e361ad0169e6471f88225032f7caed39.png)

## string操作命令及使用场景

string常用命令
字符串常用操作

> SET key value;     -- 存入一个字符串键值对
> MSET key1 value1 key2 value2 ...  -- 批量存储键值对
> SETNX key value    -- 存入一个不存在的字符串键值对
> MGET key1 key2 ...    --批量获取键值
> DEL key1 key2 ...    --删除键值对
> EXPIRE key seconds   -- 设置一个键的过期时间（秒）

原子加减
> INCR key    -- 将key中存储的数值加一
DECR key    -- 将key中存储的数值减一
INCRBY key increment  --将key中存储的数值加上increment
DECRBY key decrement  --将key中存储的数值减去decrement

### 使用场景

#### 单值缓存

很简单，就是SET key value和GET key

#### 对象缓存

SET user:1 json_value(对象的json格式数据)
这种缓存操作方便，但是修改对象中的某个字段，需要将整个对象缓存查询出来，反序列化，修改之后，序列化存入。
MSET user:1:name lisi user:1:age 18
MGET user:1:name user:1:age

#### 分布式锁

当多个服务操作的时候，可以使用SETNX命令：

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/35897ee5649d4eef9c8f3614cae125d6.png)

抢到锁的服务进程会设置成功，没抢到的则会返回0，业务逻辑处理完成后删除该键即可。

#### 计数器：文章阅读量

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/7e111bc5ea4a44548245b45cb702a526.png)

INCR article:id;
GET article:id;


#### web集群session共享

session+redis实现session共享

#### 分布式系统全局序列号

INCRBY article 1000 一次获取1000，提升性能

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/48bd632180fd4d8db62728d78d334595.png)

## hash操作命令及使用场景

常用命令

> HSET key field value   -- 存储
> HGET key field         -- 获取一个字段值
> HMSET key field1 value1 field2 value2 ...   -- 存储多个hash键值对
> HMGET key field1 field2 ...    -- 获取多个hash键值对
> HSETNX key field value  --存储一个不存在filed的值，注意不是key
> HDEL key field1 field2 ... -- 删除fields
> HLEN key     -- 返回key中field的数量
> HGETALL key  -- 返回所有field
> HINCRBY key field increment  -- 为field的值增加increment

### 使用场景

#### 存储对象

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/2b4ee434053b43f1b6a30029a9cc0c97.png)

HMSET user 1:name zhuge 1:balance 1888
HMGET user 1:name 1:balance
![](/Users/tuxiantian/Documents/webresource/images/linux/redis/52f7339e77d64c7abb82e3f2ba8f0481.png)

#### 电商购物车

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/d5b0c4a639184472bfbb45d48afb4c77.png)

* 添加商品
HSET cart:[用户id] 商品id 数量

* 增加商品数量
HINCRBY cart:[用户id] 商品id 1

* 商品种类总数
HLEN cart:[用户id]

* 删除商品
HDEL cart:[用户id] 商品id

* 获取购物车所有商品
HGETALL cart:[用户id]

示例：

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/bf75e731e6ba41b28af3cebd6c1a4400.png)

hash与string存储对象相比优缺点
优点

* 同类数据归类整合存储，方便管理

* 相比string操作消耗内存和cpu更小

* 比string节省空间

缺点

* 过期功能不能用在field上，只能用在key上

*  redis集群架构下不适合大规模使用

## list操作命令及使用场景

  list常用命令

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/70de18c2267646baabf3c85c4469494f.png)

> LPUSH key value1 value2 ...  -- 将一个或多个值从左边放入key中
> RPUSH key value1 value2 ...  -- 将一个或多个值从右边放入key中
> LPOP key   -- 从左边弹出值
> RPOP key   -- 从右边弹出值
> LRANGE key start stop  -- 返回列表key中指定区间内的元素，区间以偏移量start和stop指定
> BLPOP key1 key2 ... [timeout] -- 从多个list中左边弹出元素，超时时间timeout
> BRPOP key1 key2 ... [timeout] -- 从多个list中右边弹出元素，超时时间timeout

 使用list构建数据结构
 Stack(栈) = LPUSH + LPOP
 Queue(队列) = LPUSH + RPOP
 Blocking Queue(阻塞队列) = LPUSH + BRPOP

### 使用场景

#### 微博和公众号消息流

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/c6e514b2d5ef46ec83af37ec7a6e6449.png)

大V会给订阅了的粉丝发送消息：
例如：用户hiwei的id1001
备胎说车给粉丝推送消息:
LPUSH msg:1001 1888
MacTalk也发送消息：
LPUSH msg:1001 1999
hiwei获取最近消息：
LRANGE msg:1001 0 4 – 查看最近五条消息

## set操作命令及使用场景

常用命令

> SADD key member1 member2 ...   -- 向set中放入一个或多个value
> SREM key member1 member2 ...   -- 从set中删除元素
> SMEMBERS key       -- 从set中获取所有元素
> SCARD key          -- 获取集合key中元素个数
> SISMEMBER key member   -- 判断member是否存在于集合key中
> SRANDMEMBER key count   -- 从集合key中随机选出count个元素，不删除元素。
> SPOP key count          -- 从集合key中随机取出count个元素，从集合中删除。

set运算操作：

> SINTER key1 key2 ...    -- 交集运算
> SINTERSTORE  newKey  key1 key2 ...  -- 将key的交集存入新的集合newKey
> SUNION key1 key2 ...    -- 并集运算
> SUNIONSTORE  newKey key1 key2  ...  -- 将key的并集存入新的集合newKey
> SDIFF key1 key2  ...   ---差集运算
> SDIFFSTORE newKey key1 key2 ...     -- 将key的差集存入新的集合newKey

### 使用场景

#### 微信抽奖

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/3fdc0df4c6cc4803bc5223fcde28970c.png)

用户参与抽奖：
SADD lottery 1001;
SADD lottery 1002;
SADD lottery 1003;
查看所有抽奖用户：
SCARD lottery；
抽取一名幸运儿：
SRANDMEMBER lottery 1;
如果是多次抽奖，不能重复获奖，则使用 SPOP lottery count

#### 点赞 收藏场景

jams id=1001,tony Id=1002
jams对tony点赞：
SADD like:1002 1001
tony查看点赞总数：SCARD like:1002
查看所有点赞人：SMEMBERS like:1002
jams取消点赞：SREM like:1002 1001

#### 微博微信等社交软件关注模型

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/63df28f893cc4e06b20c2c6e8c4dad79.png)

例如：jams、mic、tony、lisi、wangwu
jams关注的人jamsSet = {lisi,tony}
mic关注的人micSet = {lisi,wangwu}
则jams和mic共同关注的人：SINTER jamsSet micSet;
jams可能认识的人：SDIFF jamsSet micSet 然后去除jams的关注人。

## zset操作命令及使用场景

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/9c94ed32c62f4f1681e814ae4cdd12f8.png)

常用命令

> ZADD key [[score member]...]  -- 向有序集合key中添加带分值的member
> ZREM key member1 member2 ...  -- 删除元素
> ZSCORE key member              -- 返回元素member的分值
> ZINCRBY key increment member   -- 为元素member的分值加上increment
> ZCARD key                      -- 返回集合中元素个数
> ZRANGE	key	start stop        -- 正序返回从start下标到stop下标的元素
> ZREVRANGE	key	start stop        -- 倒序返回从start下标到stop下标的元素

zset集合操作：

> ZINTERSTORE destination numkeys key [key ...]    -- 交集计算
> ZUNIONSTORE destkey numkeys key [key ...] 	-- 并集计算

### 使用场景

实现排行榜

![](/Users/tuxiantian/Documents/webresource/images/linux/redis/cbc7e7b710be4b9980fead82bf54ca4b.png)

1）点击新闻
ZINCRBY hotNews:20190819 1 守护香港
2）展示当日排行前十
ZREVRANGE hotNews:20190819 0 9 WITHSCORES
3）七日搜索榜单计算
ZUNIONSTORE hotNews:20190813-20190819 7
hotNews:20190813 hotNews:20190814… hotNews:20190819
4）展示七日排行前十
ZREVRANGE hotNews:20190813-20190819 0 9 WITHSCORES