# 计算模型之Java8
## 简述
Java 8发行版是自Java 5（发行于2004，已经过了相当一段时间了）以来最具革命性的版本。Java 8我认为带来的最核心的变化主要体现在三个方面：Lambda(函数式编程)、Stream(流)和并发/并行编程简易化。其中Lamdba特性是最具革命性，为Stream、并行/并发编程等新特性提供基础支撑。

Java 8所做的改变，在许多方面比Java历史上任何一次改变都深远，为古老渐显疲态的Java注入新的活力：
1. ​lambda:最具革命性的新特性，直观上看：代码量大大减少，程序逻辑也清晰明了，可以编写出简单、干净、易读的代码；深层原因：函数式编程思想的风靡流行
2. ​Stream(流):Lambda和集合结合的产物，也让Lambda函数式编程这一酷炫技术得到很好展现的一个新特性， 是Java 8带给我们最核心、最实用的一个特性
3. ​并发/并行:借助于lambda、Stream和ForkJoin、CompletableFuture等新特性，让并发/并行编程更加简单

## Lambda
### 概述
Lambda表达式并不是Java 8新出的概念，最近几年lambda表达式早已风靡于编程界，很多现代编程语言都把它作为函数式编程的基本组成部分，像Scala、Groovy等早已开始支持Lambda表达式语法。而且实践证明：让函数作为一等公民(Java是面向对象编程，只有对象是一等公民可以进行任意的传递，不过lambda底层实现依然采用的是对象封装实现的，因此，lambda可以看成是Java 8提供给程序员的一种”语法糖”)可以扩充程序员的工具库，从而让代码量大大减少、程序逻辑更清晰明了，编写出简单、干净、易读的代码，最终实现编程简单轻松和提高开发人员效率。

让Java实现一种尽可能轻量级的将代码封装为数据（Model code as data）的方法，这就是lambda表达式最本质的需求，用专家更精简的说法是：让行为参数化。

我们知道，Java作为一门面向对象的语言：在Java世界里，一切皆对象。在Java 8之前，Java专家们使用接口中的一个方法来封装对象行为进行参数传递，如可能存在如下情况：

```java
button.addActionListener(new ActionListener) {
  public void actionPerformed(ActionEvent e) {
    ui.dazzle(e.getModifiers());
  }
}

```
使用接口方法定义行为，然后通过匿名类方式实现行为传递，但通常非常臃肿，既难于编写，也不易于维护。这种方案并不令人满意：冗余的语法会影响程序员在实践中使用行为参数化的积极性。像上面例子一样，真正有用的代码就只有一句：ui.dazzle(e.getModifiers())，而大量模板式的“噪点”代码充斥其中使代码复杂化，结构不够清晰。Java 8引入的lambda就是对这一问题很好的解决，通过向方法传递代码片段来解决这一问题，让你很简洁地对一个行为进行参数化并传递：

```
button.addActionListener(e -> ui.dazzle(e.getModifiers()))

```
### 案例

采用lambda可以轻松实现行为参数化，这样在接口设计的时候可以更抽象化、灵活性更高，如下：
```java
@Test
public void test(){
  System.out.println(operation((x,y)->x+y, 5));//实现累加求和
  System.out.println(operation((x,y)->x*y, 5));//实现阶乘
  System.out.println(operation((x,y)->x*x+y*y, 5));//实现其它需求
}

/**
  * 1、实现根据传入的n创建一个int类型序列：1,2,3,4...n
  * 2、将传入的行为函数去处理这个int类型序列
  */
private int operation(IntBinaryOperator operator, int n){
  return IntStream.rangeClosed(1,n).reduce(operator).getAsInt();
}

```
通过使用lambda表达式，简单的几行代码就实现了一个灵活的数学运算方法，这就是lambda强大的地方。如果我们使用传统方式如何实现上述功能呢：
1. 采用策略模式，首先定义一个接口，接口中定义一个方法代表数据处理的业务逻辑入口
2. 执行运算的时候，通过匿名内部类将不同的业务逻辑封装到1步骤中定义的接口中，通过对象方式传入方法

你可以自己用传统的策略模式实现上述功能，哪种方式编写简洁、灵活就一目了然了。
方法引用
若Lambda体中的内容有方法已经实现了，我们可以使用方法引用，可以理解为：方法引用是Lambda表达式的另外一种表现形式，对一类特殊的lambda表达式进一步进行简化。

方法引用和下面的构造器引用都很简单，没什么实质性需要讲解的，本质上是对一类特殊的lambda进一步进行简化编写，可以看着是Java 8在极简编程方面的努力尝试。

主要有三种语法格式：
1. 对象::实例方法名
2. 类::静态方法名
3. 类:::实例方法名

方法引用：lambda表达式参数类型和返回类型和引用方法的参数类型和返回类型一致

```java
//lamdba表达式方式
Consumer<String> consumer = x -> System.out.println(x);
//方法引用方式
consumer = System.out::print;

//类::静态方法名
Comparator<Integer> comparable = (x, y) -> Integer.compare(x, y);
comparable = Integer::compare;

//类::实例方法名方式调用必须满足条件：两个参数，第一个参数是实例方法的调用者，而第二个参数是实例方法的参数时，即lamdba体中参数1.方法(参数2)，可以使用类::实例方法名
//即：参数1作为调用方，参数2作为参数样式，也即，实例方法是参数1类型中的实例方法
BiPredicate<String,String> bp = (x,y) -> x.equals(y);
bp = String::equals;

```
构造器引用
构造器引用，类似于方法引用:
1. 格式：ClassName::new
2. 与函数式接口相结合，自动与函数式接口中方法兼容。
3. 可以把构造器引用赋值给定义的方法，与构造器参数列表要与接口中抽象方法的参数列表一致

```java
class Employee{
        public Employee(String str){
            System.out.println("str:"+str);
        }
        public Employee(){
            System.out.println("无参构造方法");
        }
}

//构造器引用
//构造器的参数列表要和Supplier中的T get()参数列表一致，所以调用的是无参构造方法
Supplier<Employee> supplier = () -> new Employee();
supplier = Employee::new;

//构造器的参数列表要和Function中的R apply(T t)参数列表一致，所以调用的是有参构造方法
Function<String,Employee> fun1 = (x) -> new Employee(x);
Function<String,Employee> fun2 = Employee::new;
fun2.apply("hah");

```
## Stream
### 概述
lambda函数式编程完善了面向对象编程的不足，可以实现更抽象、更灵活的接口，从而让代码质量更加高效。对于lambda表达式我们理解到这点基本就足已，因为它还是比较简单的，真正核心的地方是lambda表达式与流式思想的结合。

Stream就是这样一个lambda表达式与流式思想的结合的产物，是lambda表达式作为流式思想实现的一个很好方案的展现。Stream的本质你可以这么理解：Stream就是将一系列lambda表达式进行串联形成一条数据处理流水线，实现通过各个lambda表达式间相互协作最终完成复杂的业务处理。Stream让传统的面向“存储” 的集合，具有了面向“计算”的能力。Java 8引入的Stream我认为是对开发人员来讲是实用性最好、使用率最高的一项特性，因为对数据集合的操作在日常开发中扮演着越来越重要的地位。

Stream意义
传统的项目开发，基本上数据都会存储在关系型数据库如MySQL或Oracle中，利用关系型数据库提供的丰富内置函数，可以帮助完成各种数据处理工作，因此，传统的开发更多的是面向数据库编程。然后，现在是一个信息数据爆炸的时代，数据来源五花八门导致数据格式也不在是传统的以结构化数据为主的特点，而是非结构化、半结构化数据越来越多，这就对数据处理的需求更多、处理手段要更加灵活。而且数据规模越来越大，传统的关系型数据库已经无法满足需要，所以出现现在NoSQL遍地开花的局面。NoSQL数据库主要解决的核心关注点“海量数据存储和高效数据检索”，而和关系型数据库核心关注点“强一致性和强大的数据处理功能”是不一致的。这两方面的变化导致了现在越来越多的项目已将数据处理的需求移植到了程序开发中，数据处理和并发编程在日常开发中需求量大增。

传统的Java集合操作提供的API接口只有基本的功能性接口，比如：新增元素、删除元素、集合大小、集合iterator迭代，缺少面向实际业务层面更高层次的抽象接口，而Stream就是解决了传统集合操作的不足，使程序员得以站在更高的抽象层次上对集合进行操作。

Stream实现了类似SQL语法样式，使用声明式的类似描述性语言，有效帮助开发人员构建高质量、高性能的数据处理平台，挖掘出真正的商业价值，让“大数据”发挥出强大的威力。

案例
案例一:
下面的代码源自JDK中的Class类型（getEnclosingMethod方法），这段代码会遍历所有声明的方法，然后根据方法名称、返回类型以及参数的数量和类型进行匹配：

```java
for (Method method : enclosingInfo.getEnclosingClass().getDeclaredMethods()) {
  if (method.getName().equals(enclosingInfo.getName())) {
    Class<?>[] candidateParamClasses = method.getParameterTypes();
    if (candidateParamClasses.length == parameterClasses.length) {
      boolean matches = true;
      for (int i = 0; i < candidateParamClasses.length; i += 1) {
        if (!candidateParamClasses[i].equals(parameterClasses[i])) {
          matches = false;
          break;
        }
      }
      if (matches) { // finally, check return type
        if (method.getReturnType().equals(returnType)) {
          return method;
        }
      }
    }
  }
}
throw new InternalError("Enclosing method not found");

```
通过使用流，我们不但可以消除上面代码里面所有的临时变量，还可以把控制逻辑交给类库处理。通过反射得到方法列表之后，我们利用 Arrays.stream将它转化为Stream，然后利用一系列过滤器去除类型不符、参数不符以及返回值不符的方法，然后通过调用findFirst 得到Optional<Method>，最后利用orElseThrow 返回目标值或者抛出异常。

```java
return Arrays.stream(enclosingInfo.getEnclosingClass().getDeclaredMethods())
             .filter(m -> Objects.equals(m.getName(), enclosingInfo.getName()))
             .filter(m -> Arrays.equals(m.getParameterTypes(), parameterClasses))
             .filter(m -> Objects.equals(m.getReturnType(), returnType))
             .findFirst()
             .orElseThrow(() -> new InternalError("Enclosing method not found"));

```
相对于未使用流的代码，这段代码更加紧凑，可读性更好，也不容易出错。
案例二：基本集合操作案例(出至《Java8函数式编程》)  
Album：专辑，由若干曲目组成
Track：曲目，专辑中的一支曲目
现在要实现这样需求：现在要找出长度大于1分钟的曲目，并将曲目名字返回成一个Set集合

传统方式：
```java
public Set<String> findLongTracks(List<Album> albums) {
  Set<String> trackNames = new HashSet<>();
  for(Album album : albums) {
    for (Track track : album.getTrackList()) {
      if (track.getLength() > 60) {
        String name = track.getName();
        trackNames.add(name);
      }
    }
  }
  return trackNames;
}

```
使用Stream方式：
```java
public Set<String> findLongTracks(List<Album> albums) {
 return albums.stream()
               .flatMap(album -> album.getTracks())
                 .filter(track -> track.getLength() > 60)
              .map(track -> track.getName())
               .collect(toSet());
}

```
对比总结：
1. 代码量减少
2. 结构更加清晰，一方面是收益于代码量的减少；另一方面，主要是使用类似描述性语言让代码的逻辑更加清晰。比如看到filter就晓得是进行过滤处理，看到map就晓得是一对一处理、看到collect就晓得是将流收集到集合中等等，这些接口本身就具有很强的描述性，简化了开发人员对代码的理解
    
    
flatMap、filter、map、collect等等，这些就是Stream提供的声明式的类似描述性语言的API接口，搞过Spark开发的人看着这些函数名称应该很熟悉了，和Spark编程提供的算子很类似，在语义上基本一致，对大数据开发人员具有很好的亲和力。

仔细思考会发现它们在计算模型设计的思想有很多的相似性：
1. Spark中对数据集封装成RDD，然后使用一堆map、flatMap、filter等算子对RDD中的数据元素进行中间层处理，最后使用reduce、count、collect、foreach等聚合操作输出最终结果；
2. Java 8中使用Stream对数据集进行封装，使用map、flatMap、filter等lambda表达式对Stream中元素进行中间层处理，最后使用reduce、count、collect、foreach等lambda表达式进行结果的聚合输出。
3. 而且中间层map、flatMap、filter等操作它们都具有惰性特性，只有在遇到需要对结果进行聚合输出时才会正在的执行。
 
当然了这里只是列举的Spark Core编程思想，Spark还提供了Spark SQL、Spark Stream、Spark MLlib等模块，提供了大数据“一站式”的基于分布式的解决方案，显然是Stream无法比拟的。但是parallel和sequential可轻易的让Stream在并行流和串行流之间进行转换，也提供了丰富的“算子”操作，因此，你也可以把Stream看着是“轻量级”、“单机版”的Spark编程框架实现。
进一步延伸

Storm中的Bolt、Spark中的算子和Java 8中的lambda，它们的思想和UNIX中的管道、责任链和pipeline模式中封装的处理单元是很类似的：对数据的处理封装成一个个处理单元，然后根据业务需要组装成一个线性或非线性链表或DAG(有向无环图)，让数据像水流一样沿着这个有向无环图经过处理单元进行层层过滤、处理。这是一种非常实用的经典计算模型或叫编程思想，有一句话很能体现这种思想的价值：“如果说Unix是计算机文明中最伟大的发明，那么，Unix下的Pipe管道就是跟随Unix所带来的另一个伟大的发明”。它体现的哲学思想：”Do one thing, Do it well”，程序应该只关注一个目标，并尽可能把它做好，让程序能够互相协同工作完成复杂任务。

Storm、Spark计算模型的强大以及Java 8中lamdba简洁性，让我们看到：虽然它们和传统的管道、责任链、Pipeline等模式在底层思想上如此的一致，但是在技术上还是向前迈出了很大一步，这就是技术积累进步的力量。

也再次印证了：火热的大数据时代让这一编程思想再次受到人们的关注，Java 8中及时引入lambda函数式编程，不在简简单单认为只是一种酷炫、装逼神器，而是一种迫切的真实需求体现，是顺应潮流的必然结果。
## 声明式编程
一般通过编程实现一个系统，有两种思考方式。一种专注于如何实现，比如：“首先做这个，紧接着更新那个，然后……”举个例子，如果你希望通过计算找出列表中最昂贵的事务，通常需要执行一系列的命令：从列表中取出一个事务，将其与临时最昂贵事务进行比较；如果该事务开销更大，就将临时最昂贵的事务设置为该事务；接着从列表中取出下一个事务，并重复上述操作。这种“如何做”风格的编程非常适合经典的面向对象编程，有些时候我们也称之为“命令式”编程，因为它的特点是它的指令和计算机底层的词汇非常相近，比如赋值、条件分支以及循环，就像下面这段代码：

```java
Transaction mostExpensive = transactions.get(0);
if(mostExpensive == null)
  throw new IllegalArgumentException("Empty list of transactions")
for(Transaction t: transactions.subList(1, transactions.size())){
  if(t.getValue() > mostExpensive.getValue()){
      mostExpensive = t;
  }
}

```
另一种方式则更加关注要做什么。使用Stream API你可以指定下面这样的查询：
Optional<Transaction> mostExpensive = transactions.stream().max(comparing(Transaction::getValue));
这个查询把最终如何实现的细节留给了函数库。我们把这种思想称之为内部迭代。它的巨大优势在于你的查询语句现在读起来就像是问题陈述，由于采用了这种方式，我们马上就能理解它的功能，比理解一系列的命令要简洁得多。

采用这种“要做什么”风格的编程通常被称为声明式编程。你制定规则，给出了希望实现的目标，让系统来决定如何实现这个目标。它带来的好处非常明显，用这种方式编写的代码更加接近问题陈述了。

在声明式编程语言中最为我们所熟知的是SQL，这个被称为第三代半或第四代编程语言取得了巨大成功，很重要的一点：它可以使用声明式语言，而不必关注具体实现细节。这一特性让它的使用及其简单，也成为它广受欢迎的关键。

Stream遵循”做什么，而不是怎么去做”的原则，可以看成lambda函数式编程对声明式编程的具体实践：你只需要使用不相互影响的表达式，描述想要做什么，由系统来选择如何实现。你可以使用Stream将几个操作串接在一起，表达一个复杂的操作，这些都是函数式编程语言的特性。
## 并行流
并行化操作流只需改变一个方法调用。如果已经有一个Stream对象，调用它的parallel方法就能让其拥有并行操作的能力。如果想从一个集合类创建一个流，调用parallelStream就能立即获得一个拥有并行能力的流，非常的简单就实现了并行化编程。并行流就是一个把内容分成多个数据块，并用不同的线程分别处理每个数据块的流。这样一来，你就可以自动把给定操作的工作负荷分配给多核处理器的所有内核，让他们都忙起来。

并行流内部使用了默认的ForkJoinPool，它默认的线程数量就是你的处理器数量，这个值是由Runtime.getRuntime().availableProcessors()得到的。但是你可以通过系统属性java.util.concurrent.ForkJoinPool.common.parallelism来改变线程池大小，如下所示：System.setProperty(“java.util.concurrent.ForkJoinPool.common.parallelism”,”12”);这是一个全局设置，因此它将影响代码中所有的并行流。反过来说，目前还无法专为某个并行流指定这个值。一般而言，让ForkJoinPool的大小等于处理器数量是个不错的默认值，除非你有很好的理由，否则我们强烈建议你不要修改它。

当然，也可以通过自定义ForkJoinPool并指定并行度方式实现局部并行度修改，方式如下：

```java
public void test() throws Exception {
  ForkJoinPool pool = new ForkJoinPool(6);//指定并行度为6，下面并行流执行的时并行度即设置成6
  Long ret = pool.submit(() -> {
    return LongStream.range(1, 100).boxed().collect(Collectors.toList())
        .stream()
        .parallel()
        .map(x -> {
          System.out.println(Thread.currentThread().getName()+":"+x);
          return x * 2;
        })
        .reduce((x, y) -> x + y)
        .get();
  }).get();
}

``` 
这是一个多核的时代，并行流对提系统整体升性能是极具价值，最关键的是并行流和串行流间切换如此的简单，一个函数就可搞定，这是传统Java进行并行编程无法想象的。

## Stream总结
java 8的流式处理极大的简化了对于集合的操作，实际上不光是集合，包括数组、文件等，只要是可以转换成流，我们都可以借助流式处理，类似于我们写SQL语句一样对其进行操作。java 8通过内部迭代来实现对流的处理，一个流式处理可以分为三个部分：转换成流、中间操作、终端操作。它们之间的区别就是：中间操作输出还是流，一般是用于对流中元素进行处理，而终端操作一般是聚合操作，用于获取最终的结果。如下图：
![](/images/java/计算模型之java8/1.png)
![](/images/java/计算模型之java8/2.png)
下面再通过一个案例再次体验下并行/并发编程方面Stream和传统编程巨大的区别

蒙特卡洛模拟案例(出至《Java8函数式编程》)
如果公平地掷两次骰子，然后将赢的一面上的点数相加，就会得到一个2~12的数字。点数的和至少是2，因为骰子六个面上最小的点数是1，而我们将骰子掷了两次；点数的和最大超不过12，因为骰子点数最多的一面也不过6点。我们想要得出点数落在2~12之间每个值的概率。
  
方式一：求出掷骰子的所有组合，比如，得到2点的方式是第一次掷得1点，第二次也掷得1点。总共有36种可能的组合，因此，掷得2点的概率就是1/36。
方式二：使用1到6的随机数模拟掷骰子事件，然后用得到每个点数的次数除以总的投掷次数。这就是一个简单的蒙特卡洛模拟。模拟投掷骰子的次数越多，得到的结果越准确，因此，我们希望尽可能多地增加模拟次数(Spark案例中SparkPi，就是利用蒙特卡洛模拟求π值)。
  
```java
/**
  * 模拟公平投掷两次筛子，赢面上点数和
  * @return
  */
private int twoDiceThrows() {
  ThreadLocalRandom random = ThreadLocalRandom.current();
  int firstThrow = random.nextInt(1, 7);
  int secondThrow = random.nextInt(1, 7);
  return firstThrow + secondThrow;
}

/**
  * 使用蒙特卡洛模拟法并行化模拟掷骰子事件
  */
public Map<Integer, Double> parallelDiceRolls(int N) {
  double fraction = 1.0 / N;
  return IntStream.range(0, N).parallel()
                              .mapToObj(x -> twoDiceThrows())
                              .collect(Collectors.groupingBy(side -> side, Collectors.summingDouble(n -> fraction)));
  //Collectors.summingDouble(n -> fraction) 将n转成double类型fraction，并累加
}

public static void main(String[] args) {
  Map<Integer, Double> ret = new Demo1().parallelDiceRolls(10000);
  ret.forEach((k,v) -> System.out.println("点数:"+k+", 概率"+v));
}

```
输出结果：
```
  点数:2, 概率0.027693
  点数:3, 概率0.05557999999999999
  点数:4, 概率0.083445
  点数:5, 概率0.11120599999999999
  点数:6, 概率0.139088
  点数:7, 概率0.166841
  点数:8, 概率0.138882
  点数:9, 概率0.11072699999999999
  点数:10, 概率0.083487
  点数:11, 概率0.055407
  点数:12, 概率0.027644

```
使用传统方式实现上述同样效果代码：
```java
/**
 * @author 36410
 * @Copyright © 2017 tiger Inc. All rights reserved.
 * @create 2017-12-01 17:11
 * Description:通过手动使用线程模拟掷骰子事件
 */
public class ManualDiceRolls {

  private static final int N = 100000000;
  private final double fraction;
  private final Map<Integer, Double> results;
  private final int numberOfThreads;
  private final ExecutorService executor;
  private final int workPerThread;

  public static void main(String[] args) {
    ManualDiceRolls roles = new ManualDiceRolls();
    roles.simulateDiceRoles();
  }

  public ManualDiceRolls() {
    fraction = 1.0 / N;
    results = new ConcurrentHashMap<>();
    numberOfThreads = Runtime.getRuntime().availableProcessors();
    executor = Executors.newFixedThreadPool(numberOfThreads);
    workPerThread = N / numberOfThreads;
  }

  public void simulateDiceRoles() {
    List<Future<?>> futures = submitJobs();
    awaitCompletion(futures);
    printResults();
  }

  private void printResults() {
    results.entrySet()
        .forEach(System.out::println);
  }

  private List<Future<?>> submitJobs() {
    List<Future<?>> futures = new ArrayList<>();
    for (int i = 0; i < numberOfThreads; i++) {
      futures.add(executor.submit(makeJob()));
    }
    return futures;
  }

  private Runnable makeJob() {
    return () -> {
      ThreadLocalRandom random = ThreadLocalRandom.current();
      for (int i = 0; i < workPerThread; i++) {
        int entry = twoDiceThrows(random);
        accumulateResult(entry);
      }
    };
  }

  private void accumulateResult(int entry) {
    results.compute(entry, (key, previous) ->
        previous == null ? fraction
            : previous + fraction
    );
  }

  private int twoDiceThrows(ThreadLocalRandom random) {
    int firstThrow = random.nextInt(1, 7);
    int secondThrow = random.nextInt(1, 7);
    return firstThrow + secondThrow;
  }

  private void awaitCompletion(List<Future<?>> futures) {
    futures.forEach((future) -> {
      try {
        future.get();
      } catch (InterruptedException | ExecutionException e) {
        e.printStackTrace();
      }
    });
    executor.shutdown();
  }
}

```
对比：
  1. 使用Stream几行代码就可以搞定一个复杂的并发编程，而使用传统方式却需要几十行到上百行等，代码的简洁性体现的淋漓尽致
  2. 得益于Stream编程使代码量大大减少，同时采用的是声明式编程，采用Stream编程方式结构流程清晰明了，而使用传统方式构建的程序流程就不是那么容易理解了
  3. 对集合执行操作流水线，并可以通过简单的一个方法就实现了串行流与并行流间的切换，基本上不会付出任何代价，传统方式在并发编程方面，又是创建管理线程池、又是要创建管理线程、最后通过异步方式获取结果等，显然代价要昂贵的多，这也是体现出传统编程下对使用并发编程积极性不高的一个因数，然而在当代这个多核时代，为了尽可能发挥出多核硬件资源的优势，并发编程是不可避免的，而且重要性也会越来越高
## Stream性能分析
Stream接口可以让你不用太费力气就能对数据集执行并行操作。它允许你声明性地将顺序流变为并行流。可以通过对收集源调用parallelStream方法来把集合转换为并行流。
并行流就是一个把内容分成多个数据块，并用不同的线程分别处理每个数据块的流。这样一来，你就可以自动把给定操作的工作负荷分配给多核处理器的所有内核，让它们都忙起来。

案例：累加求和

方式一：传统方式
```java
public long iterativeSum(long n) {
    long result = 0;
    for (long i = 1L; i <= n; i++) {
      result += i;
    }
    return result;
}

```
方式二：串行流方式
```java
public long sequentialSum(long n) {
  return Stream.iterate(1L, i -> i + 1)
      .limit(n)
      .reduce(0L, Long::sum);
}

```
方式三：并行流方式
```java
public long parallelSum(long n) {
  return Stream.iterate(1L, i -> i + 1)
      .limit(n)
      .parallel()
      .reduce(0L, Long::sum);
}

```
使用parallel()可以把流转换成并行流，从而让前面的函数归约过程（也就是求和）并行运行。Stream在内部分成了几块。因此可以对不同的块独立并行进行归纳操作，最后，同一个归纳操作会将各个子流的部分归纳结果合并起来，得到整个原始流的归纳结果。
  
配置并行流使用的线程池
看看流的parallel方法，你可能会想，并行流用的线程是从哪儿来的？有多少个？怎么自定义这个过程呢？
并行流内部使用了默认的ForkJoinPool，它默认的线程数量就是你的处理器数量， 这个值是由Runtime.getRuntime().availableProcessors()得到的。
但是你可以通过系统属性java.util.concurrent.ForkJoinPool.common.parallelism来改变线程池大小，如下所示：
```java
System.setProperty("java.util.concurrent.ForkJoinPool.common.parallelism","12");
```
这是一个全局设置，因此它将影响代码中所有的并行流。反过来说，目前还无法专为某个并行流指定这个值。一般而言，让ForkJoinPool的大小等于处理器数量是个不错的默认值，除非你有很好的理由，否则我们强烈建议你不要修改它。
  
我们声称并行求和方法应该比顺序和迭代方法性能好。然而在软件工程上，靠猜绝对不是什么好办法！特别是在优化性能时，你应该始终遵循三个黄金规则：测量，测量，再测量。为此，你可以开发一个方法，如下所示(调用10次，取耗时最短一次)：
```java
public long measureSumPerf(Function<Long, Long> adder, long n) {
  long fastest = Long.MAX_VALUE;
  for (int i = 0; i < 10; i++) {
    long start = System.nanoTime();
    long sum = adder.apply(n);
    long duration = (System.nanoTime() - start) / 1_000_000;
    System.out.println("Result: " + sum);
    if (duration < fastest) fastest = duration;
  }
  return fastest;
}

```
测试一：for循环原生类型：
```java
public long iterativeSum1(long n) {
  long result = 0;
  for (long i = 1L; i <= n; i++) {
    result += i;
  }
  return result;
}

```
输出内容：for -> 原生类型耗时(毫秒):5
  
测试二：for循环装箱类型：
```java
public long iterativeSum2(Long n) {
  Long result = 0L;
  for (Long i = 1L; i <= n; i++) {
    result += i;
  }
  return result;
}

```
输出内容：for -> 装箱类型耗时(毫秒):126
 
测试三：iterator串行
```java
public long sequentialSum(long n) {
  return Stream.iterate(1L, i -> i + 1)
      .limit(n)
      .reduce(0L, Long::sum);
}

```
输出内容：iterator -> 串行(毫秒):118

测试四：iterator并行
```java
public long parallelSum(long n) {
  return Stream.iterate(1L, i -> i + 1)
      .limit(n)
      .parallel()
      .reduce(0L, Long::sum);
}

```
输出内容：iterator -> 并行(毫秒):308

测试五：LongStream.rangeClosed串行
```java
public static long rangedSum(long n) {
  return LongStream.rangeClosed(1, n)
      .reduce(0L, Long::sum);
}

```  
输出内容：LongStream.rangeClosed -> 串行(毫秒):4
 
测试六：LongStream.rangeClosed并行
```java
public static long parallelRangedSum(long n) {
  return LongStream.rangeClosed(1, n)
      .parallel()
      .reduce(0L, Long::sum);
}

```
输出内容：LongStream.rangeClosed -> 并行(毫秒):1
  
  
结果分析：
1. 测试一和测试二对比：5ms VS 126 ms  
      分析：
          a 同是for循环累加求和操作，原生类型和装箱类型耗时相差几十倍，因为装箱的对象必须拆箱成数字才能求和，存在性能消耗  
          b 原生类型long占用8字节，而它的装箱类型是一个对象，对象在内存中存储的布局可以分为三块区域：对象头、实例数据和对齐填充，以64位JVM为例，装箱Long占用16+8=24字节，刚好是对齐不需要进行填充，可见Long装箱类型是原生类型long在内存占用上相差3倍，而Integer装箱类型和int原生类型相差6倍  
          c 从上面两点分析可以得出：在进行大量数据处理的时候，可以使用原生类型尽量使用原生类型，而不要使用装箱类型，不论在性能还是内存占用上，原生类型都极具优势

2. 测试三和测试四对比：118ms VS 308ms  
          分析：看到这个结果，可能感到很惊讶，为什么并行流比串行流性能低那么多，按道理并行流应该比串行流快很多才符合逻辑。  
          原因：采用Stream.iterate()生成的流是没法分成多个独立块来并行执行，因为每次应用这个函数都要依赖前一次应用的结果，导致数据集合在归纳过程开始时是没有准备好的，因而无法有效地把流划分为小块来并行处理。但是把流标记成并行，你其实是给顺序处理增加了开销，它还要把每次求和操作分到一个不同的线程上。这就说明了并行编程可能很复杂，有时候甚至有点违反直觉。如果用得不对（比如采用了一个不易并行化的操作，如iterate），它甚至可能让程序的整体性能更差，所以在调用那个看似神奇的parallel操作时，了解背后到底发生了什么是很有必要的

3. 测试一和测试四对比：5ms VS 118ms  
        分析：为什么采用Stream方式累加求和竟比传统for循环方式性能低那么多，相差几十倍  
        原因：采用Stream.iterate()生成流中元素是装箱类型，计算时要进行拆箱后才会进行累加求和计算，导致了性能差。从另一点也可以印证这个观点：测试2采用for循环装箱类型耗时126ms基本接近Stream.iterate()串行流性能，可见性能的差距主要体现在拆箱上面

4. 测试五和测试三、测试一对比：4ms VS 118ms VS 5ms  
          分析：测试五性能要比测试三性能高很多  
          原因：a.Java8意识到原生类型和装箱类型性能差距的问题，因此提供了一些列直接生成原生类型的流的类，如LongStream、IntegerStream等，通过LongStream.rangeClosed()直接产生原生类型long，而不再是装箱类型Long  
                b.测试五和测试一性能基本接近，这也说明采用Stream这套接口开发在给我们带来方便的同时，性能是没有打折的

5. 测试六和测试五对比：1ms VS 4ms  
          分析：测试六采用并行流，并行流使用系统内置的ForkJoinPool线程池，线程数默认是Runtime.getRuntime().availableProcessors()

## 并发/并行编程
由于摩尔定律在处理器的时钟频率不断提升这一方式遇到了瓶颈，即单核CPU在性能上无法进一步获得有效提升，现在趋势是在横向上进行扩展，即无法获取更快的CPU核心，但是可以通过获取更多的CPU核心来提升性能，这就是所谓的多核时代的来临。由单核主频的提升到多核扩展这一硬件结构的转变，为了让你的代码运行得更快，需要你的代码具备并行运算的能力，可以让每个处理线程单独占据一个核，从而得到多倍的整体性能。

前面提到的并行流就是Java 8对并行编程一个很好的实践，但流类库提供的数据并行化只是其中的一种形式，下面会介绍Java 8在中并发/并行编程的其它手段。

并发/并行编程区别
并发是两个任务共享时间段，并行则是两个任务在同一时间发生，比如运行在多核CPU上。如果一个程序要运行两个任务，并且只有一个CPU 给它们分配了不同的时间片，那么这就是并发，而不是并行。两者之间的区别如下图：
![](/images/java/计算模型之java8/3.png)
并发并行区别

CompletableFuture
Future接口是在Java5中被引入，设计初衷是对将来某个时刻会发生的结果进行建模，它建模了一种异步计算，返回一个执行运算结果的引用，当运算结束后，这个引用被返回给调用方。打个比方，你可以把它想象成这样的场景：你拿了一袋子衣服到你中意的干洗店去洗。干洗店的员工会给你张发票，告诉你什么时候你的衣服会洗好（这就是一个Future事件）。衣服干洗的同时，你可以去做其他的事情。Future的另一个优点是它比更底层的Thread更易用。要使用Future，通常你只需要将耗时的操作封装在一个Callable对象中，再将它提交给ExecutorService，就万事大吉了。下面这段代码展示了Java 8之前使用Future的一个例子。

```java
ExecutorService executor = Executors.newCachedThreadPool();
Future<Double> future = executor.submit(new Callable<Double>() {
    public Double call() {
      return doSomeLongComputation();
 }
});
doSomethingElse();
try {
 Double result = future.get(1, TimeUnit.SECONDS);
} catch (ExecutionException ee) {
   // 计算抛出一个异常
} catch (InterruptedException ie) {
  // 当前线程在等待过程中被中断
} catch (TimeoutException te) {
 // 在Future对象完成之前超过已过期
}

```

我们很难表述Future结果之间的依赖性；从文字描述上这很简单，“当长时间计算任务完成时，请将该计算的结果通知到另一个长时间运行的计算任务，这两个计算任务都完成后，将计算的结果与另一个查询操作结果合并”。但是，使用Future中提供的方法完成这样的操作又是另外一回事。这也是我们需要更具描述能力的特性的原因，比如下面这些。
1. 将两个异步计算合并为一个——这两个异步计算之间相互独立，同时第二个又依赖于第一个的结果
2. 等待Future集合中的所有任务都完成
3. 仅等待Future集合中最快结束的任务完成（有可能因为它们试图通过不同的方式计算同一个值），并返回它的结果
4. 通过编程方式完成一个Future任务的执行（即以手工设定异步操作结果的方式）
5. 应对Future的完成事件（即当Future的完成事件发生时会收到通知，并能使用Future计算的结果进行下一步的操作，不只是简单地阻塞等待操作的结果）。

CompletableFuture类（它实现了Future接口）如何利用Java 8的新特性以更直观的方式将上述需求都变为可能。Stream和CompletableFuture的设计都遵循了类似的模式：它们都使用了Lambda表达式以及流水线的思想。从这个角度，你可以说CompletableFuture和Future的关系就跟Stream和Collection的关系一样。

使用CompletableFuture很容易就构造出一个异步方法，而Java 8之前只能面向接口Callable构造，如果存在多个异步方法，就需要定义构造多个Callable接口的实现类，显然要繁琐很多：
  
```java
public Future<Double> getPriceAsync(String product) {
  CompletableFuture<Double> futurePrice = new CompletableFuture<>();
  new Thread( () -> {
    try {
      double price = calculatePrice(product);
      futurePrice.complete(price);//如果价格计算正常结束，完成Future操作并设置商品价格
    } catch (Exception ex) {
      futurePrice.completeExceptionally(ex);//否则就抛出导致失败的异常，完成这次Future操作
    }
  }).start();
  return futurePrice;
}

```
我们已经了解了如何通过CompletableFuture编程方式构建异步方法，看起来这些操作也比较方便，但还有进一步提升的空间，CompletableFuture类自身提供了大量精巧的工厂方法，使用这些方法能更容易地完成整个流程，还不用担心实现的细节。比如，可以将上面的代码进一步简化：
    
```java
public Future<Double> getPriceAsync(String product) {
  return CompletableFuture.supplyAsync(() -> calculatePrice(product));
}

```
从这里再次见识到：Java 8在代码简洁性上做的比之前优秀太多了，lambda让行为参数化后，基本上模板化的代码都被封装起来了，开发人员只需关注真正与业务相关的核心代码片段即可，在提高代码开发效率的同时，代码质量也得到了很大提升。这就得益于声明式编程，你只需要关注你要做什么，而无需关注怎么做，具体实现的细节都被封装到框架中了，自然你的代码质量也就提升了。
Stream与CompletableFuture结合案例

案例：最佳价格查询器(案例来源《Java8 实战》)  
需求：现在有个商家列表，你需要实现一个方法，它接受产品名作为参数，返回一个字符串列表，这个字符串列表中包括商店的名称、该商店中指定商品的价格：

商家列表：
```java
List<Shop> shops = Arrays.asList(new Shop("BestPrice"), new Shop("LetsSaveBig"), 
new Shop("MyFavoriteShop"), new Shop("BuyItAll"));

```
方式一：采用顺序查询所有商店的方式实现的findPrices方法
```java
public List<String> findPrices(String product) {
  return shops.stream()
              .map(shop -> String.format("%s price is %.2f", shop.getName(), shop.getPrice(product)))
              .collect(toList());
}

```
方式二：对findPrices进行并行操作
```java
public List<String> findPrices(String product) {
  return shops.parallelStream()
              .map(shop -> String.format("%s price is %.2f", shop.getName(), shop.getPrice(product)))
              .collect(toList());
}

```
假如商家查询价格是个比较耗时的接口，可能也是最快的改善方法是使用并行流来避免顺序计算。但是注意：Stream并行流使用的是内置的ForkJoinPool连接池中的执行线程（Executor）运行，直线线程默认等于CPU核数，如果商家列表比较多且查询价格接口存在IO阻塞情况，使用并行流并不能完全利用好CPU资源，当然也可以修改线程数使线程数加大，但是这个修改是全局性的，所以一般是不建议修改的，毕竟全局性的修改可能会导致对其它地方的使用造成影响。这就是为什么Stream叫做并行流而不是并发流。
  
方式三：使用CompletableFuture发起异步请求
```java
//自定义线程池执行器
private final Executor executor =
      Executors.newFixedThreadPool(Math.min(shops.size(), 100),
          new ThreadFactory() {
            public Thread newThread(Runnable r) {
              Thread t = new Thread(r);
              t.setDaemon(true);
              return t;
            }
          });

  
  public List<String> findPrices(String product) {
    List<CompletableFuture<String>> priceFutures =
        shops.stream()
            .map(shop -> CompletableFuture.supplyAsync(
                () -> shop.getName() + " price is " +
                    shop.getPrice(product)), executor)//这里需要指定使用的线程池，如果不指定，默认也是使用ForkJoinPool线程池
            .collect(Collectors.toList());
    
    return priceFutures.stream()
                        .map(CompletableFuture::join)
                        .collect(toList());
  }
}

```
并行——使用流还是CompletableFutures？
目前为止，你已经知道对集合进行并行计算有两种方式：
  1. 要么将其转化为并行流，利用map这样的操作开展工作
  2. 要么枚举出集合中的每一个元素，创建新的线程，在CompletableFuture内对其进行操作。后者提供了更多的灵活性，你可以调整线程池的大小，而这能帮助
你确保整体的计算不会因为线程都在等待I/O而发生阻塞。
  
我们对使用这些API的建议如下。
  1. 如果你进行的是计算密集型的操作，并且没有I/O，那么推荐使用Stream接口，因为实现简单，同时效率也可能是最高的（如果所有的线程都是计算密集型的，那就没有必要创建比处理器核数更多的线程）。
  2. 反之，如果你并行的工作单元还涉及等待I/O的操作（包括网络连接等待），那么使用CompletableFuture灵活性更好，你可以像前文讨论的那样，依据等待计算，或者W/C的比率设定需要使用的线程数。
  3. CompletableFuture具有一定的优势，因为它允许你对执行器（Executor）进行配置，尤其是线程池的大小，让它以更适合应用需求的方式进行配置，满足程序的要求，而这是并行流API无法提供的。让我们看看你怎样利用这种配置上的灵活性带来实际应用程序性能上的提升。
CompletableFuture实现多个异步任务流水线式操作
上面介绍的主要是通过CompletableFuture及内置大量的工厂方法方便的实现异步接口，并结合Stream技术实现并发/并行编程，CompletableFuture实现的异步操作都是单任务操作。CompletableFuture类实现了CompletionStage和Future两个接口，一方面对传统的Future接口进行了增强，上面介绍的主要就是集中这个方面。下面就重点看下CompletionStage这个接口，它将流式思想引入到了并发/并行编程，让并发/并行编程具有了类似Stream的流水式操作的强大和灵活性，同时也降低了并发/并行编程的复杂性，这才是Java 8和之前并发/并行编程的一个本质区别。 

需求描述：
  1. 任务1获取商品价格，任务2获取货币汇率，然后将任务1获取的商品价格*任务2获取的货币汇率相乘即可得到最终结果
  2. 任务1和任务2相互之间不存在依赖关系，所以任务1和任务2可以同时并行执行
  3. 任务1和任务2结果都出来后，才执行它们结果相乘得到最终结果
```java
Future<Double> futurePriceInUSD = 
CompletableFuture.supplyAsync(() -> shop.getPrice(product))
      .thenCombine(CompletableFuture.supplyAsync(() -> exchangeService.getRate(Money.EUR, Money.USD))
                   , (price, rate) -> price * rate);
```
需求描述：
  1. 任务1是将数据写入数据库
  2. 任务2是将数据推送到第三方接口
  3. 任务1和任务2没有任何依赖关系，可以并行执行，通过join保证这两个任务都执行完成后才继续向下执行，如果不需要也可以不使用join进行阻塞
  
```java
CompletableFuture.runAsync(() -> writeDb(alarmData), cachedThreadPool)//写入DB
            .runAsync(() -> transferParallel(alarmData, uidSet), cachedThreadPool)//传送到推送服务器
            .join();//阻塞直到上面2个任务执行完毕
```
需求描述：
  1. task1和task2同时并行执行，哪个执行快使用哪个的计算结果
```java
String result = CompletableFuture.supplyAsync(() -> doTask1())
                                      .applyToEither(CompletableFuture.supplyAsync(() -> doTask2()), s -> s)
                                      .join();

```

CompletableFuture类提供了将两个CompletableFuture建立联系功能，通过迭代方式，可以让更多个CompletableFuture建立起关系，构建出更加复杂的业务逻辑，这就形成了类似Stream流式处理功能，只不过它内部元素不再是数据，而是一个个异步任务，而且通过内部抽象出来的语义接口，可以灵活实现这些异步任务间的依赖关系等，这就是流式编程模型的哲学：让程序只关注一个目标，并尽可能把它做好，让程序能够互相协同工作完成复杂任务。这才是真正体现CompletableFuture版本实现所具备的巨大优势，用CompletableFuture在代码简洁性、可读性上带来的巨大提升，提高了开发人员进行并发/并行编程的积极性。
  
CompletableFuture类提供的接口方法还是比较多的，但是这些接口原理上大致相同，理解上也不复杂，关键是要理解这些思想背后的逻辑及它的优势。
Fork/Join
ForkJoin框架是在Java 7中引入的，即分支/合并框架，Stream并行流就是依赖ForkJoin将一个操作切分为多个子操作，在多个不同的核上并行地执行这些子操作，所以还是有必要简单认识下。

在ForkJoin框架出来之前，你要将任务拆解进行并发编程：
1. 你得明确地把包含数据的数据结构分成若干子部分
2. 你要给每个子部分分配一个独立的线程
3. 你需要在恰当的时候对它们进行同步来避免不希望出现的竞争条件，等待所有线程完成，最后把这些部分结果合并起来

Java 7引入ForkJoin就是让这些操作更稳定、更不易出错，ForkJoin框架的原理：以递归方式将可以并行的任务拆分成更小的任务，然后将每个子任务的结果合并起来生成整体结果。它是ExecutorService接口的一个实现，它把子任务分配给线程池（称为ForkJoinPool）中的工作线程。

使用ForkJoin框架另一个好处就是：它实现了“工作窃取”机制，这种算法用于在池中的工作线程之间重新分配和平衡任务，直白的说就是：某个线程从其他队列里窃取任务来执行。假如我们需要做一个比较大的任务，我们可以把这个任务分割为若干互不依赖的子任务，为了减少线程间的竞争，于是把这些子任务分别放到不同的队列里，并为每个队列创建一个单独的线程来执行队列里的任务，线程和队列一一对应，比如A线程负责处理A队列里的任务。但是有的线程会先把自己队列里的任务干完，而其他线程对应的队列里还有任务等待处理。干完活的线程与其等着，不如去帮其他线程干活，于是它就去其他线程的队列里窃取一个任务来执行。而在这时它们会访问同一个队列，所以为了减少窃取任务线程和被窃取任务线程之间的竞争，通常会使用双端队列，被窃取任务线程永远从双端队列的头部拿任务执行，而窃取任务的线程永远从双端队列的尾部拿任务执行。

工作窃取算法的优点是充分利用线程进行并行计算，并减少了线程间的竞争，其缺点是在某些情况下还是存在竞争，比如双端队列里只有一个任务时。并且消耗了更多的系统资源，比如创建多个线程和多个双端队列。

案例
ForkJoin框架编程的模板伪代码大致如下： 

```
if (任务足够小或不可分) {
     顺序计算该任务
 } else {
    将任务分成两个子任务
    递归调用本方法，拆分每个子任务，等待所有子任务完成
    合并每个子任务的结果
 }

```
你可能已经注意到，这只不过是著名的分递归治算法的并行版本而已。

  
案例如下：

```java
import java.util.concurrent.RecursiveTask;

/**
 * @author 36410
 * @Copyright © 2017 tiger Inc. All rights reserved.
 * @create 2017-12-11 10:27
 * Description:你可能已经注意到，这只不过是著名的分治算法的并行版本而已
 */
public class ForkJoinSumCalculator extends RecursiveTask<Long> {
  private final long[] numbers;
  private final int start;
  private final int end;
  public static final long THRESHOLD = 10_000;

  public ForkJoinSumCalculator(long[] numbers) {
    this(numbers, 0, numbers.length);
  }

  private ForkJoinSumCalculator(long[] numbers, int start, int end) {
    this.numbers = numbers;
    this.start = start;
    this.end = end;
  }

  @Override
  protected Long compute() {
    int length = end - start;
    if (length <= THRESHOLD) {
      return computeSequentially();
    }
    /**
     * 对子任务调用fork方法可以把它排进ForkJoinPool。同时对左边和右边的子任务调用它似乎很自然，但这样做的效率要比直接对其中一个调用compute低。
     * 这样做你可以为其中一个子任务重用同一线程，从而避免在线程池中多分配一个任务造成的开销。
     *
     * fork()：放入到ForkJoinPool线程池中执行，compute()重用当前线程执行任务
     */
    ForkJoinSumCalculator leftTask = new ForkJoinSumCalculator(numbers, start, start + length / 2);
    leftTask.fork();
    ForkJoinSumCalculator rightTask = new ForkJoinSumCalculator(numbers, start + length / 2, end);
    Long rightResult = rightTask.compute();
    Long leftResult = leftTask.join();
    return leftResult + rightResult;
  }

  private long computeSequentially() {
    long sum = 0;
    for (int i = start; i < end; i++) {
      sum += numbers[i];
    }
    return sum;
  }
}

/**
 * @author 36410
 * @Copyright © 2017 tiger Inc. All rights reserved.
 * @create 2017-12-11 10:30
 * Description:Runtime.availableProcessors的返回值来决定线程池使用的线程数。请注意availableProcessors方法虽然看起来是处理器，
                但它实际上返回的是可用内核的数量，包括超线程生成的虚拟内核
 */
public class Main {
  public static long forkJoinSum(long n) {
    long[] numbers = LongStream.rangeClosed(1, n).toArray();
    ForkJoinTask<Long> task = new ForkJoinSumCalculator(numbers);
    return new ForkJoinPool().invoke(task);
  }
}
```