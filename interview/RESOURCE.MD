### spring的controller默认是单例
> http://blog.csdn.net/gengchenliang/article/details/26681295
> #### 注意事项
> 1、不要在controller中定义成员变量。
> 2、万一必须要定义一个非静态成员变量时候，则通过注解@Scope("prototype")，将其设置为多例模式。
### 关于 ArrayList 的 5 道面试题
> http://mp.weixin.qq.com/s/O7ptp3qaulrnNNDk5oKHqQ
> 1、ArrayList的大小是如何自动增加的？你能分享一下你的代码吗？
> 2、什么情况下你会使用ArrayList？什么时候你会选择LinkedList？
> 3、当传递ArrayList到某个方法中，或者某个方法返回ArrayList，什么时候要考虑安全隐患？如何修复安全违规这个问题呢？
> 4、如何复制某个ArrayList到另一个ArrayList中去？写出你的代码？
> 5、在索引中ArrayList的增加或者删除某个对象的运行过程？效率很低吗？解释一下为什么？
### 关于 Java Collections 的几个常见问题
> http://mp.weixin.qq.com/s/AHfiMpx5ShKhLEIIzEOFjg