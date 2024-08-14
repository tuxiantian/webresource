可执行的 JAR （Executable JAR）和不可执行的 JAR （Non-Executable JAR）在使用目的和结构上有一些关键的区别。

### 可执行的 JAR

可执行的 JAR 文件包含一个可以直接运行的 Java 应用程序。要使 JAR 文件可执行，它必须包含一个 `Main-Class` 属性，该属性指定要运行的主类（main class）。

#### 特点

1. **包含 Main-Class 属性**：可执行 JAR 文件的 `META-INF/MANIFEST.MF` 文件中包含一个 `Main-Class` 条目，用于指定程序的入口点。例如：

    ```plaintext
    Main-Class: com.example.MainClass
    ```

    这意味着，当你执行该 JAR 文件时，JVM 会运行 `com.example.MainClass` 中的 `main` 方法。

2. **可以直接使用 java -jar 命令运行**：

    ```bash
    java -jar your-executable.jar
    ```

    这条命令会启动 `META-INF/MANIFEST.MF` 文件中定义的主类。

#### 示例

创建一个简单的 Java 应用程序：

```java
package com.example;

public class MainClass {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

编译并打包成可执行 JAR 文件：

```bash
javac com/example/MainClass.java
jar cfe your-executable.jar com.example.MainClass com/example/MainClass.class
```

在 `jar` 命令中使用 `cfe` 选项可以创建一个 JAR 文件，并在 `MANIFEST.MF` 文件中添加 `Main-Class` 属性。

### 不可执行的 JAR

不可执行的 JAR 文件主要用作 Java 类库（Library JAR），它不包含可以直接运行的主类。这样的 JAR 文件通常被引入到其他 Java 项目中作为依赖项使用。

#### 特点

1. **缺少 Main-Class 属性**：不可执行 JAR 文件的 `META-INF/MANIFEST.MF` 文件中没有 `Main-Class` 条目，或者即使有，该类也不包含 `main` 方法。

2. **不能直接使用 java -jar 命令运行**：因为没有指定主类，尝试使用 `java -jar` 命令会失败。

    ```bash
    java -jar your-library.jar
    ```

    这会导致一个 "no main manifest attribute" 错误。

#### 示例

创建一个简单的 Java 库类：

```java
package com.example;

public class LibraryClass {
    public void hello() {
        System.out.println("Hello from Library!");
    }
}
```

编译并打包成不可执行的 JAR 文件：

```bash
javac com/example/LibraryClass.java
jar cf your-library.jar com/example/LibraryClass.class
```

这个 JAR 文件可以在其他项目中引用，但不能直接运行。

### 总结

- **可执行 JAR**：包含 `Main-Class` 属性和一个可以运行的 `main` 方法，可以使用 `java -jar` 命令直接运行。
    - 典型用途：独立的 Java 应用程序。
- **不可执行 JAR**：缺少 `Main-Class` 属性，无法直接运行，主要用作类库。
    - 典型用途：Java 类库，依赖项。

两者的关键区别在于可执行 JAR 文件具有一个可执行入口点，而不可执行 JAR 文件作为库供其他项目使用。如果你对这一点有更多疑问或者需要更详细的示例，请随时告知！