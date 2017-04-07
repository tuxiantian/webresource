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