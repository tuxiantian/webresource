---
typora-root-url: ..\..
---

![](/images/java/httpput.jpg)
```java
@Test
public void updateCustomers(){
    String timestamp=""+System.currentTimeMillis()/1000;
    MapBean params=new MapBean("type","cellphone","content","18625356915",
            "email",email,"timestamp",timestamp,"sign",getSign(timestamp));
    Map body=new MapBean("customer",new MapBean("tags","已缴纳保证金","nick_name","高媛媛"));
    try {
        String json = HttpUtil.put(host.concat(updateCustomers), params,JsonUtil.toJson(body));
        System.out.println(JsonUtil.toObject(json,MapBean.class));
    } catch (Exception e) {
        e.printStackTrace();
    }
}

protected static String addParamsToUrl(String url, MapBean params) {
    if (url.indexOf("?") < 0)
        url += "?";
    List<NameValuePair> names = new LinkedList<>();
    if (params != null && params.size() > 0) {
        names.addAll(params.keySet().stream().map(name -> new BasicNameValuePair(name, params.getString(name))).collect(Collectors.toList()));
    }
    String paramString = URLEncodedUtils.format(names, "utf-8");
    url += paramString;
    return url;
}

public static String common(HttpUriRequest request){
    CloseableHttpClient httpclient = HttpClients.createDefault();
    StringBuffer log = new StringBuffer();
    ResponseHandler<String> responseHandler = response -> {
        int status = response.getStatusLine().getStatusCode();
        if (status >= 200 && status < 300) {
            HttpEntity entity = response.getEntity();
            return entity != null ? EntityUtils.toString(entity) : null;
        } else {
            throw new ClientProtocolException("Unexpected response status: " + status);
        }
    };
    String responseBody;
    try {
        responseBody = httpclient.execute(request, responseHandler);
        log.append("result: " + responseBody);
        logger.debug(log.toString() + "\r\n");
        logger.debug("----------------------------------------\r\n");
        return responseBody;
    } catch (IOException e) {
        logger.error("request url error", e);
    } finally {
        try {
            httpclient.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    return null;
}
public static String put(String url, MapBean params,String body) {
    HttpPut put=new HttpPut(addParamsToUrl(url, params));
    put.setEntity(new StringEntity(body, "UTF-8"));
    put.setHeader("Content-type", "application/json; charset=utf-8");
    return common(put);
}
```