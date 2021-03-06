### 解决Maven报Plugin execution not covered by lifecycle configuration
> Plugin execution not covered by lifecycle configuration: org.apache.maven.plugins:maven-antrun-plugin:1.3:run (execution: default, phase: compile)

<plugins> 标签外再套一个 <pluginManagement> 标签，我试验是成功的。详情如下：  
[ 解决Maven报Plugin execution not covered by lifecycle configuration](http://blog.csdn.net/xxd851116/article/details/25197373)
### The Central Repository
> https://search.maven.org/
> http://mvnrepository.com/tags/maven
### 常用Maven插件介绍
> http://www.importnew.com/23928.html
### 处理私有jar的两种方式
#### 使用私服nexus
填好GAV，上传私有jar，pom文件中添加依赖。jar包的GAV可以随意指定。
#### 设置maven参数的方式
```
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.1</version>
    <configuration>
        <source>1.8</source>
        <target>1.8</target>
        <encoding>UTF-8</encoding>  <!-- “编码 GBK 的不可映射字符”问题的解决 -->
        <compilerArgs>
            <arg>-verbose</arg>
            <arg>-Xlint:unchecked</arg>
            <arg>-Xlint:deprecation</arg>
            <!--<arg>-bootclasspath</arg>
            <arg>${JAVA_HOME}/jre/lib/rt.jar,${JAVA_HOME}/jre/lib/jce.jar</arg>-->
            <arg>-extdirs</arg>
            <arg>${project.basedir}/src/main/webapp/WEB-INF/lib</arg>
        </compilerArgs>
    </configuration>
</plugin>
```
`-extdirs`指定编译过程中使用外部的jar
##### 本地开发
* 使用eclipse: 选中jar，右键add build path；
* 使用idea: project structure->modules->选中项目->Dependencies->点击加号添加jar
### 配置maven仓库的镜像地址
```
    <mirrors>
        <mirror>
            <id>alimaven</id>
            <name>aliyun maven</name>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
        <mirror>
            <id>mvnrepository</id>
            <name>mvnrepository Central</name>
            <url>http://mvnrepository.com/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
        <mirror>
            <id>ibiblio</id>
            <name>ibiblio Central</name>
            <url>http://mirrors.ibiblio.org/maven2/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
        <mirror>
            <id>CN</id>
            <name>OSChina Central</name>
            <url>http://maven.oschina.net/content/groups/public/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>
```
maven中的仓库分为两种，snapshot快照仓库和release发布仓库
snapshot快照仓库用于保存开发过程中的不稳定版本，release正式仓库则是用来保存稳定的发行版本
```
<groupId>cc.mzone</groupId>
<artifactId>m1</artifactId>
<version>0.1-SNAPSHOT</version>
<packaging>jar</packaging>
```
在maven本地仓库的groupId/artifactId/version文件路径下会存在maven-metadata.xml文件，会记录版本信息

频率共有四种，分别是always、daily、interval:XXX、never
always是每次都去远程仓库查看是否有更新，
daily是只在第一次的时候查看是否有更新，当天的其它时候则不会查看；
interval允许设置一个分钟为单位的间隔时间，在这个间隔时间内只会去远程仓库中查找一次，
never是不会去远程仓库中查找
```
<repository>
    <id>myRepository</id>
    <url>...</url>
    <snapshots>
        <enabled>true</enabled>
        <updatePolicy>XXX</updatePolicy>
        <checksumPolicy>warn</checksumPolicy>
    </snapshots>
</repository>
```
## 常用的mvn命令
mvn verify 运行检查以证实生成的包是有效的，达到质量标准的
mvn dependency:analyze,使用该命令就可以看到maven分析的结果和建议
mvn dependency:tree -Dverbose,maven依赖jar包冲突
mvn dependency:tree,使用该命令可以看到maven的依赖树
mvn dependency:tree -Doutput=tree.txt,将maven的依赖树导出到tree.txt
mvn clean package -Dmaven.test.skip=true 忽略测试进行打包
mvn:deploy在整合或者发布环境下执行,将最终版本的包拷贝到远程的repository,使得其他的开发者或者工程可以共享
mvn install 安装当前工程的输出文件到本地仓库
mvn调试信息：
比如：mvn -X -e clean compile
-e:打印错误信息
-X:代表debug模式
Dt 插件相关参
U 强制更新
--------------------------------------------------------------------------------------
maven采用约定优于配置的策略
--------------------------------------------------------------------------------------
时区是UTC
```
<properties>
    <maven.build.timestamp.format>yyyyMMddHHmmss</maven.build.timestamp.format>
</properties>

<plugin>
   <groupId>org.apache.maven.plugins</groupId>
   <artifactId>maven-war-plugin</artifactId>
   <version>2.4</version>
   <configuration>
     <warName>showcase-${maven.build.timestamp}</warName>
   </configuration>
</plugin>
```
要使用GMT+8，就需要插件提供支持，我用的是build-helper-maven-plugin
--------------------------------------------------------------------------------------
maven maven-jar-plugin插件
打包命令mvn clean package
--------------------------------------------------------------------------------------
Maven Release Plugin只能以-SNAPSHOT结尾

versions-maven-plugin
把父模块更新到指定版本号，然后更新子模块，与父模块有相同的版本号
mvn versions:set -DnewVersion=0.0.4-SNAPSHOT
mvn -N versions:update-child-modules

#撤销
mvn versions:revert
#提交
mvn versions:commit
--------------------------------------------------------------------------------------
maven-compiler-plugin用来编译Java代码
maven-resources-plugin则用来处理资源文件
--------------------------------------------------------------------------------------
optional：可选依赖，true 不会传递，false会传递（默认）
```
<dependency>
   <groupId>mysql</groupId>
   <artifactId>mysql-connector-java</artifactId>
   <version>5.1.10</version>
   <optional>true</optional>
</dependency>
```

exclusions排除依赖
```
<dependency>
    <groupId>commons-configuration</groupId>
    <artifactId>commons-configuration</artifactId>
    <version>1.9</version>
    <exclusions>
        <exclusion>
            <groupId>commons-lang</groupId>
            <artifactId>commons-lang</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```
归类依赖
```
<properties>
    <spring>2.5.6</spring>
</properties>
```

```
<groupId>org.apache.maven.plugins</groupId>
<artifactId>maven-compiler-plugin</artifactId>
<version>2.3.2</version>
<configuration>
    <source>1.6</source>
    <target>1.6</target>
    <encoding>UTF-8</encoding>
    <!-- 解决maven编译时用到com.sun.*包下的东西 -->
    <compilerArguments>
        <verbose />
        <bootclasspath>${env.JAVA_HOME}\jre\lib\rt.jar;${env.JAVA_HOME}\jre\lib\jce.jar</bootclasspath>
    </compilerArguments>

</configuration>
</plugin>
```
--------------------------------------------------------------------------------------
```
<!-- 复制依赖的插件 -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-dependency-plugin</artifactId>
    <executions>
        <execution>
            <id>copy-dependencies</id>
            <phase>package</phase>
            <goals>
                <goal>copy-dependencies</goal>
            </goals>
            <configuration>
                <outputDirectory>${project.build.directory}/lib</outputDirectory>
                <overWriteReleases>false</overWriteReleases>
                <overWriteSnapshots>true</overWriteSnapshots>
            </configuration>
        </execution>
    </executions>
</plugin>

<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <configuration>
        <archive>
            <manifest>
                <addClasspath>true</addClasspath>
                <classpathPrefix>lib/</classpathPrefix>
                <mainClass>com.weibosdk.listener.boot.ListenerBootstrap</mainClass>
            </manifest>
        </archive>
    </configuration>
</plugin>

mvn clean package -Dmaven.test.skip=true
```
--------------------------------------------------------------------------------------
部署到远程仓库
```
<distributionManagement>
	<repository>
		<id>nexus-releases</id>
		<name>Nexus Release Repository</name>
		<url>http://127.0.0.1:8080/nexus/content/repositories/releases/</url>
	</repository>
	<snapshotRepository>
		<id>nexus-snapshots</id>
		<name>Nexus Snapshot Repository</name>
		<url>http://127.0.0.1:8080/nexus/content/repositories/snapshots/</url>
	</snapshotRepository>
</distributionManagement>
```
--------------------------------------------------------------------------------------
```
mvn dependency:sources -DincludeArtifactIds=guava
mvn dependency:sources -DincludeGroupIds=com.jcraft,org.testng -Dclassifier=sources

mvn -DgroupId=com.google.code.gson
  -DartifactId=gson
  -Dversion=2.6.2
  -Dclassifier=sources
  -DremoteRepositories=http://nexus.dmz1.heuboe.hbintern:8080/nexus/content/repositories/central/
  org.apache.maven.plugins:maven-dependency-plugin:2.10:get

maven -DgroupId=com.google.code.gson -DartifactId=gson -Dversion=2.6.2
-Dclassifier=sources org.apache.maven.plugins:maven-dependency-plugin:2.10:get
```
--------------------------------------------------------------------------------------

```
<plugin>
	<!-- 发布插件 -->
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-deploy-plugin</artifactId>
	<version>2.8.2</version>
	<configuration>
      <skip>true</skip>
    </configuration>
</plugin>
```
跳过测试
--------------------------------------------------------------------------------------
mvn help: active-Profiles来查看处于激活状态的profiles
```
<profile>
    <!-- 开发环境 -->
    <id>dev</id>
    <properties>
        <db-username>***</db-username>
    </properties>
    <!-- 默认激活本环境 -->
    <activation>
        <activeByDefault>true</activeByDefault>
    </activation>
</profile>
```
maven package -P dev
将自动打包成dev环境的部署包

mvn clean install -Dmaven.test.skip -Denv=release -Denv=dev 语句创建一个名为 env 的系统属性，并将其值设为 dev，这激活了开发配置

## Maven常见的依赖范围有哪些?
compile:编译依赖,默认的依赖方式,在编译（编译项目和编译测试用例）,运行测试用例,运行（项目实际运行）三个阶段都有效,
典型地有spring-core等jar
test:测试依赖,只在编译测试用例和运行测试用例有效,典型地有JUnit
provided:对于编译和测试有效,不会打包进发布包中,典型的例子为servlet-api,一般的web工程运行时都使用容器的servlet-api
runtime:只在运行测试用例和实际运行时有效,对于测试和运行classpath有效,但在编译主代码时无效,典型地是jdbc驱动jar包
system: 不从maven仓库获取该jar,而是通过systemPath指定该jar的路径
import: 用于一个dependencyManagement对另一个dependencyManagement的继承

依赖范围compile使用举例
```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>3.1.0</version>
    <scope>compile</scope>
</dependency>
```

添加上面的依赖后可以使用request.getServletContext().getRealPath(uploadPath)
代替下面的代码
request.getSession().getServletContext().getRealPath(uploadPath)
tomcat的lib包下面包含servlet-api.jar