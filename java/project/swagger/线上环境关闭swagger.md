# SpringBoot生产环境快速禁用Swagger2

## 方法一

使用注解`@Profile({"dev","test"})` 表示在开发或测试环境开启，而在生产关闭。
`@Profile`使用的值是根据`spring.profiles.active`指定的环境参数，可以参考上一篇博客[SpringBoot入门篇之多环境配置文件](http://www.magicj.top/2019/05/08/SpringBoot入门篇之多环境配置文件/#more)。

简单介绍下`@Profile`注解

`@Profile` 注解的作用在不同的场景下，给出不同的类实例。比如在生产环境中给出的 DataSource 实例和测试环境给出的 DataSource 实例是不同的。

`@Profile` 的使用时，一般是在`@Configuration` 下使用，标注在类或者方法上，标注的时候填入一个字符串（例如”dev”），作为一个场景,或者一个区分。

实际上，很少通过上面的方式激活 Spring 容器中的 Profile，通常都是让 Spring 容器自动去读取 Profile 的值，然后自动设置。这些实现通常是具体框架实现或者虚拟机参数/环境变量等相关。

## 方法二

使用注解`@ConditionalOnProperty(name = "swagger.enable", havingValue = "true")` 然后在对应的application.properties/application.yml配置文件中添加 `swagger.enable = true`即可开启，生产环境不填则默认关闭Swagger。