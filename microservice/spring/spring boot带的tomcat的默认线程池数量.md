Spring Boot 使用内嵌的 Tomcat 作为默认的嵌入式服务器，并且它会自动配置 Tomcat 的线程池。内嵌 Tomcat 的线程池默认参数由 `server.tomcat.max-threads` 属性指定。

### 默认线程池配置

内嵌的 Tomcat 的默认线程池最大线程数是 `200`。这意味着 Tomcat 在高负载情况下可以同时处理 200 个并发请求。如果超过这个数量，新的请求将在队列中等待，直到有空闲线程可用。

```properties
server.tomcat.max-threads=200
```

上述配置表示 Tomcat servlet 容器最多支持 200 个线程来处理并发请求。

### 如何查看和修改默认线程池配置

你可以在 `application.properties` 或 `application.yml` 文件中配置 Tomcat 的线程池属性。

#### 在 `application.properties` 文件中配置：

```properties
server.tomcat.max-threads=200
# 如果你想修改为其他值，比如 300，可以这样设置：
server.tomcat.max-threads=300
```

#### 在 `application.yml` 文件中配置：

```yaml
server:
  tomcat:
    max-threads: 200
# 如果你想修改为其他值，比如 300，可以这样设置：
  tomcat:
    max-threads: 300
```

### 其他相关配置参数

除了 `server.tomcat.max-threads`，你还可以配置以下一些相关参数来调整 Tomcat 的性能：

- **`server.tomcat.min-spare-threads`**：Tomcat 在启动时创建的最小线程数。这个值帮助确保系统在初始启动时有足够的线程来处理请求。

    ```properties
    server.tomcat.min-spare-threads=10
    ```

- **`server.tomcat.accept-count`**：Tomcat 在达到最大线程数时，可以接受的等待请求的最大数量。如果超过这个数量，新的请求将被拒绝。

    ```properties
    server.tomcat.accept-count=100
    ```

- **`server.tomcat.max-connections`**：Tomcat 允许的最大连接数，包括正在处理的请求和等待的请求。它是一个表示同时连接数（包括正在处理和等待处理的）的上限值。

    ```properties
    server.tomcat.max-connections=10000
    ```

### 示例

假设你有一个高并发的应用，需要修改 Tomcat 的默认线程池配置，你可以将这些参数添加到你的 `application.properties` 文件中：

```properties
server.tomcat.max-threads=300
server.tomcat.min-spare-threads=50
server.tomcat.accept-count=200
server.tomcat.max-connections=15000
```

这些修改会确保 Tomcat 能够处理更多的并发请求，并有更高的连接数上限。

### 总结

Spring Boot 内嵌的 Tomcat 服务器的默认线程池最大线程数是 200，但通过修改 `application.properties` 或 `application.yml` 文件中的配置，可以根据应用的实际需求对线程池大小进行调整。这些配置有助于在高并发环境下确保应用的性能和稳定性。

如果有任何其他问题或需要更详细的解释，请随时提问。