[java实现map和object互转的三种方法](http://www.open-open.com/code/view/1423280939826)  
[线程的基本概念](https://gold.xitu.io/post/58a1ba8786b599006b4877aa)  
[深入理解 Java 线程池：ThreadPoolExecutor](https://juejin.im/entry/58fada5d570c350058d3aaad)  
[spring自定义转换类](http://www.cnblogs.com/caoyc/p/5639652.html)  
> spring会自发去找自定义的转换类

### MyBatis中使用#和$书写占位符有什么区别？
答：#将传入的数据都当成一个字符串，会对传入的数据自动加上引号；$将传入的数据直接显示生成在SQL中。注意：使用$占位符可能会导致SQL注射攻击，能用#的地方就不要使用$。
### 迭代map
#### 方法一
```
Map<Integer, Integer> map = new HashMap<Integer, Integer>();
for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
    System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
}
```
#### 方法二
```
Map<Integer, Integer> map = new HashMap<Integer, Integer>();

//iterating over keys only
for (Integer key : map.keySet()) {
    System.out.println("Key = " + key);
}

//iterating over values only
for (Integer value : map.values()) {
    System.out.println("Value = " + value);
}
```
#### 方法三
```
Map<Integer, Integer> map = new HashMap<Integer, Integer>();
Iterator<Map.Entry<Integer, Integer>> entries = map.entrySet().iterator();
while (entries.hasNext()) {
    Map.Entry<Integer, Integer> entry = entries.next();
    System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
}
```
### 静态代理和动态代理
```
/**
 * 代理模式 --静态代理(没有调用JDK里面的方法)
 */

interface Targetable {
	public void targetMethod();
}

class Target implements Targetable {

	public void targetMethod() {
		System.out.println("this is a target method...");
	}
}

class Proxy implements Targetable {
	private Target target;

	public Proxy() {
		this.target = new Target();
	}

	private void beforeMethod() {
		System.out.println("this is a method before proxy...");
	}

	private void afterMethod() {
		System.out.println("this is a method after proxy...");
	}

	/**
	 * 在执行目标方法前后加了逻辑
	 */
	public void targetMethod() {
		beforeMethod();
		target.targetMethod();
		afterMethod();
	}
}
public class Test {
	public static void main(String[] args) {
		/**
		 * 创建代理对象
		 */
		Targetable proxy = new Proxy();
		/**
		 * 执行代理方法
		 */
		proxy.targetMethod();
	}
}

/**
 *代理模式 --动态代理
 * 以添加用户为例
 */
class User {
	private String username;
	private String password;
}

/**
 * 目标接口
 */
interface IUserDao {
	public void add(User user);
}

class UserDaoImpl implements IUserDao {
	public void add(User user) {
		System.out.println("add a user successfully...");
	}
}

/**
 * 日志类 --> 待织入的Log类
 */
class LogEmbed implements InvocationHandler {
	private IUserDao target;

	/**
	 * 对target进行封装
	 */
	public IUserDao getTarget() {
		return target;
	}

	public void setTarget(IUserDao target) {
		this.target = target;
	}

	private void beforeMethod() {
		System.out.println("add start...");
	}

	private void afterMethod() {
		System.out.println("add end...");
	}

	/**
	 * 这里用到了反射
	 *
	 * proxy 代理对象
	 *
	 * method 目标方法
	 *
	 * args 目标方法里面参数列表
	 */
	public Object invoke(Object proxy, Method method, Object[] args)
			throws Throwable {
		beforeMethod();
		// 回调目标对象的方法
		method.invoke(target, args);
		System.out.println("LogEmbed --invoke-> method = " + method.getName());
		afterMethod();
		return null;
	}
}

public class Test {
	public static void main(String[] args) {
		IUserDao userDao = new UserDaoImpl();
		LogEmbed log = new LogEmbed();
		log.setTarget(userDao);
		/**
		 * 根据实现的接口产生代理
		 */
		IUserDao userDaoProxy = (IUserDao) Proxy.newProxyInstance(userDao
				.getClass().getClassLoader(), userDao.getClass()
				.getInterfaces(), log);
		/**
		 * 注意：这里在调用IUserDao接口里的add方法时,
		 * 代理对象会帮我们调用实现了InvocationHandler接口的LogEmbed类的invoke方法
		 *
		 * 这样做,是不是有点像Spring里面的拦截器呢？
		 */
		userDaoProxy.add(new User("张三", "123"));
	}
}
```
### 死锁的四个必要条件
死锁：是指两个或两个以上的进程（或线程）在执行过程中,因争夺资源而造成的一种互相等待的现象死锁发生的条件  
互斥条件：线程对资源的访问是排他性的,如果一个线程对占用了某资源,那么其他线程必须处于等待状态,直到资源被释放  
请求和保持条件：线程T1至少已经保持了一个资源R1占用,但又提出对另一个资源R2请求,而此时,资源R2被其他线程T2占用,于是该线程T1也必须等待,但又对自己保持的资源R1不释放  
不剥夺条件：线程已获得的资源,在未使用完之前,不能被其他线程剥夺,只能在使用完以后由自己释放环路等待条件  

--------------------------------------------------------------------------------------
ArrayBlockingQueue：阻塞队列主要用于可以用来构建生产者-消费者模型
内部用数组实现的一个queue,按照元素先进先出（FIFO）原则初始化后,队列容量不可改变
支持可选的公平机制,来保证阻塞的操作线程能按照顺序排列等待默认是不公平机制
offer(e) poll()
整个队列是有一个环绕机制的 环

ArrayBlockingQueue中的锁是没有分离的,即生产和消费用的是同一个锁；
LinkedBlockingQueue中的锁是分离的,即生产用的是putLock,消费是takeLock

     抛出异常	特殊值	   阻塞	     超时
插入	add(e)	offer(e)	put(e)	offer(e, time, unit)
移除	remove()	poll()	take()	poll(time, unit)
检查	element()	peek()	不可用	不可用

--------------------------------------------------------------------------------------
```
Integer缓存 -127->127
Integer a = Integer.valueOf(-127);
Integer b = Integer.valueOf(-127);
Integer c = new Integer(-127);

System.out.println(a == b); // true
System.out.println(a == c); // false
```
--------------------------------------------------------------------------------------

拦截器只能对action请求起作用,而过滤器则可以对几乎所有的请求起作用  
拦截器可以访问action上下文、值栈里的对象,而过滤器不能  
拦截器是基于java的反射机制的,而过滤器是基于函数回调  

--------------------------------------------------------------------------------------
### 重试
```
int retry = 3;
while (retry > 0) {
    try {
        inquirySolrService.commitBean(bean);
        break;
    } catch (Exception e) {
        LOGGER.error(e.getMessage(), e);
        retry --;
    }
}
```
--------------------------------------------------------------------------------------

UML类图 泛化, 实现, 关联 和 依赖  
泛化	表示"类与类之间的继承关系"  
实现	表示"类与接口之间的实现"  
关联	表示"类与类之间的拥有关系"  
依赖	表示"类与类之间的使用关系"  

时序图包含4类元素: 对象, 生命线, 消息, 激活  激活期代表时序图中的对象执行一项操作的时期  

--------------------------------------------------------------------------------------
```
for(int i=0;i<10;i++)
   Integer k=new Integer(i);
   System.out.println("hello world");
```
【答案】：变量作用域问题,压根编译不过  

--------------------------------------------------------------------------------------

开闭原则：即扩展式开放的；修改是关闭的  
单一职责原则：避免职责扩散，每个类都应该仅完成一个功能  
里氏代换原则：子类可以扩展父类的功能，但是不能改变父类原有的功能  
依赖倒置原则：解耦高层次与低层次实现的关系，采用接口之类的方法进行解耦  
接口隔离原则：客户端不应该实现不需要的接口方法  
迪米特法则：对象之间尽量保持最少的依赖关系  

--------------------------------------------------------------------------------------
### 使用%对%进行转义
System.out.println(String.format("%d%%", 20));  