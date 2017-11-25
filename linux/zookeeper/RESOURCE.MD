## 常用命令
启动ZK服务:        bin/zkServer.sh start  
查看ZK服务状态:  bin/zkServer.sh status  
停止ZK服务:        bin/zkServer.sh stop  
重启ZK服务:        bin/zkServer.sh restart  
连接服务器          zkCli.sh -server 127.0.0.1:2181  
查看根目录 ls /
创建 testnode节点，关联字符串"zz"         create /zk/testnode "zz"  
查看节点内容  get /zk/testnode  
设置节点内容  set /zk/testnode abc  
删除节点      delete /zk/testnode  
## centOS设置zookeeper开机自动启动
在/etc/rc.local文件中追加：  
/home/cent2014/zookeeper/zookeeper-3.4.6/bin/zkServer.sh start
nexus的开机自启动与此相似。