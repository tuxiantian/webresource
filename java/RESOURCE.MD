### Java Decompiler
jar包下载地址如下：  
http://www.benf.org/other/cfr/  
使用示例如下：  
java -jar cfr_0_122.jar CarsService.class --outputpath result

### 高效的工具
org.springframework.beans.BeanUtils#copyProperties(java.lang.Object, java.lang.Object)  
> Copy the property values of the given source bean into the target bean.  
> Note: The source and target classes do not have to match or even be derived from each other, as long as the properties match. Any bean properties that the source bean exposes but the target bean does not will silently be ignored.  
> This is just a convenience method. For more complex transfer needs, consider using a full BeanWrapper.

注意事项
1. 根据source的属性来向target同名属性设值。 
* 若target无该属性，则不设
* 名字相同，基本类型和封装类型可以完成映射
* 若target有source无，则target属性值为null（基本类型则为初始值，如int 为 0）
2. 调用原理 target.set + source的属性名（source.get + source的属性名）：所有source必须有get方法，target必须有set方法
3. 必须保证同名的两个成员变量类型相同.
4. BeanUtils.copyProperties是浅拷贝

使用场景：对象的拷贝，在活动中心生成优惠券时，同样的优惠券会一次生成几张，这是就可以使用这个工具拷贝对象。
```java
Coupon coupon=new Coupon();
coupon.setAmount(activityCoupon.getAmount());
coupon.setValidDate(validDate);
coupon.setValidStatus(CouponStatus.noUse.getVal());
......
for (int i=0;i<activityCoupon.getCouponNum();i++){
    Coupon temp=new Coupon();
    BeanUtils.copyProperties(coupon,temp);
    couponService.saveOrUpdate(temp);
}
```
### 知识链接
[java实现map和object互转的三种方法](http://www.open-open.com/code/view/1423280939826)  
[线程的基本概念](https://gold.xitu.io/post/58a1ba8786b599006b4877aa)  
[深入理解 Java 线程池：ThreadPoolExecutor](https://juejin.im/entry/58fada5d570c350058d3aaad)  
[spring自定义转换类](http://www.cnblogs.com/caoyc/p/5639652.html)  
> spring会自发去找自定义的转换类
> [基于 Spring Cloud 完整的微服务架构实战](https://github.com/souyunku/spring-boot-cloud)
### 数组和list相互转化
数组转list  
List<String> priStrList=Arrays.asList(priStrArr);  
list转数组  
priStrArr=(String[]) toSave.toArray(new String[toSave.size()]);  
### split使用注意事项
```java
String privelegs = (String)param.get("priveleges");
if (StringUtil.isNull(privelegs)) {
	return;
}else {
	if (privelegs.startsWith("|")) {
		privelegs=privelegs.substring(1);
	}
}
String[] priStrArr =privelegs.split("\\|");
```
### MyBatis中使用#和$书写占位符有什么区别？
答：#将传入的数据都当成一个字符串，会对传入的数据自动加上引号；$将传入的数据直接显示生成在SQL中。注意：使用$占位符可能会导致SQL注射攻击，能用#的地方就不要使用$。
### 迭代map
#### 方法一
```java
Map<Integer, Integer> map = new HashMap<Integer, Integer>();
for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
    System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
}
```
#### 方法二
```java
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
```java
Map<Integer, Integer> map = new HashMap<Integer, Integer>();
Iterator<Map.Entry<Integer, Integer>> entries = map.entrySet().iterator();
while (entries.hasNext()) {
    Map.Entry<Integer, Integer> entry = entries.next();
    System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
}
```

### 以,连接集合中的元素的写法
```java
String productNames = "";
String areaCode = "";
if (productList != null && productList.size() > 0) {
	for (MapBean productBean : productList) {
		if (StringUtils.isBlank(productNames)) {
			productNames = productBean.getString("productName");
		} else {
			productNames = productNames + "," + productBean.getString("productName");
		}
	}
	areaCode = productList.get(0).getString("areaCode");
}
```

```java
Optional<String> val = productList.stream().map(productBean -> productBean.getString("productName")).reduce((a, b) -> a + "," + b);
System.out.println(val.get());
```

```java
List<String> productNameList= productList.stream().map(productBean -> productBean.getString("productName")).collect(Collectors.toList());
StringUtils.join(productNameList,',');
```

### Java将科学计数法数据转为字符串
有些项目可能会涉及到从Excel导入数据，但如果Excel里单元格类型为数值，但内容数据太长时（如银行账号），导入时，会默认读取为科学计数法，用以下代码便轻松解决。
```java
BigDecimal bd = new BigDecimal("3.40256010353E11");  
System.out.println(bd.toPlainString());
```
### 死锁的四个必要条件
* 死锁：是指两个或两个以上的进程（或线程）在执行过程中,因争夺资源而造成的一种互相等待的现象死锁发生的条件  
* 互斥条件：线程对资源的访问是排他性的,如果一个线程对占用了某资源,那么其他线程必须处于等待状态,直到资源被释放  
* 请求和保持条件：线程T1至少已经保持了一个资源R1占用,但又提出对另一个资源R2请求,而此时,资源R2被其他线程T2占用,于是该线程T1也必须等待,但又对自己保持的资源R1不释放  
* 不剥夺条件：线程已获得的资源,在未使用完之前,不能被其他线程剥夺,只能在使用完以后由自己释放环路等待条件  

### 阻塞队列
ArrayBlockingQueue：阻塞队列主要用于可以用来构建生产者-消费者模型
内部用数组实现的一个queue,按照元素先进先出（FIFO）原则初始化后,队列容量不可改变
支持可选的公平机制,来保证阻塞的操作线程能按照顺序排列等待默认是不公平机制
offer(e) poll()
整个队列是有一个环绕机制的 环

ArrayBlockingQueue中的锁是没有分离的,即生产和消费用的是同一个锁；
LinkedBlockingQueue中的锁是分离的,即生产用的是putLock,消费是takeLock

|      |   抛出异常    |   特殊值    |   阻塞   |          超时          |
| ---- | :-------: | :------: | :----: | :------------------: |
| 插入   |  add(e)   | offer(e) | put(e) | offer(e, time, unit) |
| 移除   | remove()  |  poll()  | take() |   poll(time, unit)   |
| 检查   | element() |  peek()  |  不可用   |         不可用          |

### Integer缓存
```java
Integer缓存 -127->127
Integer a = Integer.valueOf(-127);
Integer b = Integer.valueOf(-127);
Integer c = new Integer(-127);

System.out.println(a == b); // true
System.out.println(a == c); // false
```
### 拦截器
拦截器只能对action请求起作用,而过滤器则可以对几乎所有的请求起作用  
拦截器可以访问action上下文、值栈里的对象,而过滤器不能  
拦截器是基于java的反射机制的,而过滤器是基于函数回调  

### 重试机制代码
```java
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
### UML建模

UML类图 泛化, 实现, 关联 和 依赖  
泛化	表示"类与类之间的继承关系"  
实现	表示"类与接口之间的实现"  
关联	表示"类与类之间的拥有关系"  
依赖	表示"类与类之间的使用关系"  

时序图包含4类元素: 对象, 生命线, 消息, 激活  激活期代表时序图中的对象执行一项操作的时期  

### 面试题之变量作用域
```
for(int i=0;i<10;i++)
   Integer k=new Integer(i);
   System.out.println("hello world");
```
【答案】：变量作用域问题,压根编译不过  

### 设计模式的几个原则

开闭原则：即扩展式开放的；修改是关闭的  
单一职责原则：避免职责扩散，每个类都应该仅完成一个功能  
里氏代换原则：子类可以扩展父类的功能，但是不能改变父类原有的功能  
依赖倒置原则：解耦高层次与低层次实现的关系，采用接口之类的方法进行解耦  
接口隔离原则：客户端不应该实现不需要的接口方法  
迪米特法则：对象之间尽量保持最少的依赖关系  

### 使用%对%进行转义
System.out.println(String.format("%d%%", 20));  

### 反射的应用示例
```java
public class MethodInvokeUtil {

public static String messagePackageMethodInvoke(Map<String, String> interfaceInfo, Map<String, Object> interfaceDataMap) throws Exception{
        String res = "";

        String method_service_class = interfaceInfo.get("package_service");
        //业务层方法
        String method_name = interfaceInfo.get("package_method");

        if(StringUtil.isNotEmpty(method_service_class)&&StringUtil.isNotEmpty(method_name)){
            res = (String) methodInvoke(method_service_class, method_name, interfaceDataMap);

        }else{
            throw new Exception("接口调用失败，错误描述：接口"+interfaceInfo.get("interface_id")+"的配置出错，未配置报文封装实现。");
        }


        return res;
    }

/**
* 反射调用具体实现
* @param method_service_class
* @param method_name
* @param datas
* @return
* @throws Exception
*/
public static Object methodInvoke(String method_service_class,String method_name,Map<String, Object> datas) throws Exception{
    Object res = null;

    Class<?> clazz = null;
    Method method = null;

    try {
        clazz = Class.forName(method_service_class);


        method = clazz.getDeclaredMethod(method_name, Map.class);
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        throw new Exception(" 没有找到类，类路径和类名： " + method_service_class +"，错误描述：" +e.getCause());
    } catch (NoSuchMethodException e) {
        e.printStackTrace();
        throw new Exception("在类"+method_service_class+"中，没有找到方法"+method_name +"，错误描述：" +e.getCause());
    } catch (SecurityException e) {
        e.printStackTrace();
        throw new Exception("调用"+method_service_class+"."+method_name+"(...)方法出错" +"，错误描述：" +e.getCause());
    }

    try {
        res =  method.invoke(clazz.newInstance(), datas);
    } catch (IllegalAccessException e) {
        e.printStackTrace();
        throw new Exception("调用"+method_service_class+"."+method_name+"(...)方法出错" +"，错误描述：" +e.getCause());
    } catch (IllegalArgumentException e) {
        e.printStackTrace();
        throw new Exception("调用"+method_service_class+"."+method_name+"(...)方法出错" +"，错误描述：" +e.getCause());
    } catch (InvocationTargetException e) {
        e.printStackTrace();
        throw new Exception("调用"+method_service_class+"."+method_name+"(...)方法出错" +"，错误描述：" +e.getCause());
    } catch (InstantiationException e) {
        e.printStackTrace();
        throw new Exception("调用"+method_service_class+"."+method_name+"(...)方法出错" +"，错误描述：" +e.getCause());
    } catch(Exception e){
        throw new Exception("调用"+method_service_class+"."+method_name+"(...)方法出错" +"，错误描述：" +e.getMessage());
    }

    return res;
    }
}

```
### 跳出多层for循环的几种处理方式
```
@Test
public void test18(){
    boolean flag=false;
    for (int i=0 ;i<10;i++){
        flag=true;
        for (int j=1;flag&&j<10;j++){
            for (int k=1;flag&&k<10;k++){
                if (k==i+j){
                    flag=false;
                    System.out.println(String.format("i:%s,j:%s,k:%s",i,j,k));
                    continue;
                }
            }
        }
    }
}
```

```
@Test
public void test19(){
    lable1:for (int i=0 ;i<10;i++){
        for (int j=1;j<10;j++){
            for (int k=1;k<10;k++){
                if (k==i+j){
                    System.out.println(String.format("i:%s,j:%s,k:%s",i,j,k));
                    continue lable1;
                }
            }
        }
    }
}
```

```
@Test
public void test20(){
    for (int i=0 ;i<10;i++){
        process(i);
    }
}

private void process(int i) {
    for (int j=1;j<10;j++){
        for (int k=1;k<10;k++){
            if (k==i+j){
                System.out.println(String.format("i:%s,j:%s,k:%s",i,j,k));
                return;
            }
        }
    }
}
```
个人认为最后一种方法最好，通过抽取方法让方法变小，程序的可读性更高了。由此可以得出更一般的结论：方法中不允许有3层及以上的for循环。