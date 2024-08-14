Maven多环境打包

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.ai</groupId>
    <artifactId>rgshcore</artifactId>
    <packaging>war</packaging>
    <version>1.0</version>
    <name>rgshcore</name>
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <org.apache.spring.version>3.2.13.RELEASE</org.apache.spring.version>
        <zookeeper.version>3.4.5</zookeeper.version>
        <package.environment>quartz</package.environment>
    </properties>


    <profiles>
        <profile>
            <id>queue</id>
            <properties>
                <!-- 此处package.environment 应该是自定义参数 -->
                <package.environment>queue</package.environment>
            </properties>
        </profile>
        <profile>
            <id>app</id>
            <properties>
                <package.environment>app</package.environment>
            </properties>
            <!-- 默认生成环境 -->
            <!--<activation> <activeByDefault>true</activeByDefault> </activation> -->
        </profile>
        <profile>
            <id>test</id>
            <properties>
                <!-- 此处release.file 应该是自定义参数 -->
                <release.file>test</release.file>
            </properties>
        </profile>
        <profile>
            <id>product</id>
            <properties>
                <release.file>product</release.file>
            </properties>
        </profile>
    </profiles>

    <build>
        <plugins>
            <!-- 打包 -->
            <plugin>
                <artifactId>maven-antrun-plugin</artifactId>
                <executions>
                    <execution>
                        <phase>compile</phase>
                        <goals>
                            <goal>run</goal>
                        </goals>
                        <configuration>
                            <tasks>
                                <!-- 可以显示打包的环境 -->
                           			<echo>@@@@@@@@@@@@@@@@@@${package.environment}@@@@@@@@@@@@@@@@@@@@@</echo>
                                	<echo>@@@@@@@@@@@@@@@@@@${release.file}@@@@@@@@@@@@@@@@@@@@@</echo>
                            </tasks>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <!-- 打包 -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <configuration>
                    <archive>
                        <addMavenDescriptor>false</addMavenDescriptor>
                    </archive>
                    <warName>rgshcore</warName>
                    <!-- 过滤不打的文件 -->
                    <packagingExcludes>WEB-INF/classes/spring/app/**,WEB-INF/classes/spring/queue/**,WEB-INF/classes/config/product/**,WEB-INF/classes/config/test/**					</packagingExcludes>
                    <webResources>
                        <resource>
                            <directory>src/main/resources/spring/${package.environment}/</directory>
                            <targetPath>WEB-INF/classes/spring</targetPath>
                            <filtering>true</filtering>
                        </resource>
                        <resource>
                            <directory>src/main/resources/config/${release.file}/</directory>
                            <targetPath>WEB-INF/classes/config</targetPath>
                            <filtering>true</filtering>
                        </resource>
                    </webResources>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```
打包命令
mvn package -P queue -P test