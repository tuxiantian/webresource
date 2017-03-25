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
<groupId>cc.mzone</groupId>
<artifactId>m1</artifactId>
<version>0.1-SNAPSHOT</version>
<packaging>jar</packaging>

在maven本地仓库的groupId/artifactId/version文件路径下会存在maven-metadata.xml文件，会记录版本信息

频率共有四种，分别是always、daily、interval:XXX、never
always是每次都去远程仓库查看是否有更新，
daily是只在第一次的时候查看是否有更新，当天的其它时候则不会查看；
interval允许设置一个分钟为单位的间隔时间，在这个间隔时间内只会去远程仓库中查找一次，
never是不会去远程仓库中查找

<repository>
    <id>myRepository</id>
    <url>...</url>
    <snapshots>
        <enabled>true</enabled>
        <updatePolicy>XXX</updatePolicy>
        <checksumPolicy>warn</checksumPolicy>
    </snapshots>
</repository>


--------------------------------------------------------------------------------------
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
<dependency>
   <groupId>mysql</groupId>
   <artifactId>mysql-connector-java</artifactId>
   <version>5.1.10</version>
   <optional>true</optional>
</dependency>
--------------------------------------------------------------------------------------
exclusions排除依赖

归类依赖
<properties>
    <spring>2.5.6</spring>
</properties>

--------------------------------------------------------------------------------------
部署至远程仓库

--------------------------------------------------------------------------------------
maven具有三个独立的生命周期：clean、defeat、site
--------------------------------------------------------------------------------------
mvn install:install-file -Dfile=jar包的位置 -DgroupId=上面的groupId
-DartifactId=上面的artifactId -Dversion=上面的version -Dpackaging=jar
--------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------

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
--------------------------------------------------------------------------------------
部署到远程仓库
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
--------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------
mvn verify 运行检查以证实生成的包是有效的，达到质量标准的

--------------------------------------------------------------------------------------

<plugin>
	<!-- 发布插件 -->
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-deploy-plugin</artifactId>
	<version>2.8.2</version>
	<configuration>
      <skip>true</skip>
    </configuration>
</plugin>

跳过测试
--------------------------------------------------------------------------------------
mvn help: active-Profiles来查看处于激活状态的profiles

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
maven package -P dev
将自动打包成dev环境的部署包
--------------------------------------------------------------------------------------
mvn clean install -Dmaven.test.skip -Denv=release
-Denv=dev 语句创建一个名为 env 的系统属性，并将其值设为 dev，这激活了开发配置
--------------------------------------------------------------------------------------
mvn:deploy在整合或者发布环境下执行,将最终版本的包拷贝到远程的repository,使得其他的开发者或者工程可以共享
mvn install 安装当前工程的输出文件到本地仓库
--------------------------------------------------------------------------------------
maven的仲裁
根据从根节点到各个组件节点之间的路径深度,路径短的组件优先,如果路径深度相同,则是先发现的那个
类似一棵树的广度遍历
--------------------------------------------------------------------------------------
父模块
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
        </dependency>
    </dependencies>
</dependencyManagement>

<dependency>
  <groupId>junit</groupId>
  <artifactid>junit</artifactId>
</dependency>

<properties>
    <hibernate.annotations.version>3.3.0.ga</hibernate.annotations.version>
</properties>

mvn dependency:analyze,使用该命令就可以看到maven分析的结果和建议
mvn dependency:tree,使用该命令可以看到maven的依赖树
--------------------------------------------------------------------------------------
Maven对重复依赖的解决方案
最短路径原则
声明优先原则 按照依赖包在pom.xml中声明的先后顺序,优先选择先声明的包
--------------------------------------------------------------------------------------