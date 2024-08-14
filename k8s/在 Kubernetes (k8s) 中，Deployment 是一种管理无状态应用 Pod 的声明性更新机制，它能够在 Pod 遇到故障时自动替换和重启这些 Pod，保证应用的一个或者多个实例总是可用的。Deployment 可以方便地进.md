在 Kubernetes (k8s) 中，Deployment 是一种管理无状态应用 Pod 的声明性更新机制，它能够在 Pod 遇到故障时自动替换和重启这些 Pod，保证应用的一个或者多个实例总是可用的。Deployment 可以方便地进行应用的升级、回滚、扩缩等操作。以下是如何在 Kubernetes 中创建和管理 Deployment 的基本步骤。

**1. 创建一个 Deployment**

首先，你需要编写一个 YAML 文件来定义 Deployment。这个文件会描述 Deployment 的期望状态，包括所需的副本数、Pod 模板、标签选择器等信息。例如，创建一个名为 `nginx-deployment.yaml` 的文件，内容如下：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3  # 指定要运行的副本数量
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2  # 指定容器使用的镜像
        ports:
        - containerPort: 80  # 容器需要暴露的端口号
```

在这个示例中，我们创建了一个名为 `nginx-deployment` 的 Deployment，它应该在集群中运行三个 nginx 镜像的副本。

**2. 应用 Deployment**

使用以下命令将 Deployment 部署到 Kubernetes 集群：

```bash
kubectl apply -f nginx-deployment.yaml
```

此命令将通知 Kubernetes 创建或者更新一个名为 `nginx-deployment` 的 Deployment。

**3. 查看 Deployment 状态**

部署后，可以使用以下命令来获取 Deployment 的状态信息：

```bash
kubectl get deployments
```

输出显示了 Deployment 的状态和一些相关信息，例如副本数量、可用数量等。

**4. 更新 Deployment**

如果需要更新 Deployment（比如更新应用的镜像版本），只需更改 YAML 文件中的配置，并重新应用该文件。例如，更新 nginx 的镜像版本到 `1.16.1`：

```yaml
...
      containers:
      - name: nginx
        image: nginx:1.16.1  # 更新镜像的版本
...
```

然后再次应用更改：

```bash
kubectl apply -f nginx-deployment.yaml
```

Kubernetes 将根据更新调整 Pod，进行滚动更新，无需停机。

**5. 扩缩 Deployment**

要更改运行的 Pod 副本的数量，可以更新 YAML 文件中的 `replicas` 字段，或者直接在命令行中执行命令：

```bash
kubectl scale deployment nginx-deployment --replicas=5
```

这个命令将 `nginx-deployment` 的 Pod 副本数设置为 5。

**6. 回滚 Deployment**

如果更新后的版本有问题，可以使用 Deployment 的回滚功能恢复到旧版本：

```bash
kubectl rollout undo deployment nginx-deployment
```

**7. 删除 Deployment**

当你不再需要某个 Deployment 时，可以使用以下命令将其删除：

```bash
kubectl delete deployment nginx-deployment
```

Deployment 是 Kubernetes 用于管理应用部署的强大工具，它抽象了 Pod 和 ReplicaSet 层面的细节，使得应用的发布和管理更加直观和便利。以上步骤是 Deployment 最基本的操作，更高级的使用包括管理 Deployment 的生命周期、使用 ready probes 保证服务就绪、设置资源限制和使用策略控制更新过程等。