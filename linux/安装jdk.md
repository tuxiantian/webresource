```shell
mkdir -p /usr/lib/jvm
tar -zxvf jdk-8u131-linux-x64.tar.gz -C /usr/lib/jvm
vim /etc/profile

```

在最前面添加：

```
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_131  
export JRE_HOME=${JAVA_HOME}/jre  
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib  
export  PATH=${JAVA_HOME}/bin:$PATH
```
执行profile文件
```
source /etc/profile
```
查看java版本
```
java -version
```

[Linux(CentOS 7)使用yum安装Redis](<https://jingyan.baidu.com/article/020278114119b71bcc9ce5bf.html>)

[centos解决bash: service: command not found 错误](<https://blog.csdn.net/qq_14847537/article/details/78400333>)

