# spring boot 2 禁用security

禁用spring security两种方法：

```
@EnableAutoConfiguration(exclude = {SecurityAutoConfiguration.class})
```


或

```
@SpringBootApplication(exclude = {SecurityAutoConfiguration.class })
```



[【解决】Linux Tomcat启动慢--Creation of SecureRandom instance for session ID generation using [SHA1PRNG] took [236,325] milliseconds]( https://www.bbsmax.com/A/WpdKnLLr5V/ )

