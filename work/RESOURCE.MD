### 从redis中获取用户信息
```
    @Autowired
    private JedisUserService redisUserService;

    JedisUser jedisUser = redisUserService.get(ControllerHelper.getMcpToken());
```
### 来驾分页查询模板代码
#### 使用代码生成器生成的默认findPage方法
```
public McpPageResult queryLockDetailsPage(Integer pageNo,
                                          Integer pageSize,
                                          String sortFiledName,String sortType,Integer remainBattery,Integer status){
        MapBean params=new MapBean("sortFiledName",sortFiledName,"sortType",sortType,"remainBattery",remainBattery,"status", status);
        Page<Lock> page = ControllerHelper.getPage();
        page.setPageNo(pageNo);
        page.setPageSize(pageSize);
        page = this.find(page,params);

        List<Lock> result = page.getResult();

        return McpPageResult.success("查询成功",ParkingSpaceLockTrans.trans(result),pageNo,pageSize,page.getTotalPages(),page.getTotalCount());
}
```
#### 自定义分页代码示例
CarsMapper.java
```
public interface CarsMapper extends EntityMapper<Cars> {
    List<MapBean> myCarsPage(MapBean params);

    Long myCarsPageCount(MapBean params);
}
```
**需要注意的地方mapper接口中要声明自定义分页的查询方法，且要定义入参MapBean，即便carsMapper.xml中的自定义分页查询sql片段不需要入参，
否则会报找不到方法的异常。**  

carsMapper.xml
```
<select id="myCarsPage" resultType="mb">
    <include refid="sys.begin"/>
    SELECT C.CARID carId,C.LPN lpn,C.VIN vin,C.ENGINENUM engineNum,C.COLOR color,C.STATUS status,M.CARMODELNAME carModelName,
    M.SEAT seat,M.MILEAGE mileage,D.GLATITUDE glatitude,D.GLONGITUDE glongitude,D.TOTALMILEAGE totalMileage,A.REMARK remark FROM t_cars C
    INNER JOIN `t_carmodels` M ON M.CARMODELID=C.CARMODELID
    INNER JOIN `t_lastdevicedata` D ON D.DEVICEID=C.DEVICEID
    LEFT OUTER JOIN T_AREA A ON C.AREACODE = A.AREACODE
    WHERE 1=1
    <if test="orgNo != null">
        AND C.ORGNO = #{orgNo}
    </if>
    <include refid="sys.end"/>
</select>

<select id="myCarsPageCount" resultType="long">
    SELECT COUNT(1) FROM T_CARS C
    WHERE 1=1
    <if test="orgNo != null">
        AND C.ORGNO = #{orgNo}
    </if>
</select>
```
CarsService.java
```
public McpPageResult myCarsPage(Integer pageNo, Integer pageSize, String orgNo){
        if (pageNo == null || pageNo < 1) {
            return McpPageResult.fail(ERR_PARA_ERROR, null);
        }
        MapBean params = new MapBean("orgNo", org.apache.commons.lang3.StringUtils.isBlank(orgNo) ? null : orgNo);
        Page<MapBean> page = ControllerHelper.getPage();
        page.setPageNo(pageNo);
        page.setPageSize(pageSize);
        page = this.findPageSqlName("myCarsPage", page, params);

        List<MapBean> list = page.getResult();
        if (page.getTotalCount()>0){
            for (MapBean mapBean:list
                 ) {
                mapBean.put("statusDesc",CarStatus.convert(mapBean.getInt("status")));
            }
        }
        return McpPageResult.success("查询成功", list, page.getPageNo(), pageSize, page.getTotalPages(), page.getTotalCount());
}
```
### 统一维护配置系统错误返回码
系统错误返回码使用4位数字字符串表示，前两位表示系统模块编码，后两位表示模块下分类错误编码  
接口正确返回码因为频繁使用，使用0来表示  
示例
```
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
```
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
```
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
```
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
### 自定义异常处理
无论在Controller层发生任何未知的异常，给前端用户返回的都是服务器繁忙，但是开发人员需要查明异常原因。
```
package com.laijia.core.web;

import com.laijia.core.entity.Result;
import com.laijia.core.entity.ResultCode;
import com.laijia.util.JsonUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class BussinessHandlerExceptionResolver implements HandlerExceptionResolver {

    private static final Logger logger = LoggerFactory.getLogger(BussinessHandlerExceptionResolver.class);

    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        try {
            if (ex != null) {
                logger.info("request error :", ex);
                String fullContentType = "application/json" + ";charset=" + "UTF-8";
                response.setContentType(fullContentType);
                response.getWriter().write(JsonUtil.toJson(Result.code(ResultCode.Base.ERR_SERVER_EXCEP, null)));
                response.getWriter().flush();
                response.getWriter().close();
            }
        } catch (Exception e) {
            logger.info("request error :", ex);
        }
        return null;
    }

}

```
### 最有用的数据结构
```
package com.laijia.core.entity;

import com.laijia.util.DataUtils;
import com.laijia.util.JsonUtil;
import org.apache.commons.lang3.StringUtils;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;


public class MapBean extends HashMap<String, Object> implements Entity {

    private static final long serialVersionUID = 5819387600888005124L;

    public MapBean() {
        super();
    }

    /**
     * 传入0到n对象，创建MapBean
     *
     * @param args
     */
    public MapBean(Object... args) {
        super();
        puts(args);
    }

    /**
     * 当你确切知道返回类型时，才能使用
     *
     * @param key 鍵值
     * @return
     */
    public <X> X get(String key) {
        try {
            X value = (X) super.get(key);
            return value;
        } catch (ClassCastException e) {
            throw new ClassCastException("MapBean中存放的类型，与返回类型不匹配.");
        }

    }

    /**
     * 获得Integer类型的值
     *
     * @param key 键值
     * @return 值
     */
    public Integer getInt(Object key) {
        Object value = get(key);
        if (value != null) {
            if (value instanceof BigDecimal) {
                return ((BigDecimal) value).intValue();
            } else if (value instanceof Long) {
                return ((Long) value).intValue();
            } else if (value instanceof Double) {
                return ((Double) value).intValue();
            } else if (value instanceof String) {
                return Integer.parseInt((String) value);
            }
            return (Integer) value;
        } else {
            return null;
        }
    }

    /**
     * 获得Integer类型的值
     *
     * @param key 键值
     * @return 值
     */
    public Long[] getLongArray(String key) {
        if (StringUtils.isBlank(key)) {
            return null;
        }
        Object value = get(key);
        if (value == null) {
            value = get(key.toLowerCase());
        }
        if (value instanceof String[]) {
            return toLongs((String[]) value);
        } else if (value instanceof String) {
            String[] idsArray = StringUtils.split((String) value, ",");
            return toLongs((String[]) idsArray);
        } else {
            return null;
        }
    }

    /**
     * 根据指定的值返回long型数组，用于删除
     *
     * @param values
     * @return
     */
    private Long[] toLongs(String[] values) {
        if (values != null) {
            List<Long> ret = new LinkedList<Long>();
            for (int i = 0; i < values.length; i++) {
                Long t = DataUtils.toLong(values[i]);
                if (t != null) {
                    ret.add(t);
                }
            }
            return ret.toArray(new Long[ret.size()]);
        }
        return null;
    }

    /**
     * 获得Byte类型的值
     *
     * @param key 键值
     * @return 值
     */
    public Byte getByte(Object key) {
        Integer i = getInt(key);
        return i == null ? null : i.byteValue();
    }

    /**
     * 获得Long类型的值
     *
     * @param key 键值
     * @return 值
     */
    public Long getLong(Object key) {
        Object value = get(key);
        if (value != null) {
            if (value instanceof Long) {
                return (Long) this.get(key);
            } else if (value instanceof BigDecimal) {
                return ((BigDecimal) value).longValue();
            } else if (value instanceof String) {
                return Long.parseLong((String) value);
            }
        }
        return (Long) value;
    }

    /**
     * 获得Double类型的值
     *
     * @param key 键值
     * @return 值
     */
    public Double getDouble(Object key) {
        Object value = get(key);
        if (value != null) {
            if (value instanceof Double) {
                return ((Double) value);
            } else if (value instanceof BigDecimal) {
                return ((BigDecimal) value).doubleValue();
            } else if (value instanceof String) {
                return Double.parseDouble(((String) value).trim());
            }
        }
        return (Double) value;
    }

    /**
     * 获得String类型的值
     *
     * @param key 键值
     * @return 值
     */
    public String getString(Object key) {
        Object v = get(key);
        if (!(v instanceof String) && v != null) {
            return v.toString();
        }
        return (String) v;
    }

    /**
     * 获得Byte类型的值
     *
     * @param key        键值
     * @param defaultVal 无值是的默认值
     * @return 值
     */
    public Byte getByte(Object key, byte defaultVal) {
        Byte b = getByte(key);
        return b == null ? defaultVal : b;
    }

    /**
     * 获得int类型的值
     *
     * @param key        键值
     * @param defaultVal 无值是的默认值
     * @return 值
     */
    public int getInt(Object key, int defaultVal) {
        Integer i = getInt(key);
        return i == null ? defaultVal : i;
    }

    public boolean getBoolean(Object key) {
        return getBoolean(key, false);
    }

    /**
     * 返回boolean类型值
     *
     * @param key
     * @param defaultVal
     * @return
     */
    public boolean getBoolean(Object key, boolean defaultVal) {
        Object v = get(key);
        if (v != null) {
            if (v instanceof Boolean) {
                return (Boolean) v;
            } else if (v instanceof String) {
                return "true".equals((String) v) || "yes".equals(v);
            } else if (v instanceof Number) {
                return ((Number) v).intValue() == 0;
            }
        } else {
            return defaultVal;
        }
        return false;
    }

    /**
     * 获得long类型的值
     *
     * @param key        键值
     * @param defaultVal 无值是的默认值
     * @return 值
     */
    public long getLong(Object key, int defaultVal) {
        Long i = getLong(key);
        return i == null ? defaultVal : i;
    }

    /**
     * 获得String类型的值
     *
     * @param key        键值
     * @param defaultVal 无值是的默认值
     * @return 值
     */
    public String getString(Object key, String defaultVal) {
        String value = getString(key);
        return value == null ? defaultVal : value;
    }

    /**
     * 一次添加多个对象到Map中
     *
     * @param args
     */
    public void puts(Object... args) {
        for (int i = 1; i < args.length; i += 2) {
            put(String.valueOf(args[i - 1]), args[i]);
        }
    }

    /**
     * 将Map转成json格式的字符串
     *
     * @return
     */
    public String toJson() {
        return JsonUtil.toJson(this);
    }

    /**
     * 将Map格式的JSON字符串值，转成Map集合
     *
     * @param keys
     * @return
     */
    public String toJson(Object... keys) {
        Map<Object, Object> map = new HashMap<Object, Object>();
        for (int i = 0; i < keys.length; i++) {
            if (this.containsKey(keys[i]))
                map.put(keys[i], this.get(keys[i]));
        }
        return JsonUtil.toJson(map);
    }

    public static MapBean toMapBean(Map map) {
        if (map != null) {
            MapBean r = new MapBean();
            for (Object key : map.keySet()) {
                r.put(String.valueOf(key), map.get(key));
            }
            return r;
        }
        return null;
    }

    public static MapBean toMapBean(Serializable e) {
        if (e != null) {
            String v = JsonUtil.toJson(e);
            return JsonUtil.toObject(v, MapBean.class);
        }
        return null;
    }

    public Map<String, String> toHashMap() {
        HashMap<String, String> maps = new HashMap<>();
        for (String s : this.keySet()) {
            maps.put(s, this.getString(s));
        }
        return maps;
    }

    @Override
    public Serializable getId() {
        return this.getString("id");
    }
}
```
