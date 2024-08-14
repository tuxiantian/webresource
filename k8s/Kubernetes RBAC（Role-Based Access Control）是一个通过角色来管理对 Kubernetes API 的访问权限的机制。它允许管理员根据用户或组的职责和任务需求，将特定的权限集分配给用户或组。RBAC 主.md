Kubernetes RBAC（Role-Based Access Control）是一个通过角色来管理对 Kubernetes API 的访问权限的机制。它允许管理员根据用户或组的职责和任务需求，将特定的权限集分配给用户或组。RBAC 主要涉及以下资源类型：

1. **Role 和 ClusterRole**：
   - **Role**：定义在命名空间范围内的权限，即它只能用来授权访问同一个命名空间内的资源。
   - **ClusterRole**：定义在集群范围内的权限，可以用来授权访问集群内任何命名空间的资源，也可以授予不属于某个命名空间的资源（如节点）的访问权限。

这些角色包含了一系列可以在 Kubernetes API 上执行的动作，如创建、获取、更新、删除资源的权限。

2. **RoleBinding 和 ClusterRoleBinding**：
   - **RoleBinding**：将 Role 中定义的权限分配给用户或用户组。它只作用于单个命名空间中。
   - **ClusterRoleBinding**：将 ClusterRole 中定义的权限分配给用户或用户组，可以是集群全局的权限或者是特定命名空间的权限。

RBAC 授权决定是基于组合的，意味着用户的最终权限是其所有角色权限的并集。

**示例：**

以下是一个 RBAC 使用的简单示例。

1. 创建一个 `Role` 来允许读取（"get"）和列出（"list"）Pods:

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

这个 `Role` 称为 "pod-reader"，允许对命名空间 "default" 下的 Pod 资源进行 "get" 和 "list" 操作。

2. 通过创建一个 `RoleBinding` 来将 "pod-reader" 角色分配给一个具体用户：

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: jane   # 这里假设是一个名为 "jane" 的用户
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader  # 这里引用上面创建的 Role
  apiGroup: rbac.authorization.k8s.io
```

该 `RoleBinding` 确保用户 "jane" 在 "default" 命名空间中具有读取 Pod 的权限。

在 Kubernetes 集群中设置 RBAC 的时候，应该以最小权限原则作为指导，只授予用户或应用程序完成其任务所需要的最少权限，以减少安全风险。此外，还可以通过使用 Kubernetes 的认证代理（Authenticator）或使用认证 API Server 标志实现用户认证来进一步加强安全性。这使得 Kubernetes 管理变得既灵活又安全。