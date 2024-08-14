Spring Security 是一个强大且高度可定制的认证和访问控制框架，它集成了Spring 应用程序，并提供了Web安全和方法级别的安全支持。以下是一个简单介绍和使用Spring Security的指南。

### 1. 引入依赖
在使用Spring Security之前，需要在项目中引入相应的依赖。以Maven为例：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

### 2. 基本配置
Spring Security 默认会保护所有的URL路径，并会要求用户进行认证。为了进行自定义配置，可以创建一个配置类，继承 `WebSecurityConfigurerAdapter`。

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/home").permitAll()
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .loginPage("/login")
                .permitAll()
                .and()
            .logout()
                .permitAll();
    }
}
```

### 3. 配置用户和角色
为了进行用户认证，需要配置用户信息。可以在配置类中重写 `configure` 方法来配置内存中的用户：

```java
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/home").permitAll()
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .loginPage("/login")
                .permitAll()
                .and()
            .logout()
                .permitAll();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.inMemoryAuthentication()
            .withUser("user").password(passwordEncoder().encode("password")).roles("USER")
            .and()
            .withUser("admin").password(passwordEncoder().encode("admin")).roles("ADMIN");
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

### 4. 创建自定义登录页面
Spring Security默认提供了一个登录页面，可以通过 `http.formLogin().loginPage("/login")` 自定义登录页面。需要在控制器中提供映射，并在模板引擎（如Thymeleaf）中创建相应的页面。

```java
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {
    
    @GetMapping("/login")
    public String login() {
        return "login";
    }
}
```

```html
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h1>Login Page</h1>
    <form method="post" action="/login">
        <div>
            <label>Username: <input type="text" name="username"/></label>
        </div>
        <div>
            <label>Password: <input type="password" name="password"/></label>
        </div>
        <div>
            <button type="submit">Login</button>
        </div>
    </form>
</body>
</html>
```

### 5. 方法级别的安全
除了Web级别的安全，还可以在方法上使用注解来进行权限控制。启用方法级别的安全需要在配置类上加上 `@EnableGlobalMethodSecurity` 注解：

```java
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    // ... previous configuration
}
```

然后可以在具体方法上使用 `@PreAuthorize` 或 `@Secured` 注解来进行权限控制：

```java
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

@Service
public class SomeService {

    @PreAuthorize("hasRole('ADMIN')")
    public void adminMethod() {
        // only admins can access this method
    }

    @PreAuthorize("hasRole('USER')")
    public void userMethod() {
        // only users can access this method
    }
}
```

### 6. 自定义用户服务
通常我们会将用户信息存储在数据库中，这时候需要自定义一个 `UserDetailsService`：

```java
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.beans.factory.annotation.Autowired;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username);
        if (user == null) {
            throw new UsernameNotFoundException("User not found");
        }
        return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER")));
    }
}
```

在配置类中使用该服务：

```java
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.beans.factory.annotation.Autowired;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(new BCryptPasswordEncoder());
    }

    // ... previous configuration
}
```

### 总结
Spring Security 是一个功能强大且灵活的框架，用于保护Spring应用的安全。它提供了多种方法进行身份验证和授权，通过高度可定制的配置来满足不同的需求。上面的步骤展示了如何在一个典型的Spring Boot应用中配置和使用Spring Security，但实际上你可以通过扩展和定制来满足更复杂的业务需求和安全要求。

在Spring Boot应用中，处理没有权限时的统一异常处理，可以通过自定义异常处理器来实现，从而为用户提供更友好的错误提示。

以下是详细步骤来实现这一目标：

### 1. 创建一个全局异常处理器
使用`@ControllerAdvice`和`@ExceptionHandler`来定义一个全局异常处理器来处理Security相关的异常。

```java
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<String> handleAccessDeniedException(AccessDeniedException ex) {
        return new ResponseEntity<>("Access Denied: You do not have the necessary permissions to access this resource.", HttpStatus.FORBIDDEN);
    }

    @ExceptionHandler(org.springframework.security.core.userdetails.UsernameNotFoundException.class)
    public ResponseEntity<String> handleUsernameNotFoundException(org.springframework.security.core.userdetails.UsernameNotFoundException ex) {
        return new ResponseEntity<>("User not found.", HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleGeneralException(Exception ex) {
        return new ResponseEntity<>("An error occurred: " + ex.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
```

### 2. 更新Spring Security配置
确保Spring Security在遇到没有权限的情况时能够触发 `AccessDeniedException` 处理。

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.beans.factory.annotation.Autowired;

@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private CustomAccessDeniedHandler accessDeniedHandler;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/home").permitAll()
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .loginPage("/login")
                .permitAll()
                .and()
            .logout()
                .permitAll()
                .and()
            .exceptionHandling()
                .accessDeniedHandler(accessDeniedHandler);
    }
}
```

### 3. 自定义 AccessDeniedHandler
为了能返回统一的响应格式，我们需要实现 `AccessDeniedHandler` 接口。

```java
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.core.Authentication;
import org.springframework.security.access.AccessDeniedException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CustomAccessDeniedHandler implements AccessDeniedHandler {

    @Override
    public void handle(HttpServletRequest request,
                       HttpServletResponse response,
                       AccessDeniedException accessDeniedException) throws IOException, ServletException {

        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.getWriter().write("Custom Access Denied Message: You do not have the necessary permissions to access this resource.");
    }
}
```

### 4. 声明 `CustomAccessDeniedHandler` Bean
在Spring配置中声明这个Bean。

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CustomSecurityConfig {

    @Bean
    public AccessDeniedHandler accessDeniedHandler() {
        return new CustomAccessDeniedHandler();
    }
}
```

### 5. 测试全局异常处理器
创建一些测试端点并进行测试，确保在没有权限的情况下会触发统一的异常处理器，返回合适的响应。

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping("/admin")
    public String adminPage() {
        return "Admin Page";
    }

    @GetMapping("/user")
    public String userPage() {
        return "User Page";
    }
}
```

### 总结
通过上述步骤，我们实现了在没有权限时的统一异常处理。全局异常处理器和自定义的`AccessDeniedHandler`保证了应用在遇到异常情况时能够返回一致且友好的错误信息。这样的设计不仅提升了用户体验，还使应用的安全性逻辑更为清晰和集中管理。

是的，`@PreAuthorize` 注解是在方法调用之前起作用的。它用于在方法调用之前进行权限检查，以确定当前认证用户是否具有执行该方法的权限。

### 工作原理
`@PreAuthorize` 注解是Spring Security中的方法级别的安全控制之一。它利用Spring AOP（Aspect-Oriented Programming 面向切面编程）来拦截对目标方法的调用，并在调用之前进行权限验证。如果验证失败，那么该方法不会被执行。

### 使用示例
以下是一个简单的使用示例：

#### 1. 启用方法级别的安全
在安全配置类中，启用方法级别的安全注解。通常，这需要在配置类上添加 `@EnableGlobalMethodSecurity` 注解，并设置 `prePostEnabled = true`。

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    // 其他安全配置
}
```

#### 2. 在服务方法上使用 @PreAuthorize 注解
在需要进行权限检查的方法上添加 `@PreAuthorize` 注解。

```java
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

@Service
public class SampleService {

    @PreAuthorize("hasRole('ADMIN')")
    public void adminOnlyMethod() {
        // 仅有 ADMIN 角色的用户可以访问这个方法
        System.out.println("Admin only method executed.");
    }

    @PreAuthorize("hasRole('USER')")
    public void userOnlyMethod() {
        // 仅有 USER 角色的用户可以访问这个方法
        System.out.println("User only method executed.");
    }

    @PreAuthorize("#id == authentication.principal.username")
    public void userCanAccessTheirOwnData(String id) {
        // 仅当前认证用户可以访问这个方法
        System.out.println("User is accessing their own data.");
    }
}
```

#### 3. 测试方法
编写控制器或其他方式来调用受保护的方法进行测试。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SampleController {

    @Autowired
    private SampleService sampleService;

    @GetMapping("/admin")
    public String adminEndpoint() {
        sampleService.adminOnlyMethod();
        return "Admin endpoint accessed";
    }

    @GetMapping("/user")
    public String userEndpoint() {
        sampleService.userOnlyMethod();
        return "User endpoint accessed";
    }

    @GetMapping("/user/{id}")
    public String userOwnDataEndpoint(@PathVariable String id) {
        sampleService.userCanAccessTheirOwnData(id);
        return "User own data endpoint accessed";
    }
}
```

### 验证流程
1. **在方法调用之**前，Spring Security会解析 `@PreAuthorize` 注解中的表达式。
2. **评估表达式**：Spring Security使用SpEL（Spring Expression Language）评估表达式，检查当前用户的权限。
3. **授权通过**：如果表达式评估结果为 `true`，则允许方法执行。
4. **授权失败**：如果表达式评估结果为 `false`，则抛出 `AccessDeniedException`，方法不会被执行。

### 表达式详解
- **hasRole('ROLE')**：检查当前用户是否具有指定角色。
- **hasAuthority('AUTHORITY')**：检查当前用户是否具有指定权限。
- **#id == authentication.principal.username**：检查自定义条件，这里 `#id` 是方法参数，`authentication.principal.username` 是当前认证用户的用户名。

### 总结
`@PreAuthorize` 注解提供了一种简洁且强大的方式来在方法调用之前进行权限验证。通过使用这种注解，开发者可以更加方便地管理和控制方法级别的安全性，确保应用按照预定的权限策略执行。

为了实现手机号码加密码登录以及验证码校验，我们需要自定义Spring Security的认证流程。具体步骤如下：

1. **自定义身份验证逻辑**
2. **配置Spring Security**
3. **编写控制器与表单页面**
4. **处理验证码校验**

我们将详细展开每一步的实现。

### 1. 自定义身份验证逻辑

首先，需要实现一个自定义的 `AuthenticationProvider` 来处理手机号和密码的认证。

#### 1.1. 自定义 `AuthenticationToken`

创建一个自定义的 `AuthenticationToken`，用于封装手机号码和密码。

```java
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;

import java.util.Collection;

public class PhoneNumberAuthenticationToken extends UsernamePasswordAuthenticationToken {

    public PhoneNumberAuthenticationToken(Object principal, Object credentials) {
        super(principal, credentials);
    }

    public PhoneNumberAuthenticationToken(Object principal, Object credentials, Collection<? extends GrantedAuthority> authorities) {
        super(principal, credentials, authorities);
    }
}
```

#### 1.2. 自定义 `AuthenticationProvider`

实现一个自定义的 `AuthenticationProvider` 来处理手机号和密码的验证。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class PhoneNumberAuthenticationProvider implements AuthenticationProvider {

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String phoneNumber = (String) authentication.getPrincipal();
        String password = (String) authentication.getCredentials();

        UserDetails userDetails = userDetailsService.loadUserByUsername(phoneNumber);

        if (userDetails == null) {
            throw new BadCredentialsException("User not found.");
        }

        if (!passwordEncoder.matches(password, userDetails.getPassword())) {
            throw new BadCredentialsException("Invalid password.");
        }

        return new PhoneNumberAuthenticationToken(userDetails, password, userDetails.getAuthorities());
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return PhoneNumberAuthenticationToken.class.isAssignableFrom(authentication);
    }
}
```

### 2. 配置Spring Security

在Spring Security的配置类中，将自定义的 `AuthenticationProvider` 配置进去，并实现一个自定义的登录过滤器。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private PhoneNumberAuthenticationProvider phoneNumberAuthenticationProvider;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/login", "/captcha").permitAll()
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .loginPage("/login")
                .usernameParameter("phoneNumber")
                .passwordParameter("password")
                .permitAll()
                .and()
            .logout()
                .permitAll();

        http.addFilterBefore(phoneNumberAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(phoneNumberAuthenticationProvider);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public PhoneNumberAuthenticationFilter phoneNumberAuthenticationFilter() throws Exception {
        PhoneNumberAuthenticationFilter filter = new PhoneNumberAuthenticationFilter();
        filter.setAuthenticationManager(authenticationManager());
        filter.setFilterProcessesUrl("/login");
        return filter;
    }
}
```

自定义 `PhoneNumberAuthenticationFilter`：

```java
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

public class PhoneNumberAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    private static final String PHONE_NUMBER_PARAMETER = "phoneNumber";
    private static final String PASSWORD_PARAMETER = "password";
    private static final String CAPTCHA_PARAMETER = "captcha";

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) {
        String phoneNumber = obtainPhoneNumber(request);
        String password = obtainPassword(request);
        String captcha = obtainCaptcha(request);

        // 验证验证码逻辑 (需要自己实现)
        verifyCaptcha(captcha);

        PhoneNumberAuthenticationToken authRequest = new PhoneNumberAuthenticationToken(phoneNumber, password);
        setDetails(request, authRequest);

        return this.getAuthenticationManager().authenticate(authRequest);
    }

    private String obtainPhoneNumber(HttpServletRequest request) {
        return request.getParameter(PHONE_NUMBER_PARAMETER);
    }

    private String obtainCaptcha(HttpServletRequest request) {
        return request.getParameter(CAPTCHA_PARAMETER);
    }

    private void verifyCaptcha(String captcha) {
        // 验证码校验逻辑
        if (!"expectedCaptcha".equals(captcha)) {
            throw new BadCredentialsException("Invalid captcha.");
        }
    }
}
```

### 3. 编写控制器与表单页面

#### 3.1. 登录控制器

```java
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String login() {
        return "login";
    }
}
```

#### 3.2. 登录表单页面（login.html）

```html
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h1>Login Page</h1>
    <form method="post" action="/login">
        <div>
            <label>Phone Number: <input type="text" name="phoneNumber"/></label>
        </div>
        <div>
            <label>Password: <input type="password" name="password"/></label>
        </div>
        <div>
            <label>Captcha: <input type="text" name="captcha"/></label>
        </div>
        <div>
            <button type="submit">Login</button>
        </div>
    </form>
</body>
</html>
```

### 4. 处理验证码校验

验证码的生成和校验逻辑需要你自己实现，可以使用一些第三方库，比如 Google 的 reCAPTCHA 或者简单的图片验证码。你需要：

- 在生成验证码时存储它（例如存储在会话中）
- 在用户提交表单时获取并校验用户输入的验证码

例如，可以在登录表单页面加入一个显示验证码的字段，并在 `PhoneNumberAuthenticationFilter` 中进行校验。

#### 4.1. 显示验证码

```html
<!-- 在 login.html 模板中加入验证码图片 -->
<div>
    <label>Captcha: <input type="text" name="captcha"/></label>
    <img src="/captcha" alt="captcha"/>
</div>
```

#### 4.2. 生成和校验验证码控制器

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import javax.imageio.ImageIO;

@RestController
public class CaptchaController {

    @GetMapping("/captcha")
    public void getCaptcha(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("image/jpeg");

        int width = 150;
        int height = 50;

        BufferedImage captchaImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = captchaImage.createGraphics();

        g2d.setColor(Color.WHITE);
        g2d.fillRect(0, 0, width, height);

        g2d.setColor(Color.BLACK);
        g2d.drawString("1234", 50, 25); // 生成简单的字符串验证码 "1234"

        g2d.dispose();

        // 将验证码存储在会话中
        request.getSession().setAttribute("CAPTCHA", "1234");

        ImageIO.write(captchaImage, "jpeg", response.getOutputStream());
    }
}
```

#### 4.3. 在 `PhoneNumberAuthenticationFilter` 中校验验证码

```java
import javax.servlet.http.HttpServletRequest;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.authentication.BadCredentialsException;

public class PhoneNumberAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    // 省略了其他方法

    private void verifyCaptcha(HttpServletRequest request, String captcha) {
        String sessionCaptcha = (String) request.getSession().getAttribute("CAPTCHA");
        if (sessionCaptcha == null || !sessionCaptcha.equals(captcha)) {
            throw new BadCredentialsException("Invalid captcha.");
        }
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) {
        String captcha = obtainCaptcha(request);
        verifyCaptcha(request, captcha);

        // 省略了其他认证逻辑
    }
}
```

### 总结

通过上述步骤，你可以实现自定义手机号码加密码登录，并在登录时校验验证码的功能。这个过程涉及了自定义身份验证逻辑、配置Spring Security、编写登录控制器和表单页面，以及实现验证码的生成和校验。这个方案提供了一个灵活且可扩展的方式来处理自定义认证场景，同时确保系统的安全性。

为了在Spring Security中实现“记住我”（Remember-Me）功能，使用户在7天内免登录，可以遵循以下步骤：

1. **引入依赖**
2. **配置Remember-Me服务**
3. **配置Remember-Me令牌持久化存储**
4. **设置Remember-Me相关属性**

### 1. 引入依赖

首先，确保项目中已经包含Spring Security的依赖。如果你使用的是Spring Boot，通常不需要额外添加特殊的依赖。Spring Security依赖通常已经包含在Spring Boot Starter Security中。

### 2. 配置Remember-Me服务

我们需要在Spring Security的配置类中启用和配置Remember-Me服务。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;
import org.springframework.security.web.authentication.rememberme.PersistentTokenBasedRememberMeServices;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private PersistentTokenRepository persistentTokenRepository;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/login", "/captcha").permitAll()
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .loginPage("/login")
                .usernameParameter("username")
                .passwordParameter("password")
                .permitAll()
                .and()
            .logout()
                .permitAll()
                .and()
            .rememberMe()
                .tokenValiditySeconds(7 * 24 * 60 * 60) // 7天
                .rememberMeParameter("remember-me")
                .tokenRepository(persistentTokenRepository)
                .userDetailsService(userDetailsService);
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

### 3. 配置Remember-Me令牌持久化存储

为了让Remember-Me令牌能够持久化存储，我们需要实现 `PersistentTokenRepository`。可以使用JDBC持久化令牌：

#### 3.1. 创建数据库表

创建一个表来存储Remember-Me令牌。以下是一个示例SQL语句：

```sql
CREATE TABLE persistent_logins (
  username VARCHAR(64) NOT NULL,
  series VARCHAR(64) PRIMARY KEY,
  token VARCHAR(64) NOT NULL,
  last_used TIMESTAMP NOT NULL
);
```

#### 3.2. 配置持久化令牌存储

实现一个 `JdbcTokenRepositoryImpl` 来连接数据库进行持久化存储：

```java
import javax.sql.DataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;

@Configuration
public class RememberMeConfig {

    @Autowired
    private DataSource dataSource;

    @Bean
    public PersistentTokenRepository persistentTokenRepository() {
        JdbcTokenRepositoryImpl tokenRepository = new JdbcTokenRepositoryImpl();
        tokenRepository.setDataSource(dataSource);
        // 如果是第一次启动，需要自动创建表
        // tokenRepository.setCreateTableOnStartup(true);
        return tokenRepository;
    }
}
```

### 4. 设置Remember-Me相关属性

在登录表单页面中添加"记住我"复选框，并在请求中包含 `remember-me` 参数。

#### 4.1. 登录表单页面（login.html）

```html
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h1>Login Page</h1>
    <form method="post" action="/login">
        <div>
            <label>Username: <input type="text" name="username"/></label>
        </div>
        <div>
            <label>Password: <input type="password" name="password"/></label>
        </div>
        <div>
            <label>Remember me: <input type="checkbox" name="remember-me"/></label>
        </div>
        <div>
            <button type="submit">Login</button>
        </div>
    </form>
</body>
</html>
```

### 总结

通过上述步骤，我们可以在Spring Security中实现“记住我”的功能，使用户在登录时选择“记住我”选项后可以免登录7天。这个过程包括了配置Remember-Me服务、令牌持久化存储以及应用配置。这种方式不仅提升了用户体验，也确保了系统的安全性。

实现“忘记密码”和“找回密码”功能通常包括以下几个步骤：

1. **用户请求重置密码**
2. **生成重置密码的令牌**
3. **发送重置密码的邮件或短信**
4. **验证重置密码令牌**
5. **重置密码**

### 1. 用户请求重置密码

首先，我们需要一个功能允许用户请求重置他们的密码。这通常是通过一个简单的表单来实现，用户输入他们注册时使用的电子邮件地址或手机号码。

#### 1.1. "忘记密码"表单页面

创建一个表单页面，用户可以在这里输入他们的电子邮件或手机号码。

```html
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
</head>
<body>
    <h1>Forgot Password</h1>
    <form method="post" action="/forgot-password">
        <div>
            <label>Email: <input type="email" name="email"/></label>
        </div>
        <div>
            <button type="submit">Submit</button>
        </div>
    </form>
</body>
</html>
```

#### 1.2. 控制器方法

在控制器中处理"忘记密码"表单。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;

@Controller
public class PasswordResetController {

    @Autowired
    private UserService userService;

    @Autowired
    private EmailService emailService;

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, Model model) {
        String token = userService.createPasswordResetToken(email);
        if (token == null) {
            model.addAttribute("error", "No user found with that email address.");
            return "forgot-password";
        }
        emailService.sendPasswordResetEmail(email, token);
        model.addAttribute("message", "A password reset link has been sent to " + email);
        return "forgot-password";
    }
}
```

### 2. 生成重置密码的令牌

我们需要在 `UserService` 里添加生成密码重置令牌的逻辑。这个令牌可以是一个随机字符串，并且存储在数据库中以便后续验证。

#### 2.1. UserService 方法

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    public String createPasswordResetToken(String email) {
        Optional<User> user = userRepository.findByEmail(email);
        if (!user.isPresent()) {
            return null;
        }
        String token = UUID.randomUUID().toString();
        PasswordResetToken passwordResetToken = new PasswordResetToken(token, user.get());
        tokenRepository.save(passwordResetToken);
        return token;
    }
}
```

#### 2.2. 数据库实体

在数据库中存储密码重置令牌及其到期时间。

```java
import javax.persistence.*;
import java.util.Date;

@Entity
public class PasswordResetToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String token;

    @OneToOne(targetEntity = User.class, fetch = FetchType.EAGER)
    @JoinColumn(nullable = false, name = "user_id")
    private User user;

    private Date expiryDate;

    public PasswordResetToken() {}

    public PasswordResetToken(String token, User user) {
        this.token = token;
        this.user = user;
        this.expiryDate = calculateExpiryDate();
    }

    private Date calculateExpiryDate() {
        int expiryTimeInMinutes = 60 * 24; // 24 hours
        Date now = new Date();
        return new Date(now.getTime() + expiryTimeInMinutes * 60 * 1000);
    }

    // Getters and setters omitted for brevity
}
```

### 3. 发送重置密码的邮件或短信

这个步骤假设你已经有一个 `EmailService` 或类似的服务，用于发送电子邮件。

#### 3.1. EmailService

```java
import org.springframework.stereotype.Service;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@Service
public class EmailService {

    public void sendPasswordResetEmail(String email, String token) {
        String subject = "Password Reset Request";
        String message = "To reset your password, click the link below:\n" +
                "http://localhost:8080/reset-password?token=" + token;

        sendEmail(email, subject, message);
    }

    private void sendEmail(String to, String subject, String messageText) {
        // 设置电子邮件服务器属性
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.example.com"); // 替换为你的SMTP服务器
        props.put("mail.smtp.auth", "true");

        // 获取默认的Session对象
        Session session = Session.getDefaultInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("your-email@example.com", "your-password"); // 替换为你的邮箱和密码
            }
        });

        try {
            // 创建默认的MimeMessage对象
            Message message = new MimeMessage(session);

            // 设置发件人
            message.setFrom(new InternetAddress("your-email@example.com"));

            // 设置收件人
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));

            // 设置邮件主题
            message.setSubject(subject);

            // 设置邮件内容
            message.setText(messageText);

            // 发送邮件
            Transport.send(message);

            System.out.println("Email sent successfully");

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
}
```

### 4. 验证重置密码令牌

我们需要创建一个控制器来处理用户点击重置密码链接的请求，并验证令牌。

#### 4.1. 重置密码表单页面

```html
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
</head>
<body>
    <h1>Reset Password</h1>
    <form method="post" action="/reset-password">
        <div>
            <label>New Password: <input type="password" name="password"/></label>
        </div>
        <input type="hidden" name="token" value="${token}"/>
        <div>
            <button type="submit">Submit</button>
        </div>
    </form>
</body>
</html>
```

#### 4.2. 控制器方法

在控制器中处理重置密码请求。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PasswordResetController {

    @Autowired
    private UserService userService;

    @GetMapping("/reset-password")
    public String showResetPasswordPage(@RequestParam("token") String token, Model model) {
        if (!userService.isPasswordResetTokenValid(token)) {
            model.addAttribute("error", "Invalid or expired token.");
            return "reset-password";
        }
        model.addAttribute("token", token);
        return "reset-password";
    }

    @PostMapping("/reset-password")
    public String processResetPassword(@RequestParam("password") String password, 
                                       @RequestParam("token") String token,
                                       Model model) {
        if (!userService.resetPassword(token, password)) {
            model.addAttribute("error", "Invalid or expired token.");
            return "reset-password";
        }
        model.addAttribute("message", "Password reset successfully.");
        return "login";
    }
}
```

### 5. 重置密码

在 `UserService` 中添加验证令牌和重置密码的逻辑。

#### 5.1. UserService 方法

```java
import java.util.Date;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    public String createPasswordResetToken(String email) {
        Optional<User> user = userRepository.findByEmail(email);
        if (!user.isPresent()) {
            return null;
        }
        String token = UUID.randomUUID().toString();
        PasswordResetToken passwordResetToken = new PasswordResetToken(token, user.get());
        tokenRepository.save(passwordResetToken);
        return token;
    }

    public boolean isPasswordResetTokenValid(String token) {
        PasswordResetToken resetToken = tokenRepository.findByToken(token);
        return resetToken != null && resetToken.getExpiryDate().after(new Date());
    }

    public boolean resetPassword(String token, String newPassword) {
        PasswordResetToken resetToken = tokenRepository.findByToken(token);
        if (resetToken == null || resetToken.getExpiryDate().before(new Date())) {
            return false;
        }
        User user = resetToken.getUser();
        user.setPassword(new BCryptPasswordEncoder().encode(newPassword));
        userRepository.save(user);
        tokenRepository.delete(resetToken);
        return true;
    }
}
```

### 总结

通过上述步骤，你可以实现一个完整的“忘记密码”和“找回密码”功能。该功能包括用户请求密码重置、生成和存储重置令牌、发送重置链接、验证令牌以及重置密码。这个流程不仅确保了用户体验，还提高了系统的安全性。

在Spring Security中集成第三方登录（例如Google登录）通常使用OAuth2协议来实现。Spring Security 5.0开始提供了原生的OAuth2登录支持，使集成过程变得相对简单。以下是实现Google登录的详细步骤：

### 1. 引入依赖

首先，在`pom.xml`中引入Spring Security OAuth2客户端依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
```

### 2. 配置Google OAuth2客户端信息

在你的Spring Boot应用程序配置文件中（`application.yml`或`application.properties`），添加Google OAuth2客户端的信息。你需要在Google Developers Console中创建一个OAuth2客户端ID，并获取`client-id`和`client-secret`。

#### 2.1. 在`application.yml`中配置

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: your-client-id
            client-secret: your-client-secret
            scope: profile, email
            redirect-uri: "{baseUrl}/login/oauth2/code/{registrationId}"
```

#### 2.2. 或者在`application.properties`中配置

```properties
spring.security.oauth2.client.registration.google.client-id=your-client-id
spring.security.oauth2.client.registration.google.client-secret=your-client-secret
spring.security.oauth2.client.registration.google.scope=profile, email
spring.security.oauth2.client.registration.google.redirect-uri={baseUrl}/login/oauth2/code/{registrationId}
```

### 3. 配置Spring Security

将Spring Security配置为启用OAuth2登录。你可以创建一个新的配置类或者修改现有的配置类。

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/login**", "/error**").permitAll()
                .anyRequest().authenticated()
                .and()
            .oauth2Login()
                .loginPage("/login") // 自定义登录页面
                .defaultSuccessUrl("/home", true)
                .failureUrl("/login?error=true");
    }
}
```

### 4. 创建自定义的登录页面（可选）

如果你想自定义登录页面，可以创建一个简单的登录页面，其中包含一个Google登录按钮。

#### 4.1. 控制器方法

创建一个控制器来处理显示登录页面的请求。

```java
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String login() {
        return "login";
    }
}
```

#### 4.2. 登录页面（login.html）

在登录页面中添加一个Google登录按钮。

```html
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h1>Login Page</h1>
    <a href="/oauth2/authorization/google">Login with Google</a>
</body>
</html>
```

### 5. 处理登录成功后的逻辑（可选）

在某些情况下，你可能需要处理用户在登录成功后的逻辑，比如在数据库中存储用户信息。你可以实现一个 `OAuth2UserService` 来处理这种情况。

#### 5.1. 自定义OAuth2UserService

```java
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        // 提取用户信息
        Map<String, Object> attributes = oAuth2User.getAttributes();
        String email = (String) attributes.get("email");
        // 这里可以添加你的自定义逻辑，比如在数据库中存储用户信息
        return oAuth2User;
    }
}
```

#### 5.2. 在配置类中使用自定义的OAuth2UserService

```java
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.user.OAuth2User;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private CustomOAuth2UserService customOAuth2UserService;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/login**", "/error**").permitAll()
                .anyRequest().authenticated()
                .and()
            .oauth2Login()
                .loginPage("/login")
                .defaultSuccessUrl("/home", true)
                .failureUrl("/login?error=true")
                .userInfoEndpoint()
                .userService(customOAuth2UserService);  // 使用自定义的OAuth2UserService
    }
}
```

### 6. 处理用户返回和会话管理

登录成功后，你可能想要处理用户的返回页面和会话管理逻辑。你可以在Spring Security中配置这些项。 

例如，你可以在 `SecurityConfig` 中设置 `defaultSuccessUrl()` 和 `failureUrl()` 来控制登录成功和失败后的跳转页面。

```java
.oauth2Login()
    .loginPage("/login")
    .defaultSuccessUrl("/home", true)
    .failureUrl("/login?error=true")
```

你还可以配置会话管理，例如最大会话数和并发会话控制：

```java
.and()
    .sessionManagement()
    .maximumSessions(1)
    .maxSessionsPreventsLogin(true);
```

### 总结

通过上述步骤，我们就可以在Spring Security中集成Google登录，使得用户可以通过OAuth2协议使用Google账号进行登录。这种方式不仅提升了用户体验，还简化了用户的注册流程，并且安全性高。这种集成方式也可以用于其他支持OAuth2的第三方登录，如Facebook、GitHub等。

`maxSessionsPreventsLogin(true)` 是 Spring Security 中 `SessionManagementConfigurer` 类的一个配置选项，该选项用于控制用户的会话并发数。当达到最大会话数限制时，是否阻止新的会话登录。

具体来说，这个选项的作用如下：

- **`maximumSessions(int maximumSessions)`**：设置同一用户最大可并发会话数。
- **`maxSessionsPreventsLogin(boolean value)`**：设置是否阻止新的会话登录。当设置为 `true` 时，新的登录会话将被拒绝并抛出一个异常；当设置为 `false` 时，新的会话会替换之前的会话。

### 例子

假设你有一个应用程序，你希望每个用户最多只有一个活动会话，这可以通过下面的配置来实现：

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/login**", "/error**").permitAll()
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .loginPage("/login")
                .defaultSuccessUrl("/home", true)
                .failureUrl("/login?error=true")
                .and()
            .sessionManagement()
                .maximumSessions(1) // 每个用户只允许一个会话
                .maxSessionsPreventsLogin(true); // 达到最大会话数后阻止新的会话登录
    }
}
```

### 工作原理

1. **最大并发会话数**：通过 `maximumSessions(1)` 来限制每个用户最多只有一个活动会话。

2. **阻止新会话**：如果 `maxSessionsPreventsLogin(true)` 被设置为 `true`，当用户尝试在另一个设备或浏览器中进行登录时，该登录会被拒绝，用户会看到一个错误消息，提示他们已经在另一个地方登录。

### 默认行为

- **`maxSessionsPreventsLogin(false)`**：默认情况下，这个选项是 `false`，这意味着当达到最大会话数时，新的会话将替换旧的会话。旧的会话将被标记为无效，用户在之前的会话中将被强制下线。

### 异常处理

当 `maxSessionsPreventsLogin(true)` 被触发时，Spring Security 会抛出一个 `SessionAuthenticationException` 异常。默认情况下，这个异常会被捕获并重定向到登录失败页面。在登录失败页面中，你可以显示一个适当的错误消息来提示用户。

你可以自定义错误处理逻辑，例如：

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.web.authentication.session.ConcurrentSessionControlAuthenticationStrategy;
import org.springframework.security.web.session.HttpSessionEventPublisher;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/login**", "/error**").permitAll()
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .loginPage("/login")
                .defaultSuccessUrl("/home", true)
                .failureUrl("/login?error=true")
                .and()
            .sessionManagement()
                .maximumSessions(1)
                .maxSessionsPreventsLogin(true)
                .expiredUrl("/session-expired.html")
                .sessionRegistry(sessionRegistry());
    }

    @Bean
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    @Bean
    public HttpSessionEventPublisher httpSessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }
}
```

在上述配置中，当达到最大会话数限制时，会话到期后的跳转页面被设置为 `/session-expired.html`，这个页面会显示一个提示信息告诉用户他们的会话已经过期。

### 总结

`maxSessionsPreventsLogin(true)` 用于控制用户的最大会话数，并在达到最大会话数时阻止新的会话登录。这个设置通常适用于高安全需求的应用程序，确保同一用户不能在多个地方同时登录。而通过合理的配置，可以提升应用程序的安全性，防止用户名密码被滥用。

单点登录（Single Sign-On，SSO）是一种认证机制，允许用户在多个应用系统中使用同一个凭证登录，从而在不同的系统间无缝切换。实现SSO的方法有很多种，包括基于OAuth、SAML、CAS等不同的协议和框架。本文将介绍基于Spring Security OAuth2的SSO实现，这是当前比较流行和现代化的解决方案。

### 基于OAuth2的SSO实现示例

假设我们有两个客户端应用和一个认证服务，这里使用Spring Security OAuth2 Client和Spring Authorization Server来实现SSO。

### 1. 建立认证服务器 (Authorization Server)

首先，我们需要一个认证服务器来处理认证请求。Spring Authorization Server可以用来快速搭建一个OAuth2认证服务器。

#### 1.1 引入依赖

在认证服务器的`pom.xml`文件中引入需要的依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-authorization-server</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

#### 1.2 配置Spring Security

配置认证服务器，使其支持OAuth2授权代码授予类型：

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;

@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Bean
    public UserDetailsService userDetailsService() {
        InMemoryUserDetailsManager manager = new InMemoryUserDetailsManager();
        manager.createUser(User.withDefaultPasswordEncoder()
                .username("user")
                .password("password")
                .roles("USER")
                .build());
        return manager;
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/oauth2/**").permitAll()
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .permitAll();
    }
}
```

#### 1.3 配置授权服务器

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configuration.EnableAuthorizationServer;
import org.springframework.security.oauth2.config.annotation.web.configuration.AuthorizationServerConfigurerAdapter;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.config.annotation.configurers.ClientDetailsServiceConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerEndpointsConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerSecurityConfigurer;

@Configuration
@EnableAuthorizationServer
public class AuthorizationServerConfig extends AuthorizationServerConfigurerAdapter {

    // 配置客户端信息
    @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        clients.inMemory()
            .withClient("client1")
            .secret("{noop}secret1")
            .authorizedGrantTypes("authorization_code", "refresh_token")
            .scopes("read", "write")
            .redirectUris("http://localhost:8081/login/oauth2/code/client1")
            .and()
            .withClient("client2")
            .secret("{noop}secret2")
            .authorizedGrantTypes("authorization_code", "refresh_token")
            .scopes("read", "write")
            .redirectUris("http://localhost:8082/login/oauth2/code/client2");
    }
    
    // 配置访问令牌端点和授权码端点的安全
    @Override
    public void configure(AuthorizationServerSecurityConfigurer security) throws Exception {
        security
            .tokenKeyAccess("permitAll()")
            .checkTokenAccess("isAuthenticated()");
    }
}
```

### 2. 配置客户端应用 (Client Applications)

我们需要两个客户端应用来演示SSO。这两个客户端应用将使用Spring Security OAuth2 Client来进行OAuth2授权码流程。

#### 2.1 引入依赖

在两个客户端应用的`pom.xml`中引入OAuth2 Client依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

#### 2.2 配置OAuth2客户端

在客户端应用的配置文件中设置OAuth2客户端信息：

##### application.yaml (客户端1)

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          client1:
            client-id: client1
            client-secret: secret1
            scope: read,write
            authorization-grant-type: authorization_code
            redirect-uri: "{baseUrl}/login/oauth2/code/{registrationId}"
        provider:
          client1:
            authorization-uri: http://localhost:8080/oauth/authorize
            token-uri: http://localhost:8080/oauth/token
            user-info-uri: http://localhost:8080/userinfo
            user-name-attribute: username
```

##### application.yaml (客户端2)

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          client2:
            client-id: client2
            client-secret: secret2
            scope: read,write
            authorization-grant-type: authorization_code
            redirect-uri: "{baseUrl}/login/oauth2/code/{registrationId}"
        provider:
          client2:
            authorization-uri: http://localhost:8080/oauth/authorize
            token-uri: http://localhost:8080/oauth/token
            user-info-uri: http://localhost:8080/userinfo
            user-name-attribute: username
```

#### 2.3 配置Spring Security

在两个客户端应用中配置Spring Security来使用OAuth2登录。

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/oauth2/**").permitAll()
                .anyRequest().authenticated()
                .and()
            .oauth2Login()
                .loginPage("/login")
                .defaultSuccessUrl("/", true);
    }
}
```

#### 2.4 创建默认页面和控制器

创建一个简单的默认页面来验证用户登录状态。

```java
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "home";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }
}
```

#### home.html

```html
<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
</head>
<body>
    <h1>Home Page</h1>
    <p>Welcome!</p>
    <a href="/logout">Logout</a>
</body>
</html>
```

#### login.html

```html
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h1>Login Page</h1>
    <a href="/oauth2/authorization/client1">Login with Client1</a>
    <a href="/oauth2/authorization/client2">Login with Client2</a>
</body>
</html>
```

### 总结

通过上述步骤，我们实现了基于OAuth2的单点登录（SSO）。两个客户端应用通过OAuth2认证服务器进行认证，用户在一个客户端应用中登录后，可以无缝访问另一个客户端应用而无需重新登录。这种方法不仅提升了用户体验，还有效地管理和保护了用户的认证信息。

`{registrationId}` 是 Spring Security OAuth2 Client 中的一个占位符，用于标识当前的OAuth2客户端注册。它从 `spring.security.oauth2.client.registration` 配置的客户端注册信息中获取。具体来说，`registrationId` 对应于你在配置文件中为每个 OAuth2 客户端注册时定义的唯一标识符。

例如，在配置文件中，你可能有如下配置：

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: google-client-id
            client-secret: google-client-secret
            scope: profile, email
            authorization-grant-type: authorization_code
            redirect-uri: "{baseUrl}/login/oauth2/code/{registrationId}"
        provider:
          google:
            authorization-uri: https://accounts.google.com/o/oauth2/auth
            token-uri: https://oauth2.googleapis.com/token
            user-info-uri: https://www.googleapis.com/oauth2/v3/userinfo
            user-name-attribute: sub
```

在这个配置中，`google` 即为 `registrationId`。它是你在 `spring.security.oauth2.client.registration` 下定义的客户端注册信息的标识符。在配置 `redirect-uri` 时，Spring Security 使用 `{registrationId}` 占位符来替换实际的客户端注册标识符。

### 如何使用 `{registrationId}`

#### 1. 配置文件

在 `application.yml` 或 `application.properties` 配置文件中，定义多个OAuth2客户端：

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: google-client-id
            client-secret: google-client-secret
            scope: profile, email
            authorization-grant-type: authorization_code
            redirect-uri: "{baseUrl}/login/oauth2/code/google"
        provider:
          google:
            authorization-uri: https://accounts.google.com/o/oauth2/auth
            token-uri: https://oauth2.googleapis.com/token
            user-info-uri: https://www.googleapis.com/oauth2/v3/userinfo
            user-name-attribute: sub
```

### 2. 配置类

在Spring Security配置类中，不需要特别处理 `registrationId`，它会自动识别来自配置文件中的客户端注册信息。

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/login**", "/error**").permitAll()
                .anyRequest().authenticated()
                .and()
            .oauth2Login()
                .loginPage("/login") // 自定义登录页面
                .defaultSuccessUrl("/home", true)
                .failureUrl("/login?error=true");
    }
}
```

### 3. 自定义登录页面

假设你有一个自定义登录页面 `login.html`，你希望用户能够选择通过Google进行登录。在登录页面上，你可以提供一个链接，指向该特定的OAuth2客户端授权端点。

```html
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h1>Login Page</h1>
    <a href="/oauth2/authorization/google">Login with Google</a>
</body>
</html>
```

当用户点击 "Login with Google" 链接时，Spring Security 会自动处理 OAuth2 的授权流程，并将用户重定向到 Google 的授权页面。

### 4. 控制器示例

你可能还会有一个控制器来处理登录请求并显示首页或其他内容。

```java
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/home")
    public String home() {
        return "home"; // 返回视图名
    }

    @GetMapping("/login")
    public String login() {
        return "login"; // 返回视图名
    }
}
```

### 总结

- `{registrationId}` 占位符用于OAuth2客户端配置中的 `redirect-uri`，它会被客户端注册标识符（如 `google`）替换。
- 这个标识符与 `spring.security.oauth2.client.registration` 下的具体客户端配置对应。
- 在Spring Security配置类中，配置OAuth2登录，不需手动处理 `registrationId`，Spring Security会自动识别配置文件中的客户端注册信息。
- 在自定义登录页面提供指向OAuth2授权端点的链接，用户点击后，Spring Security会自动处理授权流程。

通过这样的配置，你可以方便地集成多个OAuth2客户端，实现统一的单点登录体验。

`authorization-uri` 和 `token-uri` 是OAuth2协议中非常关键的两个端点，它们分别用于处理授权请求和访问令牌请求。根据OAuth2协议的定义，这两个端点在OAuth2授权流程中起着不同的作用。

### 1. Authorization Endpoint (`authorization-uri`)

**用途**：处理用户的授权请求。

**典型用途**：用户通过浏览器访问该端点进行登录并授权应用访问其资源。

**URL 格式**：`http://localhost:8080/oauth/authorize`

- 客户端应用将用户重定向到该端点。
- 通过该端点，用户可以登录并授权应用访问用户的资源。
- 授权成功后，该端点会生成一个授权码，并将其重定向回客户端应用。

**请求示例**：

```
GET http://localhost:8080/oauth/authorize?
  response_type=code&
  client_id=CLIENT_ID&
  redirect_uri=REDIRECT_URI&
  scope=read write&
  state=STATE
```

### 2. Token Endpoint (`token-uri`)

**用途**：用于交换授权码或刷新令牌以获取访问令牌。

**典型用途**：客户端应用后台请求该端点以获取访问令牌（通过授权码、用户名密码等方式）。

**URL 格式**：`http://localhost:8080/oauth/token`

- 客户端应用通过POST请求访问该端点，使用授权码获取访问令牌。
- 可以用不同的授权类型（如授权码、客户端凭証、密码凭証等）获取访问令牌。

**请求示例**：

```
POST http://localhost:8080/oauth/token
  grant_type=authorization_code&
  code=AUTHORIZATION_CODE&
  redirect_uri=REDIRECT_URI&
  client_id=CLIENT_ID&
  client_secret=CLIENT_SECRET
```

### 实现这些端点

如果你使用的是Spring Authorization Server或其他类似库的话，这些端点会由框架自动实现。你不需要自己手动实现它们，只需要进行配置即可。

#### 1. 使用Spring Authorization Server

Spring Authorization Server 是一个由Spring团队提供的用于构建OAuth2授权服务器的框架。它可以帮助你快速实现一个完全符合OAuth2标准的授权服务器。

依赖配置：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-authorization-server</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

Spring Authorization Server 配置示例如下：

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.oauth2.config.annotation.configurers.ClientDetailsServiceConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configuration.EnableAuthorizationServer;
import org.springframework.security.oauth2.config.annotation.web.configuration.AuthorizationServerConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerEndpointsConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerSecurityConfigurer;

@Configuration
@EnableAuthorizationServer
public class AuthorizationServerConfig extends AuthorizationServerConfigurerAdapter {

    @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        clients.inMemory()
            .withClient("client1")
            .secret(passwordEncoder().encode("secret1"))
            .authorizedGrantTypes("authorization_code", "refresh_token")
            .scopes("read", "write")
            .redirectUris("http://localhost:8081/login/oauth2/code/client1")
            .and()
            .withClient("client2")
            .secret(passwordEncoder().encode("secret2"))
            .authorizedGrantTypes("authorization_code", "refresh_token")
            .scopes("read", "write")
            .redirectUris("http://localhost:8082/login/oauth2/code/client2");
    }

    @Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
        endpoints
            // Add additional configurations here if necessary
        ;
    }

    @Override
    public void configure(AuthorizationServerSecurityConfigurer security) throws Exception {
        security
            .tokenKeyAccess("permitAll()")
            .checkTokenAccess("isAuthenticated()");
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

在这个配置中：
- `authorization-uri` 对应于 `AuthorizationServerConfigurerAdapter` 中的 `AuthorizationServerEndpointsConfigurer` 配置。
- `token-uri` 对应于 `AuthorizationServerEndpointsConfigurer` 配置。

引入Spring Authorization Server后，Spring Security会为你自动配置这些端点。你只需进行必要的安全配置和客户端注册信息配置。

### 测试

现在你已经配置好了OAuth2 Authorization Server，可以通过浏览器访问：

- `http://localhost:8080/oauth/authorize`：这里你可以通过相应的客户端提供的URL进行授权请求。
- `http://localhost:8080/oauth/token`：用于客户端请求访问令牌。

成功授权后，你应该能看到在`redirect_uri` 页面获取到的 `code`，然后客户端使用获取到的 `code` 去请求获取 `access_token`。

### 总结

- `authorization-uri`：处理OAuth2授权请求的端点。用户通过这个端点进行登录和授权。
- `token-uri`：处理OAuth2令牌请求的端点。客户端使用这个端点通过授权码等获取访问令牌。
- 使用Spring Authorization Server 或其它框架来自动实现这些端点，可以大大简化开发工作。你只需关注配置和客户端注册信息，不需要手动实现具体的授权和令牌逻辑。



在OAuth2的授权流程中，客户端通过授权服务器获取`access_token`后，便可以使用这个令牌来访问受保护的资源。以下是客户端如何使用`access_token`的详细步骤和示例。

### 1. 获取`access_token`

首先，客户端需要通过授权服务器的Authorization Code Grant流程获取`access_token`。这个过程包括以下几个步骤：

1. 用户从客户端重定向到授权服务器的授权端点。
2. 用户在授权服务器上进行身份验证并授权给客户端。
3. 授权服务器将用户重定向回客户端，并附带一个授权码（authorization code）。
4. 客户端用授权码请求授权服务器的令牌端点获取`access_token`。

假设你已经获取到`access_token`，例如：

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cC...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "tGzv3JOkF0XG5Qx2TlKWIA"
}
```

### 2. 使用`access_token`访问受保护资源

客户端可以将`access_token`包含在HTTP请求的Authorization头部中，以访问受保护资源。受保护资源可以是你的Spring Boot应用程序中提供的API或其他服务。

#### HTTP请求示例

```http
GET /protected/resource HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5c...
```

### 3. Spring Boot中的资源服务器配置

假设你有一个受保护的资源API，并希望只有持有有效`access_token`的客户端才能访问。你需要将你的应用程序配置为OAuth2资源服务器。

#### 3.1. 引入依赖

在你的Spring Boot项目的`pom.xml`文件中，添加Spring Security OAuth2资源服务器依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
</dependency>
```

#### 3.2. 配置资源服务器

在你的Spring Boot应用程序中配置资源服务器，以便能够验证和处理`access_token`。

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;

@Configuration
@EnableWebSecurity
public class ResourceServerConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/public/**").permitAll()
                .anyRequest().authenticated()
                .and()
            .oauth2ResourceServer()
                .jwt();
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtGrantedAuthoritiesConverter converter = new JwtGrantedAuthoritiesConverter();
        converter.setAuthorityPrefix("ROLE_");
        converter.setAuthoritiesClaimName("roles");

        JwtAuthenticationConverter jwtAuthenticationConverter = new JwtAuthenticationConverter();
        jwtAuthenticationConverter.setJwtGrantedAuthoritiesConverter(converter);
        return jwtAuthenticationConverter;
    }
}
```

### 4. 示例受保护资源API

创建一个简单的REST控制器，提供受保护的资源。

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;

@RestController
public class ProtectedResourceController {

    @GetMapping("/protected/resource")
    public String getProtectedResource(@AuthenticationPrincipal Jwt jwt) {
        return "This is a protected resource. You are authenticated as " + jwt.getSubject();
    }
}
```

### 5. 测试客户端访问

客户端应用程序可以使用任何HTTP客户端工具（如Postman、curl等）来请求受保护的资源。

#### 使用curl请求示例

```sh
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5c..." http://localhost:8080/protected/resource
```

如果`access_token`有效并且资源服务器正确配置，客户端将会收到受保护资源的响应。

### 6. 刷新`access_token`

当`access_token`过期后，客户端可以使用刷新令牌(`refresh_token`)来获取新的`access_token`。这可以避免用户再次进行身份验证。

#### 刷新令牌请求示例

```http
POST /oauth/token HTTP/1.1
Host: authorization-server.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token&refresh_token=tGzv3JOkF0XG5Qx2TlKWIA&client_id=CLIENT_ID&client_secret=CLIENT_SECRET
```

成功响应示例：

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5c...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "tGzv3JOkF0XG5Qx2TlKWIA"
}
```

### 总结

通过上述步骤，你可以让客户端获取和使用`access_token`来访问受保护的资源。对于资源服务器的配置，Spring Security OAuth2提供了简洁的配置方式，使得处理`access_token`的验证和授权变得非常简单。通过合理地使用OAuth2协议，客户端可以在安全的前提下访问受保护的资源，并且可以通过刷新令牌机制来延长访问令牌的有效期。

当客户端使用无效的 `access_token` 访问受保护资源时，资源服务器响应的具体内容将依赖于资源服务器的实现。对于使用 Spring Security 配置的 OAuth2 资源服务器，默认情况下，如果 `access_token` 无效，客户端通常会收到 HTTP 401 Unauthorized 响应，并且响应体中会包含一些错误信息描述。

### 常见的无效 `access_token` 错误响应

一个典型的 HTTP 401 Unauthorized 响应可能如下所示：

*HTTP 响应示例：*

```http
HTTP/1.1 401 Unauthorized
Content-Type: application/json
WWW-Authenticate: Bearer error="invalid_token", error_description="The access token expired"
```

*响应体（JSON）：*

```json
{
    "error": "invalid_token",
    "error_description": "The access token expired"
}
```

### 示例场景和错误信息

资源服务器返回 HTTP 401 Unauthorized 状态码可以有多种原因，以下是一些常见场景：

1. **`access_token` 已经过期**

   错误信息：
   ```json
   {
       "error": "invalid_token",
       "error_description": "The access token expired"
   }
   ```

2. **`access_token` 非法或格式错误**

   错误信息：
   ```json
   {
       "error": "invalid_token",
       "error_description": "Invalid access token"
   }
   ```

3. **`access_token` 已被吊销**

   错误信息：
   ```json
   {
       "error": "invalid_token",
       "error_description": "The access token is no longer valid"
   }
   ```

### 如何处理无效的 `access_token`

对于客户端来说，处理无效 `access_token` 的常见策略包括：

1. **刷新令牌**：如果收到 `access_token` 无效的响应，客户端可以尝试使用 `refresh_token` 获取新的 `access_token`，然后重试请求。

2. **重新认证**：如果无法使用 `refresh_token` 获取新的 `access_token`，客户端可能需要用户重新进行身份验证。

### 示例：客户端处理无效 `access_token`

以下是一个示例的伪代码，展示了如何在客户端处理无效 `access_token` 的响应。

```python
import requests

# 发起受保护资源请求
def get_protected_resource(access_token):
    headers = {
        "Authorization": f"Bearer {access_token}"
    }
    response = requests.get("http://localhost:8080/protected/resource", headers=headers)
    
    if response.status_code == 401:
        error_info = response.json()
        if error_info.get("error") == "invalid_token":
            print("Access token is invalid:", error_info.get("error_description"))
            # 尝试刷新令牌
            new_access_token = refresh_access_token()
            if new_access_token:
                # 使用新的 `access_token` 重试请求
                headers["Authorization"] = f"Bearer {new_access_token}"
                response = requests.get("http://localhost:8080/protected/resource", headers=headers)
                return response
            else:
                print("Failed to refresh access token")
        else:
            print("Authorization failed:", error_info)
    return response

# 刷新令牌
def refresh_access_token():
    refresh_token = "your-refresh-token"  # 获取已有的 `refresh_token`
    data = {
        "grant_type": "refresh_token",
        "refresh_token": refresh_token,
        "client_id": "your-client-id",
        "client_secret": "your-client-secret"
    }
    response = requests.post("http://localhost:8080/oauth/token", data=data)
    if response.status_code == 200:
        return response.json().get("access_token")
    return None

# 使用 `access_token` 请求受保护的资源
access_token = "your-access-token"
response = get_protected_resource(access_token)
if response.status_code == 200:
    print("Successfully accessed protected resource:", response.json())
else:
    print("Failed to access protected resource")
```

### 总结

- 当客户端使用无效的 `access_token` 访问受保护资源时，Spring Security 资源服务器通常会返回 HTTP 401 Unauthorized 响应，包含详细的错误信息。
- 客户端在处理无效 `access_token` 时，可以尝试刷新令牌或要求用户重新进行身份验证。
- 在实际应用中，可以为客户端实现更加健壮的错误处理逻辑，以确保在 `access_token` 失效时不影响用户体验。