<!-- TOC -->

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