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