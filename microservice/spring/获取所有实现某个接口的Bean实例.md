在Spring中，可以使用几种不同的方式来获取所有实现某个接口的Bean实例。这在许多情况下非常有用，例如需要动态地选择并使用某个策略或处理不同类型的操作。下面介绍几种常用的方法。

### 方法一：使用Spring的`ApplicationContext`

通过`ApplicationContext`获取实现某个接口的所有Bean实例。

#### 示例代码

首先，定义一个接口和几个实现该接口的类：

```java
public interface PaymentStrategy {
    void pay(int amount);
}

@Service
public class CreditCardPayment implements PaymentStrategy {
    @Override
    public void pay(int amount) {
        System.out.println("Paid " + amount + " using Credit Card");
    }
}

@Service
public class PayPalPayment implements PaymentStrategy {
    @Override
    public void pay(int amount) {
        System.out.println("Paid " + amount + " using PayPal");
    }
}
```

然后，在需要获取这些实现类的地方注入`ApplicationContext`：

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.Map;

@Service
public class PaymentService {

    @Autowired
    private ApplicationContext applicationContext;

    @PostConstruct
    public void init() {
        Map<String, PaymentStrategy> beans = applicationContext.getBeansOfType(PaymentStrategy.class);
        beans.forEach((name, bean) -> {
            System.out.println("Found bean: " + name);
            bean.pay(100);
        });
    }
}
```

### 方法二：使用Spring的`ListableBeanFactory`

`ApplicationContext`也是`ListableBeanFactory`的子类，因此可以通过它来获取所有实现某个接口的Bean实例。

#### 示例代码

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.Map;

@Service
public class PaymentService {

    @Autowired
    private ConfigurableListableBeanFactory beanFactory;

    @PostConstruct
    public void init() {
        Map<String, PaymentStrategy> beans = beanFactory.getBeansOfType(PaymentStrategy.class);
        beans.forEach((name, bean) -> {
            System.out.println("Found bean: " + name);
            bean.pay(100);
        });
    }
}
```

### 方法三：使用`@Autowired`注解

直接使用`@Autowired`注解可以将实现某个接口的所有Bean实例注入一个集合（如`List`或`Map`）中。

#### 示例代码

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.List;

@Service
public class PaymentService {

    @Autowired
    private List<PaymentStrategy> paymentStrategies;

    @PostConstruct
    public void init() {
        for (PaymentStrategy paymentStrategy : paymentStrategies) {
            paymentStrategy.pay(100);
        }
    }
}
```

### 总结

以上几种方法都是获取实现某个接口的所有Bean实例的有效手段，每种方法都有其适用的场景：

- `ApplicationContext`：适用于需要通过上下文动态获取Bean实例的场景。
- `ListableBeanFactory`：与`ApplicationContext`类似，同样用于动态获取Bean实例。
- `@Autowired`注解：更加简洁直接，适用于简单场景。

根据具体需求选择合适的方法，就可以在Spring应用中灵活地获取和使用实现某个接口的Bean实例。