编写一个 Spring Boot Starter 可以帮助你创建可重用的自定义组件，并且可以被多个 Spring Boot 项目方便地使用。一个典型的 Spring Boot Starter 包含以下几个部分：

1. 项目的基本结构
2. 自动配置类（Auto Configuration）
3. 配置属性类（Configuration Properties）
4. 主项目的依赖声明

接下来，我们将逐步讲解如何编写一个简单的 Spring Boot Starter。

### 1. 创建项目结构

首先，创建一个 Maven 项目，并设置基本的 Maven 脚本和项目结构。

假设你要创建一个 `my-starter` 的 Starter，项目结构可能如下：

```
my-starter/
│
├── src/main/java/com/example/mystarter/
│   ├── MyStarterAutoConfiguration.java
│   ├── MyStarterService.java
│   ├── MyStarterProperties.java
│
├── src/main/resources/
│   ├── META-INF/spring.factories
│   ├── application.properties
│
├── pom.xml
```

### 2. 编写 `pom.xml`

首先设置 Maven 项目的 `pom.xml` 文件：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>my-starter</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <dependencies>
        <!-- Spring Boot Starter -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <!-- Spring Boot Auto Configuration -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-autoconfigure</artifactId>
        </dependency>
        <!-- Optional: Configuration Processor for annotation processing -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```

### 3. 编写自动配置类

`MyStarterAutoConfiguration` 类将包含自动配置逻辑。如果符合一定条件（比如设置了某些属性），该类将提供某些 Bean。

```java
package com.example.mystarter;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConditionalOnProperty(prefix = "mystarter", name = "enabled", havingValue = "true", matchIfMissing = true)
public class MyStarterAutoConfiguration {

    @Bean
    public MyStarterService myStarterService(MyStarterProperties properties) {
        return new MyStarterService(properties.getMessage());
    }
}
```

### 4. 编写自定义服务类

`MyStarterService` 类是一个简单的服务类，包含一些 Starter 的基本逻辑。

```java
package com.example.mystarter;

public class MyStarterService {

    private String message;

    public MyStarterService(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }
}
```

### 5. 编写配置属性类

`MyStarterProperties` 类将用于绑定到配置文件中定义的属性。

```java
package com.example.mystarter;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "mystarter")
public class MyStarterProperties {

    private String message = "Hello, World!";

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
```

### 6. 配置 `spring.factories` 文件

在 `src/main/resources/META-INF` 目录下创建 `spring.factories` 文件，用于声明自动配置类。

```properties
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
  com.example.mystarter.MyStarterAutoConfiguration
```

### 7. 使用 Starter 的示例项目

创建一个新的 Spring Boot 应用程序，作为使用 `my-starter` 的示例项目。

#### `pom.xml` 的依赖声明

在示例项目的 `pom.xml` 文件中添加对 `my-starter` 依赖的声明：

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>my-starter</artifactId>
    <version>1.0.0-SNAPSHOT</version>
</dependency>
```

#### `application.properties`

在 `src/main/resources/application.properties` 文件中配置一些属性（可选）：

```properties
mystarter.enabled=true
mystarter.message=Hello from my-starter!
```

#### 示例项目的主类

编写示例项目的主类，使用 `MyStarterService`：

```java
package com.example.demo;

import com.example.mystarter.MyStarterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication implements CommandLineRunner {

    @Autowired
    private MyStarterService myStarterService;

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println(myStarterService.getMessage());
    }
}
```

### 完结

这样，你就成功编写了一个简单的 Spring Boot Starter，现在可以在任何 Spring Boot 项目中通过添加依赖来使用 `my-starter`。

当然，根据需要，你的 Starter 可以包含更多高级功能，比如条件注入、更复杂的配置、集成其他框架等。这个简单的示例为你提供了一个基础框架，供你进一步扩展和优化。