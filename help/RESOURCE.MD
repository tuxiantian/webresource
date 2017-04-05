### 查看端口被哪个进程占用并结束该进程
```
netstat -aon|findstr "8888"
tasklist|findstr "5536"
taskkill /f /t /im javaw.exe
```
### 安装私有jar包到maven仓库示例如下：
```
mvn install:install-file -Dfile=E:/webfront/ckeditor-java-core-3.5.3/ckeditor-java-core-3.5.3.jar -DgroupId=com.ckeditor -DartifactId=ckeditor-java-core -Dversion=3.6.6.2 -Dpackaging=jar  -DgeneratePom=true -DcreateChecksum=true
<dependency>
	<groupId>com.ckeditor</groupId>
	<artifactId>ckeditor-java-core</artifactId>
	<version>3.6.6.2</version>
</dependency>
```