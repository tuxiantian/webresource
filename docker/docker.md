首先我们将使用Docker来安装Redis，注意下载Redis的完全体版本RedisMod，它是内置了所有模块的增强版Redis！
docker pull redislabs/redismod:preview

docker run -p 6379:6379 --name redismod \
-v /Users/tuxiantian/mydata/redismod/data:/data \
-d redislabs/redismod:preview

https://redis.com/redis-enterprise/redis-insight/

可视化监控
docker pull grafana/grafana

docker run -p 3000:3000 --name grafana \
-d grafana/grafana

docker pull prom/prometheus

在/Users/tuxiantian/mydata/prometheus/目录下创建Prometheus的配置文件prometheus.yml：
global:
  scrape_interval: 5s
  
docker run -p 9090:9090 --name prometheus \
-v /Users/tuxiantian/mydata/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
-d prom/prometheus

进入grafana容器并安装redis-datasource插件，安装完成后需要重启grafana服务。
docker exec -it grafana /bin/bash
grafana-cli plugins install redis-datasource

连接到redismod需要使用到它的容器IP地址，使用如下命令查看redismod容器的IP地址；
docker inspect redismod |grep IPAddress

在Grafana中配置好Redis数据源，使用admin:admin账户登录，访问地址；
http://localhost:3000/