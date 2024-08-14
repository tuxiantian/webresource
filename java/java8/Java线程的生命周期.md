Java 线程（Thread）的生命周期包括多个状态，每个状态表明线程在执行过程中的特定阶段。理解线程的生命周期对于编写高效并发程序至关重要。一个 Java 线程的生命周期通常包括以下几种状态：

1. **新建状态（New）**
2. **就绪状态（Runnable）**
3. **运行状态（Running）**
4. **阻塞状态（Blocked）**
5. **等待状态（Waiting）**
6. **限时等待状态（Timed Waiting）**
7. **终止状态（Terminated）**

### 1. 新建状态（New）

当一个线程对象被创建时，新线程处于新建状态。此时线程尚未开始执行。

```java
Thread thread = new Thread();
```

### 2. 就绪状态（Runnable）

当调用 `start()` 方法时，线程进入就绪状态。此时，线程已经准备好运行，但 JVM 的线程调度器尚未将其选中执行。

```java
thread.start();
```

### 3. 运行状态（Running）

当线程调度器选择一个处于就绪状态的线程并赋予CPU时间片，该线程进入运行状态。此时线程中的 `run()` 方法开始执行。

```java
@Override
public void run() {
    // 线程执行的任务
}
```

### 4. 阻塞状态（Blocked）

线程进入阻塞状态是因为它正在等待获取一个内置锁（mutex），例如当线程试图进入一个同步方法但是该方法的锁被另一个线程持有时，线程便进入阻塞状态。

```java
synchronized(lock) {
    // 对临界区进行操作
}
```

### 5. 等待状态（Waiting）

线程进入等待状态表明线程需要等待其他线程显式唤醒。一般通过调用 `Object` 的 `wait()`、`join()` 或 `LockSupport` 的 `park()` 等方法使线程进入此状态。

```java
synchronized(lock) {
    lock.wait();
}

thread.join();

LockSupport.park();
```

### 6. 限时等待状态（Timed Waiting）

线程进入限时等待状态是因为它在等待另一线程的特定时间的操作完成。通常通过调用带有超时参数的方法，如 `sleep(long millis)`、`wait(long timeout)`、`join(long millis)` 或 `LockSupport.parkNanos(nanos)` 等使线程进入此状态。

```java
Thread.sleep(1000);

synchronized(lock) {
    lock.wait(1000);
}

thread.join(1000);

LockSupport.parkNanos(1000000L);
```

### 7. 终止状态（Terminated）

当线程的 `run()` 方法执行完毕或线程被终止时，线程进入终止状态。线程一旦进入此状态，无法再进入任何其他状态。

```java
@Override
public void run() {
    // 线程的任务执行完毕
}
```

### 代码示例

以下是一个简单的代码示例，演示上述线程状态的部分转换过程：

```java
public class ThreadLifecycleDemo {

    public static void main(String[] args) {
        Thread thread = new Thread(() -> {
            System.out.println(Thread.currentThread().getName() + " is running");
            try {
                Thread.sleep(1000);
                synchronized (ThreadLifecycleDemo.class) {
                    ThreadLifecycleDemo.class.wait(1000);
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName() + " is terminating");
        });

        // 线程处于新建状态
        System.out.println(thread.getState()); // NEW

        thread.start();

        // 线程处于就绪状态，随时可能被调度运行
        System.out.println(thread.getState()); // RUNNABLE

        try {
            Thread.sleep(500); // 期间线程会变为运行状态
            System.out.println(thread.getState()); // 可能是 TIMED_WAITING
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        try {
            thread.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // 线程终止后
        System.out.println(thread.getState()); // TERMINATED
    }
}
```

### 解释说明

1. **新建状态**：
   - 创建线程时 `new Thread()`。
   - Thread 对象尚未启动。

2. **就绪状态**：
   - 调用 `start()` 方法后线程进入就绪状态。
   - Thread 对象准备好供 CPU 调度。

3. **运行状态**：
   - 由 JVM 的线程调度器选择获得 CPU 时间片，真正执行 `run()` 代码段。

4. **阻塞状态**：
   - 如 `synchronized` 关键字。
   - 尝试获取内置锁但失败时进入阻塞状态。

5. **等待和限时等待状态**：
   - `wait()` 进入，超时参数或 `sleep()` 类似方法。
   - 等待显式唤醒或等待时间到达进入限时状态。

6. **终止状态**：
   - 完成 `run()` 代码或遇到未捕获异常后。
   - 不可逆转和无法返回其他任何状态。

### 总结

线程生命周期的细节理解，有助于编写高质量，高效，多线程程序，特别在同步和并发控制中的处理。通过认识和利用 Java 提供的线程状态和 API，其更好把控多线程服务稳定性和资源调节。