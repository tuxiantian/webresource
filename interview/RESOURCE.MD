### spring的controller默认是单例
> http://blog.csdn.net/gengchenliang/article/details/26681295
> #### 注意事项
> 1、不要在controller中定义成员变量。
> 2、万一必须要定义一个非静态成员变量时候，则通过注解@Scope("prototype")，将其设置为多例模式。