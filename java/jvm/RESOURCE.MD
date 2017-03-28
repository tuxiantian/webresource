### 如何使用 jstack 分析线程状态
> http://mp.weixin.qq.com/s/Jr6YrJ2QM5LO06q7EzV8dA
### Java (1) 类的加载机制
> https://mp.weixin.qq.com/s/3LOSQnLNuaa-dEGXA-q4-w
### JVM（2）: JVM 内存结构
> http://mp.weixin.qq.com/s/NpeHBU8VlGNPEMAIefgTvA
### JVM（3）：Java GC 算法垃圾收集器
> http://mp.weixin.qq.com/s/-ujo_noQUM4KLqOPSbQdOw
### JVM（4）：JVM 调优 - 命令篇
> http://mp.weixin.qq.com/s/9iDFxy1N1YKYcCzvis-U6A
### JVM（5）：Tomcat 性能调优和性能监控（visualvm）
> http://mp.weixin.qq.com/s/JKtBW5M3x1MzdDlP7_v93g
### JVM（6）：JVM 调优 - 从 Eclipse 开始
> http://mp.weixin.qq.com/s/RreFWmBGa8Wkyf8RraNROQ
### JVM（7）：JVM 调优 - 工具篇
> http://mp.weixin.qq.com/s/1TmJvnof_yWDAuqffCVhOQ
### JVM（8）：JVM 知识点总览 - 高级 Java 工程师面试必备
> http://mp.weixin.qq.com/s/EDieD01pqJyMIAiTB3V4Eg

JAVA_OPTS="$JAVA_OPTS -Xmn768m -Xms2048m -Xmx2048m -XX:PermSize=128m -XX:MaxPermSize=256m"
--------------------------------------------------------------------------------------
JVM初始分配的内存默认是物理内存的1/64,默认(MinHeapFreeRatio参数可以调整)空余堆内存小于40%时，
JVM就会增大堆直到-Xmx的最大限制,-XX:MinHeapFreeRatio=40.

JVM最大分配的内存默认是物理内存的1/4,默认(MaxHeapFreeRatio参数可以调整)空余堆内存大于70%时，
JVM会减少堆直到 -Xms的最小限制,-XX:MaxHeapFreeRatio=70.
--------------------------------------------------------------------------------------
查看jvm栈深度
jinfo -flag ThreadStackSize 11351（pid）
--------------------------------------------------------------------------------------

强制要求JVM始终抛出含堆栈的异常(-XX:-OmitStackTraceInFastThrow)
--------------------------------------------------------------------------------------