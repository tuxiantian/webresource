最近在阅读maven项目代码时，dependencyManagement与dependencies之间的区别不是很了解，现通过项目实例进行总结：项目epps-demob-pom下有一个模块是epps-demob-war。

## 一、dependencyManagement应用场景

　　为了项目的正确运行，必须让所有的子模块使用依赖项的统一版本，必须确保应用的各个项目的依赖项和版本一致，才能保证测试的和发布的是相同的结果。在我们项目顶层的pom文件中，我们会看到dependencyManagement元素。通过它元素来管理jar包的版本，让子项目中引用一个依赖而不用显示的列出版本号。Maven会沿着父子层次向上走，直到找到一个拥有dependencyManagement元素的项目，然后它就会使用在这个dependencyManagement元素中指定的版本号。

　　epps-demob-pom中dependencyManagement如下：

```xml
    <modules>
        <module>epps-demob-war</module>
    </modules>
    <properties>
            <spring-version>3.1.1.RELEASE</spring-version>
    </properties>
    <dependencyManagement>
          <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-web</artifactId>
                <version>${spring-version}</version>
          </dependency>
    </dependencyManagement>
```

　　epps-demob-war中dependency如下：

```xml
    <dependencies>
            <dependency>
                  <groupId>org.springframework</groupId>
                  <artifactId>spring-web</artifactId>
            </dependency>
    </dependencies>
```

　　这样做的好处：统一管理项目的版本号，确保应用的各个项目的依赖和版本一致，才能保证测试的和发布的是相同的成果，因此，在顶层pom中定义共同的依赖关系。同时可以避免在每个使用的子项目中都声明一个版本号，这样想升级或者切换到另一个版本时，只需要在父类容器里更新，不需要任何一个子项目的修改；如果某个子项目需要另外一个版本号时，只需要在dependencies中声明一个版本号即可。子类就会使用子类声明的版本号，不继承于父类版本号。

## 二、dependencies应用场景

　　相对于dependencyManagement，如果在epps-demob-pom中通过dependencies引入jar，将默认被所有的子模块继承。

## 三、dependencyManagement与dependencies区别

　　dependencyManagement里只是声明依赖，并不实现引入，因此子项目需要显式的声明需要用的依赖。如果不在子项目中声明依赖，是不会从父项目中继承下来的；只有在子项目中写了该依赖项，并且没有指定具体版本，才会从父项目中继承该项，并且version和scope都读取自父pom;另外如果子项目中指定了版本号，那么会使用子项目中指定的jar版本。
　　dependencies即使在子模块中不写该依赖项，那么子模块仍然会从父项目中继承该依赖项（全部继承）。