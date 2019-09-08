引入加密jar

```xml
<dependency>    
    <groupId>bouncycastle</groupId>   
    <artifactId>bouncycastle-jce-jdk13</artifactId>    
    <version>112</version>
</dependency>
```

加密类

```java
import org.apache.commons.codec.binary.Base64;
import javax.crypto.Cipher;
import java.security.*;
import java.security.interfaces.RSAPublicKey;
public class RSAUtils {
    private static final KeyPair keyPair = initKey();
    private static KeyPair initKey() {
        try {
            Provider provider =new org.bouncycastle.jce.provider.BouncyCastleProvider();
            Security.addProvider(provider);
            SecureRandom random = new SecureRandom();
            KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA", provider);
            generator.initialize(1024,random);
            return generator.generateKeyPair();
        } catch(Exception e) {
            throw new RuntimeException(e);
        }
    }
    public static String generateBase64PublicKey() {
        PublicKey publicKey = (RSAPublicKey)keyPair.getPublic();
        return new String(Base64.encodeBase64(publicKey.getEncoded()));
    }
    public static String decryptBase64(String string) {
        return new String(decrypt(Base64.decodeBase64(string.getBytes())));
    }
    private static byte[] decrypt(byte[] byteArray) {
        try {
            Provider provider = new org.bouncycastle.jce.provider.BouncyCastleProvider();
            Security.addProvider(provider);
            Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding", provider);
            PrivateKey privateKey = keyPair.getPrivate();
            cipher.init(Cipher.DECRYPT_MODE, privateKey);
            byte[] plainText = cipher.doFinal(byteArray);
            return plainText;
        } catch(Exception e) {
            throw new RuntimeException(e);
        }
    }

}
```

提供获取公钥的接口

```java
@RequestMapping(value = "enc", method = RequestMethod.POST, headers = "Accept=application/json")
    @ResponseBody
    public String getKey(HttpServletRequest request){
        String publicKey = RSAUtils.generateBase64PublicKey();
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("publicKey",publicKey);
        return jsonObject.toJSONString();
    }
```

前端使用获取的公钥对参数进行加密

```js
$.post('enc',{},function(resp){
                    var encrypt = new JSEncrypt();
                    encrypt.setPublicKey(resp.publicKey);
                    var encUser=encrypt.encrypt($("#inputUserName").val());
                    var encPw=encrypt.encrypt($("#inputPassword").val());
                    $.post('login',{user:encUser,pw:encPw,certCode:$("#verificationCode").val()}).done(function(ret){
                        $.unblockUI();
                        console.log(ret);
                        if (ret.IS_SUCCESS=='false') {
                            me.loadCode();
                            fish.error(ret.ERROR_DESC);
                        } else {
                            var date = new Date();
                            date.setTime(date.getTime() + 1000 * 60 * 60 * 24 * 30);
                            if ($("#checkRememberMe").prop("checked")) {
                                fish.cookies.set("username", $("#inputUserName").val(), {expires: date});
                                fish.cookies.set("usercode", fish.Base64.encode($("#inputPassword").val()), {expires: date});
                            }
                            $.blockUI({message: '登录成功'});
                            if(location.hash&&location.hash!=''){
                                utils.redirect('./main.html'+location.hash);
                            }else{
                                utils.redirect();
                            }
                        }
                    }).fail(function(obj,type,msg){
                        $.unblockUI();
                        me.loadCode();
                        me.$("#verificationCode").val(""); // 重置验证码输入框

                    });
});
```

后端解密

```java
String decUser=RSAUtils.decryptBase64(user);
```

前端只有使用https才能保证真正的数据传输安全，否则就对密码采用MD5加密就好了。

fish框架进行MD5加密的方法是fish.MD5('你想加密的字符串')