### 触发远程构建:触发远程构建
Build after other projects are built:在其他项目触发的时候触发，里面有分为三种情况，也就是其他项目构建成功、失败、或者不稳定（这个不稳定我这里还木有理解）时候触发项目  
Poll SCM：定时检查源码变更（根据SCM软件的版本号），如果有更新就checkout最新code下来，然后执行构建动作。我的配置如下：  
*/5 * * * * （每5分钟检查一次源码变化）  
Build periodically：周期进行项目构建（它不care源码是否发生变化），我的配置如下：  
0 2 * * * （每天2:00 必须build一次源码）  
那么是不是有这个就很强大了，不需要我们手动的点击构建了，因为我之前在Microsoft的时候我们的项目都是半夜开始工作，到第二天早晨的时候开发查看结果即可。  	
### Deploy to container Plugin
> 将项目war部署到tomcat，需在tomcat-users.xml中配置用户
```
<role rolename="manager"/>
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>

<role rolename="manager-status"/>
<role rolename="admin"/>
<user username="admin" password="admin" roles="admin,manager,manager-script,manager-gui,manager-jmx,manager-status"/>
```
### Global Tool Configuration
> 在此选项中设置jdk、git、maven等
### jekins发布过程中遇到的问题及解决办法
当项目的pom文件中引入新的jar包时，jekins从私服仓库中取不到jar会导致编译失败  
错误示例如下：  
> [ERROR] Failed to execute goal on project Business: Could not resolve dependencies for project com.laijia:Business:war:1.0-SNAPSHOT: Failure to find org.apache.activemq:activemq-client:jar:5.9.0 in http://192.168.0.254:8089/nexus/content/groups/public/ was cached in the local repository, resolution will not be reattempted until the update interval of xingtu has elapsed or updates are forced -> [Help 1]  

可行的解决办法如下:  
修改/usr/local/maven/conf/setting.xml中的镜像，注释私服镜像，使用阿里巴巴镜像下载jar,使用jekins的立即构建触发下载jar  
去/root/.jenkins/workspace/laijia/.repository/org/apache/activemq/activemq-client/5.9.0目录将后缀为.lastupdated的文件删除  
再放开/usr/local/maven/conf/setting.xml注释私服镜像  
#### 私服不能启动导致发布失败
cd /home/nexus/nexus-2.14.0-01/bin  
./nexus start  