## 1、前提准备

首先请确认你的电脑是 windows10 专业版或企业版，只有这只有这两个版本才带有 hyper-v

## 2、介绍

以往我们如果想要在 windows 上使用 docker，都是使用 virual box 来创建虚拟机，自从 windows10 发布以来，微软宣布了一系列的 linux 软件登陆 windows，其中就包括了 docker，现在我们可以使用 windows 自带的 hyper-v 虚拟机来创建运行 docker 服务。

InteliiJ Idea 作为目前最实用的 IDE 对 Docker 也提供了支持。

## 3、安装 Docker for windows

3.1 从官网下载 docker for windows，https://store.docker.com/editions/community/docker-ce-desktop-windows，下载完毕后进入安装界面, docker 会自动安装，界面一闪而过，电脑运行速度还不错，安装完成之后，docker 会弹个窗告诉你 hyper-v 未开启，像这样。

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenUWCJMicusUmU5EXqa5ynCLQAlOibXftjCZgrb0vCp5ibhszY50XicY7X3g/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

不过如果你现在点击 OK 基本上是没有用的，得先去 BIOS 里打开硬件虚拟化，本机是惠普的机器，开启点按 f10 进入 bios，其他品牌的机器自行搜索进入，像这样

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenmDE77yOcnqu5d7w7gIaoEzL6eYibYRh8GRs1ccZxMwas6vC59DuzQIA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

重启电脑后 docker 会自动运行，依然弹出上面那个 hyper-v 未开启的窗口，这回可以点击 OK 让 docker 来帮你开启 hyper-v，或者是自己在控制面板 - 程序 - 程序和功能 - 启用或关闭 windows 功能里开启 hyper-v

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenSVKgn7YdPn6bTSbTdu5Pc71kSHPAPB3pL0W3qibtuJ8nKrcLrgia3WIg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

到此，我们的 docker for windows 已经安装完成。在命令行中输入 docker --version 可以查看已经安装的 docker 版本

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenvx4o4ZbkibHbx53PYB76dNkITdOpBK3ic5mAjYe2ywwu8oAebJO4KYNw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 3.2 使用 docker 中的镜像 

3.2.1  先用官方镜像作个示例  使用 docker search来搜索对应的镜像 

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenyDrh4DlvHWdKff34O2NlNuR3p8jj4GsPMGIUZ7KMnEEoE1QMgL3Bkg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

然后使用 docker pull <镜像名: tag> 例如 docker pull nginx:latest  ,tag 不输入是默认拉取最新的　

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbens1R3HHgEicMK3Ht5z8cecXfMGaFBJzNbGRicnqyW5ddLFLF6tdvLb37A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

当镜像下载玩之后我们通过 docker images 命令来查看所有本地的镜像

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenBSiaQoZPdEs4b56iacibV7CHScq5DXulCp7oeWeZv9LH8iaTu2SD7XXE3A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

我这里下载了 java 以及 nginx 的镜像 其中还有我已经打包好的 spring cloud 的 eureka 注册中心的镜像

使用 docker run 命令来运行镜像，我这里运行 nginx 的镜像

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenvh90c9v4XSChQXEwZdYu91r7Aiae2yNP7dyTPOgMjBaRXwOuyxQ48HQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

使用 docker 运行 nginx 成功后访问 localhost:80 就可以访问到 nginx 的主页，说明我们已经在 docker 运行了我们的第一个镜像，虽然是官方镜像，但心里的成就感还是不低的。

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenG0CboPFebC8ya36sR8qc5q6LZF1cMqQoEGObEWZxjmDwDibOMUzbZ0w/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

好的，在运行了第一个镜像之后，我们要开始在 IntelliJ IDEA 中使用 docker 并构建我们的第一个 spring boot 程序放到 docker 中去运行

## 4、IDEA 的准备工作

1：Docker 插件，首先需要在你的 IDEA 中安装 Docker 插件，定位到 File-Setting-Plugins 后搜索 Docker Integration 安装。

2：配置 Docker 服务器，在 IDEA 中定位到 File-Setting-build,Execution,Deployment-Docker

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenlaF4O6DOOlhviaeR9Jw3LibKY6Xl2W0x5YIhfUEibA8nTfvDD6K2oGQGw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

如果你没用使用 Docker Machine 来管理虚拟机的需求的话, 我们使用默认的 Docker 守护进程就 OK 了，不过在此之前我们还需要设置一下 docker

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenyD3MC935LpEcrvAVteo5KyZIDeveAdXO0f43uCmcgAvVjC6dVwcvfw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenaqYSCZFlKCiaBl6d2Z3UBleryibD5o6yVS4r8sBnofluHAmCsBYLlibPA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

将 docker 与本地的连接设置为不需要 TLS 加密。

在完成这一步之后，可以在 IDEA 的配置窗口看到成功连接到了本机上的 docker

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenDZtcYaiaaqwQ9VdLfGIaOoInv4psfNNQfNDAdOnqXqQIAtdTdL2GiceQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

到这里，我们已经完成对 docker 的配置，接下来就可以进入真正的实施阶段。

## 5、创建 spring cloud 项目

首先在 Idea 中创建一个 spring boot 项目，怎么创建在此就不再赘述了创建完成之后，我们在 pom.xml 中添加依赖项。

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenkL2I5UibkD8Q0Rw9Zc9MZuEhmoucYRagguGPf7f2B45umWRFNQQrGww/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

本地编写的是 spring cloud 的注册中心项目，所以还需要加上

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNben8VGQ0DLg7PGfb1icZHvDaQNMBqK2626iaCBsCleRgGmsPWTvwpT5jX9Q/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

spring 的版本需要与 spring cloud 的版本号对应，详细的对应信息可以去 http://projects.spring.io/spring-cloud / 查看

由于本次只是简单地示范如何在 IDEA 中部署 spring boot 项目到 docker 中，所以在项目中只需要对 eureka 注册中心进行简单的配置就 OK 了，

在启动类中加上注解标明这是一个 eureka 注册中心的项目

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenoYAT93F0iaPyoXYXGJN4X0xPuNAAzvwLNxvu09XVKM7ls3yONrnebgg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

在配置文件中配置端口

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbeno066WmibFIdVzDl9hGXMHDG4275fyl1FMgs1xtfWNgKA5ALEbribt3UA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

然后我们就完成了项目的编写，可以先启动看看项目是否能够启动，启动之后我们访问 http://localhost:8761/ , 可以看到我们的 eureka 注册中心已经启动，项目编写没有问题

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenqLAY1yrKlCTOdnYBrAvQUPOm9UltlP5fL59Qthrafznd98Tx4FhOsQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

接下来就到了如何把项目部署到 docker 中去的问题了

## 6、将项目部署到 Docker 中

首先我们需要编写 Dockerfile 文件，在 src-main 目录下新建 docker 文件夹，然后在其中新建 Dockerfile 文件

文件内容如下

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenk2mB8r0ibwCBgib2CiaNoJ79yDVcNmsKicWqGicOHUtrQ3jo0pCR5kicP3CA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

其中红框的地方是本项目打包之后的 jar 包名字，默认是 artifactId-version.jar, 同时我们可以看到在左上叫有个运行的标记，很对，这个就是用来在 IDEA 构建 jar 包到镜像，然后放到 Docker 中运行的按钮, 不过我们还是需要先配置一下

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenlzgberyWvJYRAXeBB3wq9BFQIsOFNZRfV5O1m70YLLHIlf8DucjK9Q/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

我们先配置镜像名称以及容器名称

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNben1rQQlU4NwXZWE2icf8hQMxYLJcXKKuUfBG9jFATXyaecZ21icO6GbLow/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

然后需要对 docker 容器需要映射的端口号进行配置

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenCZv5kdd3yEbenkZjDvLwT0E8UYXaweRsRkg1tH2EyfdFeM9RjBKS9g/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

然后我们点击 run, 可以看到，很快就报错了，这是由于 DockerFile 与我们生成的 jar 包不在同一个文件夹造成的。

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenbdtueRabBzudCtYEibic3ibXV3nU2ibzicEF1VJxcN0g49Ok2ibMchUkRZSg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

为了解决这个问题，我找到了两种方案：

### 方案 1：先使用 maven 命令

mvn clean package

对项目进行打包，命令执行完毕之后可以在 target 目录下看到已经打包完成的 jar 包

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenVPT6bf5I568suOmcka1drRjvD4ib9VhiadE1MDTnO5z5umtWGqibOsBDA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

然后把 jar 包放到 Dockerfile 所在的目录下，像这样

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenJJxD6HCic5JfiaeMp3x7Ttc7A4PknlLHbKxM7M9RNb6QQLQum0nRYPUw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

然后接着点击 Dockerfile 中的运行，

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNben2nnX1u1icgP4j6mEpITbUibn1GvEAibQ4euAibZ9x5EA3epfIHI8MedVow/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

在 Deploylog 窗口中，可以看到，这次构建镜像就成功了, 在 log 窗口中可以看到我们的项目在运行过程中打出的日志信息

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNben0GlTsk3c4E67bSolnX3ibGz6wXIUQMb9EiakibclGAxDfOf50reIjblyw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

很明显，这次的构建和部署都成功了, 访问 http://localhost:8761/，出现了我们想要看到的东西。

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenzkic4xibUn3Yseb2CQDcLic8wtlNokrPml4LJaQYx0giaQwF73QiaPb0iciaA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

在命令行中使用 docker ps 命令查看正在运行的容器信息

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenWPWth2J6TE9TLDbvB6mqzvzeHEegpWibibv7U6nh3tLgT8DNGeuxrwTg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

可以看到，我们在 IDEA 中编写的项目已经运行到了 docker 中。

### 方案 2：使用 docker-maven-plugin 插件，在 pom.xml 中配置插件

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenKVnhQN00IwshibxbEg5S6RIbfU8tnEHcmhHhOFvlS9FyQVibITjXBtfA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

然后在 ternimal 中运行 mvn clean package -DskipTests=true docker:build 命令，打包项目并构建镜像，命令执行完毕可以看到

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenU7xicVINy2UAAqZJr9knCUicynKaQEC8a5zkYZW4Qpyibt2z3y4on99EA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

在 docker 窗口下，我们构建的镜像已经出现在窗口中了

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenCptBRgXXllRicu1m01DfXiasQO7uiayTaN4O0n7icHnqfEWv54t8E3HicUw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

右键点击创建一个新的容器

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNben3iaXdgJmqnh7GciazqMnZxY8QsrMkA55Atdu83kn5eveDjz9IzGaNuog/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

跳转到我们的部署配置里面，只需要像方案 1 中的一样进行配置完毕后点击 run 就 OK 了, 访问 http://localhost:8761/，同样可以看到我们的 eureka 的运行信息。docker ps 命令也显示我们的容器已经运行起来。

![img](https://mmbiz.qpic.cn/mmbiz_png/sG1icpcmhbiaA0xMSia3av6x0yo1KUnNbenxmKLBjiczEek1J8JQCnud2lG1PicRlb6f8jA7jOkvc5OErvZKjfhIXeQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 7、总结

好的，到这里我们先是在安装了 windows 版的 docker, 然后使用 IDEA 创建了一个 spring cloud 项目，并在 IDEA 中将此项目部署到了 docker 中.