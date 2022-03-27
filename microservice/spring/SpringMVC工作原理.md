**1 简介**

SpringMVC框架是以请求为驱动，围绕Servlet设计，将请求发给控制器，然后通过模型对象，分派器来展示请求结果视图。其中核心类是DispatcherServlet，它是一个Servlet，顶层是实现的Servlet接口。

**2 运行原理**

![img](https://mmbiz.qpic.cn/mmbiz_png/KLTiaLuJImEKmUBtqHvToTCvvC5P0vr5D0WkPfmGk3Oet31iaE7swWiaE4DaIZtf6RPMRVJUCia7WCDhngfPyZYtCw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

流程说明：

（1）客户端（浏览器）发送请求，直接请求到DispatcherServlet。

![img](https://mmbiz.qpic.cn/mmbiz_jpg/KLTiaLuJImEKmUBtqHvToTCvvC5P0vr5DY0X8Iku6ibrHEgaznoF1ynsfpUgH4AQ6P8pqgy8afT981ZqYbvgO1Qg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



（2）DispatcherServlet根据请求信息调用HandlerMapping，解析请求对应的Handler。

```
HandlerMapping接口 -- 处理请求的映射
HandlerMapping接口的实现类：  
SimpleUrlHandlerMapping  通过配置文件，把一个URL映射到ControllerDefaultAnnotationHandlerMapping  通过注解，把一个URL映射到Controller类上
```

（3）解析到对应的Handler后，开始由HandlerAdapter适配器处理。
```
HandlerAdapter接口 -- 处理请求的映射
AnnotationMethodHandlerAdapter类，通过注解，把一个URL映射到Controller类的方法上
```

（4）HandlerAdapter会根据Handler来调用真正的处理器开处理请求，并处理相应的业务逻辑。

（5）处理器处理完业务后，会返回一个ModelAndView对象，Model是返回的数据对象，View是个逻辑上的View。

（6）ViewResolver会根据逻辑View查找实际的View。

（7）DispaterServlet把返回的Model传给View。

（8）通过View返回给请求者（浏览器）

**3 具体流程步骤**

1、首先用户发送请求——>DispatcherServlet，前端控制器收到请求后自己不进行处理，而是委托给其他的解析器进行处理，作为统一访问点，进行全局的流程控制；

2、DispatcherServlet——>HandlerMapping， HandlerMapping 将会把请求映射为HandlerExecutionChain 对象（包含一个Handler 处理器（页面控制器）对象、多个HandlerInterceptor 拦截器）对象，通过这种策略模式，很容易添加新的映射策略；

3、DispatcherServlet——>HandlerAdapter，HandlerAdapter 将会把处理器包装为适配器，从而支持多种类型的处理器，即适配器设计模式的应用，从而很容易支持很多类型的处理器；

4、HandlerAdapter——>处理器功能处理方法的调用，HandlerAdapter 将会根据适配的结果调用真正的处理器的功能处理方法，完成功能处理；并返回一个ModelAndView 对象（包含模型数据、逻辑视图名）；

5、ModelAndView的逻辑视图名——> ViewResolver， ViewResolver 将把逻辑视图名解析为具体的View，通过这种策略模式，很容易更换其他视图技术；

6、View——>渲染，View会根据传进来的Model模型数据进行渲染，此处的Model实际是一个Map数据结构，因此很容易支持其他视图技术；

7、返回控制权给DispatcherServlet，由DispatcherServlet返回响应给用户，到此一个流程结束。

下边两个组件通常情况下需要开发：

Handler：处理器，即后端控制器用controller表示。

View：视图，即展示给用户的界面，视图中通常需要标签语言展示模型数据。

MVC：MVC是一种设计模式

MVC的原理图：

![img](https://mmbiz.qpic.cn/mmbiz_png/KLTiaLuJImEKmUBtqHvToTCvvC5P0vr5DicvDaWpgukhlMNX1VfibeEIqbbLf2Y9yaUxxdK4NoxSCvBZ2ictpgCwDw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

分析：

M-Model 模型（完成业务逻辑：有javaBean构成，service+dao+entity）

V-View 视图（做界面的展示 jsp，html……）

C-Controller 控制器（接收请求—>调用模型—>根据结果派发页面）

**4** **DispatcherServlet详细解析**

源码如下：

```java
package org.springframework.web.servlet;
 
@SuppressWarnings("serial")
public class DispatcherServlet extends FrameworkServlet {
 
  public static final String MULTIPART_RESOLVER_BEAN_NAME = "multipartResolver";
  public static final String LOCALE_RESOLVER_BEAN_NAME = "localeResolver";
  public static final String THEME_RESOLVER_BEAN_NAME = "themeResolver";
  public static final String HANDLER_MAPPING_BEAN_NAME = "handlerMapping";
  public static final String HANDLER_ADAPTER_BEAN_NAME = "handlerAdapter";
  public static final String HANDLER_EXCEPTION_RESOLVER_BEAN_NAME = "handlerExceptionResolver";
  public static final String REQUEST_TO_VIEW_NAME_TRANSLATOR_BEAN_NAME = "viewNameTranslator";
  public static final String VIEW_RESOLVER_BEAN_NAME = "viewResolver";
  public static final String FLASH_MAP_MANAGER_BEAN_NAME = "flashMapManager";
  public static final String WEB_APPLICATION_CONTEXT_ATTRIBUTE = DispatcherServlet.class.getName() + ".CONTEXT";
  public static final String LOCALE_RESOLVER_ATTRIBUTE = DispatcherServlet.class.getName() + ".LOCALE_RESOLVER";
  public static final String THEME_RESOLVER_ATTRIBUTE = DispatcherServlet.class.getName() + ".THEME_RESOLVER";
  public static final String THEME_SOURCE_ATTRIBUTE = DispatcherServlet.class.getName() + ".THEME_SOURCE";
  public static final String INPUT_FLASH_MAP_ATTRIBUTE = DispatcherServlet.class.getName() + ".INPUT_FLASH_MAP";
  public static final String OUTPUT_FLASH_MAP_ATTRIBUTE = DispatcherServlet.class.getName() + ".OUTPUT_FLASH_MAP";
  public static final String FLASH_MAP_MANAGER_ATTRIBUTE = DispatcherServlet.class.getName() + ".FLASH_MAP_MANAGER";
  public static final String EXCEPTION_ATTRIBUTE = DispatcherServlet.class.getName() + ".EXCEPTION";
  public static final String PAGE_NOT_FOUND_LOG_CATEGORY = "org.springframework.web.servlet.PageNotFound";
  private static final String DEFAULT_STRATEGIES_PATH = "DispatcherServlet.properties";
  protected static final Log pageNotFoundLogger = LogFactory.getLog(PAGE_NOT_FOUND_LOG_CATEGORY);
  private static final Properties defaultStrategies;
  static {
    try {
      ClassPathResource resource = new ClassPathResource(DEFAULT_STRATEGIES_PATH, DispatcherServlet.class);
      defaultStrategies = PropertiesLoaderUtils.loadProperties(resource);
    }
    catch (IOException ex) {
      throw new IllegalStateException("Could not load 'DispatcherServlet.properties': " + ex.getMessage());
    }
  }
 
  /** Detect all HandlerMappings or just expect "handlerMapping" bean? */
  private boolean detectAllHandlerMappings = true;
 
  /** Detect all HandlerAdapters or just expect "handlerAdapter" bean? */
  private boolean detectAllHandlerAdapters = true;
 
  /** Detect all HandlerExceptionResolvers or just expect "handlerExceptionResolver" bean? */
  private boolean detectAllHandlerExceptionResolvers = true;
 
  /** Detect all ViewResolvers or just expect "viewResolver" bean? */
  private boolean detectAllViewResolvers = true;
 
  /** Throw a NoHandlerFoundException if no Handler was found to process this request? **/
  private boolean throwExceptionIfNoHandlerFound = false;
 
  /** Perform cleanup of request attributes after include request? */
  private boolean cleanupAfterInclude = true;
 
  /** MultipartResolver used by this servlet */
  private MultipartResolver multipartResolver;
 
  /** LocaleResolver used by this servlet */
  private LocaleResolver localeResolver;
 
  /** ThemeResolver used by this servlet */
  private ThemeResolver themeResolver;
 
  /** List of HandlerMappings used by this servlet */
  private List<HandlerMapping> handlerMappings;
 
  /** List of HandlerAdapters used by this servlet */
  private List<HandlerAdapter> handlerAdapters;
 
  /** List of HandlerExceptionResolvers used by this servlet */
  private List<HandlerExceptionResolver> handlerExceptionResolvers;
 
  /** RequestToViewNameTranslator used by this servlet */
  private RequestToViewNameTranslator viewNameTranslator;
 
  private FlashMapManager flashMapManager;
 
  /** List of ViewResolvers used by this servlet */
  private List<ViewResolver> viewResolvers;
 
  public DispatcherServlet() {
    super();
  }
 
  public DispatcherServlet(WebApplicationContext webApplicationContext) {
    super(webApplicationContext);
  }
  @Override
  protected void onRefresh(ApplicationContext context) {
    initStrategies(context);
  }
 
  protected void initStrategies(ApplicationContext context) {
    initMultipartResolver(context);
    initLocaleResolver(context);
    initThemeResolver(context);
    initHandlerMappings(context);
    initHandlerAdapters(context);
    initHandlerExceptionResolvers(context);
    initRequestToViewNameTranslator(context);
    initViewResolvers(context);
    initFlashMapManager(context);
  }
}
```

DispatcherServlet类中的属性beans：
HandlerMapping：用于handlers映射请求和一系列的对于拦截器的前处理和后处理，大部分用@Controller注解。
HandlerAdapter：帮助DispatcherServlet处理映射请求处理程序的适配器，而不用考虑实际调用的是 哪个处理程序。
HandlerExceptionResolver：处理映射异常。
ViewResolver：根据实际配置解析实际的View类型。
LocaleResolver：解决客户正在使用的区域设置以及可能的时区，以便能够提供国际化视野。
ThemeResolver：解决Web应用程序可以使用的主题，例如提供个性化布局。
MultipartResolver：解析多部分请求，以支持从HTML表单上传文件。
FlashMapManager：存储并检索可用于将一个请求属性传递到另一个请求的input和output的FlashMap，通常用于重定向。
在Web MVC框架中，每个DispatcherServlet都拥自己的WebApplicationContext，它继承了ApplicationContext。WebApplicationContext包含了其上下文和Servlet实例之间共享的所有的基础框架beans。

1、HandlerMapping：

![img](https://mmbiz.qpic.cn/mmbiz_png/KLTiaLuJImEKmUBtqHvToTCvvC5P0vr5DYECp9iczmoSKNkg7h5AdcwFp9G8ZZhnEdbxMGvBvhMKBFhQ36amlFhA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

HandlerMapping接口处理请求的映射
HandlerMapping接口的实现类：
SimpleUrlHandlerMapping类通过配置文件把URL映射到Controller类。DefaultAnnotationHandlerMapping类通过注解把URL映射到Controller类。

2、HandlerAdapter：

![img](https://mmbiz.qpic.cn/mmbiz_png/KLTiaLuJImEKmUBtqHvToTCvvC5P0vr5DXNN9neiaFpibUtYI0m6sezbh57Y3n5xldTzKNybUeCwXH6reNz4M7Alw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



```
HandlerAdapter接口-处理请求映射
AnnotationMethodHandlerAdapter：通过注解，把请求URL映射到Controller类的方法上。
```

3、HandlerExceptionResolver：

![img](https://mmbiz.qpic.cn/mmbiz_png/KLTiaLuJImEKmUBtqHvToTCvvC5P0vr5DHf2q0aFt3Gd9KdymaQMyGdKAdyxWX1QKbJice0QS76bQFBwEmibXttYA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

HandlerExceptionResolver接口-异常处理接口
SimpleMappingExceptionResolver通过配置文件进行异常处理。AnnotationMethodHandlerExceptionResolver：通过注解进行异常处理。

4、HandlerExceptionResolver：

![img](https://mmbiz.qpic.cn/mmbiz_png/KLTiaLuJImEKmUBtqHvToTCvvC5P0vr5DRXC6JicatB0UleeJMocon0zduC1GfOKpLNzLEhClf0YD6tCKibwM0Wzg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

HandlerExceptionResolver接口-异常处理接口
SimpleMappingExceptionResolver通过配置文件进行异常处理。AnnotationMethodHandlerExceptionResolver：通过注解进行异常处理。

5、ViewResolver：

![img](https://mmbiz.qpic.cn/mmbiz_png/KLTiaLuJImEKmUBtqHvToTCvvC5P0vr5DanVBzEoIhXO2dA9icRdYRSKWjtdicAUkicTTTu2THvxkRRLXrhka6NSLg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)


ViewResolver接口解析View视图。
UrlBasedViewResolver类 通过配置文件，把一个视图名交给到一个View来处理。