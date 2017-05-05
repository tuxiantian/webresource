### spring-task
```
<task:scheduled-tasks>  
    <task:scheduled ref="voiceFileClearJob" method="execute" initial-delay="5000" fixed-delay="3600000"/>  
    <task:scheduled ref="versionListenJob" method="execute" initial-delay="5000" fixed-delay="5000"/>  
    <task:scheduled ref="statJob" method="statLgj" cron="0 59 23 * * ?"/>  
    <task:scheduled ref="statJob" method="statBadNameAndQQ" cron="23 28 20 * * ?"/>  
</task:scheduled-tasks>  
```
第一个任务表示程序启动5s后调用voiceFileClearJob类中的execute方法，然后每隔一个小时再调用execute一次  
第三个任务表示每天的23点59分调用statJob类中的statLgj方法  


ref是工作类  
method是工作类中要执行的方法  
initial-delay是任务第一次被调用前的延时，单位`毫秒`  
fixed-delay是上一个调用完成后再次调用的延时  
fixed-rate是上一个调用开始后再次调用的延时（不用等待上一次调用完成）  
cron是表达式，表示在什么时候进行任务调度。  

cron表达式：  

一个cron表达式有至少6个（也可能7个）有空格分隔的时间元素。  
按顺序依次为  
秒（0~59）  
分钟（0~59）  
小时（0~23）  
天（月）（0~31，但是你需要考虑你月的天数）  
月（0~11）  
天（星期）（1~7 1=SUN 或 SUN，MON，TUE，WED，THU，FRI，SAT）  
年份（1970－2099）  

其中每个元素可以是一个值(如6),一个连续区间(9-12),一个间隔时间(8-18/4)(/表示每隔4小时),一个列表(1,3,5),通配符。由于"月份中的日期"和"星期中的日期"这两个元素互斥的,必须要对其中一个设置?.

0 0 10,14,16 * * ? 每天上午10点，下午2点，4点  
0 0/30 9-17 * * ?   朝九晚五工作时间内每半小时  
0 0 12 ? * WED 表示每个星期三中午12点  
"0 0 12 * * ?" 每天中午12点触发  
"0 15 10 ? * *" 每天上午10:15触发  
"0 15 10 * * ?" 每天上午10:15触发  
"0 15 10 * * ? *" 每天上午10:15触发  
"0 15 10 * * ? 2005" 2005年的每天上午10:15触发  
"0 * 14 * * ?" 在每天下午2点到下午2:59期间的每1分钟触发  
"0 0/5 14 * * ?" 在每天下午2点到下午2:55期间的每5分钟触发  
"0 0/5 14,18 * * ?" 在每天下午2点到2:55期间和下午6点到6:55期间的每5分钟触发  
"0 0-5 14 * * ?" 在每天下午2点到下午2:05期间的每1分钟触发  
"0 10,44 14 ? 3 WED" 每年三月的星期三的下午2:10和2:44触发  
"0 15 10 ? * MON-FRI" 周一至周五的上午10:15触发  
"0 15 10 15 * ?" 每月15日上午10:15触发  
"0 15 10 L * ?" 每月最后一日的上午10:15触发  
"0 15 10 ? * 6L" 每月的最后一个星期五上午10:15触发  
"0 15 10 ? * 6L 2002-2005" 2002年至2005年的每月的最后一个星期五上午10:15触发  
"0 15 10 ? * 6#3" 每月的第三个星期五上午10:15触发  

有些子表达式能包含一些范围或列表  
例如：子表达式（天（星期） ）可以为 “MON-FRI”，“MON，WED，FRI”，“MON-WED,SAT”  

“*”字符代表所有可能的值  
因此，“*”在子表达式（月 ）里表示每个月的含义，“*”在子表达式（天（星期） ）表示星期的每一天  

“/”字符用来指定数值的增量  
例如：在子表达式（分钟）里的“0/15”表示从第0分钟开始，每15分钟  
在子表达式（分钟）里的“3/20”表示从第3分钟开始，每20分钟（它和“3，23，43”）的含义一样  

“？”字符仅被用于天（月）和天（星期）两个子表达式，表示不指定值
当2个子表达式其中之一被指定了值以后，为了避免冲突，需要将另一个子表达式的值设为“？”  
“L” 字符仅被用于天（月）和天（星期）两个子表达式，它是单词“last”的缩写  
但是它在两个子表达式里的含义是不同的。  
在天（月）子表达式中，“L”表示一个月的最后一天  
在天（星期）自表达式中，“L”表示一个星期的最后一天，也就是SAT  
如果在“L”前有具体的内容，它就具有其他的含义了  
例如：“6L”表示这个月的倒数第６天，“ＦＲＩＬ”表示这个月的最一个星期五  
注意：在使用“L”参数时，不要指定列表或范围，因为这会导致问题  

|字段	 	   |允许值	 	        |允许的特殊字符              |
|----------- | :---------------:|--------------------------:|
|秒 	        | 0-59 	           |   , - * /                 |
|分 	        | 0-59 	           |   , - * /                 |
|小时 	   |0-23 	          |    , - * /                |
|日期 	   |1-31 	          |   , - * ? / L W C         |
|月份 	   |1-12 或者 JAN-DEC |    , - * /                |
|星期 	   |1-7 或者 SUN-SAT  |    , - * ? / L C #        |
|年（可选）  |留空, 1970-2099    |   , - * /                 |

ApplicationContext ctx = new ClassPathXmlApplicationContext("beans.xml");  
FileSystemXmlApplicationContext
--------------------------------------------------------------------------------------
Spring 切面可以应用五种类型的通知：  
    * before ：前置通知，在一个方法执行前被调用  
    * after:  在方法执行之后调用的通知，无论方法执行是否成功  
    * after-returning:  仅当方法成功完成后执行的通知  
    * after-throwing:  在方法抛出异常退出时执行的通知  
    * around:  在方法执行之前和之后调用的通知  
--------------------------------------------------------------------------------------
Spring 支持两种类型的事务管理：  
编程式事务管理  
声明式事务管理  
--------------------------------------------------------------------------------------
spring命名空间：context、beans、jdbc、tx、aop
--------------------------------------------------------------------------------------
spring mvc异常统一处理（ControllerAdvice注解）
> https://my.oschina.net/gef/blog/713722
--------------------------------------------------------------------------------------
spring mvc 静态资源
```
<mvc:resources location="/WEB-INF/resources/**" mapping="/resources/**" />
```
Spring MVC 的运行流程
DispatcherServlet 前置控制器,处于核心位置，负责协调和组织不同组件以完成请求处理并返回响应的工作
SpringMVC 处理请求过程：
1. spring mvc请所有的请求都提交给DispatcherServlet,它会委托应用系统的其他模块负责负责对请求进行真正的处理工作
2. DispatcherServlet查询一个或多个HandlerMapping,找到处理请求的Controller.
3. DispatcherServlet请请求提交到目标Controller
4. Controller进行业务逻辑处理后，会返回一个ModelAndView
5. Dispathcher查询一个或多个ViewResolver视图解析器,找到ModelAndView对象指定的视图对象
6. 视图对象负责渲染返回给客户端

web.xml中springmvc的启动配置
```
<servlet>
      <servlet-name>springmvc</servlet-name>
      <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
      <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:springmvc-servlet.xml</param-value>
      </init-param>
      <!-- <load-on-startup>1</load-on-startup> -->
  </servlet>

<servlet-mapping>
      <servlet-name>springmvc</servlet-name>
      <url-pattern>/</url-pattern>
</servlet-mapping>

<url-pattern>/</url-pattern>：会匹配到/springmvc这样的路径型url，不会匹配到模式为*.jsp这样的后缀型url
<url-pattern>/*</url-pattern>：会匹配所有的url
```
<!-- 监听spring上下文容器 -->
 ```
<listener>
     <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
 </listener>
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:applicationContext.xml</param-value>
</context-param>
```
视图名称解析器和文件上传解析器
```
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver"
            id="internalResourceViewResolver">
        <!-- 前缀 -->
        <property name="prefix" value="/WEB-INF/jsp/" />
        <!-- 后缀 -->
        <property name="suffix" value=".jsp" />
</bean>

<!-- SpringMVC上传文件时，需要配置MultipartResolver处理器 -->
<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
      <property name="defaultEncoding" value="UTF-8"/>
      <!-- 指定所上传文件的总大小不能超过200KB 所有文件的容量之和 -->
      <property name="maxUploadSize" value="200000"/>
</bean>
```
--------------------------------------------------------------------------------------
JAX-RS常用注解：
@Path：标注资源类或方法的相对路径  
@GET、@PUT、@POST、@DELETE：标注方法的HTTP请求类型  
@Produces：标注返回的MIME媒体类型  
@Consumes：标注可接受请求的MIME媒体类型  
@FormParam：标注方法的参数来自于HTTP请求的位置一般用在Post方法中  
@PathParam来自于URL的路径  
@QueryParam来自于URL的查询参数  
@HeaderParam来自于HTTP请求的头信息  
@CookieParam来自于HTTP请求的Cookie  
```
@GET
@Path("/books/{id}/")
@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
public Book getBook(@PathParam("id") String id){
  return books.get(id);
}

@POST
@Path("/createUser")
@Consumes("application/x-www-form-urlencoded")
public void createUser(@FormParam("loginID") String loginID, @FormParam("name") String name,
    @FormParam("email") String email) throws Exception {
}
Jersey RESTful 框架是开源的RESTful框架
```
--------------------------------------------------------------------------------------
```
@RestController 返回的 json 不包含值为 null 的字段
<mvc:annotation-driven>
	<mvc:message-converters>
		<bean class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter">
			<property name="objectMapper">
				<bean class="com.fasterxml.jackson.databind.ObjectMapper">
					<property name="serializationInclusion" value="NON_NULL"/>
				</bean>
			</property>
		</bean>
	</mvc:message-converters>
</mvc:annotation-driven>
```
--------------------------------------------------------------------------------------
springmvc文件上传配置
```
<bean id="multipartResolver"
          class="org.springframework.web.multipart.commons.CommonsMultipartResolver"
          p:defaultEncoding="UTF-8"
          p:maxUploadSize="10485760"
          p:uploadTempDir="WEB-INF/upload/temp"/>
```
--------------------------------------------------------------------------------------
Spring提供了以下四种集合类的配置元素：  
`<list>` :   该标签用来装配可重复的list值  
`<set>` :    该标签用来装配没有重复的set值  
`<map>`:   该标签可用来注入键和值可以为任何类型的键值对  
`<props>` : 该标签支持注入键和值都是字符串类型的键值对  
```
<property name="customMap">
        <map>
           <entry key="1" value="INDIA"/>
        </map>
</property>

<property name="customProperies">
    <props>
        <prop key="admin">admin@nospam.com</prop>
    </props>
</property>


<util:list id="strArray">
  <value>Hello</value>
</util:list>
<util:set set-class="java.util.HashSet">
    <value>1</value>
</util:set>
<util:map id="map" map-class="java.util.HashMap" >
   <entry key="key1" value-ref="some1"/>
</util:map>
<util:properties id="config" location="classpath:/config.properties">
    <prop key="jdbc.prop1">JDBC Properties 1</prop>
</util:properties>
```
设值注入和构造注入示例
```
<bean id="people" class="com.abc.People">
　　 <property name="name" value="张三" /> <!-- 设值注入 -->
　　 <property name="school" ref="school" />
　　 <property name="age" value="20" type="int" />
</bean>
<bean id="people" class="com.abc.People">
    <!-- 构造注入,index=0表示构造器的第一个参数 -->
　　 <constructor-arg index="0" value="张三"/> <!-- 构造注入 -->
　　 <constructor-arg index="1" ref="school" />
　　 <constructor-arg index="2" value="20" type="int" />
</bean>
```

循环依赖就是循环引用,两个或多个Bean相互之间的持有对方,比如CircleA引用CircleB,CircleB引用CircleC,CircleC引用CircleA  
解决 设值注入
```
<bean id="circleA" class="cn.javass.spring.chapter3.bean.CircleA" scope="prototype">
     <property name="circleB" ref="circleB"/>
</bean>
<bean id="circleB" class="cn.javass.spring.chapter3.bean.CircleB" scope="prototype">
    <property name="circleC" ref="circleC"/>
</bean>
<bean id="circleC" class="cn.javass.spring.chapter3.bean.CircleC" scope="prototype">
    <property name="circleA" ref="circleA"/>
</bean>
```
IOC技术的本质就是构建对象的技术。换句话说就是将一个类实例化成对象的技术，Spring提供一个容器,
我们在xml文件里定义各个对象的依赖关系,由容器完成对象的构建。
--------------------------------------------------------------------------------------
spring配置注入
```
<bean id="configProperties" class="org.springframework.beans.factory.config.PropertiesFactoryBean">
    <property name="locations">
        <list>
            <value>classpath*:application.properties</value>
        </list>
    </property>
</bean>
<!-- 将配置文件读取到容器中,交给Spring管理 -->
<bean id="propertyConfigurer" class="org.springframework.beans.factory.config.PreferencesPlaceholderConfigurer">
    <property name="properties" ref="configProperties" />
</bean>

@Value("#{configProperties['mysql.url']}")
private String url;


<bean id="placer2" class="org.springframework.beans.factory.config.PreferencesPlaceholderConfigurer">
    <property name="order" value="1"></property>
    <property name="ignoreUnresolvablePlaceholders" value="true" />
    <property name="locations">
        <list>
            <value>classpath:/jdbc.properties</value>
        </list>
    </property>
</bean>

<bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
    <property name="ignoreUnresolvablePlaceholders" value="true" />
    <property name="ignoreResourceNotFound" value="true" />
    <property name="locations">
        <list>
            <value>classpath:default.properties</value>
            <value>file:${user.home}/webextractor.properties</value>
        </list>
    </property>
</bean>
```
--------------------------------------------------------------------------------------
@Value("${server.host:127.0.0.1}")  默认值
--------------------------------------------------------------------------------------
springmvc redirect注意事项  
return "redirect:/test3"; 跳转相对于根路径地址: localhost:8080/test3  
return "redirect:test2"; 跳转相对于当前路径地址  
--------------------------------------------------------------------------------------
Spring提供了两种方式来生成代理对象: JDKProxy (接口)和Cglib
--------------------------------------------------------------------------------------
springmvc框架在遇到这种同名参数提交,而参数中有逗号时,会出现问题：  
比如我提交的值是 xname=123 和 xname=45,67  
那么在进入action拿到参数时会变成string[] xname = ["123","45","67"]  
```
$("input[name='ssidName']").each(function(){
    $(this).val(encodeURIComponent($(this).val()));
})
URLDecoder.decode(ssidNames [i], "UTF-8" )
```
--------------------------------------------------------------------------------------
spring拦截器
```
<mvc:interceptors>
   <mvc:interceptor>
     <mvc:mapping path="/**" />
     <mvc:exclude-mapping path="/**.jsonp"/>
     <mvc:exclude-mapping path="/site/**.jsonp"/>
     <bean id="loginInterceptor" class="com.jdd.admin.interceptor.LoginInterceptor" />
  </mvc:interceptor>
 </mvc:interceptors>
 ```
 一个springmvc的拦截器使用示例  
 > http://blog.csdn.net/liuwenbo0920/article/details/7283757
--------------------------------------------------------------------------------------
```
@Transactional(rollbackFor = Exception.class)
public int method(Object obj) {
    try {
        doInsert(obj);
        return 1;
    } catch(Exception e) {
        e.printStackTrace();
        // 加入下行代码手动回滚
        // @Transactional 为方法加上事务,try catch 捕获到异常手动回滚事务
        if (TransactionAspectSupport.currentTransactionStatus().isNewTransaction()) {
            // 第一次开启事务遇到异常则回滚
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        } else {
            // 嵌套的事务,当前方法被另一个加了 @Transactional 标注的方法调用
            // 抛出异常告诉上一个事务,让上一个事务判断是否回滚
            // 这样的优点是: 在调用者那边不用根据当前方法返回值来判断是否回滚
            throw e;
        }
    }
    return 0;
}
```
--------------------------------------------------------------------------------------