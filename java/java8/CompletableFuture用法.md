`CompletableFuture` 是 Java 8 引入的强大工具，用于处理异步编程。它提供了一个非阻塞的编程模型，允许你通过多种方式组合和处理异步任务。下面是 `CompletableFuture` 的主要用法和几个示例代码。

### 1. 创建 `CompletableFuture`

#### 1.1 创建一个立即完成的 `CompletableFuture`

```java
CompletableFuture<String> future = CompletableFuture.completedFuture("Hello");
```

#### 1.2 创建一个新任务的 `CompletableFuture`

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> "Hello");
```

### 2. 链式操作

#### 2.1 使用 `thenApply`

`thenApply` 方法在 `CompletableFuture` 完成后处理结果并返回一个新结果。

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> "Hello")
                                                   .thenApply(result -> result + " World");
future.thenAccept(System.out::println);  // 输出：Hello World
```

#### 2.2 使用 `thenAccept`

`thenAccept` 方法在 `CompletableFuture` 完成后处理结果但不返回新结果。

```java
CompletableFuture.supplyAsync(() -> "Hello")
                 .thenAccept(result -> System.out.println("Result: " + result));  // 输出：Result: Hello
```

#### 2.3 使用 `thenRun`

`thenRun` 方法在 `CompletableFuture` 完成后运行一个 `Runnable`，但是不需传递结果。

```java
CompletableFuture.supplyAsync(() -> "Hello")
                 .thenRun(() -> System.out.println("Task finished"));  // 输出：Task finished
```

### 3. 组合多个 `CompletableFuture`

#### 3.1 使用 `thenCombine`

连接两个 `CompletableFuture` 的结果。

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> "Hello");
CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> "World");

CompletableFuture<String> combinedFuture = future1.thenCombine(future2, (result1, result2) -> result1 + " " + result2);
combinedFuture.thenAccept(System.out::println);  // 输出：Hello World
```

#### 3.2 使用 `allOf`

等待多个 `CompletableFuture` 都完成。

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> "Task 1");
CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> "Task 2");

CompletableFuture<Void> combinedFuture = CompletableFuture.allOf(future1, future2);

combinedFuture.thenRun(() -> System.out.println("All tasks completed"));
```

#### 3.3 使用 `anyOf`

只要任意一个 `CompletableFuture` 完成即可。

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> "Task 1");
CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> "Task 2");

CompletableFuture<Object> anyFuture = CompletableFuture.anyOf(future1, future2);

anyFuture.thenAccept(result -> System.out.println("First completed task: " + result));
```

### 4. 异常处理

#### 4.1 使用 `exceptionally`

处理计算过程中抛出的异常。

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    if (Math.random() > 0.5) {
        throw new RuntimeException("Something went wrong");
    }
    return "Hello";
});

future.exceptionally(ex -> "Error: " + ex.getMessage())
      .thenAccept(result -> System.out.println("Result: " + result));
```

#### 4.2 使用 `handle`

无论是否出现异常，都会处理结果。

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    if (Math.random() > 0.5) {
        throw new RuntimeException("Something went wrong");
    }
    return "Hello";
});

future.handle((result, ex) -> {
    if (ex != null) {
        return "Error: " + ex.getMessage();
    } else {
        return result;
    }
}).thenAccept(System.out::println);
```

### 5. 阻塞等待

虽然 `CompletableFuture` 是非阻塞模型，但有时你需要等待结果。你可以使用 `get()` 方法，它会阻塞到 CompletableFuture 完成。

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> "Hello");

try {
    String result = future.get();  // 这会阻塞直到结果计算完成
    System.out.println(result);     // 输出：Hello
} catch (InterruptedException | ExecutionException e) {
    e.printStackTrace();
}
```

### 6. 取消任务

你可以取消一个尚未完成的 `CompletableFuture`。

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    try {
        Thread.sleep(5000);
    } catch (InterruptedException e) {
        throw new IllegalStateException(e);
    }
    return "Completed";
});

future.cancel(true);  // 取消任务

future.thenAccept(System.out::println)
      .exceptionally(ex -> {
          System.out.println("Task was cancelled");
          return null;
      });
```

### 总结

`CompletableFuture` 提供了丰富的 API 来处理异步编程任务，不仅支持基本的异步任务执行，还提供了多种操作来组合和处理多个异步任务，并且具备强大的异常处理能力。使用 `CompletableFuture` 可以大大简化复杂的异步编程逻辑。

通过这些示例，你应该能够掌握 `CompletableFuture` 的基本用法。如果你有任何进一步的问题或需要更深入的解释，请随时提问！