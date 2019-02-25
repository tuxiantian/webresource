如果存储一个对象 这个时候使用String 类型就不适合了，如果在String中修改一个数据的话，这就感到烦琐。 
hash 散列类型 ,他提供了字段与字段值的映射，当时字段值只能是字符串类型 
命令： 

命令 | 操作
---|---
hget | hmget的单参数版本 一次操作一个值
hset | hmset的单参数版本 一次操作一个值
hmget | hmget key-name key [key…]从散列里面获取一个或者多个键的值
hmset | hmset key-name key value [key value…] 为散列里面一个或者多个键设置值
hdel | hdel key-name key [key…] 删除给定键的值
hlen | 获取散列包含键值的数量
hexists | hexists key-name key 检查给定键是否存在散列里面
hkeys | 获取所有的键
hvals | 获取所有的值
hgetall | 获取所有的键和值
hincrby | 将某个键的值加上一个incrment
hincrbyfloat | 将某个键的值加上一个incrment（float类型）redis 2.6以上 support


## 1>赋值 

HSET命令不区分插入和更新操作，当执行插入操作时HSET命令返回1，当执行更新操作时返回0。 
一次只能设置一个字段值 
语法：HSET key field value 
比如：

> 127.0.0.1:6379> hset user username zhangsan 
> (integer) 1

一次可以设置多个字段值 
语法：HMSET key field value [field value …]

> 127.0.0.1:6379> hmset user age 20 username lisi 
> OK

语法：HSETNX key field value

> 127.0.0.1:6379> hsetnx user age 30  如果user中没有age字段则设置age值为30，否则不做任何操作
> (integer) 0

## 2>取值 

一次只能获取一个字段值

语法：HGET key field

> 127.0.0.1:6379> hget user username
> "zhangsan“

一次可以获取多个字段值 
语法：HMGET key field [field …]

> 127.0.0.1:6379> hmget user age username
> 1) "20"
> 2) "lisi"

获取所有字段值 
语法：HGETALL key

> 127.0.0.1:6379> hgetall user
> 1) "age"
> 2) "20"
> 3) "username"
> 4) "lisi"

## 3>删除字段 

可以删除一个或多个字段，返回值是被删除的字段个数

语法：HDEL key field [field …]

> 127.0.0.1:6379> hdel user age
(integer) 1
> 127.0.0.1:6379> hdel user age name
(integer) 0
> 127.0.0.1:6379> hdel user age username
(integer) 1 

增加数字 
语法： HINCRBY key field increment

> 127.0.0.1:6379> hincrby user age 2  将用户的年龄加2
(integer) 22
> 127.0.0.1:6379> hget user age       获取用户的年龄
"22“

注： 这个没有递减数字这一说； 

## 4>其他 

判断字段是否存在 
语法：HEXISTS key field

> 127.0.0.1:6379> hexists user age        查看user中是否有age字段
(integer) 1
> 127.0.0.1:6379> hexists user name   查看user中是否有name字段
(integer) 0

只获取字段名或字段值 
语法： 
HKEYS key 
HVALS key

> 127.0.0.1:6379> hmset user age 20 name lisi 
OK
> 127.0.0.1:6379> hkeys user
1) "age"
2) "name"
> 127.0.0.1:6379> hvals user
1) "20"
2) "lisi"

获取字段数量 
语法：HLEN key

> 127.0.0.1:6379> hlen user
(integer) 2

eg; 
注：map是最常见的数据类型；