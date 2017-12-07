#### linux下启动mongodb
/usr/local/mongodb/bin/mongod  -port 27017 --dbpath /data/mongodb/db --logpath /data/mongodb/log/mongodb.log --fork  
--fork 选项将会通知 mongod 在后台运行  
mongodb默认端口 27017  

mongodb不支持Timestamp

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
./mongoexport -d xingtu -c carInfo217361300000098 -o carInfo217361300000098.dat  
./mongoimport -d xingtu -c carInfo217361300000098 carInfo217361300000098.dat  
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
Warning  0.000GB
local    0.000GB
xingtu   0.040GB
```
查看当前数据库的统计信息  
命令：db.stats()
```
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
db.carLocation217361300000115.find().sort({gpsTime:-1}).limit(1).pretty()
db.carLocation217361300000095.find({"gpsTime":{$gte:1510110480000,$lte:1510111680000}}).sort({gpsTime:1}).pretty() //查询某个时间点的经纬度.limit(1)
db.carInfo217361300000153.find({"receivedTime":{$gte:1508064540000,$lte:1508067120000}}).sort({receivedTime:1}).pretty()
db.carInfo217361300000035.find({"receivedTime":{$gte:1508399040000,$lte:1508399580000}}).sort({receivedTime:1}).pretty()
db.carInfo217361300000006.find({"receivedTime":{$gte:1508635020000,$lte:1508635620000}}).sort({receivedTime:1}).pretty() 

db.carInfo217361300000280.find({"receivedTime":{$gte:1510960980000,$lte:1510963980000}}).sort({receivedTime:1}).pretty() 

db.carInfo217361300000280.find().count()

db.carInfo217361300000280.find().sort({receivedTime:-1}).limit(1).pretty()
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

##### 查看最近15分钟内的服务状态  
db.serverStatus()  
上面的分析结果中包含支持的最大连接数，db.serverStatus().connections.available  
```
db.serverStatus().connections.available
{
	"host" : "iZ2zecl4i8oy1rs7r025p8Z",
	"version" : "3.4.3",
	"process" : "mongod",
	"pid" : NumberLong(1295),
	"uptime" : 1856726,
	"uptimeMillis" : NumberLong(1856726501),
	"uptimeEstimate" : NumberLong(1856726),
	"localTime" : ISODate("2017-10-16T03:07:55.553Z"),
	"asserts" : {
		"regular" : 0,
		"warning" : 0,
		"msg" : 0,
		"user" : 94,
		"rollovers" : 0
	},
	"connections" : {
		"current" : 35,
		"available" : 2365,
		"totalCreated" : 434
	},
	"extra_info" : {
		"note" : "fields vary by platform",
		"page_faults" : 336
	},
	"globalLock" : {
		"totalTime" : NumberLong("1856726388000"),
		"currentQueue" : {
			"total" : 0,
			"readers" : 0,
			"writers" : 0
		},
		"activeClients" : {
			"total" : 41,
			"readers" : 0,
			"writers" : 0
		}
	},
	"locks" : {
		"Global" : {
			"acquireCount" : {
				"r" : NumberLong(156125525),
				"w" : NumberLong(621572),
				"W" : NumberLong(7)
			}
		},
		"Database" : {
			"acquireCount" : {
				"r" : NumberLong(77751620),
				"w" : NumberLong(414229),
				"R" : NumberLong(244),
				"W" : NumberLong(207343)
			},
			"acquireWaitCount" : {
				"r" : NumberLong(2437),
				"w" : NumberLong(3482),
				"W" : NumberLong(15905)
			},
			"timeAcquiringMicros" : {
				"r" : NumberLong(38427998),
				"w" : NumberLong(77632698),
				"W" : NumberLong(55784913)
			}
		},
		"Collection" : {
			"acquireCount" : {
				"r" : NumberLong(77751311),
				"w" : NumberLong(414613)
			}
		},
		"Metadata" : {
			"acquireCount" : {
				"w" : NumberLong(1)
			}
		}
	},
	"network" : {
		"bytesIn" : NumberLong(346126162),
		"bytesOut" : NumberLong(736578774),
		"physicalBytesIn" : NumberLong(346126162),
		"physicalBytesOut" : NumberLong(736398071),
		"numRequests" : NumberLong(4857872)
	},
	"opLatencies" : {
		"reads" : {
			"latency" : NumberLong(240900550),
			"ops" : NumberLong(1618855)
		},
		"writes" : {
			"latency" : NumberLong(143673483),
			"ops" : NumberLong(413783)
		},
		"commands" : {
			"latency" : NumberLong(58571333),
			"ops" : NumberLong(396300)
		}
	},
	"opcounters" : {
		"insert" : 413783,
		"query" : 1618731,
		"update" : 0,
		"delete" : 0,
		"getmore" : 79,
		"command" : 396342
	},
	"opcountersRepl" : {
		"insert" : 0,
		"query" : 0,
		"update" : 0,
		"delete" : 0,
		"getmore" : 0,
		"command" : 0
	},
	"storageEngine" : {
		"name" : "wiredTiger",
		"supportsCommittedReads" : true,
		"readOnly" : false,
		"persistent" : true
	},
	"tcmalloc" : {
		"generic" : {
			"current_allocated_bytes" : 228622552,
			"heap_size" : 299442176
		},
		"tcmalloc" : {
			"pageheap_free_bytes" : 59752448,
			"pageheap_unmapped_bytes" : 2199552,
			"max_total_thread_cache_bytes" : 1031798784,
			"current_total_thread_cache_bytes" : 4312512,
			"total_free_bytes" : 8867624,
			"central_cache_free_bytes" : 2898568,
			"transfer_cache_free_bytes" : 1656544,
			"thread_cache_free_bytes" : 4312512,
			"aggressive_memory_decommit" : 0,
			"formattedString" : "------------------------------------------------\nMALLOC:      228622552 (  218.0 MiB) Bytes in use by application\nMALLOC: +     59752448 (   57.0 MiB) Bytes in page heap freelist\nMALLOC: +      2898568 (    2.8 MiB) Bytes in central cache freelist\nMALLOC: +      1656544 (    1.6 MiB) Bytes in transfer cache freelist\nMALLOC: +      4312512 (    4.1 MiB) Bytes in thread cache freelists\nMALLOC: +      2810048 (    2.7 MiB) Bytes in malloc metadata\nMALLOC:   ------------\nMALLOC: =    300052672 (  286.2 MiB) Actual memory used (physical + swap)\nMALLOC: +      2199552 (    2.1 MiB) Bytes released to OS (aka unmapped)\nMALLOC:   ------------\nMALLOC: =    302252224 (  288.3 MiB) Virtual address space used\nMALLOC:\nMALLOC:          22235              Spans in use\nMALLOC:             46              Thread heaps in use\nMALLOC:           4096              Tcmalloc page size\n------------------------------------------------\nCall ReleaseFreeMemory() to release freelist memory to the OS (via madvise()).\nBytes released to the OS take up virtual address space but no physical memory.\n"
		}
	},
	"wiredTiger" : {
		"uri" : "statistics:",
		"LSM" : {
			"application work units currently queued" : 0,
			"merge work units currently queued" : 0,
			"rows merged in an LSM tree" : 0,
			"sleep for LSM checkpoint throttle" : 0,
			"sleep for LSM merge throttle" : 0,
			"switch work units currently queued" : 0,
			"tree maintenance operations discarded" : 0,
			"tree maintenance operations executed" : 0,
			"tree maintenance operations scheduled" : 0,
			"tree queue hit maximum" : 0
		},
		"async" : {
			"current work queue length" : 0,
			"maximum work queue length" : 0,
			"number of allocation state races" : 0,
			"number of flush calls" : 0,
			"number of operation slots viewed for allocation" : 0,
			"number of times operation allocation failed" : 0,
			"number of times worker found no work" : 0,
			"total allocations" : 0,
			"total compact calls" : 0,
			"total insert calls" : 0,
			"total remove calls" : 0,
			"total search calls" : 0,
			"total update calls" : 0
		},
		"block-manager" : {
			"blocks pre-loaded" : 656,
			"blocks read" : 544104,
			"blocks written" : 2316533,
			"bytes read" : 2228654080,
			"bytes written" : 14149353472,
			"bytes written for checkpoint" : 14147780608,
			"mapped blocks read" : 0,
			"mapped bytes read" : 0
		},
		"cache" : {
			"application threads page read from disk to cache count" : 644,
			"application threads page read from disk to cache time (usecs)" : 238452,
			"application threads page write from cache to disk count" : 768,
			"application threads page write from cache to disk time (usecs)" : 36529,
			"bytes belonging to page images in the cache" : 71589,
			"bytes currently in the cache" : 132863932,
			"bytes not belonging to page images in the cache" : 132792342,
			"bytes read into cache" : 426992,
			"bytes written from cache" : 8382912672,
			"checkpoint blocked page eviction" : 0,
			"eviction calls to get a page" : 151634,
			"eviction calls to get a page found queue empty" : 151656,
			"eviction calls to get a page found queue empty after locking" : 0,
			"eviction currently operating in aggressive mode" : 0,
			"eviction empty score" : 0,
			"eviction server candidate queue empty when topping up" : 0,
			"eviction server candidate queue not empty when topping up" : 0,
			"eviction server evicting pages" : 0,
			"eviction server slept, because we did not make progress with eviction" : 0,
			"eviction server unable to reach eviction goal" : 0,
			"eviction state" : 16,
			"eviction walks abandoned" : 0,
			"eviction worker thread active" : 4,
			"eviction worker thread created" : 0,
			"eviction worker thread evicting pages" : 0,
			"eviction worker thread removed" : 0,
			"eviction worker thread stable number" : 4,
			"failed eviction of pages that exceeded the in-memory maximum" : 0,
			"files with active eviction walks" : 0,
			"files with new eviction walks started" : 0,
			"hazard pointer blocked page eviction" : 0,
			"hazard pointer check calls" : 6,
			"hazard pointer check entries walked" : 0,
			"hazard pointer maximum array length" : 0,
			"in-memory page passed criteria to be split" : 12,
			"in-memory page splits" : 6,
			"internal pages evicted" : 0,
			"internal pages split during eviction" : 0,
			"leaf pages split during eviction" : 0,
			"lookaside table insert calls" : 0,
			"lookaside table remove calls" : 0,
			"maximum bytes configured" : 3590324224,
			"maximum page size at eviction" : 0,
			"modified pages evicted" : 768,
			"modified pages evicted by application threads" : 0,
			"overflow pages read into cache" : 0,
			"overflow values cached in memory" : 0,
			"page split during eviction deepened the tree" : 0,
			"page written requiring lookaside records" : 0,
			"pages currently held in the cache" : 1149,
			"pages evicted because they exceeded the in-memory maximum" : 6,
			"pages evicted because they had chains of deleted items" : 0,
			"pages evicted by application threads" : 0,
			"pages queued for eviction" : 0,
			"pages queued for urgent eviction" : 0,
			"pages queued for urgent eviction during walk" : 0,
			"pages read into cache" : 1301,
			"pages read into cache requiring lookaside entries" : 0,
			"pages requested from the cache" : 13259824,
			"pages seen by eviction walk" : 0,
			"pages selected for eviction unable to be evicted" : 0,
			"pages walked for eviction" : 0,
			"pages written from cache" : 1230277,
			"pages written requiring in-memory restoration" : 0,
			"percentage overhead" : 8,
			"tracked bytes belonging to internal pages in the cache" : 1124386,
			"tracked bytes belonging to leaf pages in the cache" : 131739546,
			"tracked dirty bytes in the cache" : 8121211,
			"tracked dirty pages in the cache" : 7,
			"unmodified pages evicted" : 0
		},
		"connection" : {
			"auto adjusting condition resets" : 640917,
			"auto adjusting condition wait calls" : 11893354,
			"files currently open" : 574,
			"memory allocations" : 139945314,
			"memory frees" : 138011304,
			"memory re-allocations" : 7459948,
			"pthread mutex condition wait calls" : 30825193,
			"pthread mutex shared lock read-lock calls" : 52397675,
			"pthread mutex shared lock write-lock calls" : 34868117,
			"total fsync I/Os" : 706420,
			"total read I/Os" : 573767,
			"total write I/Os" : 2470836
		},
		"cursor" : {
			"cursor create calls" : 41337,
			"cursor insert calls" : 1747877,
			"cursor next calls" : 1602300,
			"cursor prev calls" : 45582,
			"cursor remove calls" : 1915,
			"cursor reset calls" : 13063993,
			"cursor restarted searches" : 1394,
			"cursor search calls" : 10064921,
			"cursor search near calls" : 1599358,
			"cursor update calls" : 0,
			"truncate calls" : 0
		},
		"data-handle" : {
			"connection data handles currently active" : 699,
			"connection sweep candidate became referenced" : 0,
			"connection sweep dhandles closed" : 859,
			"connection sweep dhandles removed from hash list" : 7190388,
			"connection sweep time-of-death sets" : 7192363,
			"connection sweeps" : 185668,
			"session dhandles swept" : 4620,
			"session sweep attempts" : 16478
		},
		"lock" : {
			"checkpoint lock acquisitions" : 13420,
			"checkpoint lock application thread wait time (usecs)" : 0,
			"checkpoint lock internal thread wait time (usecs)" : 164,
			"handle-list lock eviction thread wait time (usecs)" : 266421,
			"metadata lock acquisitions" : 13420,
			"metadata lock application thread wait time (usecs)" : 0,
			"metadata lock internal thread wait time (usecs)" : 477,
			"schema lock acquisitions" : 16689,
			"schema lock application thread wait time (usecs)" : 890095,
			"schema lock internal thread wait time (usecs)" : 158,
			"table lock acquisitions" : 0,
			"table lock application thread time waiting for the table lock (usecs)" : 0,
			"table lock internal thread time waiting for the table lock (usecs)" : 0
		},
		"log" : {
			"busy returns attempting to switch slots" : 0,
			"consolidated slot closures" : 139720,
			"consolidated slot join races" : 14736,
			"consolidated slot join transitions" : 139720,
			"consolidated slot joins" : 458203,
			"consolidated slot unbuffered writes" : 0,
			"log bytes of payload data" : 160930259,
			"log bytes written" : 192294784,
			"log files manually zero-filled" : 0,
			"log flush operations" : 18546000,
			"log force write operations" : 20686604,
			"log force write operations skipped" : 20561972,
			"log records compressed" : 23424,
			"log records not compressed" : 417128,
			"log records too small to compress" : 17590,
			"log release advances write LSN" : 15099,
			"log scan operations" : 5,
			"log scan records requiring two reads" : 0,
			"log server thread advances write LSN" : 124621,
			"log server thread write LSN walk skipped" : 2530098,
			"log sync operations" : 134700,
			"log sync time duration (usecs)" : 383410892,
			"log sync_dir operations" : 2,
			"log sync_dir time duration (usecs)" : 6950,
			"log write operations" : 458025,
			"logging bytes consolidated" : 192545920,
			"maximum log file size" : 104857600,
			"number of pre-allocated log files to create" : 2,
			"pre-allocated log files not ready and missed" : 1,
			"pre-allocated log files prepared" : 3,
			"pre-allocated log files used" : 1,
			"records processed by log scan" : 10,
			"total in-memory size of compressed records" : 549989633,
			"total log buffer size" : 33554432,
			"total size of compressed records" : 70610360,
			"written slots coalesced" : 0,
			"yields waiting for previous log file close" : 0
		},
		"reconciliation" : {
			"fast-path pages deleted" : 0,
			"page reconciliation calls" : 1103506,
			"page reconciliation calls for eviction" : 384,
			"pages deleted" : 0,
			"split bytes currently awaiting free" : 0,
			"split objects currently awaiting free" : 0
		},
		"session" : {
			"open cursor count" : 3049,
			"open session count" : 30,
			"table alter failed calls" : 0,
			"table alter successful calls" : 0,
			"table alter unchanged and skipped" : 0,
			"table compact failed calls" : 0,
			"table compact successful calls" : 0,
			"table create failed calls" : 0,
			"table create successful calls" : 1158,
			"table drop failed calls" : 473,
			"table drop successful calls" : 574,
			"table rebalance failed calls" : 0,
			"table rebalance successful calls" : 0,
			"table rename failed calls" : 0,
			"table rename successful calls" : 0,
			"table salvage failed calls" : 0,
			"table salvage successful calls" : 0,
			"table truncate failed calls" : 0,
			"table truncate successful calls" : 0,
			"table verify failed calls" : 0,
			"table verify successful calls" : 0
		},
		"thread-state" : {
			"active filesystem fsync calls" : 0,
			"active filesystem read calls" : 0,
			"active filesystem write calls" : 0
		},
		"thread-yield" : {
			"application thread time evicting (usecs)" : 0,
			"application thread time waiting for cache (usecs)" : 0,
			"page acquire busy blocked" : 0,
			"page acquire eviction blocked" : 0,
			"page acquire locked blocked" : 3,
			"page acquire read blocked" : 101,
			"page acquire time sleeping (usecs)" : 202000
		},
		"transaction" : {
			"number of named snapshots created" : 0,
			"number of named snapshots dropped" : 0,
			"transaction begins" : 2025035,
			"transaction checkpoint currently running" : 0,
			"transaction checkpoint generation" : 13420,
			"transaction checkpoint max time (msecs)" : 1308,
			"transaction checkpoint min time (msecs)" : 6,
			"transaction checkpoint most recent time (msecs)" : 267,
			"transaction checkpoint scrub dirty target" : 0,
			"transaction checkpoint scrub time (msecs)" : 0,
			"transaction checkpoint total time (msecs)" : 1760575,
			"transaction checkpoints" : 13420,
			"transaction checkpoints skipped because database was clean" : 17496,
			"transaction failures due to cache overflow" : 0,
			"transaction fsync calls for checkpoint after allocating the transaction ID" : 13420,
			"transaction fsync duration for checkpoint after allocating the transaction ID (usecs)" : 182643,
			"transaction range of IDs currently pinned" : 0,
			"transaction range of IDs currently pinned by a checkpoint" : 0,
			"transaction range of IDs currently pinned by named snapshots" : 0,
			"transaction sync calls" : 0,
			"transactions committed" : 425664,
			"transactions rolled back" : 1600921
		},
		"concurrentTransactions" : {
			"write" : {
				"out" : 0,
				"available" : 128,
				"totalTickets" : 128
			},
			"read" : {
				"out" : 0,
				"available" : 128,
				"totalTickets" : 128
			}
		}
	},
	"mem" : {
		"bits" : 64,
		"resident" : 268,
		"virtual" : 608,
		"supported" : true,
		"mapped" : 0,
		"mappedWithJournal" : 0
	},
	"metrics" : {
		"commands" : {
			"buildInfo" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(204)
			},
			"collStats" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(44)
			},
			"count" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(46)
			},
			"createIndexes" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(206891)
			},
			"dbStats" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(229)
			},
			"dropDatabase" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(2)
			},
			"find" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(1618730)
			},
			"getLastError" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(136)
			},
			"getLog" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(21)
			},
			"getMore" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(79)
			},
			"getnonce" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(3)
			},
			"insert" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(413783)
			},
			"isMaster" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(186354)
			},
			"listCollections" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(13)
			},
			"listDatabases" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(109)
			},
			"ping" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(80)
			},
			"replSetGetStatus" : {
				"failed" : NumberLong(24),
				"total" : NumberLong(24)
			},
			"serverStatus" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(1831)
			},
			"top" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(282)
			},
			"whatsmyuri" : {
				"failed" : NumberLong(0),
				"total" : NumberLong(73)
			}
		},
		"cursor" : {
			"timedOut" : NumberLong(5),
			"open" : {
				"noTimeout" : NumberLong(0),
				"pinned" : NumberLong(0),
				"total" : NumberLong(0)
			}
		},
		"document" : {
			"deleted" : NumberLong(0),
			"inserted" : NumberLong(413783),
			"returned" : NumberLong(1653117),
			"updated" : NumberLong(0)
		},
		"getLastError" : {
			"wtime" : {
				"num" : 0,
				"totalMillis" : 0
			},
			"wtimeouts" : NumberLong(0)
		},
		"operation" : {
			"scanAndOrder" : NumberLong(0),
			"writeConflicts" : NumberLong(0)
		},
		"queryExecutor" : {
			"scanned" : NumberLong(1540130),
			"scannedObjects" : NumberLong(1653301)
		},
		"record" : {
			"moves" : NumberLong(0)
		},
		"repl" : {
			"executor" : {
				"counters" : {
					"eventCreated" : 0,
					"eventWait" : 0,
					"cancels" : 0,
					"waits" : 0,
					"scheduledNetCmd" : 0,
					"scheduledDBWork" : 0,
					"scheduledXclWork" : 0,
					"scheduledWorkAt" : 0,
					"scheduledWork" : 0,
					"schedulingFailures" : 0
				},
				"queues" : {
					"networkInProgress" : 0,
					"dbWorkInProgress" : 0,
					"exclusiveInProgress" : 0,
					"sleepers" : 0,
					"ready" : 0,
					"free" : 0
				},
				"unsignaledEvents" : 0,
				"eventWaiters" : 0,
				"shuttingDown" : false,
				"networkInterface" : "\nNetworkInterfaceASIO Operations' Diagnostic:\nOperation:    Count:   \nConnecting    0        \nIn Progress   0        \nSucceeded     0        \nCanceled      0        \nFailed        0        \nTimed Out     0        \n\n"
			},
			"apply" : {
				"attemptsToBecomeSecondary" : NumberLong(0),
				"batches" : {
					"num" : 0,
					"totalMillis" : 0
				},
				"ops" : NumberLong(0)
			},
			"buffer" : {
				"count" : NumberLong(0),
				"maxSizeBytes" : NumberLong(0),
				"sizeBytes" : NumberLong(0)
			},
			"initialSync" : {
				"completed" : NumberLong(0),
				"failedAttempts" : NumberLong(0),
				"failures" : NumberLong(0)
			},
			"network" : {
				"bytes" : NumberLong(0),
				"getmores" : {
					"num" : 0,
					"totalMillis" : 0
				},
				"ops" : NumberLong(0),
				"readersCreated" : NumberLong(0)
			},
			"preload" : {
				"docs" : {
					"num" : 0,
					"totalMillis" : 0
				},
				"indexes" : {
					"num" : 0,
					"totalMillis" : 0
				}
			}
		},
		"storage" : {
			"freelist" : {
				"search" : {
					"bucketExhausted" : NumberLong(0),
					"requests" : NumberLong(0),
					"scanned" : NumberLong(0)
				}
			}
		},
		"ttl" : {
			"deletedDocuments" : NumberLong(0),
			"passes" : NumberLong(30945)
		}
	},
	"ok" : 1
}

```
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
> getmore：每秒执行getmore次数(查询时游标的getmore操作)  
> flushes  mongod将数据刷新到磁盘的次数  
> command：一秒钟执行的命令数。如批量插入，只认为是一条命令，意义不大。  
> dirty：这个是Wried Tiger引擎所特有的参数，数值是缓存中无效数据所占的百分比.  
> used:这个是WriedTiger引擎所特有的参数，数值是正在使用的缓存百分比。  
> vsize     mongod正在使用的虚拟内存的大小，通常为数据目录的2倍大小（一次用于映射文件，一次用于日记系统）  
> res        mongod正在使用的内存的大小，通常该值应该尽量接近机器所有内存的大小。  
> qr | qw  读写操作队列大小，即有多少读写操作被阻塞，等待进行处理。  
> ar | aw  活动客户端的数量，即正在进行读写操作的客户端。  
> netIn     通过网络传输进来的字节数。  
> netOut  通过网络传输出去的字节数。  
> conn     此服务器打开的连接数，包括输入和输出的连接。  