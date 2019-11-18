maven中的mirrors节点

maven2的setting.xml大家都知道，里面有个mirrors节点，用来配置镜像URL。
mirrors可以配置多个mirror，每个mirror有id,name,url,mirrorOf属性，id是唯一标识一个mirror就不多说了，name貌似没多大用，相当于描述，url是官方的库地址，mirrorOf代表了一个镜像的替代位置，例如central就表示代替官方的中央库。

我本以为镜像库是一个分库的概念，就是说当a.jar在第一个mirror中不存在的时候，maven会去第二个mirror中查询下载。但事实却不是这样，当第一个mirror中不存在a.jar的时候，并不会去第二个mirror中查找，甚至于，maven根本不会去其他的mirror地址查询。

后来终于知道，maven的mirror是镜像，而不是“分库”，只有当前一个mirror无法连接的时候，才会去找后一个，类似于备份和容灾。
还有，mirror也不是按settings.xml中写的那样的顺序来查询的。
所谓的第一个并不一定是最上面的那个。

当有id为B,A,C的顺序的mirror在mirrors节点中，maven会根据字母排序来指定第一个，所以不管怎么排列，一定会找到A这个mirror来进行查找，当A无法连接，出现意外的情况下，才会去B查询。

```
     <mirror>
            <id>alimaven</id>
            <name>aliyun maven</name>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
            <mirrorOf>central</mirrorOf>
    </mirror>
    <mirror>
            <id>mvnrepository</id>
            <name>mvnrepository Central</name>
            <url>http://mvnrepository.com/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
        <mirror>
            <id>ibiblio</id>
            <name>ibiblio Central</name>
            <url>http://mirrors.ibiblio.org/maven2/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
        <mirror>
            <id>CN</id>
            <name>OSChina Central</name>
            <url>http://maven.oschina.net/content/groups/public/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
```

