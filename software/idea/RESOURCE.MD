---
typora-root-url: ..\..
---


## plugins
### GsonFormat
这个插件根据json数据生成pojo，复制接口响应数据，创建entity类，在创建类的窗口，Alt+Insert,选择GsonFormat，粘贴json，生成。
#### 安装插件
Intellij IDEA File——>Settings——>IDE setttings——>Plugins
搜索GsonFormat，安装后重启idea。

## 激活方法
[Win10中Clion的安装-注册-MinGW环境配置-运行C++](https://blog.csdn.net/qq_33956051/article/details/79463757)
## 使用for的正确姿势
Settings->Completion 
1. for

Before
```java
public class Foo {
    void m() {
        int[] values = {1, 2, 3};
        values.for
    }
}
```
After
```java
public class Foo {
    void m() {
        int[] values = {1, 2, 3};
        for (int value : values) {

        }
    }
}
```
2. fori

Before
```java
public class Foo {
    void m() {
        int foo = 100;
        foo.fori
    }
}
```
After
```java
public class Foo {
    void m() {
        int foo = 100;
        for (int i = 0; i < foo; i++) {

        }
    }
}
```
3. forr

Before
```java
public class Foo {
    void m() {
        int foo = 100;
        foo.forr
    }
}
```
After
```java
public class Foo {
    void m() {
        int foo = 100;
        for (int i = foo; i > 0; i--) {

        }
    }
}
```