---
typora-root-url: ..\..
---

## 进入docker容器的方法

> **docker exec**
> **使用方法**：`docker exec -it [container name][command]`
> **适用范围**：docker宿主机内部登录容器
> **优点**：快捷方便
> **缺点**：外部终端无法使用这种方法登录容器
> **使用参数介绍**：
> -i, --interactive               Keep STDIN open even if not attached ——交互 
> -t, --tty                        Allocate a pseudo-TTY——分配伪终端 一般情况会使用-it这个组合命令，如果单用也只能单独使用-i命令 
>
> -i 参数不会产生伪终端，但是会有正确的返回
> ![20160818114129537](/images/linux/docker/20160818114129537.png)

