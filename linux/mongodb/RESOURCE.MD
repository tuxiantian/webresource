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
#### MongoDB学习文档
http://www.runoob.com/mongodb/mongodb-window-install.html
mongodb官网       http://docs.mongoing.com/manual-zh/sharding.html