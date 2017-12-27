实现ApplicationContextAware接口时，获取ApplicationContext为null

```java
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

@Service
@Lazy(false)
public class SpringContextUtil implements ApplicationContextAware {

    private static ApplicationContext applicationContext = null; // Spring应用上下文环境

    /*
     * 
     * 实现了ApplicationContextAware 接口，必须实现该方法；
     * 
     * 通过传递applicationContext参数初始化成员变量applicationContext
     */

    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        SpringContextUtil.applicationContext = applicationContext;
    }

    public static ApplicationContext getApplicationContext() {
        return applicationContext;
    }

    @SuppressWarnings("unchecked")
    public static <T> T getBean(String name) throws BeansException {
        return (T) applicationContext.getBean(name);
    }

}
```