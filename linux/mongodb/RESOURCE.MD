#### linux下启动mongodb
/usr/local/mongodb/bin/mongod  -port 27017 --dbpath /data/mongodb/db --logpath /data/mongodb/log/mongodb.log --fork  
--fork 选项将会通知 mongod 在后台运行  
mongodb默认端口 27017  
--------------------------------------------------------------------------------------
mongodb不支持Timestamp
--------------------------------------------------------------------------------------
#### 启动MongoDB
mongod.exe --dbpath C:\mongod_data\db
#### 将MongoDB服务器作为Windows服务运行
mongod.exe --bind_ip localhost --logpath "C:\mongod_data\dbConf\mongodb.log" --logappend --dbpath "C:\mongod_data\db" --port 27017 --serviceName "mongodb" --serviceDisplayName "mongodb" --install  
**注意以管理员身份运行**
net start mongodb  启动服务  
net stop mongodb   停止服务  
sc delete mongodb   删除服务（这条命令适合大多数服务，只需要改后面的服务名称）  
mongo 127.0.0.1:27017 //连接mongodb  
下面两个是连接的简写  
mongo 27017  
mongo  
bin目录中包含如下几个程序：
1. mongo.exe，命令行客户端工具。  
2. mongod.exe，数据库服务程序。  
3. mongodump.exe，数据库备份程序。  
4. mongoexport.exe，数据导出工具。  
5. mongofiles.exe，GridFS工具。  
6. mongoimport.exe，数据导入工具。  
7. mongorestore.exe，数据库恢复工具。  
8. mongos.exe，貌似是性能检测工具。  

#### MongoDB数据导入和导出
[MongoDB数据导入和导出](http://www.cnblogs.com/roland1982/archive/2013/12/04/3458032.html)
./mongoexport -d xingtu -c carInfo250006222 -o carInfo250006222.dat  
./mongoimport -d xingtu -c carInfo250006222 carInfo250006222.dat  
#### mongodb视图工具，免费的
Robomongo 1.0.0-RC1
#### MongoDB学习文档
MongoDB入门学习     http://www.runoob.com/mongodb/mongodb-window-install.html  
mongodb官网       http://docs.mongoing.com/manual-zh/sharding.html  
mongodb视图管理工具下载地址      https://robomongo.org/download  
MongoDB干货篇之更新数据         https://chenjiabing666.github.io/2017/05/01/MongoDB%E5%B9%B2%E8%B4%A7%E7%AF%87%E4%B9%8B%E6%9B%B4%E6%96%B0%E6%95%B0%E6%8D%AE/#
MongoDB干货篇之查询数据         https://chenjiabing666.github.io/2017/04/30/MongoDB%E5%B9%B2%E8%B4%A7%E7%AF%87%E4%B9%8B%E6%9F%A5%E8%AF%A2%E6%95%B0%E6%8D%AE/


MongoDB查询超时异常SocketTimeoutException   https://my.oschina.net/gooke/blog/382722  
> 最后一点 ConnectionTimeOut和SocketTimeOut的区别：
> 一次完整的请求包括三个阶段：1、建立连接 2、数据传输 3、断开连接  
> 如果与服务器(这里指数据库)请求建立连接的时间超过ConnectionTimeOut，就会抛 ConnectionTimeOutException，即服务器连接超时，没有在规定的时间内建立连接。  
> 如果与服务器连接成功，就开始数据传输了。  
> 如果服务器处理数据用时过长，超过了SocketTimeOut，就会抛出SocketTimeOutExceptin，即服务器响应超时，服务器没有在规定的时间内返回给客户端数据。  
#### 查看数据库信息
查看所有的数据库 show dbs
```
 命令：db.stats()
 执行结果如下：
 {
        "db" : "test",  //当前数据库
        "collections" : 509,     //当前数据库多少表
        "views" : 0,
        "objects" : 5446,       //当前数据库所有表共有多少条数据 
        "avgObjSize" : 141.1968417186926,       //每条数据的平均大小
        "dataSize" : 768958,    //所有数据的总大小 
        "storageSize" : 18640896, //所有数据占的磁盘大小
        "numExtents" : 0,
        "indexes" : 510,        //索引数
        "indexSize" : 18673664, //索引大小
        "ok" : 1
}
```
#### 查看集合信息
命令：db.集合名.stats()
查看数据库所有的集合
show collections;
查看集合的数量
db.集合名.find().count();
多个查询条件的查询示例
db.getCollection('carLocation080').find({"gpsTime":{$gte:1492046406356,$lte:1503543971000}})
#### Help查看命令提示
```
help
db.help();
db.yourColl.help();
db.youColl.find().help();
rs.help();
```
#### 索引
```
> db.carInfo001.find().pretty().explain()
{
        "queryPlanner" : {
                "plannerVersion" : 1,
                "namespace" : "xingtu.carInfo001",
                "indexFilterSet" : false,
                "parsedQuery" : {

                },
                "winningPlan" : {
                        "stage" : "COLLSCAN",
                        "direction" : "forward"
                },
                "rejectedPlans" : [ ]
        },
        "serverInfo" : {
                "host" : "tuxt-PC",
                "port" : 27017,
                "version" : "3.4.3",
                "gitVersion" : "f07437fb5a6cca07c10bafa78365456eb1d6d5e1"
        },
        "ok" : 1
}
```
```
> db.carInfo001.find({"receivedTime":{$lte:1492052929754}}).pretty().explain()
{
        "queryPlanner" : {
                "plannerVersion" : 1,
                "namespace" : "xingtu.carInfo001",
                "indexFilterSet" : false,
                "parsedQuery" : {
                        "receivedTime" : {
                                "$lte" : 1492052929754
                        }
                },
                "winningPlan" : {
                        "stage" : "FETCH",
                        "inputStage" : {
                                "stage" : "IXSCAN",
                                "keyPattern" : {
                                        "receivedTime" : -1
                                },
                                "indexName" : "receivedTime_-1",
                                "isMultiKey" : false,
                                "multiKeyPaths" : {
                                        "receivedTime" : [ ]
                                },
                                "isUnique" : false,
                                "isSparse" : false,
                                "isPartial" : false,
                                "indexVersion" : 2,
                                "direction" : "forward",
                                "indexBounds" : {
                                        "receivedTime" : [
                                                "[1492052929754.0, -inf.0]"
                                        ]
                                }
                        }
                },
                "rejectedPlans" : [ ]
        },
        "serverInfo" : {
                "host" : "tuxt-PC",
                "port" : 27017,
                "version" : "3.4.3",
                "gitVersion" : "f07437fb5a6cca07c10bafa78365456eb1d6d5e1"
        },
        "ok" : 1
}
```
#### mongodb监控
db.your_collection.find({ x : 123, y : 456 }).explain("allPlansExecution")，查看你的语句的工作情况 :

db.setProfilingLevel( profile, slowms )
// 第一个参数表示慢日志的级别，取值是 0 1 2
        profile=0  表示不记录慢日志
        profile=1  表示只记录慢日志
        profile=2  表示所有日志都记录
// 第二个参数表示慢日志的时间阀值，单位是毫秒

db.getProfilingStatus()
// 查看当前慢日志的配置信息

开启慢日志后，在当前库下就会出现system.profile这个collection
 db.system.profile.find().limit(2).sort({ ts : -1 }).pretty() 查出最近的2条慢日志

查看最近15分钟内的服务状态
db.serverStatus()
// 必须在admin库下，才能使用这条命令
egg db.serverStatus()['extra_info']

##### mongostat
mongostat默认每秒输出一次，可传入参数更改时间间隔
> mongostat 2 # 每隔2s输出一次

```
insert query update delete getmore command dirty used flushes vsize  res qrw arw net_in net_out conn                time
    *0    *0     *0     *0       0     2|0  0.5% 3.7%       0  608M 268M 0|0 0|0   158b   45.2k   35 Oct 16 11:04:36.857
    *0    *0     *0     *0       0     2|0  0.5% 3.7%       0  608M 268M 0|0 0|0   215b   45.4k   35 Oct 16 11:04:37.858
    *0    *0     *0     *0       0     2|0  0.5% 3.7%       0  608M 268M 0|0 0|0   158b   45.2k   35 Oct 16 11:04:38.857
    *0     2     *0     *0       0     2|0  0.5% 3.7%       0  608M 268M 0|0 0|0   383b   46.0k   35 Oct 16 11:04:39.857
    *0     2     *0     *0       0     2|0  0.5% 3.7%       0  608M 268M 0|0 0|0   383b   45.9k   35 Oct 16 11:04:40.857
    *0    *0     *0     *0       0     2|0  0.5% 3.7%       0  608M 268M 0|0 0|0   158b   45.2k   35 Oct 16 11:04:41.857
    *0    *0     *0     *0       0     1|0  0.5% 3.7%       0  608M 268M 0|0 0|0   157b   45.2k   35 Oct 16 11:04:42.857
    *0    *0     *0     *0       0     2|0  0.5% 3.7%       0  608M 268M 0|0 0|0   158b   45.2k   35 Oct 16 11:04:43.857
    *0    *0     *0     *0       0     2|0  0.5% 3.7%       0  608M 268M 0|0 0|0   158b   45.2k   35 Oct 16 11:04:44.857
    12    32     *0     *0       0     8|0  0.3% 3.7%       1  608M 268M 0|0 0|0  8.19k   57.1k   35 Oct 16 11:04:45.856
```
输出说明：
> insert query update delete getmore command        每种操作发生的次数  
> flushes  mongod将数据刷新到磁盘的次数  
> vsize     mongod正在使用的虚拟内存的大小，通常为数据目录的2倍大小（一次用于映射文件，一次用于日记系统）  
> res        mongod正在使用的内存的大小，通常该值应该尽量接近机器所有内存的大小。  
> qr | qw  读写操作队列大小，即有多少读写操作被阻塞，等待进行处理。  
> ar | aw  活动客户端的数量，即正在进行读写操作的客户端。  
> netIn     通过网络传输进来的字节数。  
> netOut  通过网络传输出去的字节数。  
> conn     此服务器打开的连接数，包括输入和输出的连接。  