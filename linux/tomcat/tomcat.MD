### 在tomcat-users.xml文件中添加tomcat的管理员账户
```
<role rolename="manager"/>
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>

<role rolename="manager-status"/>
<role rolename="admin"/>
<user username="admin" password="admin" roles="admin,manager,manager-script,manager-gui,manager-jmx,manager-status"/>
```
--------------------------------------------------------------------------------------
tomcat 参数
-server

minSpareThreads    Tomcat初始化时创建的线程数
maxSpareThreads     一旦创建的线程超过这个值,Tomcat就会关闭不再需要的socket线程

<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"    --NIO模型
           connectionTimeout="20000"   --连接超时时间
           redirectPort="8443"
           maxThreads="500"     --最多运行线程数
           minSpareThreads="20"  --初始化创建的线程数
           acceptCount="100"   --监听端口队列最大数 超过这个数的请求将不予处理
           disableUploadTimeout="true"
           enableLookups="false"    --停用DNS查询
           URIEncoding="UTF-8" />

--------------------------------------------------------------------------------------
tomcat
 Bootstrap
    |
  System
    |
   Common
  /     \
Webapp1   Webapp2

从 Web 应用的角度来看,加载类或资源时,要查看的仓库及其顺序如下：
JVM 的 Bootstrap 类
Web 应用的 /WEB-INF/classes 类
Web 应用的 /WEB-INF/lib/*.jar 类
System 类加载器的类（如上所述）
Common 类加载器的类（如上所述）

如果 Web 应用类加载器配置有 <Loader delegate="true"/>,则顺序变为：
JVM 的 Bootstrap 类
System 类加载器的类（如上所述）
Common 类加载器的类（如上所述）
Web 应用的 /WEB-INF/classes 类
Web 应用的 /WEB-INF/lib/*.jar 类
--------------------------------------------------------------------------------------
tomcat中如何禁止和允许主机或IP地址访问
```
<Host name="localhost" ...>
  <Valve className="org.apache.catalina.valves.RemoteHostValve"
         allow="*.mycompany.com,www.yourcompany.com"/>
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         deny="192.168.1.*"/>
</Host>
```
--------------------------------------------------------------------------------------
tomcat中如何禁止和允许列目录下的文档
在{tomcat_home}/conf/web.xml中，把listings参数配置成false即可，如下：
```
<servlet>
   <init-param>
     <param-name>listings</param-name>
     <param-value>false</param-value>
   </init-param>
</servlet>
```
--------------------------------------------------------------------------------------
Tomcat的session过期时间修改
 修改conf\web.xml
 ```
<session-config>
    <!-- 单位：分钟 -->
    <session-timeout>180</session-timeout>
</session-config>
 ```
--------------------------------------------------------------------------------------
### linux下解压tomcat后执行startup.sh提示没有权限
apache-tomcat-7.0.59/bin下执行  
chmod 777 *.sh  
## 设置tomcat自动启动
[linux教程：[4]配置Tomcat开机启动](http://jingyan.baidu.com/article/6525d4b1382f0aac7d2e9421.html)  
[Linux下chkconfig命令详解](http://www.cnblogs.com/panjun-Donet/archive/2010/08/10/1796873.html)  
[服务不支持chkconfig的解决](http://blog.chinaunix.net/uid-10697776-id-3187846.html)  

### spring boot 项目启动脚本加入开机启动项中

/opt/script/autostart.sh

```shell
#!/bin/sh
#description: auto_run
export JAVA_HOME=/usr/local/java/jdk1.8.0_181
export CLASSPATH=$JAVA_HOME/lib/
export PATH=$PATH:$JAVA_HOME/bin
rm -f /home/dison/tag/pid_tag.pid
/home/dison/tag/start-tag.sh

```

chmod +x /etc/rc.d/rc.local

在/etc/rc.d/rc.local文件中加入下面这句

/opt/script/autostart.sh