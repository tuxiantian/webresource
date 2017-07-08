[jsonp跨域请求详解——从繁至简](https://zhuanlan.zhihu.com/p/24390509)  
  
[SpringMvc解决跨域问题](https://my.oschina.net/wangnian/blog/689020)  
> Spring MVC通过CROS协议解决跨域问题
Spring MVC 从4.2版本开始增加了对CORS的支持

springmvc全局跨域配置
```
<mvc:cors>   
   		<mvc:mapping path="/**" />
</mvc:cors>
```