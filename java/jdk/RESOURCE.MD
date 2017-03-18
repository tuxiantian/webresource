### 为什么1000 == 1000返回为False，而100 == 100会返回为True?
如果你运行如下代码：
```
Integer a = 1000, b = 1000; 
System.out.println(a == b);//1
Integer c = 100, d = 100; 
System.out.println(c == d);//2
```
你会得到以下运行结果：
```
false
true
```
如果你查看Integer.java类，你会找到IntegerCache.java这个内部私有类，它为-128到127之间的所有整数对象提供缓存。
这个东西为那些数值比较小的整数提供内部缓存，当进行如此声明时：

Integer c = 100;

它的内部就是这样的：

Integer i = Integer.valueOf(100);

如果我们观察valueOf()类函数，我们可以看到
 ```
 public static Integer valueOf(int i) {
        assert IntegerCache.high >= 127;
        if (i >= IntegerCache.low && i <= IntegerCache.high)
            return IntegerCache.cache[i + (-IntegerCache.low)];
        return new Integer(i);
 }
 ```
现在你可能会问，为什么会为-128到127之间的所有整数设置缓存？

这是因为在这个范围内的小数值整数在日常生活中的使用频率要比其它的大得多，多次使用相同的底层对象这一特性可以通过该设置进行有效的内存优化。