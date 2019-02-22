---
typora-root-url: ..
---

### 从redis中获取用户信息
```java
    @Autowired
    private JedisUserService redisUserService;

    JedisUser jedisUser = redisUserService.get(ControllerHelper.getMcpToken());
```

### 统一维护配置系统错误返回码
系统错误返回码使用4位数字字符串表示，前两位表示系统模块编码，后两位表示模块下分类错误编码  
接口正确返回码因为频繁使用，使用0来表示  
示例
```java
public class ResultCode {
    //错误代码
    public static HashMap<String, String> codeMsg = new HashMap<String, String>();

    /**
     * 基础服务，包含基础模块或通用错误代码，比如参数错误，服务器异常，以0开头
     */
    public static class Base {
        public static final String SUCCESS_CODE = "0";
        public static final String ERR_PARA_ERROR = "0001";
        public static final String ERR_REQ_ERROR = "0003";
        public static final String ERR_SERVER_EXCEP = "0004";
        public static final String ERR_VALID_CODE = "0005";
        public static final String ERR_DATA_NO_FUND = "0006";
        //签名出错
        public static final String ERR_SIGN_ERROR = "0011";
        public static final String ERR_SAVE_FILE_ERROR = "0012";

        public static final String ERR_LOCATION_ERROR = "0013";
        public static final String ERR_SEND_CODE_ERROR = "0014";
        public static final String ERR_SEND_CODE_FREQUENT = "0015";
        public static final String ERR_FILE_TOO_BIG = "0016";
        public static final String ERR_IMAGE_CAN_NOT_UPLOAD = "0017";
        public static final String ERR_AREA_DATA_NOT_NEW = "0018";
        public static final String ERR_TOKEN = "0019";

        public static final String ERR_AUTH_ERROR = "0020";
        public static final String ERR_AREACODE_ERROR = "0021";

        public static void init(HashMap<String, String> codeMsg) {
            codeMsg.put(SUCCESS_CODE, "请求成功");
            codeMsg.put(ERR_PARA_ERROR, "参数不正确");

            //用于对外请求，比如手机号归属地查询
            codeMsg.put(ERR_REQ_ERROR, "请求出错，无法获取内容");
            codeMsg.put(ERR_SERVER_EXCEP, "服务器繁忙,请稍后重试");
            codeMsg.put(ERR_VALID_CODE, "验证码错误");
            codeMsg.put(ERR_DATA_NO_FUND, "查询不到数据");
            codeMsg.put(ERR_SIGN_ERROR, "请求签名出错，无法处理");
            codeMsg.put(ERR_SAVE_FILE_ERROR, "上传文件出错");
            codeMsg.put(ERR_LOCATION_ERROR, "定位信息出错");
            codeMsg.put(ERR_SEND_CODE_ERROR, "发送验证码失败");
            codeMsg.put(ERR_SEND_CODE_FREQUENT, "发送验证码太频繁");
            codeMsg.put(ERR_FILE_TOO_BIG, "上传的文件太大");
            codeMsg.put(ERR_IMAGE_CAN_NOT_UPLOAD, "认证中和认证成功的照片不能重新上传");
            codeMsg.put(ERR_AREA_DATA_NOT_NEW, "行政区划数据需要更新");
            codeMsg.put(ERR_TOKEN, "登录信息已过期，请重新登录");
            codeMsg.put(ERR_AUTH_ERROR, "登录信息已过期，请重新登录");
            codeMsg.put(ERR_AREACODE_ERROR, "城市编码有误");

        }
    }


    /**
     * 账户错误代码，会员模块，以1开头
     */
    public static class Account {

        public static final String ERR_ACCOUNT_NOT_FOUNT = "1001";
        public static final String ERR_MEMB_FREEZE = "1002";
        public static final String ERR_ACCOUNT_AUTH_NOT_FOUNT = "1003";
        public static final String ERR_ACCOUNT_AUTH_IMAGE_NOT_FOUNT = "1004";
        public static final String ERR_ACCOUNT_NOT_AUTH = "1005";
        public static final String ERR_ACCOUNT_ZHIMA_ACCREDIT = "1006";
        public static final String ERR_ACCOUNT_ZHIMA_SCORE_NOTENOUGH = "1007";
        public static final String ERR_SET_PAYPASSWD_FIRST = "1008";
        public static final String ERR_OLD_PAYPASSWD_ERROR = "1009";
        public static final String ERR_IDNUMBER_NOT_FOUND = "1010";
        public static final String ERR_IDNUMBER_NOT_MATCH = "1011";
        public static final String ERR_PAYPASSWD_EXIST = "1012";

        public static void init(HashMap<String, String> codeMsg) {
            codeMsg.put(ERR_MEMB_FREEZE, "会员已冻结");
            codeMsg.put(ERR_ACCOUNT_NOT_FOUNT, "没有用户信息");
            codeMsg.put(ERR_ACCOUNT_AUTH_NOT_FOUNT, "没有用户认证信息");
            codeMsg.put(ERR_ACCOUNT_AUTH_IMAGE_NOT_FOUNT, "没有用户认证照片信息");
            codeMsg.put(ERR_ACCOUNT_NOT_AUTH, "用户认证失败");
            codeMsg.put(ERR_ACCOUNT_ZHIMA_ACCREDIT,"芝麻信用授权失败");
            codeMsg.put(ERR_ACCOUNT_ZHIMA_SCORE_NOTENOUGH,"芝麻信用分不够，请缴纳保障金");
            codeMsg.put(ERR_SET_PAYPASSWD_FIRST, "请先设置支付密码");
            codeMsg.put(ERR_OLD_PAYPASSWD_ERROR, "原始支付密码不正确");
            codeMsg.put(ERR_IDNUMBER_NOT_FOUND, "找不到实名认证身份证号");
            codeMsg.put(ERR_IDNUMBER_NOT_MATCH, "身份证号不匹配");
            codeMsg.put(ERR_PAYPASSWD_EXIST, "支付密码已存在");

        }
    }

    static {
        //公共错误码
        Base.init(codeMsg);
        //会员模块
        Account.init(codeMsg);
    }
}

```
### 数据库类型
表示钱的概念的数据库字段类型使用decimal(16,2)  
> 这种类型的字段的默认值设为0，不能默认null，否则在查询使用的时候要做非空判断。设置默认值0就是避免做非空判断，让代码更加优雅。

表示实体状态的数据库字段类型使用tinyint  
业务表的主键类型使用bigint  
经纬度对应的数据库字段类型是decimal(10,6)  
### 实体的状态使用枚举维护
示例
```java
public enum CarStatus {
    //车辆状态@0 维保 1 正常  2 事故 3 到期下线
    maintain(0, "维保"),
    normal(1, "正常"),
    accident(2, "事故"),
    expireOffline(3, "到期下线"),
    lowPowerOffline(4, "电量过低自动下线"),
    offline(5, "离线下线");
    private String text;
    private int val;

    CarStatus(int val, String text) {
        this.text = text;
        this.val = val;
    }

    public int getVal() {
        return val;
    }

    public String getText() {
        return text;
    }

    public static String convert(int val){
        switch (val){
            case 0:return maintain.getText();
            case 1:return normal.getText();
            case 2:return accident.getText();
            case 3:return expireOffline.getText();
            case 4:return lowPowerOffline.getText();
            case 5:return offline.getText();
            default:return "";
        }
    }
}
```
若想使用枚举项的名称可以这样用：CarStatus.maintain.name()//maintain
### 全局参数配置表设计
```sql
CREATE TABLE `t_globalparam` (
  `PARAMID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '参数ID',
  `PARAMNAME` varchar(50) DEFAULT NULL COMMENT '参数名称',
  `PARAMTYPE` varchar(50) DEFAULT NULL COMMENT '参数类型',
  `PARAMVALUE` varchar(200) DEFAULT NULL COMMENT '参数值',
  `PARAMREMARK` varchar(200) DEFAULT NULL COMMENT '参数说明',
  PRIMARY KEY (`PARAMID`),
  KEY `idx_globalparam_type` (`PARAMTYPE`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='全局参数配置表'
```
数据示例
![](/images/work/t_globalparam.png)
### 全局字典表设计
```sql
CREATE TABLE `t_globaldict` (
  `DICTID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '字典ID',
  `PARENTID` int(11) unsigned DEFAULT NULL COMMENT '父级字典ID',
  `DICTNAME` varchar(50) DEFAULT NULL COMMENT '字典名称',
  `DICTTYPE` varchar(20) DEFAULT NULL COMMENT '字典类型',
  `DICTVALUE` varchar(200) DEFAULT NULL COMMENT '字典值',
  `SORTINDEX` smallint(6) unsigned DEFAULT NULL COMMENT '排序号',
  `DICTREMARK` varchar(200) DEFAULT NULL COMMENT '字典说明',
  PRIMARY KEY (`DICTID`),
  KEY `idx_globaldict_type` (`DICTTYPE`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='全局字典表'
```
数据示例
![](/images/work/t_globaldict.png)
