<!-- TOC -->

- [使用eventBus的功能单元测试](#使用eventbus的功能单元测试)
- [生成城市合伙人收益测试](#生成城市合伙人收益测试)

<!-- /TOC -->

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
## 生成城市合伙人收益测试
需求
> 每天生成城市合伙人的收益，产生资金变动流水，修改车辆的累计收益和城市合伙人的余额和累计收益。

首先准备好测试的sql语句
```sql
#清理测试数据
DELETE FROM t_partner;
DELETE FROM `t_partner_income`;
DELETE FROM `t_partner_seq`;
DELETE FROM `t_partner_car`;
#造数据
INSERT INTO `t_partner` (`partner_id`, `area_code`, `partner_name`, `sex`, `partner_mobile`, `partner_card_id`, `home_address`, `wx_openid`, `bank_no`, `bank_name`, `bank_account_no`, `bind_date`, `invest_num`, `income`, `amount`, `withdraw_amount`, `create_user`, `create_time`) 
	VALUES('1','370700','涂贤田','男','15039686014',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1','0.00','0.00','0.00',NULL,'2018-04-04 11:25:08');
	
INSERT INTO `t_partner_car` (`car_id`, `partner_id`, `lpn`, `vin`, `car_model`, `income_start_date`, `income_end_date`, `sum_income`) 
	VALUES('1','1','1',NULL,NULL,'2018-04-10','2018-04-29','0.00');
#验证程序执行的结果    
SELECT * FROM `t_partner`;
SELECT * FROM t_partner_car;
SELECT * FROM t_partner_income;
SELECT * FROM t_partner_seq;
```
梳理测试用例
1. 当前日期在投车日期里
2. 是否重复生成收益
3. 投车后第4年的收益情况

