ApplicationContext ctx = new ClassPathXmlApplicationContext("beans.xml");
FileSystemXmlApplicationContext
--------------------------------------------------------------------------------------
<!--启动@AspectJ支持-->
<aop:aspectj-autoproxy/>
--------------------------------------------------------------------------------------
Spring 切面可以应用五种类型的通知：
    before ：前置通知，在一个方法执行前被调用
    after:  在方法执行之后调用的通知，无论方法执行是否成功
    after-returning:  仅当方法成功完成后执行的通知
    after-throwing:  在方法抛出异常退出时执行的通知
    around:  在方法执行之前和之后调用的通知
--------------------------------------------------------------------------------------
Spring 支持两种类型的事务管理：
编程式事务管理
声明式事务管理
--------------------------------------------------------------------------------------
spring命名空间：context、beans、jdbc、tx、aop
--------------------------------------------------------------------------------------
代理模式—在AOP和remoting中被用的比较多
单例模式—在spring配置文件中定义的bean默认为单例模式
模板方法—用来解决代码重复的问题比如.  RestTemplate ,  JmsTemplate ,  JpaTemplate
依赖注入—贯穿于 BeanFactory  /  ApplicationContext 接口的核心理念
工厂模式—BeanFactory用来创建对象的实例
--------------------------------------------------------------------------------------
public class AllApplicationEventListener implements ApplicationListener < ApplicationEvent >{
    public void onApplicationEvent(ApplicationEvent applicationEvent)
    {
        //process event
    }
}

spring 提供了以下5中标准的事件
上下文更新事件（ContextRefreshedEvent） ：该事件会在ApplicationContext被初始化或者更新时发布
也可以在调用ConfigurableApplicationContext 接口中的refresh()方法时被触发
上下文开始事件（ContextStartedEvent） ：当容器调用ConfigurableApplicationContext的Start()方法开始/重新开始容器时触发该事件
上下文停止事件（ContextStoppedEvent） ：当容器调用ConfigurableApplicationContext的Stop()方法停止容器时触发该事件
上下文关闭事件（ContextClosedEvent） ：当ApplicationContext被关闭时触发该事件容器被关闭时，其管理的所有单例Bean都被销毁
请求处理事件（RequestHandledEvent） ：在Web应用中，当一个http请求（request）结束触发该事件
--------------------------------------------------------------------------------------
Spring中的 org.springframework.beans 包和 org.springframework.context包构成了Spring框架IoC容器的基础
ioc 控制反转
--------------------------------------------------------------------------------------
@controllerAdvice最为实用的一个场景就是将所有@ExceptionHandler方法收集到一个类中，这样所有的异常都能在一个地方进行一致处理

@ControllerAdvice默认所有控制的抛出的异常都会在这个类进行处理
@ControllerAdvice(annotations = {PCInfoController .class}) 配置你需要拦截的控制器，
@ControllerAdvice(basePackages = "com.demo") 配置你需要路径下的控制器

@ControllerAdvice 注解，会应用到所有的Controller中的@RequestMapping注解的方法中
防止SpringMVC和SpringIOC对同一个对象的管理重合
<context:component-scan base-package="com.uniweibov2.web" use-default-filters="false">
  <context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
	<context:include-filter type="annotation" expression="org.springframework.web.bind.annotation.ControllerAdvice"/>
</context:component-scan>

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(SQLException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ResponseBody
    public ExceptionResponse handleSQLException(HttpServletRequest request, Exception ex) {
        String message = ex.getMessage();
        return ExceptionResponse.create(HttpStatus.INTERNAL_SERVER_ERROR.value(), message);
    }
}
--------------------------------------------------------------------------------------
spring中的核心类有那些，各有什么作用?
BeanFactory：产生一个新的实例，可以实现单例模式
BeanWrapper：提供统一的get及set方法
ApplicationContext:提供框架的实现，包括BeanFactory的所有功能
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
 <!-- 监听spring上下文容器 -->
<listener>
     <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
 </listener>
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:applicationContext.xml</param-value>
</context-param>
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
http://my.oschina.net/liting/blog/524332
BeanFactory接口是Spring IoC 容器的核心接口

BeanFactory和ApplicationContext有什么区别
BeanFactory 含有bean集合的工厂类

application context在此基础上还提供了其他的功能ApplicationContex接口对BeanFactory（是一个子接口）进行了扩展
提供了支持国际化的文本消息
统一的资源文件读取方式
已在监听器中注册的bean的事件

bean的生命周期由两组回调方法组成
初始化之后调用的回调方法
销毁之前调用的回调方法

Spring提供了以下四种集合类的配置元素：
<list> :   该标签用来装配可重复的list值
<set> :    该标签用来装配没有重复的set值
<map>:   该标签可用来注入键和值可以为任何类型的键值对
<props> : 该标签支持注入键和值都是字符串类型的键值对
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


加密 http://www.yihaomen.com/article/java/420.htm  extends DefaultPropertiesPersister 重写load 读入流覆盖属性转成流
<bean class="org.springframework.beans.factory.config.PreferencesPlaceholderConfigurer">
	<property name="locations">
		<list>
			<value>classpath:config/jdbc.properties</value>
		</list>
	</property>
	<property name="propertiesPersister">
		<bean class="com.ai.rgshcore.util.MyPropertiesPersist" />
	</property>
	<property name="ignoreUnresolvablePlaceholders" value="true" />
	<property name="ignoreResourceNotFound" value="true" />
</bean>


extends PropertyPlaceholderConfigurer 重写PropertiesLoaderSupport loadProperties;   super.loadProperties(props) 直接覆盖属性
extends PropertyPlaceholderConfigurer 重写PropertyResourceConfigurer convertProperty(String propertyName, String propertyValue) 覆盖propertyValue属性

使用jasypt jasypt-spring3加密 ENC(加密值)
```
<bean id="propertyConfigurerForProject2" class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
    <property name="order" value="2" />
    <property name="ignoreUnresolvablePlaceholders" value="true" />
    <property name="locations">
      <list>
        <value>classpath:/spring/include/jdbc-parms.properties</value>
        <value>classpath:/spring/include/base-config.properties</value>
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
--------------------------------------------------------------------------------------