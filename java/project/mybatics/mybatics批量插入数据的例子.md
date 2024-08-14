在批量插入数据时，如果表的主键是自增类型，通常需要在插入完成后获取这些新插入记录的主键值。在MyBatis中，可以使用`useGeneratedKeys`和`keyProperty`属性来实现这一点。

下面是一个完整的示例，展示如何在批量插入数据时获取这些数据的主键值。

### 1. 创建表结构

假设我们有一个名为`Employee`的表，表结构如下：

```sql
CREATE TABLE Employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    department VARCHAR(255) NOT NULL
);
```

### 2. 创建实体类

首先，创建一个与表对应的实体类 `Employee`：

```java
public class Employee {
    private Integer id;
    private String name;
    private Integer age;
    private String department;

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
}
```

### 3. 创建 Mapper 接口

创建一个 Mapper 接口 `EmployeeMapper`，其中定义批量插入并获取主键的方法：

```java
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Options;

import java.util.List;

public interface EmployeeMapper {

    @Insert({
        "<script>",
        "INSERT INTO Employee (name, age, department) VALUES ",
        "<foreach collection='employees' item='employee' separator=','>",
        "(#{employee.name}, #{employee.age}, #{employee.department})",
        "</foreach>",
        "</script>"
    })
    @Options(useGeneratedKeys = true, keyProperty = "employee.id")
    void insertEmployees(@Param("employees") List<Employee> employees);
}
```

### 4. 配置 MyBatis

在 MyBatis 的配置文件中配置 Mapper 接口。

假设我们使用 MyBatis 的 XML 配置文件：

#### mybatis-config.xml

```xml
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <typeAliases>
        <typeAlias type="com.example.model.Employee" alias="Employee"/>
    </typeAliases>

    <mappers>
        <mapper resource="com/example/mapper/EmployeeMapper.xml"/>
    </mappers>
</configuration>
```

#### EmployeeMapper.xml

```xml
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.example.mapper.EmployeeMapper">
    <insert id="insertEmployees" useGeneratedKeys="true" keyProperty="employee.id">
        INSERT INTO Employee (name, age, department) VALUES
        <foreach collection="employees" item="employee" separator=",">
            (#{employee.name}, #{employee.age}, #{employee.department})
        </foreach>
    </insert>
</mapper>
```

### 5. 使用 Spring Boot 集成 MyBatis（可选）

如果你使用 Spring Boot 项目，集成 MyBatis 也是比较简单的。以下示例展示如何集成和使用。

#### application.yml

配置数据源信息：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/test
    username: root
    password: yourpassword
  mybatis:
    mapper-locations: classpath:mapper/*.xml
    type-aliases-package: com.example.model
```

#### POM 文件

在 pom.xml 文件中加入 MyBatis 和 MySQL 的依赖：

```xml
<dependencies>
    <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
        <version>2.1.2</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <scope>runtime</scope>
    </dependency>
</dependencies>
```

### 6. 编写测试代码

编写一个测试代码来测试批量插入并获取主键的功能。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class MyBatisTest implements CommandLineRunner {

    @Autowired
    private EmployeeMapper employeeMapper;

    @Override
    public void run(String... args) throws Exception {
        List<Employee> employees = new ArrayList<>();
        employees.add(new Employee(null, "John Doe", 30, "Engineering"));
        employees.add(new Employee(null, "Jane Doe", 25, "Marketing"));
        employees.add(new Employee(null, "Jim Brown", 45, "HR"));

        employeeMapper.insertEmployees(employees);

        for (Employee employee : employees) {
            System.out.println("Inserted Employee ID: " + employee.getId());
        }
    }
}
```

在这段代码中，执行批量插入操作后，`Employee`对象的`id`属性将自动填充所生成的主键值。你可以通过遍历这些`Employee`对象来获取它们的ID。

### 总结

通过上面的步骤，使用 MyBatis 批量插入数据，并且在插入操作后获取这些数据的主键值变得非常容易。关键步骤包括：

1. **配置主键自动生成**：在`@Options`注解中使用`useGeneratedKeys`和`keyProperty`，或在 XML 中配置使用生成的键。
2. **启用批量插入**：使用 MyBatis 的动态 SQL 和`foreach`标签进行批量插入。
3. **测试插入效果**：编写测试代码验证插入后主键值的获取效果。

这种方法可以大大简化批量插入操作和主键获取的流程，有助于提高开发效率和代码可读性。