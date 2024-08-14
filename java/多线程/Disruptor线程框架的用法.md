Disruptor 是一个高性能的线程间消息传递库，由 LMAX Exchange 开发，用于提高并发应用程序的性能。它通过使用一种称为“环形缓冲区”（Ring Buffer）的方式来实现生产者和消费者之间的消息传递，从而减少锁的开销和缓存一致性问题。

以下是 Disruptor 线程框架的基本用法：

### 1. 定义事件（Event）

首先，你需要定义一个事件类，这个类将作为环形缓冲区中存储的消息类型。

```java
public class LongEvent {
    private long value;

    public void set(long value) {
        this.value = value;
    }

    public long get() {
        return value;
    }
}
```

### 2. 创建事件工厂

接下来，创建一个事件工厂，用于生成事件实例。

```java
EventFactory<LongEvent> factory = LongEvent::new;
```

### 3. 创建环形缓冲区

然后，创建一个环形缓冲区。你可以选择一个合适的缓冲区大小，这个大小必须是2的幂。

```java
int bufferSize = 1024; // 必须是2的幂
RingBuffer<LongEvent> ringBuffer = RingBuffer.createSingleProducer(factory, bufferSize);
```

### 4. 创建消费者（Consumer）

定义一个或多个消费者，消费者将处理环形缓冲区中的消息。消费者需要实现 `EventProcessor` 接口。

```java
class LongEventHandler implements EventHandler<LongEvent> {
    @Override
    public void onEvent(LongEvent event, long sequence, boolean endOfBatch) {
        System.out.println("Event: " + event.get());
    }
}
```

### 5. 创建事件处理器（Event Processor）

使用消费者创建一个事件处理器。

```java
EventProcessor processor = ringBuffer.newConsumer(LongEventHandler(), new YieldingWaitStrategy());
```

### 6. 启动消费者

启动事件处理器，使其开始处理消息。

```java
processor.start();
```

### 7. 发送消息

生产者可以通过环形缓冲区发送消息。

```java
long sequence = ringBuffer.next(); // 获取下一个可用的序列
try {
    LongEvent event = ringBuffer.get(sequence); // 获取事件实例
    event.set(System.currentTimeMillis()); // 设置事件数据
} finally {
    ringBuffer.publish(sequence); // 发布事件
}
```

### 8. 停止消费者

当不再需要消费者时，可以停止它们。

```java
processor.halt();
```

### 9. 等待消费者完成

在停止消费者之前，确保它们已经处理完所有消息。

```java
processor.shutdown();
```

### 其他策略

Disruptor 还提供了不同的等待策略，例如 `BlockingWaitStrategy`、`SleepingWaitStrategy` 和 `YieldingWaitStrategy`，你可以根据应用程序的需求选择合适的策略。

### 示例代码

```java
public class DisruptorExample {
    public static void main(String[] args) throws InterruptedException {
        EventFactory<LongEvent> factory = LongEvent::new;
        RingBuffer<LongEvent> ringBuffer = RingBuffer.createSingleProducer(factory, 1024);

        LongEventHandler handler = new LongEventHandler();
        EventProcessor processor = ringBuffer.newConsumer(handler, new YieldingWaitStrategy());
        processor.start();

        for (int i = 0; i < 1000; i++) {
            long sequence = ringBuffer.next();
            try {
                LongEvent event = ringBuffer.get(sequence);
                event.set(System.currentTimeMillis());
            } finally {
                ringBuffer.publish(sequence);
            }
        }

        processor.halt();
        processor.shutdown();
    }
}
```

通过这种方式，Disruptor 可以有效地减少线程之间的竞争和锁的开销，提高并发处理能力。