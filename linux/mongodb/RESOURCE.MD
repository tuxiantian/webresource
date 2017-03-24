mongodb监控
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
--------------------------------------------------------------------------------------
mongodb默认端口 27017
--------------------------------------------------------------------------------------
mongodb不支持Timestamp
--------------------------------------------------------------------------------------