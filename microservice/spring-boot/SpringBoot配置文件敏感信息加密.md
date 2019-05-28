使用过SpringBoot配置文件的朋友都知道，资源文件中的内容通常情况下是明文显示，安全性就比较低一些。打开application.properties或application.yml，比如mysql登陆密码，redis登陆密码以及第三方的密钥等等一览无余，这里介绍一个加解密组件，提高一些属性配置的安全性。
 jasypt由一个国外大神写了一个springboot下的工具包，
 下面直接看代码：

# 这里以数据用户名和数据库密码加密为例

# 一，首先引入maven

```
<dependency>
    <groupId>com.github.ulisesbocchio</groupId>
    <artifactId>jasypt-spring-boot-starter</artifactId>
    <version>2.1.0</version>
</dependency>
```

2.1.0版本是我用的时候最新版本。查看最新版本可以到
 <https://github.com/ulisesbocchio/jasypt-spring-boot> 查看

> jasypt-1.9.4.jar
>
> jasypt-spring-boot-2.1.1.jar
>
> jasypt-spring-boot-starter-2.1.1.jar

# 二，application.yml配置文件中增加如下内容（加解密时使用）

```
#jasypt加密的密匙
jasypt:
  encryptor:
    password: EbfYkitulv73I2p0mXI50JMXoaxZTKJ7
```

# 三，在测试用例中生成加密后的秘钥：

```
@RunWith(SpringRunner.class)
@SpringBootTest
@WebAppConfiguration
public class testTest {
    @Autowired
    StringEncryptor encryptor;

    @Test
    public void getPass() {
        String url = encryptor.encrypt("jdbc:mysql://47.97.192.116:3306/sell?characterEncoding=utf-8&useSSL=false&serverTimezone=GMT%2b8");
        String name = encryptor.encrypt("你的数据库名");
        String password = encryptor.encrypt("你的数据库密码");
        System.out.println(url+"----------------");
        System.out.println(name+"----------------");
        System.out.println(password+"----------------");
        Assert.assertTrue(name.length() > 0);
        Assert.assertTrue(password.length() > 0);
    }
}
```

下面是加密后的输出结果

```
3OW8RQaoiHu1DXfDny4FDP0W5KOSVcWN5yWNxQ6Q4UE=----------------
ITE8wJryM8hVnofDKQodFzPZuPpTaMtX71YDoOTdh0A=----------------
```

# 四，将上面生成的name和password替换配置文件中的数据库账户和密码，替换后如下：

```
spring:
  #数据库相关配置
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    #这里加上后缀用来防止mysql乱码,serverTimezone=GMT%2b8设置时区
    url: ENC(i87lLC0ceVq1vK91R+Y6M9fAJQdU7jNp5MW+ndLgacRvPDj42HR8mUE33uFwpWqjOSuDX0d1dd2NilrnW7yJbZmoxuJ3HmOmjwY5+Vhu+e3We4QPDVCr/s/RHsQgYOiWrSQ92Mjammnody/jWI5aaw==)
    username: ENC(3OW8RQaoiHu1DXfDny4FDP0W5KOSVcWN5yWNxQ6Q4UE=)
    password: ENC(ITE8wJryM8hVnofDKQodFzPZuPpTaMtX71YDoOTdh0A=)
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true

  #返回的api接口的配置，全局有效
  jackson:
    default-property-inclusion: non_null #如果某一个字段为null，就不再返回这个字段

#url相关配置，这里配置url的基本url
server:
  port: 8888
#jasypt加密的密匙
jasypt:
  encryptor:
    password: EbfYkitulv73I2p0mXI50JMXoaxZTKJ7
```

注意上面的 ENC()是固定写法，（）里面是加密后的信息。

到此，我们就实现了springboot配置文件里的敏感信息加密。是不是很简单。

#五，使用命令加密

```
java -cp jasypt-1.9.4.jar org.jasypt.intf.cli.JasyptPBEStringEncryptionCLI input=ocdm password=123456 algorithm=PBEWithMD5AndDES
```

参考链接

[spring、spring-boot配置文件属性内容加解密](<https://yq.aliyun.com/articles/182720>)