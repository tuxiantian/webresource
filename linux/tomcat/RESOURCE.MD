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