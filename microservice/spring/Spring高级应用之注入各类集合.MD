先定义一个测试类，由于本文将要介绍注入各种集合时如何配置，故这个类包含各种集合，类名和属性名不好取，没有特殊含义：
```java
public class Test {
    private List<String> listTest;
    private Map<String, Object> mapTest;
    private Set setTest;
    private String[] arrayTest;
    private Properties propertiesTest;
    //下面是各个属性的setter，此处省略
    //......
}
```
Test类中，分别定义了List，Map，Set，Array等5种集合类型的属性，下面在Spring配置文件中，分别为这些类型的属性注入值：
```xml
<bean id="test" class="com.abc.Test">
    <!-- List类型的属性 -->
    <property name="listTest">
        <!-- 为list类型的属性注入值时，使用<list>元素 -->
        <list>
            <!-- 只要类型满足，每个<value>，<ref>，<bean>都可以配置一个list的元素 -->
            <value>ListA</value>
            <value>ListB</value>
            <value>ListC</value>
        </list>
    </property>
 
    <!-- Map类型的属性 -->
    <property name="mapTest">
        <!-- 为map类型的属性注入值时，使用<map>元素 -->
        <map>
            <!-- 每一个<entry>都为<map>配置一个K-V对，同样， -->
            <entry key="key1" value="value1" />
            <!-- 下面这个value指向了在此Spring文件中定义的另一个叫object的Bean -->
            <entry key="key2" value-ref="object" />
        </map>
    </property>
 
    <!-- Set类型的属性 -->
    <property name="setTest">
        <!-- 为set类型的属性注入值时，使用<set>元素 -->
        <set>
            <!-- 只要类型满足，每个<value>，<ref>，<bean>都可以配置一个list的元素 -->
            <value>SetA</value>
            <!-- 下面是一个嵌套Bean的定义。关于什么是嵌套Bean，请看：http://my.oschina.net/itblog/blog/204378 -->
            <bean class="com.abc.OtherBean1" />
            <!-- 下面引用了此Spring文件中定义的另一个Bean -->
            <ref local="com.abc.OtherBean2" />
        </set>
    </property>
 
    <!-- Properties类型的属性 -->
    <property name="propertiesTest">
        <props>
            <!-- 每个<prop>元素指定一个属性项，其中key指定属性名 -->
            <prop key="prop1">value1</prop>
            <prop key="prop2">value2</prop>
        </props>
    </property>
 
    <!-- 数组类型的属性 -->
    <property name="arrayTest">
        <!-- 为数组类型的属性注入值时，使用<list>元素 -->
        <list>
            <!-- 只要类型满足，每个<value>，<ref>，<bean>都可以配置一个list的元素 -->
            <value>Array1</value>
            <bean class="com.abc.OtherBean1" />
            <ref local="com.abc.OtherBean2" />
        </list>
    </property>
</bean>
```
由于集合元素有可以是基本类型值、引用容器中其他Bean、嵌套Bean或集合属性等，因此<list>、<set>、和<key>元素又可以接受如下的子元素：

value：指定集合元素是基本数据类型值或字符串类型值
ref：指定集合元素是容器中另一个Bean实例
bean：指定集合元素是一个嵌套Bean
list、set、map及props：指定集合元素值又是集合

<props>元素适用于配置Properties类型的属性，Properties类型时一种特殊的类型，其key和value都只能是字符串，故Spring配置Properties类型的属性都比较简单：每个属性项只要分别给出属性名和属性值就足够了。

当使用<map>元素配置Map类型属性时稍显复杂，因为Map类型的元素由多个<entry>组成，每个<entry>又需要配置key和value两个属性。其中<entry>属性支持以下几个属性：

key：当key是基本类型或字符串时使用
key-ref：当key类型是容器中定义的另一个Bean时使用
value：当value是基本类型或字符串时使用
value-ref：当value是容器中定义的另一个Bean时使用

Spring还提供了一个简化语法来支持Properties形参的setter方法，例如我们可以使用如下配置片段来配置Properties类型的属性：
```xml
<property name="propertiesTest">
    <value>
        key1=value1
        key2=value2
    </value>
</property>
```
虽然这种配置方式更简单，但是它也有一个缺点：属性名、属性值都只能是英文或数字，不能包含中文字符

从Spring2开始，Spring IoC容器支持集合的合并：子Bean中的集合属性可以从其父Bean的集合属性继承而来，同时，子Bean中的属性会覆盖父Bean中属性名相同的值。也就是说，子Bean的集合属性的最终值是父Bean、子Bean合并后的最终结果，下面是一个示例：
```xml
<!-- 将parent类型定义成抽象类 -->
<bean id="parent" abstract="true" class="com.abc.Parent">
    <!-- 定义Properties类型的集合属性 -->
    <property name="websites">
        <props>
            <prop key="baidu">www.baidu.com</props>
            <prop key="google">www.google.com.hk</prop>
        <props>
    </property>
</bean>
<bean id="child" parent="parent">
    <property name="websites">
        <!-- 注意，这里子Bean在集合元素上加了属性"merge=true" -->
        <props merge="true">
            <prop key="google">www.google.com</prop>
            <prop key="tencent">www.qq.com</prop>
        <props>
    </property>    
</bean>
```
通过上面的配置后，child中的属性将变为：

baidu=www.baidu.com  
google=www.google.com  
tencent=www.qq.com  