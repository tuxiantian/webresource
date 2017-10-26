我写的第一个Linux脚本。主要功能是备份重启看日志，使用脚本减少发布出错的可能性。
```
#!/bin/sh


filename="com.`date +%Y%m%d%H%M%S`.tar.gz"
tar zcvf $filename /home/tomcat/tomcat_test/webapps/ROOT/WEB-INF/classes/com
mv  $filename /home/tomcat/tomcat_test/webapps/ROOT/WEB-INF/classes
kill -9 $(ps aux | grep tomcat_test | awk '{print $2}')
rm -rf /home/tomcat/tomcat_test/webapps/ROOT/WEB-INF/classes/com
cp -r /home/tomcat/publish/file/com /home/tomcat/tomcat_test/webapps/ROOT/WEB-INF/classes/
sh /home/tomcat/tomcat_test/bin/startup.sh
tail -200f /home/tomcat/tomcat_test/logs/catalina.out

```