将 Spring Boot 项目打包成 Docker 镜像大致分为以下几个步骤：

**1. 准备项目**

确保你的 Spring Boot 项目可以在本地构建并成功运行。通常情况下，Spring Boot 项目可以打成一个独立的 jar 文件，这个 jar 文件包含了内嵌的 Tomcat 和所有必须的依赖库。

**2. 创建一个 Dockerfile**

在你的 Spring Boot 项目的根目录中创建一个名为 `Dockerfile` 的文本文件，这个文件将包含构建 Docker 镜像的所有指令。

下面是一个基本的 `Dockerfile` 示例：

```
# 使用一个包含 Java 运行环境的基础镜像
FROM openjdk:11-jdk

# 指定维护者信息
LABEL maintainer="name@example.com"

# 将 jar 包添加到容器中，并更名为 app.jar
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

# 指定容器的默认启动命令
ENTRYPOINT ["java","-jar","/app.jar"]

# 容器开放的端口
EXPOSE 8080
```

这里，我们使用了 `openjdk:11-jdk` 作为基础镜像。你可以根据你的应用需求选择适当的 Java 版本。

**3. 构建镜像**

打开终端，在包含 `Dockerfile` 的项目根目录下运行以下命令来构建你的 Docker 镜像：

```bash
docker build -t myapp .
```

这个命令会构建一个新的镜像，并给它打上 `myapp` 的标签。点号 `.` 表示 Dockerfile 位于当前目录。

**4. 运行容器**

一旦镜像构建完成，你可以使用以下命令运行一个容器来测试镜像：

```bash
docker run -p 8080:8080 myapp
```

这条命令会启动一个新的容器，运行你的 Spring Boot 应用，并将容器的 8080 端口映射到宿主机的 8080 端口。

打开浏览器访问 `http://localhost:8080` 来验证你的应用是否正常运行。

**注意**：

- 文件中的 ARG JAR_FILE=target/*.jar 行如果遇到构建问题可能需要指定为具体的 jar 文件名，特别是当你的 target 目录下有多个 jar 文件时。
- 制作 Docker 镜像时，确保你的应用已经被构建（例如使用 `mvn package` 或 `gradle build`），并且 `target` 目录下含有最新的可执行 jar 文件。

以上步骤描述了创建一个简单的 Docker 镜像的过程。根据你的具体需求，如需添加健康检查、设置环境变量、配置多层构建等，可能需要进一步扩展你的 Dockerfile。