---
typora-root-url: ..\..
---

[Intellij IDEA创建Maven Web项目](http://www.cnblogs.com/winkey4986/p/5279820.html)
## idea配置一个项目的步骤
![](/images/software/idea/1.png)

![](/images/software/idea/2.png)

![](/images/software/idea/3.png)

![](/images/software/idea/4.png)

## 配置tomcat启动项目

![](/images/software/idea/6.png)

![](/images/software/idea/7.png)

## idea在合并分支过程中导致*.iml被更改，项目加载不出来的解决办法
![](/images/software/idea/5.png)

## 添加maven依赖之外的jar
![](/images/software/idea/8.png)
实践过程中，在切换分支时发现之前添加的jar包找不到了，会报编译错误，此时要将之前添加的lib移掉，然后重新添加。
## 通过idea修改全局maven配置文件
![](/images/software/idea/9.png)  
需要从远程下载新的jar包时，需要注释掉私服xingtu的镜像地址。
## 从git上面导入项目
![](/images/software/idea/从git上面导入项目/1.png)  
![](/images/software/idea/从git上面导入项目/2.png)  
![](/images/software/idea/从git上面导入项目/3.png)  
![](/images/software/idea/从git上面导入项目/4.png)  
![](/images/software/idea/从git上面导入项目/5.png)  
![](/images/software/idea/从git上面导入项目/6.png)  
![](/images/software/idea/从git上面导入项目/7.png)
![](/images/software/idea/从git上面导入项目/8.png)  
## plugins
### GsonFormat
这个插件根据json数据生成pojo，复制接口响应数据，创建entity类，在创建类的窗口，Alt+Insert,选择GsonFormat，粘贴json，生成。
#### 安装插件
Intellij IDEA File——>Settings——>IDE setttings——>Plugins
搜索GsonFormat，安装后重启idea。

## 激活方法
[Win10中Clion的安装-注册-MinGW环境配置-运行C++](https://blog.csdn.net/qq_33956051/article/details/79463757)