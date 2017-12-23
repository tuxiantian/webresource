## 非自增主键的保存更新问题
![](/images/work/question/question1.png)  
表结构信息如下
```sql
CREATE TABLE `t_busline_map_data` (
  `line_id` int(10) unsigned NOT NULL COMMENT '线路id',
  `map_data` varchar(20000) DEFAULT NULL COMMENT '地图数据',
  PRIMARY KEY (`line_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='线路地图数据'
```
重写服务类的保存更新方法，根据主键值查询，非空即更新  
![](/images/work/solution11.png)  
删除insert元素的useGeneratedKeys和keyProperty属性，将主键改为手动插入  
![](/images/work/solution12.png)  

## HttpMessageNotReadableException: Could not read JSON: java.lang.NumberFormatException: empty String;

> 2017-07-19 09:04:48,498 [http-bio-8080-exec-2] WARN  [org.springframework.web.servlet.mvc.support.DefaultHandlerExceptionResolver] - Failed to read HTTP message: org.springframework.http.converter.HttpMessageNotReadableException: Could not read JSON: java.lang.NumberFormatException: empty String; nested exception is com.google.gson.JsonSyntaxException: java.lang.NumberFormatException: empty String

![](/images/work/question/question1.png)

解决方法：前端传值为数值型，若没有值，则传null或不传。

## postman使用

![](/images/work/question/question2.png)  

## Zookeeper连接不上导致web服务无法正常启动
catalina.out日志中出现
```
08-24 17:46:39.055 [localhost-startStop-1-SendThread(192.168.0.254:2181)] org.apache.zookeeper.ClientCnxnSocketNIO org.apache.zookeeper.ClientCnxnSocketNIO.cleanup(ClientCnxnSocketNIO.java:203) DEBUG - Ignoring exception during shutdown input
java.net.SocketException: Socket is not connected
	at sun.nio.ch.Net.translateToSocketException(Net.java:123)
	at sun.nio.ch.Net.translateException(Net.java:157)
	at sun.nio.ch.Net.translateException(Net.java:163)
	at sun.nio.ch.SocketAdaptor.shutdownInput(SocketAdaptor.java:401)
	at org.apache.zookeeper.ClientCnxnSocketNIO.cleanup(ClientCnxnSocketNIO.java:200)
	at org.apache.zookeeper.ClientCnxn$SendThread.cleanup(ClientCnxn.java:1185)
	at org.apache.zookeeper.ClientCnxn$SendThread.run(ClientCnxn.java:1110)
Caused by: java.nio.channels.NotYetConnectedException
	at sun.nio.ch.SocketChannelImpl.shutdownInput(SocketChannelImpl.java:782)
	at sun.nio.ch.SocketAdaptor.shutdownInput(SocketAdaptor.java:399)
	... 3 more
```
wget http://localhost:8083/mongodb/index.html
服务器无响应输出
本地启动正常，项目发到服务器上面就出现了上面陈述的问题。
最后检查发现是spring-dubbo.xml文件中的zookeeper连接地址配置错误。地址改正后，服务正常启动了，上面两个问题就都不存在了。这真是一个诡异的问题。
## MySQL两个无符号的数字想减出现问题
次卡的打包次数-剩余次数=次卡使用次数。但是次卡参加活动后，剩余次数大于打包次数，想减之后会报错。
```sql
 SELECT a.`NICKNAME` nickName,a.`MOBILE` mobile,c.`card_name` cardName,ar.`AREANAME` areaName,pc.`pay_time` payTime,
ac.`card_end_date` cardEndDate,ac.card_num cardNum,ac.`surplus_times` surplusTimes,(ac.`card_num`-ac.`surplus_times`) usedTimes
	from `t_account_paycard` pc
	inner join `t_card` c on pc.`card_id`=c.`card_id`
	inner join t_account a on a.`USERID`=pc.`userid`
	inner join `t_account_card` ac on ac.`card_id`=pc.`card_id` and pc.`userid`=ac.`userid`
	left join t_area ar on ar.`AREACODE`=c.`areacode`
	where 1=1
```
![](/images/work/question/question3.png)  
表结构如下：
![](/images/work/question/question4.png)  
## 磁盘空间不足导致的问题
查看磁盘空间的使用情况：df -h
```
[root@iZ2zecl4i8oy1rs7r025p8Z tomcat_mongo]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1        40G   33G  4.8G  88% /
tmpfs           3.9G     0  3.9G   0% /dev/shm

```
当时有一个bug需要修复，管控数据统计的合计和按日统计是两段查询语句，它们的查询条件不一致导致统计的结果不一致。mapper文件是可以直接覆盖生效的，我在本地改过mapper文件后直接上传覆盖生产环境的mapper文件，正常情况下，这样做是没有问题的，但是由于磁盘空间已满，ftp上传文件失败直接导致生产环境的mapper文件被清空了，紧接着就是服务崩溃了。当时我还以为是那个目录对于tomcat用户没有写权限呢？去看了一下是有写权限的。然后我根据以往经验判断是mapper文件加载失败导致服务崩溃，然后重启服务发现服务还是启动失败了。此刻我就慌了，压力很大。生产环境处于崩溃状态，我是没有时间排查问题的。我的应激反应就是执行发布脚本将上次发布的内容重新发布一次，这是服务正常可用了。

监控磁盘空间使用情况真的是很有必要啊。
## 前后端传值规范
以优惠券为例说明前后端传值接收值的规范。  
若使用@RequestParam接收传参，对应的页面是表单传值，表单传值‘’表示全国，若数据库约定null值表示全国，接口方面要做处理把''转为null。  
若使用@RequestBody接收传参，对应的页面是json对象传值，页面可以直接将参数赋值为null表示全国。  
优惠券的查询比较特殊，对于既支持查询全国又支持查询全部的情况可以这样处理：  
前端传0表示查询全国，传''表示全部。  
后台接口做如下处理：  
方式一  
```sql
<if test="areaCode !=null and areaCode !='' and areaCode !='0'.toString()">AND c.CITYCODE=#{areaCode}</if>
<if test="areaCode =='0'.toString()">AND c.CITYCODE IS NULL </if>
```
方式二  
```java
if ("0".equals(areaCode)) {
	paras.put("areaCode4QG", true);
} else {
	paras.put("areaCode", areaCode);
}
```

```sql
<if test="areaCode != null and areaCode!= ''">
	AND T.CITYCODE=#{areaCode}
</if>
<if test="areaCode4QG">
	AND T.CITYCODE IS NULL
</if>
```
目前页面上的查询条件一般都是@RequestParam接收传参,查询全部传‘’，接口方面要判断处理。处理方式如下：
方式一  
```java
 MapBean params = new MapBean("keyword", StringUtils.isBlank(keyword) ? null : keyword);
```
方式二  
```sql
<if test="areaCode != null and areaCode!= ''">
	AND T.CITYCODE=#{areaCode}
</if>
```
## 接口使用@RequestBody保存数据要注意的问题
```
@ResponseBody
@RequestMapping(value = "save", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
public McpResult save(@RequestBody TripCard tripCard){
//...
}

public class TripCard extends AbsBaseEntity  {
	//次卡id
	private Integer cardId;
	//0  下线  1 上线
	private Integer status;
	public TripCard(Integer cardId, Integer status) {
		this.cardId = cardId;
		this.status = status;
	}
}
```
像上面那样使用@RequestBody保存数据时自定义了构造函数而没有添加空的构造函数，那么前端调用接口时就会报400错误。所以在自定义实体类的构造函数时必须保留空的构造函数。
## 联合主键的findBy查询问题
联合主键的表结构
```sql
CREATE TABLE `t_account_trip_card` (
  `userid` char(32) NOT NULL COMMENT '会员id',
  `card_id` int(11) NOT NULL COMMENT '次卡id',
  `card_name` varchar(30) DEFAULT NULL COMMENT '次卡名称',
  `area_code` varchar(30) DEFAULT NULL COMMENT '运营地区代码',
  `use_time` int(11) DEFAULT NULL COMMENT '用车时长',
  `surplus_times` int(11) DEFAULT NULL COMMENT '剩余次卡张数',
  `card_sum_times` int(11) DEFAULT NULL COMMENT '次卡累计使用张数',
  PRIMARY KEY (`userid`,`card_id`),
  KEY `idx_account_numcard_areacode` (`area_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员次卡'
```
使用默认的findBy方法出现的问题
![](/images/work/question/findOne.png)
默认的findBy方法
```
public T findBy(MapBean params) {
	if (params != null) {
		return this.getMapper().findOne(params);
	}
	return null;
}
```
在业务service中重写findBy查询方法
```java
public AccountTripCard findBy(String userId,Integer cardId){
	return this.find(new MapBean("userId", userId, "cardId",cardId)).stream().findFirst().orElse(null);
}
```
## 使用eventBus的功能单元测试
在单元测试方法执行结束时，整个应用也就结束了，这时event的订阅方法还没有执行完成，所以测试达不到期望的结果，这时必须使测试方法阻塞一段时间。
```java
@Service
@Lazy(false)
public class GiveCouponToVipAccountJob {
    @Autowired
    private AccountExtService accountExtService;
    @Autowired
    private EventBus eventBus;
    
    public void execute(){
        List<String> redVipAccountList = accountExtService.findVipAccount(UserType.redVip.getVal());
        for (String redVipAccount:redVipAccountList
        ) {
            List<RulePara> ruleParaList = Lists.newArrayList(new RulePara(Rules.redVipAccount,new MapBean("userType",UserType.redVip.getVal())));
            eventBus.post(new ActivityEvent(redVipAccount,ruleParaList, CouponSource.zq,null));
        }

        List<String> lyVipAccountList = accountExtService.findVipAccount(UserType.lyVip.getVal());
        for (String lyVipAccount:lyVipAccountList){
            List<RulePara> ruleParaList = Lists.newArrayList(new RulePara(Rules.lyVipAccount,new MapBean("userType",UserType.lyVip.getVal())));
            eventBus.post(new ActivityEvent(lyVipAccount,ruleParaList,CouponSource.zq,null));
        }
    }
}

public class GiveCouponToVipAccountJobTest extends BaseTest{
    @Autowired
    private GiveCouponToVipAccountJob giveCouponToVipAccountJob;
    
    @Test
    @Rollback(false)
    public void execute(){
        giveCouponToVipAccountJob.execute();
        try {
            TimeUnit.SECONDS.sleep(20);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```