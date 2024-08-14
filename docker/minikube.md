

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-arm64
sudo install minikube-darwin-arm64 /usr/local/bin/minikube

minikube start

在浏览器中打开 Kubernetes 仪表板（Dashboard）：
minikube dashboard

如果你不想打开 Web 浏览器，请使用 --url 标志运行显示板命令以得到 URL：
minikube dashboard --url
