`HashMap` 是 Java 中的一个非常重要的数据结构，用于存储键值对（key-value pairs）。以下是 `HashMap` 的一些底层原理：

1. **数组 + 链表/红黑树**：`HashMap` 底层是一个数组结构，数组中的每个元素称为一个“桶”（bucket）。当插入元素时，首先通过键（key）的哈希值计算出它在数组中的索引位置。如果数组的该位置还没有元素，就直接存储；如果已经有元素，则需要解决冲突。
2. **哈希函数**：`HashMap` 使用键对象的 `hashCode()` 方法来计算哈希值，然后通过哈希值来确定元素在数组中的索引位置。一个好的哈希函数可以减少哈希冲突，提高性能。
3. **冲突解决**：当多个键的哈希值映射到同一个数组索引时，会发生冲突。`HashMap` 通过链表来解决冲突，即使用链表将映射到同一个索引的所有键值对连接起来。当链表长度超过一定阈值（默认为8）时，链表会转化为红黑树，以提高搜索效率。
4. **负载因子**：`HashMap` 有一个负载因子（load factor），用于衡量哈希表的满度。当实际存储的元素数量达到数组容量与负载因子的乘积时，`HashMap` 会进行扩容操作，通常是数组容量的2倍。
   在 Java 的 `HashMap` 实现中，默认的负载因子是 **0.75**。这意味着当 `HashMap` 中的元素数量达到其容量与 0.75 的乘积时，`HashMap` 会进行扩容操作。

负载因子是一个重要的参数，因为它影响着 `HashMap` 在内存使用和性能之间的权衡：

- **较低的负载因子**：可以减少哈希冲突，提高搜索效率，但会增加内存使用。
- **较高的负载因子**：可以减少内存使用，但可能会增加哈希冲突，降低搜索效率。

因此，选择一个合适的负载因子对于优化 `HashMap` 的性能非常重要。在 Java 中，0.75 被认为是一个平衡内存和性能的较好选择。当然，你也可以在创建 `HashMap` 对象时通过构造函数指定不同的负载因子。

1. **扩容和重哈希**：扩容时，`HashMap` 会创建一个新的数组，并把旧数组中的所有元素重新映射到新数组中。这个过程称为“重哈希”。重哈希是一个成本较高的操作，因为它涉及到重新计算每个元素在新数组中的索引位置。
2. **null 键和null值**：`HashMap` 允许一个 `null` 键和多个 `null` 值。`null` 键总是映射到数组的第一个索引位置。
3. **并发问题**：`HashMap` 不是线程安全的。在多线程环境下，如果需要线程安全，可以使用 `Collections.synchronizedMap(new HashMap<...>())` 来包装 `HashMap`，或者使用 `ConcurrentHashMap`。
  验证 `HashMap` 不是线程安全的，可以通过编写一个简单的多线程程序来展示在并发环境下 `HashMap` 可能遇到的问题。以下是一个简单的示例，演示了如何验证 `HashMap` 在多线程环境中的行为：

```java
import java.util.HashMap;
import java.util.Map;

public class HashMapThreadSafetyTest {
    private static final int THREAD_COUNT = 10000;
    private static final Map<String, Integer> map = new HashMap<>();

    public static void main(String[] args) {
        for (int i = 0; i < THREAD_COUNT; i++) {
            final int threadId = i;
            new Thread(() -> {
                map.put("key" + threadId, threadId);
            }).start();
        }

        try {
            Thread.sleep(1000); // 等待所有线程执行完成
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Expected size: " + THREAD_COUNT);
        System.out.println("Actual size: " + map.size());
    }
}
```

在这个示例中：

1. 创建了一个 `HashMap` 并初始化了一个固定大小的线程池。
2. 每个线程尝试向 `HashMap` 中添加一个键值对，键是 `"key" + threadId`，值是 `threadId`。
3. 所有线程几乎同时开始执行，尝试向 `HashMap` 添加元素。
4. 等待一段时间后（例如1000毫秒），打印出期望的 `HashMap` 大小和实际的大小。

由于 `HashMap` 不是线程安全的，以下情况可能会发生：
- **数据丢失**：某些线程可能在添加元素时被覆盖。
- **数据不一致**：实际的 `HashMap` 大小可能小于预期的大小。

运行这个程序，你可能会看到实际的 `HashMap` 大小小于预期的大小，这是因为多个线程同时修改 `HashMap` 时发生了数据覆盖和丢失。

### 替代方案：使用 `ConcurrentHashMap`

如果你需要一个线程安全的 `HashMap`，可以使用 `ConcurrentHashMap`：

```java
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;

public class ConcurrentHashMapThreadSafetyTest {
    private static final int THREAD_COUNT = 10000;
    private static final Map<String, Integer> map = new ConcurrentHashMap<>();

    public static void main(String[] args) {
        for (int i = 0; i < THREAD_COUNT; i++) {
            final int threadId = i;
            new Thread(() -> {
                map.put("key" + threadId, threadId);
            }).start();
        }

        try {
            Thread.sleep(1000); // 等待所有线程执行完成
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Expected size: " + THREAD_COUNT);
        System.out.println("Actual size: " + map.size());
    }
}
```

在这个示例中，使用 `ConcurrentHashMap` 替代 `HashMap`。由于 `ConcurrentHashMap` 是线程安全的，你通常会得到预期的 `HashMap` 大小，即 `THREAD_COUNT`。

4. **迭代器的快速失败**：`HashMap` 的迭代器是快速失败的，意味着在迭代过程中如果检测到 `HashMap` 被修改，迭代器会立即抛出 `ConcurrentModificationException`。
5. **`Entry` 对象**：`HashMap` 中的每个键值对都由一个 `Entry` 对象表示。`Entry` 对象包含键、值和指向下一个 `Entry` 的引用（在链表中）。
6. **性能考虑**：`HashMap` 的性能在很大程度上取决于哈希函数的质量以及负载因子的选择。一个好的哈希函数可以均匀分布键，减少冲突，而合适的负载因子可以平衡内存使用和性能。

这些是 `HashMap` 的一些基本工作原理，它们共同确保了 `HashMap` 作为一种高效的键值存储结构。

在迭代 `HashMap` 的时候直接修改它（例如添加、删除键值对）是不安全的，因为这可能会破坏迭代器的内部状态，导致 `ConcurrentModificationException` 异常。为了在迭代过程中安全地修改 `HashMap`，你可以采取以下几种方法：

1. **使用迭代器的 `remove` 方法**：
   如果你需要在迭代过程中删除元素，可以使用迭代器的 `remove` 方法。这是在迭代过程中修改 `HashMap` 的唯一安全方式。

   ```java
   HashMap<String, Integer> map = new HashMap<>();
   map.put("one", 1);
   map.put("two", 2);
   map.put("three", 3);

   Iterator<Map.Entry<String, Integer>> iterator = map.entrySet().iterator();
   while (iterator.hasNext()) {
       Map.Entry<String, Integer> entry = iterator.next();
       if (entry.getValue() > 1) {
           iterator.remove(); // 安全删除元素
       }
   }
   ```

2. **使用 `keySet` 的迭代器**：
   如果你需要在迭代过程中删除键值对，可以使用 `keySet()` 方法获取键的集合，然后迭代这个集合并从 `HashMap` 中删除相应的键值对。

   ```java
   HashMap<String, Integer> map = new HashMap<>();
   map.put("one", 1);
   map.put("two", 2);
   map.put("three", 3);

   Iterator<String> keyIterator = map.keySet().iterator();
   while (keyIterator.hasNext()) {
       String key = keyIterator.next();
       if (map.get(key) > 1) {
           map.remove(key); // 安全删除键值对
       }
   }
   ```

3. **收集要删除的键，迭代结束后删除**：
   你可以在第一次迭代中收集所有需要删除的键，然后在迭代结束后删除它们。

   ```java
   HashMap<String, Integer> map = new HashMap<>();
   map.put("one", 1);
   map.put("two", 2);
   map.put("three", 3);

   List<String> keysToRemove = new ArrayList<>();
   for (Map.Entry<String, Integer> entry : map.entrySet()) {
       if (entry.getValue() > 1) {
           keysToRemove.add(entry.getKey());
       }
   }

   for (String key : keysToRemove) {
       map.remove(key);
   }
   ```

4. **使用 `compute` 方法**：
   如果你需要在迭代过程中更新值，可以使用 `compute` 方法。这种方法允许你在不触发 `ConcurrentModificationException` 的情况下更新值。

   ```java
   HashMap<String, Integer> map = new HashMap<>();
   map.put("one", 1);
   map.put("two", 2);
   map.put("three", 3);

   for (Map.Entry<String, Integer> entry : map.entrySet()) {
       if (entry.getValue() > 1) {
           map.compute(entry.getKey(), (k, v) -> v + 1); // 更新值
       }
   }
   ```

5. **使用 `computeIfPresent` 方法**：
   如果你需要在迭代过程中根据条件更新值，可以使用 `computeIfPresent` 方法。

   ```java
   HashMap<String, Integer> map = new HashMap<>();
   map.put("one", 1);
   map.put("two", 2);
   map.put("three", 3);

   for (Map.Entry<String, Integer> entry : map.entrySet()) {
       if (entry.getValue() > 1) {
           map.computeIfPresent(entry.getKey(), (k, v) -> v + 1); // 条件更新值
       }
   }
   ```

使用这些方法可以确保在迭代 `HashMap` 的同时安全地修改它，避免 `ConcurrentModificationException` 异常。