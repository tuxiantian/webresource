<!-- TOC -->

- [输出级别的种类](#输出级别的种类)
- [配置日志信息输出目的地](#配置日志信息输出目的地)
- [配置日志信息的格式](#配置日志信息的格式)
- [日志信息格式中几个符号所代表的含义](#日志信息格式中几个符号所代表的含义)
- [log4j日志级别](#log4j日志级别)
- [log4j的常用配置](#log4j的常用配置)
- [pom文件中引入log4j](#pom文件中引入log4j)
- [web.xml文件中添加log4j配置](#webxml文件中添加log4j配置)
- [java使用示例](#java使用示例)
    - [BaseTest](#basetest)
    - [TestCase](#testcase)
- [idea查看日志技巧](#idea查看日志技巧)
- [使用log4j.xml配置](#使用log4jxml配置)
    - [指定的日志输出到指定的文件](#指定的日志输出到指定的文件)

<!-- /TOC -->
### 输出级别的种类
OFF     为最高等级 关闭了日志信息    
FATAL   为可能导致应用中止的严重事件错误    
ERROR   为严重错误 主要是程序的错误    
WARN    为一般警告，比如session丢失    
INFO    为一般要显示的信息，比如登录登出    
DEBUG   为程序的调试信息    
TRACE   为比DEBUG更细粒度的事件信息    
ALL     为最低等级，将打开所有级别的日志
### 配置日志信息输出目的地
1. org.apache.log4j.ConsoleAppender（控制台）    
2. org.apache.log4j.FileAppender（文件）    
3. org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件）    
4. org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件）    
5. org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）  
### 配置日志信息的格式
1. org.apache.log4j.HTMLLayout（以HTML表格形式布局），    
2. org.apache.log4j.PatternLayout（可以灵活地指定布局模式），    
3. org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串），    
4. org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）  
### 日志信息格式中几个符号所代表的含义
-X号: X信息输出时左对齐；    
%p: 输出日志信息优先级，即DEBUG，INFO，WARN，ERROR，FATAL,    
%d: 输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，比如：%d{yyy MMM dd HH:mm:ss,SSS}，输出类似：2002年10月18日 22：10：28，921    
%r: 输出自应用启动到输出该log信息耗费的毫秒数    
%c: 输出日志信息所属的类目，通常就是所在类的全名    
%t: 输出产生该日志事件的线程名    
%l: 输出日志事件的发生位置，相当于%C.%M(%F:%L)的组合,包括类目名、发生的线程，以及在代码中的行数。举例：Testlog4.main (TestLog4.java:10)    
%x: 输出和当前线程相关联的NDC(嵌套诊断环境),尤其用到像java servlets这样的多客户多线程的应用中。    
%%: 输出一个"%"字符    
%F: 输出日志消息产生时所在的文件名称    
%L: 输出代码中的行号    
%m: 输出代码中指定的消息,产生的日志具体信息    
%n: 输出一个回车换行符，Windows平台为"/r/n"，Unix平台为"/n"输出日志信息换行    
可以在%与模式字符之间加上修饰符来控制其最小宽度、最大宽度、和文本的对齐方式。如：    
1)%20c：指定输出category的名称，最小的宽度是20，如果category的名称小于20的话，默认的情况下右对齐。    
2)%-20c:指定输出category的名称，最小的宽度是20，如果category的名称小于20的话，"-"号指定左对齐。    
3)%.30c:指定输出category的名称，最大的宽度是30，如果category的名称大于30的话，就会将左边多出的字符截掉，但小于30的话也不会有空格。    
4)%20.30c:如果category的名称小于20就补空格，并且右对齐，如果其名称长于30字符，就从左边较远输出的字符截掉。   
### log4j日志级别
log4j常见日志级别为：debug < info < warn < error < fatal

### log4j的常用配置
```
log4j.rootLogger=debug,stdout,logfile
log4j.INFO=true

# set standard out appender.
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout 
log4j.appender.stdout.layout.ConversionPattern=%d{MM-dd HH:mm:ss.SSS} [%t] %c %l %-5p - %m%n


log4j.appender.logfile=org.apache.log4j.DailyRollingFileAppender
log4j.appender.logfile.File=../logs/mongodb.log
log4j.appender.logfile.DatePattern='.'yyyyMMdd
log4j.appender.logfile.layout=org.apache.log4j.PatternLayout
log4j.appender.logfile.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss.SSS} [%t] %c %-5p - %m%n
```
### pom文件中引入log4j
```
 <!--log4j-->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>1.7.2</version>
</dependency>
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-log4j12</artifactId>
    <version>1.7.2</version>
</dependency>

<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.17</version>
</dependency>
```
### web.xml文件中添加log4j配置
```
<context-param>
    <param-name>log4jConfigLocation</param-name>
    <param-value>classpath:log4j.properties</param-value>
</context-param>
<context-param>
    <param-name>log4jRefreshInterval</param-name>
    <param-value>60000</param-value>
</context-param>
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:spring/spring-all.xml</param-value>
</context-param>

<listener>
    <listener-class>org.springframework.web.util.Log4jConfigListener</listener-class>
</listener>
```
### java使用示例
#### BaseTest
```
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RunWith(SpringJUnit4ClassRunner.class)  //使用junit4进行测试
@ContextConfiguration({"classpath*:/spring/applicationContext*.xml"}) //加载配置文件
@Transactional
public class BaseTest {

    protected static final Logger logger = LoggerFactory.getLogger(BaseTest.class);
}
```
#### TestCase
```

public class DdtcServiceTest extends BaseTest{

    @Autowired
    private DdtcService ddtcService;

    @Test
    @Rollback(false)//测试完成时不回滚事务
    public void queryAccessToken(){
        logger.info("queryAccessToken:{}",ddtcService.queryAccessToken());

    }

}
```
### idea查看日志技巧
Use Soft Wraps
![](/images/java/idea_view_log.png)

### 使用log4j.xml配置
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
<log4j:configuration xmlns:log4j='http://jakarta.apache.org/log4j/'>
    <appender name="Console" class="org.apache.log4j.ConsoleAppender">
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern"
                   value="%d [%t] %-5p [%c] - %m%n"/>
        </layout>
    </appender>

    <appender name="InfoFile" class="org.apache.log4j.DailyRollingFileAppender">
        <param name="File" value="logs/laijia.log"/>
        <!-- 设置日志输出文件名 -->
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%d [%t] %-5p [%c] - %m%n"/>
        </layout>
    </appender>

    <appender name="iotFile" class="org.apache.log4j.DailyRollingFileAppender">
        <param name="File" value="logs/laijia_iot.log"/>
        <!-- 设置日志输出文件名 -->
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%d [%-5p] - %m%n"/>
        </layout>
        <filter class="com.laijia.util.StringMatchFilter">
            <param name="StringToMatch" value="[iot]"/>
            <param name="AcceptOnMatch" value="false"/>
        </filter>
    </appender>

    <appender name="ErrorFile" class="org.apache.log4j.DailyRollingFileAppender">
        <param name="File" value="logs/laijia_error.log"/>
        <!-- 设置日志输出文件名 -->
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern"
                   value="%d [%t] %-5p [%c] - %m%n"/>
        </layout>
        <!--过滤器设置输出的级别-->
        <filter class="org.apache.log4j.varia.LevelRangeFilter">
            <param name="levelMin" value="error"/>
            <param name="levelMax" value="error"/>
            <param name="AcceptOnMatch" value="true"/>
        </filter>
    </appender>

    <logger name="java.sql">
        <level value="info"></level>
    </logger>
    <logger name="java.sql.PreparedStatement">
        <level value="info"></level>
    </logger>
    <logger name="java.sql.Statement">
        <level value="info"></level>
    </logger>
    <logger name="java.sql.Connection">
        <level value="info"></level>
    </logger>
    <logger name="com.ibatis">
        <level value="info"></level>
    </logger>
    <logger name="com.laijia.biz.order.mapper.OrdersMapper.findBookTimeOut">
        <level value="info"></level>
    </logger>
    <logger name="com.laijia">
        <level value="debug"></level>
    </logger>


    <!-- 根logger的设置-->
    <root>
        <priority value="info"/>
        <appender-ref ref="Console"/>
        <appender-ref ref="InfoFile"/>
        <appender-ref ref="ErrorFile"/>
        <appender-ref ref="iotFile"/>
    </root>
</log4j:configuration>  
```
#### 指定的日志输出到指定的文件
```java
import org.apache.log4j.helpers.OptionConverter;
import org.apache.log4j.spi.Filter;
import org.apache.log4j.spi.LoggingEvent;


public class StringMatchFilter extends Filter {

    /**
     * @deprecated Options are now handled using the JavaBeans paradigm.
     * This constant is not longer needed and will be removed in the
     * <em>near</em> term.
     */
    public static final String STRING_TO_MATCH_OPTION = "StringToMatch";

    /**
     * @deprecated Options are now handled using the JavaBeans paradigm.
     * This constant is not longer needed and will be removed in the
     * <em>near</em> term.
     */
    public static final String ACCEPT_ON_MATCH_OPTION = "AcceptOnMatch";

    boolean acceptOnMatch = true;
    String stringToMatch;

    /**
     * @deprecated We now use JavaBeans introspection to configure
     * components. Options strings are no longer needed.
     */
    public String[] getOptionStrings() {
        return new String[]{STRING_TO_MATCH_OPTION, ACCEPT_ON_MATCH_OPTION};
    }

    /**
     * @deprecated Use the setter method for the option directly instead
     * of the generic <code>setOption</code> method.
     */
    public void setOption(String key, String value) {

        if (key.equalsIgnoreCase(STRING_TO_MATCH_OPTION)) {
            stringToMatch = value;
        } else if (key.equalsIgnoreCase(ACCEPT_ON_MATCH_OPTION)) {
            acceptOnMatch = OptionConverter.toBoolean(value, acceptOnMatch);
        }
    }

    public void setStringToMatch(String s) {
        stringToMatch = s;
    }

    public String getStringToMatch() {
        return stringToMatch;
    }

    public void setAcceptOnMatch(boolean acceptOnMatch) {
        this.acceptOnMatch = acceptOnMatch;
    }

    public boolean getAcceptOnMatch() {
        return acceptOnMatch;
    }

    public int decide(LoggingEvent event) {
        String msg = event.getRenderedMessage();
        if (msg == null || stringToMatch == null)
            return Filter.NEUTRAL;


        if (msg.indexOf(stringToMatch) >= 0) {
            return Filter.ACCEPT;
        }
        return Filter.DENY;
    }
}
```
打印日期语句
```java
logger.info("[iot]:获取状态：" + log.toString());
```