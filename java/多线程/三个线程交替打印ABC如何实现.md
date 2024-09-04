问题描述：写三个线程打印 "ABC"，一个线程打印 A，一个线程打印 B，一个线程打印 C，一共打印 10 轮。

这里提供一个 `Semaphore`版本和 `ReentrantLock` + `Condition` 版本。

#### Semaphore 实现

我们先定义一个类 `ABCPrinter` 用于实现三个线程交替打印 ABC。

```java
public class ABCPrinter {
    private final int max;
    // 从线程 A 开始执行
    private final Semaphore semaphoreA = new Semaphore(1);
    private final Semaphore semaphoreB = new Semaphore(0);
    private final Semaphore semaphoreC = new Semaphore(0);

    public ABCPrinter(int max) {
        this.max = max;
    }

    public void printA() {
        print("A", semaphoreA, semaphoreB);
    }

    public void printB() {
        print("B", semaphoreB, semaphoreC);
    }

    public void printC() {
        print("C", semaphoreC, semaphoreA);
    }

    private void print(String alphabet, Semaphore currentSemaphore, Semaphore nextSemaphore) {
        for (int i = 1; i <= max; i++) {
            try {
                currentSemaphore.acquire();
                System.out.println(Thread.currentThread().getName() + " : " + alphabet);
                // 传递信号给下一个线程
                nextSemaphore.release();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }
        }
    }
}
```

可以看到，我们这里用到了三个信号量，分别用于控制这三个线程的交替执行。`semaphoreA` 信号量先获取，也就是先输出“A”。一个线程执行完之后，就释放下一个信号量。也就是，A 线程执行完之后释放`semaphoreB`信号量，B 线程执行完之后释放`semaphoreC`信号量，以此类推。

接着，我们创建三个线程，分别用于打印 ABC。

```java
ABCPrinter printer = new ABCPrinter(10);
Thread t1 = new Thread(printer::printA, "Thread A");
Thread t2 = new Thread(printer::printB, "Thread B");
Thread t3 = new Thread(printer::printC, "Thread C");

t1.start();
t2.start();
t3.start();
```

输出如下：

Thread A : A
Thread B : B
Thread C : C
......
Thread A : A
Thread B : B
Thread C : C

