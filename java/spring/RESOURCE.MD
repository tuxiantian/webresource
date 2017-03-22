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
构造器注入
Setter方法注入
接口注入
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
<mvc:resources location="/WEB-INF/resources/**" mapping="/resources/**" />

Spring MVC 的运行流程
DispatcherServlet 前置控制器,处于核心位置，负责协调和组织不同组件以完成请求处理并返回响应的工作
SpringMVC 处理请求过程：
1.spring mvc请所有的请求都提交给DispatcherServlet,它会委托应用系统的其他模块负责负责对请求进行真正的处理工作
2.DispatcherServlet查询一个或多个HandlerMapping,找到处理请求的Controller.
3.DispatcherServlet请请求提交到目标Controller
4.Controller进行业务逻辑处理后，会返回一个ModelAndView
5.Dispathcher查询一个或多个ViewResolver视图解析器,找到ModelAndView对象指定的视图对象
6.视图对象负责渲染返回给客户端

@RequestMapping 控制器指定可以处理哪些 URL 请求
@PathVariable
@RequestParam
@RequestBoy 该注解用于读取Request请求的body部分数据
@ResponseBody
@ExceptionHandler 注解到方法上，出现异常时会执行该方法

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

视图名称解析器
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

--------------------------------------------------------------------------------------
@RequestMapping(value="/user/{id}",method=RequestMethod.GET)
public String get(@PathVariable("id") Integer id){
       System.out.println("get"+id);
       return "/hello";
}

@RequestMapping("test/login")  // 请求url地址映射
public String testLogin(@RequestParam(value="username")String username){

}

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
public class SpringMVCInterceptor implements HandlerInterceptor {
    //当preHandle的返回值为false的时候整个请求就结束了
    public boolean preHandle(HttpServletRequest request,
         HttpServletResponse response, Object handler) throws Exception {
       return false;
    }
    //在Controller的方法调用之后执行，但是它会在DispatcherServlet进行视图的渲染之前执行
    public void postHandle(HttpServletRequest request,
            HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
    }
    //将在整个请求完成之后，也就是DispatcherServlet渲染了视图执行，
    //这个方法的主要作用是用于清理资源的
    public void afterCompletion(HttpServletRequest request,
            HttpServletResponse response, Object handler, Exception ex)
          throws Exception {

    }

}

<mvc:interceptors>
    <!-- 使用bean定义一个Interceptor，直接定义在mvc:interceptors根下面的Interceptor将拦截所有的请求 -->
    <bean class="com.host.app.web.interceptor.AllInterceptor"/>
    <mvc:interceptor>
        <mvc:mapping path="/test/number.do"/>
        <!-- 定义在mvc:interceptor下面的表示是对特定的请求才进行拦截的 -->
        <bean class="com.host.app.web.interceptor.LoginInterceptor"/>
    </mvc:interceptor>
</mvc:interceptors>
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