在 Kubernetes (k8s) 中，Service 是一种定义一组逻辑 Pod 的访问策略和代理方式的抽象，它使得外部或内部的服务可以稳定地访问这一组 Pod，即使后者的实例发生变化。Service 通过标签选择器来确定它代理流量的 Pod，通过定义 Service，我们就能保持对一组动态变化的 Pods 的稳定访问。

以下是一个 Service 的构建和使用的基本过程：

**1. 创建一个 Service**

首先，你需要一个运行中的应用（由一组 Pod 组成），这些 Pod 应具有标签，以便 Service 可以通过标签选择器选择它们。例如，假设你的 Pod 都具有标签 `app=MyApp`。

接下来，你可以创建一个名为 `my-service.yaml` 的文件，其中包含以下 Service 定义：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service  # Service 名称
spec:
  selector:
    app: MyApp      # 选择所有标签为 app=MyApp 的 Pod
  ports:
    - protocol: TCP
      port: 80      # Service 对外暴露的端口
      targetPort: 9376  # Pod 上的目标端口
```

**2. 应用 Service 配置**

运行以下命令应用你的 Service 配置文件：

```bash
kubectl apply -f my-service.yaml
```

**3. 访问 Service**

- 如果是集群内部的其他应用需要访问此 Service，它们可以通过 `<service-name>.<namespace>.svc.cluster.local` 的形式进行连接，其中 `service-name` 是 Service 的名称，`namespace` 是该 Service 所在的命名空间。（如果是 default 命名空间，则通常可以省略 `<namespace>.` 部分）
- 如果需要将 Service 暴露给集群外部访问，则通常需要配置一个 Service 的类型为 `NodePort` 或 `LoadBalancer`：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort     # 或 LoadBalancer
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

当设置 `type: NodePort` 时，Kubernetes 会在所有 Node 上随机分配一个范围在 30000-32767 的端口，并将其转发到 Service 上的端口。

而 `type: LoadBalancer` 通常用在云提供的 Kubernetes 服务中，这时，云服务会自动提供一个外部负载均衡器并将流量路由到 Service。

**注意事项**

- Service 类型：除了 `NodePort` 和 `LoadBalancer` 外，还有 `ClusterIP` （默认类型，仅对集群内部可见）和 `ExternalName`（提供能解析到外部 DNS 名称的服务）。
- 当你创建 Service 时，它同时创建了一个 DNS 记录。假设你的 Service 名称为 `my-service` 在 `default` 命名空间中，集群内部的 Pod 可以直接通过 `http://my-service/` 访问到这个 Service。
- 当使用 `type: LoadBalancer` 时，你可能还需要配置附加的云提供商特定注解，以允许设置负载均衡器的额外选项或参数。

这些基本步骤展示了如何在 Kubernetes 中定义和使用 Service，这是 Kubernetes 网络的核心概念之一。

下面是一个使用 `type: LoadBalancer` 的 Kubernetes Service 的例子。这个 Service 设定将会创建一个外部负载均衡器（取决于你的 Kubernetes 环境，如果是云服务提供商，如 AWS、GCP 或 Azure，他们会自动为你提供并配置负载均衡器）。

首先，假设我们有一组运行 Web 应用的 Pod，这些 Pod 通过标签 `app: web` 来标识。

以下是用于创建名为 `web-service` 的 Service 的 YAML 配置：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web  # 这会将服务连接到所有标签为 app: web 的 Pod
  ports:
    - protocol: TCP
      port: 80       # Service 对外暴露的端口（外部请求使用的端口）
      targetPort: 8080  # Pod 上的目标端口（Pod 内应用监听的端口）
  type: LoadBalancer  # 指定 Service 类型为 LoadBalancer
```

当你通过 `kubectl apply -f service.yaml` 应用这段配置，Kubernetes 会在后台调用云服务的 API 为这个 Service 创建一个负载均衡器。这个负载均衡器会有一个外部 IP 地址，可以从集群外部网络访问。

在云提供商环境中，一旦配置被应用，你可以通过检查 Service 状态来获取分配给 Service 的外部 IP 地址：

```bash
kubectl get svc web-service
```

你会看到如下的输出，其中 `EXTERNAL-IP` 是分配给此 Service 的负载均衡器的公共 IP 地址：

```
NAME          TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
web-service   LoadBalancer   10.100.200.10   203.0.113.25     80:32111/TCP   78s
```

集群外的用户可以使用这个外部 IP 地址通过端口 80 访问你的 Web 应用。

更进一步，你可能需要根据云服务提供商给 `LoadBalancer` 类型的 Service 配置额外的属性。例如，在 AWS 上，可以添加注解来指定负载均衡器的类型：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"  # 使用 AWS 网络负载均衡器(NLB)
spec:
  selector:
    app: web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
```

在上述例子中，通过添加注解 `service.beta.kubernetes.io/aws-load-balancer-type: "nlb"` 我们指示 AWS 创建一个网络负载均衡器（NLB）而不是默认的普通负载均衡器。在 GCP、Azure 或其他云服务中可能有不同的注解来控制行为。

请牢记配置外部负载均衡器通常会产生费用，并且你需要确保恰当的安全规则（如安全组或网络访问控制列表）已经正确设置，以允许合适的流量经过。

在 Kubernetes 中，`ClusterIP` 和 `ExternalName` 是两种不同类型的服务（Service），它们提供不同的网络抽象来访问应用和外部资源。以下是每种服务类型的使用示例。

### type: ClusterIP 示例

`ClusterIP` 是 Kubernetes Service 的默认类型，它为服务在集群内部提供一个虚拟的IP地址，使得集群内部的其他组件可以通过这个 IP 地址达到服务的负载均衡和服务发现的目的。

以下是一个 `ClusterIP` 类型的 Service 的 YAML 配置示例：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-internal-service
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: ClusterIP  # 指定 Service 类型为 ClusterIP
```

这个 Service 通过 `app: my-app` 选择器来选择 Pod，对外暴露 80 端口，并将请求转发到 Pod 上相应的 8080 端口。`ClusterIP` 默认是由 Kubernetes 随机分配的，如需指定可以使用 `clusterIP: <IP_address>` 参数。

### type: ExternalName 示例

`ExternalName` 类型的 Service 允许将服务定义为对应外部服务的引用。通过设置 `ExternalName`，这个 Service 实质上成为了所指定外部服务域名的别名。

以下是一个 `ExternalName` 类型的 Service 的 YAML 配置示例：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-external-service
spec:
  type: ExternalName
  externalName: my.database.example.com  # 外部域名
```

这个 Service 没有选择器和端口定义，因为它是一个指向外部服务的引用。当集群内的 Pod 尝试连接 `my-external-service.default.svc.cluster.local` (假定它部署在 default 命名空间)，请求会被解析到 `my.database.example.com`。

这种服务类型对于应对某些集群迁移场景很有用，当先将服务托管在集群外部，然后逐渐移动到集群内部时，你只需要将服务类型从 `ExternalName` 改为 `ClusterIP` 或者其他类型，而无需更改依赖该服务的应用配置。

在使用 `ExternalName` 服务时，需要注意的是，该服务不是通过 IP 地址而是通过 CNAME 记录在 DNS 中解析的，所以它只适用于基于 DNS 名称进行通讯的应用。此外，服务通常不受 Kubernetes 平台的网络策略和安全组控制，所以需要确保外部服务的域名是可解析且安全的。