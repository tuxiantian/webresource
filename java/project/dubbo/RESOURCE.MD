eclipse添加dubbo xsd的支持
> http://www.cnblogs.com/panxuejun/p/6102011.html
### dubbo的使用示例
#### 使用dubbo必须添加的依赖
```
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>dubbo</artifactId>
    <version>2.5.3</version>
    <exclusions>
        <exclusion>
            <artifactId>spring</artifactId>
            <groupId>org.springframework</groupId>
        </exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>org.apache.zookeeper</groupId>
    <artifactId>zookeeper</artifactId>
    <version>3.4.6</version>
</dependency>

<dependency>
    <groupId>com.github.sgroschupf</groupId>
    <artifactId>zkclient</artifactId>
    <version>0.1</version>
</dependency>
```
#### 服务提供方配置
```
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://code.alibabatech.com/schema/dubbo"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-2.5.xsd
        http://code.alibabatech.com/schema/dubbo
        http://code.alibabatech.com/schema/dubbo/dubbo.xsd"
       default-lazy-init="false">

    <dubbo:application name="dubbo-mongodb"/>
	<dubbo:protocol name="dubbo" port="20881" />
    <dubbo:registry address="zookeeper://127.0.0.1:2181" check="false" subscribe="false" register=""></dubbo:registry>
	<dubbo:service interface="com.laijia.dubbo.mongodb.ICarRecordService" ref="carRecordService"/>
</beans>
```
#### 服务消费方配置
```
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://code.alibabatech.com/schema/dubbo"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-2.5.xsd
        http://code.alibabatech.com/schema/dubbo
        http://code.alibabatech.com/schema/dubbo/dubbo.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd"
       default-lazy-init="false">

    <dubbo:application name="dubbo-laijia"/>

    <!-- 本机测试地址 -->
     <dubbo:registry address="zookeeper://127.0.0.1:2181?backup=127.0.0.1:2182"/>

     <context:annotation-config/>
     <dubbo:annotation/>
     <!-- ①：对web包中的所有类进行扫描，以完成Bean创建和自动依赖注入的功能 -->
    <context:component-scan base-package="com.laijia.biz.mongo"/>
</beans>
```
#### 服务消费方代码示例
```java
import com.alibaba.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.laijia.dubbo.mongodb.ICarRecordService;

/**
 * Created by tuxt on 2017/4/10.
 */
@Service
@Transactional
public class MongoService
{
    @Reference
    public ICarRecordService carRecordService;

    /**
     * 查询一辆车最新的状态信息，按receivedTime排序
     * @param sn
     * @return CarInfo json
     */
    public String findLastedCarInfo(String sn){
        return carRecordService.findLastedCarInfo(sn);
    }
}
```
**注意服务提供方提供的服务接口和服务消费方引用的接口必须是同一个接口，同一个接口指的的是接口名和限定名（即包名）必须一致**