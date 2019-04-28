---
typora-root-url: ..\..
---

![TIM截图20190401153653](/images/linux/docker/dockerfile使用示例/TIM截图20190401153653.png)

![TIM截图20190401153909](/images/linux/docker/dockerfile使用示例/TIM截图20190401153909.png)

ocdm-web.dockerfile

```dockerfile
FROM java:8-jdk

LABEL version="1.0.0" \ 
      maintainer="wang.ganzhong01@iwhalecloud.com"

WORKDIR /
ADD ./code /web/

EXPOSE 8080

ENTRYPOINT ["java", "-Duser.timezone=GMT+08", "-cp", "/web", "org.springframework.boot.loader.WarLauncher"]
```

使用dockerfile编译镜像到仓库

```
docker build -f ocdm-web.dockerfile -t iwhalecloud/ocdm-web .
```

![TIM截图20190401154556](/images/linux/docker/dockerfile使用示例/TIM截图20190401154556.png)