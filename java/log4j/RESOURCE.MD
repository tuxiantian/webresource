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