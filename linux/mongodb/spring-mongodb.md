## 配置

```yml
spring:
  data:
    mongodb:
      host: 192.168.130.133
      port: 27017
      database: dygasms
```

## 查询

```java
    private SmsTemplate getSmsTemplateByModuleCode(String moduleCode) {
        Query query=new Query();
        Criteria criteria = new Criteria();
        criteria.and("moduleCode").is(moduleCode);
        criteria.and("delFlag").is(0);
        query.addCriteria(criteria);
        return mongoTemplate.findOne(query , SmsTemplate.class);
    }
```

## 分页查询

```java
public PageBean<SmsTemplateVO> selectSmsTemplateList(SmsTemplateDTO smsTemplateDTO) {
        Query query = new Query();
        Criteria criteria = new Criteria();
        //排序
        List<Order> orders = new ArrayList<Order>();
        orders.add(new Order(Direction.DESC, "createTime"));
        Sort sort = new Sort(orders);
        if (StringUtils.isNotBlank(smsTemplateDTO.getTemplateName())){
            criteria.and("templateName").is(smsTemplateDTO.getTemplateName());
        }
        query.addCriteria(criteria);
        Pageable pageable = PageRequest.of(smsTemplateDTO.getPageNum() - 1, smsTemplateDTO.getPageSize(), sort);
        List<SmsTemplate> resolveRules = mongoTemplate.find(query.with(pageable), SmsTemplate.class);
        List<SmsTemplateVO> smsTemplateDTOS = new ArrayList<SmsTemplateVO>();
        if(resolveRules != null && resolveRules.size() > 0) {
            smsTemplateDTOS = JSONObject.parseArray(JSONObject.toJSONString(resolveRules), SmsTemplateVO.class);
        }
        PageBean<SmsTemplateVO> pageBean = new PageBean<>();
        pageBean.setList(smsTemplateDTOS);
        pageBean.setPageNum(smsTemplateDTO.getPageNum());
        pageBean.setPageSize(smsTemplateDTO.getPageSize());
        pageBean.setTotal(mongoTemplate.count(query, SmsTemplate.class));
        return pageBean;
    }
```

```java
@Data
public class PageBean<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 总记录数
     */
    private long total;
    /**
     * 结果集
     */
    private List<T> list;
    /**
     * 第几页
     */
    private int pageNum;
    /**
     * 每页记录数
     */
    private int pageSize;

}
```



## 保存

```java
@Data
@Document(collection="dygasms_template")
public class SmsTemplate implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 模板id */
	private String templateId;
	/** 模块的code */
	private String moduleCode;
	/** 模板名称 */
	private String templateName;
	/** 模板内容 */
	private String content;
	/** 模版CODE */
	private String templateCode;
	/** 签名 */
	private String templateSign;
	/** 多久发送一次(秒) */
	private Integer sendTimeInterval;
	/** 每天发送次数 */
	private Integer sendFrequency;
	/** 失效时间(秒) */
	private Integer invalidTime;
	/** 删除标志(0代表存在，2代表删除) */
	private Integer delFlag;
	/** 创建者 */
	private String createBy;
	/** 更新者 */
	private String updateBy;
	/** 创建时间 */
	private Date createTime;
	/** 更新时间 */
	private Date updateTime;

}
```

```java
SmsTemplate smsTemplate=new SmsTemplate();
mongoTemplate.save(smsTemplate);
```

## 修改

```java
public long updateSmsTemplate(SmsTemplate smsTemplate) {
        logger.info("com.deyi.sms.service.impl.SmsTemplateServiceImpl.updateSmsTemplate 修改模板参数{}", JSONObject.toJSONString(smsTemplate));
        Query query = new Query(Criteria.where("templateId").is(smsTemplate.getTemplateId()));
        Update update = new Update();
        Field[] fields = smsTemplate.getClass().getDeclaredFields();
        for (Field field : fields) {
            field.setAccessible(true);
            try {
                if (!"serialVersionUID".equals(field.getName())) {
                    if (field.get(smsTemplate) != null && StringUtils.isNotBlank(field.get(smsTemplate).toString())) {
                        update.set(field.getName(),field.get(smsTemplate));
                    }
                }
            } catch (IllegalAccessException e) {
                e.printStackTrace();
                logger.info("com.deyi.sms.service.impl.SmsTemplateServiceImpl.updateSmsTemplate 异常{}", e);
            }
        }
        UpdateResult updateResult = mongoTemplate.updateFirst(query, update, SmsTemplate.class);
        logger.info("com.deyi.sms.service.impl.SmsTemplateServiceImpl.updateSmsTemplate 修改结果updateResult{}", JSONObject.toJSONString(updateResult));
        return updateResult.getMatchedCount();
}
```

