### 为什么要使用https代替已有的http？

#### 先说一下http的隐患

- http是明文传输的，内容很容易被监听，窃听风险
- 不验证通信方的身份，可以伪装身份，冒充风险
- 无法证明报文的完整性，可能被篡改，篡改风险

这些隐患可不只是说说而已，你遇到过运营商劫持吗？三天两头给你插一段广告还有其他很恶心的操作，防不胜防。正是因为这些隐患才成了某些黑心商的沃土。

#### 再来看一下国际趋势

为鼓励https部署

- Google 已调整搜索引擎算法，让采用https 的网站在搜索中排名更靠前
- Chrome 浏览器已把http协议的网站标记为不安全网站
- 苹果要求2017年App Store中的所有应用都必须使用https加密连接；
- 微信小程序要求必须使用https
- 新一代的 HTTP/2 协议的支持需以https为基础。

基于这些原因，https部署势在必行。

### https特点

https是http的安全升级版本，在http的基础上添加[SSL/TLS](https://link.juejin.im?target=https%3A%2F%2Fzh.wikipedia.org%2Fwiki%2F%25E5%2582%25B3%25E8%25BC%25B8%25E5%25B1%25A4%25E5%25AE%2589%25E5%2585%25A8%25E6%2580%25A7%25E5%258D%2594%25E5%25AE%259A)层。大致说一下原理：基本思路就是采用公钥加密，客户端向服务端索要公钥，收到公钥后使用它加密信息，服务器收到信息后使用与公钥配套的私钥解密。

上一张图补充说明原理 

![img](https://user-gold-cdn.xitu.io/2018/7/4/164638d71a77c806?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

#### 这样做的目的：

- 传输内容加密，保证数据传输安全
- 身份验证，防止冒充
- 数据完整性校验，防止内容被第三方冒充或者篡改

### https部署过程

#### 带你了解证书

1）为什么需要证书？

对于请求方，它如何能确定所得公钥是从目标主机那里发布的，而不是中间人发布给它的？或者怎么去确定目标主机是可信任的，或者目标主机背后的企业或机构靠谱？这时候，我们需要一个权威、值得信赖机构(一般是由政府审核并授权的机构)来统一对外发放主机机构的公钥，来解决信任问题(中心化)

2）如何申请证书？

用户首先生成特定密钥对，并将公钥和部分必要信息传送给认证中心。认证中心在核实信息合法后，执行一些必要的步骤，以确信请求是用户提交的（通常是提供认证文件，你需要下载并将文件放在域名特定目录下）。然后，认证中心将发给用户一个数字证书

3）证书内容信息是什么？

- 证书颁发机构的名称
- 证书本身的数字签名
- 证书持有者公钥+部分信息
- 证书签名用到的Hash算法

**证书由独立的证书发行机构发布，每种证书的可信任级别不同**，有点类似树的结构。这点一定要注意，在部署https要保证证书链完整（向上可以追溯到CA根证书，否则某些情况下会提示网站不安全，https部署失败）

4）证书有效性校验

浏览器内部会内置CA根证书，使用CA证书校验配置的证书

- 证书颁发的机构错误----危险证书
- 证书颁发的机构正确，根据CA根证书的公钥对证书摘要进行解密，解密失败----危险证书；解密成功得到摘要A，然后再根据签名的Hash算法计算出证书的摘要B，对比A与B，若相等则正常，若不相等则是被篡改过的----危险证书。
- 证书过期----危险证书。

#### 证书申请

下面我将使用证书颁发机构[ssls](https://link.juejin.im?target=https%3A%2F%2Fwww.ssls.com%2F)来实操。

至于为什么选择它？

- 因为性价比高，价格可以，证书质量很高。
- 公司在用

就是这么任性的理由。好了，书归正传

国际惯例，注册登录 -> 选择CERTS，之后选择合适的商品，加入购物车，选择数量和有效时间

商品列表,界面做的还是很好看的 

![img](https://user-gold-cdn.xitu.io/2018/7/4/16463c44389db4dc?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

**下面重点来了，证书部署三步走**

1）按照提示，输入CSR。使用openssl生成

```
openssl req -new -newkey rsa:2048 -sha256 -nodes -out www.hashfish.net.csr -keyout www.hashfish.net.key -subj "/C=CN/ST=BeiJing/L=BeiJing/O=HASH FISH./OU=Web Security/CN=www.hashfish.net"
```

命令的含义 req——执行证书签发命令

-new——新证书签发请求

-out——输出的csr文件的路径

-keyout——指定私钥路径

-subj——证书相关的用户信息(subject的缩写)

直接使用是注意修改信息，别直接复制了

2）根据提示完成其他操作（填写接收证书邮箱等操作），order状态变为in progress，这时候需要你把验证文件放到制定的目录下，以完成ssls的验证

上图吧，直观一些

![img](https://user-gold-cdn.xitu.io/2018/7/4/16463fdac2b9b610?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

3）验证完成之后，若干时间后，你会收到以证书为附件的邮件，**合并证书（如果有多个的话，一定要保持证书链完整，避免有些情况下提示非安全链接）**，上传服务器，配置nginx 重启nginx，整个世界清净了。

**合并证书**

```
//合并证书的命令
//将证书和CA证书合并成pem
cat  www.hashfish.net.crt  www.hashfish.net.ca-bundle > www.hashfish.net.pem
复制代码
```

**配置nginx**

```
//在特定的域名中添加
listen 443;
ssl_certificate  【合并过后的.pem文件路径】
ssl_certificate_key  【openssl生成的私钥文件路径】
```

好了，https证书部署到此结束。上一张经典的图来描述一下https请求的过程

![img](https://user-gold-cdn.xitu.io/2018/7/5/16467c0ebbd89eff?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)