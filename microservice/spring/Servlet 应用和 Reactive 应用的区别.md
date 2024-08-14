Servlet 应用与 Reactive 应用在架构、实现方式，以及适用场景上都有显著的区别。Spring 提供了对这两种应用模式的支持，这使得开发者能选择最适合其应用需求和性能要求的模式。

### Servlet 应用

#### 概述

Servlet 应用基于 Java Servlet 规范，是一种同步阻塞模型。它在一次请求处理中占用一个线程，并且每个请求处理都是阻塞的，直到处理完成。

#### 特点

1. **同步阻塞**：
   - 当一个请求到达时，分配一个线程来处理请求，直到处理完成线程才会释放。
   - 由于阻塞和线程数的限制，在高并发情况下性能可能会受到影响。

2. **线程模型**：
   - 基于固定线程池（如 Tomcat、Jetty 等）。每个请求处理需要一个线程，当线程池耗尽时，新的请求会被排队或拒绝。

3. **适用场景**：
   - 普通的 Web 应用，尤其是 I/O 密集度不高且请求处理时间短的应用。
   - 传统的数据库驱动应用（如使用 JDBC），因为多数数据库驱动也是阻塞模式。

#### 示例

Spring MVC 是最常用的 Servlet 应用框架之一。

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MyController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello, Servlet World!";
    }
}
```

### Reactive 应用

#### 概述

Reactive 应用基于 Reactive Streams 规范，是一种非阻塞异步模型。请求处理不直接绑定到特定线程，而是通过事件驱动的方式进行处理。

#### 特点

1. **非阻塞异步**：
   - 请求的处理是非阻塞的，可以使用少量线程处理大量并发请求。
   - 在等待 I/O（如数据库查询、HTTP 调用）时不会阻塞线程，而是通过回调或反应式流（Reactive Streams）来处理。

2. **事件驱动模型**：
   - 基于事件循环的模型，可以使用较少的线程处理。典型实现是 Netty。
   - Reactive 应用处理响应式流，通过 `Mono` 和 `Flux` 这两个主要抽象来处理单值和多值的异步流。

3. **适用场景**：
   - 高并发应用，尤其是 I/O 密集型任务（如大量的数据库操作、外部 HTTP 调用）。
   - 微服务架构中的服务，因为异步非阻塞模型可以提高系统的吞吐量和性能。

#### 示例

Spring WebFlux 是 Spring 提供的反应式 Web 框架。

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
public class MyReactiveController {

    @GetMapping("/hello")
    public Mono<String> hello() {
        return Mono.just("Hello, Reactive World!");
    }
}
```

### 区别总结

1. **同步 vs. 异步**：
   - Servlet：同步阻塞模型，每个请求占用一个线程。
   - Reactive：异步非阻塞模型，请求处理通过事件驱动，不直接绑定线程。

2. **线程模型**：
   - Servlet：基于固定线程池的传统线程模型。
   - Reactive：基于事件循环的轻量级线程模型。

3. **性能与并发**：
   - Servlet：适用于并发请求不多的应用，受限于线程数和阻塞模型。
   - Reactive：适用于高并发和 I/O 密集型应用，通过非阻塞异步模型提升性能和并发处理能力。

4. **编程模型**：
   - Servlet：传统的阻塞编程模型，易于理解和使用，但当涉及到复杂异步I/O时，表现和性能有限。
   - Reactive：更复杂的编程模型，需理解和使用 `Flux` 和 `Mono`，适合处理复杂的异步和并发场景。

### 选择建议

- **选择 Servlet 应用**：如果你的应用对高并发和异步处理要求不高，且你希望使用成熟、理解比较简单的同步阻塞模型。
- **选择 Reactive 应用**：如果你的应用需要处理高并发大量 I/O 操作，或者你需要非阻塞异步处理来提高响应效率和系统吞吐量。

选择合适的架构模式取决于具体应用场景和性能需求。理解两者的差异和各自的优势，有助于做出更符合实际情况的技术决策。