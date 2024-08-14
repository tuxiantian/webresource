---
typora-root-url: ..\..
---

Maven手动添加JAR包到本地仓库

Maven 确确实实是个好东西，用来管理项目显得很方便，但是如果是通过 Maven 来远程下载 JAR 包的话，我宿舍的带宽是4兆的，
4个人共用，有时候用 Maven 来远程下载 JAR 包会显得很慢，一般我发现下载速度不明显的时候，我就 Ctrl + C 来终止它的下载。
然后改用手动来下载，因为用迅雷一类的工具来下载会快很多。我机子上 Maven 的本地仓库的很多 JAR 包我都是手动下载的。
手动下载的话就会带来一个问题，就是，怎么样手动将下载下来的 JAR 包添加到 Maven 的本地仓库。关于这个，网上也有很多资料。
我说下我的做法。
首先，
推荐几个好的 Maven 常用仓库网址：  
http://mvnrepository.com/  
http://search.maven.org/  
http://repository.sonatype.org/content/groups/public/  
http://people.apache.org/repo/m2-snapshot-repository/  
http://people.apache.org/repo/m2-incubating-repository/  

第一个是我最常用的，然后是第二个，然后是第三个，最后两个是 Apache 的私有仓库，我还没用过，不过感觉应该还可以吧...
接下来，还是一贯的作风，使用截图通俗易懂的方式来解说：

如果你看过我的上一篇：Spring邮件服务之Html：Maven + Spring SMTP Mail With Html 文章，里面需要用到一个
spring-context-support-3.1.0.RELEASE.jar 的 JAR 包，我把它安装到本地仓库的时候把图截了下来，顺便写了这篇文章，
供有需要的网友参考。
首先，到 http://mvnrepository.com/ 这个网，在搜索栏中输入你要搜索的 JAR 包的关键字来搜索，下面直接贴图：

@1图
![](/images/java/maven/Maven手动添加JAR包到本地仓库/1.jpg)

@2图
![](/images/java/maven/Maven手动添加JAR包到本地仓库/2.jpg)

@3图
![](/images/java/maven/Maven手动添加JAR包到本地仓库/3.jpg)

以 spring-context-support-3.1.0.RELEASE.jar 为例，在 @3图中已经给出这个 jar 包的 groupId，artifactId，version信息，
手动安装的时候这些信息不要改，否则 Maven 项目移植的话，jar 包下载就会失败。顺便把这信息帖下面，方便对照：

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context-support</artifactId>
    <version>3.1.0.RELEASE</version>
</dependency>
```

# Maven 安装 JAR 包的命令


mvn install:install-file -Dfile=jar包的位置 -DgroupId=上面的groupId -DartifactId=上面的artifactId -Dversion=上面的version -Dpackaging=jar

例如：
我下载的这个 jar 包是放到了 D:\mvn 目录下(D:\mvn\spring-context-support-3.1.0.RELEASE.jar)
那么我在 cmd 中敲入的命令就应该是：
```
mvn install:install-file -Dfile=D:\mvn\spring-context-support-3.1.0.RELEASE.jar -DgroupId=org.springframework -DartifactId=spring-context-support -Dversion=3.1.0.RELEASE -Dpackaging=jar
```
回车，显示安装成功：

![](/images/java/maven/Maven手动添加JAR包到本地仓库/4.jpg)