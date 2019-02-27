Arraylist 和 LinkedList 是 Java 集合框架中用来存储对象引用列表的两个类。Arraylist 和 LinkedList 都实现 List 接口。首先，让我们了解一下它们最重要的父接口——List。



**1. List 接口**

列表（list）是元素的有序集合，也称为序列。它提供了基于元素位置的操作，有助于快速访问、添加和删除列表中特定索引位置的元素。List 接口实现了 Collection 和 Iterable 作为父接口。它允许存储重复值和空值，支持通过索引访问元素。

**2. 用法**

下面是使用 List 接口声明 ArrayList 和 LinkedList 的代码片段。

```
import java.util.*;
public class MyClass {
  // 非同步或非线程安全
  List<Object> arrayList = new ArrayList<>(); // 声明一个 array list
  List<Object> linkedList = new LinkedList(); // 声明 linked list   
  // 确保线程安全
  List<Object> tsArrayList = Collections.synchronizedList(new LinkedList<>());
  List<Object> tsLinkedList = Collections.synchronizedList(new LinkedList<>());   
}
```



Vector 与 ArrayList 类似，只是它们支持自动同步，这也使得 Vector 线程安全，但同时会带来一些性能损耗。



**3. 内部实现**



**3.1 LinkedList 内部实现**

Linkedlist 数据结构包含一组有序的数据元素，称为节点。每个元素都包含对其后续元素，即下一个元素的链接或引用。 序列的最后一个元素（尾部）指向空元素。链表本身包含对链表第一个元素的引用，该元素称为 head 元素。Java 中的 LinkedList 是 List 接口的双向链表。在双向链表中，每个节点都指向它的上一个节点和下一个节点。此外，它还实现了其他接口，比如 Serializable、 Cloneable 和 Deque（实现 Queue 作为父接口）。



**3.2 ArrayList 内部实现**

Arraylist 是可调整大小的数组，实现了 List 接口。 它的内部是一个对象数组，可以根据需要扩容支持在集合中加入更多元素。可以通过构造函数 ArrayList(int initialCapacity)指定 ArrayList 的初始容量，然后在必要时使用 void ensureCapacity(int minCapacity) 增加容量，确保至少可以容纳初始化时最小容量参数指定数量的元素。



它还提供一个方法 void trimToSize()，可以减少现有元素的大小。

```
// 调用构造函数 ArrayList<type>(initialCapacity)
List arr = new ArrayList<Integer>(10);
```



默认情况下，ArrayList 创建初始容量为10的列表，而 LinkedList 只构造一个没有设置任何初始容量的空列表。 Linkedlist 不实现 RandomAccess 接口，而 ArrayList 实现了 RandomAccess 接口（而非 Deque 接口）。



**4. 各种操作的时空复杂性**



![img](https://mmbiz.qpic.cn/mmbiz_png/eZzl4LXykQyjuRticPhUeOF3q8ZN5oOnpE1D0b82Ej8WlicO8Eyd2gZEV0HBwrVhYiam9sTLRgEAdbbkSZ8KiaKeLQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



**5. 小贴士**



考虑下面遍历 LinkedList 的示例代码。在这段代码中遍历会非常慢，因为 LinkedList 不支持随机访问，因此每次遍历都会带来巨大的开销。

```
LinkedList ll = new LinkedList();
…
…
Object o = null;   
for (int i = 0; i < list.size(); i++)
{       
  o = list.get(i);
  …
}
```



一个更好的方法可提高性能，像下面这段代码。

```
LinkedList ll = new LinkedList(); 
… 
…   
Object o = null;    
ListIterator li = list.listIterator(0);   
while (li.hasNext()){
  o = ll.next();
  …    
}
```



**6. 总结**

相比较而言 Arraylist 更快而且更好，因为它支持对其元素的随机访问。 遍历链表或在中间插入新元素开销很大，因为必须遍历每个元素而且很可能遇到缓存失败。 如果需要在一次迭代中对列表中的多个项目执行处理，那么 LinkedList 的开销比 Arraylist 使用时多次复制数组元素的开销要小。