## 理解不可变集合 | Guava Immutable与JDK unmodifiableList
### 1、为什么需要不可变集合
（1）保证线程安全：在并发程序中，使用Immutable既保证线程安全性，也大大增强了并发时的效率（跟并发锁方式相比）。尤其当一个对象是值对象时，更应该考虑采用Immutable方式；  
（2）被不可信的类库使用时会很安全；  
（3）如果一个对象不需要支持修改操作(mutation)，将会节省空间和时间的开销；经过分析，所有不可变的集合实现都比可变集合更加有效地利用内存；  
（4）可以当作一个常量来对待，并且这个对象在以后也不会被改变。  
将一个对象复制一份成immutable的，是一个防御性编程技术。
### 2、JDK中提供的不可变集合：真的做到了不可变？

在JDK类库中很多集合(List、Set、Map等)都可以调用Collections类提供的静态方法unmodifiableXXX(…)来得到一个不可修改的视图，例如：
```java
// 下面的代码利用Collections.unmodifiableList(list)得到一个不可修改的集合unmodifiableList
List list = new ArrayList();
list.add("wyp");
list.add("good");

List unmodifiableList = Collections.unmodifiableList(list);
System.out.println(unmodifiableList);//[wyp, good]
unmodifiableList.add("add");
```
当unmodifiableList.add(“add”)时，运行代码将会出现以下异常：
```java
Exception in thread "main" java.lang.UnsupportedOperationException
at java.util.Collections$UnmodifiableCollection.add(Collections.java:1018)
at com.wyp.test.testFiles(test.java:152)
at com.wyp.test.main(test.java:160)
```
说明如果直接add是不可以的，符合不可变的定义。
一切看起来很不错，因为调用unmodifiableList.add()会抛出一个java.lang.UnsupportedOperationException。但如果有用户修改了list，会发生什么情况？在上述代码的下面加入以下代码:
```java
list.add("add");
System.out.println(unmodifiableList);
```
当你再次打印unmodifiableList的时候，你会发现结果是[wyp, good, add]，**多了一个"add"元素**。unmodifiableList不是不可变的吗？这显然不是我们期望的。  
**说明：Collections.unmodifiableList(…)实现的不是真正的不可变集合，当原始集合被修改后，不可变集合里面的元素也是跟着发生变化。**  

**利用JDK类库中提供的unmodifiableXXX方法最少存在以下几点不足：**
* 笨拙：因为你每次都得写那么多代码；
* 不安全：如果没有引用到原来的集合，这种情况之下才会返回唯一真正永恒不变的集合；
* 效率很低：返回的不可修改的集合数据结构仍然具有可变集合的所有开销。
### 3、Guava提供的Immutable：真正的不可变集合

Guava类库中提供的Immutable才是真正的不可修改的集合。
```
import com.google.common.collect.ImmutableList;
ImmutableList immutableList = ImmutableList.of("wyp", "good");
```
* 当你往immutableList 中添加元素，也会抛出java.lang.UnsupportedOperationException异常；
* 修改原集合后，immutable集合不变：
```java
public void testImmutable(){
    ArrayList<String> stringArrayList = Lists.newArrayList("wo","bu","ke","bian");
    ImmutableList<String> immutableList = ImmutableList.copyOf(stringArrayList);
    // 尝试add： java.lang.UnsupportedOperationException
    // immutableList.add("!!!");

    // 尝试修改原集合：immutableList不变，还是 [wo, bu, ke, bian]
    stringArrayList.add("!!!");
    System.out.println(immutableList);
}
```
## Optional<T> | Ordering：流畅风格比较器
> http://www.jianshu.com/p/431353c3eafa
### 使用optional的意义
* 使用Optional除了赋予null语义，增加了可读性，最大的优点在于它是一种傻瓜式的防护。
* Optional迫使你积极思考引用缺失的情况，因为你必须显式地从Optional获取引用。
* 直接使用null很容易让人忘掉某些情形，尽管FindBugs可以帮助查找null相关的问题，但是我们还是认为它并不能准确地定位问题根源。
* 如同输入参数，方法的返回值也可能是null。
* 和其他人一样，你绝对很可能会忘记别人写的方法method(a,b)会返回一个null，就好像当你实现method(a,b)时，也很可能忘记输入参数a可以为null。将方法的返回类型指定为Optional，也可以迫使调用者思考返回的引用缺失的情形。
### 使用Optional包装引用的优点：
1. isPresent方法会更加清晰、明确的指明业务上的含义；
2. isPresent方法可以判断实例是否为null，防止NullPointException发生；
3. 容易和空区分开；
4. 代码的可读性增强，而且返回值可以设置默认值等。
### Optional的使用

创建Optional实例（以下都是静态方法）：

* Optional.of(T) 创建指定引用的Optional实例，若引用为null则快速失败
* Optional.absent() 创建引用缺失的Optional实例
* Optional.fromNullable(T) 创建指定引用的Optional实例，若引用为null则表示缺失
用Optional实例查询引用（以下都是非静态方法）：

* boolean isPresent() 如果Optional包含非null的引用（引用存在），返回true
* T get() 返回Optional所包含的引用，若引用缺失，则抛出java.lang.IllegalStateException
* T or(T) 返回Optional所包含的引用，若引用缺失，返回指定的值
* T orNull() 返回Optional所包含的引用，若引用缺失，返回null
* Set<T> asSet() 返回Optional所包含引用的单例不可变集，如果引用存在，返回一个只有单一元素的集合，如果引用缺失，返回一个空集合。
### 代码示例
```java
//A
public void sayHelloA(String name) {
    if (name == null) {
        System.out.println("name = " + "无名氏");
    }
    System.out.println("name = " + name);
}

//B
public void sayHelloB(String name) {
    name = Optional.fromNullable(name).or("无名氏");
    System.out.println("name = " + name);
}
```
### 其他处理null的便利方法
（1）当需要一个默认值来替换可能会出现的null值，那么可以使用Optional.fromNullable(first).or(second)，如果两个值都是null，该方法会抛出NullPointerException。  
（2）还有其它一些方法专门处理null或空字符串：Strings.emptyToNull(String)，Strings.nullToEmpty(String)，Strings.isNullOrEmpty(String)。  
## Guava ListenableFuture介绍以及使用
### 介绍

> 我们知道java中的Future表示一个异步计算任务，当任务完成时可以得到计算结果，如果我们希望一旦计算完成就拿到结果展示给用户或者做计算，
> 就必须使用另一个线程不断的查询计算状态，这样会使代码复杂而且效率低下。使用guava的
> ListenableFuture可以帮我们检测Future是否完成了，如果完成就会自动调用回调函数，这样可以减少并发程序的复杂度。

### 使用示例
```java
 public static void main(String[] args) {
    ListeningExecutorService executorService = MoreExecutors.listeningDecorator(Executors.newCachedThreadPool());
    // 执行任务
    final ListenableFuture<Integer> listenableFuture =  executorService.submit(new Callable<Integer>() {
        public Integer call() throws Exception {
            System.out.println("新任务。。。");
            TimeUnit.SECONDS.sleep(1);
            return 7;
        }

    });
    // 任务完成回掉函数
    final FutureCallback<Integer> futureCallback = new FutureCallback<Integer>() {
        @Override
        public void onSuccess(Integer result) {
            System.out.println("任务执行成功，对任务进行操作。");
        }

        @Override
        public void onFailure(Throwable t) {
            System.out.println("任务执行失败。");
        }
    };

    // 绑定任务以及回调函数
    Futures.addCallback(listenableFuture, futureCallback);
}
```
## guava list 排序
```java
List<RuleDataDto> ruleDataDtoList = defaultToolDataCache.get(activityId);

//存放多个结果然后根据优先级排序(逆序排列)
ruleDataDtoList = new Ordering<RuleDataDto>() {
      @Override
      public int compare(RuleDataDto left, RuleDataDto right) {
            return right.getMarketingToolData().getPriority() - left.getMarketingToolData().getPriority();
      }
}.immutableSortedCopy(ruleDataDtoList);
```
## 限流某个接口的总并发/请求数

如果接口可能会有突发访问情况，但又担心访问量太大造成崩溃，如抢购业务；这个时候就需要限制这个接口的总并发/请求数总请求数了；  
因为粒度比较细，可以为每个接口都设置相应的阀值。可以使用Java中的AtomicLong进行限流：
```java
try{

if(atomic.incrementAndGet() > 限流数) {

//拒绝请求

}

//处理请求

}finally{

atomic.decrementAndGet();

}
```
适合对业务无损的服务或者需要过载保护的服务进行限流，如抢购业务，超出了大小要么让用户排队，要么告诉用户没货了，对用户来说是可以接受的。  
而一些开放平台也会限制用户调用某个接口的试用请求量，也可以用这种计数器方式实现。这种方式也是简单粗暴的限流，没有平滑处理，需要根据实际情况选择使用；
## 平滑限流某个接口的请求数
> 聊聊高并发系统限流特技-1 http://www.jianshu.com/p/0d7ca597ebd2  
`令牌桶算法` `漏桶算法`
```java
RateLimiter limiter = RateLimiter.create(5);
limiter.acquire();
```
1、RateLimiter.create(5)表示桶容量为5且每秒新增5个令牌，即每隔200毫秒新增一个令牌；  
2、limiter.acquire()表示消费一个令牌，如果当前桶中有足够令牌则成功（返回值为0），如果桶中没有令牌则暂停一段时间，比如发令牌间隔是200毫秒，则等待200毫秒后再去消费令牌，这种实现将突发请求速率平均为了固定请求速率。

[guava RateLimiter限流实战](http://blog.csdn.net/Yin_Tang/article/details/78851825)
[guava RateLimiter限流实战 代码](https://github.com/yinTang/TokenBucket)
## 集合数据分组
```java
public static void main(String[] args) {
    Person p1 = new Person("a", 10, "男", "china");
    Person p2 = new Person("b", 11, "女", "japan");
    Person p3 = new Person("c", 12, "男", "japan");
    Person p4 = new Person("d", 14, "男", "USA");
    Person p5 = new Person("e", 14, "女", "china");
    List<Person> persons = Lists.newArrayList(p1,p2,p3,p4,p5);
    Multimap<String,Person> multimap1 = ArrayListMultimap.create();
    Multimap<Integer,Person> multimap2 = ArrayListMultimap.create();
    Multimap<String,Person> multimap3 = ArrayListMultimap.create();
    for (Person p : persons) {
        multimap1.put(p.getSex(), p);
        multimap2.put(p.getAge(), p);
        multimap3.put(p.getContry(), p);
    }
    Map<String, Collection<Person>> sex = multimap1.asMap();
    for (Entry<String, Collection<Person>> p : sex.entrySet()) {
        System.out.println("按性别分组 = " +p.getKey()+"--"+ p.getValue());
    }
    Map<Integer, Collection<Person>> age = multimap2.asMap();
    for (Entry<Integer, Collection<Person>> p : age.entrySet()) {
        System.out.println("按年龄分组 = " +p.getKey()+"岁"+"--"+ p.getValue());
    }
    Map<String, Collection<Person>> country = multimap3.asMap();
    for (Entry<String, Collection<Person>> p : country.entrySet()) {
        System.out.println("按国家分组 = " +p.getKey() +"--" + p.getValue());
    }
}
```
## Joiner
```java
//use java
List<String> list = new ArrayList<String>();
list.add("aa");
list.add("bb");
list.add("cc");
String str = "";
for(int i=0; i<list.size(); i++){
    str ="-" +list.get(i);
}
System.out.println(str);
//str 为-aa-bb-cc
//use guava
List<String> list2 = new ArrayList<String>();
list2.add("aa");
list2.add("bb");
list2.add("cc");
String result = Joiner.on("-").join(list2);
//result为  aa-bb-cc
System.out.println(result);
```
## Splitter
```java
//use java
List<String> list = new ArrayList<String>();
String a = "1-2-3-4-5-6";
String[] strs = a.split("-");
for(int i=0; i<strs.length; i++){
    list.add(strs[i]);
}
System.out.println(list);
//use guava
String str = "1-2-3-4-5-6";
List<String> list2 = Splitter.on("-").splitToList(str);
System.out.println(list2);
//list为  [1, 2, 3, 4, 5, 6]
String str2 = "1-2-3-4-  5-  6   ";  
List<String> list3 = Splitter.on("-").omitEmptyStrings().trimResults().splitToList(str2);
System.out.println(list3);

List<String> list4 = Splitter.on("-").splitToList(str2);
System.out.println(list4);
```
## 优质资源
使用Google Guava快乐编程  http://www.jianshu.com/p/97778b21bd00  

## cache使用示例
移动端操控丁丁地锁升降需要丁丁的accessToken，应用服务器获取丁丁的accessToken后3600秒过期，使用guava的cache避免频繁调用丁丁的接口。
```java
@Service
public class DdtcService {

    private static final Logger logger= LoggerFactory.getLogger(DdtcService.class);

    @Value("${ddtc.appId}")
    private String appId;
    @Value("${ddtc.appSecret}")
    private String appSecret;
    @Value("${ddtc.queryAccessTokenUrl}")
    private String queryAccessTokenUrl;

    private static Cache<String, String> cache;

    @PostConstruct
    private void init(){
        AccessTokenResult accessTokenResult;
        try {
            String result = HttpUtil.get(queryAccessTokenUrl, new MapBean("appSecret", appSecret, "appId", appId));
            logger.info(result);
            accessTokenResult = JsonUtil.toObject(result, AccessTokenResult.class);
            if ("200".equals(accessTokenResult.getErrNo())) {
                cache= CacheBuilder.newBuilder().
                        maximumSize(1)
                        .expireAfterWrite(Long.parseLong(accessTokenResult.getExpiresIn()), TimeUnit.SECONDS)
                        .recordStats()
                        .build();
                cache.put("accessToken",accessTokenResult.getAccessToken());
            }
        } catch (Exception e) {
            logger.error("",e);
        }
    }

    /**
     * 获取accessToken
     * @return
     */
    public String getAccessToken(){
        try {
            return cache.get("accessToken", () -> {
                String result = HttpUtil.get(queryAccessTokenUrl, new MapBean("appSecret", appSecret, "appId", appId));
                AccessTokenResult accessTokenResult = JsonUtil.toObject(result, AccessTokenResult.class);
                return accessTokenResult.getAccessToken();
            });
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }
}
```