## Spring事务
### 资源链接
[透彻的掌握 Spring 中@transactional 的使用](https://www.ibm.com/developerworks/cn/java/j-master-spring-transactional-use/index.html)
### spring事务使用方式
默认spring事务只在发生未被捕获的runtimeexcetpion时才回滚。 
spring aop  异常捕获原理：被拦截的方法需显式抛出异常，并不能经任何处理，这样aop代理才能捕获到方法的异常，才能进行回滚，默认情况下aop只捕获runtimeexception的异常，但可以通过配置来捕获特定的异常并回滚  。

换句话说在service的方法中不使用try catch 或者在catch中最后加上`throw new runtimeexcetpion（）`，这样程序异常时才能被aop捕获进而回滚
解决方案： 

  - 方案1.service层处理事务，那么service中的方法中不做异常捕获，或者在catch语句中最后增加`throw new RuntimeException()`语句，以便让aop捕获异常再去回滚，并且在service上层（webservice客户端，view层action）要继续捕获这个异常并处理。
  - 方案2.在service层方法的catch语句中增加：`TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();`语句，手动回滚，这样上层就无需去处理异常。

### Spring事务管理方式
Spring 支持两种类型的事务管理：  
编程式事务管理  
声明式事务管理  
### spring编程事务示例

```java
@Transactional(rollbackFor = Exception.class)
public int method(Object obj) {
    try {
        doInsert(obj);
        return 1;
    } catch(Exception e) {
        e.printStackTrace();
        // 加入下行代码手动回滚
        // @Transactional 为方法加上事务,try catch 捕获到异常手动回滚事务
        if (TransactionAspectSupport.currentTransactionStatus().isNewTransaction()) {
            // 第一次开启事务遇到异常则回滚
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        } else {
            // 嵌套的事务,当前方法被另一个加了 @Transactional 标注的方法调用
            // 抛出异常告诉上一个事务,让上一个事务判断是否回滚
            // 这样的优点是: 在调用者那边不用根据当前方法返回值来判断是否回滚
            throw e;
        }
    }
    return 0;
}
```
## spring编程事务实战
业务场景
> 会员支付代缴费用完成后，产生分公司的资金账户流水。要求产生分公司的资金账户流水出现异常回滚事务而不影响上层的事务。

### 方式一

```java
@Service
@Transactional
public class AccountExtFeeService extends AbstractService<AccountExtFee> {

    private static final Logger logger = LoggerFactory.getLogger(AccountExtFeeService.class);
    public void updatePayExtFeeResult(PayStatus status, String tradeNo,
                                      String otherOrderNum, String payUser, Double totalFee) {
        if (status == null || StringUtils.isBlank(tradeNo)) {
            throw new ServiceException("信息不足，无法更新会员套餐支付记录");
        }
        List<AccountExtFeePay> extFeePayList = accountExtFeePayService.find(new MapBean("tradeNo", tradeNo));
        if (extFeePayList != null && extFeePayList.size() == 1) {
            AccountExtFeePay extFeePay = extFeePayList.get(0);
            if (extFeePay.getPayAmount().doubleValue() != totalFee.doubleValue()) {
                throw new ServiceException("回调金额与支付金额不相同. tradeNO:" + tradeNo + ", " + "totalFee:" + totalFee);
            }
            AccountExtFeePay newExtFeePay = new AccountExtFeePay();
            newExtFeePay.setPayId(extFeePay.getPayId());
            newExtFeePay.setPayTime(new Date());
            newExtFeePay.setBuyUser(payUser);
            newExtFeePay.setOtherOrderNum(otherOrderNum);
            newExtFeePay.setPayStatus(status.getVal());
            accountExtFeePayService.saveOrUpdate(newExtFeePay);

            if (status == PayStatus.success) {
                List<AccountExtFee> list = this.mapper.find(new MapBean("payId", extFeePay.getPayId()));
                String orgNo = null;
                if (list != null && list.size() > 0) {
                    for (AccountExtFee accountExtFee : list) {
                        AccountExtFee newExtFee = new AccountExtFee();
                        newExtFee.setFeeId(accountExtFee.getFeeId());
                        newExtFee.setStatus(ExtFeeStatus.payed.getVal());
                        this.saveOrUpdate(newExtFee);
                        orgNo=accountExtFee.getOrgNo();
                    }
                }
                //解锁保证金
                depositPayService.operateExtfeeLock(extFeePay.getUserId(), LockStatus.unlocked);
                companyService.allocationIncome(AllocationType.extFee,extFeePay.getPayId(),orgNo,extFeePay.getPayAmount(),null);
            }
        } else {
            throw new ServiceException("会员待缴费用支付记录不存在");
        }
    }
}
@Service
@Transactional
public class CompanyService {
    private static final Logger logger= LoggerFactory.getLogger(CompanyService.class);
    @Transactional(propagation = REQUIRES_NEW)
    public void allocationIncome(AllocationType allocationType, Long refid, String orgNo,BigDecimal allocationAmount,Integer couponId){
        logger.info("allocationIncome parameters allocationType:{},refid:{},orgNo:{}",allocationType.name(),refid,orgNo);
        try {
            switch (allocationType){
                case coupon:
                    coupon(refid, orgNo,allocationAmount,couponId);
                    break;
                case amount:
                    amount(refid,orgNo,allocationAmount);
                    break;
                case extFee:
                    extFee(refid,orgNo,allocationAmount);
                    break;
                case violation:
                    violation(refid,orgNo,allocationAmount);
                    break;
                case subsidy:
                    subsidy(refid,orgNo);
                    break;
                case withDraw:
                    withDraw(refid,orgNo);
                    break;
                default:;
            }
        } catch (Exception e) {
            logger.error(String.format("allocationIncome fail allocationType:%s refid:%s orgNo:%s ",allocationType.name(),refid,orgNo),e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
    }

    private void extFee(Long refid, String orgNo,BigDecimal allocationAmount) {
        CustAccount companyCustAccount = custAccountService.findCustAccountByOrgNo(orgNo);
        BigDecimal companyAmount = allocationAmount;
        CustAccountIncome companyIncome = new CustAccountIncome(companyCustAccount.getCustId(), companyCustAccount.getCustName(), BussType.extFee.getVal(), companyAmount, refid, CanWithDraw.no.getVal());
        custAccountIncomeService.saveOrUpdate(companyIncome);
       if (true){
           throw new RuntimeException("test");
       }
        CustAccountSeq companySeq = new CustAccountSeq(companyCustAccount.getCustId(), companyCustAccount.getCustName(), SeqFlag.in.getVal(), ChangeType.extFee.getVal(), companyCustAccount.getAmount(), companyCustAccount.getAmount().add(companyAmount), companyAmount, companyIncome.getSn());
        custAccountSeqService.saveOrUpdate(companySeq);

        companyCustAccount.setSumAmount(companyCustAccount.getSumAmount().add(companyAmount));
        companyCustAccount.setAmount(companyCustAccount.getAmount().add(companyAmount));
        custAccountService.saveOrUpdate(companyCustAccount);
    }
}
```
allocationIncome的传播行为可以设置为REQUIRES_NEW或NESTED都可以实现本方法的事务回滚。

### 方式二

```java
@Service
@Transactional
public class AccountExtFeeService extends AbstractService<AccountExtFee> {

    private static final Logger logger = LoggerFactory.getLogger(AccountExtFeeService.class);
    public void updatePayExtFeeResult(PayStatus status, String tradeNo,
                                      String otherOrderNum, String payUser, Double totalFee) {
        if (status == null || StringUtils.isBlank(tradeNo)) {
            throw new ServiceException("信息不足，无法更新会员套餐支付记录");
        }
        List<AccountExtFeePay> extFeePayList = accountExtFeePayService.find(new MapBean("tradeNo", tradeNo));
        if (extFeePayList != null && extFeePayList.size() == 1) {
            AccountExtFeePay extFeePay = extFeePayList.get(0);
            if (extFeePay.getPayAmount().doubleValue() != totalFee.doubleValue()) {
                throw new ServiceException("回调金额与支付金额不相同. tradeNO:" + tradeNo + ", " + "totalFee:" + totalFee);
            }
            AccountExtFeePay newExtFeePay = new AccountExtFeePay();
            newExtFeePay.setPayId(extFeePay.getPayId());
            newExtFeePay.setPayTime(new Date());
            newExtFeePay.setBuyUser(payUser);
            newExtFeePay.setOtherOrderNum(otherOrderNum);
            newExtFeePay.setPayStatus(status.getVal());
            accountExtFeePayService.saveOrUpdate(newExtFeePay);

            if (status == PayStatus.success) {
                List<AccountExtFee> list = this.mapper.find(new MapBean("payId", extFeePay.getPayId()));
                String orgNo = null;
                if (list != null && list.size() > 0) {
                    for (AccountExtFee accountExtFee : list) {
                        AccountExtFee newExtFee = new AccountExtFee();
                        newExtFee.setFeeId(accountExtFee.getFeeId());
                        newExtFee.setStatus(ExtFeeStatus.payed.getVal());
                        this.saveOrUpdate(newExtFee);
                        orgNo=accountExtFee.getOrgNo();
                    }
                }
                //解锁保证金
                depositPayService.operateExtfeeLock(extFeePay.getUserId(), LockStatus.unlocked);
                try{
                    companyService.allocationIncome(AllocationType.extFee,extFeePay.getPayId(),orgNo,extFeePay.getPayAmount(),null);
                }catch(Exception e){}
                
            }
        } else {
            throw new ServiceException("会员待缴费用支付记录不存在");
        }
    }
}
@Service
@Transactional
public class CompanyService {
    private static final Logger logger= LoggerFactory.getLogger(CompanyService.class);
    @Transactional(propagation = NESTED)
    public void allocationIncome(AllocationType allocationType, Long refid, String orgNo,BigDecimal allocationAmount,Integer couponId){
        logger.info("allocationIncome parameters allocationType:{},refid:{},orgNo:{}",allocationType.name(),refid,orgNo);
       
        switch (allocationType){
            case coupon:
                coupon(refid, orgNo,allocationAmount,couponId);
                break;
            case amount:
                amount(refid,orgNo,allocationAmount);
                break;
            case extFee:
                extFee(refid,orgNo,allocationAmount);
                break;
            case violation:
                violation(refid,orgNo,allocationAmount);
                break;
            case subsidy:
                subsidy(refid,orgNo);
                break;
            case withDraw:
                withDraw(refid,orgNo);
                break;
            default:;
        }
        
    }
    
    private void extFee(Long refid, String orgNo,BigDecimal allocationAmount) {
        CustAccount companyCustAccount = custAccountService.findCustAccountByOrgNo(orgNo);
        BigDecimal companyAmount = allocationAmount;
        CustAccountIncome companyIncome = new CustAccountIncome(companyCustAccount.getCustId(), companyCustAccount.getCustName(), BussType.extFee.getVal(), companyAmount, refid, CanWithDraw.no.getVal());
        custAccountIncomeService.saveOrUpdate(companyIncome);
       if (true){
           throw new RuntimeException("test");
       }
        CustAccountSeq companySeq = new CustAccountSeq(companyCustAccount.getCustId(), companyCustAccount.getCustName(), SeqFlag.in.getVal(), ChangeType.extFee.getVal(), companyCustAccount.getAmount(), companyCustAccount.getAmount().add(companyAmount), companyAmount, companyIncome.getSn());
        custAccountSeqService.saveOrUpdate(companySeq);

        companyCustAccount.setSumAmount(companyCustAccount.getSumAmount().add(companyAmount));
        companyCustAccount.setAmount(companyCustAccount.getAmount().add(companyAmount));
        custAccountService.saveOrUpdate(companyCustAccount);
    }
}
```
**在方式二中若不在allocationIncome方法上面加事务注解，即便外层调用的地方加了try-catch,那么外层的事务也会回滚。**

异常信息如下：

```
logback [http-nio-6002-exec-3] ERROR o.a.c.c.C.[.[.[.[dispatcherServlet] - Servlet.service() for servlet [dispatcherServlet] in context with path [] threw exception [Request processing failed; nested exception is org.springframework.transaction.UnexpectedRollbackException: Transaction rolled back because it has been marked as rollback-only] with root cause
org.springframework.transaction.UnexpectedRollbackException: Transaction rolled back because it has been marked as rollback-only
```