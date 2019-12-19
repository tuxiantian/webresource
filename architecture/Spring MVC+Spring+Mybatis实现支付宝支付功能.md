### 前言

本教程详细介绍了如何使用ssm框架实现支付宝支付功能。本文章分为两大部分，分别是「支付宝测试环境代码测试」和「将支付宝支付整合到ssm框架」，详细的代码和图文解释，自己实践的时候一定仔细阅读相关文档，话不多说我们开始。

### 一、支付宝测试环境代码测试

#### 源代码

https://github.com/OUYANGSIHAI/sihai-maven-ssm-alipay

#### 1、下载电脑网站的官方demo：

下载：https://docs.open.alipay.com/270/106291/

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZrOdjZQACJCHUTFf2rINO1bpRKIUmPQedsDCmENrGPPpmdXJZib5HZ8w/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

#### 2.下载解压导入eclipse

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZnZYctt4Tp0f6rwiczSLj6hZB4MgJcYb9a0ltrewqj9kOFq68chlcE5Q/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

readme.txt请好好看一下。

只有一个Java配置类，其余都是JSP。

#### 3、配置AlipayConfig

(1) 注册蚂蚁金服开发者账号（免费，不像苹果会收取费用）

注册地址：https://open.alipay.com ，用你的支付宝账号扫码登录，完善个人信息，选择服务类型（我选的是自研）。

![img](https://mmbiz.qpic.cn/mmbiz_png/XaklVibwUKn51t9ibG4TQMnELz4G8V05Wsh9aO9OxaEd4dFTqM9vZYpt1fdqE5DZ5DHicP2fMsLjibyYaLOMgfv4Hw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

(2) 设置app_id和gatewayUrl

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZPtuicxXEHeZcXvRQkKLcPRS85M1UqwTLwVEEMVxGaXiaVFJSawKHGfmQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZV22CwCl8oBYTQasKQWll2pPWFmNTF8I7Deswj1ZOyqicL2Zfv7032zA/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

其中密钥需要自己生成，appID和支付宝网关是已经给好的，网关有dev字样，表明是用于开发测试。

(3) 设置密钥

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZZtDaKUqVwNR3bKvT93Vf4PQaysTdR6fyNQgs11hicWwicYEeQoQ1931g/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

点击“生成方法”，打开界面如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZOI6SO46mA4W2r8Rq8yVpGjTZFIRiaFxxUwxIQ6EVEl2GGAFZfpRL6gg/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

下周密钥生成工具，解压打开后，选择2048位生成密钥：

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZxKK8dJ5w7J0ysWuxRDdFIt3fET79caqlR81ApJwSiaSd88KptZpKpkw/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

如果没有设置过，此时显示文本是"设置应用公钥"，我这里是已经设置过得。

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZws3provTrCSmalwQO5zibEhickyvTZC1hqmFEH79rFhsqrt7Ymibw2qCw/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

设置方法,"打开密钥文件路径"：

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZyvYOJ0fxHCZncNmh6mQ1xj3bBrs2v7NDUuEkzNEKDcb1QunvDOge1A/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZhUBnDFodaicwib94e6CRZBQjfuWoy72wRSpYpMyZeS3PfGO5rk4Y3bPg/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

复制应用公钥2048.txt中的内容到点击"设置应用公钥"的弹出框中，保存：

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZjmibW6on6kcibKZgGOh8nA4stZpU5yHf54F3kSkTjjatOu1gbo102cGA/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

- 商户私钥（merchant_private_key）

  复制 应用私钥2048.txt 中的内容到merchant_private_key中。

- 支付宝公钥（alipay_public_key）

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZkNdLkjyTfrRlaKmmaQgJQlLgdDFXTC4na5iaOymN4uiaGD8CoqnJWiaCQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

点击如上图链接，复制弹出框里面的内容到alipay_public_key。

如果这个设置不对，结果是：支付成功，但是验签失败。

如果是正式环境，需要上传到对应的应用中：

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZv8mWs3oroY0cW54hW1vLKKNhQbXaZeUEGicV2MPtXO7hyeOdmrw6gQQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

(4) 服务器异步通知页面路径（notify_url）

如果没有改名，修改IP和端口号就可以了，我自己的如下:

```
http://localhost:8080/alipay.trade.page.pay-JAVA-UTF-8/notify_url.jsp
```

(5) 页面跳转同步通知页面的路径（return_url）

```
http://localhost:8080/alipay.trade.page.pay-JAVA-UTF-8/return_url.jsp
```

#### 4、测试运行

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZ2ZiagOZwNqeDXYAE6JS3tAz9lMRzg6okYUlHwwL9yR6qabNwM206rVQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZ1h0tMsNsiahA4icSEy7icmHuH45SE1FMGAD4ph6JYO0r7VBRK2pEQtMbQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

测试用的支付宝买家账户可以在"沙箱账"这个页面可以找到：

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZsyT4I4iaiamjia1ZNLsydds6Q9CR0aqqe8XQn0bn0Cort0c95mVRnQ9ibA/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

支付成功后，验签结果：

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZ693bSSIGsvqnGicRe1BTlqZl26JZBbRDGQWHEOibibjw7A6O88zdMPJZA/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

#### 问题解决

由于我们使用的是沙箱测试环境，测试环境和正式上线的环境的**网关**是不一样的，如果配置错误，会出现，appid错误的问题。配置如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZa27N0rib0aU9pBPIja4Up8wfibu8RibuJreDxoZoJ19tpiaZVmjpEZXlYA/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

#### 源代码下载

```
链接: https://pan.baidu.com/s/1n6GbEJiMzoGWJrSw0bb2Cg 密码: zd9e
```

### 二、将支付宝支付整合到ssm框架

#### 1、项目架构

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZq13Wexk7CiaEwf4qSx9bNKFjA728PbCGPnfnibib9QNu8tM00mld2syMg/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

- 项目架构：spring+springmvc+mybatis
- 数据库：mysql
- 部署环境：tomcat9.0
- 开发环境：jdk9、idea
- 支付：支付宝、微信

整合到ssm一样，我们需要像沙箱测试环境一样，需要修改**支付的配置信息**

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWialsFkU5bHuiaPIfqACCNFicZIabFZuA87ErVPGWcycjgIwPPyvMIrsGvgZtNgcFQ9clibyeWMYLvliaQ/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

#### 2、数据库代码

主要包括以下的数据库表：

- user：用户表
- order：支付产生的订单
- flow：流水账
- product：商品表：用于模拟购买商品。

```sql
drop table if exists user;

/*==============================================================*/
/* Table: user                                                  */
/*==============================================================*/
create table user
(
   id                   varchar(20) not null,
   username             varchar(128),
   sex                  varchar(20),
   primary key (id)
);

alter table user comment '用户表';


CREATE TABLE `flow` (
  `id` varchar(20) NOT NULL,
  `flow_num` varchar(20) DEFAULT NULL COMMENT '流水号',
  `order_num` varchar(20) DEFAULT NULL COMMENT '订单号',
  `product_id` varchar(20) DEFAULT NULL COMMENT '产品主键ID',
  `paid_amount` varchar(11) DEFAULT NULL COMMENT '支付金额',
  `paid_method` int(11) DEFAULT NULL COMMENT '支付方式
            1：支付宝
            2：微信',
  `buy_counts` int(11) DEFAULT NULL COMMENT '购买个数',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流水表';


CREATE TABLE `orders` (
  `id` varchar(20) NOT NULL,
  `order_num` varchar(20) DEFAULT NULL COMMENT '订单号',
  `order_status` varchar(20) DEFAULT NULL COMMENT '订单状态
            10：待付款
            20：已付款',
  `order_amount` varchar(11) DEFAULT NULL COMMENT '订单金额',
  `paid_amount` varchar(11) DEFAULT NULL COMMENT '实际支付金额',
  `product_id` varchar(20) DEFAULT NULL COMMENT '产品表外键ID',
  `buy_counts` int(11) DEFAULT NULL COMMENT '产品购买的个数',
  `create_time` datetime DEFAULT NULL COMMENT '订单创建时间',
  `paid_time` datetime DEFAULT NULL COMMENT '支付时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';


CREATE TABLE `product` (
  `id` varchar(20) NOT NULL,
  `name` varchar(20) DEFAULT NULL COMMENT '产品名称',
  `price` varchar(11) DEFAULT NULL COMMENT '价格',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='产品表 ';
```

**3、dao数据接口层**

这里就不介绍了，这个只包括简单的curd，可以使用`通用mapper`，或者`逆向工程`就行。以订单order为例给出:

```java
public interface OrdersMapper {
    int countByExample(OrdersExample example);

    int deleteByExample(OrdersExample example);

    int deleteByPrimaryKey(String id);

    int insert(Orders record);

    int insertSelective(Orders record);

    List<Orders> selectByExample(OrdersExample example);

    Orders selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Orders record, @Param("example") OrdersExample example);

    int updateByExample(@Param("record") Orders record, @Param("example") OrdersExample example);

    int updateByPrimaryKeySelective(Orders record);

    int updateByPrimaryKey(Orders record);
}
```

注意：源代码最后给出

**4、service层**

同上，最后在项目源代码里可见。以订单order为例给出:

```java
/**
 * 订单操作 service
 * @author ibm
 *
 */
public interface OrdersService {

    /**
     * 新增订单
     * @param order
     */
    public void saveOrder(Orders order);

    /**
     * 
     * @Title: OrdersService.java
     * @Package com.sihai.service
     * @Description: 修改叮当状态，改为 支付成功，已付款; 同时新增支付流水
     * Copyright: Copyright (c) 2017
     * Company:FURUIBOKE.SCIENCE.AND.TECHNOLOGY
     * 
     * @author sihai
     * @date 2017年8月23日 下午9:04:35
     * @version V1.0
     */
    public void updateOrderStatus(String orderId, String alpayFlowNum, String paidAmount);

    /**
     * 获取订单
     * @param orderId
     * @return
     */
    public Orders getOrderById(String orderId);

}
```



### 三、支付宝支付controller（支付流程）

**支付流程图**

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWiaTJOLMDVv4NZppafLsAGUnutooHfZAOvatHNzqjUdicFNGBdricwGYicARxMsYFxAib6QUKxrRzgTR0w/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

首先，启动项目后，输入http://localhost:8080/,会进入到商品页面，如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWiaTJOLMDVv4NZppafLsAGUnoTam6Mknx0LqcNPADKib5sqKAQOTXgCHabIicclQR5pkuoC2DfErsG8A/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

下面是页面代码

**商品页面（products.jsp）**

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWiaTJOLMDVv4NZppafLsAGUnJlThicSOSLuzibdgtakNdUn36ajWomDgz2kkukbMr2RHXQwqnfAib3nDA/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**代码实现：**

```
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  
<script src="<%=request.getContextPath() %>/static/js/jquery.min.js" type="text/javascript"></script>

<html>

    <head>

    </head>

    <body>

        <table>
            <tr>
                <td>
                    产品编号
                </td>
                <td>
                    产品名称
                </td>
                <td>
                    产品价格
                </td>
                <td>
                    操作
                </td>
            </tr>
            <c:forEach items="${pList }" var="p">
                <tr>
                    <td>
                        ${p.id }
                    </td>
                    <td>
                        ${p.name }
                    </td>
                    <td>
                        ${p.price }
                    </td>
                    <td>
                        <a href="<%=request.getContextPath() %>/alipay/goConfirm.action?productId=${p.id }">购买</a>
                    </td>
                </tr>

            </c:forEach>
        </table>

        <input type="hidden" id="hdnContextPath" name="hdnContextPath" value="<%=request.getContextPath() %>"/>
    </body>

</html>


<script type="text/javascript">

    $(document).ready(function() {

        var hdnContextPath = $("#hdnContextPath").val();


    });


</script>
```

点击上面的**购买**，进入到**订单页面**

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWiaTJOLMDVv4NZppafLsAGUnOQObdY2vdtXXEm3icQBJx08mEuzupMuiaHs4wC6TMz6LT8nmSJrjhkcA/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

填写**个数**，然后点击**生成订单**，调用如下代码

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWiaTJOLMDVv4NZppafLsAGUnYbA4uoSPDsicgmD7EkZDy8L6pdM4vZsYfxtcia8TLGLhRicD52hU6PZsw/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

根据`SID`（生成id的工具）等信息生成订单，保存到数据库。

进入到**选择支付页面**

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWiaTJOLMDVv4NZppafLsAGUntTAAWZS13vTZL7qArJ0ib2KKVbkhYleFZPgVCvPkYAC7wOLTic0iagsuw/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

调用了如下代码：

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWiaTJOLMDVv4NZppafLsAGUnpaHmaSykpFu2HHabDGPicIhI4ItASAXbPnbJ0rpj2sqjYyIJbSxZtDg/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

然后，我们选择**支付宝支付**，进入到了我们支付的页面了，大功告成！

![img](https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWiaTJOLMDVv4NZppafLsAGUnYL39cYCQZtASFELUbL4dzjMyIV3yW7WricxvYkPpnPqe9KgKbAxu7Rg/640?tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

调用了如下代码：

```java
/**
     *
     * @Title: AlipayController.java
     * @Package com.sihai.controller
     * @Description: 前往支付宝第三方网关进行支付
     * Copyright: Copyright (c) 2017
     * Company:FURUIBOKE.SCIENCE.AND.TECHNOLOGY
     *
     * @author sihai
     * @date 2017年8月23日 下午8:50:43
     * @version V1.0
     */
    @RequestMapping(value = "/goAlipay", produces = "text/html; charset=UTF-8")
    @ResponseBody
    public String goAlipay(String orderId, HttpServletRequest request, HttpServletRequest response) throws Exception {

        Orders order = orderService.getOrderById(orderId);

        Product product = productService.getProductById(order.getProductId());

        //获得初始化的AlipayClient
        AlipayClient alipayClient = new DefaultAlipayClient(AlipayConfig.gatewayUrl, AlipayConfig.app_id, AlipayConfig.merchant_private_key, "json", AlipayConfig.charset, AlipayConfig.alipay_public_key, AlipayConfig.sign_type);

        //设置请求参数
        AlipayTradePagePayRequest alipayRequest = new AlipayTradePagePayRequest();
        alipayRequest.setReturnUrl(AlipayConfig.return_url);
        alipayRequest.setNotifyUrl(AlipayConfig.notify_url);

        //商户订单号，商户网站订单系统中唯一订单号，必填
        String out_trade_no = orderId;
        //付款金额，必填
        String total_amount = order.getOrderAmount();
        //订单名称，必填
        String subject = product.getName();
        //商品描述，可空
        String body = "用户订购商品个数：" + order.getBuyCounts();

        // 该笔订单允许的最晚付款时间，逾期将关闭交易。取值范围：1m～15d。m-分钟，h-小时，d-天，1c-当天（1c-当天的情况下，无论交易何时创建，都在0点关闭）。该参数数值不接受小数点， 如 1.5h，可转换为 90m。
        String timeout_express = "1c";

        alipayRequest.setBizContent("{"out_trade_no":""+ out_trade_no +"","
                + ""total_amount":""+ total_amount +"","
                + ""subject":""+ subject +"","
                + ""body":""+ body +"","
                + ""timeout_express":""+ timeout_express +"","
                + ""product_code":"FAST_INSTANT_TRADE_PAY"}");

        //请求
        String result = alipayClient.pageExecute(alipayRequest).getBody();

        return result;
}
```

这段代码都可以在阿里支付的demo里面找到的，只需要复制过来，然后改改，整合到ssm环境即可。

上面就是将阿里支付宝支付整合到ssm的全过程了。