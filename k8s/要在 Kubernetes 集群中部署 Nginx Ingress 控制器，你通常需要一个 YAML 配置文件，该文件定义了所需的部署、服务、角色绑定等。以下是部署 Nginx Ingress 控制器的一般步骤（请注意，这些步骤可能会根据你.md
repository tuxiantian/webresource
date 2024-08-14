要在 Kubernetes 集群中部署 Nginx Ingress 控制器，你通常需要一个 YAML 配置文件，该文件定义了所需的部署、服务、角色绑定等。以下是部署 Nginx Ingress 控制器的一般步骤（请注意，这些步骤可能会根据你使用的 Kubernetes 环境和 Nginx Ingress 控制器版本而变化）：

**1. 使用 Helm 安装**

Helm 是一个 Kubernetes 的包管理工具，它使得安装和管理 Kubernetes 应用变得更容易。Nginx Ingress 控制器在 Helm 的公共仓库中有自己的 chart，因此我们可以很容易地使用 Helm 来部署它。

如果你尚未安装 Helm，请遵循其[官方安装指南](https://helm.sh/docs/intro/install/)进行安装。

安装好 Helm 之后，添加 Nginx Ingress 控制器的 Helm 仓库并更新：

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

使用 Helm 安装 Nginx Ingress 控制器：

```bash
helm install my-nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
```

这里 `my-nginx-ingress` 是自定义的发布名称，你可以将其替换为你选择的任何名称。`--namespace ingress-nginx` 指定了控制器安装在 `ingress-nginx` 命名空间下，如果这个命名空间不存在，`--create-namespace` 命令会创建它。

**2. 使用官方 YAML 文件手动部署**

如果你不想使用 Helm，你可以直接使用 Nginx 提供的 YAML 文件来部署 Ingress 控制器。以下是部署命令：

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

这将为大多数基于云的 Kubernetes 环境自动创建所需的配置。如果你在裸机环境中，可能需要使用不同的配置。访问 Nginx Ingress 控制器的 [GitHub 页面](https://github.com/kubernetes/ingress-nginx) 查看其他环境的安装指南。

**完成部署后，验证 Nginx Ingress 控制器是否在运行：**

```bash
kubectl get pods --namespace ingress-nginx
```

你应该会看到名为 `ingress-nginx-controller-xxxx` 的 Pod 正在运行。如果 Pod 处于 `Running` 状态，并且 READY 列中的第一个数字等于第二个数字，那么 Ingress 控制器应该已经成功启动。

请记住，如果你在内部网络或者裸机环境中，你可能还需要配置额外的网络规则来确保 Ingress 控制器对外部流量可见。在云环境中，该部署通常会自动为 Ingress 控制器创建一个外部可访问的 LoadBalancer 类型的服务。

确保遵循最新的官方文档，因为随着版本的更新，安装步骤可能略有不同。

在 Kubernetes（K8s）中，Ingress 是一个 API 对象，它管理外部用户访问集群中服务的 HTTP 和 HTTPS 请求。Ingress 可以提供负载均衡、SSL 终止和基于名称的虚拟托管。

在开始使用 Ingress 前，需要有一个 Ingress 控制器的实例在集群中运行。常见的 Ingress 控制器实现包括 Nginx Ingress 控制器、HAProxy Ingress、Traefik 等。如果没有合适的控制器，Ingress 资源仅是存在，但并不会有任何路由行为发生。

**部署 Ingress 控制器**

这取决于你的 Kubernetes 环境。例如，如果你在使用 minikube，可以简单地启用 Ingress 控制器：

```bash
minikube addons enable ingress
```

对于其他环境，你需要遵循相应 Ingress 控制器的安装指南来部署一个。

**定义 Ingress 资源**

一旦有了 Ingress 控制器，你就可以创建 Ingress 资源了。Ingress 资源定义了如何路由外部请求。

1. 首先，确保你的服务已经正确运行。创建如下服务：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-svc
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

这个服务名为 `my-app-svc`，它将一个服务端口（80）映射到了现有应用 Pods 的端口（8080）上。

2. 创建一个简单的 Ingress 资源文件 `my-ingress.yaml`：

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: my-app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-svc
            port:
              number: 80
```

这个 Ingress 定义了路由规则，表示所有前往 `my-app.example.com` 的 HTTP 请求应该被转发到 `my-app-svc` 服务的 80 端口。

3. 使用 `kubectl` 应用这个 Ingress：

```bash
kubectl apply -f my-ingress.yaml
```

**注意事项**

- 在绑定特定的主机名之前，确保 DNS 正确解析到了 Ingress 控制器的公共 IP 地址。
- 你可能需要为 Ingress 配置 TLS，以便能够处理HTTPS请求。这通常需要在 Ingress 资源中定义一个或多个 `tls` 部分，并指定你的证书和密钥。

**添加 TLS 支持**

为了让 Ingress 支持 HTTPS，你需要准备好 TLS 证书，并在 Ingress 资源中进行设置。

1. 首先，创建一个包含 TLS 证书和密钥的 Kubernetes Secret：

```bash
kubectl create secret tls my-app-tls --cert=path/to/tls.cert --key=path/to/tls.key
```

2. 修改你的 Ingress 资源文件，包含 TLS 信息：

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  tls:
  - hosts:
    - my-app.example.com
    secretName: my-app-tls
  rules:
  - host: my-app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-svc
            port:
              number: 80
```

在这里，我们向 Ingress 资源添加了 `tls` 部分，并引用了之前创建的 Secret `my-app-tls`。

这样配置了 Ingress 后，你的应用现在应该可以通过 HTTP 和 HTTPS 处理外部流量了。使用 Ingress 将使你能够更方便地对外暴露服务，同时它也支持更复杂的路由策略，如基于路径的路由、基于主机的路由等。

Ingress 允许你基于请求的 HTTP 路径和主机名（通常是域名）将外部流量路由到集群内的相应服务。以下是基于路径和基于主机路由的 Ingress 的使用方法示例：

**基于路径的路由 (Path-Based Routing)**

基于路径的路由允许你根据请求的 URL 路径将流量路由到不同的后端服务。以下是一个 Ingress 资源的示例，它根据请求路径转发流量到不同的服务：

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  namespace: default
spec:
  rules:
  - http:
      paths:
      - path: /app1
        pathType: Prefix
        backend:
          service:
            name: app1-service
            port:
              number: 80
      - path: /app2
        pathType: Prefix
        backend:
          service:
            name: app2-service
            port:
              number: 80
```

在这个例子中，有两个服务：`app1-service` 和 `app2-service`。请求路径以 `/app1` 开头的请求将被路由到 `app1-service`，路径以 `/app2` 开头的请求将被路由到 `app2-service`。

**基于主机的路由 (Host-Based Routing)**

基于主机的路由允许你根据请求的主机名（即域名）将流量路由到不同的后端服务。以下是一个 Ingress 资源的示例，它根据请求的主机名转发流量到相应的服务：

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  namespace: default
spec:
  rules:
  - host: app1.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app1-service
            port:
              number: 80
  - host: app2.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app2-service
            port:
              number: 80
```

在此例中，以 `app1.example.com` 发起的请求将被路由到 `app1-service`，而 `app2.example.com` 的请求则被路由到 `app2-service`。

**组合使用基于主机和基于路径的路由**

基于路径和基于主机的路由可以结合起来使用，以提供更加灵活的路由配置：

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: combined-ingress
  namespace: default
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /app1
        pathType: Prefix
        backend:
          service:
            name: app1-service
            port:
              number: 80
      - path: /app2
        pathType: Prefix
        backend:
          service:
            name: app2-service
            port:
              number: 80
```

在这个组合配置中，若请求以 `example.com/app1` 开头，它将被路由到 `app1-service`；若请求以 `example.com/app2` 开头，则被路由到 `app2-service`。

要使用上述任一配置，请确保域名能正确解析到运行 Ingress 控制器的服务的 IP 地址上，通常是通过 DNS 记录实现。此外，还要确认对应服务（如 `app1-service` 或 `app2-service`）已定义并在集群中运行。之后，将 Ingress 资源应用到你的集群：

```bash
kubectl apply -f ingress.yaml
```
其中 `ingress.yaml` 是包含你的 Ingress 配置的文件。

通过这种方式，Ingress 控制器根据定义的规则将流量路由到不同的服务，从而可以轻松地管理对集群内服务的访问。