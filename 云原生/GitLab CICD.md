使用 GitLab CI/CD 来持续集成和持续部署一个 Spring Boot 项目是一种典型且高效的工作流。通过 GitLab 提供的强大 CI/CD 能力，我们可以自动化构建、测试和部署 Spring Boot 应用。

### 目录结构

假设你的 Spring Boot 项目的基本目录结构如下：

```
my-spring-boot-project/
├── .gitlab-ci.yml
├── mvnw
├── mvnw.cmd
├── pom.xml
├── src
│   ├── main
│   └── test
```

### 步骤一：准备 GitLab CI/CD 配置文件（.gitlab-ci.yml）

在项目根目录下创建 `.gitlab-ci.yml` 文件，这是 GitLab CI/CD 的配置文件，用于定义各个阶段（stage）和步骤（job）。

### .gitlab-ci.yml 文件模板

```yaml
image: maven:3.6.3-jdk-11  # 使用 Maven 和 JDK 11 的 Docker 镜像

stages:                     # 定义阶段
  - build
  - test
  - package
  - deploy

cache:                      # 缓存配置，加快构建速度
  paths:
    - .m2/repository

before_script:              # 执行 job 之前的命令
  - export MAVEN_CLI_OPTS="--batch-mode --errors --fail-at-end --show-version"
  - export PROJECT_NAME=my-spring-boot-project
  
build:                      # 构建阶段
  stage: build
  script:
    - mvn $MAVEN_CLI_OPTS clean compile

test:                       # 测试阶段
  stage: test
  script:
    - mvn $MAVEN_CLI_OPTS test

package:                    # 打包阶段
  stage: package
  script:
    - mvn $MAVEN_CLI_OPTS package
  artifacts:
    paths:
      - target/*.jar        # 保存构建产物，供接下来使用

deploy:                     # 部署阶段
  stage: deploy
  script:
    - echo "Deploying to Production Server"
    - scp target/*.jar user@your-server:/path/to/deploy  # 使用 SCP 将 jar 文件复制到服务器
    - ssh user@your-server 'bash -s' < deploy-script.sh  # SSH 登录到服务器并运行部署脚本
  only:
    - main                  # 仅在 main 分支上执行部署
  environment:
    name: production
    url: http://your-production-url
```

### 步骤二：编写部署脚本（deploy-script.sh）

在项目根目录创建 `deploy-script.sh`，这个脚本将会在目标服务器执行，用来部署 Spring Boot 应用。

```sh
#!/bin/bash
# 停止当前运行的应用
echo "Stopping current application..."
pkill -f 'java -jar'

# 备份旧的日志文件
echo "Backing up old logs..."
if [ -f /path/to/deploy/logs/app.log ]; then
  mv /path/to/deploy/logs/app.log /path/to/deploy/logs/app.log.bak
fi

# 启动新的应用
echo "Starting new application..."
nohup java -jar /path/to/deploy/my-spring-boot-project.jar > /path/to/deploy/logs/app.log 2>&1 &

echo "Deployment completed."
```

确保脚本有执行权限，可以通过以下命令设置：

```sh
chmod +x deploy-script.sh
```

### 步骤三：配置 GitLab Runner

GitLab Runner 是在 GitLab CI/CD 管道路由操作的实例。你需要一个 GitLab Runner 来执行 `.gitlab-ci.yml` 文件定义的任务。

#### 安装 GitLab Runner

根据操作系统选择安装方式：https://docs.gitlab.com/runner/install/

例如，在 Linux 上：

```sh
# Add the official GitLab repository
curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

# Give it permission to execute
chmod +x /usr/local/bin/gitlab-runner

# Install runner as a service
gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner

# Start the service
gitlab-runner start
```

#### 注册 GitLab Runner

在项目的 GitLab 界面中，导航到 **Settings > CI/CD > Runners**，点击 **"Register a runner"** 获取注册令牌。

然后在终端执行以下命令来注册 Runner：

```sh
gitlab-runner register

# Following the prompts
# URL: https://gitlab.com/ or your self-hosted GitLab instance URL
# Token: <your-project-specific-token>
# Description: <runner-description>
# Tags: <optional-tags>
# Executor: shell or docker (recommend docker for isolation)
# Docker Image: maven:3.6.3-jdk-11
```

### 步骤四：设置 SSH 与服务器认证

为了安全地将 artifact（JAR 文件）传输到目标服务器，需要配置 SSH key 和相应认证机制。

#### 生成 SSH Key

如果没有 SSH key，可以使用以下命令生成：

```sh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

默认会生成 `id_rsa` 和 `id_rsa.pub` 两个文件。将 `id_rsa` 文件内容添加到 GitLab 项目的 **Settings > CI/CD > Variables** 中，变量名为 `SSH_PRIVATE_KEY`。

#### 添加公钥到服务器

将生成的 `id_rsa.pub` 内容添加到目标服务器的 `~/.ssh/authorized_keys` 文件中：

```sh
cat id_rsa.pub >> ~/.ssh/authorized_keys
```

### 步骤五：更新 .gitlab-ci.yml 以使用 SSH Key

更新 `.gitlab-ci.yml` 文件，使用以下代码片段将私钥添加到 CI/CD 环境中：

```yaml
before_script:
  - 'which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )'
  - eval $(ssh-agent -s)
  - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
  - mkdir -p ~/.ssh
  - chmod 700 ~/.ssh
  - ssh-keyscan your-server >> ~/.ssh/known_hosts
```

### 总结

通过以上步骤，你已经完成了使用 GitLab CI/CD 来持续集成和持续部署一个 Spring Boot 项目的配置。这个流程包括自动化构建、测试、打包和部署，并使用 SSH 和 SCP 确保安全高效的文件传输。根据实际需求，配置脚本和配置文件可能会有所不同，但基本流程是一致的。