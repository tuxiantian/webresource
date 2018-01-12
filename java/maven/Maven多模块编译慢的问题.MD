---
typora-root-url: ..\..
---

Maven多模块编译慢的问题

最近在部署项目时发现，Maven编译打包相当耗时，比之前项目用Gradle慢了很多倍，特别是对于WEB工程，打war包花的时间很长，在unix主机下一般会用到3到4分钟，如果有多个WEB工程，那简直不能忍受，经过查找资料并结合本人真实验证，原本编译打包需要8分钟的项目，优化编译后时间减少至34秒。如下图：
![](/images/java/maven/Maven多模块编译慢的问题.png)
​        

其中下面标红两个工程为WEB工程。下面来说一下进行了哪些优化：

1. 增加跳过测试代码的编译命令 -Dmaven.test.skip=true ；

2. 增加编译-Dmaven.compile.fork=true 参数，用以指明多线程进行编译；

3. 如果你用的Maven是3.×以上版本，可以增加 -T 1C 参数，表示每个CPU核心跑一个工程；

完整命令如下：   

```
mvn clean package -T 1C -Dmaven.test.skip=true  -Dmaven.compile.fork=true  
```